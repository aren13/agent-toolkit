---
description: Organize documentation folder structure, enforce naming, remove duplicates, update indexes
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(git mv *), Bash(git rm *), Bash(mkdir *), Bash(wc *)
argument: options
---

## Context

- Project root: !`pwd`
- Current doc structure: !`find docs -type f -name "*.md" 2>/dev/null | head -30 || echo "no docs/ folder"`
- Doc file count: !`find docs -name "*.md" 2>/dev/null | wc -l || echo "0"`
- Folders without README: !`find docs -type d 2>/dev/null | while read d; do [ ! -f "$d/README.md" ] && echo "$d"; done | head -10 || echo "n/a"`

## User Options

$ARGUMENTS

## Your Task

Organize project documentation following the docs base skill at `~/.claude/skills/docs/SKILL.md` for naming conventions, folder structure standards, and document type classification.

Read `~/.claude/skills/docs-organize/SKILL.md` for the full workflow.

### Options Parsing

| Flag | Effect |
|------|--------|
| `--dry-run` | Show what would change without making modifications |
| `--refactor` | After organizing structure, also refactor content via `/docs-craft` |
| `--path <dir>` | Target specific subdirectory instead of entire docs/ |

Default (no options): audit and reorganize the entire `docs/` folder.

### Workflow Summary

1. **Audit** -- scan all docs, classify files, check naming, find duplicates, check README indexes
2. **Present report** -- show findings categorized by severity
3. **Execute** -- move/rename files with `git mv`, create missing READMEs, update cross-references
4. **Verify** -- check for broken references, confirm folder completeness
5. **Report** -- summarize all changes made

Use `git mv` for all moves to preserve history. Never copy+delete.
