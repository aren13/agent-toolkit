# Quality Checklist Reference

Complete quality checklist for reviewing documentation before committing.

## Pre-Commit Checklist

Use this checklist before committing any documentation:

### Naming Convention (6 checks)

- [ ] **All lowercase** - No uppercase letters in filename
- [ ] **Kebab-case** - Uses hyphens not underscores or spaces
- [ ] **Type suffix** - Has appropriate suffix (`-guide`, `-reference`, etc.) or none for features
- [ ] **Max 50 characters** - Filename is 50 characters or less
- [ ] **No special chars** - Only letters, numbers, hyphens, and `.md`
- [ ] **Correct location** - File is in appropriate folder for its type

**Example Check:**
- ❌ `API_Guide.md` → Fails: uppercase, underscore, missing suffix
- ✅ `api-reference.md` → Passes all checks

---

### Structure (8 checks)

- [ ] **Title (H1)** - Document has exactly one H1 heading that matches purpose
- [ ] **Metadata block** - Has date/version/status metadata where required
- [ ] **Table of Contents** - Has ToC if document has more than 3 sections
- [ ] **Required sections** - All required sections for document type are present
- [ ] **ATX-style headings** - Uses `#` syntax not underlines
- [ ] **One H1 only** - Only one H1, all other headings are H2 or below
- [ ] **No skipped levels** - Heading hierarchy is proper (H1→H2→H3, not H1→H3)
- [ ] **Blank lines around headings** - Blank line before and after each heading

**Required Sections by Type:**
- **Guide:** Prerequisites, Steps, (Troubleshooting recommended)
- **Reference:** Overview, Categorized content, Examples
- **Fix:** Issue details, Solution, Testing, Deployment
- **PRD:** Introduction, Requirements, Acceptance criteria
- **Spec:** Overview, Protocol, Endpoints, Examples
- **Summary:** Overview, Key points, Results, Next steps
- **Roadmap:** Progress overview, Phases, Items with status
- **Feature:** Overview, Components, Configuration, Usage

---

### Content Quality (12 checks)

- [ ] **English language** - Written in English (or specified language)
- [ ] **Active voice** - Uses active voice ("system handles" not "handled by system")
- [ ] **Present tense** - Uses present tense for current state
- [ ] **Imperative for instructions** - Uses commands ("Run the test" not "You should run")
- [ ] **No emojis** - No emoji characters anywhere in document
- [ ] **Defines acronyms** - All acronyms defined on first use
- [ ] **Specific dates/versions** - No vague references ("recently" → "2024-01-15")
- [ ] **No vague language** - No "might", "soon", "later", "possibly"
- [ ] **Consistent terminology** - Same terms used for same concepts throughout
- [ ] **Actionable content** - Reader can actually do something with the information
- [ ] **Practical examples** - Has concrete, working examples (not just abstract descriptions)
- [ ] **No time estimates** - Doesn't include time estimates ("takes 2 hours")

---

### Technical Formatting (6 checks)

- [ ] **Code blocks have language** - All code blocks specify language (```ruby, ```bash, etc.)
- [ ] **Code is complete** - Code examples are complete and runnable
- [ ] **Code is tested** - Code examples have been verified to work
- [ ] **Tables formatted correctly** - Tables have header, alignment, proper structure
- [ ] **Links are relative** - Internal doc links use relative paths
- [ ] **Links are descriptive** - Link text describes destination (not "click here")

**Code Block Check:**
❌ ` ```
code here
```

✅ ` ```ruby
code here
```

**Link Check:**
- ❌ `[here](./guide.md)` → Not descriptive
- ✅ `[Installation Guide](./guide.md)` → Descriptive

---

### Lists (4 checks)

- [ ] **Unordered use hyphens** - Uses `-` for unordered lists
- [ ] **Ordered use numbers** - Uses `1.` for ordered lists
- [ ] **Consistent indentation** - Nested lists use 2-space indentation
- [ ] **Parallel structure** - List items use same grammatical form

