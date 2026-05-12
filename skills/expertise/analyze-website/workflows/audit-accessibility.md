# Workflow: Audit Accessibility

<required_reading>
**Read these reference files NOW:**
1. references/accessibility.md
2. references/ux-usability.md
</required_reading>

<process>
## Step 1: Automated Scan

Run Lighthouse accessibility audit (included in PageSpeed Insights).

Note: Automated tools catch only 20-50% of accessibility issues. Manual testing is essential.

## Step 2: Keyboard Navigation Test

Use Playwright MCP to test keyboard-only navigation:

1. **Tab through the page** - Can you reach all interactive elements?
2. **Focus visibility** - Is it always clear which element has focus?
3. **Tab order** - Is the order logical (follows visual layout)?
4. **Keyboard traps** - Can you Tab away from all elements?
5. **Skip links** - Is there a "Skip to content" link?

Test key interactions:
- Buttons: Activate with Enter or Space
- Links: Activate with Enter
- Dropdowns: Open with Enter, navigate with arrows
- Modals: Trap focus inside, Escape to close

## Step 3: Heading Structure

Check heading hierarchy:

```
✅ Good:
H1 (single, page title)
  H2 (section)
    H3 (subsection)
  H2 (section)
    H3 (subsection)

❌ Bad:
H1
  H3 (skipped H2)
H2
H1 (multiple H1s)
```

Use Playwright snapshot to extract heading structure.

## Step 4: Image Accessibility

Check all images:

1. **Alt text present** - All `<img>` have `alt` attribute
2. **Alt text quality** - Describes content, not just "image"
3. **Decorative images** - Use `alt=""` or `role="presentation"`
4. **Complex images** - Charts/graphs have detailed descriptions

```html
<!-- Good -->
<img src="chart.png" alt="Sales increased 40% from Q1 to Q4 2024">

<!-- Bad -->
<img src="chart.png" alt="chart">
<img src="chart.png">  <!-- Missing alt -->
```

## Step 5: Color Contrast

Check text contrast ratios:

| Element | Minimum Ratio (AA) | Enhanced (AAA) |
|---------|-------------------|----------------|
| Normal text | 4.5:1 | 7:1 |
| Large text (18pt+) | 3:1 | 4.5:1 |
| UI components | 3:1 | 3:1 |

Tools: Lighthouse, axe DevTools, or browser DevTools color picker.

Also check:
- Color not sole means of conveying information
- Links distinguishable from surrounding text (not just color)

## Step 6: Form Accessibility

Test all forms:

1. **Labels** - Every input has associated `<label>`
2. **Required fields** - Clearly indicated (not just asterisk)
3. **Error messages** - Descriptive, associated with field
4. **Error recovery** - User can correct without re-entering all data

```html
<!-- Good -->
<label for="email">Email address (required)</label>
<input type="email" id="email" required aria-describedby="email-error">
<span id="email-error" role="alert">Please enter a valid email</span>

<!-- Bad -->
<input type="email" placeholder="Email">  <!-- No label -->
```

## Step 7: ARIA Usage

Check ARIA implementation:

1. **No ARIA is better than bad ARIA** - Native HTML preferred
2. **Required ARIA attributes** - All roles have required attributes
3. **Valid ARIA values** - Attribute values are valid
4. **Accessible names** - Interactive elements have names

Common issues:
- `role="button"` without keyboard handler
- `aria-hidden="true"` on focusable element
- Missing `aria-label` on icon buttons

## Step 8: Dynamic Content

Test dynamic updates:

1. **Live regions** - Updates announced to screen readers
2. **Focus management** - Focus moved appropriately after actions
3. **Loading states** - Progress indicated accessibly

```html
<!-- Good: Live region for status updates -->
<div aria-live="polite" aria-atomic="true">
  3 items added to cart
</div>
```

## Step 9: Media Accessibility

Check multimedia:

1. **Videos** - Captions available
2. **Audio** - Transcripts available
3. **Auto-play** - Can be paused/stopped
4. **Animations** - Respect `prefers-reduced-motion`

## Step 10: Mobile Accessibility

Test on mobile viewport:

1. **Touch targets** - Minimum 44x44px
2. **Zoom** - Page works at 200% zoom
3. **Orientation** - Works in portrait and landscape
4. **Text sizing** - Respects user text size preferences

## Step 11: Document Findings

Categorize by WCAG level:

**Level A (Minimum):**
- Non-text content has text alternatives
- Keyboard accessible
- No keyboard traps

**Level AA (Standard - legal requirement in many jurisdictions):**
- Contrast minimum 4.5:1
- Text resizable to 200%
- Multiple ways to find pages

**Level AAA (Enhanced):**
- Contrast enhanced 7:1
- Sign language for video
- Reading level

Report format:
```markdown
## Accessibility Audit

**WCAG 2.2 Compliance:** [Level A / AA / AAA]

### Critical (Level A violations)
- [Issue]: [Location] - [WCAG criterion]

### High (Level AA violations)
- [Issue]: [Location] - [WCAG criterion]

### Recommendations
- [Issue]: [Fix]
```
</process>

<anti_patterns>
Avoid:
- Relying solely on automated tools (miss 50-80% of issues)
- Skipping keyboard testing (critical for many users)
- Ignoring color contrast (affects low vision users)
- Using ARIA when native HTML works (adds complexity)
- Hiding content with CSS but leaving it focusable
</anti_patterns>

<success_criteria>
Accessibility audit complete when:

- [ ] Automated scan completed (Lighthouse/axe)
- [ ] Keyboard navigation fully tested
- [ ] Heading structure validated
- [ ] All images checked for alt text
- [ ] Color contrast verified
- [ ] Forms tested for labels and error handling
- [ ] ARIA usage validated
- [ ] Dynamic content accessibility verified
- [ ] Media accessibility checked
- [ ] Mobile accessibility tested
- [ ] Findings categorized by WCAG level
- [ ] Actionable recommendations provided
</success_criteria>
