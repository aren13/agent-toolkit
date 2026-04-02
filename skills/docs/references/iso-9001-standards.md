# ISO 9001 Documentation Standards

Reference for ISO 9001/ISO 30301 compliant documentation. Use when creating SOPs, procedures, or formal business documentation.

## Document Hierarchy (ISO Model)

| Level | Type | Purpose | Review Cycle |
|-------|------|---------|--------------|
| 1 | **Policy** | Strategic direction, "what we do and why" | Annually |
| 2 | **Process** | High-level workflow, "how we achieve policy" | Annually |
| 3 | **Procedure (SOP)** | Detailed steps, "how to do specific tasks" | 6 months |
| 4 | **Work Instruction** | Granular task steps, "exactly how to perform" | 6 months |
| 5 | **Forms/Records** | Evidence of execution, "proof it was done" | As needed |

## SOP Number Format

`SOP-[CATEGORY]-[NNN]`

- **CATEGORY**: 2-3 letter code for domain/department (e.g., HR, IT, QA, OPS, FIN, MKT, DEV, SEC)
- **NNN**: Sequential number (001, 002, etc.)

Derive category codes from the project's existing structure or domain.

## Version Format

`YYYYMMDD_HHMM` (e.g., 20251216_1430)

**When to increment:**
- Any procedure step changes
- RACI assignments change
- References are added/removed
- Quality criteria change

**Do NOT increment for:**
- Typo corrections (note as "Editorial corrections")
- Formatting-only changes (note as "Format standardization")

## 15-Element SOP Standard

Every SOP MUST contain these elements:

### Header Section (5 elements)
1. **Title** - Descriptive and searchable
2. **SOP Number** - Unique identifier (SOP-XX-NNN)
3. **Version** - YYYYMMDD_HHMM format
4. **Effective Date** - YYYY-MM-DD
5. **Review Date** - 6 months from effective date

### Administrative Section (5 elements)
6. **Purpose** - WHY this SOP exists (1-2 sentences, start with "To ensure/provide/establish...")
7. **Scope** - WHO it applies to, WHAT it covers, EXCLUDES
8. **Definitions** - Technical terms/abbreviations clarified
9. **Responsibilities (RACI)** - Responsible, Accountable, Consulted, Informed matrix
10. **References** - Related SOPs, regulations, standards

### Body Section (5 elements)
11. **Procedure Steps** - Numbered, sequential, action-oriented (imperative verbs)
12. **Safety/Precautions** - Warnings, quality check points
13. **Quality Checklist** - Verification criteria
14. **Attachments** - Templates, flowcharts, forms
15. **Revision History** - Version, date, author, change summary

## RACI Matrix

| Role | Description |
|------|-------------|
| **R** (Responsible) | Performs the work |
| **A** (Accountable) | Final authority, approves (ONE per task) |
| **C** (Consulted) | Provides input (two-way communication) |
| **I** (Informed) | Kept updated (one-way communication) |

## The 5 C's of Documentation

1. **CLEAR** - One interpretation only
   - Use active voice with imperative verbs
   - Avoid: "should be", "may", "might", "adequate", "sufficient"

2. **CONCISE** - Minimum words, maximum clarity
   - One action per step
   - Remove filler words
   - Use tables for structured data

3. **COMPLETE** - No gaps in instructions
   - Include decision criteria
   - Specify quantities and parameters
   - Define all acronyms on first use

4. **CONSISTENT** - Same terminology throughout
   - Use project glossary terms
   - Match capitalization patterns
   - Reference documents by SOP number

5. **CURRENT** - Up-to-date and reviewed
   - Version format: YYYYMMDD_HHMM
   - Review date always 6 months ahead
   - Revision history tracks all changes

## Imperative Verbs for Procedures

**DO use:**
- Record, Document, Log
- Verify, Validate, Confirm, Check
- Submit, Send, Transmit
- Review, Analyze, Assess
- Create, Generate, Produce
- Update, Modify, Edit
- Archive, Store, Save
- Notify, Inform, Alert
- Complete, Finalize, Close
- Open, Start, Begin, Initiate

**DO NOT use:**
- "Should be done" → "Do"
- "Can be performed" → "Perform"
- "Is recorded" → "Record"
- "May need to" → "If [condition], then [action]"

## Compliance Audit Scoring

### Header Section (20 points)
- (4 pts) Title is descriptive and searchable
- (4 pts) SOP Number follows SOP-XX-NNN format
- (4 pts) Version uses YYYYMMDD_HHMM format
- (4 pts) Effective Date is present and valid
- (4 pts) Review Date is 6 months from effective date

### Administrative Section (30 points)
- (6 pts) Purpose clearly states WHY
- (6 pts) Scope defines WHO, WHAT, and exclusions
- (6 pts) Definitions explain all technical terms
- (6 pts) RACI matrix assigns all responsibilities
- (6 pts) References list related documents

### Body Section (30 points)
- (8 pts) Procedure uses numbered, sequential steps
- (6 pts) Each step uses imperative verb
- (6 pts) Decision points have clear criteria
- (4 pts) Safety/Precautions addresses risks
- (6 pts) Quality Checklist provides verification criteria

### Supporting Elements (20 points)
- (10 pts) Attachments list templates/forms used
- (10 pts) Revision History tracks all changes

### Deductions
- (-5 pts each) Passive voice in procedure steps
- (-5 pts each) Vague terms ("adequate", "sufficient", "appropriate")
- (-3 pts each) Missing time estimates for phases
- (-3 pts each) Undefined acronyms or terms
- (-5 pts each) Broken cross-references

### Score Thresholds
- **90-100**: Compliant
- **70-89**: Minor Issues (remediate within 30 days)
- **50-69**: Major Issues (remediate within 7 days)
- **<50**: Non-Compliant (immediate remediation required)

## Document Deprecation

Never physically delete - mark as deprecated:

```markdown
> **DEPRECATED:** [YYYY-MM-DD]
> **Reason:** [Why deprecated]
> **Superseded by:** [New document reference or N/A]
```

Retain for minimum 24 months (or per policy).
