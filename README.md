# Agent Toolkit

A collection of scripts and utilities for setting up and managing infrastructure used by AI agents and home lab environments. These tools automate server provisioning, system hardening, and always-on configurations so machines are ready for persistent agent workloads.

---

## Table of Contents

- [Overview](#overview)
- [Conventions](#conventions)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Scripts](#scripts)
  - [mbp-server-setup.sh](#mbp-server-setupsh)
- [Claude Code](#claude-code)
  - [Statusline](#statusline)
  - [Hooks](#hooks)
- [Skills](#skills)
- [Installation](#installation)
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

## Claude Code

Shell-based integrations for the [Claude Code](https://docs.claude.com/en/docs/claude-code) CLI. All scripts are self-contained, auditable, and make no network calls.

**Location:** `claude-code/`

### Statusline

A compact statusline renderer for the Claude Code TUI. Shows working directory, model, session duration, turn count, remaining context, token totals, spend, and git state (branch, dirty-file count, ahead/behind).

```
📁 agent-toolkit │ 🎭 Opus 4.7 │ ⏱ 1h23m │ 💬 47 │ 🔋 180k left │ ⬇️ 412k ⬆️ 38k │ 💰 $3.21 │ 🌿 main ⚡2 ↑1
```

Each segment is an isolated shell function, so removing or reordering them is a one-line edit. See [`claude-code/statusline/README.md`](claude-code/statusline/README.md) for install steps and customization.

### Hooks

A `Stop`-hook notifier that fires when Claude finishes a turn:

- macOS notification banner (or Linux `notify-send`)
- Terminal-tab title tag (`🔴 <session> DONE`) so you can spot completed sessions across windows
- Optional text-to-speech announcement gated by a minimum elapsed time so fast turns stay silent

Also included: `voice-on.sh` / `voice-off.sh` / `voice-status.sh` to toggle TTS without editing settings.

Session names, TTS minimum duration, speaking rate, and the macOS terminal bundle ID are all configurable via environment variables -- no hardcoded assumptions about which terminal you use. See [`claude-code/hooks/README.md`](claude-code/hooks/README.md) for install steps and a complete `settings.json` example.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/aren13/agent-toolkit.git
cd agent-toolkit
```

---

## Project Structure

```
agent-toolkit/
  claude-code/        -- Claude Code CLI integrations (statusline, hooks)
  scripts/            -- Automation and setup scripts
  skills/             -- Claude Code skills following {domain}-{action} convention
  CONVENTIONS.md      -- Universal naming convention specification
  README.md           -- This file
```

## Skills

Skills follow the `{domain}-{action}` naming convention. The bare domain name (`git`, `doc`) is a reference skill containing standards and rules. Domain-prefixed names (`git-commit`, `doc-create`) are action skills that execute workflows using those standards.

See [CONVENTIONS.md](CONVENTIONS.md) for the full pattern and domain prefix registry.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/aren13/agent-toolkit.git
cd agent-toolkit
```

Scripts are standalone and have no external dependencies beyond macOS system tools.

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-script`)
3. Commit your changes
4. Push to the branch and open a Pull Request

---

## License

MIT
