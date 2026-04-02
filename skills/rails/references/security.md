# Security: Authentication, Authorization & Protection

## Table of Contents
1. [What Rails Protects Automatically](#what-rails-protects-automatically)
2. [Authentication](#authentication)
3. [Authorization](#authorization)
4. [Parameter Safety](#parameter-safety)
5. [SQL Injection Prevention](#sql-injection-prevention)
6. [XSS Prevention](#xss-prevention)
7. [CSRF Protection](#csrf-protection)
8. [Content Security Policy](#content-security-policy)
9. [Rate Limiting](#rate-limiting)
10. [Secrets Management](#secrets-management)

---

## What Rails Protects Automatically

Out of the box, Rails handles:
- CSRF tokens on all non-GET forms
- HTML escaping in ERB templates (`<%= %>` is auto-escaped)
- SQL parameter binding in Active Record queries
- Encrypted session cookies
- Secure default headers (`X-Frame-Options`, `X-Content-Type-Options`, `X-XSS-Protection`)
- `HttpOnly` and `Secure` flags on cookies

You must still handle: authorization, input validation, rate limiting, and CSP configuration.

---

## Authentication

### Rails 8 Authentication Generator

Rails 8+ includes a built-in auth generator:

```bash
bin/rails generate authentication
```

This creates:
- `User` model with `has_secure_password`
- `Session` model for tracking sessions
- `SessionsController` for login/logout
- `PasswordsController` for password reset
- `Authentication` concern for `current_user` and `authenticate`

Use this instead of Devise for most applications. It's simpler, you own the code, and it follows Rails conventions.

### Session Security

```ruby
class SessionsController < ApplicationController
  def create
    user = User.authenticate_by(email: params[:email], password: params[:password])
    if user
      reset_session  # Prevent session fixation attacks
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
```

`reset_session` before setting session data is critical — it prevents session fixation attacks.

---

## Authorization

Rails doesn't include authorization out of the box. The simplest approach is query scoping:

```ruby
# ALWAYS scope queries to the current user
@projects = current_user.projects
@project = current_user.projects.find(params[:id])

# NEVER do this — any user can access any project
@project = Project.find(params[:id])
```

### Role-Based Authorization

```ruby
class ApplicationController < ActionController::Base
  private

  def authorize_admin!
    redirect_to root_path, alert: "Not authorized." unless current_user&.admin?
  end
end

class Admin::UsersController < ApplicationController
  before_action :authorize_admin!
end
```

### Resource-Level Authorization

```ruby
class ArticlesController < ApplicationController
  before_action :authorize_article!, only: %i[edit update destroy]

  private

  def authorize_article!
    redirect_to root_path, alert: "Not authorized." unless @article.author == current_user
  end
end
```

For complex authorization needs, consider the `pundit` gem — it's lightweight and follows Rails conventions.

---

## Parameter Safety

### Strong Parameters

```ruby
# Rails 8+ — use params.expect
def article_params
  params.expect(article: [:title, :body, :published, :category_id])
end

# Never permit all parameters
params.permit!  # NEVER DO THIS

# Never use params directly in mass assignment
Article.create(params[:article])  # NEVER DO THIS
```

### Guarding Against Parameter Tampering

```ruby
# Even with strong params, don't trust hidden fields for authorization
# BAD: User could tamper with the hidden user_id field
def create
  @article = Article.new(article_params)  # article_params includes user_id
end

# GOOD: Set sensitive attributes from the server
def create
  @article = current_user.articles.build(article_params)  # user comes from session
end
```

---

## SQL Injection Prevention

Active Record parameterizes queries by default. The danger is string interpolation:

```ruby
# SAFE — parameterized
User.where(email: params[:email])
User.where("email = ?", params[:email])
User.where("name ILIKE ?", "%#{User.sanitize_sql_like(params[:query])}%")

# DANGEROUS — string interpolation
User.where("email = '#{params[:email]}'")  # SQL INJECTION VULNERABILITY
User.where("name LIKE '%#{params[:query]}%'")  # SQL INJECTION VULNERABILITY

# SAFE — for LIKE queries, always sanitize
User.where("name ILIKE :query", query: "%#{User.sanitize_sql_like(params[:query])}%")
```

Use `sanitize_sql_like` when using LIKE/ILIKE to escape `%` and `_` in user input.

---

## XSS Prevention

### ERB Auto-Escaping

```erb
<%# SAFE — auto-escaped %>
<p><%= user.name %></p>  <%# <script>alert('xss')</script> becomes &lt;script&gt;... %>

<%# DANGEROUS — raw output %>
<p><%= raw user.bio %></p>  <%# Renders HTML directly — XSS risk %>
<p><%== user.bio %></p>     <%# Same as raw — XSS risk %>

<%# SAFE — when you need HTML but want sanitization %>
<p><%= sanitize user.bio, tags: %w[p br strong em a], attributes: %w[href] %></p>
```

### Content Tag Safety

```erb
<%# SAFE — tag helpers escape attributes %>
<%= tag.div user.name, class: "name" %>

<%# SAFE — link_to escapes content %>
<%= link_to user.name, user_path(user) %>
```

---

## CSRF Protection

Rails includes CSRF protection by default. Turbo handles CSRF tokens automatically for form submissions.

```ruby
# ApplicationController (default)
class ApplicationController < ActionController::Base
  # protect_from_forgery is enabled by default in Rails 8+
end

# For API controllers that use token auth instead
class Api::BaseController < ActionController::Base
  skip_forgery_protection  # Only for token-authenticated APIs
end
```

```erb
<%# In layout — required for Turbo %>
<%= csrf_meta_tags %>
```

---

## Content Security Policy

Configure CSP in the initializer to prevent XSS:

```ruby
# config/initializers/content_security_policy.rb
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src    :self, "https://fonts.gstatic.com"
    policy.img_src     :self, :data, "https:"
    policy.object_src  :none
    policy.script_src  :self
    policy.style_src   :self, "https://fonts.googleapis.com"
    policy.connect_src :self, "wss:"  # For Action Cable WebSocket

    # Report violations (recommended for monitoring)
    policy.report_uri "/csp-violation-report"
  end

  # Use nonces for inline scripts (Turbo compatible)
  config.content_security_policy_nonce_generator = ->(request) {
    request.session.id.to_s
  }
  config.content_security_policy_nonce_directives = %w[script-src style-src]
end
```

---

## Rate Limiting

Rails 8+ includes built-in rate limiting:

```ruby
class SessionsController < ApplicationController
  rate_limit to: 10, within: 3.minutes, only: :create,
    with: -> { redirect_to new_session_path, alert: "Try again in a few minutes." }
end

class PasswordsController < ApplicationController
  rate_limit to: 5, within: 1.hour, only: :create,
    with: -> { redirect_to new_password_path, alert: "Too many reset requests." }
end

class Api::BaseController < ApplicationController
  rate_limit to: 100, within: 1.minute,
    by: -> { request.remote_ip },
    with: -> { head :too_many_requests }
end
```

---

## Secrets Management

### Rails Credentials

```bash
# Edit credentials
EDITOR="code --wait" bin/rails credentials:edit

# Structure
secret_key_base: abc123...
database:
  password: db_password_here
smtp:
  username: mailer@example.com
  password: smtp_password

# Access in code
Rails.application.credentials.secret_key_base
Rails.application.credentials.dig(:database, :password)
```

### Environment-Specific Credentials

```bash
bin/rails credentials:edit --environment production
# Stored in config/credentials/production.yml.enc
# Key in config/credentials/production.key
```

### Never Commit

- `.env` files with secrets
- `config/credentials/*.key` files
- API keys or tokens in source code
- Database passwords in `database.yml`

These should be in `.gitignore` (Rails does this by default for key files).
