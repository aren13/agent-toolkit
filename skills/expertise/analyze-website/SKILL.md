---
name: analyze-website
description: Comprehensive website analysis covering performance, accessibility, security, SEO, mobile, UX, and more. Full lifecycle - audit, test manually with Playwright, identify issues, generate reports, prioritize fixes. Uses popular tools like Lighthouse, axe, WebPageTest, and Playwright MCP for hands-on testing.
---

<essential_principles>
## How Website Analysis Works

Website analysis requires systematic evaluation across multiple dimensions. No single tool catches everything - combine automated scans with manual testing.

### 1. Automated First, Manual Second

Run automated tools to catch obvious issues quickly. Then use Playwright MCP for manual verification and edge cases that automation misses. Automated tools catch 20-50% of issues; manual testing catches the rest.

### 2. Prioritize by Impact

Not all issues are equal. Focus on:
- **Critical:** Security vulnerabilities, broken functionality, WCAG A violations
- **High:** Core Web Vitals failures, WCAG AA violations, major SEO issues
- **Medium:** Performance optimizations, minor accessibility issues
- **Low:** Best practice suggestions, polish items

### 3. Test Real Conditions

Lab data (Lighthouse) differs from field data (real users). Test on:
- Slow 3G connections
- Low-powered mobile devices
- Multiple browsers (Chrome, Firefox, Safari, Edge)
- Different viewport sizes

### 4. Verify Before Reporting

Every finding should be reproducible. Use Playwright MCP to demonstrate issues visually before including them in reports.
</essential_principles>

<intake>
**What would you like to do?**

1. Run full site audit (all areas)
2. Analyze performance (Core Web Vitals, load times)
3. Audit accessibility (WCAG compliance)
4. Audit security (headers, HTTPS, vulnerabilities)
5. Audit SEO (meta, structured data, crawlability)
6. Test manually with Playwright (interactive browser testing)
7. Test mobile/responsive design
8. Test cross-browser compatibility
9. Analyze third-party script impact
10. Generate analysis report
11. Prioritize fixes (triage by impact/effort)
12. Something else

**Provide the website URL and your selection.**
</intake>

<routing>
| Response | Workflow |
|----------|----------|
| 1, "full", "complete", "everything", "all" | `workflows/run-full-audit.md` |
| 2, "performance", "speed", "slow", "vitals", "LCP", "CLS" | `workflows/analyze-performance.md` |
| 3, "accessibility", "a11y", "WCAG", "screen reader" | `workflows/audit-accessibility.md` |
| 4, "security", "headers", "CSP", "HTTPS", "vulnerable" | `workflows/audit-security.md` |
| 5, "SEO", "meta", "structured data", "crawl" | `workflows/audit-seo.md` |
| 6, "manual", "Playwright", "interactive", "click", "test" | `workflows/test-manually.md` |
| 7, "mobile", "responsive", "phone", "tablet" | `workflows/test-mobile.md` |
| 8, "browser", "cross-browser", "Safari", "Firefox", "Edge" | `workflows/test-cross-browser.md` |
| 9, "third-party", "scripts", "tags", "external" | `workflows/analyze-third-parties.md` |
| 10, "report", "summary", "document", "findings" | `workflows/generate-report.md` |
| 11, "prioritize", "triage", "fix", "effort" | `workflows/prioritize-fixes.md` |
| 12, other | Clarify intent, then select workflow or references |

**After reading the workflow, follow it exactly.**
</routing>

<verification_loop>
## After Every Analysis Step

1. **Capture evidence** - Screenshots, console output, network logs
2. **Verify reproducibility** - Can you reproduce the issue?
3. **Document clearly** - What, where, why it matters, how to fix
4. **Cross-reference** - Does this issue appear in multiple tools?

Report findings as:
- "Performance: LCP 4.2s (should be <2.5s) - hero image not optimized"
- "Accessibility: Missing alt text on 12 images - WCAG 1.1.1 violation"
- "Security: CSP header missing - XSS risk"
</verification_loop>

<tools_available>
## Analysis Tools

**Performance:**
- Lighthouse (Chrome DevTools, CLI, or PageSpeed Insights)
- WebPageTest (detailed waterfall, multi-location)
- GTmetrix (Lighthouse-based with monitoring)
- Chrome DevTools Performance panel

**Accessibility:**
- axe DevTools (browser extension, zero false positives)
- WAVE (WebAIM, visual overlay)
- Lighthouse accessibility audit
- Manual keyboard/screen reader testing

**Security:**
- SecurityHeaders.com (header analysis)
- Mozilla Observatory (comprehensive scan)
- Google CSP Evaluator (CSP validation)
- Chrome DevTools Security panel

**SEO:**
- Lighthouse SEO audit
- Google Rich Results Test (structured data)
- Screaming Frog (crawl analysis)
- Google Search Console (field data)

**Manual Testing:**
- Playwright MCP (browser automation with Claude)
- Chrome DevTools (all panels)
- Browser responsive mode

**Cross-Browser:**
- BrowserStack / LambdaTest (cloud testing)
- Local browser installations
- Responsively App (side-by-side views)
</tools_available>

<reference_index>
## Domain Knowledge

All in `references/`:

**Core Analysis:**
- performance.md - Core Web Vitals, Lighthouse, optimization
- accessibility.md - WCAG 2.2, testing tools, patterns
- security.md - Headers, CSP, HTTPS, vulnerabilities
- seo.md - Meta tags, structured data, crawlability

**Testing:**
- playwright-testing.md - Manual browser testing with Playwright MCP
- mobile-responsive.md - Responsive design, touch, viewports
- browser-compatibility.md - Cross-browser testing strategies

**Specialized:**
- pwa.md - Service workers, manifest, offline
- javascript-health.md - Console errors, memory, profiling
- third-party-impact.md - External scripts, performance cost
- content-quality.md - Links, images, fonts
- ux-usability.md - Nielsen heuristics, forms, navigation

**Decision Support:**
- tools-comparison.md - When to use which tool
</reference_index>

<workflows_index>
## Workflows

All in `workflows/`:

| File | Purpose |
|------|---------|
| run-full-audit.md | Comprehensive analysis across all areas |
| analyze-performance.md | Core Web Vitals, load times, optimization |
| audit-accessibility.md | WCAG compliance testing |
| audit-security.md | Headers, HTTPS, vulnerability scanning |
| audit-seo.md | Meta, structured data, crawlability |
| test-manually.md | Interactive Playwright browser testing |
| test-mobile.md | Responsive design, mobile performance |
| test-cross-browser.md | Browser compatibility testing |
| analyze-third-parties.md | External script impact analysis |
| generate-report.md | Create findings report |
| prioritize-fixes.md | Triage issues by impact/effort |
</workflows_index>

<success_criteria>
A complete website analysis:

- [ ] All requested areas analyzed
- [ ] Automated tools run and results captured
- [ ] Manual verification with Playwright for key findings
- [ ] Issues documented with evidence and reproduction steps
- [ ] Findings prioritized by severity/impact
- [ ] Actionable recommendations provided
- [ ] Report generated (if requested)
</success_criteria>
