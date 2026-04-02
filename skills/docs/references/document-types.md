# Document Types Reference

Complete guide to each documentation type, when to use them, and their characteristics.

## Overview

Each document type serves a specific purpose and follows a specific template structure. Choosing the correct type ensures consistency and helps readers know what to expect.

---

## Guide (`-guide.md`)

### Purpose
Teach readers how to accomplish a specific task through step-by-step instructions.

### When to Use
- User needs to perform a procedure
- Multiple steps are involved
- Prerequisites or setup is needed
- Common problems might occur

### Key Characteristics
- **Procedural** - Step-by-step numbered instructions
- **Goal-oriented** - Focused on accomplishing something
- **Complete** - Includes prerequisites, steps, verification, troubleshooting
- **Practical** - Has working examples and commands

### Required Sections
1. Title and metadata (last updated date)
2. Brief description of what will be accomplished
3. Prerequisites
4. Steps (with substeps if needed)
5. Verification/testing section (optional but recommended)
6. Troubleshooting (optional but recommended)
7. Related documentation

### Keywords that Indicate Guide
- "How to..."
- "Setting up..."
- "Installing..."
- "Configuring..."
- Tutorial, walkthrough, setup, installation, configuration

### Examples
- `installation-guide.md` - How to install the application
- `deployment-guide.md` - How to deploy to production
- `quickstart-guide.md` - How to get started quickly
- `migration-guide.md` - How to migrate from old version

---

## Reference (`-reference.md`)

### Purpose
Provide comprehensive lookup information organized for quick access.

### When to Use
- Reader needs to look up specific information
- Complete coverage of options/parameters/endpoints
- Minimal narrative, maximal factual information
- Used as reference material, not read start-to-finish

### Key Characteristics
- **Comprehensive** - Complete coverage of topic
- **Organized** - Structured by categories or alphabetically
- **Concise** - Minimal prose, focus on facts
- **Tabular** - Heavy use of tables for structured data
- **Searchable** - Easy to scan and find specific items

### Required Sections
1. Title and metadata
2. Overview (what this reference covers)
3. Categorized content (tables, lists, definitions)
4. Examples (showing how to use the reference info)
5. See also / related references

### Keywords that Indicate Reference
- "API documentation"
- "Configuration options"
- "Parameters"
- "Environment variables"
- "Commands"
- Reference, lookup, spec sheet, options, parameters

### Examples
- `api-reference.md` - Complete API endpoint documentation
- `configuration-reference.md` - All config options with defaults
- `cli-reference.md` - All command-line commands and flags
- `environment-variables-reference.md` - All ENV vars

---

## Fix (`-fix.md`)

### Purpose
Document a specific bug fix, security patch, or hotfix with technical details.

### When to Use
- Documenting a bug fix
- Documenting a security vulnerability fix
- Recording technical details of a patch
- Need to track what was changed and why

### Key Characteristics
- **Specific** - Documents one particular fix
- **Technical** - Includes code changes, root cause
- **Traceable** - Has ticket/CVE numbers
- **Actionable** - Includes testing and deployment steps
- **Dated** - Has specific date and severity

### Required Sections
1. Title and metadata (date, ticket, severity, status)
2. Summary (one paragraph)
3. Issue details (problem, impact, root cause)
4. Solution (changes made, files modified, code snippets)
5. Testing (verification steps, test commands)
6. Deployment (prerequisites, steps)
7. References (related tickets, CVEs, docs)

### Keywords that Indicate Fix
- "Bug fix"
- "Vulnerability fix"
- "Security patch"
- "Hotfix"
- CVE, security, patch, fix, vulnerability

### Examples
- `sql-injection-fix.md` - SQL injection vulnerability fix
- `csp-fix.md` - Content Security Policy fix
- `memory-leak-fix.md` - Memory leak bug fix
- `cve-2024-1234-fix.md` - CVE-specific fix

---

## PRD (`-prd.md`)

### Purpose
Define product requirements and specifications for a feature or project.

### When to Use
- Planning a new feature
- Defining requirements before implementation
- Need stakeholder alignment
- Complex feature with multiple requirements

### Key Characteristics
- **Comprehensive** - Covers all aspects of requirements
- **Structured** - Formal sections (intro, requirements, acceptance)
- **Versioned** - Has version number and change history
- **Stakeholder-focused** - Written for decision-makers
- **Testable** - Includes acceptance criteria

### Required Sections
1. Title and metadata (version, date, status)
2. Document history
3. Introduction (purpose, background, scope, glossary)
4. Product overview (vision, audience, benefits)
5. User stories
6. Functional requirements
7. Non-functional requirements
8. Technical implementation (high-level)
9. Acceptance criteria
10. Appendices (if needed)

