# Workflow: Standardize Multiple Documents

<required_reading>
Before starting, read:
- references/naming-conventions.md - File naming rules
- references/quality-checklist.md - Standards to apply
</required_reading>

<process>
## Step 1: Identify Scope

Ask user: "What documents need standardization?"

Options:
1. **Specific folder** - "All docs in docs/features/"
2. **Document set** - "These 5 files: [list]"
3. **Entire project** - "All documentation"
4. **By pattern** - "All guide documents"

Get confirmation on scope.

## Step 2: Analyze Current State

For the identified scope:

1. **List all files** using Glob tool
2. **Categorize issues** found across documents:
   - Naming convention violations
   - Missing metadata
   - Formatting inconsistencies
   - Writing style issues
   - Structural problems

3. **Generate inventory:**

```markdown
## Documentation Inventory

**Total Documents:** [N]

### By Type
- Guides: [N]
- References: [N]
- Fixes: [N]
- PRDs: [N]
- Specs: [N]
- Summaries: [N]
- Roadmaps: [N]
- Features: [N]
- Unclassified: [N]

### Issues Found

**Critical (Must Fix):**
- [N] naming convention violations
- [N] missing required sections
- [N] wrong document type

**Warnings (Should Fix):**
- [N] missing metadata
- [N] formatting inconsistencies
- [N] style issues

**Suggestions (Nice to Have):**
- [N] missing examples
- [N] unclear content
- [N] organization improvements
```

## Step 3: Prioritize Standardization

Create priority groups:

**Priority 1 - Critical (Do First):**
- Naming violations (breaks tooling/consistency)
- Wrong document types (confuses users)
- Missing required sections (incomplete)
- Broken links (poor user experience)

**Priority 2 - Important (Do Next):**
- Missing metadata (hard to maintain)
- Formatting issues (looks unprofessional)
- Writing style problems (hurts clarity)
- Structural inconsistencies (hard to navigate)

**Priority 3 - Enhancement (Do If Time):**
- Missing examples (would help users)
- Additional context (would improve understanding)
- Better organization (would be cleaner)

## Step 4: Create Standardization Plan

For each priority group, list specific actions:

```markdown
## Standardization Plan

### Phase 1: Critical Fixes

**Naming Violations (N files):**
1. `API_Guide.md` → rename to `api-guide.md`
2. `setup.md` → rename to `setup-guide.md`
3. [...]

**Type Reclassification (N files):**
1. `feature-overview.md` → reclassify as summary
2. `api-docs.md` → reclassify as reference
3. [...]

**Structure Fixes (N files):**
1. `install.md` → add missing ToC and troubleshooting
2. `config.md` → add missing examples table
3. [...]

### Phase 2: Important Improvements

**Add Metadata (N files):**
- All guides missing "Last Updated"
- All specs missing version number

**Fix Formatting (N files):**
- Add language specifiers to code blocks
- Fix table alignment
- Convert absolute links to relative

**Improve Writing (N files):**
- Convert passive voice to active
- Add imperative mood to instructions
- Define acronyms on first use

### Phase 3: Enhancements

**Add Examples (N files):**
- API reference needs code examples
- Config guide needs example values

**Improve Organization (N files):**
- Split large multi-topic docs
- Merge redundant docs
- Create missing index pages
```

Present plan to user: "Here's the standardization plan. Should I proceed with all phases, or select specific phases?"

## Step 5: Execute Standardization

Work through plan systematically:

### For Each Document:

1. **Read current state**
2. **Apply fixes** based on priority
3. **Verify changes**
4. **Move to next document**

### Batch Operations

Some fixes can be done in batches:

**Batch Naming Changes:**
- Rename multiple files following convention
- Update all references to renamed files
- Update README indexes

**Batch Metadata Addition:**
- Add "Last Updated" to all missing
- Add version to all specs/PRDs
- Use consistent metadata format

**Batch Formatting:**
- Fix all code blocks in one pass
- Fix all tables in one pass
- Fix all links in one pass

### Track Progress

Update progress as you work:

```markdown
## Standardization Progress

**Phase 1:** [X/N complete] (Y%)
**Phase 2:** [X/N complete] (Y%)
**Phase 3:** [X/N complete] (Y%)

**Recently Completed:**
- [✓] Fixed api-guide.md naming
- [✓] Added metadata to 12 guides
- [✓] Fixed code blocks in features/
- [ ] In progress: Restructuring config docs
```

## Step 6: Update Supporting Files

After document changes:

**Update README files:**
- Folder README.md files
- Main docs/README.md
- Update links to renamed files
- Update descriptions if types changed

**Update Index Files:**
- Table of contents documents
- Navigation files
- Documentation site configs

