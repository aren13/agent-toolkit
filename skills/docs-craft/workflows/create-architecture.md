# Workflow: Create Documentation Architecture

<required_reading>
Before starting, read:
- references/document-types.md - To understand organization patterns
- references/naming-conventions.md - Folder naming patterns
</required_reading>

<process>
## Step 1: Understand Project Context

Ask user: "Tell me about your project and current documentation state:"

Gather information:
1. **Project type** - Web app, library, API, platform, etc.
2. **Team size** - Solo, small team, large team
3. **Audience** - Developers, end-users, both
4. **Current docs** - None, some files, many files
5. **Pain points** - What's not working with current setup

## Step 2: Assess Current State

If documentation exists:

1. **Inventory files** using Glob
2. **Analyze structure:**
   - Where are docs located?
   - How are they organized?
   - What types exist?
   - What's missing?

3. **Identify issues:**
   - Hard to find information
   - No clear organization
   - Mixed purposes in same location
   - Outdated or orphaned docs

Create current state map if docs exist.

## Step 3: Define Documentation Needs

Based on project context, determine what documentation types are needed:

**For Web Applications:**
- Getting started guides (installation, setup)
- Feature documentation (what it does, how to use)
- How-to guides (common tasks)
- API reference (if has API)
- Integration docs (third-party services)
- Development guides (contributing, architecture)
- Deployment guides

**For Libraries/Packages:**
- Installation guide
- API reference (methods, parameters)
- Usage examples
- Configuration reference
- Migration guides
- Contributing guide

**For APIs:**
- Getting started (authentication, first request)
- API reference (endpoints, parameters)
- Webhook specifications
- Integration guides
- Error handling reference
- SDKs/client libraries

**For Platforms:**
- All of the above
- Security documentation
- Architecture documentation
- Runbooks/operations guides
- Roadmaps and planning docs

Ask user to confirm which categories they need.

## Step 4: Design Folder Structure

Create logical folder hierarchy:

### Standard Structure

```
docs/
├── README.md                 # Documentation index
├── getting-started/          # New user onboarding
│   ├── README.md
│   ├── installation-guide.md
│   ├── quickstart-guide.md
│   └── configuration-guide.md
│
├── how-to/                   # Task-oriented guides
│   ├── README.md
│   └── [specific-task-guide.md]
│
├── features/                 # Feature documentation
│   ├── README.md
│   └── [feature-name.md]
│
├── integrations/            # Third-party integrations
│   ├── README.md
│   └── [system-integration.md]
│
├── api/                     # API documentation (if applicable)
│   ├── README.md
│   ├── authentication-reference.md
│   ├── endpoints-reference.md
│   └── [api-spec.md]
│
├── development/             # Developer documentation
│   ├── README.md
│   ├── architecture.md
│   ├── contributing-guide.md
│   └── [roadmaps, specs]
│
├── security/                # Security documentation
│   ├── README.md
│   ├── cve/                # CVE fixes
│   └── [security-fix.md]
│
└── archive/                 # Outdated but kept for reference
    ├── README.md
    └── [old-doc-summary.md]
```

### Folder Descriptions

