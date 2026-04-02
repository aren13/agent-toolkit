# Workflow: Update Document

<required_reading>
Before starting, read:
- references/writing-style.md - Style standards
- references/quality-checklist.md - Quality requirements
- Relevant template if major restructure needed
</required_reading>

<process>
## Step 1: Read Current Document

Ask user: "What document needs updating? (provide path)"

Read the document using Read tool.

## Step 2: Understand Update Needs

Ask user: "What changes are needed?"

Common update types:
1. **Content update** - Add/change/remove information
2. **Fix errors** - Correct mistakes, broken links, outdated info
3. **Improve quality** - Better writing, structure, examples
4. **Apply standards** - Make compliant with guidelines
5. **Refresh metadata** - Update dates, versions, status
6. **Restructure** - Major reorganization

If user provides audit report, use that to guide updates.

## Step 3: Plan Changes

Based on update type, plan specific changes:

**For Content Updates:**
- Identify sections to modify
- Gather new information needed
- Determine if structure changes needed
- Check if related docs need updates

**For Error Fixes:**
- List specific errors (line numbers if known)
- Verify corrections
- Test links, code examples
- Check for similar errors elsewhere

**For Quality Improvements:**
- Identify writing issues (passive voice, vague language)
- Find structural issues (missing sections, poor flow)
- Locate formatting issues (code blocks, tables)
- Note missing examples or clarity problems

**For Standards Compliance:**
- Use audit findings
- Prioritize critical issues
- Plan systematic fixes
- Consider file renaming/relocation if needed

**For Metadata Refresh:**
- Update "Last Updated" date
- Increment version if significant changes
- Update status if applicable
- Update changelog if present

**For Restructure:**
- May need to reclassify document type
- Consider splitting into multiple docs
- Consider merging with related docs
- Load appropriate template

## Step 4: Execute Updates

Make changes systematically:

### Content Changes

Use Edit tool for precise changes:
- Quote exact text to replace
- Provide improved version
- Make one logical change at a time
- Verify context matches

### Metadata Updates

Always update when making changes:

```markdown
> **Last Updated:** 2024-01-15  ← Update this
> **Version:** 1.1  ← Increment if significant
```

Add to changelog if document has one:

```markdown
## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.1 | 2024-01-15 | Added troubleshooting section, updated API examples |
| 1.0 | 2024-01-01 | Initial release |
```

### Writing Improvements

Common patterns:

**Passive → Active:**
```diff
- The configuration should be updated by the administrator
+ The administrator should update the configuration
```

**Vague → Specific:**
```diff
- This might take a while
+ This takes approximately 2-5 minutes
```

**First-person plural → Imperative:**
```diff
- We recommend that you run the tests
+ Run the tests
```

**Past → Present (for current state):**
```diff
- The system was designed to handle requests
+ The system handles requests
```

### Formatting Fixes

**Add language specifiers:**
```diff
- ```
+ ```ruby
def example
  "correct"
end
```

**Fix table alignment:**
```diff
- |Column1|Column2|
  |---|---|
+ | Column 1 | Column 2 |
+ |----------|----------|
```

**Use relative links:**
```diff
- [Setup](https://github.com/org/repo/blob/main/docs/setup.md)
+ [Setup](./setup-guide.md)
```

### Structural Changes

If major restructure needed:
1. Create new version with correct structure
2. Migrate content section by section
3. Improve as you migrate
4. Verify all content transferred
5. Check all links still work

## Step 5: Verify Changes

After updates:

**Content Verification:**
- [ ] All requested changes made
- [ ] New information is accurate
- [ ] Examples work correctly
- [ ] No information lost

**Quality Verification:**
- [ ] Writing style improved
- [ ] Structure is logical
- [ ] Formatting is correct
- [ ] Links work
- [ ] Code runs

**Metadata Verification:**
- [ ] "Last Updated" date updated
- [ ] Version incremented if needed
- [ ] Changelog updated if present
- [ ] Status updated if changed

**Standards Verification:**
Run through quality checklist:
- [ ] Follows naming convention
- [ ] Uses correct template structure
- [ ] Written in English
- [ ] No emojis
- [ ] Code blocks have language
- [ ] Links are relative
- [ ] Tables formatted correctly

## Step 6: Document Changes

Provide change summary to user:

```markdown
## Update Summary

**Document:** [path]
**Date:** [YYYY-MM-DD]
**Type:** [Content/Fix/Quality/Standards/Metadata/Restructure]

### Changes Made

1. **[Change category 1]**
   - [Specific change]
   - [Specific change]

2. **[Change category 2]**
   - [Specific change]

### Improvements

- [What's better now]
- [What's better now]

### Before/After

[Show key improvements, especially for writing/structure changes]

### Related Updates Needed

[If other docs need updates based on these changes]
```

## Step 7: Handle Related Updates

If changes affect other documents:

**Check for:**
- Documents that link to this one
- Documents about related topics
- README files that list this doc
- Index or table of contents files

**Update as needed:**
- Link text if title changed
- Cross-references if content changed
- Location links if file moved
- Related document content if dependencies exist

## Step 8: Offer Further Improvements

After requested updates, offer:

"Updates complete. Would you like me to:
1. Audit the document for additional improvements?
2. Update related documents?
3. Check if any other docs need similar updates?
4. Nothing else - updates are sufficient"

Route to appropriate workflow if requested.
</process>

<success_criteria>
Update is successful when:
- All requested changes are made correctly
- No information is lost in the process
- Document quality is improved (not degraded)
- Metadata is current
- Writing and formatting meet standards
- Code examples and links work
- Related documents are updated if needed
- User confirms updates meet their needs
</success_criteria>

<examples>
## Example 1: Content Update

**Request:** "Add section about error handling to the API guide"

**Process:**
1. Read current document
2. Determine placement (after main usage section)
3. Gather error code information
4. Write new section following guide template style
5. Add to table of contents
6. Update "Last Updated" date
7. Verify formatting and links

**Result:**
- New "Error Handling" section added
- Includes error code table
- Shows example error responses
- ToC updated
- Metadata refreshed

## Example 2: Fix Errors

**Request:** "Fix broken links and update outdated API endpoint"

**Process:**
1. Identify all broken links
2. Find correct link targets
3. Update links to use relative paths
4. Find API endpoint references
5. Update endpoint URL (old → new)
6. Update example requests
7. Note in changelog

**Result:**
- 5 links fixed
- API endpoint updated throughout
- Examples updated and tested
- Changelog entry added

## Example 3: Quality Improvement

**Request:** "Make the writing clearer and more direct"

**Process:**
1. Scan for passive voice → convert to active
2. Find vague language → make specific
3. Locate "we recommend" → convert to imperative
4. Check for undefined acronyms → add definitions
5. Look for wall-of-text paragraphs → add structure
6. Update metadata

**Result:**
- 23 passive voice instances fixed
- 8 vague phrases clarified
- 12 instructions converted to imperative
- 4 acronyms defined
- 3 sections restructured for clarity
- Overall readability significantly improved

## Example 4: Standards Compliance

**Request:** "Apply standards from audit report"

**Audit Issues:**
- Missing language specifiers in code blocks (Critical)
- Using absolute links for internal docs (Warning)
- No "Last Updated" date (Warning)

**Process:**
1. Add language to all code blocks (6 instances)
2. Convert absolute links to relative (12 links)
3. Add metadata block with date
4. Run quality checklist
5. Generate compliance report

**Result:**
- All critical issues resolved
- All warnings resolved
- Document now 100% compliant
- Standards checklist passed
</examples>
