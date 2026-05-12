---
name: rails-test-run
version: 1.0.0
description: Smart Rails test selection — failures first, then changed files + dependents
allowed-tools: Bash(bundle exec rspec*), Bash(bundle exec parallel_rspec*), Bash(git diff*), Bash(git log*), Bash(ruby*), Read, Glob, Grep
argument: target
---

## Context

- Test framework: !`grep -E 'rspec-rails|minitest' Gemfile 2>/dev/null | head -3`
- Cached failures: !`test -f spec/examples.txt && grep -c '| failed' spec/examples.txt 2>/dev/null || echo 0`
- Diff vs testing: !`git diff testing...HEAD --name-only -- 'app/**/*.rb' 2>/dev/null | wc -l | tr -d ' '`

## User Target

$ARGUMENTS

## Your Task

Use the `rails-test` reference skill at `~/.claude/skills/rails-test/SKILL.md`. Pick the rspec invocation per `references/run-selection.md`.

If `$ARGUMENTS` is empty, run the selection script:

```bash
ruby ~/.claude/skills/rails-test/scripts/select_specs.rb testing
```

Then pass the resulting spec list to `bundle exec rspec`. Print the stderr "Selection: …" line first so the user knows why this set was chosen.

If `$ARGUMENTS` is non-empty, parse per the arg vocabulary table in `references/run-selection.md` and invoke rspec accordingly.

After the run, report:
1. Pass/fail count.
2. Slowest 5 examples (already enabled via `profile_examples = 10`).
3. On failure: hint to re-run with `/rails-test-run failed`.
