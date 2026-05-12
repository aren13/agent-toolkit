# Workflow: Prioritize Fixes

<required_reading>
**Review all findings before prioritizing.**
</required_reading>

<process>
## Step 1: Gather All Issues

Collect all findings from audits:
- Performance issues
- Accessibility violations
- Security vulnerabilities
- SEO problems
- UX issues

## Step 2: Rate by Impact

Score each issue on impact (1-5):

| Impact Score | Description |
|-------------|-------------|
| 5 | Affects all users, critical functionality broken |
| 4 | Affects most users, major feature degraded |
| 3 | Affects many users, noticeable issue |
| 2 | Affects some users, minor issue |
| 1 | Affects few users, cosmetic/minor |

**Impact factors:**
- Number of users affected
- Severity of effect
- Business impact (revenue, reputation)
- Legal/compliance requirements

## Step 3: Rate by Effort

Score each issue on effort (1-5):

| Effort Score | Description | Time Estimate |
|-------------|-------------|---------------|
| 1 | Quick fix | < 1 hour |
| 2 | Easy fix | 1-4 hours |
| 3 | Medium effort | 1-2 days |
| 4 | Significant work | 1 week |
| 5 | Major project | 2+ weeks |

**Effort factors:**
- Technical complexity
- Number of files/systems affected
- Testing required
- Dependencies on other changes

## Step 4: Calculate Priority Score

Priority = Impact / Effort

| Impact | Effort | Priority | Action |
|--------|--------|----------|--------|
| 5 | 1 | 5.0 | Do immediately |
| 4 | 1 | 4.0 | High priority |
| 5 | 2 | 2.5 | High priority |
| 3 | 1 | 3.0 | Quick win |
| 5 | 5 | 1.0 | Plan carefully |
| 1 | 5 | 0.2 | Low priority |

**Priority interpretation:**
- 3.0+ = Do first (high impact, low effort)
- 1.5-3.0 = Important (balance of impact/effort)
- 0.5-1.5 = Plan for later
- <0.5 = Consider if worth doing

## Step 5: Create Priority Matrix

Visual representation:

```
High Impact
     │
  4  │  Quick Wins  │  Major Projects
     │  (DO FIRST)  │  (PLAN CAREFULLY)
     │              │
─────┼──────────────┼─────────────────
     │              │
  2  │  Fill-ins    │  Low Priority
     │  (DO LATER)  │  (MAYBE SKIP)
     │              │
Low  └──────────────┴─────────────────
         Low            High
                    Effort
```

## Step 6: Apply Category Weights

Some categories may have higher priority:

| Category | Weight | Reason |
|----------|--------|--------|
| Security (Critical) | 2.0x | Legal/safety risk |
| Accessibility (A) | 1.5x | Legal compliance |
| Performance (CWV) | 1.3x | SEO/UX impact |
| SEO | 1.0x | Business impact |
| Best Practices | 0.8x | Nice to have |

Adjusted Priority = Base Priority × Category Weight

## Step 7: Consider Dependencies

Some fixes must happen in order:

```
Fix A → Fix B → Fix C
        ↘ Fix D
```

If Fix B depends on Fix A, Fix A priority increases.

Mark dependencies:
- "Blocked by: [other fix]"
- "Enables: [other fix]"

## Step 8: Group Related Fixes

Combine fixes that:
- Touch the same files
- Address the same root cause
- Can be done together efficiently

Example:
- "Add alt text to images" (10 images)
- Group as single task, not 10 tasks

## Step 9: Create Prioritized List

Final prioritized list:

| # | Issue | Category | Impact | Effort | Priority | Dependencies |
|---|-------|----------|--------|--------|----------|--------------|
| 1 | Missing HTTPS redirect | Security | 5 | 1 | 5.0 | None |
| 2 | No alt text on hero image | a11y | 4 | 1 | 4.0 | None |
| 3 | LCP image not optimized | Perf | 4 | 2 | 2.0 | None |
| 4 | Missing H1 tag | SEO | 3 | 1 | 3.0 | None |
| 5 | CSP header missing | Security | 4 | 3 | 1.3 | #1 |

## Step 10: Create Sprint/Phase Plan

Organize into actionable phases:

**Phase 1: Quick Wins (Week 1)**
- [ ] Fix 1: [description]
- [ ] Fix 2: [description]
- [ ] Fix 3: [description]

**Phase 2: High Priority (Week 2-3)**
- [ ] Fix 4: [description]
- [ ] Fix 5: [description]

**Phase 3: Medium Priority (Week 4+)**
- [ ] Fix 6: [description]
- [ ] Fix 7: [description]

**Backlog: Low Priority**
- [ ] Fix 8: [description]
- [ ] Fix 9: [description]

## Step 11: Define Success Metrics

For each phase, set measurable goals:

**Phase 1 Success:**
- Lighthouse Performance: 60 → 75
- Security Headers grade: F → C
- WCAG A violations: 5 → 0

**Phase 2 Success:**
- Lighthouse Performance: 75 → 90
- LCP: 4.2s → 2.5s
- WCAG AA compliance achieved

## Step 12: Document Rationale

Explain prioritization decisions:

```markdown
## Prioritization Rationale

### Why Security First
- HTTPS redirect missing exposes users to MITM attacks
- Quick fix with major impact
- Required for other security improvements

### Why Performance Second
- Core Web Vitals affect SEO rankings
- LCP fix has highest ROI
- Image optimization is straightforward

### Deferred Items
- [Item] deferred because [reason]
```
</process>

<anti_patterns>
Avoid:
- Prioritizing by ease only (low-impact quick fixes first)
- Ignoring dependencies (creating blocked work)
- Not considering category importance (security > cosmetics)
- Perfect prioritization paralysis (good enough is fine)
- Not revisiting priorities as context changes
</anti_patterns>

<success_criteria>
Prioritization complete when:

- [ ] All issues rated for impact (1-5)
- [ ] All issues rated for effort (1-5)
- [ ] Priority scores calculated
- [ ] Category weights applied if appropriate
- [ ] Dependencies identified
- [ ] Related fixes grouped
- [ ] Ordered prioritized list created
- [ ] Phases/sprints defined
- [ ] Success metrics established
- [ ] Rationale documented
</success_criteria>
