# Active Record: Models, Associations, Queries & Migrations

## Table of Contents
1. [Naming Conventions](#naming-conventions)
2. [Associations](#associations)
3. [Validations](#validations)
4. [Callbacks](#callbacks)
5. [Scopes & Queries](#scopes--queries)
6. [Migrations](#migrations)
7. [Concerns](#concerns)
8. [Enums & Normalizations](#enums--normalizations)
9. [Anti-Patterns to Avoid](#anti-patterns-to-avoid)

---

## Naming Conventions

Active Record infers everything from names. Follow these precisely:

| Concept | Convention | Example |
|---------|-----------|---------|
| Model class | Singular CamelCase | `OrderItem` |
| Table name | Plural snake_case | `order_items` |
| Primary key | `id` (integer or bigint) | Auto-generated |
| Foreign key | `singularized_table_name_id` | `order_id` |
| Join table | Alphabetical, both pluralized | `categories_products` |
| Timestamps | `created_at`, `updated_at` | Auto-managed |
| STI column | `type` | Stores class name |
| Polymorphic | `_type` + `_id` | `imageable_type`, `imageable_id` |
| Counter cache | `pluralized_association_count` | `comments_count` |

---

## Associations

### belongs_to

Declares that this model holds the foreign key. Always singular.

```ruby
class Book < ApplicationRecord
  belongs_to :author                              # Standard
  belongs_to :publisher, optional: true           # Allow nil
  belongs_to :genre, counter_cache: true          # Maintain count on parent
  belongs_to :category, touch: true               # Update parent's updated_at
  belongs_to :writer, class_name: "Person"        # Custom class
  belongs_to :commentable, polymorphic: true       # Polymorphic
end
```

Since Rails 5, `belongs_to` validates presence by default. Use `optional: true` to allow nil.

Always declare explicit `dependent` behavior on `has_many` and `has_one`. Use `dependent: :delete_all` when callbacks are not needed (faster than `:destroy`).

### has_many

Declares one-to-many. Always plural.

```ruby
class Author < ApplicationRecord
  has_many :books, dependent: :destroy            # Cascading delete
  has_many :drafts, -> { where(published: false) }, class_name: "Book"
  has_many :recent_books, -> { order(created_at: :desc).limit(5) }, class_name: "Book"
end
```

**dependent options:**
- `:destroy` — calls destroy on each associated record (runs callbacks)
- `:delete_all` — deletes directly from database (skips callbacks, faster)
- `:destroy_async` — enqueues background job to destroy (Rails 7+)
- `:nullify` — sets foreign key to NULL

### has_many :through

The preferred way to model many-to-many. The join model can have its own attributes, validations, and callbacks.

```ruby
class Physician < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments
end

class Appointment < ApplicationRecord
  belongs_to :physician
  belongs_to :patient
  # Can have additional attributes: appointment_date, notes, etc.
end

class Patient < ApplicationRecord
  has_many :appointments
  has_many :physicians, through: :appointments
end
```

### has_one

```ruby
class Supplier < ApplicationRecord
  has_one :account, dependent: :destroy
  has_one :account_history, through: :account
end
```

### Polymorphic Associations

When a model can belong to more than one other model:

```ruby
class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
end

class Employee < ApplicationRecord
  has_many :pictures, as: :imageable
end

class Product < ApplicationRecord
  has_many :pictures, as: :imageable
end
```

Migration:
```ruby
create_table :pictures do |t|
  t.belongs_to :imageable, polymorphic: true, null: false
  t.timestamps
end
```

### Delegated Types

When STI becomes unwieldy because subclasses have different attributes, use delegated types (Rails 6.1+):

```ruby
class Entry < ApplicationRecord
  delegated_type :entryable, types: %w[Message Comment]
end

class Message < ApplicationRecord
  has_one :entry, as: :entryable, touch: true
end
```

### Self-Referential Associations

```ruby
class Employee < ApplicationRecord
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"
  belongs_to :manager, class_name: "Employee", optional: true
end
```

---

## Validations

Validate at the model level for business rules. Constrain at the database level for data integrity. Both.

```ruby
class User < ApplicationRecord
  # Presence
  validates :email, presence: true
  validates :name, presence: true

  # Uniqueness (always add a database unique index too)
  validates :email, uniqueness: { case_sensitive: false }

  # Format
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Length
  validates :bio, length: { maximum: 500 }
  validates :password, length: { minimum: 8 }

  # Numericality
  validates :age, numericality: { greater_than: 0, only_integer: true }, allow_nil: true

  # Inclusion
  validates :role, inclusion: { in: %w[admin member guest] }

  # Custom
  validate :email_domain_allowed

  private

  def email_domain_allowed
    return if email.blank?
    domain = email.split("@").last
    errors.add(:email, "domain not allowed") unless allowed_domains.include?(domain)
  end
end
```

### Conditional Validations

```ruby
validates :card_number, presence: true, if: :paid_with_card?
validates :terms, acceptance: true, on: :create
```

---

## Callbacks

Use callbacks sparingly. They create implicit behavior that's hard to trace. Prefer explicit service objects for complex workflows.

**Good uses:**
```ruby
class User < ApplicationRecord
  # Normalizing data before save
  normalizes :email, with: ->(email) { email.strip.downcase }

  # Generating tokens
  has_secure_token :api_key

  # Setting defaults via lambda
  attribute :role, default: -> { "member" }
  attribute :creator, default: -> { Current.user }

  # Or via after_initialize
  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.locale ||= "en"
  end
end
```

**Avoid:** Callbacks that send emails, enqueue jobs, or modify other models. Use `after_commit` if you must, or better — do it explicitly in the model's public API.

### Callback Order

`before_validation` → `after_validation` → `before_save` → `before_create`/`before_update` → `after_create`/`after_update` → `after_save` → `after_commit`

---

## Scopes & Queries

### Scopes

Scopes are chainable, reusable query fragments. Prefer scopes over class methods for query logic. Name scopes for business concepts, not SQL operations:

```ruby
class Article < ApplicationRecord
  # Good — business concepts
  scope :published, -> { where(published: true) }
  scope :recent, -> { order(published_at: :desc) }
  scope :by_author, ->(author) { where(author: author) }
  scope :featured, -> { published.where(featured: true).recent }
  scope :active, -> { where.missing(:pop) }
  scope :unassigned, -> { where.missing(:assignments) }

  # Bad — SQL operations as names
  # scope :without_pop, -> { ... }
  # scope :no_assignments, -> { ... }

  # With date logic
  scope :this_week, -> { where(created_at: 1.week.ago..) }
  scope :archived, -> { where(archived_at: ...Time.current) }
end

# Chain them: Article.published.recent.by_author(current_user)
```

### Query Interface

```ruby
# Finding
User.find(1)                          # Raises RecordNotFound
User.find_by(email: "a@b.com")       # Returns nil if not found
User.where(active: true)             # Returns Relation
User.where.not(role: "admin")        # NOT
User.where(age: 18..65)              # Range (BETWEEN)
User.where(age: 18..)               # Endless range (>=)
User.where(status: [:active, :pending])  # IN

# Ordering
User.order(created_at: :desc)
User.order(:last_name, :first_name)

# Limiting
User.limit(10).offset(20)

# Selecting
User.select(:id, :name, :email)
User.pluck(:email)                    # Returns array of values, no AR objects
User.pick(:email)                     # Single value

# Aggregations
Order.count
Order.sum(:total)
Order.average(:total)
Order.group(:status).count            # { "pending" => 5, "shipped" => 12 }

# Existence
User.exists?(email: "a@b.com")       # Efficient boolean check
User.any?
User.none?
```

### Preventing N+1 Queries

This is critical. An N+1 query loads an association for each record individually instead of batching.

```ruby
# BAD: N+1 — 1 query for books, then 1 query per book for author
@books = Book.all
@books.each { |book| book.author.name }

# GOOD: Eager loading — 2 queries total
@books = Book.includes(:author)

# GOOD: When you need to filter on the association
@books = Book.joins(:author).where(authors: { active: true })

# GOOD: When you need both filtering AND eager loading
@books = Book.includes(:author).where(authors: { active: true }).references(:authors)

# Catch N+1 in development:
# In ApplicationRecord:
self.strict_loading_by_default = true  # Raises error on lazy loading
```

**includes vs preload vs eager_load:**
- `includes` — Rails chooses the best strategy (usually separate queries)
- `preload` — always separate queries (1 per association)
- `eager_load` — always LEFT OUTER JOIN (single query)

### Batch Processing

For processing large datasets without loading everything into memory:

```ruby
User.find_each(batch_size: 1000) do |user|
  user.send_newsletter
end

User.where(active: true).find_in_batches(batch_size: 500) do |group|
  group.each { |user| process(user) }
end
```

---

## Migrations

Migrations are version-controlled database changes. They should be reversible.

```ruby
class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.belongs_to :category, null: false, foreign_key: true
      t.integer :stock_count, default: 0, null: false
      t.boolean :active, default: true, null: false
      t.jsonb :metadata, default: {}
      t.timestamps
    end

    add_index :products, :name
    add_index :products, [:category_id, :active]
    add_index :products, :metadata, using: :gin
  end
end
```

### Migration Best Practices

- Always add `null: false` where the column should never be null
- Always add `foreign_key: true` on belongs_to references
- Add database indexes on: foreign keys, columns used in WHERE/ORDER, unique constraints
- Use `t.belongs_to` (not `t.integer` + `add_index`) for foreign keys
- For renaming columns/tables, use the dedicated `rename_column`/`rename_table` methods
- Never modify data in schema migrations — use a separate data migration or rake task
- Add `default:` values when a column should never be nil but existing records need a value

### PostgreSQL-Specific Migrations

```ruby
# JSONB column with GIN index
t.jsonb :settings, default: {}, null: false
add_index :users, :settings, using: :gin

# Array column
t.string :tags, array: true, default: []
add_index :users, :tags, using: :gin

# Check constraint
add_check_constraint :products, "price > 0", name: "price_positive"

# Exclusion constraint (e.g., no overlapping date ranges)
execute <<-SQL
  ALTER TABLE reservations
  ADD CONSTRAINT no_overlapping_reservations
  EXCLUDE USING gist (room_id WITH =, daterange(start_date, end_date) WITH &&);
SQL

# Partial index
add_index :orders, :created_at, where: "status = 'pending'", name: "index_pending_orders"

# Generated column
execute <<-SQL
  ALTER TABLE users
  ADD COLUMN full_name text GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED;
SQL
```

---

## Concerns

Use concerns to extract cohesive chunks of behavior from models that grow large. Each concern should be 50-150 lines, self-contained, and named for the capability it provides (`Closeable`, `Watchable`, `Searchable`). Extract when the same behavior appears across 3+ models.

```ruby
# app/models/concerns/searchable.rb
module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search, ->(query) {
      where("name ILIKE :q OR description ILIKE :q", q: "%#{sanitize_sql_like(query)}%")
    }
  end

  class_methods do
    def full_text_search(query)
      where("to_tsvector('english', name || ' ' || coalesce(description, '')) @@ plainto_tsquery('english', ?)", query)
    end
  end
end

# app/models/product.rb
class Product < ApplicationRecord
  include Searchable
end
```

---

## Enums & Normalizations

### Enums (Rails 8+)

```ruby
class Order < ApplicationRecord
  enum :status, {
    pending: "pending",
    processing: "processing",
    shipped: "shipped",
    delivered: "delivered",
    cancelled: "cancelled"
  }
  # Generates: Order.pending, order.pending?, order.pending!
  # Also: Order.statuses hash
end
```

Prefer string-backed enums over integer-backed — they're readable in the database and don't break when you reorder.

### Normalizations (Rails 7.1+)

```ruby
class User < ApplicationRecord
  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :phone, with: ->(phone) { phone.gsub(/\D/, "") }
  normalizes :name, with: ->(name) { name.strip }
end
```

Normalizations run before validation and on finder methods — `User.find_by(email: " FOO@BAR.COM ")` works correctly.

---

## State as Records

Prefer state records over boolean columns. A `Closure` record captures who, when, and why. A `closed` boolean captures nothing.

```ruby
module Card::Closeable
  extend ActiveSupport::Concern

  included do
    has_one :closure, dependent: :destroy
    scope :closed, -> { joins(:closure) }
    scope :open, -> { where.missing(:closure) }
  end

  def closed? = closure.present?

  def close(user: Current.user)
    return if closed?
    transaction do
      create_closure!(user: user)
      track_event(:closed, creator: user)
    end
  end

  def reopen(user: Current.user)
    return unless closed?
    transaction do
      closure&.destroy
      track_event(:reopened, creator: user)
    end
  end
end
```

---

## POROs Under Model Namespaces

POROs live under model namespaces for related logic that does not need persistence. They are model-adjacent, not controller-adjacent.

```ruby
# app/models/event/description.rb
class Event::Description
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def to_s
    case event.action
    when "created"  then "#{creator_name} created this card"
    when "closed"   then "#{creator_name} closed this card"
    else "#{creator_name} updated this card"
    end
  end

  private
    def creator_name = event.creator.name
end
```

Do not use `*Service`, `*Manager`, or `*Handler` suffixes. Use domain nouns. Decision heuristic: start with a model method, then a concern (3+ models), then a PORO with a domain noun.

---

## Job Naming Convention

When a model method enqueues a job that calls back into the same class, use `_later` for the async version and `_now` for the synchronous version:

```ruby
module Event::Relaying
  extend ActiveSupport::Concern

  included do
    after_create_commit :relay_later
  end

  def relay_later
    Event::RelayJob.perform_later(self)
  end

  def relay_now
    # actual work
  end
end

class Event::RelayJob < ApplicationJob
  def perform(event)
    event.relay_now
  end
end
```

Jobs should be shallow -- they delegate to model methods, not contain business logic.

---

## Anti-Patterns to Avoid

1. **God Models** — If a model exceeds ~200 lines, decompose with concerns
2. **Callback Hell** — Chains of callbacks that trigger other callbacks. Prefer explicit orchestration
3. **N+1 in Views** — Always eager-load associations the view will access
4. **Missing Database Constraints** — Model validations can be bypassed. Critical constraints belong in the database. Prefer database constraints over AR validations for data integrity
5. **Integer Enums** — One accidental reorder breaks everything. Use strings
6. **Skip-Validation Methods** — `update_column`, `update_all`, `delete` bypass validations and callbacks. Use them only when you explicitly need to skip them and understand the consequences
7. **Business Logic in Callbacks** — Sending emails, creating audit logs, or modifying other models in `after_save` is fragile. Do it explicitly
8. **Overusing STI** — If subclasses have very different columns, use delegated types or separate tables
9. **Boolean State Columns** — Use state-as-records instead (see above)
10. **Silent Failures** — Use `save!`, `create!`, `update!` in jobs and POROs. Use `find_by!` and `fetch` when nil is unexpected
