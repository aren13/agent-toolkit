#!/bin/bash
# Enable Claude Code TTS voice mode

echo "1" > /tmp/claude-tts-enabled

# Announce if on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    say -r 200 "Voice mode enabled" &
elif command -v espeak &>/dev/null; then
    espeak "Voice mode enabled" &
elif command -v spd-say &>/dev/null; then
    spd-say "Voice mode enabled" &
fi

echo "Voice mode enabled"
