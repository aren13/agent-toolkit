#!/usr/bin/env bash
# Claude Code Stop-hook notifier.
#
# Fires when Claude finishes a turn. Produces:
#   1. A macOS notification banner (via terminal-notifier if available,
#      else osascript).
#   2. A terminal-tab title tag ("🔴 <session> DONE") that stays until the
#      next turn, so you can spot the finished session across windows.
#   3. Optional text-to-speech announcement, gated by a minimum elapsed
#      time so fast turns do not spam audio.
#
# Also usable as a generic Pre/PostToolUse hook -- pass the hook type as
# the first argument ($1). Current behavior:
#
#   stop-notify.sh stop     -- notify + tab-title + speak "<session>, done"
#   stop-notify.sh pre      -- speak short pre-tool message
#   stop-notify.sh post     -- speak short post-tool message
#
# See README.md for install steps and environment variables.

set -u

# ---------------------------------------------------------------------------
# Config -- override with environment variables
# ---------------------------------------------------------------------------

# Minimum seconds of wall-clock time before the Stop hook speaks.
# Short turns stay silent. Set to 0 to always speak.
: "${CC_TTS_MIN_SECONDS:=30}"

# Speaking rate (macOS say -r), words per minute. Ignored elsewhere.
: "${CC_TTS_RATE:=200}"

# Override the inferred session name.
: "${CC_SESSION_NAME:=}"

# Optional: bundle ID for the terminal app that launched Claude. When set,
# terminal-notifier uses it for -sender / -activate so clicking the
# notification jumps to that app (e.g. dev.warp.Warp-Stable, com.apple.Terminal,
# com.googlecode.iterm2). Leave empty to skip -- the notification still fires.
: "${CC_TERMINAL_BUNDLE_ID:=}"

# TTS toggle state file. voice-on.sh / voice-off.sh write here.
TTS_STATE_FILE="/tmp/claude-tts-enabled"

# Directory for small scratch files (debounce keys, prompt-start timestamps).
SCRATCH_DIR="/tmp"

# ---------------------------------------------------------------------------
# TTS enable/disable
# ---------------------------------------------------------------------------

if [[ -f "$TTS_STATE_FILE" ]]; then
    VOICE_ENABLED="$(cat "$TTS_STATE_FILE")"
else
    VOICE_ENABLED="1"
    echo "1" >"$TTS_STATE_FILE"
fi

# ---------------------------------------------------------------------------
# Parse hook input
# ---------------------------------------------------------------------------

INPUT="$(cat)"
HOOK_TYPE="${1:-tool}"

have_jq() { command -v jq >/dev/null 2>&1; }

json_field() {
    # $1 = jq path expression, e.g. '.tool_name'
    have_jq || { echo ""; return; }
    echo "$INPUT" | jq -r "${1} // empty" 2>/dev/null
}

TOOL_NAME="$(json_field '.tool_name')"
TOOL_INPUT_JSON=""
if have_jq; then
    TOOL_INPUT_JSON="$(echo "$INPUT" | jq -c '.tool_input // {}' 2>/dev/null)"
fi

# Pull tool-specific fields for nicer TTS phrasing.
FILE_PATH="" FILE_NAME="" COMMAND="" CMD_SHORT=""
PATTERN="" SEARCH_PATTERN="" DESCRIPTION="" AGENT_TYPE=""
URL="" DOMAIN="" QUERY="" QUERY_SHORT="" TODO_COUNT=""

if have_jq && [[ -n "$TOOL_INPUT_JSON" ]]; then
    case "$TOOL_NAME" in
        Read|Write|Edit)
            FILE_PATH="$(echo "$TOOL_INPUT_JSON" | jq -r '.file_path // empty')"
            [[ -n "$FILE_PATH" ]] && FILE_NAME="$(basename "$FILE_PATH")"
            ;;
        Bash)
            COMMAND="$(echo "$TOOL_INPUT_JSON" | jq -r '.command // empty')"
            CMD_SHORT="$(echo "$COMMAND" | awk '{print $1}' | head -c 30)"
            ;;
        Glob)
            PATTERN="$(echo "$TOOL_INPUT_JSON" | jq -r '.pattern // empty')"
            ;;
        Grep)
            SEARCH_PATTERN="$(echo "$TOOL_INPUT_JSON" | jq -r '.pattern // empty')"
            ;;
        Task)
            DESCRIPTION="$(echo "$TOOL_INPUT_JSON" | jq -r '.description // empty')"
            AGENT_TYPE="$(echo  "$TOOL_INPUT_JSON" | jq -r '.subagent_type // empty')"
            ;;
        WebFetch)
            URL="$(echo "$TOOL_INPUT_JSON" | jq -r '.url // empty')"
            DOMAIN="$(echo "$URL" | sed -E 's|https?://([^/]+).*|\1|')"
            ;;
        WebSearch)
            QUERY="$(echo "$TOOL_INPUT_JSON" | jq -r '.query // empty')"
            QUERY_SHORT="$(echo "$QUERY" | head -c 50)"
            ;;
        TodoWrite)
            TODO_COUNT="$(echo "$TOOL_INPUT_JSON" | jq -r '.todos | length' 2>/dev/null)"
            ;;
    esac
