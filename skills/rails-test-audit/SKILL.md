---
name: rails-test-audit
version: 1.0.0
description: Audit current branch's diff against the test suite (existence, coverage, smells)
allowed-tools: Bash(bundle exec rspec*), Bash(git diff*), Bash(git log*), Bash(ruby*), Bash(COVERAGE=true*), Read, Glob, Grep
argument: base-ref
---

## Context

- Branch: !`git rev-parse --abbrev-ref HEAD`
- Diff vs testing: !`git diff testing...HEAD --name-only 2>/dev/null | head -20`
- App-file count in diff: !`git diff testing...HEAD --name-only -- 'app/**/*.rb' 2>/dev/null | wc -l | tr -d ' '`

## User Target

$ARGUMENTS  (defaults to: testing)

## Your Task

Use the `rails-test` reference skill at `~/.claude/skills/rails-test/SKILL.md`. Run the audit per `references/audit.md`.

```bash
BASE="${1:-testing}"
ruby ~/.claude/skills/rails-test/scripts/audit.rb --base "$BASE"
```

Display the Markdown output to the user. Exit status:
- 0: clean — proceed.
- 1: warnings only — show them, but the user can proceed.
- 2: hard failures — list them and recommend the user fix before pushing.

If audit fails, suggest specific next steps: write missing spec, add expectations, increase diff coverage on the named files. Do not auto-write specs.