**Update References:**
- Cross-references between docs
- Links from code comments
- Links from external docs

## Step 7: Verify Consistency

After standardization, verify:

**Naming Consistency:**
- [ ] All files follow kebab-case
- [ ] All have appropriate type suffix
- [ ] No files exceed 50 characters
- [ ] No files have spaces or special chars

**Structural Consistency:**
- [ ] All docs have appropriate headings
- [ ] All docs have metadata (where needed)
- [ ] All docs have ToC (where needed)
- [ ] All docs follow template structure

**Formatting Consistency:**
- [ ] All code blocks have language
- [ ] All tables are properly formatted
- [ ] All links use relative paths (internal)
- [ ] All lists use consistent markers

**Writing Consistency:**
- [ ] All use active voice
- [ ] All use imperative for instructions
- [ ] All define acronyms
- [ ] All avoid emojis
- [ ] All use consistent terminology

## Step 8: Generate Compliance Report

Create final report:

```markdown
# Documentation Standardization Report

**Date:** [YYYY-MM-DD]
**Scope:** [Description of what was standardized]
**Documents Processed:** [N]

---

## Summary

Successfully standardized [N] documents across [M] folders.

**Before Standardization:**
- Compliance Rate: [X]%
- Critical Issues: [N]
- Warnings: [N]

**After Standardization:**
- Compliance Rate: [X]%
- Critical Issues: [N]
- Warnings: [N]

**Improvement:** +[X]% compliance

---

## Changes Made

### Phase 1: Critical Fixes
- Renamed [N] files to follow naming convention
- Reclassified [N] documents to correct type
- Fixed [N] structural issues

### Phase 2: Important Improvements
- Added metadata to [N] documents
- Fixed formatting in [N] documents
- Improved writing in [N] documents

### Phase 3: Enhancements
- Added examples to [N] documents
- Improved organization of [N] documents

---

## File Changes

**Renamed:**
- `old-name.md` → `new-name.md`
- [...]

**Restructured:**
- `file1.md` - Major restructure to fit template
- [...]

**Updated:**
- `file1.md` - Added metadata, fixed formatting
- [...]

---

## Remaining Issues

[If any issues remain, list them with reasoning]

**Deferred:**
- [Issue] - Reason deferred
- [...]

**Cannot Fix:**
- [Issue] - Reason cannot fix
- [...]

---

## Recommendations

### Maintenance
1. Add pre-commit hook to enforce naming convention
2. Use documentation template when creating new docs
3. Regular audits (quarterly) to maintain standards

### Process
1. Review new docs before merging
2. Update this report after major changes
3. Keep compliance above [X]%

### Next Steps
1. [Specific next action]
2. [Specific next action]
```

## Step 9: Establish Maintenance Process

Help user maintain standards going forward:

**Suggest:**
1. **Pre-commit checks** - Scripts to validate naming, formatting
2. **Documentation PR template** - Checklist for new docs
3. **Regular audits** - Schedule for compliance checks
4. **Templates** - Provide templates for new docs
5. **Guidelines** - Link to documentation-guideline.md

**Offer to create:**
- Pre-commit hook script
- PR checklist template
- Quick reference guide
- New document templates
</process>

<success_criteria>
Standardization is successful when:
- All critical issues are resolved
- Compliance rate is significantly improved
- Naming is consistent across all documents
- Formatting is consistent across all documents
- Writing style is consistent across all documents
- Supporting files (README, indexes) are updated
- Links between documents work correctly
- User has tools to maintain standards
- Compliance report documents all changes
</success_criteria>

<examples>
## Example: Standardizing features/ Folder

**Initial State:**
```
features/
├── WhatsApp.md              (wrong case)
├── sms-feature.md           (inconsistent naming)
├── Email_Integration.md     (underscore)
├── calendar.md              (no suffix)
├── donationTracking.md      (camelCase)
```

**Issues Found:**
- 5 naming violations
- 2 missing metadata blocks
- 3 missing examples sections
- 1 using absolute links

**Standardization:**

Phase 1 - Naming:
```
features/
├── whatsapp-notifications.md
├── sms-notifications.md
├── email-integration.md
├── calendar-integration.md
├── donation-tracking.md
```

Phase 2 - Content:
- Added metadata to all
- Fixed 15 code blocks (added language)
- Converted 8 absolute links to relative
- Fixed 4 table formatting issues

Phase 3 - Enhancement:
- Added example section to 3 docs
- Added troubleshooting to 2 docs

**Result:**
- 100% naming compliance
- 100% formatting compliance
- 85% content completeness (up from 40%)
- Updated features/README.md with all files
</examples>
