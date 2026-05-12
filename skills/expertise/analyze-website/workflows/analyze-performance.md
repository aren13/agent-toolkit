# Workflow: Analyze Performance

<required_reading>
**Read these reference files NOW:**
1. references/performance.md
2. references/third-party-impact.md
3. references/content-quality.md (image optimization section)
</required_reading>

<process>
## Step 1: Capture Core Web Vitals

Use PageSpeed Insights for both lab and field data:

```
WebFetch: https://pagespeed.web.dev/analysis?url=[URL]
```

Record metrics:

| Metric | Target | Mobile | Desktop |
|--------|--------|--------|---------|
| LCP (Largest Contentful Paint) | <2.5s | | |
| INP (Interaction to Next Paint) | <200ms | | |
| CLS (Cumulative Layout Shift) | <0.1 | | |
| FCP (First Contentful Paint) | <1.8s | | |
| TTFB (Time to First Byte) | <800ms | | |

Note: INP replaced FID as of March 2024.

## Step 2: Analyze LCP Element

Use Playwright MCP to identify the LCP element:

1. Navigate to the page
2. The LCP element is typically:
   - Hero image
   - Large heading text
   - Background image
   - Video poster

Common LCP issues:
- **Slow server response** (TTFB >800ms)
- **Render-blocking resources** (CSS, JS in head)
- **Slow resource load** (unoptimized images)
- **Client-side rendering** (content built by JS)

## Step 3: Analyze CLS Issues

Use Playwright MCP to observe layout shifts:

1. Load page with network throttling (Slow 3G)
2. Watch for elements jumping/shifting
3. Common culprits:
   - Images without dimensions
   - Ads/embeds without reserved space
   - Web fonts causing FOIT/FOUT
   - Dynamic content injection

## Step 4: Analyze INP (Interaction Responsiveness)

Use Playwright MCP to test interactions:

1. Click buttons, links, form elements
2. Type in input fields
3. Observe responsiveness

Poor INP causes:
- Long JavaScript tasks (>50ms)
- Heavy event handlers
- Synchronous operations blocking main thread

## Step 5: Resource Analysis

Check network waterfall for:

**Render-blocking resources:**
- CSS in `<head>` without media queries
- JavaScript without `async` or `defer`

**Large resources:**
- Images >100KB (especially above fold)
- JavaScript bundles >200KB
- CSS files >50KB

**Slow resources:**
- Third-party scripts with high latency
- Resources from slow CDNs

## Step 6: Image Audit

Check image optimization:

1. **Format:** Are images WebP/AVIF? (not just JPEG/PNG)
2. **Size:** Are images sized appropriately? (not 2000px for 400px display)
3. **Lazy loading:** Images below fold should have `loading="lazy"`
4. **LCP image:** Should NOT be lazy loaded, should be preloaded

```html
<!-- Good: Preload LCP image -->
<link rel="preload" as="image" href="hero.webp">

<!-- Good: Lazy load below-fold images -->
<img src="product.webp" loading="lazy" width="400" height="300">
```

## Step 7: JavaScript Analysis

Check for JavaScript issues:

1. **Bundle size:** Total JS should be <300KB compressed
2. **Unused code:** Check Coverage in DevTools
3. **Long tasks:** Tasks >50ms block main thread
4. **Third-party impact:** Analytics, ads, widgets

## Step 8: Caching Analysis

Verify proper caching headers:

```
Cache-Control: public, max-age=31536000, immutable  (static assets)
Cache-Control: no-cache  (HTML)
```

Check:
- Static assets (JS, CSS, images) have long cache times
- HTML is not over-cached
- Service worker caching (if PWA)

## Step 9: Server Performance

Check TTFB and server response:

- TTFB >800ms indicates server issues
- Check for proper CDN usage
- Verify compression (gzip/brotli)

```
Content-Encoding: br  (or gzip)
```

## Step 10: Document Findings

Create performance report:

```markdown
## Performance Summary

**Overall Score:** [Lighthouse score]

### Core Web Vitals
- LCP: [value] ([pass/fail])
- INP: [value] ([pass/fail])
- CLS: [value] ([pass/fail])

### Top Issues
1. [Issue] - [Impact] - [Fix]
2. [Issue] - [Impact] - [Fix]
3. [Issue] - [Impact] - [Fix]

### Recommendations
- [Priority 1 recommendation]
- [Priority 2 recommendation]
- [Priority 3 recommendation]
```
</process>

<anti_patterns>
Avoid:
- Only testing desktop (mobile is usually worse)
- Only using lab data (field data shows real user experience)
- Ignoring third-party scripts (often biggest impact)
- Optimizing images without checking format (WebP/AVIF)
- Adding `loading="lazy"` to LCP image (makes it slower)
</anti_patterns>

<success_criteria>
Performance analysis complete when:

- [ ] Core Web Vitals captured for mobile AND desktop
- [ ] LCP element identified and optimized
- [ ] CLS sources identified
- [ ] INP tested with real interactions
- [ ] Image optimization audited
- [ ] JavaScript bundle analyzed
- [ ] Caching headers verified
- [ ] Third-party impact quantified
- [ ] Actionable recommendations provided with priority
</success_criteria>
