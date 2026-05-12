#!/bin/bash
# Claude Code notification hook: speech + macOS notification + Warp tab title.
# Usage: Called by Claude Code hooks with stdin JSON and $1 = hook type.

STATE_FILE="/tmp/claude-tts-enabled"

# Check if TTS is enabled (default: enabled)
if [[ -f "$STATE_FILE" ]]; then
    VOICE_ENABLED=$(cat "$STATE_FILE")
else
    VOICE_ENABLED="1"
    echo "1" > "$STATE_FILE"
fi

# Exit silently if disabled
[[ "$VOICE_ENABLED" != "1" ]] && exit 0

# Read JSON input from stdin
INPUT=$(cat)

# Parse fields using jq
if command -v jq &>/dev/null; then
    TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
    TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // empty' 2>/dev/null)

    # Extract detailed info based on tool type
    case "$TOOL_NAME" in
        "Read"|"Write"|"Edit")
            FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null)
            FILE_NAME=$(basename "$FILE_PATH" 2>/dev/null)
            ;;
        "Bash")
            COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // empty' 2>/dev/null)
            # Get first word/command name, limit length
            CMD_SHORT=$(echo "$COMMAND" | awk '{print $1}' | head -c 30)
            ;;
        "Glob")
            PATTERN=$(echo "$TOOL_INPUT" | jq -r '.pattern // empty' 2>/dev/null)
            ;;
        "Grep")
            SEARCH_PATTERN=$(echo "$TOOL_INPUT" | jq -r '.pattern // empty' 2>/dev/null)
            ;;
        "Task")
            DESCRIPTION=$(echo "$TOOL_INPUT" | jq -r '.description // empty' 2>/dev/null)
            AGENT_TYPE=$(echo "$TOOL_INPUT" | jq -r '.subagent_type // empty' 2>/dev/null)
            ;;
        "WebFetch")
            URL=$(echo "$TOOL_INPUT" | jq -r '.url // empty' 2>/dev/null)
            # Extract domain from URL
            DOMAIN=$(echo "$URL" | sed -E 's|https?://([^/]+).*|\1|' 2>/dev/null)
            ;;
        "WebSearch")
            QUERY=$(echo "$TOOL_INPUT" | jq -r '.query // empty' 2>/dev/null)
            # Limit query length for speech
            QUERY_SHORT=$(echo "$QUERY" | head -c 50)
            ;;
        "TodoWrite")
            # Count todos
            TODO_COUNT=$(echo "$TOOL_INPUT" | jq -r '.todos | length' 2>/dev/null)
            ;;
    esac
else
    TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' 2>/dev/null)
fi

HOOK_TYPE="${1:-tool}"

# Resolve session name: env var > project config > folder name
resolve_session_name() {
    if [[ -n "$CLAUDE_SESSION_NAME" ]]; then
        echo "$CLAUDE_SESSION_NAME"
        return
    fi
    if command -v jq &>/dev/null && [[ -f ".claude/settings.local.json" ]]; then
        local name
        name=$(jq -r '.warpSessionName // empty' .claude/settings.local.json 2>/dev/null)
        if [[ -n "$name" ]]; then
            echo "$name"
            return
        fi
    fi
    basename "$PWD"
}

