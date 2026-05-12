---
description: Route automation task to the right tool, force a specific tool, or run help/doctor. Usage - /automate <task> | /automate <tool> <task> | /automate help | /automate doctor
---

Parse `$ARGUMENTS` for mode selection.

## Parsing rules

1. Strip leading whitespace from `$ARGUMENTS`
2. Take first word, lowercase it → check against:
   - **Special modes**: `help`, `doctor`
   - **Tool keywords** (canonical + aliases below)
3. If matched → handle that mode/tool, rest of string is the task (if any)
4. If not matched → entire `$ARGUMENTS` is the task, use `automation-tool-router` skill to route

## Tool keywords (canonical → aliases)

| Canonical | Aliases | Forces |
|---|---|---|
| `web` | browser, ab, agent-browser | agent-browser CLI |
| `gui` | mac, macos, peekaboo | Peekaboo CLI |
| `perf` | lighthouse, devtools, chrome-devtools | chrome-devtools-mcp |
| `scrape` | extract, firecrawl, fc | Firecrawl MCP |
| `stealth` | bypass, stagehand, sh | Stagehand |
| `e2e` | playwright, test, pw | Playwright CLI |
| `auto` | router, (empty) | Use skill to route |

## Special modes

### `help` mode (`/automate help`)

Print this reference card verbatim, then stop:

```
/automate <task>                 router picks tool
/automate web <task>             agent-browser  (default web)
/automate gui <task>             Peekaboo       (macOS GUI / browser fallback)
/automate perf <url>             chrome-devtools-mcp (Lighthouse, CWV)
/automate scrape <url>           Firecrawl      (extraction only)
/automate stealth <task>         Stagehand      (bot bypass)
/automate e2e <task>             Playwright CLI (network, multi-tab, PDF)
/automate auto <task>            explicit router
/automate doctor                 check tool installation status
/automate help                   this card

Aliases:
  web     → browser, ab, agent-browser
  gui     → mac, macos, peekaboo
  perf    → lighthouse, devtools, chrome-devtools
  scrape  → extract, firecrawl, fc
  stealth → bypass, stagehand, sh
  e2e     → playwright, test, pw

Examples:
  /automate find iPhone 17 Pro Max prices on amazon.com.tr
  /automate gui write iMessage "Selam Ayşe" to Ayşe
  /automate perf https://fazla.com
  /automate scrape https://news.ycombinator.com --fields title,points
  /automate stealth check ticket on cloudflare-protected.com
  /automate e2e log in to staging and verify dashboard <2s
```

### `doctor` mode (`/automate doctor`)

Run diagnostics via Bash tool, then present a compact table.

**Run these checks (use Bash tool, capture output):**

```bash
# CLI tools
which agent-browser >/dev/null 2>&1 && agent-browser --version 2>/dev/null || echo "MISSING"
npx playwright --version 2>/dev/null || echo "MISSING"
which peekaboo >/dev/null 2>&1 && peekaboo --version 2>/dev/null | head -1 || echo "MISSING"

# MCP servers
claude mcp list 2>/dev/null || echo "claude CLI not in PATH"

# Env vars
[ -n "${FIRECRAWL_API_KEY:-}" ] && echo "set" || echo "unset"
[ -n "${BROWSERBASE_API_KEY:-}" ] && echo "set" || echo "unset"
[ -n "${BROWSERBASE_PROJECT_ID:-}" ] && echo "set" || echo "unset"

# Chrome remote debug port (for chrome-devtools-mcp)
lsof -nP -iTCP:9222 -sTCP:LISTEN 2>/dev/null | head -1 || echo "not listening"
```

**Present results as table:**

