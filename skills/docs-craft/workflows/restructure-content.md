# Workflow: Restructure Content

<required_reading>
Before starting, read:
- references/document-types.md - To classify content
- references/writing-style.md - To improve writing
- Appropriate template from templates/ after classification
</required_reading>

<process>
## Step 1: Analyze Unstructured Content

Ask user: "What content needs to be restructured? (provide text, file path, or description)"

Read or receive the content.

Analyze the content to identify:
1. **Main topic** - What is this about?
2. **Purpose** - What should readers do with this information?
3. **Content type** - Raw notes, meeting summary, email thread, ticket, code comments, etc.
4. **Key information** - Facts, steps, requirements, decisions, etc.
5. **Missing information** - What's needed to make this complete?

## Step 2: Classify Document Type

Based on analysis, determine appropriate document type:

**Ask these questions:**
- Is it teaching how to do something? → **Guide**
- Is it providing lookup information? → **Reference**
- Is it documenting a bug/security fix? → **Fix**
- Is it specifying product requirements? → **PRD**
- Is it defining a technical protocol? → **Spec**
- Is it summarizing an event/decision/ticket? → **Summary**
- Is it planning future work? → **Roadmap**
- Is it describing a system feature? → **Feature**

Use references/document-types.md for detailed classification criteria.

If content could fit multiple types, ask user: "This content could be a [Type A] or [Type B]. Which best fits your needs?"

## Step 3: Extract Information

Create structured outline of extracted information:

**For Guide:**
- Purpose/goal
- Prerequisites
- Main steps (in order)
- Expected outcomes
- Common issues
- Related resources

**For Reference:**
- Categories/sections
- Properties/options with descriptions
- Default values
- Examples
- Related references

**For Fix:**
- Issue description
- Severity/impact
- Root cause
- Solution/changes made
- Testing steps
- Deployment steps
- References (tickets, CVEs)

**For PRD:**
- Background/problem
- Target audience
- Requirements (functional/non-functional)
- Scope (in/out)
- User stories
- Acceptance criteria
- Technical approach

**For Spec:**
- Protocol/system overview
- Authentication method
- Endpoints/methods
- Request/response formats
- Error codes
- Examples

**For Summary:**
- Context/background
- Key points
- Results/outcomes
- Metrics (if applicable)
- Next steps

**For Roadmap:**
- Purpose
- Phases/milestones
- Items with status
- Progress tracking
- Execution guidelines

**For Feature:**
- What it does
- Components
- Configuration
- Usage examples
- Troubleshooting

## Step 4: Identify Gaps

Compare extracted information against template requirements.

List missing information:
- Required sections without content
- Unclear or ambiguous points
- Missing examples
- Missing technical details
- Missing dates/versions/metadata

Ask user targeted questions to fill gaps:
"I need the following information to complete this document:
1. [Missing item 1]
2. [Missing item 2]
..."

## Step 5: Improve Content Quality

Transform extracted content to meet quality standards:

**Writing Improvements:**
- Convert passive voice to active voice
  - Before: "The configuration should be updated"
  - After: "Update the configuration"

- Convert past tense to present tense (for current state)
  - Before: "The system was designed to handle..."
  - After: "The system handles..."

- Use imperative mood for instructions
  - Before: "You should run the command"
  - After: "Run the command"

- Remove vague language
  - Before: "This might take a while"
  - After: "This takes approximately 2-5 minutes"

- Define acronyms
  - Before: "Configure the CSP"
  - After: "Configure the Content Security Policy (CSP)"

- Add specific dates/versions
  - Before: "In the recent update"
  - After: "In version 2.1.0 (2024-01-15)"

- Remove emojis
  - Before: "✨ New feature"
  - After: "New feature"

**Structure Improvements:**
- Break long paragraphs into logical sections
- Convert prose into numbered steps where appropriate
- Create tables for structured comparisons
- Add code blocks with language specifiers
- Create bulleted lists for related items
- Add clear section headings

**Content Additions:**
- Add concrete examples for abstract concepts
- Add code snippets for technical instructions
- Add verification steps for procedures
- Add links to related documentation

## Step 6: Apply Template Structure

Load the appropriate template from templates/.

Map extracted and improved content to template sections:
1. Fill required sections
2. Add optional sections that have content
3. Remove optional sections without content
4. Ensure section order matches template
5. Add metadata (date, version, status)

## Step 7: Format Correctly

Apply all formatting standards:

**Code Blocks:**
```ruby
# Always specify language
def example
  "correct"
end
```

**Tables:**
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Value 1  | Value 2  | -        |

**Lists:**
- Use `-` for unordered
- 2-space indentation for nested
1. Use `1.` for ordered
2. Auto-numbering works

