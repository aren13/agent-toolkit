# Workflow: Preflight (shared)

<required_reading>
**Read these reference files NOW:**
1. `references/github-setup.md`
</required_reading>

<process>
## Step 1: Check working directory

```bash
pwd
```

Abort with a clear message if pwd is `$HOME` or any obvious non-project location (e.g. `/`, `/tmp`, `~/Desktop`, `~/Downloads`). Project work should happen in a dedicated folder.

## Step 2: Check git state

```bash
git rev-parse --git-dir 2>/dev/null && echo "ALREADY_GIT" || echo "FRESH"
```

- If output contains `ALREADY_GIT`: stop. Tell the user "This directory is already a git repo. /kickoff is for fresh project folders. If you want to add CLAUDE.md to an existing repo, do it manually." Do NOT proceed.
- If output is `FRESH`: continue.

## Step 3: Check for existing CLAUDE.md

```bash
test -f CLAUDE.md && echo "EXISTS" || echo "ABSENT"
```

- If `EXISTS`: stop. Tell the user "CLAUDE.md already exists in this directory. Aborting to avoid overwriting." Do NOT proceed.
- If `ABSENT`: continue.

## Step 4: Verify GitHub CLI auth

```bash
gh auth status
```

- If this fails (not authenticated): stop and tell the user `gh auth login` first, then re-run /kickoff.
- If it succeeds: capture the username from the output for later use in the repo URL summary.

## Step 5: Decide repo name

Default repo name = `basename "$PWD"`. Compute it:

```bash
basename "$PWD"
```

Note this name for the final `gh repo create` step. If the basename contains characters that aren't valid for GitHub repo names (uppercase is fine, but spaces/special chars aren't), normalize: replace spaces with `-`, drop other special chars.

If the normalized name differs from the basename, mention this to the user once before creating the repo.
</process>

<success_criteria>
Preflight passes when:
- [ ] Not in `$HOME` or non-project directory
- [ ] Not already a git repo
- [ ] No existing CLAUDE.md
- [ ] `gh auth status` succeeds
- [ ] Repo name decided

If any check fails, stop completely — do NOT proceed to the mode-specific workflow.
</success_criteria>
