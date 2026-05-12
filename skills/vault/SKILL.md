---
name: vault
version: 1.0.0
description: Read and write credentials, API keys, passwords, secrets, env vars, and tokens in the user's self-hosted Bitwarden / Vaultwarden via the `vault` CLI. Use whenever you need to fetch a secret to use in code or shell, store something the user just generated, rotate an existing credential, or load a project's env vars. Handles session refresh and re-login automatically — never prompt the user for the master password.
---

<objective>
Provide autonomous CRUD access to the user's self-hosted Bitwarden/Vaultwarden credentials.
The `vault` CLI wraps `bw` with session caching, silent re-unlock from macOS Keychain,
and silent re-login via API key — so a credential fetch always "just works" without
user interaction.
</objective>

<when_to_use>
**Use this skill when:**
- You need an API key, password, or token that belongs to the user (OpenAI, GitHub, AWS, etc.)
- The user asks "save / store / put this in my vault"
- The user wants you to generate-then-store a new password or token
- You're about to suggest the user paste a credential — fetch it from the vault instead
- A script needs env vars that live in a Secure Note (use `vault env NAME`)
- The user mentions vault, Bitwarden, Vaultwarden, "my credentials", "my secrets"
- You generated a new secret and want it preserved across sessions

**Don't use this skill when:**
- The user is sharing a credential **as input** for the current task only (no need to write it back)
- You're working with project-local `.env` files unrelated to the user's vault
- You need a build-time secret that already lives in CI/CD env (those have their own paths)
</when_to_use>

<quick_start>
The CLI lives at `~/.claude/skills/vault/scripts/vault`. Always invoke via absolute path or full Bash command — do NOT assume it's on PATH unless the user has added it.

**Read a credential** (returns to stdout, captureable):

```bash
~/.claude/skills/vault/scripts/vault get "OpenAI API Key"
```

**Capture into a variable** in shell:

```bash
OPENAI_API_KEY=$(~/.claude/skills/vault/scripts/vault get "OpenAI API Key")
```

**Write a new credential** — secret passes via stdin, never as an argument:

```bash
printf 'sk-...' | ~/.claude/skills/vault/scripts/vault create login "Anthropic Personal Key" \
  --username me@example.com --url https://console.anthropic.com --password-from-stdin
```

**Update a credential** — same pattern:

```bash
printf 'new-rotated-value' | ~/.claude/skills/vault/scripts/vault update "GitHub Token" \
  --field password --value-from-stdin
```

**Load all KEY=value lines from a Secure Note into the current shell:**

```bash
eval "$(~/.claude/skills/vault/scripts/vault env dev-env-personal)"
```

If anything errors with auth, run `vault doctor` to diagnose.
</quick_start>

<commands>
| Command | Purpose |
|---------|---------|
| `vault get NAME [--field F]` | Fetch field. F: password, username, notes, totp, uri, **`custom:VARNAME`** |
| `vault list [--search Q] [--type T]` | List items (TSV: id, type, name) |
| `vault list-fields ITEM` | List custom fields on an item (type, name) |
| `vault env NAME [--fields-only \| --notes-only]` | Emit env vars. Auto-prefers custom fields, falls back to KEY=value in notes |
| `vault create login NAME [opts]` | Create Login item — `--password-from-stdin` / `--password-from-env` |
| `vault create note NAME [opts]` | Create Secure Note — `--from-stdin` / `--from-env` |
| `vault set-field ITEM FIELDNAME ...` | **Add/update a custom field** (default type: hidden) |
| `vault delete-field ITEM FIELDNAME` | Remove a custom field |
| `vault update ID-OR-NAME --field F ...` | Update standard field (password/username/uri/notes/name) |
| `vault delete ID-OR-NAME` | Delete an item |
| `vault sync` / `status` / `setup` / `doctor` / `help` | Maintenance |

**Item types**: 1=login, 2=secure-note, 3=card, 4=identity.

**Resolving items by name**: `vault update`, `vault set-field`, `vault delete-field`, `vault delete` accept either a UUID or an exact item name. Ambiguous names error with a list of matching IDs — re-run with the UUID.
</commands>

<conventions>
**Convention over configuration — apply these when creating new secrets.**

### Decision tree

```
Is this credential for a specific external service (one login or one API)?
├── YES → Create a Login item, one per service.
│         vault create login "Service Name" --username U --url U --password-from-stdin
│         Fetch via: vault get "Service Name"
│
└── NO, it's a variable that belongs to a project/environment context
    └── Add it as a Hidden custom field on the appropriate "context" item.
        First time: vault create note "<project>-env" --from-stdin <<< ""
        Then:        vault set-field "<project>-env" VAR_NAME --value-from-stdin
        Bulk load:   eval "$(vault env <project>-env)"
```

### Rules

1. **Per-service credentials → Login item (one each).**
   - Example: `OpenAI API Key`, `GitHub Token`, `Stripe Live Key`.
   - The secret lives in the Login's `password` field.
   - Bonus: per-item revision history, browser/mobile copy buttons, web vault search.

