# Audit Results: automation-tool-router

> Captured from `ae-cc:skill-auditor` subagent (it cannot persist files; findings transcribed here).

**Note on configuration:** The auditor's reference files at `~/.claude/skills/create-agent-skills/references/` were missing during the run. Findings below are based on the auditor's applied training knowledge of Claude Code skill best practices.

---

## Assessment

Solid, well-maintained router skill with genuinely useful decision logic and real token-cost data. Biggest weakness is structural — body uses legacy markdown headings instead of pure XML — and several sections have minor clarity gaps that could cause a fresh agent to hesitate on edge cases. The AppleScript-first patch for native apps is present and well-placed.

---

## Critical issues

### 1. Markdown headings in body (legacy structure) — SKILL.md:6–147
- Current: Body uses `##` headings (`## Decision matrix`, `## Escalation order`, `## Anti-patterns`, etc.)
- Should be: Pure XML tags (`<decision_matrix>`, `<escalation_order>`, `<anti_patterns>`, etc.)
- Why it matters: This is the documented anti-pattern for skills in the user's `ae-cc:create-agent-skills` house style. Markdown headings produce inconsistent parsing when the skill is injected into context.
- Fix: Convert every `##` section to a matching XML tag. The bold callout on line 8 also needs wrapping (e.g., inside `<objective>`).

### 2. Missing required tags — SKILL.md (entire file)
- Current: No `<objective>`, `<quick_start>`, or `<success_criteria>` tags exist anywhere.
- Should be: All three are required for every skill in this house style.
- Why it matters: A router skill especially needs a crisp `<objective>` so an agent knows *its job is to route, not execute*, and `<success_criteria>` so it knows when routing is done (tool chosen + invocation begun).
- Fix: Add `<objective>` (1–3 sentences on what this skill does), promote the existing bold tagline + quick-command line into `<quick_start>`, add `<success_criteria>` (e.g., "Correct tool identified and first command issued; no blocked fallback attempted before trying the escalation path").

### 3. Sandboxed / non-scriptable app gap in AppleScript section — SKILL.md:60–83
- Current: Escalation says "AppleScript first → Peekaboo if the app isn't scriptable." No guidance on what to do when AppleScript *is* scriptable but fails due to App Sandbox / TCC permissions (e.g., `osascript` denied access to Contacts/Calendar on a hardened system).
- Why it matters: Real, common failure mode. Without it, an agent retries AppleScript in a loop or abandons the task instead of escalating to Peekaboo.
- Fix: Add: "If `osascript` returns a permissions error (TCC/sandbox), fall back to Peekaboo or prompt the user to grant Full Disk Access / Automation permission in System Settings."

---

## Recommendations

### 1. Description trigger language — SKILL.md:3
- Current: Trigger keywords listed as flat comma-separated string appended after the functional description.
- Recommendation: Move trigger language *earlier* in the description, before the keyword dump. Make the "route first, act never" imperative more prominent. Example opener: "Routes automation requests to the correct tool before any execution begins. Invoked whenever a task involves browser, web, GUI, or macOS app automation."
- Benefit: The description's first sentence is what Claude weights most when deciding whether to activate a skill. Burying the routing imperative weakens the trigger signal.

### 2. Stagehand setup gap — SKILL.md:106–110
- Current: Install block mentions `BROWSERBASE_API_KEY + BROWSERBASE_PROJECT_ID` are required but doesn't say where to set them or what happens if absent.
- Recommendation: Add: "Set env vars before first use: `export BROWSERBASE_API_KEY=... BROWSERBASE_PROJECT_ID=...` — without them, Stagehand MCP will error on init, not on first command."

### 3. Decision matrix "Why" column inconsistency — SKILL.md:14–23
- Current: Some rows give concrete reasons ("~200–400 tokens/page"), others give vague labels. The Firecrawl row says "Read-only, no interaction overhead" which describes a *limitation*, not a *reason to choose it*.
- Recommendation: Standardize each "Why" to answer "what makes this the best choice for this need" not "what it is." For Firecrawl: "No browser overhead; returns clean markdown/JSON in one call." For chrome-devtools-mcp: "Only tool with DevTools Protocol — required for heap snapshots and Lighthouse scores."

### 4. "Peekaboo (browser fallback)" duplication — SKILL.md:23, 49–58, 38–47
- Current: Same fallback information appears in three places (matrix row, dedicated code block, escalation prose).
- Recommendation: Consolidate. Keep the matrix row as the decision point and the code block as the single implementation reference. Remove the redundant prose in the escalation section or replace it with a pointer.

---

## Strengths

- Token-cost data for agent-browser vs. playwright-mcp (line 16: "~200–400 tokens/page, 5.7x more efficient") is concrete and compelling — exactly the kind of "why" that guides correct tool choice.
- AppleScript-first patch for Messages is specific and actionable, including the Peekaboo v3.0.0-beta3 timeout note (line 64).
- The `osascript` iMessage snippet with the Contacts resolver (lines 68–79) is a perfect example: minimal, copy-pasteable, handles a real gotcha (display name vs. handle).
- `## Live docs` section (lines 121–140) is excellent — self-referential help commands prevent the skill from going stale.
- YAML name matches directory; description is functionally specific enough to distinguish from a general browser skill.

---

## Quick fixes

1. Line 8: Bold tagline floats outside any tag — wrap when migrating to XML.
2. Line 10: Quick-command line (`/automate help | /automate doctor`) — confirm these commands are live.
3. Line 87: "schema alone costs ~13.7K tokens" — cite source or mark as approximate; will mislead if playwright-mcp versions change.
4. Line 144: "agent-browser is ~2 months old (2026)" — will go stale; remove the age claim or move to a dated changelog note.
5. Line 145: "Rakun-style sessions" — internal jargon. Replace with "long autonomous sessions" or define inline.

---

## Top 3 changes that would most improve this skill

1. **Migrate body to pure XML and add the three required tags.** Highest-leverage structural fix. Without `<success_criteria>`, a routing agent has no clear signal to stop routing and start executing.
2. **Add the TCC/sandbox AppleScript failure path.** One sentence. Without it, AppleScript escalation has a silent dead end on hardened macOS systems — exactly the environment this skill targets.
3. **Front-load the routing imperative in the YAML description.** First clause should be "Routes automation requests before any execution begins" — not buried after the feature list. Directly combats undertriggering, the existential failure mode for a router skill.
