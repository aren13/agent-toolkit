---
name: docs-craft
description: Interactive documentation creation, restructuring, and standardization. Routes to specialized workflows for creating, auditing, restructuring, classifying, and updating documents. Uses docs base skill for standards and templates.
---

<objective>
Transform unstructured information into professional, standardized documentation. This skill provides the interactive routing and specialized workflows. All standards, conventions, templates, and references live in the docs base skill.
</objective>

<intake>
What documentation task do you need help with?

1. **Create new document** - Write a new document from scratch
2. **Restructure content** - Transform unstructured content into proper documentation
3. **Standardize multiple documents** - Apply consistent standards across a set of docs
4. **Create documentation architecture** - Design folder structure and organization
5. **Classify document** - Determine correct document type and location
6. **Update/maintain document** - Revise existing documentation
7. **ISO compliance audit** - Audit SOPs/procedures against ISO 9001 standards (scoring 0-100)
8. **Create SOP** - Create ISO 9001 compliant Standard Operating Procedure

**Respond with the number, keyword, or describe your need.**
</intake>

<routing>
| User Response | Workflow |
|---------------|----------|
| 1, "create", "new", "write" | workflows/create-document.md |
| 2, "restructure", "transform", "organize content" | workflows/restructure-content.md |
| 3, "standardize", "multiple", "batch" | workflows/standardize-documents.md |
| 4, "architecture", "structure", "organize project" | workflows/create-architecture.md |
| 5, "classify", "type", "what kind" | workflows/classify-document.md |
| 6, "update", "maintain", "revise" | workflows/update-document.md |
| 7, "ISO", "compliance", "ISO 9001", "ISO audit" | workflows/iso-compliance-audit.md |
| 8, "SOP", "procedure", "create SOP" | workflows/create-sop.md |

**Direct routing (if user provides clear intent):**
- User provides document type directly -> workflows/create-document.md
- User provides path to document -> workflows/update-document.md
- User describes unstructured content -> workflows/restructure-content.md
- User asks "what type should this be?" -> workflows/classify-document.md
- User mentions "ISO", "SOP", "compliance" -> workflows/iso-compliance-audit.md or workflows/create-sop.md

**After loading the workflow, follow it exactly. The workflow specifies which references and templates to load from the docs base skill.**

**Standards and references:** All conventions, naming rules, writing style, quality checklists, document type definitions, and templates are in the `docs` base skill at `~/.claude/skills/docs/`. Workflows reference them as `references/` and `templates/` relative to that skill.
</routing>
