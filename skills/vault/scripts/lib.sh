#!/usr/bin/env bash
# lib.sh — shared helpers for the `vault` CLI
# Sourced by scripts/vault. Not executable on its own.
#
# Design notes:
# - All secrets pass via stdin or env vars; never as command-line args.
# - `_ensure_unlocked` is idempotent and silent on success.
# - Three auth states recovered with increasing weight: unlocked → locked → unauthenticated.
# - Writes are audited (timestamps + action + ID/name) to $VAULT_AUDIT_LOG.

# === Configuration ===
# Per-machine config at ~/.config/vault-skill/config.sh is sourced first so it
# can set VAULT_BW_SERVER / VAULT_BW_EMAIL. Anything unset there falls through
# to defaults below or fails loudly via _require_config when required.
VAULT_CONFIG_FILE="${VAULT_CONFIG_FILE:-${XDG_CONFIG_HOME:-$HOME/.config}/vault-skill/config.sh}"
[[ -f "$VAULT_CONFIG_FILE" ]] && source "$VAULT_CONFIG_FILE"

: "${VAULT_BW_SERVER:=}"
: "${VAULT_BW_EMAIL:=}"
: "${VAULT_BW_SESSION_FILE:=${XDG_CACHE_HOME:-$HOME/.cache}/bw-session}"
: "${VAULT_AUDIT_LOG:=${XDG_CACHE_HOME:-$HOME/.cache}/vault-audit.log}"
# Keychain service names default to the server's host so multiple vaults on
# the same machine don't collide (e.g. vault.example.com vs vault.other.com).
_VAULT_HOST_DEFAULT="${VAULT_BW_SERVER#http*://}"
: "${VAULT_KEYCHAIN_MP_SERVICE:=${_VAULT_HOST_DEFAULT}}"
: "${VAULT_KEYCHAIN_API_SERVICE:=${_VAULT_HOST_DEFAULT}-apikey}"

# === Utilities ===
_err()  { printf '%s\n' "$*" >&2; }
_die()  { _err "$*"; exit 1; }

_audit_log() {
  mkdir -p "$(dirname "$VAULT_AUDIT_LOG")"
  printf '%s\t%s\t%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$1" "$2" >> "$VAULT_AUDIT_LOG"
}

_require_deps() {
  local missing=() dep
  for dep in bw jq security curl; do
    command -v "$dep" >/dev/null 2>&1 || missing+=("$dep")
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    _err "missing required commands: ${missing[*]}"
    _err "install with: brew install bitwarden-cli jq"
    return 1
  fi
}

_require_config() {
  [[ -n "$VAULT_BW_SERVER" ]] || { _err "VAULT_BW_SERVER not set. Run 'vault setup' or edit $VAULT_CONFIG_FILE"; return 1; }
  [[ -n "$VAULT_BW_EMAIL"  ]] || { _err "VAULT_BW_EMAIL not set. Run 'vault setup' or edit $VAULT_CONFIG_FILE";  return 1; }
}

# === Session cache ===
_load_session() {
  if [[ -r "$VAULT_BW_SESSION_FILE" ]]; then
    BW_SESSION="$(<"$VAULT_BW_SESSION_FILE")"
    export BW_SESSION
  fi
}

_save_session() {
  local token="$1"
  mkdir -p "$(dirname "$VAULT_BW_SESSION_FILE")"
  (umask 077; printf '%s' "$token" > "$VAULT_BW_SESSION_FILE")
  BW_SESSION="$token"
  export BW_SESSION
}

# === Keychain access ===
_keychain_get() {
  security find-generic-password -s "$1" -a "$VAULT_BW_EMAIL" -w 2>/dev/null
}

_keychain_master_password() { _keychain_get "$VAULT_KEYCHAIN_MP_SERVICE"; }
_keychain_api_key()         { _keychain_get "$VAULT_KEYCHAIN_API_SERVICE"; }

# === Auth recovery ===

# Unlock with master password from Keychain. Returns 0 on success.
_unlock_from_keychain() {
  local mp token
  mp=$(_keychain_master_password) || return 1
  [[ -n "$mp" ]] || return 1
  token=$(BW_MP_ENV="$mp" bw unlock --passwordenv BW_MP_ENV --raw 2>/dev/null) || { unset mp; return 1; }
  unset mp
  [[ -n "$token" ]] || return 1
  _save_session "$token"
}

