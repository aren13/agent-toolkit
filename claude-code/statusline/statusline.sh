#!/usr/bin/env bash
# Claude Code statusline -- renders a compact, informative line at the bottom
# of the Claude Code TUI. Reads session JSON from stdin and prints a single
# formatted line to stdout.
#
# Wire it up in ~/.claude/settings.json:
#
#   "statusLine": {
#     "type": "command",
#     "command": "/absolute/path/to/statusline.sh"
#   }
#
# Each segment is independent -- remove or reorder the function calls in the
# main section to customize what you see.
#
# Requirements: bash 3.2+, jq, git, awk.
# No network calls. No secrets written anywhere. No files outside /tmp.

set -u

# ---------------------------------------------------------------------------
# Input
# ---------------------------------------------------------------------------

INPUT="$(cat)"

# Early exit if jq is missing so we at least print something useful.
if ! command -v jq >/dev/null 2>&1; then
    printf 'statusline: jq not found'
    exit 0
fi

# ---------------------------------------------------------------------------
# Parse shared fields once
# ---------------------------------------------------------------------------

MODEL_NAME="$(echo "$INPUT"      | jq -r '.model.display_name // ""')"
SESSION_ID="$(echo "$INPUT"      | jq -r '.session_id // ""')"
CWD="$(echo "$INPUT"             | jq -r '.workspace.current_dir // ""')"
TRANSCRIPT="$(echo "$INPUT"      | jq -r '.transcript_path // ""')"
TOTAL_INPUT="$(echo "$INPUT"     | jq -r '.context_window.total_input_tokens // 0')"
TOTAL_OUTPUT="$(echo "$INPUT"    | jq -r '.context_window.total_output_tokens // 0')"
USAGE_JSON="$(echo "$INPUT"      | jq    '.context_window.current_usage')"
USED_PCT="$(echo "$INPUT"        | jq -r '.context_window.used_percentage // empty')"
COST_USD="$(echo "$INPUT"        | jq -r '.cost.total_cost_usd // empty')"

SEPARATOR=" │ "
declare -a PARTS=()

# ---------------------------------------------------------------------------
# Segments -- each function appends zero or one entry to PARTS[]
# ---------------------------------------------------------------------------

segment_cwd() {
    [[ -z "$CWD" ]] && return
    PARTS+=("📁 $(basename "$CWD")")
}

segment_model() {
    [[ -z "$MODEL_NAME" ]] && return
    local short
    short="$(echo "$MODEL_NAME" \
        | sed -e 's/Claude //' \
              -e 's/Opus/🎭 Opus/' \
              -e 's/Sonnet/🎵 Sonnet/' \
              -e 's/Haiku/🎋 Haiku/')"
    PARTS+=("$short")
}

# Session duration is tracked via a per-session marker file in /tmp.
# First invocation writes the timestamp; subsequent invocations read it.
segment_duration() {
    [[ -z "$SESSION_ID" ]] && return
    local marker="/tmp/claude_session_${SESSION_ID}"
    local start now delta h m
    [[ -f "$marker" ]] || date +%s >"$marker"
    start="$(cat "$marker" 2>/dev/null || date +%s)"
    now="$(date +%s)"
    delta=$(( now - start ))
    h=$(( delta / 3600 ))
    m=$(( (delta % 3600) / 60 ))
    if (( h > 0 )); then
        PARTS+=("⏱ ${h}h${m}m")
    else
        PARTS+=("⏱ ${m}m")
    fi
}

# Turn counter -- counts user messages in the JSONL transcript, excluding
# synthetic tool_use_id entries that represent tool results.
segment_turns() {
    [[ -z "$TRANSCRIPT" || ! -f "$TRANSCRIPT" ]] && return
    local turns
    turns="$(awk '/"type":"user"/ && !/"tool_use_id"/ {c++} END{print c+0}' \
        "$TRANSCRIPT" 2>/dev/null)"
    [[ -n "$turns" && "$turns" != "0" ]] && PARTS+=("💬 ${turns}")
}

