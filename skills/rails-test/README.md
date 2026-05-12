# rails-test skill

Global Claude Code skill for Rails test running, auditing, and pre-push gating.
See `SKILL.md` for usage. See `docs/superpowers/specs/2026-05-01-rails-test-skill-design.md`
in a consuming project for the design rationale.

## Running the skill's own tests

```bash
cd ~/.claude/skills/rails-test
bundle install
bundle exec rspec
```

## Three slash commands (installed at ~/.claude/commands/)

- `/rails-test-run` — smart selection (failures-first → diff-based → graceful exit)
- `/rails-test-audit` — diff audit (existence, coverage, smell checks)
- `/rails-test-full` — full-suite escape hatch