2. **Per-context env vars → Note item with Hidden custom fields.**
   - Example: `dev-env-personal` (variables you load into local dev shells).
   - Each variable is a **Hidden** custom field (`--type hidden`, default).
   - The Notes body holds documentation (purpose, owner, rotation policy) — **not** raw KEY=value lines.
   - Load all at once with `eval "$(vault env dev-env-personal)"`.

3. **Never go back to KEY=value-in-notes for new items.**
   - The skill still reads legacy notes (auto-detection in `vault env`), but every new variable should be a custom field.
   - When you touch a legacy item, migrate it: pull lines from notes → `vault set-field` → clear or doc-ify the notes body.

4. **Field names are SHELL_STYLE_UPPERCASE for env vars.**
   - This matches the standard env-var convention and ensures `eval "$(vault env ...)"` produces valid identifiers.
   - For service-credential items (Login), the item NAME is human-readable ("OpenAI API Key"), not snake_case.

5. **Default new custom fields to Hidden.**
   - Use `--type text` only for clearly non-sensitive metadata (regions, hostnames, account IDs that aren't secret).
   - When in doubt, hidden.

6. **Don't write secrets as command-line arguments.**
   - Always pipe via `--value-from-stdin` or use `--value-from-env` with `VAULT_VALUE`.
   - Arguments are visible in `ps`; stdin and env vars are not (in normal conditions).

### Quick-pick examples

```bash
# A new service credential
echo "ghp_..." | vault create login "GitHub Personal Token" \
  --username arda --url https://github.com --password-from-stdin

# Add an env var to a project context
echo "sk-..." | vault set-field "myproject-env" OPENAI_API_KEY --value-from-stdin

# Add a non-secret to a context (region label)
vault set-field "myproject-env" AWS_REGION --value us-east-1 --type text

# Load context vars into a shell
eval "$(vault env myproject-env)"

# Read a single field
KEY=$(vault get "myproject-env" --field custom:OPENAI_API_KEY)
```
</conventions>

<safety_rules>
- **Never echo a fetched secret to the conversation.** Use `$(vault get ...)` to capture into a shell variable; use the variable in subsequent commands; let the secret stay out of the chat log.
- **Always pass secrets via stdin or env vars to write commands.** `--password-from-stdin` and `--password-from-env` exist for this. Never use a positional argument for a secret — it would appear in `ps`.
- **Don't add or modify any plumbing without asking.** The user's session cache, Keychain entries, and audit log are already configured. Don't move them.
- **Audit log gets every write.** `~/.cache/vault-audit.log` records `timestamp \t action \t id name`. If you need to verify "did I just save this", check that file.
- **If auth fails after one retry, stop and tell the user.** Don't loop or prompt — `vault doctor` should be enough to identify what's wrong.
</safety_rules>

<auth_recovery_model>
The CLI handles auth transparently. For your awareness when debugging:

1. **Cached session valid** (most calls) → uses `~/.cache/bw-session`, instant.
2. **Session locked** → fetches master password from macOS Keychain (service name = the host part of `VAULT_BW_SERVER`), runs `bw unlock`, caches new session.
3. **Logged out** → fetches API key from Keychain (service name = `<host>-apikey`), runs `bw login --apikey`, then step 2.
4. **All three fail** → returns non-zero with "Run 'vault doctor'." User must intervene (Keychain entries missing or master password rotated).

If `vault doctor` is needed, it walks all 8 checks and prints exactly what to fix.
</auth_recovery_model>

<setup_status>
One-time setup is described in `README.md` next to this file. The user has likely already done it; if `vault doctor` reports MISSING for the Keychain entries, point them at README.md step-by-step. Do not try to write Keychain entries on the user's behalf — `security add-generic-password -w` (no value) is intentional; it prompts the user securely for the secret.
</setup_status>

<examples>
**Fetching to use in a curl call:**
```bash
TOKEN=$(~/.claude/skills/vault/scripts/vault get "GitHub Token")
curl -H "Authorization: Bearer $TOKEN" https://api.github.com/user
```

**Rotating a token you just generated:**
```bash
NEW=$(openssl rand -hex 32)
printf '%s' "$NEW" | ~/.claude/skills/vault/scripts/vault update "Internal Service Token" \
  --field password --value-from-stdin
# Then update the consuming service with $NEW; unset NEW when done
unset NEW
```

**Adding a new credential the user mentions:**
```bash
# User says: "save this Stripe key for me: sk_live_..."
printf 'sk_live_...' | ~/.claude/skills/vault/scripts/vault create login "Stripe Live Key" \
  --username me@example.com --url https://dashboard.stripe.com --password-from-stdin
```

**Loading a project's env vars before running a command:**
```bash
eval "$(~/.claude/skills/vault/scripts/vault env myproject-env)"
node ./scripts/something.js
```
</examples>

<success_criteria>
The skill is working correctly when:
- `vault get NAME` returns a secret to stdout in under 1 second on the warm path
- A locked or logged-out vault recovers silently within ~2 seconds
- Writes appear in `~/.cache/vault-audit.log` with timestamp
- `vault doctor` shows all 8 checks green
- The user never sees a master-password prompt during normal Claude operations
</success_criteria>
