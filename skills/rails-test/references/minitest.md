# Minitest Fallback (for projects not using RSpec)

The skill detects RSpec from Gemfile. When absent, switch to Minitest conventions.

## Equivalents

| RSpec                              | Minitest                                       |
|------------------------------------|------------------------------------------------|
| `bundle exec rspec`                | `bin/rails test`                               |
| `bundle exec rspec --only-failures` | `bin/rails test --failures` (Rails 8+)        |
| `bundle exec rspec spec/models`    | `bin/rails test test/models`                   |
| `bundle exec rspec spec/x.rb:42`   | `bin/rails test test/x.rb:42`                  |
| `bundle exec parallel_rspec`       | `bin/rails test` (parallel built-in)           |

## File mapping

- `app/models/user.rb` → `test/models/user_test.rb`
- `app/controllers/users_controller.rb` → `test/controllers/users_controller_test.rb`
- `app/system/...` → `test/system/...`

## Audit adaptations

- File-existence check: same logic, different paths.
- Smell checks adapt: `assert`/`assert_equal` instead of `expect`. Most patterns translate cleanly.
- Diff coverage: SimpleCov works the same.

## When to switch

- Detected automatically. If a project genuinely uses both (rare), default to RSpec; document in `audit.yml`.
