# Workflow: Kickoff — Full Mode

<required_reading>
**Read these files NOW:**
1. `workflows/_preflight.md`
2. `templates/claude-md-full.md`
3. `templates/brief.md`
4. `templates/roadmap.md`
5. `templates/todos.md`
6. `references/gitignore-defaults.md`
</required_reading>

<process>
## Step 1: Run preflight

Follow `workflows/_preflight.md` end-to-end. Stop if any check fails.

## Step 2: Brief discovery (8–12 questions in batches)

Full mode runs THREE batched AskUserQuestion calls. Each call asks up to 4 questions (the tool's max). Pre-fill defaults from conversation history.

**Batch A — Identity & purpose (4 questions):**
1. Project name (confirm directory basename or override)
2. Project type (`code` / `research` / `writing` / `mixed`)
3. Main goal — one-line outcome
4. Motivation — why this matters / why now

**Batch B — Scope & success (4 questions):**
5. Target audience or end-user (who consumes the output)
6. Success criterion — measurable, observable
7. Out-of-scope — what this project deliberately does NOT include
8. Constraints — deadline, budget, dependencies, or "none"

**Batch C — Plan & risks (3–4 questions):**
9. Initial milestones — provide 3 plausible drafts; user picks or types Other
10. Top risk or unknown
11. Tech stack or tools (if applicable; skip for non-code)
12. External references (links, docs, prior work) — optional

After each batch, check the user's answers before sending the next. If a batch reveals the project is much smaller than expected, you MAY tell the user "this looks like a detail-mode project — want to switch?" and offer to abort.

## Step 3: Write brief.md

Copy `templates/brief.md`. Fill all sections from Batch A and Batch B answers. Write to `./brief.md`.

## Step 4: Write roadmap.md

Copy `templates/roadmap.md`. Convert the milestones from Batch C into phased entries with rough sequencing. Write to `./roadmap.md`.

## Step 5: Write TO-DOS.md

Copy `templates/todos.md`. Seed it with the first 3–5 concrete next actions derived from Phase 1 of the roadmap. Write to `./TO-DOS.md`.

## Step 6: Write CLAUDE.md

Copy `templates/claude-md-full.md`. This template links to brief.md, roadmap.md, and TO-DOS.md. Fill placeholders.

## Step 7: Write .gitignore

Pick the appropriate template from `references/gitignore-defaults.md`.

## Step 8: Initialize git and commit

```bash
git init -b main
git add CLAUDE.md brief.md roadmap.md TO-DOS.md .gitignore
git commit -m "Initial commit: scaffold via /kickoff full"
```

## Step 9: Create private GitHub repo and push

```bash
gh repo create "{{REPO_NAME}}" --private --source=. --push
```

## Step 10: Report

Give the user a 4–6 line summary:
- All artifacts created
- GitHub repo URL
- The first item from TO-DOS.md as the suggested next action
- A reminder to review brief.md / roadmap.md and refine if needed
</process>

<success_criteria>
- [ ] Preflight passed
- [ ] All six artifacts exist (CLAUDE.md, brief.md, roadmap.md, TO-DOS.md, .gitignore, .git/)
- [ ] Initial commit created
- [ ] Private GitHub repo created and pushed
- [ ] User got summary with repo URL and next action
</success_criteria>
