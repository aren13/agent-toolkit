<overview>
Website performance directly impacts user experience, SEO rankings, and business metrics. Google's Core Web Vitals are the key metrics, with tools like Lighthouse, WebPageTest, and GTmetrix providing measurement and optimization guidance.
</overview>

<core_web_vitals>
## Core Web Vitals (2024-2025)

Three metrics that matter most for user experience and SEO:

| Metric | Target | Description |
|--------|--------|-------------|
| **LCP** (Largest Contentful Paint) | <2.5s | When main content becomes visible |
| **INP** (Interaction to Next Paint) | <200ms | Responsiveness to user input |
| **CLS** (Cumulative Layout Shift) | <0.1 | Visual stability during load |

**Note:** INP replaced FID (First Input Delay) in March 2024.

<metric name="LCP">
**What it measures:** Time until the largest content element (image, video, text block) is rendered.

**Good:** <2.5s | **Needs Improvement:** 2.5-4s | **Poor:** >4s

**Common causes of poor LCP:**
- Slow server response (high TTFB)
- Render-blocking CSS/JS
- Slow resource load (large images)
- Client-side rendering delays

**Fixes:**
- Optimize server response time
- Preload LCP image: `<link rel="preload" as="image" href="hero.webp">`
- Use optimized image formats (WebP/AVIF)
- Remove render-blocking resources
</metric>

<metric name="INP">
**What it measures:** Responsiveness to all user interactions (clicks, taps, keyboard).

**Good:** <200ms | **Needs Improvement:** 200-500ms | **Poor:** >500ms

**Common causes of poor INP:**
- Long JavaScript tasks (>50ms)
- Heavy event handlers
- Main thread blocking
- Too much JavaScript

**Fixes:**
- Break up Long Tasks with `requestIdleCallback`
- Defer non-critical JavaScript
- Use web workers for heavy computation
- Optimize event handlers
</metric>

<metric name="CLS">
**What it measures:** Unexpected layout shifts during page load.

**Good:** <0.1 | **Needs Improvement:** 0.1-0.25 | **Poor:** >0.25

**Common causes of poor CLS:**
- Images without dimensions
- Ads/embeds without reserved space
- Dynamically injected content
- Web fonts causing FOIT/FOUT

**Fixes:**
- Always include width/height on images
- Reserve space for ads/embeds
- Prefer transform animations over layout properties
- Use `font-display: optional` or preload fonts
</metric>
</core_web_vitals>

<tools>
## Performance Testing Tools

<tool name="PageSpeed Insights">
**URL:** https://pagespeed.web.dev/

**What it provides:**
- Lab data (Lighthouse simulation)
- Field data (real user data from Chrome UX Report)
- Core Web Vitals scores
- Specific optimization recommendations

**When to use:** First-line testing, combines lab and field data.

**Limitations:** Single URL at a time, no competitive comparison.
</tool>

<tool name="Lighthouse">
**URL:** Built into Chrome DevTools, or `npx lighthouse [URL]`

**What it provides:**
- Performance score (0-100)
- Accessibility, SEO, Best Practices audits
- Detailed diagnostics and opportunities
- Configurable throttling

**When to use:** Development workflow, CI/CD integration.

**CLI usage:**
```bash
npx lighthouse https://example.com --output=html --output-path=./report.html
```

**Throttling options:**
- Simulated throttling (default, faster)
- DevTools throttling (more accurate)
</tool>

<tool name="WebPageTest">
**URL:** https://www.webpagetest.org/

**What it provides:**
- Multi-location testing
- Real device testing
- Video recording of load
- Waterfall diagrams
- Competitive comparison

**When to use:** Deep analysis, testing from different locations/devices.

**Key features:**
- Test from 30+ global locations
- Mobile device emulation
- Filmstrip view for visual progress
- Connection throttling (3G, 4G, etc.)
</tool>

<tool name="GTmetrix">
**URL:** https://gtmetrix.com/

