<overview>
Cross-browser compatibility ensures websites work correctly across different browsers and versions. Modern browsers are more compatible than ever, but differences still exist, particularly with Safari and older browser versions.
</overview>

<browser_market>
## Browser Market Share (2024-2025)

| Browser | Global Share | Notes |
|---------|-------------|-------|
| Chrome | ~65% | Dominant, Chromium-based |
| Safari | ~18% | Important for iOS/macOS |
| Edge | ~5% | Chromium-based |
| Firefox | ~3% | Independent engine |
| Samsung Internet | ~2% | Mobile, Chromium-based |

**Key insight:** Chromium-based browsers (Chrome, Edge, Samsung) share most behavior, but Safari and Firefox have unique quirks.
</browser_market>

<testing_priority>
## Browser Testing Priority

**Must test:**
1. Chrome (latest) - baseline
2. Safari (latest) - most differences
3. Firefox (latest) - some differences
4. Mobile Safari (iOS) - unique behaviors

**Should test:**
- Edge (latest) - usually same as Chrome
- Samsung Internet - if mobile audience significant

**Consider if in support matrix:**
- Older browser versions
- IE11 (rare, but some enterprise)
</testing_priority>

<feature_detection>
## Feature Detection (Not Browser Detection)

**Good: Feature detection**
```javascript
// Check if feature exists
if ('IntersectionObserver' in window) {
  // Use IntersectionObserver
} else {
  // Fallback
}

// CSS @supports
@supports (display: grid) {
  .container { display: grid; }
}

@supports not (gap: 1rem) {
  .item { margin: 0.5rem; }
}
```

**Bad: Browser detection**
```javascript
// Don't do this
if (navigator.userAgent.includes('Safari')) {
  // Safari-specific code
}
```

**Why feature detection:**
- Future-proof (new browsers get features)
- More accurate (user agents can be spoofed)
- Doesn't break when browser updates
</feature_detection>

<css_differences>
## CSS Compatibility Issues

<issue browser="Safari">
**Flexbox gap**
- Supported in Safari 14.1+
- Fallback: margin on items

**-webkit prefixes**
```css
.element {
  -webkit-backdrop-filter: blur(10px);
  backdrop-filter: blur(10px);
}
```

**100vh issues**
```css
/* Safari mobile includes browser chrome in vh */
height: 100vh; /* May be too tall */
height: 100dvh; /* Dynamic viewport height (modern) */
```
</issue>

<issue browser="Firefox">
**Scrollbar styling**
```css
/* Chrome/Safari */
::-webkit-scrollbar { width: 8px; }
::-webkit-scrollbar-thumb { background: #888; }

/* Firefox */
* {
  scrollbar-width: thin;
  scrollbar-color: #888 #f1f1f1;
}
```

**Select styling**
Firefox limits select dropdown styling more than Chrome.
</issue>

<issue browser="All">
**Feature support check:**
```css
@supports (property: value) {
  /* Use feature */
}
```

Common features to check:
- `container-type: inline-size` (container queries)
- `:has()` selector
- `subgrid`
- `color-mix()`
</issue>
</css_differences>

<js_differences>
## JavaScript Compatibility

**Generally safe in modern browsers:**
- ES2020+ features (optional chaining, nullish coalescing)
- Async/await
- Modules (import/export)
- Fetch API
- Promises

**Check support for:**
- New Web APIs (Web Share, Web Bluetooth)
- Intersection Observer (wide support now)
- Resize Observer (wide support now)

**Use polyfills when needed:**
```html
<script src="https://polyfill.io/v3/polyfill.min.js?features=IntersectionObserver"></script>
```
</js_differences>

<testing_tools>
## Cross-Browser Testing Tools

<tool name="BrowserStack">
**URL:** https://www.browserstack.com/

**Features:**
- 3500+ real devices/browsers
- Live interactive testing
- Automated testing
- Screenshots

**Pricing:** From $39/month

**When to use:** Comprehensive testing, real devices
</tool>

<tool name="LambdaTest">
**URL:** https://www.lambdatest.com/

**Features:**
- 3000+ browsers
- Faster session spin-up
- Competitive pricing
- Good CI/CD integration

**Pricing:** From $15/month

**When to use:** Budget-conscious, good enough coverage
</tool>

<tool name="Responsively App">
**URL:** https://responsively.app/

**Features:**
- Multiple viewports side-by-side
- Free
- Local testing

**Limitations:** Uses Chromium only
</tool>

<tool name="Local Browsers">
**Best for:**
- Quick testing
- Most common browsers
- Free

**Install:**
- Chrome, Firefox, Edge on Windows/Mac/Linux
- Safari on macOS only
- iOS Simulator for Safari iOS (Mac only)
</tool>
</testing_tools>

<common_safari_issues>
## Safari-Specific Issues

| Issue | Symptom | Fix |
|-------|---------|-----|
| Date parsing | `new Date('2024-01-15')` fails | Use `2024/01/15` or ISO format |
| Fixed position in scroll | Fixed elements jitter | Use `transform: translateZ(0)` |
| 100vh height | Includes browser chrome | Use `100dvh` or JS |
| Input zoom | Page zooms on input focus | Set `font-size: 16px` minimum |
| Backdrop filter | Doesn't work | Add `-webkit-backdrop-filter` |
| PWA limitations | No push notifications (iOS) | Accept limitation or native app |
</common_safari_issues>

<testing_checklist>
## Cross-Browser Checklist

**Visual:**
- [ ] Layout consistent across browsers
- [ ] Fonts render correctly
- [ ] Colors appear correctly
- [ ] Images display properly
- [ ] Animations work smoothly

**Functional:**
- [ ] Forms submit correctly
- [ ] JavaScript works without errors
- [ ] Navigation functions properly
- [ ] Modals/overlays work
- [ ] Scroll behavior correct

**CSS:**
- [ ] Flexbox/Grid layouts work
- [ ] Custom properties (--vars) work
- [ ] Media queries apply correctly
- [ ] Transitions/animations play

**Accessibility:**
- [ ] Focus styles visible
- [ ] Keyboard navigation works
- [ ] Screen reader compatibility
</testing_checklist>
