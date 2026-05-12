# vault skill — per-machine setup

This skill lets Claude read and write credentials in your self-hosted Bitwarden / Vaultwarden without ever asking you for the master password during normal use.

To make that possible, **you** need to put two secrets in your macOS Keychain. After that, Claude can recover from a locked vault or a logged-out session entirely on its own.

You only do these steps once per machine.

> The repo's `scripts/install-vault.sh` automates most of this. The steps below describe what it does and how to do it by hand if you'd rather.

---

## Prerequisites

```bash
brew install bitwarden-cli jq
bw config server "$VAULT_BW_SERVER"     # e.g. https://vault.example.com
bw login
bw status | jq -r '.serverUrl, .userEmail, .status'
```

Set `VAULT_BW_SERVER` to your server URL (your self-hosted Bitwarden or Vaultwarden) and `VAULT_BW_EMAIL` to your account email. These two values get written to `~/.config/vault-skill/config.sh` by the installer.

---

## Step 1: Store your master password in Keychain

Run this command (replace `<VAULT_HOST>` with the host part of your server URL — e.g. `vault.example.com`, no `https://`):

```bash
security add-generic-password -s <VAULT_HOST> -a <YOUR_EMAIL> -w
```

macOS prompts you with a hidden input field — paste your Bitwarden master password and press Enter.

Verify (prints your master password — macOS may ask to allow access; pick "Always Allow"):

```bash
security find-generic-password -s <VAULT_HOST> -a <YOUR_EMAIL> -w
```

---

## Step 2: Get your Bitwarden personal API key

1. Open your vault in a browser, log in.
2. Top-right user icon → **Account Settings** → **Security** → **Keys** tab.
3. Click **View API Key**, re-enter your master password to reveal.
4. Copy both `client_id` and `client_secret`. Keep the tab open.

---

## Step 3: Store the API key in Keychain

```bash
security add-generic-password -s <VAULT_HOST>-apikey -a <YOUR_EMAIL> \
  -w 'user.abc123...:xyz789...'
```

Replace the quoted value with `<client_id>:<client_secret>` (literal colon between them).

Verify:

```bash
security find-generic-password -s <VAULT_HOST>-apikey -a <YOUR_EMAIL> -w
```

---

## Step 4: Verify

```bash
~/.claude/skills/vault/scripts/vault setup
```

You should see all checks ending with **"All checks passed. Vault is ready for autonomous CRUD."**

If any check is MISSING or FAIL, the output tells you the exact command to fix it.

---

## Optional: add `vault` to PATH

The installer adds this to `~/.zshrc`:

```zsh
export PATH="$HOME/.claude/skills/vault/scripts:$PATH"
```

Skip it (or remove it) if you don't want `vault` callable as a bare command from your terminal — Claude will still use the absolute path internally.

---

## How autonomous recovery works (trust model)

When Claude calls `vault get "Some Name"`:

1. The script loads the cached session token from `~/.cache/bw-session` (chmod 600).
2. It asks `bw status`:
   - `unlocked` → fetches the secret, done.
   - `locked` → reads master password from Keychain, runs `bw unlock`, caches the new session, then fetches.
   - `unauthenticated` → reads API key from Keychain, runs `bw login --apikey`, then unlocks, then fetches.
3. If any of the above fails, the call exits non-zero and tells you to run `vault doctor`.

Writes also log to `~/.cache/vault-audit.log` (timestamp + action + item id/name; never the value).

## Security model

| Location | Holds | Protected by |
|---|---|---|
| `~/.cache/bw-session` | Decryption session token | `chmod 600` (your user only) |
| macOS Keychain `<host>` | Master password | Encrypted by macOS, tied to login session |
| macOS Keychain `<host>-apikey` | API client_id:client_secret | Same |

If your laptop is unlocked, anything running as your user can read all three — same trust level as your browser-extension password manager being unlocked while you're signed in. This is the intended model for autonomous-Claude-on-your-Mac.

## Rotating things later

- **Master password rotated:**
  ```bash
  security delete-generic-password -s <VAULT_HOST> -a <YOUR_EMAIL> 2>/dev/null
  security add-generic-password   -s <VAULT_HOST> -a <YOUR_EMAIL> -w
  ```
- **API key revoked / regenerated:** same flow with `<VAULT_HOST>-apikey`.
- **Lost session:** just rerun any `vault` command; it self-heals.

## Troubleshooting

- `vault doctor` first — it walks every check and tells you what to fix.
- `~/.cache/vault-audit.log` shows the history of writes.
- bw stderr goes through naturally; pipe `2>&1 | less` if something is odd.

## Bootstrap-loop caveat

Storing your master password and API key inside the same vault they unlock doesn't help recovery — if Keychain dies, you can't read the vault to get them back. They live in **Keychain** for fast access, and need a separate offline backup (paper, a different password manager, emergency-kit PDF) for true recovery.
