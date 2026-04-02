# Views: ERB, Layouts, Partials & Helpers

## Table of Contents
1. [Layout Structure](#layout-structure)
2. [Rendering Conventions](#rendering-conventions)
3. [Partials](#partials)
4. [Helpers](#helpers)
5. [Forms](#forms)
6. [Content Organization](#content-organization)
7. [Turbo Frame & Stream Views](#turbo-frame--stream-views)

---

## Layout Structure

### Application Layout

```erb
<%# app/views/layouts/application.html.erb %>
<!DOCTYPE html>
<html lang="<%= I18n.locale %>">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><%= content_for(:title) || "FMS" %></title>
  <meta name="turbo-prefetch" content="true">
  <%= csrf_meta_tags %>
  <%= csp_meta_tag %>
  <%= yield :head %>
  <%= stylesheet_link_tag "tailwind", "inter-font", "data-turbo-track": "reload" %>
  <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
  <%= javascript_importmap_tags %>
</head>
<body class="min-h-screen bg-white dark:bg-gray-950">
  <%= render "shared/flash" %>
  <%= render "shared/navbar" if current_user %>
  <main class="container mx-auto px-4 py-8">
    <%= yield %>
  </main>
</body>
</html>
```

### Content Regions

Use `content_for` to inject page-specific content into layouts:

```erb
<%# In a view %>
<% content_for :title, "Dashboard" %>

<% content_for :head do %>
  <meta name="description" content="Your dashboard">
<% end %>
```

---

## Rendering Conventions

Rails renders views by convention. `ArticlesController#index` renders `app/views/articles/index.html.erb` automatically. Don't call `render` unless you need to override the default.

```ruby
# These are equivalent — prefer the implicit version
def show
  @article = Article.find(params[:id])
  # Rails automatically renders app/views/articles/show.html.erb
end

# Explicit render (only when needed)
def create
  @article = Article.new(article_params)
  if @article.save
    redirect_to @article
  else
    render :new, status: :unprocessable_entity  # Re-render form with errors
  end
end
```

### Status Codes That Matter

- `render :new, status: :unprocessable_entity` — Turbo requires 422 to re-render forms on validation failure
- `redirect_to @article, status: :see_other` — 303 for redirects after non-GET (Turbo handles this automatically)
- `head :no_content` — 204 for actions that don't need a body

---

## Partials

Partials are the component system in Rails. They're files prefixed with `_` but referenced without the prefix.

### Basic Partial

```erb
<%# app/views/articles/_article.html.erb %>
<article id="<%= dom_id(article) %>" class="border-b py-4">
  <h2 class="text-xl font-semibold"><%= link_to article.title, article %></h2>
  <p class="text-gray-600 text-sm"><%= article.author.name %> · <%= time_ago_in_words(article.created_at) %> ago</p>
  <p class="mt-2"><%= truncate(article.body, length: 200) %></p>
</article>
```

### Rendering Partials

```erb
<%# Single partial with locals %>
<%= render "form", article: @article %>

<%# Collection rendering (fastest — Rails optimizes this) %>
<%= render partial: "article", collection: @articles %>

<%# Shorthand collection (when partial name matches model) %>
<%= render @articles %>

<%# With spacer template between items %>
<%= render partial: "article", collection: @articles, spacer_template: "article_divider" %>

<%# Empty state %>
<%= render(@articles) || render("empty_state") %>
```

### Partial Locals

Always pass data to partials via locals, not instance variables:

```erb
<%# GOOD — explicit dependencies %>
<%= render "sidebar", user: current_user, notifications: @notifications %>

<%# BAD — implicit coupling to controller %>
<%= render "sidebar" %>  <%# relies on @user and @notifications existing %>
```

### Shared Partials

Put cross-controller partials in `app/views/shared/`:

```erb
<%# app/views/shared/_flash.html.erb %>
<% flash.each do |type, message| %>
  <div class="<%= flash_class(type) %> px-4 py-3 rounded mb-4" role="alert"
       data-controller="dismissible"
       data-action="click->dismissible#dismiss animationend->dismissible#remove">
    <p><%= message %></p>
  </div>
<% end %>
```

---

## Helpers

Helpers contain view formatting logic. Keep them focused on presentation — no business logic.

```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  def page_title(title = nil)
    base = "FMS"
    title.present? ? "#{title} — #{base}" : base
  end

  def flash_class(type)
    case type.to_sym
    when :notice then "bg-green-50 text-green-800 border border-green-200"
    when :alert  then "bg-red-50 text-red-800 border border-red-200"
    else "bg-blue-50 text-blue-800 border border-blue-200"
    end
  end

  def status_badge(status)
    colors = {
      "active"   => "bg-green-100 text-green-800",
      "pending"  => "bg-yellow-100 text-yellow-800",
      "inactive" => "bg-gray-100 text-gray-800"
    }
    tag.span status.humanize, class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{colors[status]}"
  end

  def time_ago_tag(time)
    tag.time time_ago_in_words(time) + " ago",
      datetime: time.iso8601,
      title: l(time, format: :long)
  end
end
```

---

## Forms

### Standard Form

```erb
<%= form_with model: @article, class: "space-y-6" do |f| %>
  <% if @article.errors.any? %>
    <div class="bg-red-50 border border-red-200 rounded-lg p-4">
      <h3 class="text-red-800 font-medium">Please fix the following errors:</h3>
      <ul class="mt-2 list-disc list-inside text-red-700 text-sm">
        <% @article.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div>
    <%= f.label :title, class: "block text-sm font-medium text-gray-700" %>
    <%= f.text_field :title, class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" %>
  </div>

  <div>
    <%= f.label :body, class: "block text-sm font-medium text-gray-700" %>
    <%= f.text_area :body, rows: 8, class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" %>
  </div>

  <div>
    <%= f.label :category_id, class: "block text-sm font-medium text-gray-700" %>
    <%= f.collection_select :category_id, Category.order(:name), :id, :name,
        { prompt: "Select a category" },
        { class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm" } %>
  </div>

  <div class="flex items-center gap-4">
    <%= f.submit class: "bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 cursor-pointer" %>
    <%= link_to "Cancel", articles_path, class: "text-gray-600 hover:text-gray-800" %>
  </div>
<% end %>
```

### Nested Forms

```erb
<%= form_with model: @order do |f| %>
  <%= f.fields_for :line_items do |li| %>
    <div class="flex gap-4">
      <%= li.collection_select :product_id, Product.order(:name), :id, :name %>
      <%= li.number_field :quantity, min: 1, class: "w-20" %>
    </div>
  <% end %>
  <%= f.submit %>
<% end %>
```

Model setup for nested forms:
```ruby
class Order < ApplicationRecord
  has_many :line_items
  accepts_nested_attributes_for :line_items, reject_if: :all_blank, allow_destroy: true
end
```

---

## Content Organization

### dom_id Helper

Use `dom_id` to generate consistent DOM IDs for records:

```erb
<article id="<%= dom_id(article) %>">  <%# Generates "article_42" %>
```

This is critical for Turbo Streams to target the right elements.

### View Hierarchy

```
app/views/
├── layouts/
│   ├── application.html.erb      # Main layout
│   ├── mailer.html.erb           # Email layout
│   └── admin.html.erb            # Admin-specific layout (optional)
├── shared/
│   ├── _flash.html.erb           # Flash messages
│   ├── _navbar.html.erb          # Navigation
│   ├── _footer.html.erb          # Footer
│   ├── _pagination.html.erb      # Pagination controls
│   └── _empty_state.html.erb     # Empty collection state
├── articles/
│   ├── index.html.erb
│   ├── show.html.erb
│   ├── new.html.erb
│   ├── edit.html.erb
│   ├── _article.html.erb         # Single article partial
│   ├── _form.html.erb            # Shared form partial
│   ├── create.turbo_stream.erb   # Turbo Stream response
│   └── destroy.turbo_stream.erb  # Turbo Stream response
```

---

## Turbo Frame & Stream Views

### Turbo Frame in Views

```erb
<%# articles/index.html.erb %>
<%= turbo_frame_tag "articles" do %>
  <div class="space-y-4">
    <%= render @articles %>
  </div>
  <%# Pagination links stay inside the frame %>
  <%= render "shared/pagination", collection: @articles %>
<% end %>
```

### Turbo Stream Responses

```erb
<%# articles/create.turbo_stream.erb %>
<%= turbo_stream.prepend "articles", @article %>
<%= turbo_stream.update "article_count", Article.count %>
<%= turbo_stream.update "flash", partial: "shared/flash" %>

<%# articles/destroy.turbo_stream.erb %>
<%= turbo_stream.remove @article %>
<%= turbo_stream.update "article_count", Article.count %>
```

### Inline Turbo Streams in Controller

For simple cases, skip the template:

```ruby
def create
  @article = current_user.articles.build(article_params)
  if @article.save
    respond_to do |format|
      format.html { redirect_to @article }
      format.turbo_stream {
        render turbo_stream: turbo_stream.prepend("articles", @article)
      }
    end
  else
    render :new, status: :unprocessable_entity
  end
end
```
