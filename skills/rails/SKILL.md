---
name: rails
version: 1.0.0
description: Ruby on Rails conventions, patterns, and best practices following the Rails Doctrine and the modern stack (Hotwire, Tailwind CSS, PostgreSQL). Loaded as reference context when Rails standards or architecture are discussed.
triggers:
  - rails conventions
  - rails patterns
  - rails best practices
  - rails architecture
  - active record conventions
  - hotwire patterns
  - ruby on rails standards
  - stimulus conventions
  - turbo patterns
---

# Rails

You write world-class Ruby on Rails code. Every decision flows from the Rails Doctrine -- the philosophical foundation that has made Rails the most productive web framework for two decades.

## Execution Workflow

1. **Inspect** the codebase before proposing changes.
2. **Match** existing conventions unless the user requests a migration.
3. **Use Rails conventions** and plain Ruby first.
4. **Prefer small, reversible changes** with tests.
5. **Report tradeoffs** explicitly when choosing architecture.

### Mandatory Codebase Scan

Always read these files first when available:

- `Gemfile` — Rails version, gems, queue backend
- `config/application.rb` — load defaults, framework config
- `config/routes.rb` — routing patterns, namespace style
- `config/environments/*.rb` — at least the target env
- `app/models/` — 2-5 representative models
- `app/controllers/` — 2-5 representative controllers
- `test/` or `spec/` — test framework and style
- Deploy entrypoints: `Procfile*`, `bin/jobs`, `config/deploy*.yml`, CI config

Record and follow observed patterns for: test framework, auth style, frontend stack, queue backend, API conventions.

---

## The Nine Pillars

These aren't suggestions. They are the operating system for every line of code you write.

### 1. Optimize for Programmer Happiness

Ruby was designed for joy. Rails inherits that spirit. Choose the API that reads like prose. Prefer `3.days.ago` over `Time.now - 259200`. Use `person.in?(people)` when the person is the subject. Write code that a human enjoys reading.

### 2. Convention Over Configuration

This is the beating heart of Rails. Never make the developer decide what the framework already knows:

- A `Person` model maps to `people` table -- don't configure it
- `person_id` is the foreign key -- don't specify it
- `app/views/people/index.html.erb` renders for `PeopleController#index` -- don't declare it
- `created_at` and `updated_at` exist on every table -- don't question it

When you follow convention, hundreds of things work automatically. When you deviate, you must justify why.

### 3. The Menu Is Omakase

Rails is a curated full-stack framework. The pieces are chosen to work together: Active Record + Action Pack + Action View + Turbo + Stimulus + Solid Queue + Solid Cache + Solid Cable. Trust the stack. Don't reach for external gems when Rails provides the answer. Don't introduce React when Hotwire suffices. Don't add Sidekiq when Solid Queue is already configured.

### 4. No One Paradigm

Use the right tool for each layer:
- **Models**: Object-oriented domain modeling with Active Record
- **Views**: Procedural helpers and ERB templates -- sometimes a helper function is better than a presenter
- **Controllers**: Thin orchestration between request and response
- **Database**: SQL when Active Record's query interface isn't enough -- don't fear `Arel` or raw SQL for complex queries
- **Frontend**: HTML-centric with Stimulus for behavior -- it's OK to mix paradigms

### 5. Exalt Beautiful Code

```ruby
class Project < ApplicationRecord
  belongs_to :account
  has_many :participants, class_name: "Person"
  validates :name, presence: true
end
```

This reads like a specification, not an implementation. Pursue this clarity in every file. Prefer `unless` over `if !`. Prefer guard clauses over nested conditionals. Prefer `&:method_name` over verbose blocks. Let Ruby's expressiveness shine.

### 6. Provide Sharp Knives

Use concerns to decompose complex models. Use `module_function` for utility methods. Use monkey patches sparingly but don't fear Active Support extensions. Trust developers to use powerful tools responsibly. Don't over-abstract to prevent misuse.

### 7. Value Integrated Systems

Build majestic monoliths. Rails gives one person the power to build a complete system -- database, server logic, background jobs, real-time updates, file storage, email. Don't split into microservices prematurely. Don't create a separate API and SPA when server-rendered HTML with Hotwire delivers the same experience with a fraction of the complexity.

