---
name: docs-audit
version: 1.0.0
description: Audit documentation against docs base skill standards and produce actionable report
allowed-tools: Read, Glob, Grep, Bash(wc *)
argument: target
---

## Context

- Project root: !`pwd`
- Documentation files: !`find docs -name "*.md" 2>/dev/null | head -30 || echo "no docs/ folder"`
- Total doc count: !`find docs -name "*.md" 2>/dev/null | wc -l || echo "0"`

## User Target

$ARGUMENTS

## Your Task

Audit documentation against the docs base skill standards at `~/.claude/skills/docs/`. Read the base skill's SKILL.md first to understand all conventions, then audit thoroughly. No changes -- report only.

### Scope Resolution

- If `$ARGUMENTS` is a file path: audit that single document
- If `$ARGUMENTS` is a directory: audit all `.md` files in it
- If `$ARGUMENTS` is empty: audit the entire `docs/` folder
- If `$ARGUMENTS` is "all": audit every `.md` file in the project

### Audit Procedure

**Phase 1: Inventory**

Scan all target files. For each, record:
- File path
- Current name
- Detected document type (by content analysis)
- File size (line count)

**Phase 2: Naming Audit**

Check every file against `docs` skill naming conventions:

| Check | Rule |
|-------|------|
| Case | All lowercase |
| Separator | Kebab-case (hyphens) |
| Suffix | Correct type suffix (`-guide`, `-reference`, `-fix`, `-prd`, `-spec`, `-summary`, `-roadmap`) |
| Length | Max 50 characters |
| Characters | Only letters, numbers, hyphens, `.md` |
| Location | File is in correct folder for its type |

**Phase 3: Structure Audit**

For each document, check:

| Check | Rule |
|-------|------|
| Title | Exactly one H1 |
| Headings | ATX-style (`#`), no skipped levels |
| Heading spacing | Blank lines before and after |
| Metadata | Has `Last Updated` date (and version/status for PRDs/Specs) |
| ToC | Present if document has 3+ sections |
| Required sections | All required sections for its document type present |

**Phase 4: Content Quality Audit**

Sample each document for:

| Check | Rule |
|-------|------|
| Language | Written in English |
| Voice | Active voice (flag passive: "was handled", "should be done") |
| Tense | Present tense for current state |
| Instructions | Imperative mood ("Run" not "You should run") |
| Emojis | None present |
| Acronyms | Defined on first use |
| Specificity | No vague terms ("soon", "later", "might", "recently") |
| Terminology | Consistent throughout |
| Examples | Concrete and practical |

**Phase 5: Technical Formatting Audit**

| Check | Rule |
|-------|------|
| Code blocks | All have language specifier |
| Tables | Header row, alignment row, proper structure |
| Internal links | Use relative paths |
| Link text | Descriptive (not "click here") |
| External links | Include `https://` protocol |
| Lists | `-` for unordered, `1.` for ordered, 2-space nesting |

**Phase 6: Folder Health Audit**

| Check | Rule |
|-------|------|
| README indexes | Every folder with `.md` files has a `README.md` |
| README completeness | README lists all files in the folder |
| Orphan files | No `.md` files missing from any README |
| Empty folders | No folders without content |
| Duplicates | No files with identical/near-identical content |

**Phase 7: ISO Compliance (SOPs only)**

If any SOP files found (`SOP-*.md`), audit against 15-element standard:
- Header (5): title, number, version, effective date, review date
- Administrative (5): purpose, scope, definitions, RACI, references
- Body (5): procedure steps, imperative verbs, safety, quality checklist, revision history
- Score 0-100 with deductions for passive voice, vague terms, missing time estimates

### Output Format

```
======================================
  DOCUMENTATION AUDIT REPORT
  Project: [name]
  Date: [YYYY-MM-DD]
  Scope: [target]
  Files Audited: [N]
======================================

## Health Score: [A/B/C/D/F]

Criteria:
- A: 90%+ checks pass, no critical issues
- B: 80-89%, minor issues only
- C: 70-79%, needs attention
- D: 50-69%, significant issues
- F: <50%, major rework needed

## Summary
[2-3 sentence overview]

## Scores by Category

| Category | Pass | Total | Score |
|----------|------|-------|-------|
| Naming | X | 6/file | X% |
| Structure | X | 8/file | X% |
| Content | X | 12/file | X% |
| Technical | X | 6/file | X% |
| Maintenance | X | 5/file | X% |
| Folder Health | X | X | X% |
| **Overall** | **X** | **X** | **X%** |

## Findings

### Critical (must fix)
- [finding] -- file: [path], line: [N]
  Action: [exact fix]

### Warning (should fix)
- [finding] -- file: [path], line: [N]
  Action: [exact fix]

### Info (nice to have)
- [finding] -- file: [path]
  Action: [suggestion]

## File-by-File Results

| File | Naming | Structure | Content | Technical | Score | Top Issue |
|------|--------|-----------|---------|-----------|-------|-----------|
| [path] | pass/fail | X/8 | X/12 | X/6 | X% | [issue] |

## Action Plan

Priority order. Each item has the exact command or change needed.

### Immediate (critical fixes)
1. [action] -- `command or edit`
2. [action] -- `command or edit`

### Short-term (warnings)
1. [action] -- `command or edit`

### Backlog (improvements)
1. [action]
```

### Rules

1. **Read-only** -- never modify files, only inspect and report
2. **Be specific** -- include file paths, line numbers, exact violations
3. **Include fixes** -- every finding must have an actionable resolution
4. **Prioritize** -- critical issues first, cosmetic last
5. **Score objectively** -- use the checklist counts, not subjective judgment
6. **Read the docs base skill first** -- load `~/.claude/skills/docs/SKILL.md` before auditing
