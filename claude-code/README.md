# Claude Code Integrations

Shell-based integrations for the [Claude Code](https://docs.claude.com/en/docs/claude-code) CLI.

| Integration | Purpose |
|-------------|---------|
| [`statusline/`](./statusline/) | Custom statusline showing cwd, model, duration, turns, remaining context, token totals, spend, and git state. |
| [`hooks/`](./hooks/) | Stop-hook notifier (desktop notification, tab title, optional TTS) plus voice toggle scripts. |

Each subdirectory has its own README with install steps, requirements, configuration variables, and a security note.

## Design principles

- **Self-contained shell.** No runtime beyond what macOS / Linux ships with plus `jq`. No Node, no Python, no package manager.
- **No network, no secrets.** Scripts only read the JSON Claude Code pipes in and a handful of `/tmp` scratch files. Nothing phones home. Nothing reads `~/.ssh`, keychains, or shell history.
- **Short and auditable.** Every external command is visible. Each file is small enough to read end-to-end.
- **Configurable via env vars.** No config files to maintain -- override behavior from your shell profile or inline in the hook registration.