---

### Maintenance (5 checks)

- [ ] **Last Updated date** - Has "Last Updated: YYYY-MM-DD" in metadata
- [ ] **Version number** - Has version number (for PRDs/Specs/Roadmaps)
- [ ] **Status** - Has status (for PRDs/Specs/Roadmaps)
- [ ] **In folder README** - Listed in folder's README.md file
- [ ] **Related docs linked** - Links to related documentation where appropriate

---

## Compliance Score

Calculate compliance by counting passed checks:

**Total Possible:** 41 checks

**Score Interpretation:**
- **41/41 (100%)** - Excellent, fully compliant
- **37-40 (90-97%)** - Good, minor issues only
- **33-36 (80-87%)** - Acceptable, some improvements needed
- **< 33 (< 80%)** - Needs significant work

---

## Issue Severity Levels

### Critical (Must Fix)

Issues that break standards or cause confusion:
- Naming convention violations
- Missing required sections
- Wrong document type classification
- Broken links
- Code blocks without language
- Multiple H1 headings
- No title

### Warnings (Should Fix)

Issues that reduce quality or consistency:
- Missing metadata (dates, versions)
- Formatting inconsistencies (tables, lists)
- Writing style issues (passive voice, vague language)
- Missing examples
- Unclear content
- No ToC for long documents

### Suggestions (Nice to Have)

Improvements that would enhance the document:
- Additional examples
- More detailed explanations
- Better organization
- More comprehensive troubleshooting
- Additional cross-references

---

## Quick Audit Process

### 1. Filename Check (30 seconds)

✓ Lowercase, kebab-case, correct suffix, < 50 chars, correct folder

### 2. Structure Scan (1 minute)

✓ One H1, has metadata, has ToC (if long), has required sections

### 3. Code Blocks Check (1 minute)

✓ All have language specifiers, all are complete

### 4. Links Check (1 minute)

✓ All internal links are relative, all are descriptive

### 5. Writing Sample Check (2 minutes)

✓ Read a few paragraphs for: active voice, present tense, no emojis, defines acronyms

**Total: ~5 minutes for basic audit**

---

## Automated Checks

Consider automating these checks:

**Can be scripted:**
- Naming convention (regex)
- Code blocks have language (regex)
- File has exactly one H1 (regex)
- No emojis (regex)
- File is in README (file check)
- Links are relative (regex)
- Max file name length (string length)

**Harder to automate:**
- Content quality (active voice, etc.)
- Examples are practical
- Content is actionable
- Correct document type

---

## Common Failures

### 1. Missing Language on Code Blocks

**Failure:**
````markdown
```
bundle install
```
````

**Fix:**
````markdown
```bash
bundle install
```
````

**Severity:** Critical

---

### 2. Absolute Links for Internal Docs

**Failure:**
```markdown
[API Guide](/docs/api-guide.md)
```

**Fix:**
```markdown
[API Guide](./api-guide.md)
```

**Severity:** Warning

---

### 3. Passive Voice

**Failure:**
"The configuration should be updated by the administrator."

**Fix:**
"Update the configuration."

**Severity:** Warning

---

### 4. Vague Language

**Failure:**
"This might take a while."

**Fix:**
"This takes approximately 2-5 minutes."

**Severity:** Warning

---

### 5. No Metadata

**Failure:**
```markdown
# Installation Guide

This guide covers...
```

**Fix:**
```markdown
# Installation Guide

> **Last Updated:** 2024-01-15

This guide covers...
```

**Severity:** Warning

---

### 6. Poor Table Formatting

**Failure:**
```markdown
|A|B|
|---|---|
|1|2|
```

**Fix:**
```markdown
| Column A | Column B |
|----------|----------|
| Value 1  | Value 2  |
```

**Severity:** Warning

---

### 7. Multiple H1s

