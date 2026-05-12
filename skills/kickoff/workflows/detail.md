# Workflow: Kickoff — Detail Mode

<required_reading>
**Read these files NOW:**
1. `workflows/_preflight.md`
2. `templates/claude-md-detail.md`
3. `templates/brief.md`
4. `references/gitignore-defaults.md`
</required_reading>

<process>
## Step 1: Run preflight

Follow `workflows/_preflight.md` end-to-end. Stop if any check fails.

## Step 2: Ask 3–5 brief questions

Use a single AskUserQuestion call with these items. Pre-fill defaults inferred from conversation history where you can — don't ask things that are already obvious.

Required questions (skip any that the conversation already answered clearly):

1. **Project name** — confirm or override the directory basename (free text via "Other" allowed).
2. **Project type** — options: `code`, `research`, `writing`, `mixed`.
3. **Main goal** — one-line outcome statement. Provide 2–3 plausible options drafted from conversation context, plus "Other" for free text.
4. **Success criterion** — how the user will know this project succeeded. Options drawn from common framings: "ship/publish X", "answer Y question", "deliver Z to person/audience", or Other.
5. **Initial deliverables** — what's the first thing to produce? (Optional — skip if Step 3 already implies it.)

Cap at 4 questions in one AskUserQuestion call (the tool's max). Drop the lowest-priority one if needed.

## Step 3: Write brief.md

Copy `templates/brief.md` and fill placeholders from the answers. Write to `./brief.md`.

## Step 4: Write CLAUDE.md

Copy `templates/claude-md-detail.md` and fill placeholders. This template references `brief.md`. Write to `./CLAUDE.md`.

## Step 5: Write .gitignore

Pick the appropriate template from `references/gitignore-defaults.md` based on project type.

## Step 6: Initialize git and commit

```bash
git init -b main
git add CLAUDE.md brief.md .gitignore
git commit -m "Initial commit: scaffold via /kickoff detail"
```

## Step 7: Create private GitHub repo and push

```bash
gh repo create "{{REPO_NAME}}" --private --source=. --push
```

## Step 8: Report

Tell the user, in 3–4 lines:
- Artifacts created (CLAUDE.md, brief.md, .gitignore)
- GitHub repo URL
- Suggest reading brief.md and adjusting if anything looks off
</process>

<success_criteria>
- [ ] Preflight passed
- [ ] All four artifacts exist (CLAUDE.md, brief.md, .gitignore + git folder)
- [ ] Initial commit created
- [ ] Private GitHub repo created and pushed
- [ ] User got a brief summary with repo URL
</success_criteria>