# Login with API key from Keychain, then unlock. Returns 0 on success.
_login_from_keychain() {
  local api id secret
  api=$(_keychain_api_key) || return 1
  [[ "$api" == *:* ]] || { _err "API key in Keychain not in clientId:clientSecret format"; return 1; }
  id="${api%%:*}"
  secret="${api#*:}"
  BW_CLIENTID="$id" BW_CLIENTSECRET="$secret" bw login --apikey >/dev/null 2>&1 || return 1
  _unlock_from_keychain
}

# Main entrypoint for auth. Idempotent, silent on success.
_ensure_unlocked() {
  _require_config || return 1
  _load_session
  local state
  state=$(bw status 2>/dev/null | jq -r '.status' 2>/dev/null || echo "")
  case "$state" in
    unlocked)
      return 0 ;;
    locked|"")
      _unlock_from_keychain && return 0
      # Maybe session was stale and we're actually unauthenticated
      _login_from_keychain && return 0 ;;
    unauthenticated)
      _login_from_keychain && return 0 ;;
  esac
  _err "vault: unable to authenticate (state=$state). Run 'vault doctor'."
  return 1
}

# === Read commands ===

vault_get() {
  local name="" field="password"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --field) field="$2"; shift 2 ;;
      --field=*) field="${1#*=}"; shift ;;
      -*) _err "unknown flag: $1"; return 1 ;;
      *) name="$1"; shift ;;
    esac
  done
  [[ -n "$name" ]] || { _err "usage: vault get NAME [--field password|username|notes|totp|uri|custom:NAME]"; return 1; }
  _ensure_unlocked || return 1
  if [[ "$field" == custom:* ]]; then
    local fname="${field#custom:}" item result
    item=$(bw get item "$name") || return 1
    result=$(printf '%s\n' "$item" | jq -r --arg n "$fname" '
      (.fields // []) as $f
      | ($f | map(select(.name==$n)) | first) as $m
      | if $m == null then "__VAULT_MISSING__" else ($m.value // "") end
    ')
    if [[ "$result" == "__VAULT_MISSING__" ]]; then
      _err "custom field '$fname' not found on item '$name'"
      return 1
    fi
    printf '%s\n' "$result"
    return 0
  fi
  case "$field" in
    password|username|uri|totp|notes) bw get "$field" "$name" ;;
    *) _err "unknown field: $field (use 'custom:NAME' for custom fields)"; return 1 ;;
  esac
}

vault_list() {
  local search="" type=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --search)   search="$2"; shift 2 ;;
      --search=*) search="${1#*=}"; shift ;;
      --type)     type="$2"; shift 2 ;;
      --type=*)   type="${1#*=}"; shift ;;
      *) shift ;;
    esac
  done
  _ensure_unlocked || return 1
  local args=(list items) json
  [[ -n "$search" ]] && args+=(--search "$search")
  json=$(bw "${args[@]}")
  local type_num=""
  case "$type" in
    "")                  ;;
    login)               type_num=1 ;;
    note|secure-note)    type_num=2 ;;
    card)                type_num=3 ;;
    identity)            type_num=4 ;;
    *) _err "unknown type: $type"; return 1 ;;
  esac
  if [[ -n "$type_num" ]]; then
    printf '%s\n' "$json" | jq -r --argjson t "$type_num" '.[] | select(.type==$t) | [.id, .type, .name] | @tsv'
  else
    printf '%s\n' "$json" | jq -r '.[] | [.id, .type, .name] | @tsv'
  fi
}

vault_env() {
  local name="" mode="auto"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --notes-only) mode="notes"; shift ;;
      --fields-only) mode="fields"; shift ;;
      *) name="$1"; shift ;;
    esac
  done
  [[ -n "$name" ]] || { _err "usage: vault env NAME [--fields-only|--notes-only]"; return 1; }
  _ensure_unlocked || return 1
  bw sync >/dev/null 2>&1 || true
  local item field_count
  item=$(bw get item "$name") || return 1
  field_count=$(printf '%s\n' "$item" | jq '(.fields // []) | length')
  # Decide which source to use
  local use="notes"
  case "$mode" in
    fields) use="fields" ;;
    notes)  use="notes" ;;
    auto)   [[ "$field_count" -gt 0 ]] && use="fields" || use="notes" ;;
  esac
  if [[ "$use" == "fields" ]]; then
    # Emit shell-safe export lines; jq's @sh single-quotes and escapes embedded quotes
    printf '%s\n' "$item" | jq -r '.fields[] | "export \(.name)=\(.value | @sh)"'
  else
    # Legacy: raw notes body. User is responsible for shell-safety.
    printf '%s\n' "$item" | jq -r '.notes // ""'
  fi
}

