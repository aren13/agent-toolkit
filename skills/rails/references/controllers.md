# Controllers, Routing & Request Handling

## Table of Contents
1. [RESTful Controller Design](#restful-controller-design)
2. [Strong Parameters](#strong-parameters)
3. [Routing](#routing)
4. [Filters & Callbacks](#filters--callbacks)
5. [Flash & Session](#flash--session)
6. [Responding to Formats](#responding-to-formats)
7. [Error Handling](#error-handling)
8. [Controller Patterns](#controller-patterns)

---

## RESTful Controller Design

Every controller maps to a resource. Stick to the 7 standard actions:

```ruby
class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  def index
    @articles = Article.published.recent.includes(:author)
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to @article, notice: "Article created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy!
    redirect_to articles_path, notice: "Article deleted."
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.expect(article: [:title, :body, :published])
  end
end
```

### Beyond 7 Actions: Model Verbs as Noun Resources

When an action doesn't map to a standard CRUD verb, turn the verb into a noun and create a new resource:

| Verb | Noun Resource | Route |
|------|--------------|-------|
| close | closure | `resource :closure` |
| publish | publication | `resource :publication` |
| watch | watching | `resource :watching` |
| pin | pin | `resource :pin` |

```ruby
# Bad
resources :cards do
  post :close
  post :reopen
end

# Good
resources :cards do
  resource :closure      # POST to close, DELETE to reopen
end

# config/routes.rb
resources :articles do
  resource :publication, only: [:create, :destroy], module: :articles
end

# app/controllers/articles/publications_controller.rb
module Articles
  class PublicationsController < ApplicationController
    def create
      @article = Article.find(params[:article_id])
      @article.publish!
      redirect_to @article, notice: "Article published."
    end

    def destroy
      @article = Article.find(params[:article_id])
      @article.unpublish!
      redirect_to @article, notice: "Article unpublished."
    end
  end
end
```

Thin controllers invoke rich domain models directly. No service layer between them.

---

## Strong Parameters

Always use `params.expect` (Rails 8+) for mass assignment protection. Unlike `params.require`/`permit`, `params.expect` returns 400 (Bad Request) for malformed params instead of 500 (Internal Server Error):

```ruby
# Simple
def user_params
  params.expect(user: [:name, :email, :bio])
end

# Nested attributes
def order_params
  params.expect(order: [:customer_id, :notes, line_items_attributes: [[:product_id, :quantity]]])
end

# Array parameters
def filter_params
  params.expect(filter: [:query, status: []])
end
```

Never use `params.permit!` — it allows any parameter through, defeating the purpose of strong parameters.

---

## Routing

### Resource Routes

```ruby
Rails.application.routes.draw do
  # Full CRUD
  resources :articles

  # Limited actions
  resources :articles, only: %i[index show]

  # Singular resource (no index, no :id in URL)
  resource :profile, only: %i[show edit update]

  # Nested resources (limit to 1 level deep)
  resources :articles do
    resources :comments, only: %i[create destroy]
  end

  # Shallow nesting — collection actions nested, member actions at root
  resources :articles, shallow: true do
    resources :comments
  end

  # Namespaced controllers
  namespace :admin do
    resources :articles  # Admin::ArticlesController, /admin/articles
  end

  # Scoped URL without module
  scope "/admin" do
    resources :articles  # ArticlesController, /admin/articles
  end

  # Member and collection routes
  resources :photos do
    member do
      get :preview    # /photos/:id/preview
      post :approve   # /photos/:id/approve
    end
    collection do
      get :search     # /photos/search
    end
  end

  # Routing concerns (shared patterns)
  concern :commentable do
    resources :comments, only: %i[create destroy]
  end

  resources :articles, concerns: :commentable
  resources :photos, concerns: :commentable

  # Root route
  root "pages#home"
end
```

### Route Best Practices

- Prefer `resources` over custom routes — the 7 RESTful actions cover most needs
- Nest resources maximum 1 level deep — use `shallow: true` beyond that
- Use `only:` to limit generated routes to those you actually implement
- Put the most specific routes first — Rails matches top-down
- Use `constraints` for route validation (e.g., `id: /\d+/`)
- Organize large route files with `draw(:admin)` to split into `config/routes/admin.rb`

---

## Filters & Callbacks

```ruby
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale

  around_action :set_time_zone, if: :current_user

  private

  def authenticate_user!
    redirect_to login_path unless current_user
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end

class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_article, only: %i[show edit update destroy]
  before_action :authorize_article!, only: %i[edit update destroy]
end
```

---

## Flash & Session

```ruby
# Flash messages (persist across one redirect)
redirect_to articles_path, notice: "Success!"     # flash[:notice]
redirect_to articles_path, alert: "Denied!"        # flash[:alert]

# Flash for current request only (render, not redirect)
flash.now[:error] = "Validation failed."
render :new, status: :unprocessable_entity

# Session (server-side, encrypted cookie)
session[:cart_id] = cart.id
cart = Cart.find(session[:cart_id])
reset_session  # Clear everything (do this after login!)
```

---

## Responding to Formats

```ruby
class ArticlesController < ApplicationController
  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      respond_to do |format|
        format.html { redirect_to @article, notice: "Created." }
        format.turbo_stream  # Renders create.turbo_stream.erb
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy!
    respond_to do |format|
      format.html { redirect_to articles_path, notice: "Deleted." }
      format.turbo_stream  # Renders destroy.turbo_stream.erb
    end
  end
end
```

---

## Error Handling

### rescue_from

```ruby
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::Forbidden, with: :forbidden

  private

  def not_found
    render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
  end

  def forbidden
    redirect_to root_path, alert: "Access denied."
  end
end
```

### Rate Limiting (Rails 8+)

```ruby
class SessionsController < ApplicationController
  rate_limit to: 10, within: 3.minutes, only: :create,
    with: -> { redirect_to new_session_path, alert: "Too many attempts. Try again later." }
end
```

---

## Controller Patterns

### Current Attributes

Use `Current` for request-scoped state instead of thread-local variables:

```ruby
# app/models/current.rb
class Current < ActiveSupport::CurrentAttributes
  attribute :user, :request_id, :ip_address
end

# Set in ApplicationController
class ApplicationController < ActionController::Base
  before_action :set_current_attributes

  private

  def set_current_attributes
    Current.user = current_user
    Current.request_id = request.request_id
    Current.ip_address = request.remote_ip
  end
end

# Access anywhere in the request cycle
Current.user
```

### No Query Logic in Controllers

Push `.where`, `.order`, `.joins` into model scopes. Controllers orchestrate, they don't query:

```ruby
# Bad — query logic in controller
def index
  @articles = Article.where(published: true).order(created_at: :desc).joins(:author)
end

# Good — model scope
def index
  @articles = Article.published.recent.includes(:author)
end
```

Never store Active Record objects in sessions -- store IDs and reload.

### Scoping Queries to Current User

Always scope data access through the authenticated user:

```ruby
# GOOD — scoped to user
@project = current_user.projects.find(params[:id])

# BAD — any user can access any project
@project = Project.find(params[:id])
```

### Authorization Pattern

Controller checks permission via `before_action`. Model defines what permission means:

```ruby
class CardsController < ApplicationController
  before_action :authorize_card!, only: %i[edit update destroy]

  private

  def authorize_card!
    redirect_to root_path, alert: "Not authorized." unless @card.administerable_by?(current_user)
  end
end

class Card < ApplicationRecord
  def administerable_by?(user)
    user.admin? || creator == user
  end
end
```

### Controller Concerns

Extract shared behavior into concerns:

```ruby
# app/controllers/concerns/paginatable.rb
module Paginatable
  extend ActiveSupport::Concern

  private

  def page
    (params[:page] || 1).to_i
  end

  def per_page
    [(params[:per_page] || 25).to_i, 100].min
  end
end
```
