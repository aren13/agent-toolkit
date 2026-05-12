# bw-secrets.zsh — Bitwarden-backed dev-env helper for zsh
#
# Stores a session token in $BW_SESSION_FILE (chmod 600) so you don't
# re-enter your master password in every shell. Trade-off: anyone with
# read access to that file can act as you against the vault until you
# run `devenv-lock`. Acceptable for a single-user laptop; if you want
# tighter security, replace the file cache with macOS Keychain.
#
# Commands:
#   devenv         Fetch the dev-env Secure Note and export its KEY=value lines
#   devenv-edit    Edit the note in $EDITOR and push the result back
#   devenv-lock    Lock the vault and clear the cached session
#   bw-get NAME    Print one password by item name (handy for piping)
#
# Setup:
#   1) brew install bitwarden-cli
#   2) bw config server https://your-self-hosted.example.com
#   3) bw login
#   4) Create a Secure Note named "dev-env-personal" with KEY=value lines
#   5) source ~/.config/bw-secrets.zsh  (add to ~/.zshrc)

: "${BW_SESSION_FILE:=${XDG_CACHE_HOME:-$HOME/.cache}/bw-session}"
: "${BW_DEV_ENV_ITEM:=dev-env-personal}"

_bw_load_session() {
  [[ -r "$BW_SESSION_FILE" ]] && export BW_SESSION="$(<"$BW_SESSION_FILE")"
}

_bw_ensure_unlocked() {
  command -v bw >/dev/null || { print -P "%F{red}bw CLI not installed%f"; return 1; }
  command -v jq >/dev/null || { print -P "%F{red}jq not installed%f"; return 1; }
  _bw_load_session
  local _bw_status
  _bw_status=$(bw status 2>/dev/null | jq -r '.status' 2>/dev/null)
  case "$_bw_status" in
    unlocked) return 0 ;;
    locked|"")
      print -P "%F{yellow}Unlocking Bitwarden...%f"
      local token
      token=$(bw unlock --raw) || return 1
      mkdir -p "$(dirname "$BW_SESSION_FILE")"
      (umask 077; print -r -- "$token" >| "$BW_SESSION_FILE")
      export BW_SESSION="$token"
      ;;
    unauthenticated)
      print -P "%F{red}Not logged in. Run: bw login%f"
      return 1
      ;;
  esac
}

devenv() {
  _bw_ensure_unlocked || return 1
  bw sync >/dev/null 2>&1
  local content
  content=$(bw get notes "${1:-$BW_DEV_ENV_ITEM}" 2>/dev/null) || {
    print -P "%F{red}Could not fetch note: ${1:-$BW_DEV_ENV_ITEM}%f"
    return 1
  }
  local count=0 line
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]] || continue
    export "$line"
    ((count++))
  done <<< "$content"
  print -P "%F{green}Loaded $count vars from '${1:-$BW_DEV_ENV_ITEM}'%f"
}

devenv-edit() {
  _bw_ensure_unlocked || return 1
  bw sync >/dev/null 2>&1
  local item_name="${1:-$BW_DEV_ENV_ITEM}"
  local item_json item_id tmpfile
  item_json=$(bw get item "$item_name" 2>/dev/null) || {
    print -P "%F{red}Item not found: $item_name%f"
    return 1
  }
  item_id=$(jq -r '.id' <<< "$item_json")
  tmpfile=$(mktemp -t bw-devenv.XXXXXX) || return 1
  jq -r '.notes // ""' <<< "$item_json" > "$tmpfile"
  "${EDITOR:-vi}" "$tmpfile"
  jq --rawfile notes "$tmpfile" '.notes = $notes' <<< "$item_json" \
    | bw encode \
    | bw edit item "$item_id" >/dev/null \
    && print -P "%F{green}Saved '$item_name' to Bitwarden%f" \
    || print -P "%F{red}Save failed%f"
  rm -f "$tmpfile"
}

devenv-lock() {
  bw lock >/dev/null 2>&1
  rm -f "$BW_SESSION_FILE"
  unset BW_SESSION
  print -P "%F{yellow}Vault locked%f"
}

bw-get() {
  _bw_ensure_unlocked || return 1
  bw get password "$1"
}