# Remaining context: back-computed from current_usage and used_percentage
# so it adapts to whatever the model's effective window actually is.
segment_remaining_context() {
    [[ "$USAGE_JSON" == "null" || -z "$USED_PCT" ]] && return
    local in_t cache_c cache_r used_t remaining_k
    in_t="$(echo      "$USAGE_JSON" | jq -r '.input_tokens // 0')"
    cache_c="$(echo   "$USAGE_JSON" | jq -r '.cache_creation_input_tokens // 0')"
    cache_r="$(echo   "$USAGE_JSON" | jq -r '.cache_read_input_tokens // 0')"
    used_t=$(( in_t + cache_c + cache_r ))
    remaining_k="$(awk -v u="$used_t" -v p="$USED_PCT" 'BEGIN{
        if (p > 0) printf "%d", (u * 100 / p - u) / 1000
        else       printf "0"
    }')"
    PARTS+=("🔋 ${remaining_k}k left")
}

# Cumulative tokens across the whole session, including cache reads/writes.
segment_tokens() {
    local cache_c cache_r total_in input_k output_k
    if [[ "$USAGE_JSON" != "null" ]]; then
        cache_c="$(echo "$USAGE_JSON" | jq -r '.cache_creation_input_tokens // 0')"
        cache_r="$(echo "$USAGE_JSON" | jq -r '.cache_read_input_tokens // 0')"
        total_in=$(( TOTAL_INPUT + cache_c + cache_r ))
    else
        total_in="$TOTAL_INPUT"
    fi
    [[ "$total_in" == "0" && "$TOTAL_OUTPUT" == "0" ]] && return
    input_k=$(( total_in / 1000 ))
    output_k=$(( TOTAL_OUTPUT / 1000 ))
    PARTS+=("⬇️ ${input_k}k ⬆️ ${output_k}k")
}

segment_cost() {
    [[ -z "$COST_USD" ]] && return
    local fmt
    fmt="$(printf '%.2f' "$COST_USD")"
    PARTS+=("💰 \$${fmt}")
}

# Git: branch, dirty count, ahead/behind tracking. Uses --no-optional-locks
# to avoid racing with concurrent git processes.
segment_git() {
    [[ -z "$CWD" ]] && return
    if [[ ! -d "$CWD/.git" ]] && \
       ! git -C "$CWD" rev-parse --git-dir >/dev/null 2>&1; then
        return
    fi
    local branch dirty_count dirty ab ahead behind tracking=""
    branch="$(git -C "$CWD" --no-optional-locks branch --show-current \
        2>/dev/null || echo detached)"
    dirty_count="$(git -C "$CWD" --no-optional-locks status --porcelain \
        2>/dev/null | wc -l | tr -d ' ')"
    if [[ "${dirty_count:-0}" -gt 0 ]] 2>/dev/null; then
        dirty="⚡${dirty_count}"
    else
        dirty="✨"
    fi
    ab="$(git -C "$CWD" --no-optional-locks rev-list --left-right --count \
        'HEAD...@{u}' 2>/dev/null)"
    if [[ -n "$ab" ]]; then
        ahead="$(echo "$ab"  | awk '{print $1}')"
        behind="$(echo "$ab" | awk '{print $2}')"
        [[ "$ahead"  != "0" ]] && tracking+=" ↑${ahead}"
        [[ "$behind" != "0" ]] && tracking+=" ↓${behind}"
    fi
    PARTS+=("🌿 ${branch} ${dirty}${tracking}")
}

# ---------------------------------------------------------------------------
# Render
# ---------------------------------------------------------------------------

segment_cwd
segment_model
segment_duration
segment_turns
segment_remaining_context
segment_tokens
segment_cost
segment_git

out=""
for i in "${!PARTS[@]}"; do
    if (( i == 0 )); then
        out="${PARTS[$i]}"
    else
        out="${out}${SEPARATOR}${PARTS[$i]}"
    fi
done

printf '%s' "$out"
