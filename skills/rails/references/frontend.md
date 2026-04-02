# Frontend: Tailwind CSS, Importmaps & Propshaft

## Table of Contents
1. [Tailwind CSS in Rails](#tailwind-css-in-rails)
2. [Utility-First Patterns](#utility-first-patterns)
3. [Component Extraction](#component-extraction)
4. [Responsive Design](#responsive-design)
5. [Dark Mode](#dark-mode)
6. [Importmaps](#importmaps)
7. [Propshaft](#propshaft)

---

## Tailwind CSS in Rails

This project uses `tailwindcss-rails` which provides a standalone Tailwind CLI — no Node.js required. The build process watches for changes and generates CSS.

### File Structure

```
app/assets/
├── tailwind/
│   └── application.css       # Tailwind entry point (@import "tailwindcss")
├── stylesheets/
│   └── application.css       # Non-Tailwind custom CSS (if any)
└── builds/
    └── tailwind.css           # Generated output (don't edit)
```

### Configuration

Tailwind v4 uses CSS-based configuration instead of `tailwind.config.js`:

```css
/* app/assets/tailwind/application.css */
@import "tailwindcss";

/* Custom theme extensions */
@theme {
  --color-brand: #4f46e5;
  --color-brand-dark: #3730a3;
  --font-sans: "Inter", system-ui, sans-serif;
}
```

---

## Utility-First Patterns

Compose styles directly in markup. This is the core Tailwind philosophy — it's not "inline styles," it's a design system with constraints.

### Layout Patterns

```erb
<%# Page container %>
<main class="container mx-auto px-4 py-8">

<%# Flex row with spacing %>
<div class="flex items-center gap-4">

<%# Grid layout %>
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">

<%# Stack (vertical flex) %>
<div class="flex flex-col gap-2">

<%# Centered content %>
<div class="flex items-center justify-center min-h-screen">
```

### Typography

```erb
<h1 class="text-3xl font-bold tracking-tight text-gray-900">Title</h1>
<p class="text-base text-gray-600 leading-relaxed">Body text</p>
<span class="text-sm text-gray-500">Caption</span>
<a href="#" class="text-blue-600 hover:text-blue-800 underline">Link</a>
```

### Interactive Elements

```erb
<%# Primary button %>
<button class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
  Save
</button>

<%# Secondary button %>
<button class="bg-white text-gray-700 px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
  Cancel
</button>

<%# Danger button %>
<button class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2">
  Delete
</button>
```

### Cards

```erb
<div class="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden">
  <div class="px-6 py-4">
    <h3 class="text-lg font-semibold text-gray-900"><%= @article.title %></h3>
    <p class="mt-2 text-gray-600"><%= truncate(@article.body, length: 150) %></p>
  </div>
  <div class="px-6 py-3 bg-gray-50 border-t border-gray-200">
    <span class="text-sm text-gray-500"><%= time_ago_in_words(@article.created_at) %> ago</span>
  </div>
</div>
```

### Form Fields

```erb
<%# Text input %>
<div>
  <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
  <input type="email"
    class="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
    placeholder="you@example.com">
</div>

<%# Select %>
<select class="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm">
  <option>Option 1</option>
</select>

<%# Checkbox %>
<label class="flex items-center gap-2">
  <input type="checkbox" class="rounded border-gray-300 text-blue-600 focus:ring-blue-500">
  <span class="text-sm text-gray-700">Remember me</span>
</label>
```

### Tables

```erb
<div class="overflow-x-auto">
  <table class="min-w-full divide-y divide-gray-200">
    <thead class="bg-gray-50">
      <tr>
        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
      </tr>
    </thead>
    <tbody class="bg-white divide-y divide-gray-200">
      <% @users.each do |user| %>
        <tr class="hover:bg-gray-50">
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= user.name %></td>
          <td class="px-6 py-4 whitespace-nowrap"><%= status_badge(user.status) %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
</div>
```

---

## Component Extraction

Extract repeated patterns into partials with Tailwind classes. Only use `@apply` when the same utility combination appears across many different templates.

### Partial-Based Components (Preferred)

```erb
<%# app/views/shared/_button.html.erb %>
<%
  base = "inline-flex items-center px-4 py-2 rounded-lg font-medium text-sm focus:outline-none focus:ring-2 focus:ring-offset-2 transition-colors"
  variants = {
    primary: "bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500",
    secondary: "bg-white text-gray-700 border border-gray-300 hover:bg-gray-50 focus:ring-blue-500",
    danger: "bg-red-600 text-white hover:bg-red-700 focus:ring-red-500"
  }
  variant_class = variants[local_assigns.fetch(:variant, :primary).to_sym]
%>

<%= tag.send(
  local_assigns.fetch(:tag, :button),
  class: "#{base} #{variant_class} #{local_assigns[:class]}",
  **local_assigns.except(:variant, :tag, :class, :content)
) do %>
  <%= content || yield %>
<% end %>
```

```erb
<%# Usage %>
<%= render "shared/button", content: "Save Changes" %>
<%= render "shared/button", variant: :danger, content: "Delete" %>
<%= render "shared/button", variant: :secondary, tag: :a, href: articles_path, content: "Cancel" %>
```

### CSS @apply (Use Sparingly)

Only when the same combination repeats in many different templates and a partial doesn't make sense:

```css
/* app/assets/tailwind/application.css */
@import "tailwindcss";

@layer components {
  .prose-content {
    @apply text-gray-700 leading-relaxed;

    h2 { @apply text-xl font-semibold text-gray-900 mt-8 mb-4; }
    p { @apply mb-4; }
    ul { @apply list-disc list-inside mb-4; }
    a { @apply text-blue-600 underline hover:text-blue-800; }
  }
}
```

---

## Responsive Design

Mobile-first: base styles apply to mobile, then layer on breakpoints.

```erb
<%# Stack on mobile, side-by-side on desktop %>
<div class="flex flex-col md:flex-row gap-6">
  <aside class="w-full md:w-64 shrink-0">Sidebar</aside>
  <main class="flex-1">Content</main>
</div>

<%# Grid: 1 col → 2 cols → 3 cols %>
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">

<%# Hide on mobile, show on desktop %>
<nav class="hidden md:block">Desktop nav</nav>

<%# Show on mobile, hide on desktop %>
<button class="md:hidden">Mobile menu</button>
```

### Breakpoints

| Prefix | Min-width | Target |
|--------|-----------|--------|
| (none) | 0px | Mobile (default) |
| `sm:` | 640px | Small tablets |
| `md:` | 768px | Tablets |
| `lg:` | 1024px | Laptops |
| `xl:` | 1280px | Desktops |
| `2xl:` | 1536px | Large screens |

---

## Dark Mode

```erb
<%# Tailwind supports dark mode via media query or class strategy %>
<div class="bg-white dark:bg-gray-900">
  <h1 class="text-gray-900 dark:text-white">Title</h1>
  <p class="text-gray-600 dark:text-gray-400">Content</p>
</div>
```

For class-based dark mode toggle (user preference), add a Stimulus controller that toggles `dark` class on `<html>` and persists to `localStorage`.

---

## Importmaps

Rails uses importmaps by default — JavaScript modules imported directly by the browser without a bundler.

### Adding JS Packages

```bash
bin/importmap pin stimulus-autocomplete
bin/importmap pin @hotwired/turbo-rails
```

This adds entries to `config/importmap.rb`:

```ruby
pin "stimulus-autocomplete", to: "https://ga.jspm.io/npm:stimulus-autocomplete@3.1.0/src/autocomplete.js"
```

### Importing in JavaScript

```javascript
// app/javascript/application.js
import "@hotwired/turbo-rails"
import "controllers"

// app/javascript/controllers/index.js
import { application } from "controllers/application"
import AutocompleteController from "stimulus-autocomplete"
application.register("autocomplete", AutocompleteController)
```

### When Importmaps Aren't Enough

Importmaps work for most Rails apps. You'd need jsbundling-rails only when:
- Using React/Vue/Svelte components (you shouldn't be in a Hotwire app)
- NPM packages that need a build step (CommonJS-only packages)
- Complex JS that needs tree-shaking

---

## Propshaft

Propshaft is the asset pipeline for Rails 8+. It's simpler than Sprockets — it serves files and adds digests for cache-busting. No compilation, no concatenation.

### How It Works

- Files in `app/assets/` are served with fingerprinted filenames
- `stylesheet_link_tag "application"` → `/assets/application-[digest].css`
- `image_tag "logo.svg"` → `/assets/logo-[digest].svg`
- CSS `url()` references are automatically rewritten with digests

### Asset Paths

```ruby
# In CSS (automatic rewriting)
background-image: url("logo.svg")  # Propshaft handles the digest

# In ERB
<%= image_tag "logo.svg", class: "h-8 w-auto" %>
<%= stylesheet_link_tag "application" %>
<%= javascript_importmap_tags %>
```

No manifest files, no precompilation configuration. Just put files in `app/assets/` and reference them.
