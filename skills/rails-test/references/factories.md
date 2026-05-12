# FactoryBot Conventions

## Naming

- Factory name = lowercase, snake_case model name: `factory :user`, `factory :market_order, class: 'Market::Order'`.
- One factory per file under `spec/factories/`. File name matches factory name.

## Build vs create

- `build(:foo)` — instantiates without DB write. Use whenever you don't need persistence.
- `create(:foo)` — instantiates and saves. Use only when the test requires a record.
- `build_stubbed(:foo)` — like `build` but with a fake ID and stubbed callbacks. Fastest. Default for unit tests.

## Traits

- Compose state via traits: `create(:user, :admin, :with_orders)`.
- Avoid factory inheritance for state variants; use traits.
- Trait names describe state, not implementation: `:admin` not `:role_set_to_admin`.

## Sequences

- Use sequences for unique fields: `sequence(:email) { |n| "user#{n}@test.com" }`.
- Avoid `Faker` in factories — non-determinism slows debugging. OK in seeds.

## Nested associations

- Default to required associations only. Optional assocs → trait.
- Avoid deep nesting — too slow.

## Performance

- `let_it_be` (test-prof) for fixture sharing across the same group.
- `before_all` for shared expensive setup.
- `factory_default :user` (test-prof) for "use this user as the parent unless specified".
- `EVENT_PROF='factory.create' bundle exec rspec` finds slow factories.

## Anti-patterns

- Calling `create` 50× in a single example — use bulk insert or `let_it_be`.
- Factories that hit external APIs — stub, always.
- Factories with required external state (file uploads, S3) — stub the storage adapter.
