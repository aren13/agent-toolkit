# Workflow: Create ISO 9001 Compliant SOP

<required_reading>
Before starting, read:
- references/iso-9001-standards.md - Full ISO 9001 documentation standards
- templates/sop-template.md - SOP template with all 15 elements
</required_reading>

<process>
## Step 1: Gather Requirements

Ask user for:

1. **Process Name** - What procedure is being documented?
2. **Category/Department** - For SOP number (e.g., HR, IT, QA, OPS)
3. **Target Location** - Where should this SOP be saved?
4. **Key Stakeholders** - Who performs, approves, consults on this process?

## Step 2: Analyze Project Context

1. **Check project structure** using Glob
2. **Find existing SOPs** to determine:
   - Naming patterns used
   - Next sequential number for category
   - Existing cross-references
3. **Check for CLAUDE.md** or project conventions

## Step 3: Generate SOP Number

Format: `SOP-[CATEGORY]-[NNN]`

1. Determine category code:
   - Use project's existing codes if defined
   - Or standard codes: HR, IT, QA, OPS, FIN, MKT, DEV, SEC
2. Find highest existing number in category
3. Increment by 1

Example: If SOP-IT-002 exists → new SOP is SOP-IT-003

## Step 4: Set Version Metadata

1. **Version**: Current datetime as `YYYYMMDD_HHMM`
   - Example: December 16, 2025 at 2:30 PM → `20251216_1430`

2. **Effective Date**: Today's date as `YYYY-MM-DD`

3. **Review Date**: Effective date + 6 months

## Step 5: Draft Header Section

```markdown
# SOP: [Descriptive Title Based on Process Name]

| Field | Value |
|-------|-------|
| **SOP Number** | SOP-[XX]-[NNN] |
| **Version** | [YYYYMMDD_HHMM] |
| **Effective Date** | [YYYY-MM-DD] |
| **Review Date** | [YYYY-MM-DD] |
| **Page** | Page 1 of 1 |
```

## Step 6: Draft Administrative Section

### Purpose
Ask user: "In one sentence, WHY does this procedure exist?"

Format: "To [ensure/provide/establish] [outcome]."

### Scope
Ask user:
- "Who performs this procedure?" (Applies to)
- "What activities does it cover?" (Covers)
- "What is explicitly NOT included?" (Excludes)

### Definitions
Ask user: "Are there any technical terms or acronyms that need definition?"

If uncertain, create placeholder:
```markdown
| Term | Definition |
|------|------------|
| [TODO: Add terms] | [TODO: Add definitions] |
```

### RACI Matrix
Based on stakeholders provided, draft:

```markdown
| Task | Responsible | Accountable | Consulted | Informed |
|------|-------------|-------------|-----------|----------|
| [Main task] | [Doer] | [Owner] | [Advisor] | [Stakeholder] |
```

Rules:
- ONE Accountable per task
- At least one Responsible per task
- Consulted = two-way communication
- Informed = one-way updates

### References
- Link to related SOPs in the project
- Link to external standards if applicable
- Link to parent workflow/process document

## Step 7: Draft Procedure Section

Ask user: "Walk me through the steps of this process."

For each phase/step:

1. **Name the phase** with time estimate
2. **List preconditions** - what must be true before starting
3. **Write steps** using imperative verbs:
   - Record, Verify, Submit, Create, Update, Review, etc.
4. **Identify decision points** - if/then branching
5. **Note phase output** - what artifact or state results

Format each step as:
```markdown
1. **[Verb]** [specific task with measurable outcome].
   - [Sub-step if needed]
   - [Sub-step if needed]
```

## Step 8: Draft Supporting Sections

### Safety/Precautions
Ask user: "What could go wrong? What should be avoided?"

Include:
- Common mistakes and how to prevent them
- Quality checkpoints
- Risk factors and mitigation

### Quality Checklist
Create verification criteria for completion:

```markdown
- [ ] [Specific, measurable criterion]
- [ ] [Specific, measurable criterion]
- [ ] Output saved to [specified location]
```

### Attachments
List any:
- Templates used in the procedure
- Forms to fill out
- Checklists to follow
- Flowcharts or diagrams

### Revision History
Initialize with:

```markdown
| Version | Date | Author | Change Summary |
|---------|------|--------|----------------|
| [YYYYMMDD_HHMM] | [YYYY-MM-DD] | [Author] | Initial version |
```

## Step 9: Validate Against 15-Element Checklist

Before saving, verify all elements present:

**Header (5):**
- [ ] Title - Descriptive and searchable
- [ ] SOP Number - SOP-XX-NNN format
- [ ] Version - YYYYMMDD_HHMM format
- [ ] Effective Date - YYYY-MM-DD
- [ ] Review Date - 6 months from effective

**Administrative (5):**
- [ ] Purpose - 1-2 sentences, starts with "To..."
- [ ] Scope - Applies to, Covers, Excludes
- [ ] Definitions - All terms explained (or N/A)
- [ ] RACI - All tasks assigned, one A per task
- [ ] References - Related docs listed

