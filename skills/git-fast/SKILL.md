---
skill_name: git-fast
version: 1.0.0
description: Quick commit and push - no analysis, no ceremony
allowed-tools: Bash(git *)
argument: message
---

## Context

- Current git status: !`git status --short`
- Current branch: !`git branch --show-current`
- Upstream: !`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "no upstream"`

## Your Task

Quick commit and push. No analysis, no grouping, no ceremony. Just ship it.

$ARGUMENTS

### Rules

1. **Stay on current branch.** Never switch branches.
2. **Stage everything** - `git add -A`
3. **Commit message:**
   - If the user provided a message in `$ARGUMENTS`, use it as-is (but ensure conventional commit format - add prefix if missing)
   - If no message provided, auto-generate a concise conventional commit message from the diff. Read `git diff --cached --stat` after staging to understand changes.
   - **Add a commit body** if: multiple files changed, new files introduced, or the subject alone doesn't explain what/why. Only skip the body for trivial single-file changes where the subject is self-explanatory.
4. **Push** to upstream. If no upstream, set with `-u origin <branch>`.
5. **No AI references** in commit message.
6. **If behind upstream**, pull --rebase first, then commit and push.

### Execution (single turn, no questions)

```
git add -A
git commit -m "<message>"
git push
```

Report: branch, commit message, push result. One line each. Done.