# === Write commands ===

_create_login() {
  local name="$1"; shift
  local username="" url="" notes="" pw_mode=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --username) username="$2"; shift 2 ;;
      --url|--uri) url="$2"; shift 2 ;;
      --notes) notes="$2"; shift 2 ;;
      --password-from-stdin) pw_mode="stdin"; shift ;;
      --password-from-env)   pw_mode="env"; shift ;;
      *) _err "unknown flag for create login: $1"; return 1 ;;
    esac
  done
  local secret=""
  case "$pw_mode" in
    stdin) secret=$(cat); secret="${secret%$'\n'}" ;;
    env)   secret="${VAULT_PASSWORD:?VAULT_PASSWORD env required for --password-from-env}" ;;
  esac
  _ensure_unlocked || return 1
  local id
  id=$(jq -n \
        --arg name "$name" \
        --arg user "$username" \
        --arg pw   "$secret" \
        --arg url  "$url" \
        --arg notes "$notes" \
        '{
          type: 1,
          name: $name,
          notes: (if $notes=="" then null else $notes end),
          login: {
            username: (if $user=="" then null else $user end),
            password: (if $pw=="" then null else $pw end),
            uris: (if $url=="" then [] else [{uri:$url, match:null}] end)
          }
        }' | bw encode | bw create item | jq -r '.id')
  unset secret
  [[ -n "$id" && "$id" != "null" ]] || { _err "create login failed"; return 1; }
  _audit_log create_login "$id ${name}"
  printf '%s\n' "$id"
}

_create_note() {
  local name="$1"; shift
  local mode=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --from-stdin) mode="stdin"; shift ;;
      --from-env)   mode="env"; shift ;;
      *) _err "unknown flag for create note: $1"; return 1 ;;
    esac
  done
  local content=""
  case "$mode" in
    stdin) content=$(cat) ;;
    env)   content="${VAULT_NOTES:?VAULT_NOTES env required for --from-env}" ;;
  esac
  _ensure_unlocked || return 1
  local id
  id=$(jq -n --arg name "$name" --arg notes "$content" \
        '{type: 2, name: $name, notes: $notes, secureNote: {type: 0}}' \
        | bw encode | bw create item | jq -r '.id')
  unset content
  [[ -n "$id" && "$id" != "null" ]] || { _err "create note failed"; return 1; }
  _audit_log create_note "$id ${name}"
  printf '%s\n' "$id"
}

vault_create() {
  local type="${1:-}" name="${2:-}"
  [[ -n "$type" && -n "$name" ]] || { _err "usage: vault create login|note NAME [options]"; return 1; }
  shift 2
  case "$type" in
    login)             _create_login "$name" "$@" ;;
    note|secure-note)  _create_note  "$name" "$@" ;;
    *) _err "unsupported type: $type (login|note)"; return 1 ;;
  esac
}

# Resolve a name or UUID to a single item ID. Errors on ambiguity.
_resolve_item_id() {
  local q="$1"
  if [[ "$q" =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]; then
    printf '%s\n' "$q"
    return 0
  fi
  local ids
  ids=$(bw list items --search "$q" | jq -r --arg n "$q" '[.[] | select(.name==$n) | .id] | .[]')
  local count
  count=$(printf '%s\n' "$ids" | grep -c '.' || true)
  if [[ "$count" == "1" ]]; then
    printf '%s\n' "$ids"
  elif [[ "$count" == "0" ]]; then
    _err "no item with exact name: $q"
    return 1
  else
    _err "multiple items named '$q' — pass the UUID instead. IDs:"
    printf '%s\n' "$ids" >&2
    return 1
  fi
}

vault_update() {
  local target="${1:-}"; shift 2>/dev/null
  [[ -n "$target" ]] || { _err "usage: vault update ID-OR-NAME --field FIELD --value V|--value-from-stdin|--value-from-env"; return 1; }
  local field="" value="" mode="literal"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --field)            field="$2"; shift 2 ;;
      --value)            value="$2"; mode="literal"; shift 2 ;;
      --value-from-stdin) mode="stdin"; shift ;;
      --value-from-env)   mode="env"; shift ;;
      *) _err "unknown flag: $1"; return 1 ;;
    esac
  done
  [[ -n "$field" ]] || { _err "--field is required"; return 1; }
  case "$mode" in
    stdin) value=$(cat); value="${value%$'\n'}" ;;
    env)   value="${VAULT_VALUE:?VAULT_VALUE env required for --value-from-env}" ;;
  esac
  _ensure_unlocked || return 1
  local id
  id=$(_resolve_item_id "$target") || return 1
  local item filter
  item=$(bw get item "$id")
  case "$field" in
    password)  filter='.login.password = $v' ;;
    username)  filter='.login.username = $v' ;;
    uri|url)   filter='.login.uris = [{uri: $v, match: null}]' ;;
    notes)     filter='.notes = $v' ;;
    name)      filter='.name = $v' ;;
    *) _err "unknown field: $field (password|username|uri|notes|name)"; return 1 ;;
  esac
  printf '%s\n' "$item" | jq --arg v "$value" "$filter" | bw encode | bw edit item "$id" >/dev/null
  unset value
  _audit_log "update_${field}" "$id"
  printf 'updated %s .%s\n' "$id" "$field"
}