### 8. Progress Over Stability

Use the latest Rails patterns. Prefer `params.expect` over `params.permit`. Use `normalizes` over custom callbacks. Use `generates_token_for` over hand-rolled token logic. When Rails introduces a better way, adopt it.

### 9. Push Up a Big Tent

Respect existing patterns in the codebase. Don't rewrite working code to match your preference. Adapt to the project's style within Rails conventions.

---

## Architecture: How Rails Code Flows

```
Request -> Routes -> Controller -> Model -> View -> Response
                                     ^
                              Helpers/Partials
                                     |
                          Background Job -> Mailer / Cable
```

### Models (The Domain)

Models are the heart. They own business logic, validations, associations, scopes, and callbacks. A well-modeled domain makes everything else simple.

**Read `references/models.md` when working with**: Active Record, associations, validations, callbacks, scopes, queries, migrations, concerns, enums, or database design.

Key principles:
- Rich models with focused concerns -- decompose with `ActiveSupport::Concern` when a model grows beyond ~200 lines
- Validate at the model level, constrain at the database level (belt and suspenders)
- Use scopes for reusable query logic, not class methods -- name scopes for business concepts (`active`, `unassigned`), not SQL operations
- Model state as records, not booleans -- a `Closure` record captures who/when/why; a `closed` boolean doesn't
- POROs live under model namespaces (`Event::Description`) -- no `*Service`, `*Manager`, `*Handler` suffixes
- Prevent N+1 queries with `includes`, `preload`, or `eager_load`
- Use `strict_loading` in development to catch lazy loading
- Prefer `has_many :through` over `has_and_belongs_to_many` -- the join model almost always needs attributes later

### Controllers (The Orchestrator)

Controllers authenticate, authorize, parse input, delegate to models, and return a response. Nothing more. Typically under 10 lines per action.

**Read `references/controllers.md` when working with**: controllers, routing, strong parameters, filters, flash messages, session management, or API endpoints.

Key principles:
- Stick to the 7 RESTful actions: `index`, `show`, `new`, `create`, `edit`, `update`, `destroy`
- When you need actions beyond the 7, model the verb as a noun resource (e.g., `close` -> `resource :closure`, `publish` -> `resource :publication`)
- Thin controllers invoke rich domain models directly -- no service layer between them
- Strong parameters via `params.expect` (Rails 8+) -- returns 400 on bad params, not 500. Never `params.permit!`
- No query logic (`.where`, `.order`, `.joins`) in controllers or views -- push it into model scopes
- One instance variable per action when possible -- the view shouldn't need to understand controller internals
- Respond to HTML by default, Turbo Stream when enhancing

### Views (The Presentation)

Views render HTML. They should contain minimal logic -- just enough to present data.

**Read `references/views.md` when working with**: ERB templates, layouts, partials, helpers, content_for, Turbo Frame/Stream responses, or form builders.

Key principles:
- Extract partials for reusable components -- prefix with underscore, reference without
- Use `render collection:` for lists -- it's faster and cleaner than loops
- Keep helpers for formatting logic (dates, currencies, status badges)
- Use `content_for` to inject page-specific content into layouts
- Partials are your component system -- pass locals explicitly, avoid instance variables in partials

### Hotwire (The Frontend)

Hotwire is the default frontend stack. It sends HTML over the wire instead of JSON, keeping rendering on the server where it belongs.

**Read `references/hotwire.md` when working with**: Turbo Drive, Turbo Frames, Turbo Streams, Stimulus controllers, real-time updates, WebSocket features, or any frontend interactivity.

Key principles:
- **Turbo Drive** handles 80% -- automatic fast navigation, zero JS required
- **Turbo Frames** decompose pages into independently updatable regions
- **Turbo Streams** deliver surgical DOM updates (append, prepend, replace, update, remove, before, after, morph)
- **Stimulus** adds behavior to HTML -- use for the 20% that Turbo can't handle
- Build features that work without JavaScript first, then enhance with Turbo/Stimulus
- One Stimulus controller per behavior -- small, focused, reusable

### Frontend Styling

**Read `references/frontend.md` when working with**: Tailwind CSS classes, responsive design, dark mode, component extraction, importmaps, or Propshaft asset pipeline.

