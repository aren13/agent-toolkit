---
name: rails-test
description: Use whenever the user mentions running tests, test failures, test coverage, writing specs, or pushing a Rails branch. Selects the right rspec invocation, audits diffs against the test suite, and gates pre-push. Detects RSpec/Minitest from Gemfile. For TDD philosophy see superpowers:test-driven-development.
---

# Rails Test

You are a Rails testing expert. The user's productivity depends on tests being fast, focused, and trustworthy. Default to running the smallest spec set that proves the change works.

## Three commands

| Command            | When                                                  |
|--------------------|-------------------------------------------------------|
| /rails-test-run    | "run tests" — smart selection (failures→diff→deps)    |
| /rails-test-audit  | Pre-push or "are these changes tested?" gate          |
| /rails-test-full   | Explicit full suite (escape hatch)                    |

## Detection
- RSpec: Gemfile contains `rspec-rails` → use `bundle exec rspec`.
- Minitest: no rspec gem → use `bin/rails test`. See `references/minitest.md`.
- This skill is RSpec-first.

## When NOT to run tests
- User asks a question about test code → answer it, don't run.
- User mid-edit (file modified <10s ago) → wait or ask.
- After /rails-test-audit just passed and diff unchanged → say so, skip.

## Run-time conventions
1. With no args, follow the selection algorithm:
   failures-first → diff-based + dependents → graceful exit (don't auto-full).
2. Always print a one-line "selection reason" before running.
3. After every run: report pass/fail count + slowest 5 + next-action hint on failure.

Full algorithm and arg vocabulary: `references/run-selection.md`.

## Audit conventions
- Hard fails: `spec_missing`, `spec_empty`, `no_real_expectations`, `diff_coverage <50%`.
- Warns: `tautological_expect`, `mock_heavy_ratio`, `factory_no_db_assert`, `pending_or_skipped`, `untested_branch`, `slowest_spec_regression`.
- Cache result keyed by diff SHA; valid 5 min.
- Output Markdown so it pastes into PRs.

Full check list and thresholds: `references/audit.md`.

## Writing specs
- One assertion per `it` (clear failure messages).
- FactoryBot over fixtures; prefer `build` over `create` when you can.
- Use `let_it_be` (test-prof) for shared expensive setup.
- WebMock all external HTTP; never let net through.
- System specs only for critical user flows; default to request specs.
- Use `:focus` while iterating, remove before committing.

Patterns and anti-patterns: `references/rspec-conventions.md`, `references/factories.md`, `references/system-specs.md`.

## Composition
- For TDD philosophy + write-test-first discipline: invoke `superpowers:test-driven-development`.
- For Rails conventions broader than tests: invoke the `rails` skill.
- For bug-fix workflow that includes tests: `bug-fix` skill calls `/rails-test-audit` before opening a PR.

## Anti-patterns (audit will reject)
- `update_column` / `update_attribute` in specs (bypasses validations).
- `before(:all)` without database transaction (state leaks).
- `expect(true).to be_truthy` and friends (tautological).
- `pending` / `skip` / `xit` / `xdescribe` left in committed specs.
- Stubbing the method under test.
- `Net::HTTP` without WebMock stub.

## See also
- references/run-selection.md
- references/audit.md
- references/rspec-conventions.md
- references/factories.md
- references/system-specs.md
- references/minitest.md  (only if Gemfile has minitest)
