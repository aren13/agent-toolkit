---
name: rails-test
version: 1.0.0
description: Run Rails test suite with proper flags and conventions
allowed-tools: Bash(bin/rails test*), Bash(rails test*), Bash(ruby -Itest*), Bash(bin/rails db:test:prepare*), Bash(RAILS_ENV=test*), Read, Glob, Grep
argument: target
---

## Context

- Test framework: !`grep -E 'minitest|rspec' Gemfile 2>/dev/null | head -3`
- Test directory: !`ls -d test/ spec/ 2>/dev/null`
- Recent failures: !`test -f tmp/failures.txt && cat tmp/failures.txt 2>/dev/null || echo "no cached failures"`

## User Target

$ARGUMENTS

## Your Task

Run the Rails test suite. Follow the rails reference skill at `~/.claude/skills/rails/SKILL.md` for testing conventions.

### Rules

1. **Use `bin/rails test`** for Minitest (the Rails default). Use `bundle exec rspec` only if the project uses RSpec.
2. **Prepare the test database** if migrations are pending: `bin/rails db:test:prepare`
3. **Run the right scope** based on `$ARGUMENTS`
4. **Report failures clearly** with file, line, and assertion message

### Target Parsing

Parse `$ARGUMENTS` to determine what to test:

| Target | Command |
|--------|---------|
| (empty) | `bin/rails test` -- run all tests |
| `models` | `bin/rails test test/models/` |
| `controllers` | `bin/rails test test/controllers/` |
| `system` | `bin/rails test:system` |
| `integration` | `bin/rails test test/integration/` |
| specific file | `bin/rails test test/models/user_test.rb` |
| specific test | `bin/rails test test/models/user_test.rb:42` |
| `failed` | `bin/rails test --failures` -- rerun only failures |
| `seed:NNNN` | `bin/rails test --seed NNNN` -- reproduce order-dependent failure |

### Workflow

1. Check for pending migrations, prepare test DB if needed
2. Run the targeted tests
3. On failure: read the failing test file to understand context, report the failure with file path, line number, expected vs actual
4. On success: report pass count and timing

### Output

Report: tests run, pass/fail count, timing. If failures, show the specific assertion messages with file:line references.
