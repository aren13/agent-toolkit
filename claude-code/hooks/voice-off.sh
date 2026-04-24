#!/usr/bin/env bash
# Disable Claude Code text-to-speech announcements.
# Announces the change first so the user hears confirmation, then flips state.

if [[ "$OSTYPE" == "darwin"* ]]; then
    say -r 200 "Voice mode disabled"
elif command -v espeak  >/dev/null 2>&1; then
    espeak "Voice mode disabled"
elif command -v spd-say >/dev/null 2>&1; then
    spd-say "Voice mode disabled"
fi

# Small delay so the announcement finishes before we stop reading state.
sleep 0.5

echo "0" > /tmp/claude-tts-enabled
echo "Voice mode disabled"