fi

# ---------------------------------------------------------------------------
# Session-name resolution (env > project config > folder name)
#
# Project config lookup: reads .claude/settings.local.json in the cwd and
# accepts either "sessionName" or legacy "warpSessionName".
# ---------------------------------------------------------------------------

resolve_session_name() {
    [[ -n "$CC_SESSION_NAME" ]] && { echo "$CC_SESSION_NAME"; return; }

    if have_jq && [[ -f ".claude/settings.local.json" ]]; then
        local name
        name="$(jq -r '.sessionName // .warpSessionName // empty' \
            .claude/settings.local.json 2>/dev/null)"
        [[ -n "$name" ]] && { echo "$name"; return; }
    fi

    basename "$PWD"
}

# ---------------------------------------------------------------------------
# TTS helpers
# ---------------------------------------------------------------------------

speak_message() {
    local msg="$1"
    [[ "$VOICE_ENABLED" != "1" ]] && return
    if [[ "$OSTYPE" == "darwin"* ]]; then
        say -r "$CC_TTS_RATE" "$msg" &
    elif command -v espeak >/dev/null 2>&1; then
        espeak "$msg" &
    elif command -v spd-say >/dev/null 2>&1; then
        spd-say "$msg" &
    fi
}

# ---------------------------------------------------------------------------
# Notification + tab-title helpers (stop hook only)
# ---------------------------------------------------------------------------

notify_desktop() {
    local session="$1" debounce_key="$2"
    if command -v terminal-notifier >/dev/null 2>&1; then
        local args=(
            -title "Claude Code"
            -message "${session} done"
            -sound Glass
            -group "$debounce_key"
        )
        if [[ -n "$CC_TERMINAL_BUNDLE_ID" ]]; then
            args+=(-sender "$CC_TERMINAL_BUNDLE_ID"
                   -activate "$CC_TERMINAL_BUNDLE_ID")
        fi
        terminal-notifier "${args[@]}" >/dev/null 2>&1 &
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e "display notification \"${session} done\" \
with title \"Claude Code\" sound name \"Glass\"" >/dev/null 2>&1 &
    elif command -v notify-send >/dev/null 2>&1; then
        notify-send "Claude Code" "${session} done" &
    fi
}

# Tag the terminal tab so you can spot the finished session after alt-tabbing.
# Hooks have no controlling tty, so we resolve Claude's tty via the parent PID
# and write the OSC escape directly to that tty.
tag_tab_title() {
    local session="$1"
    local tty
    tty="$(ps -o tty= -p "$PPID" 2>/dev/null | tr -d ' ')"
    if [[ -n "$tty" && "$tty" != "?" && "$tty" != "??" ]]; then
        printf '\033]0;🔴 %s DONE\007' "$session" >"/dev/$tty" 2>/dev/null
    fi
}

# ---------------------------------------------------------------------------
# Build the spoken message
# ---------------------------------------------------------------------------

MESSAGE=""

