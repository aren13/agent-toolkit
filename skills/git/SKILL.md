---
name: git
version: 1.0.0
description: Git conventions, commit standards, branch naming, and PR templates. Loaded as reference context when git standards are discussed.
triggers:
  - git conventions
  - commit standards
  - branch naming
  - pr template
  - git standards
---

# Git

Execute, don't ask. You are a domain expert -- for routine git operations (status, add, commit, push to tracked branches, branch creation), execute immediately and report results. Only pause for: (1) destructive operations (force push, rebase, reset), (2) pushing to protected/unfamiliar branches, (3) genuinely ambiguous scenarios where best practice doesn't dictate a clear choice.

## Workflow

1. **Discover** -- Run `git status`, check branch/tracking info, review recent commits, diff stats
2. **Sync** -- If upstream exists and branch is behind, stash changes, `git pull --rebase`, pop stash. Report conflicts if any occur.
3. **Analyze** -- Group changes into logical commits by semantic area. Identify .gitignore candidates, breaking changes, test coverage gaps.
4. **Plan** -- Determine commit grouping, branch structure (separate unrelated concerns into different branches/PRs). Be opinionated -- don't present inferior alternatives.
5. **Execute** -- Stage by logical group, commit with conventional messages, push with tracking, create PR if requested.
6. **Report** -- Summarize: branch, commits made, push status, PR URL, warnings.

## Commit Message Standards

Format: `<type>(<scope>): <subject>` + optional body + footer

**Types:** `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `style`, `chore`, `ci`, `revert`

**Scopes (Rails):** `models`, `controllers`, `api`, `services`, `views`, `db`, `deps`, `config`, `iot`, `market`, `auth`

**Subject rules:**
- Max 72 characters, imperative mood ("add" not "added"), no period, lowercase after colon
- Describe WHAT and WHY, not HOW

**Body rules:**
- Wrap at 72 chars. Explain motivation, contrast with previous behavior. Use PROBLEM/SOLUTION structure for fixes.
- **A body is REQUIRED when:** (1) the commit contains more than one file or logical change, (2) the subject line alone cannot explain what was done and why, (3) new files are introduced that a reviewer would not understand from the subject alone, or (4) the change has non-obvious consequences.
- **A body may be skipped only when:** the commit is a trivial single-file change where the subject fully explains the what and why (e.g., `chore: add .DS_Store to gitignore`).
- The body should answer: What does this change do? Why is it needed? What files or components are affected?

**Footer:** `Refs: #123` for tickets, `BREAKING CHANGE: description` for breaking changes.

## Branch Naming

Format: `<type>/<ticket-or-description>` in kebab-case, max 50 chars.

Examples: `feat/sms-6401-smart-scale`, `fix/donation-scope-issue`, `refactor/extract-approval-service`

## Stash and Sync

### Stash
```bash
git stash push -u -m "description"        # stash all including untracked
git stash push -m "msg" -- file1 file2     # stash specific files
git stash list                             # list stashes
git stash pop                              # apply + remove most recent
git stash apply stash@{2}                  # apply specific, keep in list
```

### Upstream Sync
```bash
# Sync current branch before pushing
git stash push -u -m "sync: before rebase"
git pull --rebase origin <branch>
git stash pop
# If conflicts after pop: resolve, git add, git stash drop
```

### Sync with Target Branch
```bash
git fetch origin
git rebase origin/testing
# Conflicts: resolve -> git add -> git rebase --continue
# Abort: git rebase --abort
```

### Recovery
```bash
git reset --soft HEAD~1     # undo commit, keep staged
git reset HEAD~1            # undo commit, keep unstaged
```

## .gitignore Management

**Auto-ignore** (add without asking): `*.log`, `tmp/*`, `.DS_Store`, `node_modules/`, `coverage/`, `.env.local`, `*.swp`

**Ask user first**: `.claude/`, `prompts/`, `ae-cc/`, `docs/`, root config files

**Never ignore**: source code, tests, migrations, `.env.example`

## Forbidden Content

Never include in commits or PRs: "Generated with Claude Code", "Co-Authored-By: Claude", "Created by Claude", "AI-generated", "Anthropic", or any AI tool references.

## Pre-Commit Validation

Before every commit, verify:
1. No forbidden terms in message
2. Conventional commit format valid
3. Subject line <= 72 chars
4. No debug code (`binding.pry`, `console.log`, `debugger`) in diff
5. No secrets or credentials in diff

## Decision Guidelines

**Apply best practice directly** (don't offer alternatives):
- Always separate unrelated changes into different branches/PRs
- Always use atomic commits and conventional format
- Always use semantic branch names

**Present options only when:**
- Commit granularity within same logical concern
- Multiple equally valid branch names
- Deployment timing or migration strategy

## PR Descriptions

Read `references/pr-template.md` for the full PR template with checklists for testing, database, security, performance, and documentation.

## Detailed Examples

Read `references/examples.md` for full workflow examples covering bug fixes, features with documentation, and incremental refactoring.

## Error Handling

1. Stop on error, report clearly with context
2. Auto-fix recoverable errors (e.g., pull before push if behind)
3. Only ask user if fix requires destructive action
4. Never force push without explicit user request

## Output Format

```
Branch: [name] -> [remote/branch]
Status: [N modified, M untracked]
Strategy: [N commits, brief description]
---
Commit 1: [subject line]
Commit 2: [subject line]
---
Pushed: [yes/no + remote]
PR: [URL if created]
Warnings: [if any]
```