vault_delete() {
  local target="${1:-}"
  [[ -n "$target" ]] || { _err "usage: vault delete ID-OR-NAME"; return 1; }
  _ensure_unlocked || return 1
  local id
  id=$(_resolve_item_id "$target") || return 1
  bw delete item "$id" || return 1
  _audit_log delete "$id ${target}"
  printf 'deleted %s\n' "$id"
}

# Add or update a custom field on an item.
# Field type: hidden (default, masked), text, or boolean.
vault_set_field() {
  local target="${1:-}" fieldname="${2:-}"
  [[ -n "$target" && -n "$fieldname" ]] || { _err "usage: vault set-field ITEM FIELDNAME (--value V | --value-from-stdin | --value-from-env) [--type hidden|text|boolean]"; return 1; }
  shift 2
  local mode="literal" value="" type_str="hidden" type_num=1
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --value)            value="$2"; mode=literal; shift 2 ;;
      --value-from-stdin) mode=stdin; shift ;;
      --value-from-env)   mode=env; shift ;;
      --type)             type_str="$2"; shift 2 ;;
      --type=*)           type_str="${1#*=}"; shift ;;
      *) _err "unknown flag: $1"; return 1 ;;
    esac
  done
  case "$type_str" in
    text)    type_num=0 ;;
    hidden)  type_num=1 ;;
    boolean) type_num=2 ;;
    *) _err "unknown --type: $type_str (text|hidden|boolean)"; return 1 ;;
  esac
  case "$mode" in
    stdin) value=$(cat); value="${value%$'\n'}" ;;
    env)   value="${VAULT_VALUE:?VAULT_VALUE env required for --value-from-env}" ;;
  esac
  _ensure_unlocked || return 1
  bw sync >/dev/null 2>&1 || true
  local id item
  id=$(_resolve_item_id "$target") || return 1
  item=$(bw get item "$id")
  if ! printf '%s\n' "$item" | jq \
        --arg name "$fieldname" \
        --arg val  "$value" \
        --argjson type "$type_num" \
        '
        .fields = (
          (.fields // [])
          | map(select(.name != $name))
          | . + [{name: $name, value: $val, type: $type, linkedId: null}]
        )
        ' | bw encode | bw edit item "$id" >/dev/null; then
    unset value
    _err "set-field failed (server rejected edit — try 'bw sync' or re-fetch the item)"
    return 1
  fi
  unset value
  _audit_log "set_field:${fieldname}" "$id"
  printf 'set field %s on %s\n' "$fieldname" "$id"
}

vault_delete_field() {
  local target="${1:-}" fieldname="${2:-}"
  [[ -n "$target" && -n "$fieldname" ]] || { _err "usage: vault delete-field ITEM FIELDNAME"; return 1; }
  _ensure_unlocked || return 1
  bw sync >/dev/null 2>&1 || true
  local id item
  id=$(_resolve_item_id "$target") || return 1
  item=$(bw get item "$id")
  local has_field
  has_field=$(printf '%s\n' "$item" | jq --arg n "$fieldname" '[.fields[]? | select(.name==$n)] | length')
  if [[ "$has_field" -eq 0 ]]; then
    _err "field '$fieldname' not found on '$target'"
    return 1
  fi
  if ! printf '%s\n' "$item" | jq --arg name "$fieldname" \
        '.fields = ((.fields // []) | map(select(.name != $name)))' \
        | bw encode | bw edit item "$id" >/dev/null; then
    _err "delete-field failed (server rejected edit — try 'bw sync')"
    return 1
  fi
  _audit_log "delete_field:${fieldname}" "$id"
  printf 'deleted field %s from %s\n' "$fieldname" "$id"
}

