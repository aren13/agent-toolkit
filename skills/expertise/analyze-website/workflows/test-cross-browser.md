# Workflow: Test Cross-Browser Compatibility

<required_reading>
**Read these reference files NOW:**
1. references/browser-compatibility.md
</required_reading>

<process>
## Step 1: Identify Target Browsers

Determine which browsers to test based on:
- Target audience analytics
- Project requirements
- Browser market share

**Default browser matrix (2024-2025):**

| Browser | Versions | Priority |
|---------|----------|----------|
| Chrome | Latest, Latest-1 | High |
| Safari | Latest, Latest-1 | High (esp. for iOS) |
| Firefox | Latest, Latest-1 | Medium |
| Edge | Latest | Medium |
| Samsung Internet | Latest | Medium (mobile) |

## Step 2: Test in Primary Browser (Chrome)

Use Playwright MCP with default Chrome:

```
Use mcp__playwright__browser_navigate to [URL]
```

Document baseline behavior:
- Layout renders correctly
- All features work
- No console errors

## Step 3: Safari Testing

Safari has unique behaviors to check:

**CSS issues:**
- Flexbox gap support (recent)
- CSS grid differences
- -webkit- prefixes still needed for some properties
- backdrop-filter behavior

**JavaScript issues:**
- Date parsing differences
- fetch() behavior nuances
- Web APIs availability

**Common Safari-specific issues:**
- Position: fixed in scrollable containers
- 100vh including browser chrome
- Input styling differences
- Smooth scrolling behavior

Test with:
- Safari on macOS
- Safari on iOS (mobile Safari has additional quirks)

## Step 4: Firefox Testing

Firefox differences to check:

**CSS:**
- Scrollbar styling (different syntax)
- Grid subgrid support (Firefox led here)
- Container queries behavior

**JavaScript:**
- console.log() output format
- DevTools behavior

**Common Firefox issues:**
- Number input spinner styling
- Select dropdown styling
- overflow-y: overlay (not supported)

## Step 5: Edge Testing

Modern Edge is Chromium-based, so mostly Chrome-compatible.

Check:
- Any Microsoft-specific integrations
- Edge-specific features if used
- Performance on Windows

## Step 6: Feature Detection

Check for proper feature detection instead of browser detection:

**Good (feature detection):**
```javascript
if ('IntersectionObserver' in window) {
  // Use IntersectionObserver
} else {
  // Fallback
}
```

**Bad (browser detection):**
```javascript
if (navigator.userAgent.includes('Safari')) {
  // Safari-specific code
}
```

## Step 7: CSS Compatibility

Check modern CSS features:

| Feature | Chrome | Safari | Firefox | Edge |
|---------|--------|--------|---------|------|
| Container queries | ✅ | ✅ | ✅ | ✅ |
| :has() selector | ✅ | ✅ | ✅ | ✅ |
| Subgrid | ✅ | ✅ | ✅ | ✅ |
| View Transitions | ✅ | ❌ | ❌ | ✅ |
| @layer | ✅ | ✅ | ✅ | ✅ |
| color-mix() | ✅ | ✅ | ✅ | ✅ |

For unsupported features, check:
- Fallbacks provided
- @supports used for progressive enhancement
- Prefixes where needed

## Step 8: JavaScript Compatibility

Check modern JS features:

| Feature | Support Notes |
|---------|--------------|
| ES2022+ | Generally good in modern browsers |
| Top-level await | Supported in modules |
| Private class fields | Widely supported now |
| Nullish coalescing (??) | Supported |
| Optional chaining (?.) | Supported |

For older browser support:
- Check if transpilation/polyfills needed
- Verify bundle targets

## Step 9: Web API Compatibility

Check API usage:

| API | Notes |
|-----|-------|
| Intersection Observer | Widely supported |
| Resize Observer | Widely supported |
| Web Share API | Limited on desktop |
| Web Bluetooth | Chrome/Edge mainly |
| Web USB | Chrome/Edge mainly |

## Step 10: Form Compatibility

Test form elements across browsers:

- Input types (date, time, color, range)
- Validation messages (browser-specific)
- Autofill behavior
- Mobile keyboard types

## Step 11: Testing Without Local Browsers

If you don't have all browsers locally, use:

**BrowserStack/LambdaTest:**
- Cloud-based cross-browser testing
- Real devices and browsers

**Online tools:**
- Screenshots: browsershots.org
- Testing: crossbrowsertesting.com

**User agent simulation:**
- Not reliable for actual rendering
- Only for quick checks

## Step 12: Document Findings

Report format:
```markdown
## Cross-Browser Compatibility Report

### Browser Matrix Tested
| Browser | Version | OS | Status |
|---------|---------|-----|--------|
| Chrome | 120 | macOS | ✅ |
| Safari | 17 | macOS | ⚠️ Minor issues |
| Firefox | 121 | Windows | ✅ |
| Edge | 120 | Windows | ✅ |

### Issues Found

#### Safari
- [Issue 1]: [Description] - [Fix]
- [Issue 2]: [Description] - [Fix]

#### Firefox
- [Issue 1]: [Description] - [Fix]

### Recommendations
1. Add CSS prefix for [feature] in Safari
2. Add fallback for [feature] in older browsers
3. Test on iOS Safari specifically
```
</process>

<anti_patterns>
Avoid:
- Only testing in Chrome (Safari/Firefox have differences)
- Browser detection instead of feature detection
- Forgetting mobile browsers (Safari iOS, Samsung Internet)
- Ignoring older browser versions if in support matrix
- Assuming Chromium-based browsers are identical
- Not testing actual devices when possible
</anti_patterns>

<success_criteria>
Cross-browser testing complete when:

- [ ] Target browser matrix defined
- [ ] Chrome baseline documented
- [ ] Safari tested (desktop and mobile ideally)
- [ ] Firefox tested
- [ ] Edge tested
- [ ] CSS compatibility checked
- [ ] JavaScript compatibility verified
- [ ] Form elements tested
- [ ] Issues documented per browser
- [ ] Fixes/fallbacks recommended
</success_criteria>