**Failure:**
```markdown
# Title

# Section  ← Should be ##
```

**Fix:**
```markdown
# Title

## Section
```

**Severity:** Critical

---

### 8. Undefined Acronyms

**Failure:**
"Configure the CSP settings."

**Fix:**
"Configure the Content Security Policy (CSP) settings."

**Severity:** Warning

---

## Review Report Template

Use this template to document review findings:

```markdown
# Documentation Review Report

**Document:** [path/to/file.md]
**Reviewer:** [Name]
**Date:** YYYY-MM-DD

---

## Compliance Score

**Overall:** XX/41 checks passed (XX%)

### By Category
- Naming: X/6
- Structure: X/8
- Content: X/12
- Technical: X/6
- Lists: X/4
- Maintenance: X/5

---

## Critical Issues

[List critical issues that must be fixed]

1. [Issue description]
   - **Location:** [Line number or section]
   - **Fix:** [Specific fix needed]

---

## Warnings

[List warnings that should be fixed]

1. [Issue description]
   - **Location:** [Line number or section]
   - **Fix:** [Specific fix needed]

---

## Suggestions

[List nice-to-have improvements]

1. [Suggestion]
   - **Benefit:** [Why this would help]

---

## Approval Status

- [ ] Approved as-is
- [ ] Approved with minor fixes
- [ ] Needs revision (critical issues)
- [ ] Needs major rework

**Reviewer Comments:**
[Additional context or guidance]
```

---

## Checklist by Document Type

### Guide Checklist

Standard checklist plus:
- [ ] Has Prerequisites section
- [ ] Steps are numbered and clear
- [ ] Has verification/testing section
- [ ] Has troubleshooting section (recommended)
- [ ] Commands are complete and tested

### Reference Checklist

Standard checklist plus:
- [ ] Content organized by category
- [ ] Heavy use of tables for structured data
- [ ] Includes examples showing how to use the info
- [ ] Comprehensive coverage of topic
- [ ] Easy to scan and find specific items

### Fix Checklist

Standard checklist plus:
- [ ] Has severity level (Critical/High/Medium/Low)
- [ ] Has ticket/CVE number
- [ ] Includes root cause analysis
- [ ] Shows before/after code changes
- [ ] Has testing verification steps
- [ ] Has deployment steps

### PRD Checklist

Standard checklist plus:
- [ ] Has version number
- [ ] Has document history table
- [ ] Includes user stories
- [ ] Has acceptance criteria
- [ ] Defines scope (in/out)
- [ ] Has functional and non-functional requirements

### Spec Checklist

Standard checklist plus:
- [ ] Has version number
- [ ] Defines authentication method
- [ ] Lists all endpoints/methods
- [ ] Shows request/response formats
- [ ] Includes error codes
- [ ] Has working curl examples
- [ ] Has changelog

### Summary Checklist

Standard checklist plus:
- [ ] Has brief executive overview (2-3 sentences)
- [ ] Lists key points (bulleted)
- [ ] Includes results/outcomes
- [ ] Has next steps section
- [ ] Can be read standalone

### Roadmap Checklist

Standard checklist plus:
- [ ] Has progress overview table
- [ ] Items have clear status (Done/In Progress/Todo)
- [ ] Links to PRs where applicable
- [ ] Has completion percentage
- [ ] Updated regularly (check date)

### Feature Checklist

Standard checklist plus:
- [ ] Explains what feature does
- [ ] Lists components
- [ ] Includes configuration details
- [ ] Has usage examples
- [ ] Has troubleshooting section

---

## Final Check

Before committing, ask yourself:

1. **Can a new team member understand this?**
2. **Can they actually DO what this doc describes?**
3. **Is everything they need here (or linked)?**
4. **Would I be proud to show this to others?**
5. **Does it follow all project standards?**

If "yes" to all → Ready to commit ✅
If "no" to any → Needs more work ❌
