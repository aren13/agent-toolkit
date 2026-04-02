# Workflow: ISO 9001 Compliance Audit

<required_reading>
Before starting, read:
- references/iso-9001-standards.md - Full ISO 9001 documentation standards
</required_reading>

<process>
## Step 1: Identify Scope

Ask user: "What document(s) need ISO compliance audit?"

Options:
1. **Single document** - Path to specific file
2. **Folder of SOPs** - All SOPs in a directory
3. **Full project audit** - All documentation

Get confirmation on scope.

## Step 2: Read and Analyze Document(s)

For each document:

1. **Read full content** using Read tool
2. **Check document type** - Is it an SOP/procedure that requires ISO compliance?
3. **Apply 15-element checklist**

## Step 3: Score Each Element

### Header Section (20 points max)

| Element | Points | Check |
|---------|--------|-------|
| Title | 4 | Descriptive and searchable? |
| SOP Number | 4 | Follows SOP-XX-NNN format? |
| Version | 4 | Uses YYYYMMDD_HHMM format? |
| Effective Date | 4 | Present and valid (YYYY-MM-DD)? |
| Review Date | 4 | 6 months from effective date? |

### Administrative Section (30 points max)

| Element | Points | Check |
|---------|--------|-------|
| Purpose | 6 | Clearly states WHY in 1-2 sentences? |
| Scope | 6 | Defines WHO, WHAT, and exclusions? |
| Definitions | 6 | All technical terms explained? |
| RACI | 6 | All responsibilities assigned? ONE Accountable per task? |
| References | 6 | Related documents listed? |

### Body Section (30 points max)

| Element | Points | Check |
|---------|--------|-------|
| Procedure Steps | 8 | Numbered, sequential steps? |
| Imperative Verbs | 6 | Each step starts with action verb? |
| Decision Points | 6 | Clear criteria for branching? |
| Safety/Precautions | 4 | Risks and warnings addressed? |
| Quality Checklist | 6 | Verification criteria present? |

### Supporting Elements (20 points max)

| Element | Points | Check |
|---------|--------|-------|
| Attachments | 10 | Templates/forms listed with paths? |
| Revision History | 10 | All changes tracked with version, date, author? |

## Step 4: Apply Deductions

Check for writing quality issues:

| Issue | Deduction |
|-------|-----------|
| Passive voice in procedure steps | -5 pts each |
| Vague terms ("adequate", "sufficient", "appropriate") | -5 pts each |
| Missing time estimates for phases | -3 pts each |
| Undefined acronyms or terms | -3 pts each |
| Broken cross-references | -5 pts each |

## Step 5: Calculate Final Score

```
Final Score = (Header + Admin + Body + Supporting) - Deductions
```

### Score Thresholds

| Score | Status | Action Required |
|-------|--------|-----------------|
| 90-100 | **Compliant** | No action needed |
| 70-89 | **Minor Issues** | Remediate within 30 days |
| 50-69 | **Major Issues** | Remediate within 7 days |
| <50 | **Non-Compliant** | Immediate remediation required |

## Step 6: Generate Compliance Report

Create report in this format:

