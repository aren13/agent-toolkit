# Claude Code Hooks

Shell hooks for the [Claude Code](https://docs.claude.com/en/docs/claude-code) CLI. Notifies you when a turn finishes, optionally speaks the result, and tags the terminal tab so you can spot completed sessions at a glance.

Works well for anyone running multiple Claude sessions across terminal tabs or Spaces -- especially long-running agent work where you want to go do something else while Claude thinks.

---

## What this does

### `stop-notify.sh`

The main event. Wired to the `Stop` hook, it fires once per turn completion and produces:

1. **Desktop notification** -- macOS banner via `terminal-notifier` (falls back to `osascript`), Linux via `notify-send`. Includes session name so multi-session users know which one finished.
2. **Terminal-tab title tag** -- rewrites the tab title to `🔴 <session> DONE` using an OSC escape, so you can spot the completed session when switching windows. Cleared on the next turn.
3. **Text-to-speech announcement** -- speaks `"<session>, done"` using `say` (macOS), `espeak`, or `spd-say`. Gated by a minimum elapsed time so fast turns stay silent.

Also usable for `PreToolUse` and `PostToolUse` hooks by passing `pre` or `post` as the first argument -- it will speak short per-tool messages like "Reading foo.md" or "Bash done".

### `voice-on.sh` / `voice-off.sh` / `voice-status.sh`

Toggles the shared TTS state at `/tmp/claude-tts-enabled`. Run them from a terminal to mute announcements without removing the hook entirely.

```bash
./voice-off.sh   # no more audio
./voice-on.sh    # back on
./voice-status.sh
```

---

## Requirements

- `bash` 3.2+
- `jq` (for parsing hook JSON)
- **macOS:** `say` is built-in. Optionally install `terminal-notifier` (`brew install terminal-notifier`) for clickable notifications.
- **Linux:** `notify-send` (libnotify), plus `espeak` or `spd-say` for TTS.

All dependencies are checked at runtime -- missing tools are skipped silently, they do not break the hook.

No network calls. No secrets read. Only writes to `/tmp/claude-*` scratch files.

---

## Installation

1. **Copy the scripts** to a stable location:

   ```bash
   mkdir -p ~/.claude/hooks
   cp claude-code/hooks/stop-notify.sh  ~/.claude/hooks/
   cp claude-code/hooks/voice-on.sh     ~/.claude/hooks/
   cp claude-code/hooks/voice-off.sh    ~/.claude/hooks/
   cp claude-code/hooks/voice-status.sh ~/.claude/hooks/
   chmod +x ~/.claude/hooks/*.sh
   ```

2. **Register the hooks** in `~/.claude/settings.json`. See [`examples/settings.example.json`](./examples/settings.example.json) for a complete snippet. Minimum needed:

   ```json
   {
     "hooks": {
       "UserPromptSubmit": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "date +%s > /tmp/claude-prompt-start-$$"
             }
           ]
         }
       ],
       "Stop": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "$HOME/.claude/hooks/stop-notify.sh stop"
             }
           ]
         }
       ]
     }
   }
   ```

   The `UserPromptSubmit` hook records a timestamp that `stop-notify.sh` reads to decide whether the turn took long enough to warrant an audio announcement. Without it the timer defaults to "always speak".

3. **Restart Claude Code.** Hooks only load at startup.

---

## Configuration

All settings are environment variables. Set them in your shell profile or inline in the hook command.

| Variable | Default | Effect |
|----------|---------|--------|
| `CC_TTS_MIN_SECONDS` | `30` | Minimum wall-clock seconds before the stop hook speaks. `0` = always speak. |
| `CC_TTS_RATE` | `200` | Words per minute for macOS `say`. |
| `CC_SESSION_NAME` | *(unset)* | Override the inferred session name. Useful if your directory names are ugly. |
| `CC_TERMINAL_BUNDLE_ID` | *(unset)* | macOS bundle ID for the terminal app (e.g. `dev.warp.Warp-Stable`, `com.apple.Terminal`, `com.googlecode.iterm2`). When set, clicking the notification activates that app. |

### Session name inference

When `CC_SESSION_NAME` is not set, the hook looks for `sessionName` (or legacy `warpSessionName`) in `.claude/settings.local.json` in the current working directory. Falls back to the basename of `$PWD`.

Example project-level `.claude/settings.local.json`:

```json
{
  "sessionName": "auth-refactor"
}
```

---

## Testing

Simulate a Stop event without involving Claude Code:

```bash
echo '{"session_id":"test","stop_hook_active":false}' \
  | CC_TTS_MIN_SECONDS=0 CC_SESSION_NAME="test-session" \
    ./stop-notify.sh stop
```

You should see a desktop notification and hear "test-session, done".

To test a Pre/Post hook:

```bash
echo '{"tool_name":"Read","tool_input":{"file_path":"/tmp/foo.txt"}}' \
  | ./stop-notify.sh pre
```

Expected: TTS says "Reading foo.txt".

---

## Troubleshooting

**Nothing happens.**
Claude Code swallows hook errors. Run the test commands above to see output directly.

**TTS doesn't fire after a long turn.**
Check that the `UserPromptSubmit` hook is registered -- without the `/tmp/claude-prompt-start-*` file, the elapsed-time check still works (defaults to "speak") but if it is failing to write, `ls -t /tmp/claude-prompt-start-*` confirms whether markers exist.

**Notification is silent / missing sound.**
macOS: check System Settings → Notifications → Terminal (or `terminal-notifier`). First-time use triggers a permission prompt.

**Terminal tab title doesn't update.**
Some terminals ignore OSC 0 sequences or allow them to be disabled. In Warp, iTerm2, Terminal.app, and GNOME Terminal the default is to honor them.

**Multiple notifications per turn.**
The hook debounces at 3 seconds per session. If you see duplicates after that window, check whether you registered the Stop hook more than once.

---

## What this does not do

- No network calls.
- No reads of `~/.ssh`, shell history, keychains, or environment variables other than the `CC_*` config variables above.
- No writes outside `/tmp/claude-*` scratch files.
- No modification of Claude Code state, transcripts, or conversation history.

Scripts are short and auditable -- `stop-notify.sh` is ~240 lines with every external command visible (`jq`, `say`/`espeak`/`spd-say`, `terminal-notifier`/`osascript`/`notify-send`, `date`, `ps`, `awk`, `sed`, `basename`).
