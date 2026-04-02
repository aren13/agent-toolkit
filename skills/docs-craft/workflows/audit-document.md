# Workflow: Audit Existing Document

<required_reading>
Before starting, read these references:
- references/document-types.md - Document type standards
- references/naming-conventions.md - File naming rules
- references/writing-style.md - Style standards
- references/markdown-standards.md - Formatting rules
- references/quality-checklist.md - Complete audit criteria
</required_reading>

<process>
## Step 1: Read the Document

Ask user: "What document do you want to audit? (provide path)"

Read the document using Read tool.

## Step 2: Identify Document Type

Analyze the document to determine:
1. **Stated type** - Does filename have type suffix?
2. **Actual content** - What type of content is it really?
3. **Type match** - Do they align?

If mismatch detected, note for recommendations.

## Step 3: Audit Naming Convention

Check against references/naming-conventions.md:

**Filename Rules:**
- [ ] All lowercase (no capitals)
- [ ] Uses hyphens not underscores
- [ ] Has appropriate type suffix
- [ ] Max 50 characters
- [ ] No spaces
- [ ] Descriptive and concise

**Location Rules:**
- [ ] File is in correct folder for its type
- [ ] Folder structure makes sense

Document any violations with specific recommendations.

## Step 4: Audit Structure

Check against template for document type:

**Required Elements:**
- [ ] Title (H1) matching document purpose
- [ ] Metadata block (version/date/status) if required for type
- [ ] Table of Contents (if doc > 3 sections)
- [ ] All required sections for document type
- [ ] Logical section hierarchy

