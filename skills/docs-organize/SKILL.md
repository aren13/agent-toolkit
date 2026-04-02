---
name: docs-organize
description: Organize project documentation by auditing folder structure, enforcing naming conventions, removing duplicates, and ensuring every folder has a README index. Moves files to correct locations using git mv, updates all cross-references, and produces a summary report. Uses docs base skill for naming conventions, folder structure standards, and document type classification. Supports --refactor flag to also refactor document contents using docs-craft skill.
---

<objective>
Audit and reorganize a project's documentation folder structure to match a consistent standard. This skill handles the structural/organizational side — folder hierarchy, file placement, naming conventions, duplicate removal, README indexes, and cross-reference updates. It does NOT rewrite document contents unless the --refactor flag is used.
</objective>

<arguments>
- `--refactor` — After organizing structure, also audit and refactor the content of each document using the docs-craft skill (standardize-documents workflow). This is optional and significantly increases the scope of work.
- `--dry-run` — Show what would change without making any modifications. Produces an audit report only.
- `--path <dir>` — Target a specific subdirectory instead of the entire docs/ folder.
</arguments>

<standard_structure>
## Canonical Folder Structure

This is the target structure. Not every project needs every folder — only create folders that have content. The key principle is: documents live in ONE canonical location based on their primary purpose.

```
docs/
├── README.md                    # Main index with quick links table
├── documentation-guideline.md   # Standards and conventions (optional)
├── getting-started/             # Installation, setup, onboarding
│   └── README.md
├── how-to/                      # Task-specific step-by-step tutorials
│   └── README.md
├── product/                     # Product documentation
│   └── features/                # Feature docs, PRDs, specs
│       └── README.md
├── design-system/               # UI tokens, components, page overrides
│   ├── MASTER.md
│   └── pages/
├── integrations/                # External API and system integrations
│   └── README.md
├── architecture/                # System design, diagrams, ADRs
│   └── README.md
├── security/                    # Security fixes, patches, CVEs
│   ├── README.md
│   └── cve/
├── development/                 # Developer resources, roadmaps
│   ├── README.md
│   └── completed/              # Historical/completed work
├── monitoring/                  # Monitoring and alerting
│   └── README.md
├── maintenance/                 # Maintenance procedures
│   └── README.md
├── testing/                     # Test plans, UAT reports
│   └── README.md
└── archive/                     # Deprecated docs kept for history
    └── README.md
```

## Placement Decision Tree

Use this to determine where a document belongs:

1. **Setup/onboarding?** → `getting-started/`
2. **Step-by-step task guide?** → `how-to/`
3. **Product feature, PRD, or feature spec?** → `product/features/`
4. **UI design tokens/components?** → `design-system/`
5. **External system integration?** → `integrations/`
6. **System architecture or design?** → `architecture/`
7. **Security fix, CVE, patch?** → `security/` (or `security/cve/`)
8. **Developer tooling, roadmap, planning?** → `development/`
9. **Monitoring/alerting?** → `monitoring/`
10. **Maintenance procedures?** → `maintenance/`
11. **Test plans/UAT?** → `testing/`
12. **Outdated/deprecated?** → `archive/`

## Subdirectory Rules

Create a subdirectory when:
- 5+ related documents share a common topic prefix (e.g., `sku-data-*` → `sku/`)
- Documents form a clear logical group (e.g., `carrefour/` under `integrations/`)

## Naming Conventions

| Rule | Correct | Wrong |
|------|---------|-------|
| Lowercase only | `api-guide.md` | `API-Guide.md` |
| Kebab-case | `user-auth.md` | `user_auth.md` |
| Type suffix | `setup-guide.md` | `setup.md` |
| Max 50 chars | `retailer-api.md` | `retailer-api-integration-docs-v2.md` |
| No spaces | `ssl-tls-guide.md` | `ssl tls guide.md` |

### Type Suffixes

| Suffix | When to use |
|--------|------------|
| `-guide.md` | How-to, tutorials, step-by-step |
| `-reference.md` | API specs, lookup tables, config options |
| `-fix.md` | Security patches, bug fixes |
| `-prd.md` | Product requirements |
| `-spec.md` | Technical specifications |
| `-summary.md` | Overviews, executive summaries |
| `-roadmap.md` | Planning, milestone tracking |
| (no suffix) | Feature docs in `product/features/` |
</standard_structure>

<workflow>
## Phase 1: Audit

Scan the documentation to understand current state. This phase is read-only.

### Step 1.1 — Discover all documentation files

```
Glob: docs/**/*.md
Glob: **/*.md at project root (catch loose docs like design-system/, etc.)
```

Also check for documentation directories outside `docs/` (e.g., `design-system/` at project root).

### Step 1.2 — Classify each file

For every file found, determine:
- **Current location** — where it is now
- **Correct location** — where it should be per the decision tree
- **Naming issues** — uppercase, underscores, missing suffix, too long
- **Duplicate status** — is there another file with identical/near-identical content?

