# Performance: Caching, Optimization & Deployment

## Table of Contents
1. [Caching Strategy](#caching-strategy)
2. [N+1 Query Prevention](#n1-query-prevention)
3. [Database Optimization](#database-optimization)
4. [Background Jobs](#background-jobs)
5. [Frontend Performance](#frontend-performance)
6. [Production Configuration](#production-configuration)

---

## Caching Strategy

### Fragment Caching

Cache view fragments based on the record's cache key (includes `updated_at`):

```erb
<%# app/views/articles/_article.html.erb %>
<% cache article do %>
  <article class="border-b py-4">
    <h2><%= link_to article.title, article %></h2>
    <p><%= article.author.name %></p>
    <p><%= truncate(article.body, length: 200) %></p>
  </article>
<% end %>
```

### Russian Doll Caching

Nest cached fragments. When inner content changes, only the inner cache busts:

```erb
<%# articles/index.html.erb %>
<% cache ["articles-list", @articles.maximum(:updated_at)] do %>
  <% @articles.each do |article| %>
    <% cache article do %>
      <%= render article %>
    <% end %>
  <% end %>
<% end %>
```

For this to work, child records must `touch` their parents:

```ruby
class Comment < ApplicationRecord
  belongs_to :article, touch: true  # Updates article.updated_at when comment changes
end
```

### Collection Caching

Rails can cache entire collections efficiently:

```erb
<%= render partial: "article", collection: @articles, cached: true %>
```

This issues a single multi-key cache read instead of N individual reads.

### Low-Level Caching

For expensive computations or external API calls:

```ruby
class Dashboard
  def stats
    Rails.cache.fetch("dashboard/stats", expires_in: 15.minutes) do
      {
        total_users: User.count,
        active_today: User.where(last_seen_at: Date.current..).count,
        revenue_mtd: Order.this_month.sum(:total)
      }
    end
  end
end
```

Cache IDs and reload, never cache Active Record objects:

```ruby
# GOOD
Rails.cache.fetch("featured_ids", expires_in: 1.hour) do
  Article.featured.pluck(:id)
end
# Then: Article.where(id: cached_ids)

# BAD — stale, serialization issues
Rails.cache.fetch("featured") { Article.featured.to_a }
```

### Conditional GET (ETags)

Avoid re-rendering when content hasn't changed:

```ruby
class ArticlesController < ApplicationController
  def show
    @article = Article.find(params[:id])
    fresh_when @article  # 304 Not Modified if article hasn't changed
  end

  def index
    @articles = Article.published.recent
    if stale?(etag: @articles, last_modified: @articles.maximum(:updated_at))
      render :index
    end
  end
end
```

### Cache Store: Solid Cache

This project uses Solid Cache (database-backed). It's the Rails 8 default — no Redis needed.

```ruby
# config/environments/production.rb
config.cache_store = :solid_cache_store
```

Solid Cache uses SSD storage, which is cheap and plentiful. FIFO eviction keeps the cache fresh.

---

## N+1 Query Prevention

### Detection

Enable strict loading in development to catch N+1 queries:

```ruby
# config/environments/development.rb
config.active_record.strict_loading_by_default = true
# Raises ActiveRecord::StrictLoadingViolationError on lazy loading
```

Or per-query:

```ruby
@articles = Article.strict_loading.includes(:author)
```

### Prevention Patterns

```ruby
# In controller — always include associations the view will access
def index
  @articles = Article.published
    .includes(:author, :category)   # Prevents N+1
    .order(published_at: :desc)
    .limit(20)
end

def show
  @article = Article.includes(:comments, comments: :author).find(params[:id])
end

# In model — default includes for common access patterns
class Article < ApplicationRecord
  scope :with_details, -> { includes(:author, :category, :tags) }
end
```

### includes vs preload vs eager_load

| Method | Strategy | When to use |
|--------|----------|-------------|
| `includes` | Rails chooses (usually preload) | Default choice |
| `preload` | Separate queries per association | When you don't filter on associated table |
| `eager_load` | Single LEFT OUTER JOIN | When filtering: `.where(authors: { active: true })` |

### Counter Cache

Avoid `COUNT(*)` queries for frequently displayed counts:

```ruby
# Migration
add_column :articles, :comments_count, :integer, default: 0, null: false

# Model
class Comment < ApplicationRecord
  belongs_to :article, counter_cache: true
end

# Now article.comments_count uses the cached column, not a COUNT query
```

---

## Database Optimization

### Indexing Strategy

```ruby
# Always index:
# 1. Foreign keys (Rails does this automatically with t.belongs_to)
# 2. Columns used in WHERE clauses
# 3. Columns used in ORDER BY
# 4. Columns with uniqueness constraints

add_index :articles, :slug, unique: true
add_index :articles, [:published, :published_at]  # Composite for common query
add_index :articles, :published_at, where: "published = true"  # Partial index
add_index :articles, :metadata, using: :gin  # GIN for JSONB
```

### Query Optimization

Do work in SQL, not Ruby. Pre-compute at write time when possible.

```ruby
# Bad — filtering in Ruby
User.all.select { |u| u.active? }

# Good — filtering in SQL
User.where(active: true)

# Use pluck when you only need specific values (avoids AR object instantiation)
User.where(active: true).pluck(:email)  # Returns ["a@b.com", "c@d.com"]

# Use select to limit columns loaded
User.select(:id, :name, :email).where(active: true)

# Use exists? instead of any?/present? for existence checks
User.where(email: params[:email]).exists?  # SELECT 1 ... LIMIT 1

# Use find_each for batch processing (not .each on large sets)
User.find_each(batch_size: 1000) { |user| process(user) }

# Use explain to analyze slow queries
Article.where(published: true).order(:created_at).explain

# Pre-compute at write time — counter caches, roll-ups, denormalized columns
# are faster reads than computing on every request
```

### PostgreSQL-Specific Optimizations

```ruby
# JSONB queries with GIN index
User.where("settings @> ?", { theme: "dark" }.to_json)

# Full-text search
Article.where("to_tsvector('english', title || ' ' || body) @@ plainto_tsquery('english', ?)", query)

# Upsert (insert or update — avoids race conditions)
User.upsert({ email: "a@b.com", name: "Alice" }, unique_by: :email)

# Insert all (bulk insert — much faster than individual creates)
Article.insert_all([
  { title: "First", body: "Content", created_at: Time.current, updated_at: Time.current },
  { title: "Second", body: "Content", created_at: Time.current, updated_at: Time.current }
])
```

---

## Background Jobs

### Active Job with Solid Queue

```ruby
# app/jobs/process_order_job.rb
class ProcessOrderJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: :polynomially_longer, attempts: 5
  discard_on ActiveRecord::RecordNotFound

  def perform(order)
    order.process!
    OrderMailer.confirmation(order).deliver_later
  end
end

# Enqueue
ProcessOrderJob.perform_later(order)
ProcessOrderJob.set(wait: 1.hour).perform_later(order)
ProcessOrderJob.set(queue: :critical).perform_later(order)
```

### Job Design Principles

- **Shallow jobs** — jobs delegate to model methods, they don't contain business logic
- **Idempotent** — safe to retry without side effects
- **Serializable args** — pass IDs or GlobalID, not complex objects
- **Bounded retries** — always set `retry_on` with `attempts:` limit
- **Transaction-safe** — set `enqueue_after_transaction_commit = true` to avoid enqueueing before the data is committed
- **Explicit timeouts** — always set timeouts on HTTP calls inside jobs

### What Belongs in Background Jobs

- Email delivery (`deliver_later`)
- File processing (image resizing, PDF generation)
- External API calls (payment processing, webhooks)
- Data exports and reports
- Cleanup tasks
- Anything that takes more than ~200ms

### Solid Queue Configuration

Solid Queue runs in Puma (no separate process needed in development):

```ruby
# config/environments/development.rb
config.solid_queue.connects_to = { database: { writing: :queue } }
```

---

## Frontend Performance

### Turbo Prefetching

Enabled by default since Turbo 8. Links are fetched on hover, saving 500-800ms per click.

```erb
<%# Disable for slow/expensive pages %>
<a href="/heavy-report" data-turbo-prefetch="false">Generate Report</a>
```

### Lazy-Loaded Frames

```erb
<%# Load sidebar content only when visible %>
<%= turbo_frame_tag "sidebar", src: sidebar_path, loading: :lazy do %>
  <div class="animate-pulse bg-gray-200 h-40 rounded"></div>
<% end %>
```

### Asset Optimization

Propshaft handles fingerprinting and cache headers. In production:

```ruby
# config/environments/production.rb
config.public_file_server.headers = {
  "Cache-Control" => "public, max-age=#{1.year.to_i}"
}
```

Thruster (included in the Gemfile) adds HTTP compression and caching in front of Puma.

---

## Production Configuration

### Puma Configuration

```ruby
# config/puma.rb
workers ENV.fetch("WEB_CONCURRENCY") { 2 }
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 3 }
threads threads_count, threads_count

preload_app!

# Solid Queue runs in Puma process
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]
```

### Kamal Deployment

This project deploys with Kamal (Docker + SSH):

```bash
kamal setup     # First deploy
kamal deploy    # Subsequent deploys
kamal rollback  # Roll back to previous version
```

### Key Production Settings

```ruby
# config/environments/production.rb
config.force_ssl = true
config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
config.active_record.dump_schema_after_migration = false

# Solid services
config.cache_store = :solid_cache_store
config.active_job.queue_adapter = :solid_queue
config.action_cable.adapter = :solid_cable
```

### Puma + Database Pool Tuning

Tune Puma workers/threads and database pool size together. The database pool must be >= the thread count:

```ruby
# config/puma.rb
workers ENV.fetch("WEB_CONCURRENCY") { 2 }
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 3 }
threads threads_count, threads_count

# config/database.yml
production:
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 3 } %>
```

Verify production-like performance before broad rollout. Measure queue latency and failure rates.
