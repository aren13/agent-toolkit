## TOOL_CHOSEN
AppleScript via `osascript`

## REASONING
Messages is a scriptable Apple app with a direct iMessage scripting interface, placing it squarely in the `osascript` row of the decision matrix. The skill explicitly documents the exact AppleScript pattern for sending iMessages and calls out that Peekaboo v3.0.0-beta3 times out on `peekaboo see` after Messages.app's compose sheet opens — making AppleScript the only deterministic, window-free option here. The recipient handle `mom@example.com` is already in the correct form (email address), so no Contacts lookup is needed.

## FIRST_COMMANDS
```bash
osascript <<'EOF'
tell application "Messages"
    set targetService to 1st service whose service type = iMessage
    set targetBuddy to buddy "mom@example.com" of targetService
    send "running late, be there in 15" to targetBuddy
end tell
EOF
```

## ESCALATION_PATH
If `osascript` fails (e.g. Messages is not signed in to iMessage, the buddy handle is not found in the iMessage service, or macOS Automation permission is denied for the terminal):
1. Grant Automation permission: System Settings → Privacy & Security → Automation → allow Terminal (or Claude) to control Messages.
2. If `mom@example.com` is not a registered iMessage handle, resolve the phone number via Contacts: `osascript -e 'tell application "Contacts" to get value of phone of person whose name contains "Mom"'` and retry with the phone number.
3. Last resort: Peekaboo — launch Messages.app visually and drive the compose UI via OS-level events (`peekaboo app launch "Messages"`, `peekaboo click`, `peekaboo type`), accepting the risk of window-placement and timeout issues noted in the skill.

## NOTES
- Anti-patterns avoided: did NOT reach for Peekaboo first despite it being a "native macOS app" task — the skill explicitly flags this as an anti-pattern for scriptable apps and documents a known Peekaboo timeout bug specific to Messages.
- Did NOT use any browser tool (agent-browser, Playwright, Firecrawl) — this is a native OS messaging action with no web component.
- Env requirement: the Mac must be signed into iMessage in Messages.app, and the terminal running `osascript` must have Automation permission to control Messages (Privacy & Security → Automation).
- The recipient is provided as an email address (`mom@example.com`), which is a valid iMessage handle format — no name-resolution step needed.
