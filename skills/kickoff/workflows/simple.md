# Workflow: Kickoff — Simple Mode

<required_reading>
**Read these files NOW:**
1. `workflows/_preflight.md` (run preflight first)
2. `templates/claude-md-simple.md`
3. `references/gitignore-defaults.md`
</required_reading>

<process>
## Step 1: Run preflight

Follow `workflows/_preflight.md` end-to-end. Stop if any check fails.

## Step 2: Infer project context from conversation

Simple mode does NOT ask questions. Extract from the current conversation history:

- **Project name**: prefer the directory basename (already captured in preflight). If the conversation explicitly mentioned a different name, use that.
- **Project purpose**: 1–2 sentence summary of what this project is for, based on what the user discussed before invoking /kickoff.
- **Project type**: pick one of `code` / `research` / `writing` / `mixed` based on conversation cues.

If the conversation has zero context about this project (e.g., user just opened a new session and immediately ran `/kickoff simple`), use a minimal placeholder: purpose = "TBD — fill in.", type = `mixed`. Do NOT ask the user — the contract for simple mode is zero questions.

## Step 3: Write CLAUDE.md

Copy `templates/claude-md-simple.md` and fill placeholders:
- `{{PROJECT_NAME}}` — from Step 2
- `{{PROJECT_TYPE}}` — from Step 2
- `{{CREATED_DATE}}` — absolute date from system context
- `{{PURPOSE}}` — from Step 2

Write to `./CLAUDE.md`.

## Step 4: Write .gitignore

Pick the appropriate template from `references/gitignore-defaults.md` based on project type. If unsure, use the `general` template.

Write to `./.gitignore`.

## Step 5: Initialize git and commit

```bash
git init -b main
git add CLAUDE.md .gitignore
git commit -m "Initial commit: scaffold via /kickoff simple"
```

## Step 6: Create private GitHub repo and push

Use the repo name from preflight Step 5.

```bash
gh repo create "{{REPO_NAME}}" --private --source=. --push
```

Capture the repo URL from the command output.

## Step 7: Report

Tell the user, in 2–3 lines:
- What artifacts were created (CLAUDE.md, .gitignore)
- The GitHub repo URL
- One-line next-step suggestion (e.g., "Edit CLAUDE.md to fill in the purpose if needed.")
</process>

<success_criteria>
- [ ] Preflight passed
- [ ] CLAUDE.md and .gitignore exist
- [ ] `git log --oneline` shows the initial commit
- [ ] `gh repo view` shows a private repo
- [ ] User got a one-screen summary with the repo URL
</success_criteria>
