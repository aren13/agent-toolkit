<overview>
Content quality encompasses images, links, fonts, and overall content health. Proper optimization improves performance, SEO, and user experience.
</overview>

<image_optimization>
## Image Optimization

<format name="WebP">
**Compression:** 25-35% smaller than JPEG at same quality

**Support:** All modern browsers (95%+ globally)

**Use for:** Photos, complex images

```html
<picture>
  <source srcset="image.webp" type="image/webp">
  <img src="image.jpg" alt="Description">
</picture>
```
</format>

<format name="AVIF">
**Compression:** 50% smaller than JPEG, 20% smaller than WebP

**Support:** Chrome, Firefox, Safari 16+

**Use for:** Maximum compression when supported

```html
<picture>
  <source srcset="image.avif" type="image/avif">
  <source srcset="image.webp" type="image/webp">
  <img src="image.jpg" alt="Description">
</picture>
```
</format>

<format name="SVG">
**Use for:** Icons, logos, simple graphics

**Benefits:**
- Infinitely scalable
- Tiny file size
- Can be styled with CSS
- Can be animated

```html
<img src="icon.svg" alt="Icon">
<!-- Or inline for styling -->
<svg>...</svg>
```
</format>

<sizing>
**Responsive images:**
```html
<img src="image-800.jpg"
     srcset="image-400.jpg 400w,
             image-800.jpg 800w,
             image-1200.jpg 1200w"
     sizes="(max-width: 600px) 100vw,
            (max-width: 1200px) 50vw,
            800px"
     width="800"
     height="600"
     alt="Description">
```

**Always include width/height** to prevent CLS.
</sizing>

<lazy_loading>
**Below-fold images:**
```html
<img src="image.jpg" loading="lazy" alt="Description">
```

**Above-fold (LCP) images:**
- Do NOT lazy load
- Consider preload

```html
<link rel="preload" as="image" href="hero.webp">
```
</lazy_loading>

<tools>
**Image optimization tools:**
- Squoosh.app (browser-based)
- ImageOptim (macOS)
- TinyPNG/TinyJPG (web service)
- Sharp (Node.js library)
</tools>
</image_optimization>

<broken_links>
## Broken Links

**Impact:**
- Poor user experience
- SEO penalty
- Indicates neglected site

**Common causes:**
- Deleted pages
- Changed URLs
- External sites gone
- Typos in links

**Detection tools:**
- Screaming Frog (crawls site)
- Ahrefs Site Audit
- Dead Link Checker (free, web)
- Google Search Console (reports 404s from crawl)

**Fix strategies:**
1. Update link to new URL
2. Remove link if content gone
3. 301 redirect old URLs to new
4. Create useful 404 page for remaining cases

**Playwright check:**
```
browser_click on links
Check for 404 errors in console/network
```
</broken_links>

<font_optimization>
## Font Optimization

<strategy name="Subset">
Include only needed characters:
- Latin (~100 chars) vs Full (~2000+ chars)
- Can reduce font size by 80%+

Tools: subfont, glyphhanger
</strategy>

<strategy name="font-display">
```css
@font-face {
  font-family: 'CustomFont';
  src: url('font.woff2') format('woff2');
  font-display: swap; /* Show fallback immediately, swap when loaded */
}
```

**Options:**
- `swap`: Show fallback, swap when ready (may cause FOUT)
- `fallback`: Brief invisible text, fallback if slow
- `optional`: Invisible briefly, fallback if not cached (best for performance)
</strategy>

<strategy name="Preload">
```html
<link rel="preload" as="font" type="font/woff2"
      href="font.woff2" crossorigin>
```

Preload critical fonts (especially for LCP text).
</strategy>

<strategy name="Self-host">
Instead of Google Fonts CDN:
1. Download fonts
2. Host on your server/CDN
3. Eliminates connection to fonts.googleapis.com
</strategy>

<strategy name="System fonts">
Zero load time using system fonts:

```css
font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
             Oxygen, Ubuntu, Cantarell, sans-serif;
```
</strategy>
</font_optimization>

<content_structure>
## Content Structure

**Heading hierarchy:**
```html
<h1>Page Title (single)</h1>
  <h2>Section</h2>
    <h3>Subsection</h3>
    <h3>Subsection</h3>
  <h2>Section</h2>
    <h3>Subsection</h3>
```

**Lists:**
- Use `<ul>` for unordered lists
- Use `<ol>` for ordered lists
- Use `<dl>` for definitions

**Semantic elements:**
```html
<article>  <!-- Self-contained content -->
<section>  <!-- Thematic grouping -->
<nav>      <!-- Navigation -->
<aside>    <!-- Tangentially related -->
<header>   <!-- Introductory content -->
<footer>   <!-- Footer content -->
<main>     <!-- Main content (single) -->
```
</content_structure>

<content_checklist>
## Content Quality Checklist

**Images:**
- [ ] All images have alt text
- [ ] Using modern formats (WebP/AVIF)
- [ ] Properly sized for display size
- [ ] Lazy loading below fold
- [ ] Width/height attributes present
- [ ] LCP image optimized and preloaded

**Links:**
- [ ] No broken internal links
- [ ] External links work
- [ ] Links have descriptive text (not "click here")
- [ ] Important links visible

**Fonts:**
- [ ] Using WOFF2 format
- [ ] Subsetted to needed characters
- [ ] Using font-display
- [ ] Critical fonts preloaded

**Structure:**
- [ ] Single H1 per page
- [ ] Logical heading hierarchy
- [ ] Semantic HTML elements used
- [ ] Content readable without CSS
</content_checklist>
