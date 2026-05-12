# Workflow: Generate Analysis Report

<required_reading>
**Read findings from previous analysis steps before generating report.**
</required_reading>

<process>
## Step 1: Gather All Findings

Collect results from completed audits:
- Performance metrics
- Accessibility issues
- Security findings
- SEO analysis
- Manual testing results
- Third-party impact

## Step 2: Create Executive Summary

Write a brief overview (2-3 paragraphs):
- Overall site health
- Most critical issues
- Key wins/positives
- Recommended priority actions

## Step 3: Calculate Scores

Summarize scores by category:

| Category | Score | Status |
|----------|-------|--------|
| Performance | [0-100] | 🟢/🟡/🔴 |
| Accessibility | [0-100] | 🟢/🟡/🔴 |
| SEO | [0-100] | 🟢/🟡/🔴 |
| Security | [A-F] | 🟢/🟡/🔴 |
| Best Practices | [0-100] | 🟢/🟡/🔴 |

Score interpretation:
- 🟢 90-100 / A-B: Good
- 🟡 50-89 / C: Needs Improvement
- 🔴 0-49 / D-F: Poor

## Step 4: Document Core Web Vitals

| Metric | Mobile | Desktop | Target | Status |
|--------|--------|---------|--------|--------|
| LCP | [val] | [val] | <2.5s | 🟢/🔴 |
| INP | [val] | [val] | <200ms | 🟢/🔴 |
| CLS | [val] | [val] | <0.1 | 🟢/🔴 |

## Step 5: Prioritize Issues

Categorize all findings:

### Critical (Fix Immediately)
Issues that:
- Break core functionality
- Create security vulnerabilities
- Cause WCAG A violations
- Severely impact user experience

### High Priority
Issues that:
- Fail Core Web Vitals
- Cause WCAG AA violations
- Significantly impact SEO
- Affect many users

### Medium Priority
Issues that:
- Could improve performance
- Are minor accessibility concerns
- Are SEO best practices
- Affect some users

### Low Priority
Issues that:
- Are nice-to-have improvements
- Are cosmetic issues
- Have minimal impact
- Are suggestions/enhancements

## Step 6: Create Detailed Findings

For each category, document:

```markdown
### Performance Findings

#### Issue: [Title]
- **Severity:** Critical/High/Medium/Low
- **Location:** [URL or page area]
- **Current:** [Current state]
- **Target:** [Target state]
- **Impact:** [User/business impact]
- **Recommendation:** [How to fix]
- **Effort:** Quick fix / Medium / Major work

[Repeat for each issue]
```

## Step 7: Add Visual Evidence

Include screenshots for key findings:
- Before/after comparisons
- Error states
- Layout issues
- Console errors

## Step 8: Create Action Plan

Organize fixes by effort and impact:

| Priority | Issue | Impact | Effort | Owner |
|----------|-------|--------|--------|-------|
| 1 | [issue] | High | Quick | [team] |
| 2 | [issue] | High | Medium | [team] |
| 3 | [issue] | Medium | Quick | [team] |

Quick wins (high impact, low effort) should be first.

## Step 9: Include Technical Recommendations

For each category, provide specific fixes:

**Performance:**
```html
<!-- Add preload for LCP image -->
<link rel="preload" as="image" href="hero.webp">

<!-- Defer non-critical JS -->
<script src="analytics.js" defer></script>
```

**Accessibility:**
```html
<!-- Add missing alt text -->
<img src="product.jpg" alt="Blue Widget - front view">

<!-- Add proper form labels -->
<label for="email">Email address</label>
<input type="email" id="email">
```

**Security:**
```
# Add these headers
Content-Security-Policy: default-src 'self'
Strict-Transport-Security: max-age=31536000
```

## Step 10: Format Final Report

Structure the report:

```markdown
# Website Analysis Report

**Site:** [URL]
**Date:** [Date]
**Analyst:** Claude

---

## Executive Summary
[2-3 paragraph overview]

## Scores Overview
[Score table]

## Core Web Vitals
[Metrics table]

## Critical Issues
[List with details]

## High Priority Issues
[List with details]

## Findings by Category

### Performance
[Detailed findings]

### Accessibility
[Detailed findings]

### Security
[Detailed findings]

### SEO
[Detailed findings]

## Action Plan
[Prioritized fixes table]

## Appendix
- Screenshots
- Tool outputs
- Technical references
```

## Step 11: Save Report

Save report as markdown file or output directly to user.

Consider also creating:
- PDF version for stakeholders
- Ticket/issue format for development team
- Spreadsheet for tracking remediation
</process>

<report_templates>
**Quick Report (for minor audits):**
- Executive summary
- Top 5 issues
- Quick win recommendations

**Standard Report (full audit):**
- Full structure above

**Technical Report (for developers):**
- Focus on technical details
- Code snippets for fixes
- Skip executive summary
</report_templates>

<success_criteria>
Report complete when:

- [ ] Executive summary written
- [ ] All scores documented
- [ ] Core Web Vitals included
- [ ] All issues categorized by priority
- [ ] Each issue has: severity, location, impact, fix
- [ ] Technical recommendations included
- [ ] Action plan with priorities created
- [ ] Visual evidence where applicable
- [ ] Report formatted and readable
</success_criteria>
