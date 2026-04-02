---
skill_name: git-ship
version: 1.0.0
description: Full git workflow on current branch - analyze, commit, push, optional PR
allowed-tools: Bash(git *), Bash(gh pr create:*)
argument: options
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Tracking info: !`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "no upstream"`
- Recent commits: !`git log --oneline -10`
- Upstream status: !`git status -sb | head -1`

## User Options

$ARGUMENTS

## Your Task

You are a git management expert. Execute the full git workflow on the **current branch**. Follow the git reference skill for commit message standards, PR templates, and quality rules.

### Core Rules

1. **Stay on the current branch.** Never checkout or create a new branch unless the user explicitly passes `branching:on` in options.
2. **Sync before committing.** If the branch has an upstream and is behind, stash local changes, pull --rebase, then pop stash. Report conflicts if any.
3. **Analyze changes** - group files into logical commits based on change semantics.
4. **Commit with conventional messages** - use the format from git reference skill (feat, fix, refactor, etc.).
5. **Push to upstream** after committing. If no upstream exists, set it with `-u origin <branch>`.
6. **No AI references** - never include "Claude", "Anthropic", or AI tool mentions in commits.

### Options Parsing

Parse the `$ARGUMENTS` string for these flags (all optional):

| Flag | Effect |
|------|--------|
| `branching:on` | Create a new semantic branch before committing |
| `pr` | Create a PR after pushing (target: `testing` branch) |
| `stash` | Stash current changes instead of committing |
| `sync` | Only sync with upstream (pull --rebase), don't commit |
| `amend` | Amend the last commit instead of creating a new one |

If no options given, default behavior is: analyze -> commit -> push on current branch.

### Workflow

**Phase 1: Sync** (always)
- If upstream exists and branch is behind, stash changes, `git pull --rebase`, pop stash
- If conflicts occur, stop and report them clearly

**Phase 2: Analysis**
- Review all changed/untracked files
- Group into logical commit units
- Check for files that should be in .gitignore

**Phase 3: Execution**
- If `branching:on`: create semantic branch first
- Stage files by logical group
- Commit with conventional messages (imperative mood, max 72 char subject)
- **Commit body is REQUIRED** when: multiple files, new files introduced, or subject alone doesn't explain what/why. Only skip the body for trivial single-file changes where the subject is self-explanatory. The body should list what was added/changed and why.
- If `amend`: use `git commit --amend` instead
- If `stash`: stash instead of committing, then stop

**Phase 4: Push**
- Push to upstream (skip if `stash` or `sync` only)
- Set upstream tracking if needed

**Phase 5: PR** (only if `pr` option given)
- Create PR targeting `testing` branch
- Use the PR template from git reference skill
- Include summary, changes, testing checklist

**Phase 6: Summary**
- Report: branch, commits made, push status, PR URL if created
- Report any warnings (large files, missing tests, debug code)

### Validation Before Committing
- No forbidden terms (Claude, Anthropic, AI-generated)
- Conventional commit format
- Subject line <= 72 chars
- No secrets or credentials in diff
- No debug code or binding.pry

Execute autonomously. Only ask for confirmation on destructive operations (force push, rebase with conflicts).
