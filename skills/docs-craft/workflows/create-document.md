# Workflow: Create New Document

<required_reading>
Before starting, read these references:
- references/document-types.md - Understand document type characteristics
- references/naming-conventions.md - File naming rules
- templates/{type}-template.md - Template for chosen document type
</required_reading>

<process>
## Step 1: Determine Document Type

Ask user: "What type of document do you want to create?"

Present options with brief descriptions:
1. **Guide** - Step-by-step instructions or tutorial
2. **Reference** - API docs, config options, lookup tables
3. **Fix** - Bug fix or security patch documentation
4. **PRD** - Product requirements document
5. **Spec** - Technical specification or protocol
6. **Summary** - Overview or executive summary
7. **Roadmap** - Planning document with milestones
8. **Feature** - Feature documentation

If user is unsure, ask: "What is the main purpose? (teach how-to / provide lookup info / document a fix / specify requirements / describe protocol / summarize / plan work / describe feature)"

Map response to document type using references/document-types.md.

## Step 2: Gather Content Requirements

Based on document type, ask targeted questions:

**For Guide:**
- What is the user trying to accomplish?
- What are the prerequisites?
- What are the main steps?
- What common issues might they encounter?

**For Reference:**
- What information needs to be looked up?
- What are the main categories/sections?
- Are there configuration options or API endpoints?
- What examples would be helpful?

**For Fix:**
- What was the issue (bug/vulnerability)?
- What was the impact?
- What was the root cause?
- What changes were made?
- Ticket number (if applicable)?

**For PRD:**
- What problem does this solve?
- Who are the users?
- What are the key requirements?
- What's in/out of scope?
- Are there user stories?

**For Spec:**
- What protocol/contract is being specified?
- What are the endpoints/methods?
- What are request/response formats?
- What authentication is required?
- What error codes are possible?

**For Summary:**
- What is being summarized?
- What are the key points?
- What are the results/outcomes?
- What are next steps?

**For Roadmap:**
- What work is being planned?
- What are the phases/milestones?
- What is the current status?
- How should progress be tracked?

**For Feature:**
- What does the feature do?
- What are the main components?
- How is it configured?
- How is it used?
- What are common issues?

## Step 3: Determine File Location and Name

**Location Rules:**
- Getting started guides → `getting-started/`
- How-to guides → `how-to/`
- Features → `features/`
- Integrations → `integrations/`
- Security fixes → `security/` or `security/cve/`
- Development planning → `development/`
- Archives → `archive/`

**Naming Rules:**
1. All lowercase
2. Use hyphens (kebab-case)
3. Include type suffix (except features)
4. Max 50 characters
5. Descriptive but concise

Examples:
- `installation-guide.md`
- `api-reference.md`
- `csp-fix.md`
- `retailer-api-prd.md`
- `webhook-spec.md`
- `project-summary.md`
- `refactoring-roadmap.md`
- `whatsapp-notifications.md` (feature, no suffix)

Ask user: "Where should this document go?" (suggest based on type)
Construct filename following naming rules.

## Step 4: Load Appropriate Template

Read the template from `templates/`:
- guide-template.md
- reference-template.md
- fix-template.md
- prd-template.md
- spec-template.md
- summary-template.md
- roadmap-template.md
- feature-template.md

## Step 5: Fill Template with Content

Using the gathered information and the template structure:

1. **Replace placeholder content** with actual information
2. **Keep all required sections** from template
3. **Remove optional sections** that aren't needed
4. **Add metadata** (date, version, status as appropriate)
5. **Include code examples** with proper language specifiers
6. **Format tables** properly with alignment
7. **Use relative links** for internal references
8. **Write in active voice**, present tense
9. **Define terms** on first use
10. **Add practical examples** throughout

## Step 6: Quality Check

Review against checklist:
- [ ] Follows naming convention
- [ ] Uses correct template structure
- [ ] Written in English (or specified language)
- [ ] No emojis
- [ ] All code blocks have language specified
- [ ] Links use relative paths for internal docs
- [ ] Tables are properly formatted
- [ ] Metadata included (where appropriate)
- [ ] Content is clear and actionable
- [ ] Examples are concrete and practical

## Step 7: Write File and Update Index

1. Write the document to the determined path
2. Update the folder's README.md to include the new document
3. If this is a major document, consider adding to main docs/README.md

Present final path to user and confirm document is created.
</process>

<success_criteria>
Document creation is successful when:
- File is written to correct location with correct name
- Content follows appropriate template structure
- All required sections are complete
- Code examples work and are properly formatted
- Document passes quality checklist
- README.md is updated with new document link
- User confirms the document meets their needs
</success_criteria>

<examples>
## Example Interactions

**Example 1: Creating a Guide**

User: "I need to document how to set up the development environment"

Assistant actions:
1. Identify document type: Guide
2. Ask about: prerequisites, setup steps, common issues
3. Determine location: `getting-started/`
4. Construct name: `development-setup-guide.md`
5. Load: templates/guide-template.md
6. Fill template with gathered info
7. Write file with all required sections
8. Update getting-started/README.md

**Example 2: Creating a Fix Document**

User: "We just fixed a critical SQL injection vulnerability"

Assistant actions:
1. Identify document type: Fix
2. Ask about: vulnerability details, impact, root cause, solution, ticket number
3. Determine location: `security/`
4. Construct name: `sql-injection-fix.md`
5. Load: templates/fix-template.md
6. Fill with security details, code changes, testing steps
7. Write file with severity metadata
8. Update security/README.md

**Example 3: Creating a PRD**

User: "I want to spec out a new retailer API integration"

Assistant actions:
1. Identify document type: PRD
2. Ask about: problem, users, requirements, scope, user stories
3. Determine location: `integrations/`
4. Construct name: `retailer-api-prd.md`
5. Load: templates/prd-template.md
6. Fill with requirements, API specs, acceptance criteria
7. Write file with version and status metadata
8. Update integrations/README.md
</examples>
