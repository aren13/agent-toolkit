---
skill_name: rails-gen
version: 1.0.0
description: Generate Rails scaffold, model, controller, or migration with conventions baked in
allowed-tools: Bash(rails generate:*), Bash(bin/rails generate:*), Bash(rails g:*), Bash(bin/rails g:*), Bash(rails db:migrate*), Bash(bin/rails db:migrate*), Read, Glob, Grep
argument: what
---

## Context

- Gemfile (Rails version): !`grep 'rails' Gemfile 2>/dev/null | head -3`
- Existing models: !`ls app/models/*.rb 2>/dev/null | head -20`
- Existing controllers: !`ls app/controllers/*.rb 2>/dev/null | head -20`
- Database adapter: !`grep 'adapter:' config/database.yml 2>/dev/null | head -1`

## User Request

$ARGUMENTS

## Your Task

You are a Rails generation expert. Generate the requested Rails component following the rails reference skill at `~/.claude/skills/rails/SKILL.md`.

### Rules

1. **Use `rails generate`** -- never hand-write files that the generator creates better
2. **Follow Rails naming conventions** exactly (singular models, plural controllers, snake_case files)
3. **Run `rails db:migrate`** after generating migrations
4. **Add indexes** on foreign keys and frequently queried columns
5. **Add database constraints** (`null: false`, unique indexes) alongside model validations
6. **Use `params.expect`** (Rails 8+) in generated controllers -- fix if generator uses `params.permit`
7. **Prefer `has_many :through`** over `has_and_belongs_to_many`

### Generation Types

Parse `$ARGUMENTS` to determine what to generate:

| Request | Generator | Example |
|---------|-----------|---------|
| model | `rails g model` | `rails g model Article title:string body:text published:boolean` |
| scaffold | `rails g scaffold` | `rails g scaffold Product name:string price:decimal{10,2}` |
| controller | `rails g controller` | `rails g controller Pages home about` |
| migration | `rails g migration` | `rails g migration AddSlugToArticles slug:string:uniq` |
| mailer | `rails g mailer` | `rails g mailer UserMailer welcome reset_password` |
| job | `rails g job` | `rails g job ProcessPayment` |
| channel | `rails g channel` | `rails g channel Notification` |
| stimulus | `rails g stimulus` | `rails g stimulus clipboard` |

### Post-Generation Review

After generating, review the output and fix:
- Replace `params.permit` with `params.expect` if needed
- Add missing `null: false` constraints in migrations
- Add missing indexes on foreign keys
- Ensure model validations match database constraints
- Verify routes are RESTful

### Output

Report: what was generated, migration status, any manual fixes applied.