case "$HOOK_TYPE" in
    pre)
        case "$TOOL_NAME" in
            Bash)      MESSAGE="${CMD_SHORT:+Running $CMD_SHORT}";   MESSAGE="${MESSAGE:-Running command}"      ;;
            Read)      MESSAGE="${FILE_NAME:+Reading $FILE_NAME}";   MESSAGE="${MESSAGE:-Reading file}"         ;;
            Write)     MESSAGE="${FILE_NAME:+Writing $FILE_NAME}";   MESSAGE="${MESSAGE:-Writing file}"         ;;
            Edit)      MESSAGE="${FILE_NAME:+Editing $FILE_NAME}";   MESSAGE="${MESSAGE:-Editing file}"         ;;
            Glob)      MESSAGE="${PATTERN:+Searching for $PATTERN}"; MESSAGE="${MESSAGE:-Searching files}"      ;;
            Grep)
                grep_short="$(echo "$SEARCH_PATTERN" | head -c 30)"
                MESSAGE="${grep_short:+Searching for $grep_short}"
                MESSAGE="${MESSAGE:-Searching content}"
                ;;
            Task)
                if   [[ -n "$AGENT_TYPE"  ]]; then MESSAGE="Starting $AGENT_TYPE agent"
                elif [[ -n "$DESCRIPTION" ]]; then MESSAGE="Starting task: $DESCRIPTION"
                else                               MESSAGE="Starting agent"
                fi
                ;;
            WebFetch)  MESSAGE="${DOMAIN:+Fetching from $DOMAIN}";       MESSAGE="${MESSAGE:-Fetching web page}" ;;
            WebSearch) MESSAGE="${QUERY_SHORT:+Searching web for $QUERY_SHORT}"; MESSAGE="${MESSAGE:-Searching web}" ;;
            TodoWrite) MESSAGE="${TODO_COUNT:+Updating $TODO_COUNT todos}";      MESSAGE="${MESSAGE:-Updating todos}" ;;
            *)         MESSAGE="Starting ${TOOL_NAME:-task}" ;;
        esac
        ;;

    post)
        case "$TOOL_NAME" in
            Bash)      MESSAGE="${CMD_SHORT:+$CMD_SHORT done}";       MESSAGE="${MESSAGE:-Command done}"  ;;
            Read)      MESSAGE="${FILE_NAME:+Read $FILE_NAME}";       MESSAGE="${MESSAGE:-File read}"     ;;
            Write)     MESSAGE="${FILE_NAME:+Wrote $FILE_NAME}";      MESSAGE="${MESSAGE:-File written}"  ;;
            Edit)      MESSAGE="${FILE_NAME:+Edited $FILE_NAME}";     MESSAGE="${MESSAGE:-File edited}"   ;;
            Task)
                if [[ -n "$AGENT_TYPE" ]]; then MESSAGE="$AGENT_TYPE agent finished"
                else                            MESSAGE="Agent finished"
                fi
                ;;
            TodoWrite) MESSAGE="Todos updated" ;;
            *)         MESSAGE="${TOOL_NAME:-Task} complete" ;;
        esac
        ;;

    stop)
        SESSION_NAME="$(resolve_session_name)"
        SESSION_ID_FIELD="$(json_field '.session_id')"
        STOP_ACTIVE="$(json_field '.stop_hook_active')"

        # Avoid loops when Claude triggers Stop recursively.
        [[ "$STOP_ACTIVE" == "true" ]] && exit 0

        # Debounce: 1 notification per session per 3s.
        DEBOUNCE_KEY="${SESSION_ID_FIELD:-$SESSION_NAME}"
        DEBOUNCE_FILE="${SCRATCH_DIR}/claude-stop-last-${DEBOUNCE_KEY//\//_}"
        NOW="$(date +%s)"
        if [[ -f "$DEBOUNCE_FILE" ]]; then
            LAST="$(cat "$DEBOUNCE_FILE" 2>/dev/null || echo 0)"
            if (( NOW - LAST < 3 )); then
                exit 0
            fi
        fi
        echo "$NOW" >"$DEBOUNCE_FILE"

        # Visual signals fire every time.
        notify_desktop  "$SESSION_NAME" "$DEBOUNCE_KEY"
        tag_tab_title   "$SESSION_NAME"

        # Speak only if the turn took at least CC_TTS_MIN_SECONDS.
        if (( CC_TTS_MIN_SECONDS > 0 )); then
            START_FILE="$(ls -t "${SCRATCH_DIR}"/claude-prompt-start-* \
                2>/dev/null | head -1)"
            if [[ -n "$START_FILE" ]]; then
                START_TIME="$(cat "$START_FILE" 2>/dev/null || echo 0)"
                ELAPSED=$(( NOW - START_TIME ))
                if (( ELAPSED < CC_TTS_MIN_SECONDS )); then
                    exit 0
                fi
            fi
        fi
        MESSAGE="$SESSION_NAME, done"
        ;;

    *)
        MESSAGE="${TOOL_NAME:-Task} ${HOOK_TYPE}"
        ;;
esac

[[ -n "$MESSAGE" ]] && speak_message "$MESSAGE"
exit 0