```markdown
# ISO 9001 Compliance Audit Report

**Document:** [path/name]
**Audit Date:** [YYYY-MM-DD]
**Auditor:** Claude (DocOps)

---

## Summary

**Final Score:** [X/100] - [Status]

| Section | Score | Max |
|---------|-------|-----|
| Header | [X] | 20 |
| Administrative | [X] | 30 |
| Body | [X] | 30 |
| Supporting | [X] | 20 |
| Deductions | [-X] | - |
| **Total** | **[X]** | **100** |

---

## Element Checklist

### Header Section ([X]/20)

| Element | Status | Score | Notes |
|---------|--------|-------|-------|
| Title | ✅/❌ | [X]/4 | [Specific finding] |
| SOP Number | ✅/❌ | [X]/4 | [Specific finding] |
| Version | ✅/❌ | [X]/4 | [Specific finding] |
| Effective Date | ✅/❌ | [X]/4 | [Specific finding] |
| Review Date | ✅/❌ | [X]/4 | [Specific finding] |

### Administrative Section ([X]/30)

| Element | Status | Score | Notes |
|---------|--------|-------|-------|
| Purpose | ✅/❌ | [X]/6 | [Specific finding] |
| Scope | ✅/❌ | [X]/6 | [Specific finding] |
| Definitions | ✅/❌ | [X]/6 | [Specific finding] |
| RACI | ✅/❌ | [X]/6 | [Specific finding] |
| References | ✅/❌ | [X]/6 | [Specific finding] |

### Body Section ([X]/30)

| Element | Status | Score | Notes |
|---------|--------|-------|-------|
| Procedure Steps | ✅/❌ | [X]/8 | [Specific finding] |
| Imperative Verbs | ✅/❌ | [X]/6 | [Specific finding] |
| Decision Points | ✅/❌ | [X]/6 | [Specific finding] |
| Safety/Precautions | ✅/❌ | [X]/4 | [Specific finding] |
| Quality Checklist | ✅/❌ | [X]/6 | [Specific finding] |

### Supporting Elements ([X]/20)

| Element | Status | Score | Notes |
|---------|--------|-------|-------|
| Attachments | ✅/❌ | [X]/10 | [Specific finding] |
| Revision History | ✅/❌ | [X]/10 | [Specific finding] |

---

## Deductions ([-X] points)

| Issue | Count | Points |
|-------|-------|--------|
| Passive voice | [N] | -[X] |
| Vague terms | [N] | -[X] |
| Missing time estimates | [N] | -[X] |
| Undefined acronyms | [N] | -[X] |
| Broken references | [N] | -[X] |

**Specific Issues:**
- Line [N]: "[problematic text]" - [issue type]
- Line [N]: "[problematic text]" - [issue type]

---

## Recommendations

### Critical (Must Fix)
1. [Specific action with line reference]
2. [Specific action with line reference]

### Important (Should Fix)
1. [Specific action with line reference]
2. [Specific action with line reference]

### Suggested (Nice to Have)
1. [Specific improvement]
2. [Specific improvement]

---

## Quick Fixes

These can be applied immediately:

1. [Specific fix - e.g., "Add SOP number: SOP-XX-001"]
2. [Specific fix - e.g., "Change 'should be done' to 'Do' on line 45"]
3. [Specific fix - e.g., "Add review date: 2026-06-16"]
```

## Step 7: Offer Remediation

Ask user: "Would you like me to fix these issues automatically?"

If yes:
1. Apply all "Quick Fixes"
2. Add missing elements with placeholder content
3. Flag items requiring human input with `[TODO: ...]`
4. Update version and revision history
5. Re-audit to confirm improvement

## Step 8: Multi-Document Summary (if batch audit)

If auditing multiple documents, generate summary:

```markdown
# ISO 9001 Batch Audit Summary

**Date:** [YYYY-MM-DD]
**Documents Audited:** [N]

## Overall Compliance

| Status | Count | Percentage |
|--------|-------|------------|
| Compliant (90-100) | [N] | [X]% |
| Minor Issues (70-89) | [N] | [X]% |
| Major Issues (50-69) | [N] | [X]% |
| Non-Compliant (<50) | [N] | [X]% |

**Average Score:** [X]/100

## Documents by Score

| Document | Score | Status |
|----------|-------|--------|
| [name] | [X] | [Status] |
| [name] | [X] | [Status] |

## Common Issues

| Issue | Occurrences |
|-------|-------------|
| [Most common issue] | [N] documents |
| [Second most common] | [N] documents |

## Priority Remediation

1. **[Document]** - Score [X] - [Primary issue]
2. **[Document]** - Score [X] - [Primary issue]
```
</process>

<success_criteria>
ISO compliance audit is successful when:
- All elements are scored according to the 15-element standard
- Deductions are applied consistently for writing issues
- Final score accurately reflects document quality
- Report provides specific, actionable recommendations
- Line references point to exact issues
- Quick fixes can be applied immediately
- User understands what needs remediation and why
</success_criteria>
