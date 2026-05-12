## TOOL_CHOSEN
osascript (AppleScript)

## REASONING
iMessage on macOS is scriptable via AppleScript through the Messages app, making osascript the most direct and reliable path for sending iMessages without requiring any third-party tools or browser automation. AppleScript has native access to the Messages app's send command and can target a recipient by email address or phone number, which aligns exactly with the task (mom@example.com). No additional dependencies, authentication flows, or UI automation is needed since Messages handles iCloud/Apple ID auth at the OS level.

## FIRST_COMMANDS
```
# 1. Verify Messages app is running (or let the script launch it)
osascript -e 'tell application "Messages" to get name'

# 2. Check available services (to confirm iMessage service is active)
osascript -e 'tell application "Messages" to get name of every service'

# 3. Send the iMessage via AppleScript
osascript -e '
tell application "Messages"
  set targetService to 1st service whose service type = iMessage
  set targetBuddy to buddy "mom@example.com" of targetService
  send "running late, be there in 15" to targetBuddy
end tell
'
```

## ESCALATION_PATH
If the AppleScript approach fails (e.g., buddy not found under that email, iMessage service inactive, or permission denied):
1. Try targeting by phone number if the email resolves to a phone in Contacts: replace `"mom@example.com"` with the phone number string (e.g., `"+15555550100"`).
2. If scripting access to Messages is blocked by macOS permissions, use the Accessibility/UI scripting fallback: open Messages via `open -a Messages`, use `mcp__playwright` or `mcp__peekaboo` to click compose, type the recipient and message via UI automation.
3. As a last resort, use `shortcuts run` with a Shortcuts automation that wraps a "Send Message" action, which can bypass some script restrictions.

## NOTES
- macOS may prompt for Automation permissions the first time osascript targets Messages — the user must click "Allow" in System Settings > Privacy & Security > Automation.
- The recipient email (`mom@example.com`) must be registered as an Apple ID or iMessage-enabled address; otherwise the message will fail silently or fall back to SMS (only if the Mac is paired with an iPhone via Continuity).
- If the Mac is not signed into iMessage, the script will error — the user must be logged in via Messages > Settings > iMessage.
- This approach does NOT require the contact to be in the macOS Contacts app as long as the email is a valid iMessage address.
