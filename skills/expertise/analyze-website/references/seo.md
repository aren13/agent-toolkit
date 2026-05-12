<overview>
SEO (Search Engine Optimization) ensures websites are discoverable and rank well in search results. Key areas include technical SEO (meta tags, structured data, crawlability) and content SEO (headings, quality, relevance).
</overview>

<technical_seo>
## Technical SEO Essentials

<element name="Title Tag">
**Purpose:** Primary heading in search results.

**Best practices:**
- Unique per page
- 50-60 characters
- Primary keyword near start
- Brand at end (optional)

```html
<title>Blue Widgets for Sale | Best Prices | WidgetStore</title>
```

**Common issues:**
- Too long (truncated in results)
- Duplicate across pages
- Missing or generic
</element>

<element name="Meta Description">
**Purpose:** Summary in search results (not a ranking factor, but affects CTR).

**Best practices:**
- 150-160 characters
- Compelling call to action
- Include target keywords
- Unique per page

```html
<meta name="description" content="Shop our selection of premium blue widgets. Free shipping on orders over $50. 30-day returns.">
```
</element>

<element name="Canonical URL">
**Purpose:** Tells search engines the preferred URL when duplicates exist.

```html
<link rel="canonical" href="https://example.com/products/blue-widget">
```

**Use when:**
- Same content accessible via multiple URLs
- URL parameters create duplicates
- HTTP/HTTPS or www/non-www versions
</element>

<element name="Language">
**Purpose:** Indicates page language for search engines.

```html
<html lang="en">

<!-- For multi-language sites -->
<link rel="alternate" hreflang="en" href="https://example.com/page">
<link rel="alternate" hreflang="es" href="https://example.com/es/page">
```
</element>

<element name="Viewport">
**Purpose:** Mobile-friendly declaration (affects mobile rankings).

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```
</element>
</technical_seo>

<heading_structure>
## Heading Structure

**Best practices:**
- Single H1 per page (page title)
- Logical hierarchy (H1 → H2 → H3)
- Keywords in headings naturally
- Descriptive, not decorative

```html
<!-- Good structure -->
<h1>Blue Widgets Buying Guide</h1>
  <h2>Types of Blue Widgets</h2>
    <h3>Standard Widgets</h3>
    <h3>Premium Widgets</h3>
  <h2>How to Choose</h2>
  <h2>Price Comparison</h2>

<!-- Bad structure -->
<h1>Welcome</h1>
<h3>Products</h3>  <!-- Skipped H2 -->
<h1>About Us</h1>  <!-- Multiple H1s -->
```
</heading_structure>

<structured_data>
## Structured Data (Schema.org)

**Purpose:** Helps search engines understand content, enables rich results.

**Format:** JSON-LD (recommended)

<schema type="Organization">
```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Company Name",
  "url": "https://example.com",
  "logo": "https://example.com/logo.png",
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "+1-555-555-5555",
    "contactType": "customer service"
  }
}
```
</schema>

<schema type="Product">
```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Blue Widget",
  "image": "https://example.com/widget.jpg",
  "description": "High-quality blue widget",
  "brand": {
    "@type": "Brand",
    "name": "WidgetCo"
  },
  "offers": {
    "@type": "Offer",
    "price": "29.99",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock"
  }
}
```
</schema>

<schema type="Article">
```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Article Title",
  "author": {
    "@type": "Person",
    "name": "Author Name"
  },
  "datePublished": "2024-01-15",
  "dateModified": "2024-01-20"
}
```
</schema>

<schema type="BreadcrumbList">
```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://example.com"},
    {"@type": "ListItem", "position": 2, "name": "Products", "item": "https://example.com/products"},
    {"@type": "ListItem", "position": 3, "name": "Blue Widget"}
  ]
}
```
</schema>

**Testing:**
- Google Rich Results Test: https://search.google.com/test/rich-results
- Schema.org Validator: https://validator.schema.org/
</structured_data>

<crawlability>
## Crawlability

<file name="robots.txt">
**Location:** https://example.com/robots.txt

**Purpose:** Tells crawlers which pages to access.

```
User-agent: *
Allow: /
Disallow: /admin/
Disallow: /private/

Sitemap: https://example.com/sitemap.xml
```

**Common issues:**
- Blocking CSS/JS (Google needs to render pages)
- Blocking important pages accidentally
- Not including sitemap reference
</file>

<file name="sitemap.xml">
**Location:** https://example.com/sitemap.xml

**Purpose:** Lists all indexable pages.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://example.com/page</loc>
    <lastmod>2024-01-15</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
</urlset>
```

**Best practices:**
- Include all important pages
- Update when content changes
- Submit to Google Search Console
</file>
</crawlability>

<url_structure>
## URL Structure

**Good URLs:**
```
https://example.com/products/blue-widget
https://example.com/blog/2024/seo-guide
https://example.com/about-us
```

**Bad URLs:**
```
https://example.com/page?id=12345
https://example.com/products/item.php?cat=3&pid=456
https://example.com/index.php?p=about
```

**Best practices:**
- Descriptive slugs with keywords
- Lowercase letters
- Hyphens between words (not underscores)
- Short and readable
- HTTPS always
- Consistent trailing slash usage
</url_structure>

<social_meta>
## Social Media Meta Tags

<tags type="Open Graph">
```html
<meta property="og:title" content="Page Title">
<meta property="og:description" content="Description">
<meta property="og:image" content="https://example.com/image.jpg">
<meta property="og:url" content="https://example.com/page">
<meta property="og:type" content="website">
```
</tags>

<tags type="Twitter Cards">
```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@username">
<meta name="twitter:title" content="Page Title">
<meta name="twitter:description" content="Description">
<meta name="twitter:image" content="https://example.com/image.jpg">
```
</tags>
</social_meta>

<seo_tools>
## SEO Analysis Tools

| Tool | Purpose | Cost |
|------|---------|------|
| Google Search Console | Indexing, performance, issues | Free |
| Lighthouse SEO Audit | Basic SEO checks | Free |
| Screaming Frog | Site crawl, technical SEO | Free (500 URLs) / £199/yr |
| Ahrefs | Backlinks, keywords, audits | Paid |
| Semrush | Comprehensive SEO suite | Paid |

**Free testing:**
- Rich Results Test: https://search.google.com/test/rich-results
- Mobile-Friendly Test: https://search.google.com/test/mobile-friendly
- PageSpeed Insights: https://pagespeed.web.dev/
</seo_tools>

<seo_checklist>
## SEO Checklist

**Technical:**
- [ ] Unique, descriptive title tags
- [ ] Meta descriptions on all pages
- [ ] Canonical URLs set
- [ ] robots.txt configured correctly
- [ ] sitemap.xml submitted
- [ ] HTTPS enabled
- [ ] Mobile-friendly

**Content:**
- [ ] Single H1 per page
- [ ] Logical heading hierarchy
- [ ] Alt text on images
- [ ] Internal linking structure

**Structured Data:**
- [ ] Organization schema
- [ ] Breadcrumbs
- [ ] Product/Article/FAQ as appropriate

**Performance:**
- [ ] Core Web Vitals passing
- [ ] Fast mobile loading
</seo_checklist>