vault_list_fields() {
  local target="${1:-}"
  [[ -n "$target" ]] || { _err "usage: vault list-fields ITEM"; return 1; }
  _ensure_unlocked || return 1
  local id item
  id=$(_resolve_item_id "$target") || return 1
  item=$(bw get item "$id")
  printf '%s\n' "$item" | jq -r '
    (.fields // []) as $f
    | if ($f | length) == 0 then "no custom fields"
      else $f[] | "\(.type | if . == 0 then "text" elif . == 1 then "hidden" elif . == 2 then "bool" else "?" end)\t\(.name)"
      end
  '
}

# === Maintenance ===

vault_sync() {
  _ensure_unlocked || return 1
  bw sync
}

vault_status() {
  _load_session
  bw status | jq '{status, serverUrl, userEmail, lastSync}'
}

vault_setup() {
  printf 'Running setup verification...\n\n'
  if [[ ! -f "$VAULT_CONFIG_FILE" ]]; then
    printf 'No config file found at %s\n\n' "$VAULT_CONFIG_FILE"
    printf 'Run the installer to bootstrap config, then come back:\n'
    printf '   scripts/install-vault.sh\n\n'
    printf 'Or write it manually:\n'
    printf '   mkdir -p "$(dirname "%s")"\n' "$VAULT_CONFIG_FILE"
    printf '   cat > "%s" <<EOF\n' "$VAULT_CONFIG_FILE"
    printf '   export VAULT_BW_SERVER="https://your-vault.example.com"\n'
    printf '   export VAULT_BW_EMAIL="you@example.com"\n'
    printf '   EOF\n\n'
    return 1
  fi
  vault_doctor
}

vault_doctor() {
  local ok=true

  printf '%-40s' "0. config file"
  if [[ -f "$VAULT_CONFIG_FILE" ]]; then
    printf 'OK (%s)\n' "$VAULT_CONFIG_FILE"
  else
    printf 'MISSING — run scripts/install-vault.sh\n'
    ok=false
  fi

  printf '%-40s' "1. bw CLI installed"
  if command -v bw >/dev/null 2>&1; then
    printf 'OK (%s)\n' "$(bw --version 2>/dev/null | tail -1)"
  else
    printf 'FAIL — install with: brew install bitwarden-cli\n'
    ok=false
  fi

  printf '%-40s' "2. jq installed"
  if command -v jq >/dev/null 2>&1; then printf 'OK\n'; else printf 'FAIL — brew install jq\n'; ok=false; fi

  printf '%-40s' "3. server config matches"
  local cfg_server
  cfg_server=$(bw status 2>/dev/null | jq -r '.serverUrl // ""' 2>/dev/null || echo "")
  if [[ "$cfg_server" == "$VAULT_BW_SERVER" ]]; then
    printf 'OK (%s)\n' "$cfg_server"
  else
    printf 'WARN — expected %s, got %s\n' "$VAULT_BW_SERVER" "$cfg_server"
  fi

  printf '%-40s' "4. server reachable"
  if curl -sf --max-time 5 -o /dev/null "$VAULT_BW_SERVER/api/config"; then
    printf 'OK\n'
  else
    printf 'FAIL — cannot reach %s\n' "$VAULT_BW_SERVER"
    ok=false
  fi

  printf '%-40s' "5. Keychain: master password"
  if _keychain_master_password >/dev/null; then
    printf 'OK\n'
  else
    printf 'MISSING — add it:\n   security add-generic-password -s %s -a %s -w\n' "$VAULT_KEYCHAIN_MP_SERVICE" "$VAULT_BW_EMAIL"
    ok=false
  fi

  printf '%-40s' "6. Keychain: API key"
  if _keychain_api_key >/dev/null; then
    printf 'OK\n'
  else
    printf "MISSING — add it (format clientId:clientSecret):\n   security add-generic-password -s %s -a %s -w '<clientId>:<clientSecret>'\n" "$VAULT_KEYCHAIN_API_SERVICE" "$VAULT_BW_EMAIL"
    ok=false
  fi

  printf '%-40s' "7. cached session file"
  if [[ -r "$VAULT_BW_SESSION_FILE" ]]; then
    printf 'present (%s)\n' "$VAULT_BW_SESSION_FILE"
  else
    printf 'none yet — will be created on first call\n'
  fi

  printf '%-40s' "8. vault state"
  _load_session
  local state
  state=$(bw status 2>/dev/null | jq -r '.status' 2>/dev/null || echo "?")
  case "$state" in
    unlocked) printf 'OK (unlocked)\n' ;;
    locked)
      printf 'locked — attempting unlock from Keychain...\n'
      if _unlock_from_keychain; then printf '   -> unlocked OK\n'; else printf '   -> FAIL\n'; ok=false; fi ;;
    unauthenticated)
      printf 'logged out — attempting re-login from Keychain...\n'
      if _login_from_keychain; then printf '   -> logged in + unlocked OK\n'; else printf '   -> FAIL\n'; ok=false; fi ;;
    *) printf 'unknown state: %s\n' "$state"; ok=false ;;
  esac

  echo
  if $ok; then
    echo "All checks passed. Vault is ready for autonomous CRUD."
  else
    echo "One or more checks failed. See messages above."
    return 1
  fi
}

