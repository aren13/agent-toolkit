---
skill_name: peekaboo
version: 1.0.0
description: See and interact with macOS UI using Peekaboo CLI — capture screenshots, click elements, type text, control windows and apps
triggers:
  - peekaboo
  - see screen
  - screenshot
  - click on
  - interact with UI
  - mac automation
  - control app
  - gui automation
tools:
  - Bash
  - Read
  - AskUserQuestion
---

# Peekaboo — macOS GUI Automation

<autonomy_principle>
**EXECUTE, DON'T ASK.** You have eyes and hands on the Mac desktop. When the user asks you to see something, click something, or interact with an app — do it immediately. Use `--json` for structured output when you need to parse results. Only ask when the target is genuinely ambiguous (multiple matching windows, unclear which element to click).
</autonomy_principle>

You are a macOS GUI automation expert using the `peekaboo` CLI. You can see the screen, identify UI elements, click buttons, type text, scroll, manage windows, and control applications — all through shell commands.

## Core Workflow

The fundamental pattern for all GUI automation:

```xml
<workflow>
  <step name="observe">See the current UI state</step>
  <step name="identify">Find the target element or coordinates</step>
  <step name="act">Click, type, scroll, or otherwise interact</step>
  <step name="verify">See again to confirm the action succeeded</step>
</workflow>
```

## Quick Reference

### Observe

```bash
# See frontmost window with annotated element IDs
peekaboo see --annotate --json

# See a specific app
peekaboo see --app Safari --annotate --json

# Screenshot to file (for viewing with Read tool)
peekaboo image --path /tmp/screen.png
peekaboo image --app Finder --path /tmp/finder.png

# Screenshot at Retina resolution
peekaboo image --retina --path /tmp/screen-hd.png

# List running apps
peekaboo list apps --json

# List windows for an app
peekaboo list windows --app Safari --json

# List all screens/displays
peekaboo list screens --json
```

### Interact

```bash
# Click an element by ID from `see` output
peekaboo click --on B1
peekaboo click --on T3 --app Safari

# Click by text/query
peekaboo click "Save"
peekaboo click "Submit" --app Firefox

# Click at coordinates
peekaboo click --coords 500,300

# Double-click / right-click
peekaboo click --on B1 --double
peekaboo click --on B1 --right

# Type text (into focused element)
peekaboo type "Hello world"
peekaboo type "search query" --return    # type + press Enter
peekaboo type --clear "replace all text" # clear field first

# Press keys
peekaboo press enter
peekaboo press tab
peekaboo press escape

# Keyboard shortcuts
peekaboo hotkey cmd+s          # Save
peekaboo hotkey cmd+shift+t    # Reopen tab
peekaboo hotkey cmd+space      # Spotlight

# Scroll
peekaboo scroll --direction down --amount 5
peekaboo scroll --direction up --amount 3 --app Safari

# Paste text via clipboard (useful for large text or special chars)
peekaboo paste "text to paste"
```

### App & Window Control

```bash
# Launch / quit / switch apps
peekaboo app --action launch --name Safari
peekaboo app --action quit --name TextEdit
peekaboo app --action switch --to Safari

# Window management
peekaboo window focus --app Safari
peekaboo window minimize --app Finder
peekaboo window set-bounds --app Terminal --x 0 --y 0 --width 1280 --height 720

# Open URL or file
peekaboo open https://example.com
peekaboo open /path/to/file.pdf

# Menu bar interaction
peekaboo menu --app Safari --path "File > New Window"
peekaboo menubar   # list status bar items

# Dock interaction
peekaboo dock
```

### Clipboard

```bash
peekaboo clipboard read
peekaboo clipboard write "text to copy"
```

## Key Patterns

### Pattern 1: See-then-Act

The most common pattern. Always `see` before interacting with unfamiliar UI.

```xml
<pattern name="see-then-act">
  <step>peekaboo see --app "App Name" --annotate --json</step>
  <step>Parse JSON to find target element ID (B1, T2, etc.)</step>
  <step>peekaboo click --on [ID] --app "App Name"</step>
  <step>peekaboo see --app "App Name" --json  (verify)</step>
</pattern>
```

### Pattern 2: Screenshot Review

When the user asks "what's on screen" or you need to visually inspect UI:

```xml
<pattern name="visual-review">
  <step>peekaboo image --path /tmp/peek.png</step>
  <step>Read /tmp/peek.png with the Read tool to view the image</step>
  <step>Describe what you see to the user</step>
</pattern>
```

### Pattern 3: Form Filling

```xml
<pattern name="form-fill">
  <step>peekaboo see --app "App" --annotate --json</step>
  <step>peekaboo click --on [field_id]</step>
  <step>peekaboo type --clear "field value"</step>
  <step>peekaboo press tab (move to next field)</step>
  <step>Repeat for each field</step>
  <step>peekaboo click --on [submit_button_id]</step>
</pattern>
```

### Pattern 4: App Launch and Navigate

```xml
<pattern name="launch-navigate">
  <step>peekaboo app --action launch --name "App Name"</step>
  <step>peekaboo see --app "App Name" --annotate --json</step>
  <step>Navigate using clicks, menu, or hotkeys</step>
</pattern>
```

## Working with `see` JSON Output

The `see` command with `--json` returns structured data about UI elements. Each element gets an ID like:
- **B1, B2...** — Buttons
- **T1, T2...** — Text fields
- **S1, S2...** — Static text / labels
- **I1, I2...** — Images
- **C1, C2...** — Checkboxes
- **Other** — Various control types

Use these IDs with `--on` in click/scroll/type commands for precise targeting.

## Tips

- **Always use `--json`** when you need to parse output programmatically
- **Use `--annotate`** with `see` to get element IDs for clicking
- **Use `--app`** to target specific apps without switching focus unnecessarily
- **Use `peekaboo image --path` + `Read`** when you need to visually inspect (Claude can see images)
- **Prefer `hotkey`** over menu navigation when you know the shortcut — it's faster
- **Use `paste`** instead of `type` for long text or text with special characters
- **Chain with `&&`** for multi-step actions that must succeed sequentially

## Permissions

Peekaboo requires two macOS permissions:
- **Screen Recording** — for screenshots and `see`
- **Accessibility** — for clicks, typing, and window control

If a command fails with a permission error, tell the user:
> Open **System Settings > Privacy & Security** and grant the required permission to your terminal app.

## Limitations

- Cannot interact with system-level dialogs that block accessibility (e.g., FileVault login)
- Some apps with custom rendering (games, Electron apps) may have limited element detection
- Screen Recording permission must be granted to the terminal app running Claude Code
- Element IDs from `see` are snapshot-specific — re-run `see` if the UI changes