```
| Component                 | Status        | Version/Note          | Fix                                                                  |
|---------------------------|---------------|-----------------------|----------------------------------------------------------------------|
| agent-browser             | ✓ / ❌        | <version>             | npm i -g agent-browser                                               |
| Playwright CLI            | ✓ / ❌        | <version>             | npm i -g @playwright/cli && npx playwright install chromium          |
| Peekaboo                  | ✓ / ⚠         | <version>             | brew install peekaboo                                                |
| chrome-devtools-mcp       | ✓ / ❌        | from `claude mcp list`| claude mcp add chrome-devtools npx -- chrome-devtools-mcp@latest     |
| Firecrawl MCP             | ✓ / ❌        | from `claude mcp list`| claude mcp add firecrawl npx -- -y firecrawl-mcp                     |
| Stagehand MCP             | ✓ / ❌        | from `claude mcp list`| claude mcp add stagehand npx -- @browserbasehq/mcp-server-browserbase|
| FIRECRAWL_API_KEY         | ✓ / ❌        | required for Firecrawl| export FIRECRAWL_API_KEY=<key from firecrawl.dev>                    |
| BROWSERBASE_API_KEY       | ✓ / ❌        | required for Stagehand| export BROWSERBASE_API_KEY=<key>                                     |
| BROWSERBASE_PROJECT_ID    | ✓ / ❌        | required for Stagehand| export BROWSERBASE_PROJECT_ID=<id>                                   |
| Chrome :9222 debug port   | ✓ / ⚠         | for chrome-devtools   | google-chrome --remote-debugging-port=9222                           |
```

End with: "X/10 checks passed" and bullet list of any actionable fixes (red ❌ items only).

If a tool's MCP isn't connected AND the user hasn't asked about it, mark as ⚠ not ❌ — it's optional until needed.

## Behavior by mode (tool keywords)

**Mode 1 — Router (no tool keyword or `auto`):**
- Load `automation-tool-router` skill
- Pick best tool for task
- Execute

**Mode 2 — Forced tool + task:**
- Skip routing logic, use specified tool directly
- Apply that tool's standard workflow (see below)
- If tool fails, mention it and offer fallback per skill escalation rules

**Mode 3 — Forced tool, no task:**
- Ask: "Tool: <tool>. What's the task?"
- Wait for response, then execute

## Tool-specific workflows (when forced)

### web (agent-browser)
```bash
agent-browser open <url>
agent-browser snapshot -i              # @e refs
agent-browser click @e1 / fill @e2 "..." / screenshot
```

### gui (Peekaboo)
```bash
peekaboo see --app <App> --annotate    # identify B1, T2 IDs
peekaboo click --on B3 --app <App>
peekaboo type "..." --app <App>
peekaboo press <key> --app <App>
peekaboo hotkey --keys "cmd,c"
```
For iMessage — **prefer AppleScript over Peekaboo**. No visible window needed, no element detection, deterministic. Peekaboo v3 beta times out on Messages.app's compose sheet and the window often lands offscreen.
```bash
osascript <<'EOF'
tell application "Messages"
    set targetService to 1st service whose service type = iMessage
    set targetBuddy to buddy "<email-or-phone>" of targetService
    send "<message>" to targetBuddy
end tell
EOF
```
Recipient must be a handle (email or phone), not a contact name. Peekaboo fallback only if AppleScript fails (e.g., service not configured).

### perf (chrome-devtools-mcp)
1. Ensure Chrome on `--remote-debugging-port=9222`
2. `mcp__chrome-devtools__navigate_page` to URL
3. `performance_start_trace(reload=true, autoStop=true)`
4. `performance_analyze_insight` for LCPBreakdown / CLSCulprits / INPBreakdown
5. Report Core Web Vitals + bottlenecks

### scrape (Firecrawl)
- Single URL → `firecrawl_scrape` (markdown default)
- Multiple pages → `firecrawl_crawl`
- Structured fields → `firecrawl_extract` with schema
- No clicks/interaction — if needed, suggest `/automate web` instead

### stealth (Stagehand)
- Requires `BROWSERBASE_API_KEY` + `BROWSERBASE_PROJECT_ID`
- Use only after `web` or `e2e` blocked
- Natural language `act()` / `extract()` / `observe()` API

### e2e (Playwright CLI)
```bash
playwright-cli snapshot                # ref-based
playwright-cli click @e1 / fill / pdf / network-intercept
```
Use over `web` when needing: network intercept, multi-tab, PDF, existing Playwright fixtures.

## Edge cases

- `/automate auto <task>` → same as `/automate <task>` (explicit router)
- Tool keyword that doesn't match → treat as task, route normally
- `$ARGUMENTS` empty → ask "What do you want to automate? (or `help` / `doctor`)"
- Task mentions URL but tool is `gui` → confirm: "GUI mode targets macOS apps. Did you mean `/automate web`?"

## Args:
$ARGUMENTS
