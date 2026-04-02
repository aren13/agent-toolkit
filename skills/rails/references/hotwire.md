# Hotwire: Turbo & Stimulus Patterns

## Table of Contents
1. [Philosophy](#philosophy)
2. [Turbo Drive](#turbo-drive)
3. [Turbo Frames](#turbo-frames)
4. [Turbo Streams](#turbo-streams)
5. [Stimulus Controllers](#stimulus-controllers)
6. [Turbo + Stimulus Together](#turbo--stimulus-together)
7. [Action Cable Integration](#action-cable-integration)
8. [Common Patterns](#common-patterns)

---

## Philosophy

Hotwire sends **HTML over the wire** instead of JSON. The server renders HTML, sends it to the browser, and Turbo handles the DOM updates. This means:

- Application logic stays on the server (Ruby, not JavaScript)
- Views are rendered once (ERB), not twice (API + JS template)
- JavaScript is only for behavior that Turbo can't handle (~20% of cases)
- Progressive enhancement: features work without JS, then get enhanced

**The hierarchy:** Turbo Drive (free) → Turbo Frames (scoped updates) → Turbo Streams (surgical updates) → Stimulus (custom behavior)

---

## Turbo Drive

Turbo Drive intercepts all link clicks and form submissions, fetching the new page via AJAX and swapping the `<body>` while merging `<head>`. Zero configuration needed.

### What You Get for Free

- Fast navigation without full page reloads
- Automatic prefetching on hover (500-800ms perceived speedup)
- Progress bar for slow loads
- Form submission handling with proper redirects
- Asset change detection and full reload when needed

### Configuration

```erb
<%# In layout head %>
<meta name="turbo-prefetch" content="true">  <%# Enabled by default since Turbo 8 %>
<meta name="turbo-refresh-method" content="morph">  <%# Smart diff-based page updates %>
<meta name="turbo-refresh-scroll" content="preserve">  <%# Keep scroll position on refresh %>
```

### Persistent Elements

Use `data-turbo-permanent` on elements that should survive across page navigations (audio players, chat widgets, notification badges):

```erb
<div id="audio-player" data-turbo-permanent>
  <%# This element persists across Turbo navigations %>
</div>
```

### Controlling Turbo Drive

```erb
<%# Disable Turbo on a link %>
<a href="/external" data-turbo="false">External Link</a>

<%# Disable for an entire section %>
<div data-turbo="false">
  <%# All links and forms here bypass Turbo %>
</div>

<%# Force full reload when visiting this page %>
<meta name="turbo-visit-control" content="reload">

<%# Non-GET method on a link %>
<%= link_to "Delete", article_path(@article), data: { turbo_method: :delete, turbo_confirm: "Are you sure?" } %>
```

### Form Submission Flow

1. User submits form → Turbo sends POST/PATCH/DELETE
2. **Success:** Server responds with 303 redirect → Turbo follows it (GET) → replaces page
3. **Validation error:** Server responds with 422 + re-rendered form → Turbo replaces page
4. **Turbo Stream:** Server responds with `text/vnd.turbo-stream.html` → Turbo applies stream actions

The 422 status is critical — Turbo needs it to know the form should be re-rendered, not treated as a redirect.

---

## Turbo Frames

Frames scope navigation to a specific region of the page. Links and forms inside a frame only update that frame.

### Basic Frame

```erb
<%# articles/index.html.erb %>
<%= turbo_frame_tag "articles_list" do %>
  <% @articles.each do |article| %>
    <%= render article %>
  <% end %>
  <%# Pagination links navigate within this frame %>
  <%= link_to "Next", articles_path(page: @page + 1) %>
<% end %>
```

The server response must contain a matching `<turbo-frame id="articles_list">`. Turbo extracts just that frame and swaps it.

### Lazy Loading

```erb
<%# Load content only when the frame becomes visible %>
<%= turbo_frame_tag "notifications", src: notifications_path, loading: :lazy do %>
  <p class="text-gray-500">Loading notifications...</p>
<% end %>
```

### Eager Loading

```erb
<%# Load immediately after page renders %>
<%= turbo_frame_tag "weather", src: weather_path do %>
  <div class="animate-pulse bg-gray-200 h-20 rounded"></div>
<% end %>
```

### Breaking Out of Frames

```erb
<%# Inside a frame, but this link should navigate the whole page %>
<%= link_to "View Full Article", article_path(@article), data: { turbo_frame: "_top" } %>

<%# Or set it on the frame itself %>
<%= turbo_frame_tag "articles", target: "_top" do %>
  <%# All links here navigate full page by default %>
<% end %>
```

### Targeting Another Frame

```erb
<%# A link in one frame can update a different frame %>
<%= link_to article.title, article_path(article), data: { turbo_frame: "article_detail" } %>

<%# The target frame elsewhere on the page %>
<%= turbo_frame_tag "article_detail" do %>
  <p>Select an article to view details.</p>
<% end %>
```

### Frame with URL Update

```erb
<%# Push frame navigation to the browser URL bar %>
<%= turbo_frame_tag "articles", data: { turbo_action: "advance" } do %>
  <%# Navigation updates the URL, enabling back/forward %>
<% end %>
```

### When to Use Frames

- Inline editing (click "Edit" → form replaces content → submit → content returns)
- Tabbed interfaces (each tab loads a different frame)
- Pagination within a section
- Search/filter results
- Lazy-loaded sidebar content
- Modal content loaded from server

### When NOT to Use Frames

- When you need to update multiple unrelated parts of the page → use Turbo Streams
- When the entire page changes → let Turbo Drive handle it
- When you need complex JavaScript interactivity → use Stimulus

---

## Turbo Streams

Streams deliver surgical DOM updates. They can update multiple elements anywhere on the page, unlike Frames which are scoped to one region.

### The 8 Actions

```erb
<%# Append to end of target's children %>
<%= turbo_stream.append "messages", @message %>

<%# Prepend to beginning %>
<%= turbo_stream.prepend "messages", @message %>

<%# Replace entire element (including the target itself) %>
<%= turbo_stream.replace @message %>

<%# Update inner HTML only (preserves the target element and its event listeners) %>
<%= turbo_stream.update @message %>

<%# Remove element %>
<%= turbo_stream.remove @message %>

<%# Insert before target %>
<%= turbo_stream.before @message, partial: "messages/message", locals: { message: @message } %>

<%# Insert after target %>
<%= turbo_stream.after @message, partial: "messages/message", locals: { message: @message } %>

<%# Morph (smart diff-based update) %>
<%= turbo_stream.morph @message %>
```

### Stream Response Templates

```erb
<%# app/views/messages/create.turbo_stream.erb %>
<%= turbo_stream.append "messages", @message %>
<%= turbo_stream.update "message_count" do %>
  <%= @messages_count %> messages
<% end %>
<%= turbo_stream.replace "new_message_form" do %>
  <%= render "form", message: Message.new %>
<% end %>
```

### Targeting by CSS Selector

```erb
<%# Target all elements matching a CSS selector %>
<%= turbo_stream.remove_all ".notification.read" %>
<%= turbo_stream.update_all ".unread-count" do %>
  0
<% end %>
```

### Broadcasting Streams (Real-time via Action Cable)

```ruby
# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :room
  after_create_commit -> { broadcast_append_to room, target: "messages" }
  after_update_commit -> { broadcast_replace_to room }
  after_destroy_commit -> { broadcast_remove_to room }
end
```

```erb
<%# In the view, subscribe to the stream %>
<%= turbo_stream_from @room %>

<div id="messages">
  <%= render @room.messages %>
</div>
```

### Multi-Tenant Broadcast Scoping

In multi-tenant apps, always scope broadcasts by account to prevent data leaking across tenants:

```ruby
# Bad — global broadcast
after_create_commit -> { broadcast_append_to "messages" }

# Good — scoped to account
after_create_commit -> { broadcast_append_to [account, "messages"], target: "messages" }
```

### When to Use Streams

- Form creates a new item → append/prepend it to the list
- Form updates an item → replace it in place
- Deleting an item → remove it from the DOM
- Updating counters, badges, or status indicators across the page
- Real-time updates pushed from server (chat, notifications, live data)

---

## Stimulus Controllers

Stimulus adds JavaScript behavior to HTML. It's a thin layer — not a rendering framework.

### Controller Anatomy

```javascript
// app/javascript/controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Declare targets (DOM elements referenced by the controller)
  static targets = ["menu", "button"]

  // Declare values (reactive state stored in data attributes)
  static values = {
    open: { type: Boolean, default: false }
  }

  // Declare CSS classes (configurable from HTML)
  static classes = ["active", "hidden"]

  // Declare outlets (references to other controllers)
  static outlets = ["other-controller"]

  // Lifecycle: called when controller connects to DOM
  connect() {
    this.boundClose = this.close.bind(this)
    document.addEventListener("click", this.boundClose)
  }

  // Lifecycle: called when controller disconnects from DOM
  disconnect() {
    document.removeEventListener("click", this.boundClose)
  }

  // Action methods (called from data-action attributes)
  toggle(event) {
    event.stopPropagation()
    this.openValue = !this.openValue
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.openValue = false
    }
  }

  // Value change callback (called automatically when value changes)
  openValueChanged() {
    this.menuTarget.classList.toggle(this.hiddenClass, !this.openValue)
    this.buttonTarget.setAttribute("aria-expanded", this.openValue)
  }
}
```

### HTML Markup

```erb
<div data-controller="dropdown"
     data-dropdown-hidden-class="hidden"
     data-dropdown-open-value="false">
  <button data-dropdown-target="button"
          data-action="dropdown#toggle"
          aria-expanded="false">
    Menu
  </button>
  <div data-dropdown-target="menu" class="hidden">
    <a href="/profile">Profile</a>
    <a href="/settings">Settings</a>
  </div>
</div>
```

### Naming Conventions

| Concept | Convention | Example |
|---------|-----------|---------|
| Controller file | `kebab-case_controller.js` | `slide-over_controller.js` |
| data-controller | kebab-case | `data-controller="slide-over"` |
| Target | camelCase in JS, kebab in HTML | `static targets = ["submitButton"]` → `data-slide-over-target="submitButton"` |
| Value | camelCase in JS, kebab in HTML | `static values = { autoClose: Boolean }` → `data-slide-over-auto-close-value="true"` |
| Action | `event->controller#method` | `data-action="click->slide-over#close"` |

### Default Events

Some elements have default events you don't need to specify:

| Element | Default Event |
|---------|--------------|
| `<button>` | `click` |
| `<form>` | `submit` |
| `<input>` | `input` |
| `<select>` | `change` |
| `<textarea>` | `input` |
| `<a>` | `click` |
| `<details>` | `toggle` |

```erb
<%# These are equivalent: %>
<button data-action="click->dropdown#toggle">Menu</button>
<button data-action="dropdown#toggle">Menu</button>  <%# click is default for button %>
```

### Stimulus Best Practices

1. **One behavior per controller** — `dropdown`, `clipboard`, `auto-submit`, not `form-utils`
2. **Compose multiple controllers** on one element when needed: `data-controller="dropdown auto-save"`
3. **Use values for state** — they sync with HTML data attributes and trigger change callbacks. Use Values API, not `getAttribute()`
4. **Use targets for DOM references** — not `querySelector`
5. **Clean up in `disconnect()`** — remove event listeners, timers, observers. Extract shared helpers to modules
6. **Keep controllers small** — 50 lines is good, 100 is the soft limit
7. **Use CSS classes parameter** for configurable styling
8. **Use outlets** to communicate between controllers (not custom events unless broadcasting)
9. **Progressive installation** — show interactive UI only after JS loads using CSS `[data-controller]` selectors

---

## Turbo + Stimulus Together

### Auto-Submit Form on Change

```erb
<%= form_with url: search_path, method: :get,
    data: { controller: "auto-submit", turbo_frame: "results" } do |f| %>
  <%= f.search_field :q, data: { action: "input->auto-submit#submit" },
      placeholder: "Search..." %>
  <%= f.select :category, Category.pluck(:name, :id),
      { prompt: "All" }, data: { action: "change->auto-submit#submit" } %>
<% end %>

<%= turbo_frame_tag "results" do %>
  <%= render @results %>
<% end %>
```

```javascript
// app/javascript/controllers/auto_submit_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }
}
```

### Dismissible Flash Messages

```erb
<div data-controller="dismissible">
  <div class="flex items-center justify-between bg-green-50 p-4 rounded">
    <p><%= message %></p>
    <button data-action="dismissible#dismiss" class="text-green-600 hover:text-green-800">
      &times;
    </button>
  </div>
</div>
```

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  dismiss() {
    this.element.remove()
  }
}
```

---

## Action Cable Integration

### Real-time Updates

```ruby
# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :user
  after_create_commit -> { broadcast_append_to user, target: "notifications" }
end
```

```erb
<%# app/views/layouts/application.html.erb %>
<% if current_user %>
  <%= turbo_stream_from current_user %>
  <div id="notifications"></div>
<% end %>
```

---

## Common Patterns

### Inline Editing

```erb
<%# show mode %>
<%= turbo_frame_tag dom_id(article) do %>
  <div class="flex justify-between items-center">
    <h2><%= article.title %></h2>
    <%= link_to "Edit", edit_article_path(article), class: "text-blue-600" %>
  </div>
<% end %>
```

```erb
<%# edit mode (returned by edit action, wrapped in same frame) %>
<%= turbo_frame_tag dom_id(@article) do %>
  <%= render "form", article: @article %>
<% end %>
```

### Empty States

```erb
<%= turbo_frame_tag "articles" do %>
  <div id="articles_list">
    <%= render(@articles) || render("empty_state") %>
  </div>
<% end %>
```

### Optimistic UI with Morph

Use `turbo_stream.morph` for smart updates that preserve DOM state (scroll position, focus, form input):

```erb
<%= turbo_stream.morph "article_#{@article.id}", @article %>
```
