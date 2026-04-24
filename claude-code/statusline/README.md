# Claude Code Statusline

A compact, informative statusline for the [Claude Code](https://docs.claude.com/en/docs/claude-code) CLI. Renders one line at the bottom of the TUI with working directory, model, session duration, turn count, remaining context, token usage, spend, and git state.

---

## Preview

```
📁 agent-toolkit │ 🎭 Opus 4.7 │ ⏱ 1h23m │ 💬 47 │ 🔋 180k left │ ⬇️ 412k ⬆️ 38k │ 💰 $3.21 │ 🌿 main ⚡2 ↑1
```

Segments, left to right:

| Segment | Shows | Source |
|---------|-------|--------|
| 📁 | Current working directory basename | `workspace.current_dir` |
| 🎭 / 🎵 / 🎋 | Model (Opus / Sonnet / Haiku) | `model.display_name` |
| ⏱ | Wall-clock duration of this session | `/tmp/claude_session_<id>` marker |
| 💬 | User-turn count | Parsed from JSONL transcript |
| 🔋 | Remaining context tokens (thousands) | Derived from `used_percentage` |
| ⬇️ / ⬆️ | Cumulative input / output tokens (thousands, includes cache) | `context_window.*` |
| 💰 | Accumulated cost in USD | `cost.total_cost_usd` |
| 🌿 | Git branch, dirty file count (⚡) or clean (✨), ahead/behind (↑ ↓) | `git` in `current_dir` |

Each segment is rendered only when its data is available, so short sessions and non-git directories render a shorter line.

---

## Requirements

- `bash` 3.2 or newer (macOS default is fine)
- `jq`
- `git` and `awk` (both standard on macOS / most Linuxes)

No network calls. No API keys read. No files written outside `/tmp`.

---

## Installation

1. **Copy the script** to a stable location:

   ```bash
   mkdir -p ~/.claude/statusline
   cp claude-code/statusline/statusline.sh ~/.claude/statusline/
   chmod +x ~/.claude/statusline/statusline.sh
   ```

2. **Register it** in `~/.claude/settings.json`:

   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "/Users/<you>/.claude/statusline/statusline.sh"
     }
   }
   ```

   Claude Code requires an absolute path; `~` is not expanded.

3. **Restart Claude Code.** The new statusline renders on the next prompt.

---

## Testing

Before wiring it up, pipe a sample JSON into it to confirm output:

```bash
echo '{
  "model": { "display_name": "Claude Opus 4.7" },
  "session_id": "test",
  "workspace": { "current_dir": "'"$PWD"'" },
  "context_window": {
    "total_input_tokens": 12345,
    "total_output_tokens": 6789,
    "current_usage": {
      "input_tokens": 1000,
      "cache_creation_input_tokens": 500,
      "cache_read_input_tokens": 2000
    },
    "used_percentage": 5.5
  },
  "cost": { "total_cost_usd": 0.42 }
}' | ./statusline.sh
echo
```

Expected output is one line with all segments that have data.

---

## Customization

Each segment is an isolated function (`segment_cwd`, `segment_model`, `segment_duration`, `segment_turns`, `segment_remaining_context`, `segment_tokens`, `segment_cost`, `segment_git`). The **main section** at the bottom of the script is the only place they are invoked:

```bash
segment_cwd
segment_model
segment_duration
segment_turns
segment_remaining_context
segment_tokens
segment_cost
segment_git
```

**To remove a segment:** delete or comment out its call.
**To reorder:** move the lines.
**To change the separator:** edit `SEPARATOR=" │ "` near the top.
**To change an emoji:** edit the `PARTS+=("...")` line inside that segment.

### Example: minimal layout

```bash
segment_cwd
segment_model
segment_cost
segment_git
```

Renders:

```
📁 agent-toolkit │ 🎭 Opus 4.7 │ 💰 $3.21 │ 🌿 main ✨
```

---

## Troubleshooting

**Nothing renders.**
Claude Code swallows statusline errors silently. Run the script with a known JSON input (see [Testing](#testing)) to see what it prints.

**"jq not found".**
Install it: `brew install jq` on macOS, `apt install jq` on Debian/Ubuntu.

**Duration keeps resetting.**
The per-session marker lives in `/tmp/claude_session_<session_id>`. If your system clears `/tmp` on reboot (macOS does not by default; many Linuxes do), duration restarts after reboot. This is intentional -- session IDs are not stable across reboots either.

**Garbled box characters.**
The separator uses `│` (U+2502). Make sure your terminal font supports box-drawing characters. Replace with `|` if not.

---

## What the script does not do

- No network calls (no API pings, no version checks, no telemetry).
- No writes outside `/tmp/claude_session_*` markers.
- No reads of secrets, keychains, shell history, or environment variables.
- No parsing of anything outside the JSON piped in on stdin and the optional transcript file it points at.

If you want to verify this yourself, the script is ~150 lines and every external command is visible -- `jq`, `git`, `awk`, `sed`, `date`, `basename`, `wc`, `tr`, `cat`.