**Heading Standards:**
- [ ] Uses ATX-style headings (# not underlines)
- [ ] One H1 per document
- [ ] No skipped heading levels
- [ ] Blank lines before and after headings

Document missing sections or structural issues.

## Step 5: Audit Content Quality

**Writing Style:**
- [ ] Written in English (or appropriate language)
- [ ] Uses active voice
- [ ] Present tense for current state
- [ ] Imperative mood for instructions
- [ ] No emojis
- [ ] Minimal bold/italic (used appropriately)
- [ ] Defines acronyms on first use
- [ ] Specific version numbers and dates
- [ ] No vague language ("soon", "later", "might")
- [ ] No time estimates
- [ ] No first-person plural ("we recommend")
- [ ] Uses consistent terminology

**Content Completeness:**
- [ ] Purpose is clear
- [ ] Target audience is clear
- [ ] Instructions are actionable
- [ ] Examples are concrete and practical
- [ ] No missing information
- [ ] No broken logic flow

Document any style or content issues.

## Step 6: Audit Code and Technical Elements

**Code Blocks:**
- [ ] All code blocks have language specifiers
- [ ] Language identifiers are correct (ruby, bash, json, etc.)
- [ ] Code examples are complete and runnable
- [ ] Code includes necessary comments
- [ ] Indentation is correct

**Tables:**
- [ ] Header row with alignment
- [ ] Columns are aligned
- [ ] Uses `-` for empty cells
- [ ] Table formatting is consistent

**Links:**
- [ ] Relative paths for internal docs
- [ ] Descriptive link text (not "click here")
- [ ] External links include protocol (https://)
- [ ] All links are valid (no 404s)

**Lists:**
- [ ] Uses `-` for unordered lists
- [ ] Uses `1.` for ordered lists
- [ ] Nested lists use 2-space indentation
- [ ] List formatting is consistent

Document any technical formatting issues.

## Step 7: Audit Maintenance Info

**Metadata:**
- [ ] Has "Last Updated" date
- [ ] Has version number (if applicable)
- [ ] Has status (if applicable)
- [ ] Metadata is current and accurate

**Traceability:**
- [ ] References other docs where appropriate
- [ ] Is referenced in folder README.md
- [ ] Has changelog (if applicable)
- [ ] Has document history (for PRDs/Specs)

Document any maintenance issues.

## Step 8: Generate Audit Report

Create structured audit report:

```markdown
# Documentation Audit Report

**Document:** [path/to/document.md]
**Audit Date:** [YYYY-MM-DD]
**Current Document Type:** [type]
**Overall Grade:** [Excellent / Good / Needs Improvement / Poor]

---

## Summary

[1-2 sentence overview of document quality]

**Critical Issues:** [number]
**Warnings:** [number]
**Suggestions:** [number]

---

## Critical Issues

[Issues that must be fixed - naming violations, missing required sections, broken content]

### Issue 1: [Title]
**Problem:** [Description]
**Impact:** [Why this matters]
**Fix:** [Specific recommendation]

---

## Warnings

[Issues that should be fixed - style inconsistencies, unclear content, formatting problems]

### Warning 1: [Title]
**Problem:** [Description]
**Fix:** [Specific recommendation]

---

## Suggestions

[Nice-to-have improvements - additional examples, better organization, etc.]

### Suggestion 1: [Title]
**Current:** [Current state]
**Recommended:** [Suggested improvement]
**Benefit:** [Why this would help]

---

## Checklist Results

### Naming Convention
- [✓/✗] Lowercase
- [✓/✗] Hyphens (kebab-case)
- [✓/✗] Type suffix
- [✓/✗] Max 50 characters
- [✓/✗] No spaces
- [✓/✗] Correct location

### Structure
- [✓/✗] Title (H1)
- [✓/✗] Metadata block
- [✓/✗] Table of contents (if needed)
- [✓/✗] Required sections
- [✓/✗] ATX-style headings
- [✓/✗] One H1
- [✓/✗] No skipped levels
- [✓/✗] Blank lines around headings

### Content
- [✓/✗] English language
- [✓/✗] Active voice
- [✓/✗] Present tense
- [✓/✗] Imperative for instructions
- [✓/✗] No emojis
- [✓/✗] Defines acronyms
- [✓/✗] Specific dates/versions
- [✓/✗] No vague language
- [✓/✗] Consistent terminology
- [✓/✗] Actionable content
- [✓/✗] Practical examples

### Technical
- [✓/✗] Code blocks have language
- [✓/✗] Code is runnable
- [✓/✗] Tables formatted correctly
- [✓/✗] Links are relative (internal)
- [✓/✗] Links are descriptive
- [✓/✗] Lists formatted correctly

### Maintenance
- [✓/✗] Last Updated date
- [✓/✗] Version number (if applicable)
- [✓/✗] Status (if applicable)
- [✓/✗] In folder README
- [✓/✗] Has related doc links

---

## Recommendations

### Immediate Actions
1. [High-priority fixes]
2. [...]

### Future Improvements
1. [Nice-to-have enhancements]
2. [...]

---

## Compliance Score

**Naming:** [X/6 checks passed]
**Structure:** [X/8 checks passed]
**Content:** [X/12 checks passed]
**Technical:** [X/6 checks passed]
**Maintenance:** [X/5 checks passed]

**Overall:** [X/37 checks passed] ([percentage]%)
```

## Step 9: Present Findings

1. Show audit report to user
2. Highlight critical issues first
3. Offer to fix issues automatically if requested
4. Provide prioritized action plan

If user requests fixes:
- Route to workflows/update-document.md with audit findings
</process>

<success_criteria>
Audit is successful when:
- All aspects of document have been checked
- Issues are categorized by severity (critical/warning/suggestion)
- Each issue includes specific fix recommendation
- Checklist shows exact compliance status
- Compliance score provides objective measurement
- User understands what needs to be fixed and why
- Action plan is clear and prioritized
</success_criteria>

<examples>
## Example Audit Findings

**Example 1: Naming Violation**
```
Critical Issue: Incorrect filename
Problem: File named "API_Guide.md" violates naming convention
Impact: Inconsistent with project standards, harder to find
Fix: Rename to "api-guide.md"
```

**Example 2: Missing Structure**
```
Critical Issue: No Table of Contents
Problem: Document has 8 sections but no ToC
Impact: Difficult to navigate
Fix: Add ToC after metadata block:
## Table of Contents
- [Section 1](#section-1)
- [Section 2](#section-2)
...
```

**Example 3: Code Block Issue**
```
Warning: Code block missing language specifier
Problem: Line 45 has code block without language
Impact: No syntax highlighting, unclear what language
Fix: Change from ``` to ```ruby
```

**Example 4: Style Issue**
```
Warning: First-person plural usage
Problem: "We recommend you run..." (lines 23, 45, 67)
Impact: Less direct and actionable
Fix: Change to "Run the command" (imperative mood)
```

**Example 5: Content Gap**
```
Suggestion: Add troubleshooting section
Current: Guide has steps but no error handling
Recommended: Add "Troubleshooting" section with common issues
Benefit: Users can self-resolve problems
```
</examples>
