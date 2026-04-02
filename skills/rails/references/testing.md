# Testing: Minitest, Fixtures & Best Practices

## Table of Contents
1. [Testing Philosophy](#testing-philosophy)
2. [Test Types](#test-types)
3. [Fixtures](#fixtures)
4. [Model Tests](#model-tests)
5. [Controller Tests](#controller-tests)
6. [Integration Tests](#integration-tests)
7. [System Tests](#system-tests)
8. [Testing Hotwire](#testing-hotwire)
9. [Test Helpers](#test-helpers)

---

## Testing Philosophy

Rails uses Minitest. It's fast, simple, and built in. Don't add RSpec unless the project already uses it. Use fixtures over factories -- they're deterministic, preloaded into the test database with no runtime object creation overhead.

**What to test:**
- Every model validation, scope, and business method
- Every controller action (happy path + error cases)
- Critical user flows with system tests (registration, checkout, core features)
- Edge cases and security boundaries

**Rules:**
- Tests ship with features in the same commit
- Security fixes always include regression tests
- WebMock must remain enabled -- no real HTTP in tests
- Use VCR cassettes for outbound API calls; use JSON captures for inbound webhooks

**What NOT to test:**
- Framework behavior (Active Record saves, routing works)
- Private methods directly — test through public interface
- Trivial methods with no logic

**Test behavior, not implementation.** Assert outcomes, not that specific methods were called.

**Antipatterns to avoid:**
- No `sleep` in tests -- use `travel_to` for time-dependent logic
- No HTML-structure-coupled selectors -- use `data-test-id` attributes
- No shared mutable state between tests
- No stubbing the system under test

---

## Test Types

| Type | Location | What it tests | Speed |
|------|----------|--------------|-------|
| Model | `test/models/` | Validations, scopes, methods, associations | Fast |
| Controller | `test/controllers/` | Actions, params, responses, redirects | Fast |
| Integration | `test/integration/` | Multi-step workflows, API flows | Medium |
| System | `test/system/` | Full browser interaction (Capybara) | Slow |
| Mailer | `test/mailers/` | Email content, recipients, delivery | Fast |
| Job | `test/jobs/` | Background job behavior | Fast |

---

## Fixtures

Fixtures are predefined test data in YAML. They're loaded into the test database before each test and cleaned up automatically.

```yaml
# test/fixtures/users.yml
alice:
  name: Alice Johnson
  email: alice@example.com
  role: admin
  created_at: <%= 3.days.ago %>

bob:
  name: Bob Smith
  email: bob@example.com
  role: member
```

```yaml
# test/fixtures/articles.yml
rails_guide:
  title: Getting Started with Rails
  body: Rails is a web application framework...
  author: alice  # References the alice fixture
  published: true
  published_at: <%= 1.day.ago %>

draft_post:
  title: Work in Progress
  body: This is not ready yet...
  author: bob
  published: false
```

### Fixture Best Practices

- Name fixtures descriptively: `alice`, `published_article`, not `user1`, `article2`
- Keep fixtures minimal — just enough to test with
- Use ERB for dynamic dates: `<%= 3.days.ago %>`
- Reference associations by fixture name (not IDs)
- Access in tests: `users(:alice)`, `articles(:rails_guide)`

---

## Model Tests

```ruby
# test/models/article_test.rb
require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  # Validations
  test "requires a title" do
    article = Article.new(title: nil, author: users(:alice))
    assert_not article.valid?
    assert_includes article.errors[:title], "can't be blank"
  end

  test "requires title to be unique" do
    existing = articles(:rails_guide)
    duplicate = Article.new(title: existing.title, author: users(:alice))
    assert_not duplicate.valid?
  end

  # Scopes
  test ".published returns only published articles" do
    results = Article.published
    assert_includes results, articles(:rails_guide)
    assert_not_includes results, articles(:draft_post)
  end

  test ".recent orders by published_at descending" do
    results = Article.published.recent
    assert_equal results.first.published_at, results.pluck(:published_at).max
  end

  # Business logic
  test "#publish! sets published and published_at" do
    article = articles(:draft_post)
    article.publish!

    assert article.published?
    assert_not_nil article.published_at
  end

  # Associations
  test "belongs to an author" do
    article = articles(:rails_guide)
    assert_equal users(:alice), article.author
  end

  # N+1 prevention
  test ".with_authors eager loads authors" do
    assert_queries_count(2) do  # 1 for articles, 1 for authors
      Article.includes(:author).each { |a| a.author.name }
    end
  end
end
```

---

## Controller Tests

```ruby
# test/controllers/articles_controller_test.rb
require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @article = articles(:rails_guide)
    # If using authentication:
    # sign_in @user
  end

  test "GET index returns success" do
    get articles_path
    assert_response :success
  end

  test "GET show returns the article" do
    get article_path(@article)
    assert_response :success
    assert_select "h1", @article.title
  end

  test "POST create with valid params creates article" do
    assert_difference "Article.count", 1 do
      post articles_path, params: {
        article: { title: "New Article", body: "Content here" }
      }
    end
    assert_redirected_to article_path(Article.last)
  end

  test "POST create with invalid params re-renders form" do
    assert_no_difference "Article.count" do
      post articles_path, params: {
        article: { title: "", body: "" }
      }
    end
    assert_response :unprocessable_entity
  end

  test "PATCH update changes the article" do
    patch article_path(@article), params: {
      article: { title: "Updated Title" }
    }
    assert_redirected_to article_path(@article)
    assert_equal "Updated Title", @article.reload.title
  end

  test "DELETE destroy removes the article" do
    assert_difference "Article.count", -1 do
      delete article_path(@article)
    end
    assert_redirected_to articles_path
  end
end
```

---

## Integration Tests

For multi-step workflows that span multiple requests:

```ruby
# test/integration/user_registration_test.rb
require "test_helper"

class UserRegistrationTest < ActionDispatch::IntegrationTest
  test "user can sign up and see dashboard" do
    get new_registration_path
    assert_response :success

    post registrations_path, params: {
      user: {
        name: "New User",
        email: "new@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }
    assert_redirected_to dashboard_path
    follow_redirect!
    assert_select "h1", /Welcome/
  end
end
```

---

## System Tests

System tests run a real browser. Reserve them for critical user paths.

```ruby
# test/system/articles_test.rb
require "application_system_test_case"

class ArticlesTest < ApplicationSystemTestCase
  test "creating an article" do
    sign_in users(:alice)

    visit articles_path
    click_on "New Article"

    fill_in "Title", with: "System Test Article"
    fill_in "Body", with: "This is the content."
    select "Technology", from: "Category"
    click_on "Save"

    assert_text "Article created."
    assert_text "System Test Article"
  end

  test "inline editing with Turbo Frame" do
    sign_in users(:alice)
    article = articles(:rails_guide)

    visit article_path(article)
    click_on "Edit"

    # Frame should show the edit form without full page navigation
    within "##{dom_id(article)}" do
      fill_in "Title", with: "Updated via Turbo"
      click_on "Save"
    end

    assert_text "Updated via Turbo"
    assert_no_selector "form"  # Form should be replaced by show content
  end

  # Use data-test-id for stable selectors that don't break on markup changes
  test "displays user stats" do
    sign_in users(:alice)
    visit dashboard_path
    within "[data-test-id='user-stats']" do
      assert_text "10 articles"
    end
  end
end
```

### System Test Configuration

```ruby
# test/application_system_test_case.rb
require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 900]
end
```

---

## Testing Hotwire

### Testing Turbo Stream Responses

```ruby
test "POST create returns turbo stream" do
  post articles_path, params: {
    article: { title: "New", body: "Content" }
  }, as: :turbo_stream

  assert_response :success
  assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  assert_match "turbo-stream", response.body
end
```

### Testing Turbo Frame Responses

```ruby
test "GET edit returns content within turbo frame" do
  get edit_article_path(@article), headers: {
    "Turbo-Frame" => dom_id(@article)
  }
  assert_response :success
  assert_select "turbo-frame##{dom_id(@article)}"
end
```

---

## Test Helpers

### Custom Assertions

```ruby
# test/test_helper.rb
class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
  fixtures :all

  # Custom helper for authentication
  def sign_in(user)
    post session_path, params: {
      email: user.email,
      password: "password"  # All fixtures use this password
    }
  end
end
```

### Shared Test Modules

```ruby
# test/test_helpers/authentication_helper.rb
module AuthenticationHelper
  def sign_in_as(user)
    post session_path, params: { email: user.email, password: "password" }
    assert_response :redirect
    follow_redirect!
  end
end

# Include in test_helper.rb
class ActionDispatch::IntegrationTest
  include AuthenticationHelper
end
```
