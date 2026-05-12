# RSpec Conventions

## Spec file shape

```ruby
require 'rails_helper'

RSpec.describe MyClass, type: :model do
  describe '#method_under_test' do
    context 'when X' do
      it 'returns Y' do
        expect(subject.method_under_test).to eq(:y)
      end
    end
  end
end
```

- One `describe` per class/module under test.
- Nested `describe` per method (`#instance_method` / `.class_method`).
- `context` for branches (when/given/with).
- One assertion per `it` — failure messages stay readable.

## let, let_it_be, subject

- `let(:foo) { ... }` — memoized per example.
- `let_it_be(:foo) { ... }` (test-prof) — memoized per example group; use for expensive shared fixtures (e.g. `User`).
- `subject` — the thing under test; let RSpec auto-create where natural (`is_expected.to ...`).

## Matchers

- Use built-in matchers over hand-rolled assertions: `eq`, `match`, `include`, `change`, `raise_error`, `have_attributes`.
- Custom matchers when a domain concept repeats: e.g. `be_published`, `be_invalid_with(:email)`.
- Avoid `expect { ... }.to_not raise_error` without specifying the error class — masks real failures.

## Mocking

- `instance_double` over `double` (verifies method names against the real class).
- Stub at boundaries (HTTP, time, system clock, third-party SDKs); not internal collaborators.
- If you find yourself stubbing the method under test, you're testing the mock — refactor.

## External HTTP

- WebMock disables real net by default in this project.
- Stub specific URLs in `before` blocks or `support/stub_helpers.rb`.
- VCR for replay-style tests on stable third-party APIs.

## Time control

- `freeze_time` (ActiveSupport) over `Timecop`.
- Always thaw after the example (block form).

## Anti-patterns (audit-flagged)

- `update_column` / `update_attribute` to bypass validations.
- `before(:all)` without `use_transactional_fixtures = true`.
- Tautological assertions: `expect(true).to be_truthy`, `expect(klass).to be_truthy`.
- `pending` / `skip` / `xit` left committed.
- Stubbing the method under test.
- 12+ `allow(...).to receive(...)` for 3 `expect(...)` — testing mocks, not code.

## TDD loop (for reference; live in superpowers:test-driven-development)

1. Write failing test.
2. Run it (red).
3. Minimal implementation to pass.
4. Run (green).
5. Refactor (still green).
6. Commit.
