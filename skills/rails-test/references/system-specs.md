# System Specs

## When to write one

- Critical user flow: signup, checkout, primary feature happy path.
- Behavior that depends on JavaScript / Turbo / Hotwire.

## When NOT to write one

- Logic that fits in a request spec or model spec — those are 10–100× faster.
- Edge cases of UI behavior — over-investing in flaky tests.
- Anything you can test by asserting on `response.body` in a request spec.

## Setup

- Default driver: `:rack_test` (fast, no browser).
- For JS-required tests: `driven_by(:selenium, using: :headless_chrome)` per example.
- Selenium + webdrivers loaded lazily inside `Capybara.register_driver` block — only paid by feature/system specs.
- `FEATURE=1 bundle exec rspec spec/system spec/features` to include them in a run.

## Patterns

```ruby
RSpec.describe 'User signs in', type: :system do
  before { driven_by(:rack_test) }

  let(:user) { create(:user) }

  it 'signs in with valid credentials' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Sign in'
    expect(page).to have_content('Signed in successfully')
  end
end
```

## Flake mitigation

- `rspec-retry` retries flaky examples 2× (configured in `spec/spec_helper.rb`).
- Use Capybara's auto-waiting matchers (`have_content`, `have_selector`) — never `sleep`.
- For Ajax: `WaitForAjax` helper (in `spec/support/`).
- For Turbo: wait on `[data-turbo-frame]` updates.

## Performance

- System specs are 10–100× slower than request specs. Run via `FEATURE=1` only when needed.
- `parallel_rspec` parallelizes the system suite across DB-per-process — set up via `bundle exec rake parallel:create parallel:prepare`.
