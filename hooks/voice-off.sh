#!/bin/bash
# Disable Claude Code TTS voice mode

# Announce before disabling
if [[ "$OSTYPE" == "darwin"* ]]; then
    say -r 200 "Voice mode disabled"
elif command -v espeak &>/dev/null; then
    espeak "Voice mode disabled"
elif command -v spd-say &>/dev/null; then
    spd-say "Voice mode disabled"
fi

# Small delay to let announcement finish before writing state
sleep 0.5

echo "0" > /tmp/claude-tts-enabled
echo "Voice mode disabled"