### Keywords that Indicate PRD
- "Requirements"
- "Feature specification"
- "Product spec"
- "User stories"
- Requirements, specification, feature spec, PRD

### Examples
- `retailer-api-prd.md` - Requirements for retailer API
- `mobile-app-prd.md` - Requirements for mobile application
- `notification-system-prd.md` - Requirements for notifications

---

## Spec (`-spec.md`)

### Purpose
Define technical specifications, protocols, or contracts with precise details.

### When to Use
- Defining API contract
- Defining webhook protocol
- Specifying data format
- Integration specifications

### Key Characteristics
- **Precise** - Exact technical details
- **Complete** - All endpoints/methods documented
- **Format-focused** - Request/response formats specified
- **Example-rich** - Shows actual requests/responses
- **Versioned** - Has version and changelog

### Required Sections
1. Title and metadata (version, last updated)
2. Overview
3. Protocol details (authentication, format)
4. Endpoints/methods (with full details)
5. Request format
6. Response format
7. Error codes
8. Examples (working curl commands)
9. Changelog

### Keywords that Indicate Spec
- "API specification"
- "Webhook spec"
- "Protocol"
- "Contract"
- "Integration spec"
Specification, protocol, contract, API spec, webhook

### Examples
- `webhook-spec.md` - Webhook protocol specification
- `api-v2-spec.md` - API version 2 specification
- `data-format-spec.md` - Data exchange format spec

---

## Summary (`-summary.md`)

### Purpose
Provide high-level overview, executive summary, or recap of an event/decision/ticket.

### When to Use
- Summarizing a project or initiative
- Summarizing a completed ticket
- Executive overview of a topic
- Post-mortem or incident report
- Archiving work with context

### Key Characteristics
- **Concise** - Brief, to the point
- **High-level** - Not deep technical details
- **Key points** - Highlights most important info
- **Results-focused** - Outcomes and next steps
- **Standalone** - Can be read without other docs

### Required Sections
1. Title and metadata (date, ticket if applicable, status)
2. Overview (2-3 sentence executive summary)
3. Key points (bulleted list)
4. Details (organized by topic)
5. Results/outcomes (with metrics if applicable)
6. Next steps
7. References

### Keywords that Indicate Summary
- "Overview"
- "Summary"
- "Executive summary"
- "Recap"
- "Post-mortem"
Summary, overview, recap, highlights, executive summary

### Examples
- `project-summary.md` - Project completion summary
- `sms-6382-summary.md` - Ticket work summary
- `incident-summary.md` - Incident post-mortem summary
- `cve-summary.md` - CVE overview summary

---

## Roadmap (`-roadmap.md`)

### Purpose
Track planned work, milestones, and progress over time.

### When to Use
- Planning multi-phase work
- Tracking refactoring progress
- Project planning and milestones
- Need to show progress status

### Key Characteristics
- **Time-oriented** - Organized by phases or time
- **Status-tracked** - Shows what's done/in-progress/todo
- **Detailed** - Items with descriptions
- **Living document** - Updated regularly
- **Progress-focused** - Shows completion percentage

### Required Sections
1. Title and metadata (created, last updated, status)
2. Overview/purpose
3. Progress overview (table with completion %)
4. Phases (with item tables showing status and PRs)
5. Item details (expanded descriptions)
6. Completed items log (dated entries)
7. Execution guidelines

### Keywords that Indicate Roadmap
- "Roadmap"
- "Planning"
- "Milestones"
- "Phases"
- "Backlog"
Roadmap, planning, milestones, phases, backlog, progress

### Examples
- `refactoring-roadmap.md` - Code refactoring plan and progress
- `feature-roadmap.md` - Feature development roadmap
- `migration-roadmap.md` - Migration project roadmap

---

## Work Instruction (`WI-XX-NNN.md` or `-wi.md`)

### Purpose
Provide highly detailed, task-specific guidance for ONE job that teaches a novice to perform correctly.

### When to Use
- Single, granular task needs documentation
- Operator must follow exact steps for equipment/tool
- Visual aids (photos, diagrams) are essential
- Task requires troubleshooting guidance
- Equipment or technique has specific requirements

### Key Characteristics
- **Granular** - Single task focus (one job, one procedure)
- **Visual-heavy** - Photos, diagrams, screenshots essential
- **Operator-focused** - Written for the person doing the work
- **Troubleshooting-included** - Common issues and solutions
- **Equipment-specific** - Tied to specific tools/equipment
- **Immediately actionable** - No background reading needed

### Required Sections
1. Title and metadata (WI number, version, effective date)
2. Equipment/tools list (with locations)
3. Before use checklist (setup, verification)
4. Step-by-step procedure (with visual references)
5. After use checklist (cleanup, storage)
6. Troubleshooting table (issue → solution format)
7. Visual attachments (photos with captions)