Key principles:
- Utility-first with Tailwind -- compose styles in markup
- Extract `@apply` components only when a pattern repeats 3+ times across different templates
- Mobile-first responsive design with `sm:`, `md:`, `lg:` prefixes
- Use Propshaft for asset serving -- it's simpler than Sprockets
- Importmaps for JavaScript -- no Node.js build step needed

---

## Decision Framework

When facing a design decision, evaluate in this order:

1. **Does Rails have a convention for this?** Follow it.
2. **Does Rails provide a built-in solution?** Use it before reaching for a gem.
3. **Is this the simplest thing that works?** Don't over-engineer.
4. **Will another Rails developer understand this instantly?** Optimize for readability.
5. **Does this keep the monolith cohesive?** Resist premature extraction.

### When to Reach for What

| Need | Reach for | Not for |
|------|-----------|---------|
| Page navigation | Turbo Drive | Custom AJAX |
| Partial page update | Turbo Frames | React components |
| Multi-element update | Turbo Streams | JSON API + JS rendering |
| Real-time updates | Turbo Streams over Action Cable | Polling / third-party WS |
| JS behavior | Stimulus controller | jQuery / vanilla event listeners |
| Background work | Detect backend: adapter config → Gemfile → runtime commands | Assuming Solid Queue without checking |
| Caching | Solid Cache (Rails.cache) | Redis (unless already in stack) |
| WebSockets | Solid Cable (Action Cable) | Socket.io / Pusher |
| File uploads | Active Storage | CarrierWave / Shrine |
| Rich text | Action Text | Custom WYSIWYG |
| Email | Action Mailer | SendGrid SDK directly |
| Search | PostgreSQL full-text search | Elasticsearch (until scale demands it) |
| Auth | Rails 8 authentication generator | Devise (unless complex multi-tenant) |

---

## Code Quality Standards

### Naming

Follow Rails conventions precisely:
- **Models**: Singular, CamelCase (`OrderItem`, not `OrderItems` or `Order_Item`)
- **Controllers**: Plural, CamelCase + Controller (`OrderItemsController`)
- **Tables**: Plural, snake_case (`order_items`)
- **Columns**: snake_case (`total_price`, not `totalPrice`)
- **Foreign keys**: `singularized_table_name_id` (`order_id`)
- **Join tables**: Alphabetical, pluralized (`categories_products`)
- **Routes**: Plural, kebab-case in URLs (`/order-items`)
- **Files**: snake_case matching class name (`order_item.rb`)
- **Stimulus controllers**: kebab-case (`clipboard-controller.js` -> `data-controller="clipboard"`)
- **Partials**: prefixed underscore (`_order_item.html.erb`)

### File Organization

```
app/
├── controllers/
│   ├── concerns/          # Shared controller behavior
│   └── api/               # API-specific controllers (if needed)
├── models/
│   └── concerns/          # Shared model behavior
├── views/
│   ├── layouts/           # Application layouts
│   ├── shared/            # Cross-controller partials
│   └── [resource]/        # Resource-specific views
├── helpers/               # View formatting helpers
├── javascript/
│   └── controllers/       # Stimulus controllers
├── jobs/                  # Active Job classes
├── mailers/               # Action Mailer classes
└── channels/              # Action Cable channels
```

### Testing

**Read `references/testing.md` when working with**: writing tests, fixtures, system tests, integration tests, or test organization.

- Write tests for every model, every controller action, and every critical user flow
- Use Minitest (the Rails default) -- don't add RSpec unless the project already uses it
- Fixtures over factories -- they're faster and Rails conventions expect them
- System tests for critical paths only (registration, checkout, core workflows)
- Test behavior, not implementation -- assert outcomes, not method calls

### Security

**Read `references/security.md` when working with**: authentication, authorization, parameter handling, CSRF, CSP, or any user-facing input.

- `params.expect` always -- never trust user input
- Scope queries to the current user: `current_user.projects.find(params[:id])`
- `reset_session` after login to prevent session fixation
- Use `rate_limit` on sensitive endpoints (Rails 8+)
- Content Security Policy in initializer -- don't leave it unconfigured

### Performance

**Read `references/performance.md` when working with**: caching, database optimization, N+1 queries, background jobs, or deployment.

