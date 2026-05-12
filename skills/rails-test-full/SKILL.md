---
name: rails-test-full
version: 1.0.0
description: Run the full Rails test suite (escape hatch — bypasses smart selection)
allowed-tools: Bash(bundle exec rspec*), Bash(bundle exec parallel_rspec*), Bash(COVERAGE=true*), Bash(FEATURE=*), Read
argument: mode
---

## Context

- Test framework: !`grep -E 'rspec-rails|minitest' Gemfile 2>/dev/null | head -3`
- Estimated count: !`find spec -name '*_spec.rb' 2>/dev/null | wc -l | tr -d ' '`

## User Target

$ARGUMENTS

## Your Task

Use the `rails-test` reference skill at `~/.claude/skills/rails-test/SKILL.md`. Run the full suite per the arg form.

| Arg | Command |
|-----|---------|
| (empty) | `bundle exec rspec` |
| `parallel` | `bundle exec parallel_rspec spec/` |
| `coverage` | `COVERAGE=true bundle exec rspec` |
| `feature` | `FEATURE=1 bundle exec rspec` |
| Combinations | Compose env vars + command, e.g. `parallel coverage` → `COVERAGE=true bundle exec parallel_rspec spec/` |

This is the explicit escape hatch. No selection logic, no caching, no audit. Run what the user asked for.