### Keywords that Indicate Work Instruction
- "How to operate..."
- "Using the [equipment]..."
- "Step-by-step for [task]..."
- Work instruction, operator guide, equipment operation, task procedure

### WI Number Format
`WI-[CATEGORY]-[NNN]` (e.g., WI-EQ-012, WI-LAB-003)

Categories mirror SOP categories but may include:
- **EQ** - Equipment operation
- **LAB** - Laboratory procedures
- **MFG** - Manufacturing tasks
- **QC** - Quality control checks
- **IT** - IT system operations

### Structure Template

```markdown
# [Task Name]

**WI-XX-NNN** | [Full Title] | For: [Target Role/Department]

## Equipment
[Equipment name] (located in [location])

## Before Use
1. [Setup step with verification]
2. [Check step - If failed → action]

## Procedure: [Task Name]
1. [Action with specific parameters]
2. [Action with visual reference: [PHOTO: description]]
3. [Wait/timing instruction with indicator]
4. [Recording/documentation step]

## After Use
1. [Cleanup step]
2. [Storage instruction with orientation/position]

## Troubleshooting
| Issue | Solution |
|-------|----------|
| [Symptom] | [Fix or escalation] |
| [Error message] | [Resolution] |

[PHOTO: Description of visual aid]
```

### Difference from SOP

| Aspect | SOP | Work Instruction |
|--------|-----|------------------|
| Scope | Process (multiple tasks) | Single task |
| Audience | Department/role | Individual operator |
| Detail level | What to do | Exactly how to do it |
| Visuals | Optional flowcharts | Required photos/diagrams |
| Length | Multi-page | Usually 1-2 pages |
| Update trigger | Process change | Equipment/technique change |

### Examples
- `WI-EQ-012-digital-thermometer.md` - Operating digital thermometer
- `WI-LAB-003-ph-meter-calibration.md` - Calibrating pH meter
- `WI-IT-015-badge-printer-operation.md` - Using badge printer
- `receiving-inspection-wi.md` - Receiving dock inspection procedure

---

## Feature (no suffix required)

### Purpose
Document a specific feature or capability of the system.

### When to Use
- Describing what a feature does
- Explaining feature components
- Documenting feature configuration
- Providing feature usage examples

### Key Characteristics
- **Descriptive** - Explains what and why
- **Component-focused** - Details the parts
- **Configuration** - How to set it up
- **Usage examples** - How to use it
- **Troubleshooting** - Common issues

### Required Sections
1. Title and metadata (last updated)
2. Brief description
3. Overview (what it does, why it exists)
4. Components (the parts)
5. Workflow (how it works)
6. Configuration (env vars, settings)
7. Usage (examples)
8. Troubleshooting (common issues)
9. Related features/docs

### Keywords that Indicate Feature
- "Feature:"
- "Module:"
- "Capability:"
- Feature, component, module, capability, system

### Examples
- `whatsapp-notifications.md` - WhatsApp notification feature
- `donation-tracking.md` - Donation tracking feature
- `smart-scale-integration.md` - Smart scale feature
- `multi-tenant-support.md` - Multi-tenancy feature

---

## Decision Matrix

Use this table when unclear which type to choose:

| If the content... | Then use... |
|-------------------|-------------|
| Teaches how to do something | Guide |
| Lists options/parameters to look up | Reference |
| Documents a bug/security fix | Fix |
| Defines product requirements | PRD |
| Specifies technical protocol/API | Spec |
| Summarizes what happened | Summary |
| Tracks planned work and progress | Roadmap |
| Describes a system feature | Feature |
| Details one specific equipment/task operation | Work Instruction |
| Documents a multi-step business process | SOP |

### SOP vs Work Instruction Decision

| Question | If Yes → | If No → |
|----------|----------|---------|
| Does it cover multiple related tasks? | SOP | Work Instruction |
| Does it need RACI/governance? | SOP | Work Instruction |
| Is it for a single piece of equipment? | Work Instruction | SOP |
| Does a novice need photos to follow it? | Work Instruction | SOP |
| Does it span departments/roles? | SOP | Work Instruction |

## Combination Patterns

Sometimes you need multiple documents:

**Feature + Guide:**
- Feature doc: What it is, what it does
- Guide doc: How to set it up and use it

**PRD + Spec:**
- PRD: Business requirements, user stories
- Spec: Technical implementation, API contract

**Summary + Fix:**
- Summary: High-level incident overview
- Fix: Detailed technical fix documentation

**Guide + Reference:**
- Guide: How to use the tool
- Reference: All commands and options

**Roadmap + PRDs:**
- Roadmap: Overall plan and phases
- Multiple PRDs: Detailed requirements for each phase
