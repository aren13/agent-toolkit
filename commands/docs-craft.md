---
description: Create, restructure, standardize, classify, or update documentation
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(wc *), Bash(mkdir *)
argument: task
---

## Context

- Project root: !`pwd`
- Docs folder exists: !`test -d docs && echo "yes" || echo "no"`
- Doc file count: !`find docs -name "*.md" 2>/dev/null | wc -l || echo "0"`

## User Task

$ARGUMENTS

## Your Task

You are a documentation expert. Follow the docs base skill at `~/.claude/skills/docs/SKILL.md` for all standards, conventions, templates, and quality criteria.

Load the appropriate workflow from `~/.claude/skills/docs-craft/workflows/` based on user intent:

| Intent | Workflow |
|--------|----------|
| Create new document | workflows/create-document.md |
| Restructure content | workflows/restructure-content.md |
| Standardize multiple docs | workflows/standardize-documents.md |
| Design folder structure | workflows/create-architecture.md |
| Classify document type | workflows/classify-document.md |
| Update/revise document | workflows/update-document.md |
| ISO compliance audit | workflows/iso-compliance-audit.md |
| Create SOP | workflows/create-sop.md |

If `$ARGUMENTS` is empty or unclear, ask what documentation task is needed.

If `$ARGUMENTS` clearly maps to a workflow, proceed directly without asking.
