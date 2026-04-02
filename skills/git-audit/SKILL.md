---
name: git-audit
version: 1.0.0
description: Audit repository health and provide executive summary with actionable recommendations
allowed-tools: Bash(git *), Bash(gh *)
---

## Context

- Current branch: !`git branch --show-current`
- All branches: !`git branch -a`
- Recent commits (30): !`git log --oneline -30`
- Stash list: !`git stash list`
- Status: !`git status`
- Remotes: !`git remote -v`

## Your Task

Audit the current git repository and produce an executive summary with prioritized, actionable recommendations. No changes -- report only.

### Audit Checklist

**1. Branch Health**
- List all local branches and their tracking status
- Identify branches already merged into main/master (`git branch --merged main`)
- Identify stale branches with no commits in 30+ days (`git log -1 --format="%ci" <branch>`)
- Identify branches that are behind upstream and need rebasing
- Flag orphan branches with no remote tracking

**2. Uncommitted Work**
- Staged but uncommitted changes
- Unstaged modifications
- Untracked files that should be committed or gitignored
- Stashed changes (list with descriptions and age)

**3. Commit Hygiene**
- Recent commits missing conventional format (`feat`, `fix`, `refactor`, etc.)
- Oversized commits (10+ files in a single commit)
- Commits with forbidden content (AI references, debug code)
- Empty or vague commit messages

**4. Remote Sync**
- Branches ahead of upstream (unpushed commits)
- Branches behind upstream (need pull)
- Diverged branches (both ahead and behind)
- Fetch latest remote state first: `git fetch --all --prune`

**5. Repository Hygiene**
- Large files that should use Git LFS (`git rev-list --objects --all | git cat-file --batch-check | sort -k3 -n -r | head -20`)
- Files that should be in .gitignore (`.DS_Store`, `node_modules/`, `*.log`, `.env`)
- Dangling references or broken refs
- Merge conflicts in progress

**6. Open PRs** (if GitHub remote detected)
- List open PRs with age and review status (`gh pr list`)
- Flag PRs with merge conflicts
- Flag PRs older than 7 days with no activity

### Output Format

```
====================================
  GIT AUDIT REPORT
  Repo: [name]
  Date: [YYYY-MM-DD]
  Branch: [current]
====================================

## Health Score: [A/B/C/D/F]

Criteria:
- A: Clean repo, no stale branches, all synced
- B: Minor issues (1-2 stale branches, small uncommitted work)
- C: Needs attention (multiple stale branches, sync issues)
- D: Significant issues (merge conflicts, large uncommitted work)
- F: Critical (broken refs, data loss risk)

## Summary
[2-3 sentence overview of repo state]

## Findings

### Critical (act now)
- [finding with specific action]

### Warning (act soon)
- [finding with specific action]

### Info (nice to have)
- [finding with specific action]

## Recommended Actions
[Numbered list, priority order, with exact git commands]

1. [action] -- `git command here`
2. [action] -- `git command here`
```

### Rules

1. **Read-only** -- never modify the repo, only inspect
2. **Be specific** -- include branch names, file paths, commit hashes
3. **Include commands** -- every recommendation must have the exact git command to fix it
4. **Prioritize** -- critical issues first, cosmetic issues last
5. **Be concise** -- executive summary, not a novel