# Build detailed message based on hook type
case "$HOOK_TYPE" in
    "pre")
        case "$TOOL_NAME" in
            "Bash")
                if [[ -n "$CMD_SHORT" ]]; then
                    MESSAGE="Running $CMD_SHORT"
                else
                    MESSAGE="Running command"
                fi
                ;;
            "Read")
                if [[ -n "$FILE_NAME" ]]; then
                    MESSAGE="Reading $FILE_NAME"
                else
                    MESSAGE="Reading file"
                fi
                ;;
            "Write")
                if [[ -n "$FILE_NAME" ]]; then
                    MESSAGE="Writing $FILE_NAME"
                else
                    MESSAGE="Writing file"
                fi
                ;;
            "Edit")
                if [[ -n "$FILE_NAME" ]]; then
                    MESSAGE="Editing $FILE_NAME"
                else
                    MESSAGE="Editing file"
                fi
                ;;
            "Glob")
                if [[ -n "$PATTERN" ]]; then
                    MESSAGE="Searching for $PATTERN"
                else
                    MESSAGE="Searching files"
                fi
                ;;
            "Grep")
                if [[ -n "$SEARCH_PATTERN" ]]; then
                    # Limit pattern length for speech
                    PATTERN_SHORT=$(echo "$SEARCH_PATTERN" | head -c 30)
                    MESSAGE="Searching for $PATTERN_SHORT"
                else
                    MESSAGE="Searching content"
                fi
                ;;
            "Task")
                if [[ -n "$AGENT_TYPE" ]]; then
                    MESSAGE="Starting $AGENT_TYPE agent"
                elif [[ -n "$DESCRIPTION" ]]; then
                    MESSAGE="Starting task: $DESCRIPTION"
                else
                    MESSAGE="Starting agent"
                fi
                ;;
            "WebFetch")
                if [[ -n "$DOMAIN" ]]; then
                    MESSAGE="Fetching from $DOMAIN"
                else
                    MESSAGE="Fetching web page"
                fi
                ;;
            "WebSearch")
                if [[ -n "$QUERY_SHORT" ]]; then
                    MESSAGE="Searching web for $QUERY_SHORT"
                else
                    MESSAGE="Searching web"
                fi
                ;;
            "TodoWrite")
                if [[ -n "$TODO_COUNT" ]]; then
                    MESSAGE="Updating $TODO_COUNT todos"
                else
                    MESSAGE="Updating todos"
                fi
                ;;
            *) MESSAGE="Starting ${TOOL_NAME:-task}" ;;
        esac
        ;;
    "post")
        case "$TOOL_NAME" in
            "Bash")
                if [[ -n "$CMD_SHORT" ]]; then
                    MESSAGE="$CMD_SHORT done"
                else
                    MESSAGE="Command done"
                fi
                ;;
            "Read")
                if [[ -n "$FILE_NAME" ]]; then
                    MESSAGE="Read $FILE_NAME"
                else
                    MESSAGE="File read"
                fi
                ;;
            "Write")
                if [[ -n "$FILE_NAME" ]]; then
                    MESSAGE="Wrote $FILE_NAME"
                else
                    MESSAGE="File written"
                fi
                ;;
            "Edit")
                if [[ -n "$FILE_NAME" ]]; then
                    MESSAGE="Edited $FILE_NAME"
                else
                    MESSAGE="File edited"
                fi
                ;;
            "Task")
                if [[ -n "$AGENT_TYPE" ]]; then
                    MESSAGE="$AGENT_TYPE agent finished"
                else
                    MESSAGE="Agent finished"
                fi
                ;;
            "TodoWrite")
                MESSAGE="Todos updated"
                ;;
            *) MESSAGE="${TOOL_NAME:-Task} complete" ;;
        esac
        ;;
    "stop")
        SESSION_NAME=$(resolve_session_name)
        SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)
        STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false' 2>/dev/null)

        # Skip if Claude is already in a stop-hook continuation loop.
        if [[ "$STOP_ACTIVE" == "true" ]]; then
            exit 0
        fi

        # Debounce: one signal per session per 3s window. Prevents duplicate
        # notifications when stop fires twice rapidly for the same turn.
        DEBOUNCE_KEY="${SESSION_ID:-$SESSION_NAME}"
        DEBOUNCE_FILE="/tmp/claude-stop-last-${DEBOUNCE_KEY//\//_}"
        NOW=$(date +%s)
        if [[ -f "$DEBOUNCE_FILE" ]]; then
            LAST=$(cat "$DEBOUNCE_FILE" 2>/dev/null || echo 0)
            if (( NOW - LAST < 3 )); then
                exit 0
            fi
        fi
        echo "$NOW" > "$DEBOUNCE_FILE"

        # Visual signals — always fire on stop, regardless of speech threshold.
        # (1) macOS notification banner: renders on current Space, identifies WHICH session
        # finished. Prefer terminal-notifier so clicking the notification activates Warp
        # (useful across multiple windows); -group dedupes per-session in Notification Center.
        if command -v terminal-notifier &>/dev/null; then
            terminal-notifier \
                -title "Claude Code" \
                -message "${SESSION_NAME} done" \
                -sound Glass \
                -group "${DEBOUNCE_KEY}" \
                -sender dev.warp.Warp-Stable \
                -activate dev.warp.Warp-Stable >/dev/null 2>&1 &
        else
            osascript -e "display notification \"${SESSION_NAME} done\" with title \"Claude Code\" sound name \"Glass\"" >/dev/null 2>&1 &
        fi
        # (2) Warp tab title tag: stays on the tab until next turn, so you can spot the finished one
        # when you alt-tab or switch Spaces back to Warp. Hooks have no controlling tty,
        # so resolve claude's tty via $PPID and write the OSC sequence directly to it.
        CLAUDE_TTY=$(ps -o tty= -p "$PPID" 2>/dev/null | tr -d ' ')
        if [[ -n "$CLAUDE_TTY" && "$CLAUDE_TTY" != "?" && "$CLAUDE_TTY" != "??" ]]; then
            printf '\033]0;🔴 %s DONE\007' "$SESSION_NAME" > "/dev/$CLAUDE_TTY" 2>/dev/null
        fi

        # Speech — only announce if Claude worked for 30+ seconds
        TTS_THRESHOLD=30
        START_FILE=$(ls -t /tmp/claude-prompt-start-* 2>/dev/null | head -1)
        if [[ -n "$START_FILE" ]]; then
            START_TIME=$(cat "$START_FILE" 2>/dev/null)
            ELAPSED=$(( $(date +%s) - START_TIME ))
            if [[ $ELAPSED -lt $TTS_THRESHOLD ]]; then
                exit 0
            fi
        fi
        MESSAGE="$SESSION_NAME, done"
        ;;
    *)
        MESSAGE="${TOOL_NAME:-Task} ${HOOK_TYPE}"
        ;;
esac

# Speak the message (platform-specific)
speak_message() {
    local msg="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - use say command
        say -r 200 "$msg" &
    elif command -v espeak &>/dev/null; then
        # Linux with espeak
        espeak "$msg" &
    elif command -v spd-say &>/dev/null; then
        # Linux with speech-dispatcher
        spd-say "$msg" &
    fi
}

speak_message "$MESSAGE"
exit 0
