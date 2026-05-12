<overview>
Mobile-first design and responsive testing ensure websites work well across all device sizes. With mobile-first indexing, mobile performance directly impacts SEO rankings.
</overview>

<mobile_importance>
## Why Mobile Matters

- **Mobile-first indexing:** Google primarily uses mobile version for ranking
- **User share:** 50%+ of web traffic is mobile
- **UX expectations:** Users expect mobile-optimized experiences
- **Core Web Vitals:** Mobile metrics often worse than desktop
</mobile_importance>

<viewport_configuration>
## Viewport Configuration

**Required meta tag:**
```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

**What NOT to do:**
```html
<!-- Bad: Prevents user zoom (accessibility issue) -->
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">

<!-- Bad: Fixed width -->
<meta name="viewport" content="width=640">
```
</viewport_configuration>

<common_breakpoints>
## Common Breakpoints

| Breakpoint | Device Type | Examples |
|------------|-------------|----------|
| 320px | Small mobile | iPhone SE, older phones |
| 375px | Standard mobile | iPhone 12/13/14/15 mini |
| 390px | Large mobile | iPhone 14/15 |
| 768px | Tablet portrait | iPad |
| 1024px | Tablet landscape / Small desktop | iPad landscape |
| 1280px | Desktop | Standard monitors |
| 1440px | Large desktop | Large monitors |

**CSS approach:**
```css
/* Mobile first */
.container { padding: 1rem; }

/* Tablet and up */
@media (min-width: 768px) {
  .container { padding: 2rem; }
}

/* Desktop and up */
@media (min-width: 1024px) {
  .container { max-width: 1200px; margin: 0 auto; }
}
```
</common_breakpoints>

<touch_targets>
## Touch Target Size

**Minimum sizes:**
- Apple HIG: 44x44 points
- Material Design: 48x48 dp
- WCAG 2.5.5: 44x44 CSS pixels

**Implementation:**
```css
.button, .link, .clickable {
  min-height: 44px;
  min-width: 44px;
  padding: 12px 16px;
}

/* Ensure adequate spacing */
.nav-item + .nav-item {
  margin-top: 8px;
}
```

**Common issues:**
- Text links too small
- Buttons too close together
- Form inputs hard to tap
</touch_targets>

<mobile_navigation>
## Mobile Navigation Patterns

<pattern name="Hamburger Menu">
**When to use:** Many nav items, limited space

```html
<button aria-label="Open menu" aria-expanded="false" aria-controls="nav">
  <span class="hamburger-icon"></span>
</button>
<nav id="nav" hidden>
  <!-- Navigation items -->
</nav>
```

**Best practices:**
- Clear open/close states
- Trap focus when open
- Close on Escape key
- Close on backdrop click
</pattern>

<pattern name="Bottom Navigation">
**When to use:** App-like experience, 3-5 primary actions

**Best practices:**
- Max 5 items
- Icons with labels
- Clear active state
- Thumb-reachable
</pattern>

<pattern name="Tab Bar">
**When to use:** Content categories, quick switching

**Best practices:**
- Horizontally scrollable if many items
- Clear active indication
- Consistent positioning
</pattern>
</mobile_navigation>

<responsive_images>
## Responsive Images

**srcset for resolution switching:**
```html
<img src="image-800.jpg"
     srcset="image-400.jpg 400w,
             image-800.jpg 800w,
             image-1200.jpg 1200w"
     sizes="(max-width: 600px) 100vw,
            (max-width: 1200px) 50vw,
            800px"
     alt="Description">
```

**Art direction with picture:**
```html
<picture>
  <source media="(max-width: 600px)" srcset="mobile.jpg">
  <source media="(max-width: 1200px)" srcset="tablet.jpg">
  <img src="desktop.jpg" alt="Description">
</picture>
```
</responsive_images>

<mobile_performance>
## Mobile Performance Considerations

**Mobile devices have:**
- Less CPU power
- Less memory
- Potentially slower/unstable networks
- Battery constraints

**Optimization strategies:**
- Reduce JavaScript payload
- Lazy load below-fold images
- Use system fonts or subset web fonts
- Minimize third-party scripts
- Consider reduced motion preferences

```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation: none !important;
    transition-duration: 0.01ms !important;
  }
}
```
</mobile_performance>

<testing_tools>
## Mobile Testing Tools

<tool name="Chrome DevTools">
**Device Mode:**
- Simulate various devices
- Throttle CPU and network
- Touch simulation

**Limitations:**
- Simulated, not real device
- May miss device-specific bugs
</tool>

<tool name="Responsively App">
**URL:** https://responsively.app/

**Features:**
- Multiple devices side-by-side
- Synchronized scrolling/clicking
- Built-in device profiles
- Free and open source
</tool>

<tool name="BrowserStack / LambdaTest">
**Features:**
- Real device testing
- Many device/browser combinations
- Screenshot testing

**When to use:** Final verification on real devices
</tool>

<tool name="Playwright MCP">
**Usage:**
```
browser_resize with width: 375, height: 667
```

**Good for:**
- Quick responsive checks
- Interactive testing at different sizes
- Automated viewport testing
</tool>
</testing_tools>

<common_issues>
## Common Mobile Issues

<issue name="Horizontal Scroll">
**Cause:** Element wider than viewport

**Fixes:**
```css
* { box-sizing: border-box; }
img, video { max-width: 100%; height: auto; }
.container { overflow-x: hidden; }
```
</issue>

<issue name="Text Too Small">
**Cause:** Fixed font sizes

**Fixes:**
```css
body { font-size: 16px; } /* Minimum for mobile */
h1 { font-size: clamp(1.5rem, 4vw, 3rem); }
```
</issue>

<issue name="Tap Targets Too Small">
**Cause:** Desktop-sized buttons/links

**Fix:** Minimum 44x44px clickable area
</issue>

<issue name="Fixed Position Issues">
**Cause:** Mobile Safari viewport quirks

**Fix:**
```css
/* Instead of 100vh */
.full-height {
  height: 100dvh; /* Dynamic viewport height */
}
```
</issue>

<issue name="Keyboard Covers Input">
**Cause:** Input focus doesn't scroll properly

**Fix:** Ensure inputs scroll into view when focused
</issue>
</common_issues>

<mobile_checklist>
## Mobile Testing Checklist

- [ ] Viewport meta tag present
- [ ] No horizontal scroll
- [ ] Text readable without zoom (16px minimum)
- [ ] Touch targets adequate (44x44px)
- [ ] Navigation works (hamburger menu)
- [ ] Forms usable on mobile
- [ ] Images scale properly
- [ ] Performance acceptable (<3s LCP)
- [ ] Works in landscape orientation
- [ ] No content hidden off-screen
</mobile_checklist>
