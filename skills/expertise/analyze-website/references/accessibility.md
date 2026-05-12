<overview>
Web accessibility ensures websites are usable by people with disabilities. WCAG 2.2 is the current standard, with Level AA being the common compliance target. Automated tools catch 20-50% of issues; manual testing is essential.
</overview>

<wcag_overview>
## WCAG 2.2 Overview

Web Content Accessibility Guidelines (WCAG) 2.2 released October 2023.

**Conformance Levels:**
| Level | Description | Common Target |
|-------|-------------|---------------|
| A | Minimum accessibility | Baseline |
| AA | Standard accessibility | Most requirements |
| AAA | Enhanced accessibility | Specific contexts |

**Four Principles (POUR):**
1. **Perceivable** - Information presentable in ways users can perceive
2. **Operable** - Interface components must be operable
3. **Understandable** - Information and UI must be understandable
4. **Robust** - Content must be robust enough for assistive technologies
</wcag_overview>

<key_requirements>
## Key WCAG Requirements

<requirement level="A" criterion="1.1.1">
**Non-text Content**
All images, icons, and non-text content must have text alternatives.

```html
<!-- Good -->
<img src="chart.png" alt="Sales grew 40% from Q1 to Q4">
<button aria-label="Close dialog"><svg>...</svg></button>

<!-- Bad -->
<img src="chart.png">
<img src="chart.png" alt="chart">
```
</requirement>

<requirement level="A" criterion="2.1.1">
**Keyboard Accessible**
All functionality available via keyboard.

Test: Tab through entire page, use Enter/Space on buttons.
</requirement>

<requirement level="A" criterion="2.1.2">
**No Keyboard Trap**
User can navigate away from any component using keyboard.

Common trap: Modal dialogs, embedded content.
</requirement>

<requirement level="AA" criterion="1.4.3">
**Contrast Minimum**
Text must have sufficient contrast with background.

| Text Type | Minimum Ratio |
|-----------|---------------|
| Normal text | 4.5:1 |
| Large text (18pt+ or 14pt bold) | 3:1 |
| UI components | 3:1 |
</requirement>

<requirement level="AA" criterion="1.4.4">
**Resize Text**
Text must be resizable to 200% without loss of functionality.
</requirement>

<requirement level="A" criterion="2.4.1">
**Bypass Blocks**
Provide mechanism to skip repeated content (skip links).

```html
<a href="#main-content" class="skip-link">Skip to main content</a>
```
</requirement>

<requirement level="A" criterion="2.4.2">
**Page Titled**
Pages have descriptive, unique titles.
</requirement>

<requirement level="A" criterion="4.1.2">
**Name, Role, Value**
All UI components have accessible name, role, and state.

```html
<!-- Button with accessible name -->
<button aria-label="Delete item">
  <svg aria-hidden="true">...</svg>
</button>

<!-- Input with label -->
<label for="email">Email</label>
<input type="email" id="email">
```
</requirement>
</key_requirements>

<testing_tools>
## Accessibility Testing Tools

<tool name="axe DevTools">
**Type:** Browser extension
**URL:** Chrome Web Store

**Strengths:**
- Zero false positives
- Detailed issue explanations
- WCAG criterion references
- Integration with CI/CD

**Limitations:** Automated only, misses ~50% of issues.
</tool>

<tool name="WAVE">
**Type:** Browser extension, web service
**URL:** https://wave.webaim.org/

**Strengths:**
- Visual overlay on page
- Shows heading structure
- Highlights errors in context
- Free

**Limitations:** Can be overwhelming on large pages.
</tool>

<tool name="Lighthouse">
**Type:** Built into Chrome DevTools
**URL:** Chrome DevTools > Lighthouse

**Strengths:**
- Combined with performance/SEO
- Automated scoring
- Part of standard workflow

**Limitations:** Basic checks only.
</tool>

<tool name="Screen Readers">
**Must test with actual screen readers:**

| Screen Reader | Platform | Cost |
|---------------|----------|------|
| VoiceOver | macOS/iOS | Free |
| NVDA | Windows | Free |
| JAWS | Windows | Paid |
| TalkBack | Android | Free |
</tool>
</testing_tools>

<manual_testing>
## Manual Testing Checklist

