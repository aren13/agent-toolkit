# Workflow: Test Manually with Playwright

<required_reading>
**Read these reference files NOW:**
1. references/playwright-testing.md
2. references/ux-usability.md
</required_reading>

<process>
## Step 1: Launch Browser

Use Playwright MCP to open the target URL:

```
Use mcp__playwright__browser_navigate to navigate to [URL]
```

The browser will open in visible mode for interactive testing.

## Step 2: Capture Initial State

Take a snapshot of the page:

```
Use mcp__playwright__browser_snapshot to capture accessibility tree
```

This provides a text representation of all interactive elements.

## Step 3: Visual Inspection

Take a screenshot for documentation:

```
Use mcp__playwright__browser_take_screenshot
```

Observe:
- Layout renders correctly
- No broken images
- Fonts loaded properly
- No obvious visual issues

## Step 4: Test Navigation

Click through main navigation:

```
Use mcp__playwright__browser_click on navigation links
```

Verify:
- All nav links work
- Pages load without errors
- Back button works correctly
- Breadcrumbs (if present) are accurate

## Step 5: Test Forms

Find and test forms:

1. **Fill form fields:**
```
Use mcp__playwright__browser_type to fill inputs
```

2. **Submit form:**
```
Use mcp__playwright__browser_click on submit button
```

Test scenarios:
- Valid submission
- Invalid data (validation errors appear)
- Required fields (proper error messages)
- Empty submission

## Step 6: Test Interactive Elements

Test buttons, dropdowns, modals:

**Buttons:**
```
Use mcp__playwright__browser_click on buttons
```
- Verify action occurs
- Loading states appear
- Success/error feedback shown

**Dropdowns:**
```
Use mcp__playwright__browser_select_option
```
- Options display correctly
- Selection works

**Modals/Dialogs:**
- Opens correctly
- Can be closed (X button, Escape key, backdrop click)
- Focus trapped inside

## Step 7: Test Responsive Behavior

Resize browser to test breakpoints:

```
Use mcp__playwright__browser_resize with different widths
```

Common breakpoints:
- Mobile: 375px
- Tablet: 768px
- Desktop: 1024px
- Large desktop: 1440px

At each size, check:
- Layout adapts properly
- Navigation transforms (hamburger menu)
- Images resize
- Text remains readable
- No horizontal scroll

## Step 8: Check Console for Errors

Get console messages:

```
Use mcp__playwright__browser_console_messages
```

Look for:
- JavaScript errors (red)
- Warnings (yellow)
- Failed network requests
- Security warnings

## Step 9: Check Network Requests

Get network activity:

```
Use mcp__playwright__browser_network_requests
```

Look for:
- Failed requests (4xx, 5xx status)
- Slow requests
- Large payloads
- Unnecessary requests

## Step 10: Test Keyboard Navigation

Use keyboard to navigate:

```
Use mcp__playwright__browser_press_key with "Tab"
```

Verify:
- All interactive elements reachable
- Focus visible at all times
- Logical tab order
- No keyboard traps

Test Enter/Space on buttons:
```
Use mcp__playwright__browser_press_key with "Enter"
```

## Step 11: Test User Flows

Complete critical user journeys:

**Example: E-commerce checkout**
1. Navigate to product
2. Add to cart
3. View cart
4. Proceed to checkout
5. Fill shipping info
6. Complete order

**Example: Contact form**
1. Navigate to contact page
2. Fill form fields
3. Submit form
4. Verify confirmation

Document any issues encountered during flows.

## Step 12: Test Edge Cases

Test unusual scenarios:

- Very long text input
- Special characters in forms
- Rapid clicking
- Browser back/forward during processes
- Refresh during multi-step flow

## Step 13: Document Findings

For each issue found:

```markdown
## Issue: [Brief description]

**Location:** [URL or page area]
**Severity:** [Critical/High/Medium/Low]
**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected:** [What should happen]
**Actual:** [What actually happens]

**Screenshot:** [If applicable]

**Recommendation:** [How to fix]
```

## Step 14: Close Browser

When testing complete:

```
Use mcp__playwright__browser_close
```
</process>

<common_test_scenarios>
**Navigation:**
- Main nav links
- Footer links
- Logo returns to home
- 404 page (test invalid URL)

**Content:**
- Images load
- Videos play
- Downloads work
- External links open correctly

**Forms:**
- Validation messages
- Required field handling
- Submit success/failure
- Form reset

**E-commerce:**
- Add to cart
- Update quantities
- Remove items
- Checkout flow
- Payment handling

**Authentication:**
- Login flow
- Registration
- Password reset
- Logout

**Search:**
- Search functionality
- Results display
- No results handling
- Filters work
</common_test_scenarios>

<success_criteria>
Manual testing complete when:

- [ ] Initial page load observed and documented
- [ ] Main navigation tested
- [ ] Key forms tested (valid and invalid inputs)
- [ ] Interactive elements verified
- [ ] Responsive behavior checked at multiple breakpoints
- [ ] Console errors documented
- [ ] Network requests reviewed
- [ ] Keyboard navigation tested
- [ ] Critical user flows completed
- [ ] Edge cases explored
- [ ] All issues documented with reproduction steps
</success_criteria>