vault_help() {
  cat <<'EOF'
vault — autonomous CRUD wrapper for your self-hosted Vaultwarden vault

Usage: vault <command> [args...]

Read:
  get NAME [--field FIELD]            Fetch a field. FIELD: password (default),
                                       username, notes, totp, uri, custom:NAME
  list [--search Q] [--type TYPE]     List items. TYPE: login|note|card|identity
  list-fields ITEM                    List custom fields on an item (type, name)
  env NAME [--fields-only|--notes-only]
                                       Emit env vars. Default: use custom fields
                                       if present, else fall back to KEY=value
                                       parsed from notes (legacy).

Write (secrets pass via stdin or env; never as args):
  create login NAME [--username U] [--url URL] [--notes N]
                    [--password-from-stdin | --password-from-env]
  create note NAME  [--from-stdin | --from-env]
  update ID-OR-NAME --field FIELD (--value V | --value-from-stdin | --value-from-env)
                                       FIELD: password|username|uri|notes|name
  set-field ITEM FIELDNAME (--value V | --value-from-stdin | --value-from-env)
                           [--type hidden|text|boolean]
                                       Add/update a custom field. Default type
                                       is 'hidden' (masked in UI).
  delete-field ITEM FIELDNAME          Remove a custom field
  delete ID-OR-NAME                    Delete entire item

Maintenance:
  sync                                Force resync from server
  status                              Show auth state, server, user, last sync
  setup                               Run all doctor checks (one-time post-install)
  doctor                              Diagnose auth + connectivity problems
  help                                Show this message

Configuration:
  Per-machine config at ~/.config/vault-skill/config.sh:
    export VAULT_BW_SERVER="https://your-vault.example.com"
    export VAULT_BW_EMAIL="you@example.com"

Env vars (override defaults):
  VAULT_BW_SERVER             required — your Bitwarden/Vaultwarden server URL
  VAULT_BW_EMAIL              required — account email
  VAULT_BW_SESSION_FILE       default: ~/.cache/bw-session
  VAULT_AUDIT_LOG             default: ~/.cache/vault-audit.log
  VAULT_KEYCHAIN_MP_SERVICE   default: <host part of VAULT_BW_SERVER>
  VAULT_KEYCHAIN_API_SERVICE  default: <host>-apikey
  VAULT_PASSWORD              consumed by --password-from-env / --value-from-env
  VAULT_NOTES                 consumed by create note --from-env
  VAULT_VALUE                 consumed by update / set-field --value-from-env

Conventions (also documented in SKILL.md):
  - One Login item per service (GitHub, OpenAI, Stripe...). Use `password` field.
  - One Note item per env context (project, environment), with Hidden custom
    fields for each variable. Notes body holds documentation only.
  - Do NOT create new items in legacy KEY=value-in-notes form. Old items still
    work via `vault env` (auto-detection), but new ones should use fields.

Examples:
  # Read
  vault get "OpenAI API Key"
  vault get "GitHub" --field username
  vault get "myproject-env" --field custom:DATABASE_URL

  # Write
  printf 'sk-...' | vault create login "OpenAI Personal" \
    --username me@example.com --password-from-stdin
  printf 'sk-...' | vault set-field "myproject-env" OPENAI_API_KEY \
    --value-from-stdin
  vault delete-field "myproject-env" OLD_KEY

  # Bulk env load
  eval "$(vault env myproject-env)"
EOF
}