**What it provides:**
- Lighthouse-based scoring
- Historical tracking
- PDF reports
- Device simulation

**When to use:** Ongoing monitoring, client reports.

**Free tier:** Limited tests, basic features.
**Paid:** Monitoring, alerts, more locations.
</tool>

<tool name="Chrome DevTools">
**Performance panel:**
- Record runtime performance
- Identify Long Tasks
- Analyze main thread activity
- Memory profiling

**Network panel:**
- Request waterfall
- Throttling simulation
- Cache testing
- Request blocking
</tool>
</tools>

<optimization_strategies>
## Optimization Strategies

<strategy name="Critical Rendering Path">
Minimize time to first render:

1. Inline critical CSS
2. Defer non-critical CSS
3. Async/defer JavaScript
4. Preload key resources

```html
<!-- Preload critical resources -->
<link rel="preload" as="style" href="critical.css">
<link rel="preload" as="image" href="hero.webp">

<!-- Defer non-critical CSS -->
<link rel="stylesheet" href="styles.css" media="print" onload="this.media='all'">

<!-- Async/defer JS -->
<script src="analytics.js" async></script>
<script src="main.js" defer></script>
```
</strategy>

<strategy name="Image Optimization">
Images are often the biggest performance opportunity:

1. **Format:** Use WebP/AVIF (30-50% smaller than JPEG)
2. **Size:** Serve appropriately sized images
3. **Loading:** Lazy load below-fold images
4. **LCP:** Preload above-fold images

```html
<!-- Modern image with fallback -->
<picture>
  <source srcset="image.avif" type="image/avif">
  <source srcset="image.webp" type="image/webp">
  <img src="image.jpg" alt="Description" width="800" height="600" loading="lazy">
</picture>

<!-- Preload LCP image (don't lazy load!) -->
<link rel="preload" as="image" href="hero.webp">
```
</strategy>

<strategy name="JavaScript Optimization">
Reduce JavaScript impact:

1. **Bundle size:** Keep under 300KB compressed
2. **Code splitting:** Load only what's needed
3. **Tree shaking:** Remove unused code
4. **Defer loading:** Non-critical JS after page load

```javascript
// Dynamic import for code splitting
const module = await import('./heavy-feature.js');

// Defer non-critical initialization
if ('requestIdleCallback' in window) {
  requestIdleCallback(() => initAnalytics());
} else {
  setTimeout(() => initAnalytics(), 1);
}
```
</strategy>

<strategy name="Caching">
Proper caching headers reduce repeat visit load times:

```
# Static assets (versioned) - cache forever
Cache-Control: public, max-age=31536000, immutable

# HTML - always revalidate
Cache-Control: no-cache

# API responses - short cache
Cache-Control: public, max-age=60
```
</strategy>

<strategy name="Server Optimization">
Reduce Time to First Byte (TTFB):

- Use a CDN for static assets
- Enable compression (Brotli > Gzip)
- Optimize database queries
- Use edge caching
- Consider SSG/SSR strategies
</strategy>
</optimization_strategies>

<field_vs_lab>
## Field Data vs Lab Data

**Lab data (Lighthouse, WebPageTest):**
- Controlled environment
- Reproducible
- Good for debugging
- May not reflect real users

**Field data (CrUX, RUM):**
- Real user measurements
- Reflects actual experience
- Varies by user device/network
- Google uses for ranking

**Best practice:** Use both. Lab for debugging, field for truth.
</field_vs_lab>

<anti_patterns>
## Common Performance Anti-Patterns

- Loading all JavaScript upfront instead of code splitting
- Not using image formats like WebP/AVIF
- Lazy loading the LCP image (makes it slower)
- No preconnect for third-party origins
- Synchronous scripts in `<head>` blocking render
- Missing width/height on images (causes CLS)
- Over-reliance on client-side rendering
- Ignoring mobile performance
</anti_patterns>
