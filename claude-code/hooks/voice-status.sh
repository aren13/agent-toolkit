#!/usr/bin/env bash
# Report current TTS state.

STATE_FILE="/tmp/claude-tts-enabled"

if [[ -f "$STATE_FILE" ]] && [[ "$(cat "$STATE_FILE")" == "1" ]]; then
    echo "Voice mode is ON"
else
    echo "Voice mode is OFF"
fi
