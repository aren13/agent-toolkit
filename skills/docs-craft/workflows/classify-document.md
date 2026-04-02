# Workflow: Classify Document

<required_reading>
Before starting, read:
- references/document-types.md - Detailed classification criteria
</required_reading>

<process>
## Step 1: Understand the Content

Ask user: "What is the content about? (provide description, draft, or file path)"

If file path provided, read the file.
If description provided, gather more details.

## Step 2: Determine Primary Purpose

Ask these diagnostic questions to classify:

### Purpose Analysis

**Question 1: What should readers DO with this information?**

A. Learn how to perform a task step-by-step → Likely **Guide**
B. Look up specific information when needed → Likely **Reference**
C. Understand what was fixed and how → Likely **Fix**
D. Understand requirements for implementation → Likely **PRD**
E. Understand technical protocol/contract → Likely **Spec**
F. Get high-level overview of something → Likely **Summary**
G. Track planned work and progress → Likely **Roadmap**
H. Understand what a feature does → Likely **Feature**

**Question 2: Is this teaching or telling?**

- **Teaching** (procedural, instructional) → Guide
- **Telling** (declarative, informational) → Reference, Summary, Feature
- **Specifying** (requirements, contracts) → PRD, Spec
- **Recording** (fixes, decisions, plans) → Fix, Summary, Roadmap

**Question 3: When would someone read this?**

- When they need to do something → Guide
- When they need to look something up → Reference
- When they need to understand a fix → Fix
- When planning/building a feature → PRD
- When integrating with a system → Spec
- When catching up on what happened → Summary
- When checking project status → Roadmap
- When learning about a feature → Feature

## Step 3: Apply Classification Criteria

Use detailed criteria from references/document-types.md:

### Guide Characteristics
- Procedural content with numbered steps
- Prerequisites section
- Goal-oriented ("how to accomplish X")
- Troubleshooting section common
- Examples show process
- **Keywords:** tutorial, how-to, setup, installation, configuration

### Reference Characteristics
- Organized by categories/topics
- Tables of properties/options
- Complete coverage of a domain
- Minimal narrative, maximal facts
- Quick lookup format
- **Keywords:** API, config, options, parameters, reference, lookup

### Fix Characteristics
- Documents a specific problem and solution
- Has severity/impact assessment
- Includes root cause analysis
- Shows code changes (before/after)
- Testing and deployment steps
- **Keywords:** bug, vulnerability, CVE, patch, hotfix, security

### PRD Characteristics
- Defines product requirements
- Has user stories
- Includes acceptance criteria
- Specifies scope (in/out)
- Multiple stakeholders
- **Keywords:** requirements, feature spec, user story, acceptance criteria

### Spec Characteristics
- Defines technical contract/protocol
- Has request/response formats
- Lists endpoints/methods
- Includes authentication details
- Error codes defined
- **Keywords:** API spec, webhook, protocol, contract, integration

### Summary Characteristics
- High-level overview
- Key points highlighted
- Results/outcomes included
- Concise (typically shorter docs)
- Next steps often included
- **Keywords:** overview, summary, recap, executive summary, ticket summary

### Roadmap Characteristics
- Plans future work
- Tracks progress
- Has phases/milestones
- Status for each item
- Time-oriented
- **Keywords:** roadmap, planning, milestones, backlog, phases

### Feature Characteristics
- Describes system capability
- Explains components
- Configuration details
- Usage examples
- Troubleshooting
- **Keywords:** feature, capability, module, component, system

## Step 4: Handle Edge Cases

**Multiple Types Possible:**

If content could fit multiple types, prioritize based on:
1. **Primary user need** - What will readers most commonly need?
2. **Content focus** - What takes up most of the content?
3. **Maintenance pattern** - Which type's update pattern fits best?

Common ambiguities:

**Guide vs Reference:**
- If step-by-step process → Guide
- If lookup table → Reference
- If both → Split into Guide + Reference

**PRD vs Spec:**
- If business requirements → PRD
- If technical contract → Spec
- If both → PRD with technical appendix

**Summary vs Feature:**
- If describing what happened → Summary
- If describing capability → Feature
- If both → Depends on audience (stakeholders → Summary, users → Feature)

**Fix vs PRD:**
- If documenting past fix → Fix
- If planning future fix → PRD (or just ticket)
- Context matters

**Guide vs Feature:**
- If teaching how to use → Guide
- If explaining what it does → Feature
- Often want both (separate docs)

## Step 5: Validate Classification

Check the classification against document type template:

1. Load templates/{type}-template.md
2. Review required sections
3. Ask: "Does my content fit these sections?"
4. Ask: "Are the required sections appropriate?"
5. Ask: "Will readers find what they need?"

If sections don't fit well, reconsider classification.

## Step 6: Provide Classification Result

Present to user:

```
## Document Classification

**Recommended Type:** [Type]

**Reasoning:**
- Primary purpose: [What readers will do]
- Content focus: [Main content type]
- Best fits: [Type] characteristics

**Required Sections:**
1. [Section from template]
2. [Section from template]
3. [...]

**File Location:** [recommended folder]/
**Naming Pattern:** [topic]-[type].md
**Example:** [specific-example-name.md]

**Alternative Considerations:**
- [If another type was close, explain why not chosen]
```

## Step 7: Offer Next Steps

Ask user: "Would you like me to:
1. Create this document using the [Type] template?
2. Restructure existing content into this format?
3. Show me the full template for this type?
4. Reconsider the classification?"

Route to appropriate workflow based on response.
</process>

<success_criteria>
Classification is successful when:
- Document type is clearly identified
- Reasoning is well-explained
- Classification fits content purpose
- Required sections are appropriate for content
- User understands why this type was chosen
- Clear next steps are provided
</success_criteria>

<examples>
## Example 1: Ambiguous Content

**User:** "I have content about our caching system"

**Analysis:**
Q: What should readers do?
A: Depends on what the content contains

**Follow-up:** "What aspects of the caching system are covered? (how to use it / config options / how we built it / what it can do)"

**User:** "How to use it and config options"

**Classification:** Split recommendation
- **Guide:** "How to Use Caching" (step-by-step usage)
- **Reference:** "Caching Configuration" (config options table)

## Example 2: Clear Guide

**User:** "Instructions for deploying to production"

**Analysis:**
- Primary purpose: Learn how to deploy
- Content type: Procedural steps
- Reader intent: Complete deployment task

**Classification:** Guide
- Has: Steps, prerequisites, verification
- Location: `how-to/`
- Name: `production-deployment-guide.md`

## Example 3: Fix vs Post-Mortem

**User:** "Document about the database outage last week"

**Follow-up:** "Is this about fixing a specific bug, or summarizing what happened?"

**User:** "Summarizing what happened, lessons learned"

**Classification:** Summary (not Fix)
- Fix = specific technical fix with code changes
- Summary = high-level overview of incident
- Location: `archive/` or `development/`
- Name: `database-outage-summary.md`

## Example 4: PRD vs Spec

**User:** "New API we're building for retailers"

**Follow-up:** "Is this defining what the API should do (requirements) or how it works technically (protocol)?"

**User:** "Both - requirements and technical details"

**Classification:** Both documents
- **PRD:** `retailer-api-prd.md` - Why, who, what features, acceptance criteria
- **Spec:** `retailer-api-spec.md` - Endpoints, request/response formats, auth

Or: PRD with technical appendix if tightly coupled
</examples>
