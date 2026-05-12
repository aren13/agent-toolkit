# Agent Toolkit

A collection of scripts and utilities for setting up and managing infrastructure used by AI agents and home lab environments. These tools automate server provisioning, system hardening, and always-on configurations so machines are ready for persistent agent workloads.

---

## Table of Contents

- [Overview](#overview)
- [Conventions](#conventions)
- [Prerequisites](#prerequisites)
- [Scripts](#scripts)
  - [mbp-server-setup.sh](#mbp-server-setupsh)
  - [install-vault.sh](#install-vaultsh)
  - [sync.sh](#syncsh)
- [Project Structure](#project-structure)
- [Skills](#skills)
  - [Available domains](#available-domains)
  - [vault — autonomous credential CRUD](#vault--autonomous-credential-crud)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

Agent Toolkit provides battle-tested automation scripts for turning consumer hardware into reliable, always-on infrastructure. The primary use case is preparing machines to host AI agents, development servers, and home lab services that require persistent uptime and remote access.

## Conventions

This project follows a strict **convention-over-configuration** philosophy. All naming -- skills, commands, files, folders, SQL, documentation -- uses the same pattern:

```
{domain}            -- Reference/knowledge (e.g., /git)
{domain}-{action}   -- Executable action (e.g., /git-commit)
```

See [CONVENTIONS.md](CONVENTIONS.md) for the full specification, domain prefix registry, and examples.

---

## Prerequisites

- macOS (Sonoma 14+ recommended)
- Administrator (sudo) access
- Terminal / shell access

---

## Scripts

### mbp-server-setup.sh

Converts a MacBook Pro into an always-on headless server. Configures power management, installs a persistent caffeinate daemon, enables SSH, and sets up Wake-on-LAN -- all in a single command with full revert support.

**Location:** `scripts/mbp-server-setup.sh`

#### What It Does

| Step | Action | Detail |
|------|--------|--------|
| 1 | Backup current settings | Saves existing `pmset` config to `/tmp/openclaw-pmset-backup.txt` |
| 2 | Configure power management | Disables sleep, standby, hibernate, and auto power-off |
| 3 | Disable lid-close sleep | MacBook stays awake with the lid closed |
| 4 | Install caffeinate daemon | Persistent `LaunchDaemon` that survives reboots and crashes |
| 5 | Enable SSH | Turns on Remote Login for remote access |
| 6 | Disable screen saver | Prevents screen saver from activating |
| 7 | Verify configuration | Prints current settings and confirms all services are running |

#### Usage

**Run setup:**

```bash
sudo bash scripts/mbp-server-setup.sh
```

**Revert all changes:**

```bash
sudo bash scripts/mbp-server-setup.sh --revert
```

The revert command removes the caffeinate daemon, restores default power management settings, and optionally disables SSH.

#### Power Management Settings Applied

```text
sleep 0             Never sleep
disksleep 0         Never spin down disk
displaysleep 15     Display off after 15 minutes
hibernatemode 0     No hibernate (pure RAM)
standby 0           No deep standby
autopoweroff 0      No auto power off
powernap 0          No background wake cycles
proximitywake 0     No wake for nearby iCloud devices
tcpkeepalive 1      Keep TCP connections alive (critical for SSH)
ttyskeepawake 1     SSH sessions prevent sleep
womp 1              Wake-on-LAN enabled
autorestart 1       Auto restart after power loss
lidwake 1           Wake when lid opened
disablesleep 1      Lid close does not trigger sleep
```

#### Caffeinate Daemon

The script installs a `LaunchDaemon` at `/Library/LaunchDaemons/com.openclaw.caffeinate.plist` that runs `caffeinate -dimsu`:

| Flag | Purpose |
|------|---------|
| `-d` | Prevent display sleep |
| `-i` | Prevent idle sleep |
| `-m` | Prevent disk sleep |
| `-s` | Prevent system sleep (AC power) |
| `-u` | Declare user as active |

The daemon auto-restarts on crash and persists across reboots. Logs are written to `/tmp/openclaw-caffeinate.log`.

#### Post-Setup Recommendations

- Keep the MacBook plugged into AC power at all times
- Keep the lid slightly open or use a stand for better thermals
- Set up a VPN (Tailscale, WireGuard, or ZeroTier) for remote access outside LAN
- Enable auto-login: **System Settings > Users > Login Options > Auto Login**

---

### install-vault.sh

Deploys the `vault` skill (autonomous Bitwarden / Vaultwarden CRUD for Claude Code) on this Mac.

**Location:** `scripts/install-vault.sh`

#### What It Does

| Step | Action |
|------|--------|
| 1 | Installs `bitwarden-cli` and `jq` via Homebrew if missing |
| 2 | Prompts for server URL + email, writes `~/.config/vault-skill/config.sh` |
| 3 | Copies `skills/vault/` into `~/.claude/skills/vault/` (skill + CLI scripts) |
| 4 | Copies `dotfiles/bw-secrets.zsh` into `~/.config/bw-secrets.zsh` |
| 5 | Idempotently adds `source` + `PATH` lines to `~/.zshrc` |
| 6 | Points `bw` CLI at the configured server |
| 7 | Prints the manual steps for storing master password + API key in macOS Keychain |

#### Usage

```bash
bash scripts/install-vault.sh
```

After it finishes, follow the printed Keychain steps (master password + API key), then verify with `vault setup`.

See [skills/vault/README.md](skills/vault/README.md) for full details on the trust model, rotation, and recovery.

---

### sync.sh

Source-of-truth deployer. Edits land in this repo, `sync.sh` rsyncs them into the right locations on the host.

**Location:** `scripts/sync.sh`

#### What it deploys

| From repo | To machine | Notes |
|-----------|-----------|-------|
| `commands/*.md` | `~/.claude/commands/` | Slash command definitions |
| `hooks/*.sh` | `~/.claude/hooks/` | Shell hooks (mode +x preserved) |
| `skills/{name}/` (reference) | `~/.claude/skills/{name}/` AND `~/.agents/skills/{name}/` | Reference skills deploy to both Claude Code and OpenClaw when `~/.agents/skills/` exists |
| `skills/{name}/` (action — has matching `commands/{name}.md`) | `~/.claude/skills/{name}/` (without SKILL.md) | Action skill body excludes SKILL.md since the command file registers it |
| `prompt-shorthand-modes.md` | symlinked into `~/.claude/` | Speech-friendly shortcut reference |

#### Usage

```bash
bash scripts/sync.sh            # deploy
bash scripts/sync.sh --dry-run  # preview without writing
bash scripts/sync.sh --delete   # mirror (removes files on dest not in source)
bash scripts/sync.sh -v         # verbose rsync output
```

`sync.sh` reports orphan skills (folder with no `SKILL.md` and no command file) and orphan commands (command file with no matching skill folder).

---

## Project Structure

```
agent-toolkit/
  CLAUDE.md                  -- Working notes for Claude (this repo is the
                                source of truth for ~/.claude/ contents)
  CONVENTIONS.md             -- Universal naming convention specification
  README.md                  -- This file
  prompt-shorthand-modes.md  -- Speech-friendly prompt mode shortcuts
  scripts/                   -- Automation, setup, and sync scripts
  commands/                  -- Slash command definitions ({domain}-{action}.md)
  hooks/                     -- Shell hooks consumed by ~/.claude/settings.json
  skills/                    -- Reference and action skill sources
  dotfiles/                  -- Shell helpers deployed by installers
                                (e.g. bw-secrets.zsh for the devenv flow)
  .github/workflows/         -- CalVer auto-release on conventional commits
```

## Skills

Skills follow the `{domain}-{action}` naming convention. The bare domain name (`git`, `docs`) is a **reference skill** containing standards and rules. Domain-prefixed names (`git-ship`, `docs-craft`) are **action skills** that execute workflows using those standards.

See [CONVENTIONS.md](CONVENTIONS.md) for the full pattern and domain prefix registry.

### Available domains

| Domain | Reference skill | Action commands | Purpose |
|---|---|---|---|
| `git` | `git` | `git-ship`, `git-fast`, `git-audit` | Git operations with conventional-commit + branch-naming standards |
| `docs` | `docs` | `docs-craft`, `docs-organize`, `docs-audit` | Documentation standards + executable doc workflows |
| `rails` | `rails` | `rails-gen`, `rails-dev`, `rails-test`, `rails-test-audit`, `rails-test-full`, `rails-test-run` | Rails conventions (Hotwire, Tailwind, PostgreSQL) and test workflows |
| `vault` | `vault` | — (CLI subcommands) | Autonomous credential CRUD against self-hosted Bitwarden / Vaultwarden |
| `kickoff` | `kickoff` | `kickoff` | Bootstrap a new project (CLAUDE.md + git init + private GitHub repo) |
| `automate` | `automation-tool-router` | `automate` | Route browser / UI automation tasks to the right tool (Playwright, agent-browser, Peekaboo) |
| `expertise` | `expertise` | — | Catalog of domain expertise references for quick lookup |
| `peek` | `peekaboo` | — | Screen interaction on macOS |

### vault — autonomous credential CRUD

Skill that lets Claude (or you, from the shell) read, write, rotate, and bulk-load credentials in a self-hosted Bitwarden or Vaultwarden vault without ever prompting for the master password during routine use.

- **Server-agnostic** — works with official Bitwarden self-hosted, Vaultwarden, or anything `bw config server` accepts.
- **Autonomous recovery** — silently re-unlocks via macOS Keychain (master password) and re-logs in via personal API key (also Keychain) when the session expires or is logged out.
- **CLI shape** — `vault get NAME [--field …]`, `vault set-field`, `vault create`, `vault env`, plus `doctor`/`setup`/`status` for diagnostics.
- **Convention over configuration** — one Login item per service, one Note + Hidden custom fields per env context. Avoid legacy KEY=value-in-notes.
- **Audit log** — every write is timestamped in `~/.cache/vault-audit.log` (action + item id, never the value).

#### Quick install

```bash
bash scripts/install-vault.sh
# then follow the printed steps to populate macOS Keychain
vault setup    # verifies all 8 checks
```

Full docs in [skills/vault/README.md](skills/vault/README.md) and [skills/vault/SKILL.md](skills/vault/SKILL.md).

---

## Deployment

The repo is the **source of truth** for `~/.claude/` (Claude Code) and shared reference skills for `~/.agents/` (OpenClaw). Per-machine bootstrap:

```bash
# 1. Clone
gh repo clone aren13/agent-toolkit
cd agent-toolkit

# 2. Install any standalone tools (one-shots, run once per Mac)
bash scripts/install-vault.sh   # vault skill — Keychain + bw config + .zshrc
bash scripts/mbp-server-setup.sh   # only on machines you want as headless servers

# 3. Deploy skills, commands, and hooks
bash scripts/sync.sh
```

### Per-machine configuration

Machine-specific values **never live in this repo**. Each installer (e.g. `install-vault.sh`) writes a config file under `~/.config/{tool}/` with the right values for that Mac. The deployed skill reads from that config file at runtime.

Examples:

| Tool | Config path | Holds |
|---|---|---|
| `vault` | `~/.config/vault-skill/config.sh` | `VAULT_BW_SERVER`, `VAULT_BW_EMAIL` |
| (future) | `~/.config/{tool}/config.sh` | Same pattern |

This keeps the repo public and identical across machines — secrets and identifiers live only on the host that needs them.

### Two-agent deployment (OpenClaw + Claude Code)

If `~/.agents/skills/` exists on a Mac (i.e. OpenClaw is installed), `sync.sh` automatically deploys reference skills to both `~/.claude/skills/` and `~/.agents/skills/`. Action skills stay Claude-only because their command files use Claude-specific `!`backtick`` dynamic-context syntax.

Edit a skill once in the repo, run `sync.sh`, both agents see it.

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-script`)
3. Commit your changes
4. Push to the branch and open a Pull Request

---

## License

MIT
