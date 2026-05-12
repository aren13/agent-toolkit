---
name: automation-tool-router
description: Pick the right browser or GUI automation tool — do not run automation directly, route to the correct tool first. Use when the user asks to automate a browser, scrape a website, run E2E tests, fill forms, take screenshots, profile web performance, intercept network traffic, generate PDFs from pages, control macOS apps or windows, bypass bot detection, or extract data from web pages. Triggers on keywords - browser automation, web scraping, E2E testing, UI testing, headless browser, screenshot automation, form fill, click automation, page automation, playwright, puppeteer, peekaboo, macOS automation, GUI automation, web testing, Lighthouse, Core Web Vitals, perf profiling, Firecrawl, Stagehand, agent-browser.
---

# Automation Tool Router

**Default to `agent-browser` for web. Escalate only when blocked. Peekaboo is the universal last-resort.**

Quick commands: `/automate help` (reference card) | `/automate doctor` (diagnostics)

## Decision matrix

| Need | Tool | Why |
|---|---|---|
| Default browser automation | **agent-browser** | ~200–400 tokens/page, 5.7x more efficient than playwright-mcp, CLI (zero MCP schema cost) |
| Existing Playwright suites, network intercept, PDF gen, multi-tab | **Playwright CLI** | Depth + still CLI, no MCP schema bloat |
| Perf profiling, Core Web Vitals, heap snapshots, Lighthouse | **chrome-devtools-mcp** | DevTools Protocol access |
| Scriptable Apple apps (Messages, Mail, Calendar, Reminders, Notes, Music, Finder, Contacts) | **AppleScript via `osascript`** | Direct scripting interface, no window needed, deterministic |
| Non-scriptable macOS apps, custom UI, native dialogs | **Peekaboo** | OS-level events when AppleScript can't reach |
| Bot detection bypass, stealth scraping | **Stagehand** | Anti-detection built-in |
| Pure data extraction, markdown/JSON output | **Firecrawl** | Read-only, no interaction overhead |
| **All web tools failed** (Cloudflare, weird auth, Electron, native dialog) | **Peekaboo (browser fallback)** | OS-level events, indistinguishable from human |

## Default workflow (agent-browser)

```bash
agent-browser open <url>
agent-browser snapshot -i              # @e refs
agent-browser click @e1 / fill @e2 "..." / screenshot
agent-browser screenshot --annotate    # vision overlay
```

Flags: `--persistent` (keep session) · `--headed` (show window) · `--executable-path` (system Chrome)

## Escalation order

1. Try `agent-browser` first
2. Hit a wall? Identify it:
   - Network/multi-tab/PDF → Playwright CLI
   - Perf trace → chrome-devtools-mcp
   - Bot wall → Stagehand
   - Just data, no clicks → Firecrawl
3. **Last resort: Peekaboo** — drives Safari/Chrome via OS events. Slower but unblockable. Use when:
   - Cloudflare Turnstile / hCaptcha won't pass any web automation
   - Native macOS auth dialog (not web modal)
   - Electron app or hybrid native/web workflow

## Peekaboo browser fallback pattern

```bash
peekaboo app launch "Safari" --open https://example.com
peekaboo see --app Safari --annotate --path /tmp/page.png
peekaboo click --on B3 --app Safari
peekaboo type "user@example.com" --app Safari
peekaboo press tab --app Safari
peekaboo type "password" --app Safari --return
```

## Native macOS apps — prefer AppleScript

For scriptable Apple apps (Messages, Mail, Calendar, Reminders, Notes, Music, Finder, Safari, Contacts), `osascript` is the right tool. It hits the app's scripting interface directly — no window required, no element detection, deterministic. Peekaboo is for non-scriptable apps or when AppleScript can't reach what you need (custom UI, third-party Electron apps, native dialogs).

**Why this matters for Messages specifically:** Peekaboo v3.0.0-beta3 times out on `peekaboo see` after Messages.app's compose sheet opens, and the main window often lands on an offscreen secondary display. AppleScript sidesteps both.

**Send iMessage:**
```bash
osascript <<'EOF'
tell application "Messages"
    set targetService to 1st service whose service type = iMessage
    set targetBuddy to buddy "<email-or-phone>" of targetService
    send "<message>" to targetBuddy
end tell
EOF
```
Recipient must be a handle (email/phone), not a contact display name. Resolve names via Contacts first if needed:
```bash
osascript -e 'tell application "Contacts" to get value of email of person "Arda Eren"'
```

**Other native-app patterns:** Mail (`make new outgoing message`), Calendar (`make new event`), Reminders (`make new reminder`), Notes (`make new note`), Finder (`reveal`, `select`). Check Script Editor → File → Open Dictionary for an app's scripting vocabulary, or web-search "AppleScript <app> <action>".

**Escalation:** AppleScript first → Peekaboo if the app isn't scriptable or the action needs cursor/keystroke fidelity.

## Anti-patterns

- ❌ Reaching for `playwright-mcp` by default — schema alone costs ~13.7K tokens before any work
- ❌ Using Peekaboo for normal browser automation — slower, less precise than agent-browser, only escalate
- ❌ Using Firecrawl when interaction needed — it's extraction-only
- ❌ Loading multiple browser MCPs simultaneously — schema costs stack
- ❌ Using `chrome-devtools-mcp` for general automation — overkill, only for perf
- ❌ Using Peekaboo for scriptable Apple apps (Messages, Mail, Calendar, etc.) — AppleScript is faster, deterministic, and doesn't require a visible window. Peekaboo only when the app isn't scriptable.

## Install reference

```bash
# Default (always have it)
npm install -g agent-browser

# Existing Playwright depth
npm install -g @playwright/cli && npx playwright install chromium

# Perf profiling — runs as MCP server
claude mcp add chrome-devtools npx -- chrome-devtools-mcp@latest
# Requires Chrome on --remote-debugging-port=9222

# Bot evasion — SDK or MCP server
claude mcp add stagehand npx -- @browserbasehq/mcp-server-browserbase
# Requires BROWSERBASE_API_KEY + BROWSERBASE_PROJECT_ID

# Pure extraction — MCP server
claude mcp add firecrawl npx -- -y firecrawl-mcp
# Requires FIRECRAWL_API_KEY (firecrawl.dev)

# macOS GUI / browser fallback
brew install peekaboo
# or: npx -y @steipete/peekaboo
```

## Live docs (run for current syntax)

```bash
# CLI tools
agent-browser --help
agent-browser <command> --help
playwright-cli --help          # or: npx playwright --help
peekaboo --help
peekaboo <command> --help

# MCP tools — list connected servers
/mcp

# Online refs (WebFetch when needed)
# - agent-browser:       https://github.com/vercel-labs/agent-browser
# - Playwright CLI:      https://playwright.dev/docs/cli
# - chrome-devtools-mcp: https://github.com/ChromeDevTools/chrome-devtools-mcp
# - Firecrawl MCP:       https://docs.firecrawl.dev/mcp
# - Stagehand:           https://docs.stagehand.dev
# - Peekaboo:            https://github.com/steipete/peekaboo
```

## Notes

- agent-browser is ~2 months old (2026); Windows broken (irrelevant on macOS)
- For long autonomous Rakun-style sessions, agent-browser's compact output compounds — 5.7x more cycles per context budget
- Peekaboo v3 (currently beta) handles full macOS GUI; v2 is screenshots only