**Body (5):**
- [ ] Procedure - Numbered steps, imperative verbs
- [ ] Safety/Precautions - Risks addressed
- [ ] Quality Checklist - Verification criteria
- [ ] Attachments - Templates/forms listed
- [ ] Revision History - Initial entry

## Step 10: Write the SOP

Using Write tool, create the complete SOP file at the specified location.

## Step 11: Post-Creation Tasks

1. **Update README** if the folder has one
2. **Add cross-references** from related SOPs
3. **Notify user** of:
   - File location
   - SOP number assigned
   - Review date
   - Any [TODO] items requiring attention

## Step 12: Offer ISO Audit

Ask user: "Would you like me to audit this SOP for ISO compliance?"

If yes, run workflows/iso-compliance-audit.md on the new file.
</process>

<success_criteria>
SOP creation is successful when:
- All 15 elements are present
- SOP number follows project conventions
- Version uses YYYYMMDD_HHMM format
- Review date is 6 months from effective
- All procedure steps use imperative verbs
- RACI has exactly one Accountable per task
- Quality checklist has measurable criteria
- Revision history is initialized
- File is saved to correct location
- ISO compliance audit scores >= 90 (if run)
</success_criteria>

<examples>
## Example: Creating SOP for Code Review Process

**Input:**
- Process: Code Review
- Category: DEV
- Location: docs/sops/

**Generated:**

```markdown
# SOP: Code Review Process

| Field | Value |
|-------|-------|
| **SOP Number** | SOP-DEV-001 |
| **Version** | 20251216_1430 |
| **Effective Date** | 2025-12-16 |
| **Review Date** | 2026-06-16 |
| **Page** | Page 1 of 1 |

---

## Purpose

To ensure all code changes are reviewed for quality, security, and adherence to coding standards before merging to main branch.

## Scope

**Applies to:** All developers contributing code to the repository

**Covers:** Pull request review process, approval requirements, merge criteria

**Excludes:** Automated CI/CD checks (covered in SOP-DEV-002), hotfix procedures (SOP-DEV-003)

## Definitions

| Term | Definition |
|------|------------|
| PR | Pull Request - a proposed code change |
| LGTM | "Looks Good To Me" - approval comment |
| Blocking Comment | Issue that must be resolved before merge |

## Responsibilities (RACI)

| Task | Responsible | Accountable | Consulted | Informed |
|------|-------------|-------------|-----------|----------|
| Submit PR | Developer | Developer | - | Team |
| Review Code | Reviewer | Tech Lead | Senior Dev | Team |
| Approve/Request Changes | Reviewer | Tech Lead | - | Developer |
| Merge PR | Developer | Tech Lead | - | Team |

## References

- SOP-DEV-002: CI/CD Pipeline
- SOP-DEV-003: Hotfix Procedures
- CONTRIBUTING.md

---

## Procedure

### 1. Submit Pull Request (10 min)

**Preconditions:**
- Code changes are complete and tested locally
- Branch is up to date with main

**Steps:**

1. **Push** feature branch to remote repository.

2. **Create** pull request with:
   - Descriptive title summarizing the change
   - Description explaining what and why
   - Link to related issue/ticket

3. **Assign** at least one reviewer.

4. **Label** PR appropriately (feature, bugfix, docs, etc.).

**Decision Point:**
- If PR is draft: Mark as "Draft" and skip to monitoring
- If PR is ready: Proceed to Phase 2

### 2. Code Review (30 min)

**Preconditions:**
- PR is submitted and assigned

**Steps:**

1. **Review** code changes for:
   - Correctness and logic
   - Security vulnerabilities
   - Performance implications
   - Code style compliance

2. **Add** comments:
   - Blocking comments for issues requiring change
   - Non-blocking suggestions for improvements

3. **Approve** or **Request Changes** based on review.

**Decision Point:**
- If changes requested: Developer addresses feedback, return to Step 1 of Phase 2
- If approved: Proceed to Phase 3

### 3. Merge (5 min)

**Preconditions:**
- PR has required approvals
- All CI checks pass

**Steps:**

1. **Verify** all conversations are resolved.

2. **Squash and merge** PR to main branch.

3. **Delete** feature branch after merge.

4. **Update** related issue/ticket status.

---

## Safety/Precautions

- Never merge without at least one approval
- Resolve all blocking comments before merge
- Verify CI checks pass before merge
- Do not self-approve PRs (exception: trivial docs changes)

## Quality Checklist

- [ ] PR has descriptive title and description
- [ ] At least one reviewer assigned
- [ ] All CI checks pass
- [ ] Required approvals obtained
- [ ] All blocking comments resolved
- [ ] Branch deleted after merge

## Attachments

| Type | Name | Location |
|------|------|----------|
| Template | PR Template | `.github/PULL_REQUEST_TEMPLATE.md` |
| Checklist | Review Checklist | `docs/code-review-checklist.md` |

---

## Revision History

| Version | Date | Author | Change Summary |
|---------|------|--------|----------------|
| 20251216_1430 | 2025-12-16 | Claude | Initial version |
```
</examples>
