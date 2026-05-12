<overview>
Playwright MCP enables interactive browser testing directly within Claude. It provides real browser automation for manual testing, allowing observation of actual behavior, form submission, navigation testing, and visual verification.
</overview>

<playwright_mcp_overview>
## Playwright MCP Overview

**What it is:** Model Context Protocol server that gives Claude control over a real browser.

**Key benefits:**
- Visual verification of issues
- Interactive testing of user flows
- Real browser behavior (not simulation)
- Screenshots and snapshots for evidence

**Available MCP implementations:**
- Microsoft official: `@playwright/mcp@latest`
- ExecuteAutomation: `@executeautomation/playwright-mcp-server`
</playwright_mcp_overview>

<available_tools>
## Playwright MCP Tools

<tool name="browser_navigate">
**Purpose:** Navigate to a URL

**Usage:**
```
mcp__playwright__browser_navigate with url: "https://example.com"
```
</tool>

<tool name="browser_snapshot">
**Purpose:** Capture accessibility tree of page (text representation of all elements)

**Usage:**
```
mcp__playwright__browser_snapshot
```

**Returns:** Text representation of page with element references (refs) for interaction.
</tool>

<tool name="browser_take_screenshot">
**Purpose:** Capture visual screenshot

**Usage:**
```
mcp__playwright__browser_take_screenshot
```

**Options:**
- `fullPage: true` - Capture entire scrollable page
- `filename: "test.png"` - Save to specific file
</tool>

<tool name="browser_click">
**Purpose:** Click an element

**Usage:**
```
mcp__playwright__browser_click with element: "Submit button", ref: "button[ref]"
```

**Note:** Requires element description and ref from snapshot.
</tool>

<tool name="browser_type">
**Purpose:** Type text into an input

**Usage:**
```
mcp__playwright__browser_type with element: "Email input", ref: "input[ref]", text: "test@example.com"
```

**Options:**
- `submit: true` - Press Enter after typing
- `slowly: true` - Type character by character
</tool>

<tool name="browser_resize">
**Purpose:** Change browser viewport size

**Usage:**
```
mcp__playwright__browser_resize with width: 375, height: 667
```

Common sizes:
- Mobile: 375x667 (iPhone SE)
- Tablet: 768x1024 (iPad)
- Desktop: 1920x1080
</tool>

<tool name="browser_console_messages">
**Purpose:** Get console output

**Usage:**
```
mcp__playwright__browser_console_messages
```

**Options:**
- `level: "error"` - Only errors
- `level: "warning"` - Warnings and above
</tool>

<tool name="browser_network_requests">
**Purpose:** Get all network requests

**Usage:**
```
mcp__playwright__browser_network_requests
```

Returns list of requests with URLs, status codes, types.
</tool>

<tool name="browser_press_key">
**Purpose:** Press keyboard key

**Usage:**
```
mcp__playwright__browser_press_key with key: "Tab"
mcp__playwright__browser_press_key with key: "Enter"
mcp__playwright__browser_press_key with key: "Escape"
```
</tool>

<tool name="browser_select_option">
**Purpose:** Select dropdown option

**Usage:**
```
mcp__playwright__browser_select_option with element: "Country dropdown", ref: "select[ref]", values: ["US"]
```
</tool>

<tool name="browser_hover">
**Purpose:** Hover over element

**Usage:**
```
mcp__playwright__browser_hover with element: "Menu item", ref: "li[ref]"
```
</tool>

<tool name="browser_close">
**Purpose:** Close the browser

**Usage:**
```
mcp__playwright__browser_close
```
</tool>
</available_tools>

<testing_workflows>
## Common Testing Workflows

<workflow name="Initial Page Load Test">
1. Navigate to URL
2. Take snapshot to see structure
3. Take screenshot for visual reference
4. Check console for errors
5. Check network for failed requests

```
1. browser_navigate → URL
2. browser_snapshot → See page structure
3. browser_take_screenshot → Visual evidence
4. browser_console_messages → Check for JS errors
5. browser_network_requests → Check for failed resources
```
</workflow>

<workflow name="Form Testing">
1. Navigate to form page
2. Snapshot to identify form fields
3. Fill each field using type
4. Submit form
5. Verify success/error state

```
1. browser_navigate → form page
2. browser_snapshot → identify fields
3. browser_type → fill name field
4. browser_type → fill email field
5. browser_click → submit button
6. browser_snapshot → verify result
```
</workflow>

<workflow name="Navigation Testing">
1. Navigate to homepage
2. Snapshot to see navigation
3. Click through main nav items
4. Verify each page loads correctly
5. Test back button behavior

```
1. browser_navigate → homepage
2. browser_snapshot → see nav structure
3. browser_click → first nav item
4. browser_snapshot → verify page changed
5. browser_navigate_back → test back
```
</workflow>

<workflow name="Responsive Testing">
1. Navigate to page
2. Resize to mobile viewport
3. Snapshot and screenshot
4. Test mobile navigation
5. Resize to tablet, repeat
6. Resize to desktop, repeat

```
1. browser_navigate → URL
2. browser_resize → 375x667 (mobile)
3. browser_snapshot + screenshot
4. browser_click → hamburger menu
5. browser_resize → 768x1024 (tablet)
6. browser_snapshot + screenshot
```
</workflow>

<workflow name="Keyboard Navigation">
1. Navigate to page
2. Press Tab repeatedly
3. Note focus order
4. Test Enter/Space on buttons
5. Test Escape on modals

```
1. browser_navigate → URL
2. browser_press_key → Tab
3. browser_snapshot → see focus
4. Repeat Tab through interactive elements
5. browser_press_key → Enter (on button)
```
</workflow>
</testing_workflows>

<tips>
## Tips for Effective Testing

**Getting element refs:**
- Use browser_snapshot first
- Look for element refs in output
- Use descriptive element names in click/type calls

**When things don't work:**
- Check if element is visible (may be hidden)
- Check if element is in viewport (may need scroll)
- Wait for page to load completely
- Try browser_wait_for for dynamic content

**Evidence collection:**
- Screenshot before and after actions
- Capture console errors
- Note network failures
- Save snapshots for accessibility analysis

**Testing tips:**
- Say "playwright mcp" explicitly first time
- Take screenshots at key steps
- Check console after each major action
- Test both happy path and error cases
</tips>

<common_issues>
## Troubleshooting

**Browser doesn't open:**
- Browser installs automatically on first use
- If persistent, use `mcp__playwright__browser_install`

**Can't find element:**
- Take new snapshot (page may have changed)
- Check if element is visible
- May need to scroll into view

**Action doesn't work:**
- Element may be covered by overlay
- May need to close modal/popup first
- Dynamic content may need wait

**Timeout:**
- Page may be slow to load
- Use browser_wait_for for specific content
</common_issues>