<test name="Keyboard Navigation">
1. Start at address bar
2. Press Tab repeatedly
3. Verify:
   - All interactive elements reachable
   - Focus visible at all times
   - Logical order
   - Can activate buttons/links with Enter/Space
   - Can escape from all components
</test>

<test name="Heading Structure">
1. Extract all headings
2. Verify:
   - Single H1 per page
   - Logical hierarchy (no skipped levels)
   - Headings describe content
</test>

<test name="Forms">
1. Tab through form
2. Verify:
   - Labels associated with inputs
   - Required fields indicated
   - Error messages descriptive and associated
   - Can submit with keyboard
</test>

<test name="Images">
1. Review all images
2. Verify:
   - All have alt text
   - Alt text is descriptive (not "image")
   - Decorative images have empty alt
</test>

<test name="Color">
1. Check contrast ratios
2. Verify:
   - Text meets 4.5:1 (normal) or 3:1 (large)
   - Color not sole indicator of meaning
   - Links distinguishable without color
</test>

<test name="Dynamic Content">
1. Interact with dynamic features
2. Verify:
   - Updates announced to screen readers (live regions)
   - Focus managed appropriately
   - Loading states accessible
</test>
</manual_testing>

<common_issues>
## Common Accessibility Issues

<issue name="Missing alt text">
**Impact:** Screen reader users can't understand images
**Fix:** Add descriptive alt text to all meaningful images

```html
<img src="product.jpg" alt="Red sneakers with white sole, side view">
```
</issue>

<issue name="Poor color contrast">
**Impact:** Low vision users can't read text
**Fix:** Ensure 4.5:1 minimum contrast ratio

Use tools: WebAIM Contrast Checker, DevTools color picker
</issue>

<issue name="Missing form labels">
**Impact:** Screen reader users don't know what to enter
**Fix:** Associate labels with inputs

```html
<label for="email">Email address</label>
<input type="email" id="email" name="email">
```
</issue>

<issue name="Keyboard inaccessible">
**Impact:** Keyboard-only users can't use site
**Fix:** Ensure all interactive elements focusable and operable

```html
<!-- Bad: div acting as button -->
<div onclick="submit()">Submit</div>

<!-- Good: actual button -->
<button onclick="submit()">Submit</button>
```
</issue>

<issue name="Missing focus indicators">
**Impact:** Keyboard users don't know where they are
**Fix:** Never remove :focus styles without replacement

```css
/* Bad */
*:focus { outline: none; }

/* Good */
*:focus-visible {
  outline: 2px solid #0066cc;
  outline-offset: 2px;
}
```
</issue>

<issue name="Inaccessible modals">
**Impact:** Focus escapes, content trapped
**Fix:** Trap focus in modal, return focus on close

```javascript
// Trap focus in modal
modal.addEventListener('keydown', (e) => {
  if (e.key === 'Tab') {
    // Keep focus within modal
  }
  if (e.key === 'Escape') {
    closeModal();
  }
});
```
</issue>
</common_issues>

<aria>
## ARIA Usage

**First rule of ARIA:** Don't use ARIA if native HTML works.

```html
<!-- Prefer native HTML -->
<button>Click me</button>

<!-- Over ARIA role -->
<div role="button" tabindex="0">Click me</div>
```

**Common ARIA patterns:**

```html
<!-- Icon button needs label -->
<button aria-label="Close">
  <svg aria-hidden="true">...</svg>
</button>

<!-- Live region for dynamic updates -->
<div aria-live="polite" aria-atomic="true">
  Item added to cart
</div>

<!-- Expanded/collapsed state -->
<button aria-expanded="false" aria-controls="menu">Menu</button>
<ul id="menu" hidden>...</ul>

<!-- Required field -->
<input aria-required="true">

<!-- Error state -->
<input aria-invalid="true" aria-describedby="error">
<span id="error">Please enter a valid email</span>
```
</aria>

<mobile_accessibility>
## Mobile Accessibility

- **Touch targets:** Minimum 44x44px (Apple) or 48x48dp (Material)
- **Zoom:** Don't disable with `user-scalable=no`
- **Orientation:** Support both portrait and landscape
- **Spacing:** Adequate space between touch targets
</mobile_accessibility>
