# Workflow: Run Full Site Audit

<required_reading>
**Read these reference files for comprehensive coverage:**
1. references/performance.md
2. references/accessibility.md
3. references/security.md
4. references/seo.md
5. references/tools-comparison.md
</required_reading>

<process>
## Step 1: Initial Reconnaissance

Navigate to the site with Playwright MCP to observe initial load:

```
Use Playwright MCP to navigate to [URL]
```

Observe:
- Initial page load behavior
- Any console errors or warnings
- Visual layout and responsiveness
- Obvious issues (broken images, layout shifts)

Take a snapshot for baseline documentation.

## Step 2: Automated Performance Scan

Run Lighthouse via PageSpeed Insights or CLI:

```bash
# If Lighthouse CLI available
npx lighthouse [URL] --output=json --output=html --output-path=./lighthouse-report
```

Or use WebFetch to get PageSpeed Insights results:
- Desktop: `https://pagespeed.web.dev/analysis?url=[URL]`
- Mobile: `https://pagespeed.web.dev/analysis?url=[URL]&form_factor=mobile`

Capture Core Web Vitals:
- LCP (Largest Contentful Paint): Target <2.5s
- INP (Interaction to Next Paint): Target <200ms
- CLS (Cumulative Layout Shift): Target <0.1

## Step 3: Accessibility Audit

Run Lighthouse accessibility audit (included in Step 2).

For deeper analysis, use Playwright MCP to:
1. Check keyboard navigation (Tab through all interactive elements)
2. Verify focus indicators are visible
3. Check color contrast on key elements
4. Verify images have alt text
5. Test form labels and error messages

Document WCAG violations by level (A, AA, AAA).

## Step 4: Security Headers Scan

Use WebFetch to check security headers:
- SecurityHeaders.com: `https://securityheaders.com/?q=[URL]`
- Mozilla Observatory: `https://developer.mozilla.org/en-US/observatory`

Key headers to verify:
- Content-Security-Policy (CSP)
- Strict-Transport-Security (HSTS)
- X-Content-Type-Options
- X-Frame-Options
- Referrer-Policy
- Permissions-Policy

## Step 5: SEO Analysis

Check with Lighthouse SEO audit (from Step 2).

Manually verify via Playwright MCP:
1. Page title and meta description present
2. Heading hierarchy (single H1, logical structure)
3. Canonical URL set
4. robots.txt accessible
5. sitemap.xml accessible

For structured data:
- Google Rich Results Test: `https://search.google.com/test/rich-results?url=[URL]`

## Step 6: Mobile/Responsive Testing

Use Playwright MCP to test at different viewports:
- Mobile: 375x667 (iPhone SE)
- Tablet: 768x1024 (iPad)
- Desktop: 1920x1080

At each viewport, check:
- Layout adapts properly
- Text is readable without zooming
- Touch targets are adequate (min 44x44px)
- No horizontal scrolling
- Images scale appropriately

## Step 7: Content Quality Check

Use Playwright MCP to check:
1. All images load (no broken images)
2. Links work (click through key navigation)
3. Forms function (fill and submit test)
4. Media plays (if applicable)

Check for console errors:
```
Use Playwright MCP browser_console_messages to check for JavaScript errors
```

## Step 8: Third-Party Impact Assessment

Using browser network panel or Playwright:
1. Count third-party requests
2. Identify slow-loading scripts
3. Note any blocking resources

Common third parties to look for:
- Analytics (Google Analytics, etc.)
- Tag managers
- Social widgets
- Advertising scripts
- Chat widgets

## Step 9: Compile Findings

Organize findings by severity:

**Critical** (fix immediately):
- Security vulnerabilities
- Broken core functionality
- WCAG A violations

**High** (fix soon):
- Core Web Vitals failures
- WCAG AA violations
- Major SEO issues

**Medium** (plan to fix):
- Performance optimizations
- Minor accessibility issues
- Best practice violations

**Low** (nice to have):
- Polish items
- Suggestions

## Step 10: Generate Report

Create summary with:
1. Executive summary (overall health)
2. Scores by category (Performance, Accessibility, SEO, Security)
3. Top 5 priority issues
4. Detailed findings by category
5. Recommendations with effort estimates
</process>

<success_criteria>
Full audit complete when:

- [ ] Site loaded and initial observations captured
- [ ] Lighthouse/PageSpeed audit completed
- [ ] Core Web Vitals documented (LCP, INP, CLS)
- [ ] Accessibility issues identified with WCAG references
- [ ] Security headers analyzed and graded
- [ ] SEO fundamentals verified
- [ ] Mobile/responsive behavior tested at 3+ viewports
- [ ] Console errors documented
- [ ] Third-party impact assessed
- [ ] Findings prioritized by severity
- [ ] Report generated with actionable recommendations
</success_criteria>