### Step 1.3 — Check folder health

For each folder under `docs/`:
- Does it have a `README.md`?
- Does the README list all files in the folder?
- Are there any files not mentioned in any README?

### Step 1.4 — Present audit report

Show the user a categorized report:

```
## Documentation Audit Report

### Misplaced Files (N)
| File | Current Location | Correct Location | Reason |
|------|-----------------|-------------------|--------|

### Naming Violations (N)
| File | Issue | Suggested Name |
|------|-------|---------------|

### Duplicates (N)
| File A | File B | Action |
|--------|--------|--------|

### Missing READMEs (N)
| Folder | Status |
|--------|--------|

### Incomplete READMEs (N)
| Folder | Missing Entries |
|--------|----------------|

### Subdirectory Candidates (N)
| Folder | Pattern | File Count | Suggested Subdirectory |
|--------|---------|------------|----------------------|
```

If `--dry-run` was specified, stop here.

## Phase 2: Execute

After presenting the audit, proceed with changes. Use `git mv` for all moves to preserve history.

### Step 2.1 — Create missing directories

Create any target directories that don't exist yet. Create README.md files for new directories immediately.

### Step 2.2 — Remove duplicates

When two files have identical or near-identical content:
- Keep the one in the correct location
- `git rm` the duplicate
- If both are in wrong locations, move one to the correct location and delete the other

### Step 2.3 — Move misplaced files

Use `git mv` to relocate files. Process moves in dependency order — if File A references File B and both are moving, move them together.

### Step 2.4 — Rename files with convention violations

Use `git mv` to rename. Common fixes:
- `UPPERCASE.md` → `lowercase.md`
- `under_score.md` → `under-score.md`
- `CamelCase.md` → `camel-case.md`
- `setup.md` → `setup-guide.md` (add type suffix)

### Step 2.5 — Create subdirectories for groups

When 5+ files share a topic prefix, move them into a subdirectory with a README.

### Step 2.6 — Update all cross-references

This is critical — broken links are worse than messy organization. Search the entire codebase for references to moved/renamed files:

```
Grep for old paths in: *.md, *.rb, *.js, *.css, *.yml, CLAUDE.md, README.md
```

Update every reference found. Check:
- Markdown links `[text](path)`
- Inline code references `` `path` ``
- Comments referencing paths
- CLAUDE.md documentation section
- Root README.md

### Step 2.7 — Update/create README indexes

For every folder under `docs/`:
- Create README.md if missing
- Add entries for all files in the folder
- Remove entries for files that no longer exist
- Use table format with Document, Description columns

## Phase 3: Verify

### Step 3.1 — Search for broken references

```
Grep for any old paths that should have been updated
```

### Step 3.2 — Verify folder completeness

Every folder with `.md` files should have a README.md listing them all.

### Step 3.3 — Clean up

Remove `.DS_Store` files from tracking if found. Clean up empty directories.

## Phase 4: Report and Commit

### Step 4.1 — Generate summary

Output a concise summary of all changes:
- Files moved (with old → new paths)
- Files renamed
- Duplicates removed
- READMEs created/updated
- References updated

### Step 4.2 — Commit

Create a single commit with a descriptive message covering all changes.
</workflow>

<refactor_mode>
## --refactor Flag Behavior

When `--refactor` is specified, after completing the structural reorganization (Phases 1-4), invoke the docs-craft skill to audit and improve document contents.

### How it works:

1. Complete all structural organization first (Phases 1-4, commit)
2. Then trigger the docs-craft skill's standardize-documents workflow
3. docs-craft will:
   - Audit each document against writing standards
   - Fix formatting issues (code blocks, tables, links)
   - Add missing metadata (dates, versions)
   - Improve writing style (active voice, imperative mood)
   - Ensure template compliance for each document type
4. Create a separate commit for content refactoring

The structural commit and content commit are kept separate so they can be reviewed independently.

### Integration:

Tell the user: "Structure reorganization is complete. Now running docs-craft to refactor document contents..." Then use the Skill tool to invoke `/docs-craft` with the standardize-documents workflow, targeting the docs/ folder.
</refactor_mode>

<principles>
## Guiding Principles

- **git mv always** — Never copy+delete. Preserve git history.
- **References before moves** — Search for all references to a file BEFORE moving it, so you know what to update.
- **One canonical location** — Every document lives in exactly one place. No duplicates, no symlinks.
- **README as index** — Every folder's README.md is the table of contents. If a file exists in a folder, it must be listed in that README.
- **Minimal disruption** — Only move files that are actually in the wrong place. If a file is correctly placed, leave it alone even if there's a "more perfect" location.
- **Commit atomically** — All structural changes go in one commit so they can be reverted cleanly if needed.
- **Update CLAUDE.md** — If the project has a CLAUDE.md that references doc paths, those references must be updated too.
</principles>