**Links:**
[Descriptive text](./relative/path.md) for internal
[External link](https://example.com) for external

**Headings:**
# H1 Title
## H2 Section
### H3 Subsection

(Blank lines before and after)

## Step 8: Determine Location and Name

Follow workflows/create-document.md Step 3 to determine:
1. Appropriate folder location
2. Correct filename with type suffix

## Step 9: Quality Check

Review against references/quality-checklist.md:
- [ ] Follows naming convention
- [ ] Uses correct template structure
- [ ] Written in English
- [ ] No emojis
- [ ] Active voice, present tense, imperative mood
- [ ] Defines acronyms
- [ ] Has specific dates/versions
- [ ] Code blocks have language specified
- [ ] Tables properly formatted
- [ ] Links are relative for internal docs
- [ ] Metadata included
- [ ] Content is actionable
- [ ] Examples are concrete

## Step 10: Present Restructured Document

Show before/after comparison:
1. Original unstructured content (summary)
2. New document structure
3. Key improvements made
4. Proposed location and filename

Ask user: "Does this meet your needs? Should I write this document?"

If approved, write the file and update folder README.
</process>

<success_criteria>
Restructuring is successful when:
- Unstructured content is classified into correct document type
- All key information is extracted and organized
- Missing information is identified and filled
- Content quality is significantly improved
- Document follows appropriate template structure
- All formatting standards are applied
- Document is actionable and clear
- User confirms the restructured version is better
</success_criteria>

<examples>
## Example 1: Restructuring Meeting Notes

**Input (unstructured):**
```
Meeting with team about the new API. We decided to use OAuth2. Need to support
JSON and XML. Rate limiting is 100 req/min. John will handle authentication.
Launch in 3 weeks. Also discussed versioning - going with v1 in path.
```

**Analysis:**
- Type: Technical Specification (Spec)
- Missing: Endpoints, request/response formats, error codes, base URL
- Purpose: Define API contract

**Questions asked:**
1. What are the specific endpoints?
2. What is the base URL?
3. What are the request/response formats?
4. What error codes will be returned?
5. What authentication method specifically (OAuth2 flow type)?

**Output (restructured):**
```markdown
# Public API Specification

> **Version:** 1.0
> **Last Updated:** 2024-01-15

---

## Overview

The Public API provides programmatic access to platform resources using
RESTful principles.

## Authentication

Uses OAuth 2.0 Client Credentials flow.

**Token Endpoint:** `POST /oauth/token`

[... full spec with all sections ...]
```

## Example 2: Restructuring Ticket Description

**Input (unstructured):**
```
SQL injection in the search endpoint. Found by security audit. Can inject
through the query parameter. Fixed by using parameterized queries in
search_controller.rb. Tested manually. Deployed to staging. Ticket SMS-1234.
```

**Analysis:**
- Type: Fix documentation
- Has: Issue, solution, ticket number
- Missing: Severity, impact assessment, specific code changes, deployment steps

**Questions asked:**
1. What is the severity level?
2. What systems/users were affected?
3. Can you provide the specific code changes (before/after)?
4. What were the exact testing steps?
5. What are the deployment steps for production?

**Output (restructured):**
```markdown
# SQL Injection Fix

> **Date:** 2024-01-15
> **Ticket:** SMS-1234
> **Severity:** Critical
> **Status:** Deployed to Staging

---

## Summary

Fixed SQL injection vulnerability in search endpoint that allowed attackers
to execute arbitrary SQL queries through the query parameter.

## Issue Details

### Problem

The search endpoint was vulnerable to SQL injection attacks due to direct
string interpolation of user input into SQL queries.

[... full fix documentation with all sections ...]
```

## Example 3: Restructuring Code Comments into Guide

**Input (unstructured code comments):**
```ruby
# To set up development:
# 1. Install Ruby 3.2
# 2. Run bundle install
# 3. Copy .env.example to .env
# 4. Create database with rake db:create
# 5. Run migrations
# 6. Seed data with rake db:seed
# If you get postgres errors check that it's running
# For asset issues try rails assets:precompile
```

**Analysis:**
- Type: Guide (setup instructions)
- Has: Basic steps
- Missing: Prerequisites detail, verification steps, comprehensive troubleshooting

**Output (restructured):**
```markdown
# Development Setup Guide

> **Last Updated:** 2024-01-15

Complete guide to setting up the development environment.

---

## Prerequisites

- Ruby 3.2.0 or higher
- PostgreSQL 12 or higher
- Node.js 16 or higher
- Redis 6 or higher

Verify prerequisites:

```bash
ruby --version   # Should show 3.2.0+
psql --version   # Should show 12+
node --version   # Should show 16+
redis-cli --version  # Should show 6+
```

## Steps

### Step 1: Install Dependencies

[... full guide with all sections ...]
```
</examples>
