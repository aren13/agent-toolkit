#!/usr/bin/env bash
# Enable Claude Code text-to-speech announcements.
# Creates the state file read by stop-notify.sh.

echo "1" > /tmp/claude-tts-enabled

if [[ "$OSTYPE" == "darwin"* ]]; then
    say -r 200 "Voice mode enabled" &
elif command -v espeak  >/dev/null 2>&1; then
    espeak "Voice mode enabled" &
elif command -v spd-say >/dev/null 2>&1; then
    spd-say "Voice mode enabled" &
fi

echo "Voice mode enabled"
