# Workflow: Audit SEO

<required_reading>
**Read these reference files NOW:**
1. references/seo.md
2. references/content-quality.md
</required_reading>

<process>
## Step 1: Automated SEO Scan

Run Lighthouse SEO audit (included in PageSpeed Insights).

Check Lighthouse SEO score and specific issues flagged.

## Step 2: Meta Tags Analysis

Use Playwright MCP to check essential meta tags:

**Required:**
```html
<title>Unique, descriptive title (50-60 chars)</title>
<meta name="description" content="Compelling description (150-160 chars)">
<meta name="viewport" content="width=device-width, initial-scale=1">
```

**Recommended:**
```html
<link rel="canonical" href="https://example.com/page">
<meta name="robots" content="index, follow">
<html lang="en">
```

**Social/Open Graph:**
```html
<meta property="og:title" content="Title">
<meta property="og:description" content="Description">
<meta property="og:image" content="https://example.com/image.jpg">
<meta property="og:url" content="https://example.com/page">
<meta name="twitter:card" content="summary_large_image">
```

Check each page for:
- Unique title (not duplicated across pages)
- Unique description
- Correct canonical URL
- Language attribute

## Step 3: Heading Structure

Verify heading hierarchy:

1. **Single H1** - One per page, describes page content
2. **Logical hierarchy** - H1 → H2 → H3, no skipping levels
3. **Keyword usage** - Primary keywords in H1, secondary in H2s
4. **Descriptive** - Headings describe section content

Use Playwright snapshot to extract all headings.

## Step 4: Structured Data

Test structured data:

```
WebFetch: https://search.google.com/test/rich-results?url=[URL]
```

Common schema types:
- Organization/LocalBusiness
- Product
- Article/BlogPosting
- BreadcrumbList
- FAQ
- HowTo
- Event
- Review

Check:
- Valid JSON-LD syntax
- Required properties present
- Recommended properties included
- No errors or warnings

## Step 5: Crawlability

Check robots.txt:
```
[URL]/robots.txt
```

Verify:
- Not blocking important pages
- Sitemap location specified
- No sensitive paths exposed

Check sitemap.xml:
```
[URL]/sitemap.xml
```

Verify:
- Valid XML format
- All important pages included
- Recently updated
- URLs match canonical URLs

## Step 6: URL Structure

Evaluate URL patterns:

**Good URLs:**
```
/products/blue-widget
/blog/2024/seo-best-practices
/about-us
```

**Bad URLs:**
```
/page?id=12345
/products/item.php?cat=3&pid=456
/p/1234567890abcdef
```

Check for:
- Descriptive slugs
- Lowercase, hyphens (not underscores)
- No session IDs or tracking parameters in canonical
- HTTPS everywhere
- Trailing slash consistency

## Step 7: Internal Linking

Analyze internal link structure:

1. **Orphan pages** - Pages with no internal links
2. **Deep pages** - Pages requiring many clicks to reach
3. **Anchor text** - Descriptive, not "click here"
4. **Broken links** - 404s on internal links

Ideal: Important pages reachable within 3 clicks from homepage.

## Step 8: Image SEO

Check image optimization:

1. **Alt text** - Descriptive, includes keywords naturally
2. **File names** - Descriptive (blue-widget.jpg, not IMG_1234.jpg)
3. **File size** - Optimized for web
4. **Lazy loading** - Below-fold images lazy loaded

## Step 9: Mobile SEO

Verify mobile-friendliness:

1. **Viewport configured** - `<meta name="viewport">`
2. **Responsive design** - No horizontal scroll on mobile
3. **Readable text** - No pinch-to-zoom needed
4. **Tap targets** - Adequate spacing

Google prioritizes mobile-first indexing.

## Step 10: Page Speed (SEO Impact)

Core Web Vitals affect rankings:

- LCP <2.5s
- INP <200ms
- CLS <0.1

Pages failing Core Web Vitals may rank lower.

## Step 11: Document Findings

Report format:
```markdown
## SEO Audit

**Lighthouse SEO Score:** [score]/100

### Technical SEO
| Check | Status | Notes |
|-------|--------|-------|
| Meta title | ✅/❌ | [details] |
| Meta description | ✅/❌ | [details] |
| Canonical URL | ✅/❌ | [details] |
| robots.txt | ✅/❌ | [details] |
| sitemap.xml | ✅/❌ | [details] |
| Structured data | ✅/❌ | [details] |
| Mobile-friendly | ✅/❌ | [details] |

### Content SEO
| Check | Status | Notes |
|-------|--------|-------|
| H1 tag | ✅/❌ | [details] |
| Heading structure | ✅/❌ | [details] |
| Image alt text | ✅/❌ | [details] |
| Internal linking | ✅/❌ | [details] |

### Recommendations
1. [Priority fix]
2. [Priority fix]
3. [Priority fix]
```
</process>

<anti_patterns>
Avoid:
- Duplicate title tags across pages
- Missing or duplicate meta descriptions
- Multiple H1 tags per page
- Blocking CSS/JS in robots.txt (Google needs to render pages)
- Using images for text content
- Keyword stuffing
- Orphan pages with no internal links
</anti_patterns>

<success_criteria>
SEO audit complete when:

- [ ] Meta tags analyzed (title, description, canonical)
- [ ] Heading structure validated
- [ ] Structured data tested and validated
- [ ] robots.txt and sitemap.xml verified
- [ ] URL structure evaluated
- [ ] Internal linking analyzed
- [ ] Image SEO checked
- [ ] Mobile-friendliness verified
- [ ] Core Web Vitals impact noted
- [ ] Actionable recommendations provided
</success_criteria>
