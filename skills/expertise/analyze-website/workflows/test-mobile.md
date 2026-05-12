# Workflow: Test Mobile/Responsive

<required_reading>
**Read these reference files NOW:**
1. references/mobile-responsive.md
2. references/performance.md
</required_reading>

<process>
## Step 1: Configure Mobile Viewport

Use Playwright MCP to resize browser to mobile dimensions:

```
Use mcp__playwright__browser_resize with width: 375, height: 667 (iPhone SE)
```

Common mobile viewports:
- iPhone SE: 375x667
- iPhone 14: 390x844
- Pixel 7: 412x915
- Samsung Galaxy: 360x800

## Step 2: Test Mobile Layout

Navigate to the site and observe:

```
Use mcp__playwright__browser_navigate to [URL]
Use mcp__playwright__browser_snapshot
```

Check:
- Content fits within viewport (no horizontal scroll)
- Text is readable without zooming
- Images scale appropriately
- No elements cut off or overlapping

## Step 3: Test Mobile Navigation

Check mobile menu:

1. **Hamburger menu** - Icon visible and tappable
2. **Menu opens** - Full navigation accessible
3. **Menu closes** - Can close menu (X, backdrop, or gesture)
4. **Sub-navigation** - Nested menus work

```
Use mcp__playwright__browser_click on hamburger menu
Use mcp__playwright__browser_snapshot to see menu state
```

## Step 4: Test Touch Targets

Verify touch target sizes:

**Minimum: 44x44 pixels** (Apple HIG) or **48x48 dp** (Material Design)

Check:
- Buttons large enough to tap
- Links have adequate spacing
- Form inputs easy to tap
- No overlapping clickable areas

## Step 5: Test Forms on Mobile

Fill forms using mobile interaction:

```
Use mcp__playwright__browser_type in form fields
```

Check:
- Input fields accessible
- Keyboard type appropriate (email, number, tel)
- Labels visible when typing
- Error messages readable
- Submit button reachable

## Step 6: Test Tablet Viewport

Resize to tablet dimensions:

```
Use mcp__playwright__browser_resize with width: 768, height: 1024 (iPad)
```

Check:
- Layout adapts (may be different from mobile and desktop)
- Sidebar handling
- Grid layouts adjust columns
- Images resize appropriately

## Step 7: Test Orientation

Test landscape orientation:

```
Use mcp__playwright__browser_resize with width: 844, height: 390 (iPhone 14 landscape)
```

Check:
- Layout still usable in landscape
- No content cut off
- Modals/overlays still work

## Step 8: Mobile Performance

Mobile devices have less power and often slower networks.

Use PageSpeed Insights mobile mode:
```
WebFetch: https://pagespeed.web.dev/analysis?url=[URL]&form_factor=mobile
```

Key mobile metrics:
- LCP should be <2.5s even on 3G
- INP should be <200ms on slower devices
- Total page weight impacts mobile data usage

## Step 9: Test Viewport Meta Tag

Verify viewport is configured:

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

Issues:
- Missing viewport = desktop layout on mobile
- `user-scalable=no` = accessibility issue (prevents zoom)
- Fixed width = horizontal scroll

## Step 10: Test Media Queries

Verify CSS breakpoints work correctly:

Resize through common breakpoints:
- 320px (small mobile)
- 375px (standard mobile)
- 768px (tablet)
- 1024px (small desktop/large tablet)
- 1280px (desktop)
- 1440px (large desktop)

At each breakpoint, check:
- Layout changes appropriately
- No layout jumps or flashing
- All content accessible

## Step 11: Test Mobile-Specific Features

Check features that differ on mobile:

1. **Hover states** - Should have touch alternatives
2. **Sticky elements** - Don't obscure too much content
3. **Fixed headers** - Leave adequate scroll space
4. **Infinite scroll** - Footer still reachable
5. **Carousels** - Swipe gestures work

## Step 12: Document Findings

Report format:
```markdown
## Mobile/Responsive Audit

### Viewport Testing
| Viewport | Width | Status | Issues |
|----------|-------|--------|--------|
| Mobile (iPhone SE) | 375px | ✅/❌ | [issues] |
| Mobile (iPhone 14) | 390px | ✅/❌ | [issues] |
| Tablet (iPad) | 768px | ✅/❌ | [issues] |
| Tablet landscape | 1024px | ✅/❌ | [issues] |

### Mobile-Specific Issues
- [Issue 1]
- [Issue 2]

### Recommendations
1. [Fix 1]
2. [Fix 2]
```
</process>

<anti_patterns>
Avoid:
- Only testing one mobile viewport (test multiple)
- Forgetting landscape orientation
- Ignoring tablet breakpoints
- Touch targets too small
- Hover-only interactions on touch devices
- Viewport meta preventing zoom (accessibility issue)
- Ignoring mobile performance (slower devices/networks)
</anti_patterns>

<success_criteria>
Mobile testing complete when:

- [ ] Tested at least 3 mobile viewport sizes
- [ ] Tablet viewport tested
- [ ] Landscape orientation tested
- [ ] Mobile navigation works
- [ ] Touch targets adequate (44x44px minimum)
- [ ] Forms usable on mobile
- [ ] Mobile performance checked
- [ ] Viewport meta tag verified
- [ ] All breakpoints tested
- [ ] Issues documented with viewport information
</success_criteria>