- Fragment caching with Russian doll nesting for views
- `includes` to prevent N+1 -- use `strict_loading` to catch them
- `counter_cache` for frequently counted associations
- Background jobs for anything that doesn't need immediate response
- Database indexes on every foreign key and frequently queried column
- Use `explain` to understand query plans for slow queries

---

## Background Job Backend Policy

Never assume Solid Queue just because the app is Rails 8. Detect backend in this order:

1. `config.active_job.queue_adapter` setting
2. `Gemfile` gems (`good_job`, `solid_queue`, `sidekiq`, others)
3. Worker runtime commands and deployment wiring (`Procfile`, `bin/jobs`)

Rules:
- If `good_job` is active, keep `good_job` conventions
- If `solid_queue` is active, keep `solid_queue` conventions
- If both gems exist, treat the configured adapter as authoritative
- Do not migrate queue backend implicitly as part of unrelated tasks
- Write backend-agnostic `ApplicationJob` code unless backend features are explicitly requested
- Set `enqueue_after_transaction_commit = true` -- fix root causes, not symptoms

---

## Fail-Fast Policy

- Use `save!`, `create!`, `update!` in jobs and POROs -- silent failures are invisible until data is corrupt
- Use `find_by!` and `fetch` over `find_by` and `[]` when nil is unexpected
- Rescue only specific exceptions with intentional handling -- never bare `rescue`
- Avoid defensive patterns that hide errors: `respond_to?`, `try`, dynamic `send`
- In controllers, `save` (without `!`) is acceptable for form validation flows where you re-render on failure
- Wrap multi-step mutations in transactions

---

## Code Quality Gates

| Metric | Threshold |
|--------|-----------|
| Class size | <200 lines |
| Public methods per class | <15 |
| Private methods per class | <7 |
| Method size | <10 lines preferred, <20 hard limit |
| Nesting depth | <2 levels |
| Method parameters | <3 (use keyword args or parameter objects beyond) |
| Concern size | 50-150 lines, one capability each |

---

## Authentication Patterns

Prefer Rails 8 built-in authentication. When implementing custom auth:

- Use `has_secure_password` with bcrypt
- Follow 37signals naming: `Identity` (global email-based), `User` (per-account membership), `Session`
- Rate limit authentication endpoints aggressively
- Store sessions via signed cookies with `httponly` and `same_site: :lax`
- `reset_session` before setting session data to prevent session fixation

---

## Output Contract

**For implementation tasks**, produce:
1. Required schema changes with migrations
2. Model/controller/view/job code following local conventions
3. Tests matching local framework
4. Brief risk notes (security, performance, rollout concerns)

**For review tasks**, prioritize:
1. Correctness and behavioral regressions
2. Security and data integrity
3. Performance and operability
4. Test gaps

---

## PostgreSQL-Native Patterns

This stack uses PostgreSQL. Embrace its features:

- **JSONB columns** for flexible schema-less data -- queryable and indexable
- **Array columns** for simple lists without join tables
- **Full-text search** with `tsvector` -- skip Elasticsearch until you outgrow it
- **Database constraints** (`NOT NULL`, `UNIQUE`, `CHECK`) alongside model validations
- **Partial indexes** for queries on subsets (`WHERE active = true`)
- **Generated columns** for derived values the database maintains automatically
- **Exclusion constraints** for non-overlapping ranges (scheduling, reservations)

---

## Reference Files

The `references/` directory contains deep-dive documentation for each domain. Read the relevant reference when the SKILL.md guidance isn't detailed enough for the task at hand:

| File | When to read |
|------|-------------|
| `references/models.md` | Active Record, associations, validations, migrations, queries, concerns |
| `references/controllers.md` | Controllers, routing, params, filters, REST design |
| `references/views.md` | ERB, layouts, partials, helpers, forms, content_for |
| `references/hotwire.md` | Turbo Drive/Frames/Streams, Stimulus, real-time patterns |
| `references/frontend.md` | Tailwind CSS, importmaps, Propshaft, responsive design |
| `references/testing.md` | Minitest, fixtures, system tests, test organization |
| `references/security.md` | Auth, CSRF, CSP, parameter safety, rate limiting |
| `references/performance.md` | Caching, N+1, background jobs, database optimization |
