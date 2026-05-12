# Run Selection — Full Algorithm

Invoked by `/rails-test-run [arg]` and by the skill when the user says "run tests".

## Decision tree

```
arg given?
├── yes → pass through to rspec
└── no  → examples.txt has unresolved failures?
          ├── yes → bundle exec rspec --only-failures
          └── no  → git diff testing...HEAD changes any app/**?
                    ├── yes → diff-based selection (below)
                    └── no  → "No failures, no diff. Use /rails-test-full." Exit 0.
```

## Diff-based selection

1. List changed app files: `git diff testing...HEAD --name-only -- 'app/**/*.rb'`.
2. Direct specs: `app/<path>.rb → spec/<path>_spec.rb`. Skip if spec doesn't exist (audit's job to flag).
3. Dependents: parse class/module names from each changed file, grep specs for those names.
4. Cap dependents at 50 (most-recently-modified). Print transparency message when capped.
5. Run `bundle exec rspec <list>`.

## Argument vocabulary

| Arg | Effect |
|---|---|
| (empty) | Smart selection per decision tree |
| `failed` | `rspec --only-failures` |
| `next` | `rspec --next-failure` |
| `focus` | Only specs tagged `:focus` |
| `changed` | Force diff-based selection (skip failures-first step) |
| `parallel` | `parallel_rspec spec/` |
| `coverage` | `COVERAGE=true rspec` |
| `feature` | `FEATURE=1 rspec spec/system spec/features` |
| `seed:NNNN` | `rspec --seed NNNN` |
| `<path>` | Passthrough |
| `<path>:<line>` | Passthrough |
| `--<flag>` | Passthrough |

## Output contract

Every run prints:
1. Selection reason (one line).
2. What's running (file count + command).
3. Standard rspec output.
4. End-of-run summary: pass/fail count, slowest 5, hint on failure.

## Examples

- `/rails-test-run` (no args, has failures) → `Selection: failures-first (3 failures)` → runs only failures.
- `/rails-test-run` (no args, clean run, 4 changed files) → `Selection: diff-based (12 specs from 4 changed files vs testing)`.
- `/rails-test-run failed` → `Selection: passthrough (failed)` → `rspec --only-failures`.
- `/rails-test-run parallel coverage` → `Selection: passthrough (parallel coverage)` → `COVERAGE=true bundle exec parallel_rspec spec/`.

## Implementation

`scripts/select_specs.rb` (CLI) → `scripts/lib/spec_selector.rb` (logic).
