# Audit — Full Pipeline & Smell Checks

Invoked by `/rails-test-audit [base-ref]` and by the Lefthook pre-push hook.

## Pipeline

1. Resolve diff: `git diff <base>...HEAD --name-only`.
2. Filter to `app/**/*.rb`.
3. Apply existence-check exemptions.
4. Build expectation map: each app file → expected `spec/...spec.rb`.
5. Existence check (flag missing).
6. Run specs (changed + dependents) via `SpecSelector.select` with COVERAGE=true.
7. Diff coverage: SimpleCov hit array intersected with `git diff --unified=0` line numbers.
8. Smell scan on touched specs.
9. Score → exit code: 0 (pass), 1 (warn-only), 2 (fail).

## Existence-check exemptions (default)

- `app/assets/**`, `app/javascript/**`, `app/views/**`
- `app/cells/**` (Trailblazer cells)
- `app/datatables/**`
- `app/lib/**/version.rb`, generators, initializers

Override per project via `audit.yml`:

```yaml
base_ref: testing
diff_coverage_warn: 80
diff_coverage_fail: 50
exempt_patterns:
  - app/datatables/**
  - app/cells/**
checks_disabled:
  - slowest_spec_regression
```

## Smell checks

| Check | Severity | Description |
|---|---|---|
| `spec_missing` | **fail** | Expected spec file does not exist |
| `spec_empty` | **fail** | Spec file exists but has no `it`/`example`/`scenario` blocks |
| `no_real_expectations` | **fail** | Touched spec has zero `expect`/`is_expected`/`should` calls |
| `tautological_expect` | warn | `expect(true).to be true`, `expect(klass).to be_truthy`, etc. |
| `mock_heavy_ratio` | warn | `allow/receive` calls > 3× `expect` calls |
| `factory_no_db_assert` | warn | `create(...)` called but no `change`/`reload`/`count`/`where`/`exists?` |
| `untested_branch` | warn | New `if`/`case` branches in code without matching spec growth |
| `pending_or_skipped` | warn | New `pending`/`skip`/`xit`/`xdescribe` in diff |
| `diff_coverage_low` | warn <80% / **fail** <50% | Hit-lines / changed-lines per file |
| `slowest_spec_regression` | info (opt-in) | Top 3 specs >2s slower than baseline |

Hard fails block push. Warns are visible but non-blocking.

## Cache

- File: `tmp/audit_<diff-sha-12>.json`.
- Valid: 5 minutes.
- Pre-push hook reuses cache when `/rails-test-audit` was just run on same diff.

## Bypass

- `git push --no-verify` works (git default).
- Per repo rules, bypass is rare and must be documented in PR description.
- Skill mentions in fail_text but does not enforce.

## Implementation

`scripts/audit.rb` (CLI) → `scripts/lib/audit_runner.rb` (orchestration) → `lib/smell_checks.rb`, `lib/diff_coverage.rb`.
