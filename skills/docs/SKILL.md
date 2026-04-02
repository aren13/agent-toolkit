---
skill_name: docs
version: 1.0.0
description: Documentation conventions, standards, naming rules, document types, templates, and quality criteria. Loaded automatically when working with documentation operations.
triggers:
  - create documentation
  - audit documentation
  - organize docs
  - write docs
  - review document
  - standardize docs
  - fix doc structure
  - documentation standards
---

# Docs

Documentation domain expertise. This skill provides the shared standards, conventions, and reference material used by all docs action skills (`docs-craft`, `docs-organize`, `docs-audit`).

## Core Principles

1. **Clarity Over Cleverness** - Documentation should be immediately understandable. Avoid jargon, define terms, use concrete examples.
2. **Structure First** - Every document needs clear hierarchy: title, metadata, table of contents (for longer docs), logical sections.
3. **Consistency Is Key** - Use consistent terminology, formatting, naming conventions, and templates throughout the project.
4. **Actionable Content** - Documentation should enable action. Provide clear steps, concrete examples, and verification methods.
5. **Maintenance Culture** - Documentation is living. Include dates, version info, and update procedures.

## Document Type Classification

Documents fall into distinct categories, each with specific purposes:

- **Guide** (`-guide.md`) - Step-by-step instructions, tutorials, how-to content
- **Reference** (`-reference.md`) - Lookup tables, API specs, configuration options
- **Fix** (`-fix.md`) - Security patches, bug fixes, hotfix documentation
- **PRD** (`-prd.md`) - Product requirements documents, feature specifications
- **Spec** (`-spec.md`) - Technical specifications, webhook contracts, protocols
- **Summary** (`-summary.md`) - Overviews, executive summaries, ticket summaries
- **Roadmap** (`-roadmap.md`) - Planning documents, milestone tracking, progress
- **Feature** (no suffix) - Feature documentation in `features/` folder
- **SOP** (`SOP-XX-NNN.md`) - Standard Operating Procedures (ISO 9001 compliant)
- **Work Instruction** (`WI-XX-NNN.md`) - Granular, single-task operator guides

Read `references/document-types.md` for detailed classification criteria and decision matrix.

## Naming Conventions

**File naming:**
- All lowercase: `api-guide.md` not `API-Guide.md`
- Kebab-case: `user-auth.md` not `user_auth.md`
- Type suffix: `setup-guide.md` not `setup.md`
- Max 50 characters total
- No spaces or special characters

**Folder naming:**
- Lowercase, plural nouns: `features/` not `Feature/`
- Kebab-case, short (1-2 words)

Read `references/naming-conventions.md` for complete rules, folder-specific requirements, and examples.

## Writing Standards

- **Language:** English unless specified otherwise
- **Voice:** Active voice ("system handles" not "handled by system")
- **Tense:** Present tense for current state
- **Instructions:** Imperative mood ("Run the test" not "You should run")
- **Formatting:** No emojis, minimal bold/italic, ATX-style headings
- **Code:** Always specify language in code blocks
- **Links:** Relative paths for internal docs, descriptive text (not "click here")
- **Terminology:** Consistent throughout -- pick one term per concept

Read `references/writing-style.md` for detailed style guide and common transformations.

## Markdown Standards

- ATX-style headings (`#` not underlines)
- One H1 per document
- No skipped heading levels
- Blank lines around headings, code blocks, lists, and tables
- Hyphens (`-`) for unordered lists
- `1.` for ordered lists
- 2-space indentation for nested lists
- Tables with header row, alignment row, aligned columns
- `-` for empty/not-applicable table cells

Read `references/markdown-standards.md` for complete formatting rules.

## Quality Checklist

Every document should pass these checks:

**Naming (6):** lowercase, kebab-case, type suffix, max 50 chars, no special chars, correct location
**Structure (8):** one H1, metadata, ToC if needed, required sections, ATX headings, no skipped levels, blank lines
**Content (12):** English, active voice, present tense, imperative instructions, no emojis, defines acronyms, specific dates, no vague language, consistent terminology, actionable, practical examples, no time estimates
**Technical (6):** code blocks have language, code is complete, tables formatted, links relative, links descriptive, lists formatted
**Maintenance (5):** last updated date, version number, status, in folder README, related docs linked

**Score:** 41 checks total. 90%+ = Excellent, 80%+ = Acceptable, <80% = Needs work.

Read `references/quality-checklist.md` for the full checklist with severity levels and audit process.

## ISO 9001 Compliance

For SOPs and formal procedures:

- **Document Hierarchy:** Policy > Process > Procedure (SOP) > Work Instruction > Forms/Records
- **SOP Numbering:** `SOP-[CATEGORY]-[NNN]`
- **Version Format:** `YYYYMMDD_HHMM`
- **15-Element Standard:** Header (5), Administrative (5), Body (5)
- **The 5 C's:** Clear, Concise, Complete, Consistent, Current
- **Audit Scoring:** 0-100 points, 90+ = Compliant

Read `references/iso-9001-standards.md` for full standards including RACI, scoring rubric, and deductions.

## Templates

Templates for each document type are in `templates/`:

| Template | Document Type |
|----------|--------------|
| `guide-template.md` | Step-by-step guides |
| `reference-template.md` | API/config references |
| `fix-template.md` | Bug/security fix docs |
| `summary-template.md` | Overviews and summaries |
| `feature-template.md` | Feature documentation |
| `sop-template.md` | ISO 9001 SOPs |
| `work-instruction-template.md` | Operator task guides |

## Folder Structure Standard

```
docs/
├── README.md                    # Main index
├── getting-started/             # Installation, setup, onboarding
├── how-to/                      # Task-specific step-by-step guides
├── product/features/            # Feature documentation
├── integrations/                # External API and system integrations
├── architecture/                # System design, diagrams, ADRs
├── security/                    # Security fixes, CVEs
├── development/                 # Developer resources, roadmaps
├── archive/                     # Deprecated docs kept for history
```

Every folder must have a `README.md` listing all documents in it.

## Quick Reference

**"What type should I use?"** Guide (how-to) | Reference (lookup) | Fix (patch) | PRD (requirements) | Spec (protocol) | Summary (overview) | Roadmap (planning) | Feature (capability) | SOP (formal procedure)

**"Where should it go?"** getting-started (setup) | how-to (guides) | features (features) | integrations (external) | security (fixes) | development (planning) | archive (old)

**"How do I name it?"** `lowercase-kebab-with-type-suffix.md` -- max 50 chars
