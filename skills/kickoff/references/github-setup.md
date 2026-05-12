# GitHub setup reference

## Required tools

- `gh` CLI installed and authenticated (`gh auth status`)
- `git` installed

## Auth check

```bash
gh auth status
```

Successful output looks like:

```
github.com
  ✓ Logged in to github.com account <username>
  ...
```

If this fails:
1. Tell the user to run `gh auth login` (this is interactive — they must do it themselves).
2. Suggest the `! gh auth login` syntax if they're in Claude Code (the `!` prefix runs the command in their session so output lands in the conversation).
3. Stop the workflow. Do NOT try to authenticate on their behalf.

## Creating a private repo

The canonical command for /kickoff:

```bash
gh repo create "{{REPO_NAME}}" --private --source=. --push
```

Flags:
- `--private` — required. /kickoff always creates private repos.
- `--source=.` — uses the current directory as the repo source
- `--push` — pushes the existing local commit to the new remote

Prerequisites:
- Working directory must already be a git repo with at least one commit
- The remote name `origin` will be set automatically

## Repo naming

GitHub allows letters, digits, hyphens, underscores, and dots. It does NOT allow spaces.

Normalization rule:
- Replace spaces with `-`
- Drop characters outside `[A-Za-z0-9._-]`
- Collapse runs of `-` to a single `-`
- Trim leading/trailing `-`

If normalization changes the name, mention this to the user once.

## Default branch

We use `main`. Initialize with `git init -b main` to set this from the start (avoids `master` default on older git installs).

## Verifying after push

```bash
gh repo view --web=false
```

Confirms the remote exists. The output includes the URL — capture it for the user-facing summary.

## Common failures

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `gh: command not found` | gh not installed | `brew install gh` (macOS) |
| `not authenticated` | Token missing/expired | `gh auth login` |
| `name already exists on this account` | Repo name collision | Tell user; ask for alternative |
| `pathspec '...' did not match` on push | No commit yet | Ensure Step "Initialize git and commit" ran |