**getting-started/**
- Purpose: Help new users get up and running
- Contains: Installation, quickstart, basic configuration
- Audience: New users, first-time installers

**how-to/**
- Purpose: Task-oriented guides for specific goals
- Contains: Step-by-step guides for common tasks
- Audience: Users who need to accomplish something specific

**features/**
- Purpose: Explain what features exist and how they work
- Contains: Feature descriptions, components, configuration
- Audience: Users exploring capabilities

**integrations/**
- Purpose: Document external system integrations
- Contains: Integration guides, API docs, webhook specs
- Audience: Users connecting to external systems

**api/**
- Purpose: Complete API documentation
- Contains: Reference docs, specifications, examples
- Audience: API consumers, integration developers

**development/**
- Purpose: Information for contributors and maintainers
- Contains: Architecture, roadmaps, PRDs, contribution guides
- Audience: Developers working on the project

**security/**
- Purpose: Security-related documentation
- Contains: Vulnerability fixes, security guides, CVE reports
- Audience: Security team, compliance, developers

**archive/**
- Purpose: Historical documentation no longer current
- Contains: Summaries of old features, deprecated docs
- Audience: People researching history, migrations

## Step 5: Customize for Project

Adapt standard structure based on project needs:

**Add folders for:**
- `operations/` - If significant ops/deployment content
- `troubleshooting/` - If extensive debugging guides
- `reference/` - If lots of lookup-style content
- `tutorials/` - If comprehensive learning paths
- `examples/` - If many standalone examples

**Skip folders if:**
- No API → skip `api/`
- Small project → combine `how-to/` and `getting-started/`
- No integrations → skip `integrations/`
- Open source without security issues → skip `security/`

**Naming conventions:**
- All lowercase
- Plural nouns for category folders
- Hyphenated multi-word names
- Keep folder names short (1-2 words)

## Step 6: Create Index Structure

Design README.md files for navigation:

### Root docs/README.md

```markdown
# Documentation

Welcome to [Project Name] documentation.

## Getting Started

New to [Project Name]? Start here:
- [Installation Guide](./getting-started/installation-guide.md)
- [Quickstart Guide](./getting-started/quickstart-guide.md)
- [Configuration Guide](./getting-started/configuration-guide.md)

## How-To Guides

Task-oriented guides for specific goals:
- [Guide 1](./how-to/guide-1.md)
- [Guide 2](./how-to/guide-2.md)

## Features

Learn about [Project Name] features:
- [Feature 1](./features/feature-1.md)
- [Feature 2](./features/feature-2.md)

## API Reference

For developers integrating with our API:
- [API Documentation](./api/)

## Development

Contributing to [Project Name]:
- [Architecture](./development/architecture.md)
- [Contributing Guide](./development/contributing-guide.md)

## Additional Resources

- [Integrations](./integrations/)
- [Security](./security/)
```

### Folder README.md

```markdown
# [Folder Name]

[Brief description of what this section contains]

## Documents

- [Document 1](./document-1.md) - Brief description
- [Document 2](./document-2.md) - Brief description

## Related

- [Link to related section](../other-folder/)
```

## Step 7: Plan Document Migration

If existing docs need reorganization:

1. **Map old → new locations:**
   ```
   docs/setup.md → docs/getting-started/installation-guide.md
   docs/API.md → docs/api/endpoints-reference.md
   docs/features.md → Split into docs/features/[feature-name.md]
   ```

2. **Identify redirects needed:**
   - Old links that need updating
   - External links to update
   - README references to change

3. **Create migration plan:**
   ```
   Phase 1: Create new structure (folders + READMEs)
   Phase 2: Move/rename files
   Phase 3: Update internal links
   Phase 4: Update external references
   Phase 5: Add redirects if needed
   Phase 6: Remove old empty folders
   ```

## Step 8: Create Structure

Execute the plan:

1. **Create folders** using Bash mkdir -p
2. **Create README.md** in each folder
3. **Create root index** docs/README.md
4. **Move files** if migration needed
5. **Update links** throughout documentation
6. **Add .gitkeep** to empty folders if needed

## Step 9: Document the Architecture

Create architecture guide:

```markdown
# Documentation Architecture

> **Last Updated:** YYYY-MM-DD

This document explains how documentation is organized in this project.

## Structure

[Folder tree diagram]

## Folder Purposes

### getting-started/
[Description and what belongs here]

### how-to/
[Description and what belongs here]

[... for each folder ...]

## Document Types

Each document follows a specific type:
- Guides (`-guide.md`) - [Description]
- References (`-reference.md`) - [Description]
[... etc ...]

See [documentation guidelines](./documentation-guideline.md) for details.

## Adding New Documentation

1. Determine document type
2. Place in appropriate folder
3. Follow naming convention
4. Use appropriate template
5. Add to folder README.md

## Naming Convention

- All lowercase: `api-guide.md` not `API-Guide.md`
- Use hyphens: `user-auth.md` not `user_auth.md`
- Add type suffix: `setup-guide.md` not `setup.md`
- Max 50 characters

## Maintenance

- Update "Last Updated" dates when editing
- Keep README indexes current
- Archive outdated docs to archive/
- Review quarterly for accuracy
```

## Step 10: Provide Usage Guide

Show user how to use the new structure:

**For adding new docs:**
1. Determine type and folder
2. Use naming convention
3. Follow template
4. Update README

**For finding docs:**
- Start at docs/README.md
- Browse by category
- Use folder READMEs
- Follow cross-references

**For maintaining:**
- Keep READMEs updated
- Archive old docs
- Update links when moving files
- Regular compliance checks

Present structure to user with navigation guide.
</process>

<success_criteria>
Architecture is successful when:
- Structure matches project needs
- Folders have clear, distinct purposes
- Navigation is intuitive (easy to find things)
- README files provide good overview
- Document types have consistent placement
- Structure is scalable (can grow without refactor)
- Team understands where things go
- User confirms structure works for their needs
</success_criteria>

<examples>
## Example 1: Small Open Source Library

**Project:** Ruby gem for API client

**Needs:**
- Getting started (installation, first request)
- API reference (methods)
- Examples
- Contributing guide

**Structure:**
```
docs/
├── README.md
├── getting-started-guide.md    # Installation + first request
├── api-reference.md            # All methods in one doc
├── examples/                   # Multiple example files
│   ├── README.md
│   ├── basic-usage.md
│   └── advanced-usage.md
└── contributing-guide.md
```

**Reasoning:** Simple structure for small project. No need for many folders.

## Example 2: Large SaaS Platform

**Project:** Multi-tenant food management platform

**Needs:**
- User documentation (guides, features)
- API documentation (multiple APIs)
- Integration docs (many third parties)
- Developer docs (architecture, roadmaps)
- Security docs (CVEs, fixes)
- Operations docs (deployment, monitoring)

**Structure:**
```
docs/
├── README.md
├── documentation-guideline.md
├── getting-started/
├── how-to/
├── features/
├── integrations/
│   ├── migros/
│   ├── metro/
│   └── makro/
├── api/
│   ├── v1/
│   ├── v2/
│   └── retailer/
├── development/
│   ├── architecture/
│   ├── roadmaps/
│   └── specs/
├── operations/
│   ├── deployment/
│   └── monitoring/
├── security/
│   └── cve/
└── archive/
```

**Reasoning:** Complex project needs detailed categorization. Nested folders for major categories with many docs.

## Example 3: Migration from Flat Structure

**Before:**
```
docs/
├── API.md
├── Setup.md
├── Features.md
├── Security_Fix.md
├── Troubleshooting.md
└── whatsapp.md
```

**Issues:**
- Inconsistent naming
- No organization
- Hard to scale
- Mixed purposes

**After:**
```
docs/
├── README.md
├── getting-started/
│   ├── README.md
│   ├── installation-guide.md    # was Setup.md
│   └── troubleshooting-guide.md # was Troubleshooting.md
├── features/
│   ├── README.md
│   ├── whatsapp-notifications.md # was whatsapp.md
│   └── [split from Features.md]
├── api/
│   ├── README.md
│   └── endpoints-reference.md   # was API.md
└── security/
    ├── README.md
    └── csp-fix.md               # was Security_Fix.md
```

**Migration:**
1. Created folder structure
2. Renamed and moved files
3. Updated links (12 updates)
4. Created READMEs
5. Split Features.md into separate files
</examples>
