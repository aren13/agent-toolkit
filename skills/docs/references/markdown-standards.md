# Markdown Standards Reference

Complete formatting rules for markdown documentation following CommonMark specification.

## Headings

### ATX-Style Headings

**Rule:** Use ATX-style headings (`#`) not underline style.

**Correct:**
```markdown
# Heading 1
## Heading 2
### Heading 3
```

**Incorrect:**
```markdown
Heading 1
=========

Heading 2
---------
```

**Why:** ATX-style is more consistent, easier to write, and clearer in plain text.

---

### One H1 Per Document

**Rule:** Each document should have exactly one H1 heading (the title).

**Correct:**
```markdown
# Installation Guide

## Prerequisites
## Steps
## Troubleshooting
```

**Incorrect:**
```markdown
# Installation Guide

# Prerequisites  ❌ (should be ##)
# Steps          ❌ (should be ##)
```

---

### Don't Skip Heading Levels

**Rule:** Follow proper heading hierarchy (H1 → H2 → H3, not H1 → H3).

**Correct:**
```markdown
# Title (H1)
## Section (H2)
### Subsection (H3)
#### Sub-subsection (H4)
```

**Incorrect:**
```markdown
# Title (H1)
### Subsection (H3)  ❌ (skipped H2)
#### Detail (H4)
```

---

### Blank Lines Around Headings

**Rule:** Add blank line before and after headings.

**Correct:**
```markdown
Previous paragraph text.

## Heading

Next paragraph text.
```

**Incorrect:**
```markdown
Previous paragraph text.
## Heading  ❌ (no blank line before)
Next paragraph text.  ❌ (no blank line after)
```

---

## Code Blocks

### Always Specify Language

**Rule:** Always include language identifier in code blocks.

**Correct:**
````markdown
```ruby
def example
  puts "Hello"
end
```
````

````markdown
```bash
bundle install
rails server
```
````

````markdown
```json
{
  "key": "value"
}
```
````

**Incorrect:**
````markdown
```
def example
  puts "Hello"
end
```
````

**Why:** Enables syntax highlighting, makes code type clear, improves readability.

---

### Common Language Identifiers

| Language | Identifier |
|----------|------------|
| Ruby | `ruby` |
| Shell/Bash | `bash` or `sh` |
| SQL | `sql` |
| JSON | `json` |
| YAML | `yaml` or `yml` |
| JavaScript | `javascript` or `js` |
| TypeScript | `typescript` or `ts` |
| Python | `python` or `py` |
| ERB | `erb` |
| HTML | `html` |
| CSS | `css` |
| Markdown | `markdown` or `md` |
| Plain text | `text` |
| Diff | `diff` |

---

### Include Comments in Code

**Rule:** Add comments to explain non-obvious code.

**Good:**
```ruby
# Create user with admin role
user = User.create!(
  email: 'admin@example.com',
  role: 'admin'
)
```

**OK (if obvious):**
```bash
bundle install
```

---

### Show Output When Relevant

**Rule:** Show expected output for commands where helpful.

**Good:**
```bash
$ ruby --version
ruby 3.2.2 (2023-03-30 revision e51014f9c0)
```

**Good:**
```bash
$ rails db:migrate
== 20240101120000 CreateUsers: migrating ===
-- create_table(:users)
   -> 0.0234s
== 20240101120000 CreateUsers: migrated (0.0235s) ===
```

---

## Tables

### Proper Table Structure

**Rule:** Use header row with alignment row, keep columns aligned.

**Correct:**
```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Value 1  | Value 2  | Value 3  |
| Value 4  | Value 5  | Value 6  |
```

**Alignment Options:**
```markdown
| Left | Center | Right |
|:-----|:------:|------:|
| Text | Text   | Text  |
```

---

### Use Hyphens for Empty Cells

**Rule:** Use `-` for empty/not-applicable cells.

**Correct:**
```markdown
| Feature | Free | Pro |
|---------|------|-----|
| Users   | 5    | Unlimited |
| Storage | 1GB  | -   |
| Support | -    | Yes |
```

**Avoid:**
```markdown
| Feature | Free | Pro |
|---------|------|-----|
| Support |      | Yes |  ❌ (empty cell unclear)
| Support | N/A  | Yes |  (OK but inconsistent)
```

---

### Keep Tables Readable

**Rule:** Align columns for source readability.

**Good:**
```markdown
| Property    | Type   | Default | Required |
|-------------|--------|---------|----------|
| name        | string | -       | Yes      |
| email       | string | -       | Yes      |
| role        | string | user    | No       |
| active      | boolean| true    | No       |
```

**Acceptable (but harder to read):**
```markdown
| Property | Type | Default | Required |
|---|---|---|---|
| name | string | - | Yes |
| email | string | - | Yes |
```

**Why:** Aligned tables are easier to read and edit in source.

---

## Links

### Relative Paths for Internal Links

**Rule:** Use relative paths for links to other docs in same repository.

**Correct:**
```markdown
[Installation Guide](./getting-started/installation-guide.md)
[API Reference](../api/endpoints-reference.md)
[Features](./features/)
```

**Incorrect:**
```markdown
[Installation Guide](/docs/getting-started/installation-guide.md)  ❌ (absolute)
[Installation Guide](https://github.com/org/repo/blob/main/docs/getting-started/installation-guide.md)  ❌ (full URL)
```

**Why:** Relative links work across different hosts, forks, and local development.

---

### Descriptive Link Text

**Rule:** Use descriptive text that indicates where the link goes.

**Good:**
```markdown
See the [Installation Guide](./installation-guide.md) for setup instructions.
Read the [API Reference](./api-reference.md) for endpoint details.
Check the [troubleshooting section](#troubleshooting) below.
```

**Poor:**
```markdown
Click [here](./installation-guide.md) for setup instructions.  ❌
More info [here](./api-reference.md).  ❌
See [this section](#troubleshooting).  ❌
```

**Why:** Descriptive text is better for accessibility and scanning.

---

### External Links Include Protocol

**Rule:** External links must include `https://` or `http://`.

**Correct:**
```markdown
[Ruby Documentation](https://ruby-doc.org)
[GitHub](https://github.com)
```

**Incorrect:**
```markdown
[Ruby Documentation](ruby-doc.org)  ❌
[GitHub](www.github.com)  ❌
```

---

### Reference-Style Links (Optional)

**Pattern:** Define links at bottom for frequently referenced URLs.

**Example:**
```markdown
See the [Ruby docs][ruby-docs] and [Rails docs][rails-docs] for more information.

[ruby-docs]: https://ruby-doc.org
[rails-docs]: https://guides.rubyonrails.org
```

**Use when:** Many repeated links, very long URLs, or want to centralize URL management.

---

## Lists

### Unordered Lists Use Hyphens

**Rule:** Use `-` for unordered lists (not `*` or `+`).

**Correct:**
```markdown
- Item 1
- Item 2
- Item 3
```

**Avoid:**
```markdown
* Item 1  ❌
+ Item 2  ❌
- Item 3  ✅
```

**Why:** Consistency across project, clearer in plain text.

---

### Ordered Lists Use `1.`

**Rule:** Use `1.` for all ordered list items (auto-numbering).

**Correct:**
```markdown
1. First step
1. Second step
1. Third step
```

**Also Correct (manual numbering):**
```markdown
1. First step
2. Second step
3. Third step
```

**Why:** Auto-numbering (`1. 1. 1.`) is easier to maintain when reordering.

---

### Nested Lists Use 2-Space Indentation

**Rule:** Indent nested lists with 2 spaces.

**Correct:**
```markdown
- Level 1
  - Level 2
    - Level 3
- Level 1 again
  1. Ordered nested
  1. Second item
```

**Incorrect:**
```markdown
- Level 1
    - Level 2  ❌ (4 spaces, should be 2)
- Level 1
   - Level 2  ❌ (odd number of spaces)
```

---

### Consistent List Formatting

**Rule:** Keep formatting consistent within each list.

**Good:**
```markdown
- Item with description
- Another item with description
- Third item with description
```

**Poor:**
```markdown
- Item 1
  Multiline description
  continues here
- Item 2  ❌ (inconsistent with above)
- Item 3: inline description  ❌ (different format)
```

---

## Emphasis

### Bold for Strong Emphasis

**Rule:** Use `**bold**` for strong emphasis.

**Syntax:**
```markdown
This is **bold text**.
This is also __bold text__.  (alternative)
```

**Use for:**
- Important warnings: "**Warning:** This deletes all data"
- Key terms: "The **primary key** must be unique"
- Labels: "**Prerequisites:**"

---

### Italic for Mild Emphasis

**Rule:** Use `*italic*` for mild emphasis or new terms.

**Syntax:**
```markdown
This is *italic text*.
This is also _italic text_.  (alternative)
```

**Use for:**
- New term introduction: "The *dependency injection* pattern"
- UI element names: "Click the *Save* button"
- Emphasis: "This is *not* recommended"

---

### Don't Overuse

**Rule:** Use emphasis sparingly.

**Good:**
```markdown
The **primary** database handles all writes. Replicas handle reads.
```

**Overused:**
```markdown
The **primary** **database** **handles** **all** **writes**.  ❌
```

---

## Block Quotes

### Use for Citations or Notes

**Rule:** Use `>` for block quotes.

**Syntax:**
```markdown
> This is a block quote.
> It can span multiple lines.
```

**Use for:**
- Important notes
- Citations
- Callouts

**Example:**
```markdown
> **Note:** This feature requires Ruby 3.2 or higher.

> **Warning:** This operation cannot be undone.
```

---

## Horizontal Rules

### Use for Major Breaks

**Rule:** Use `---` for horizontal rules (three hyphens).

**Syntax:**
```markdown
Section content.

---

Next section content.
```

**Alternatives (equivalent):**
```markdown
***
___
```

**Use sparingly:** Only for major section breaks.

---

## Metadata Blocks

### Consistent Metadata Format

**Rule:** Use blockquotes for metadata at document start.

**Pattern:**
```markdown
# Document Title

> **Last Updated:** YYYY-MM-DD
> **Version:** X.Y (for PRDs/Specs)
> **Status:** Active/Draft/Deprecated (for PRDs/Specs)

Brief description.

---

## First Section
```

**Use:**
- Last Updated: All documents
- Version: PRDs, Specs, Roadmaps
- Status: PRDs, Specs, Roadmaps
- Date: Fix documents, Summaries

---

## Line Length

### No Hard Wrap Required

**Rule:** No strict line length limit, but avoid extremely long lines.

**Good Practice:**
- Break at natural points (sentences, clauses)
- Keep lines readable in most editors (80-120 chars reasonable)
- Tables may exceed line length (that's OK)
- Don't break mid-sentence arbitrarily

**OK:**
```markdown
This is a sentence that's moderately long but still readable in most editors without scrolling horizontally.
```

**Avoid:**
```markdown
This is an extremely long sentence that goes on and on and on with no breaks whatsoever and becomes very difficult to read in a standard editor window and should probably be broken into multiple sentences for better readability.  ❌
```

---

## Blank Lines

### Use for Visual Separation

**Rules:**
- Blank line before and after headings
- Blank line before and after code blocks
- Blank line between paragraphs
- Blank line before and after lists
- Blank line before and after tables
- No multiple blank lines (max 1)

**Good:**
```markdown
Paragraph text.

## Heading

Another paragraph.

```ruby
code_here
```

Next paragraph.
```

**Poor:**
```markdown
Paragraph text.
## Heading  ❌
Another paragraph.  ❌


Multiple blanks.  ❌
```

---

## Special Characters

### Escape When Needed

**Rule:** Escape markdown special characters when you want them literal.

**Special Characters:**
```
\ ` * _ { } [ ] ( ) # + - . ! |
```

**Example:**
```markdown
Use \*asterisks\* to show asterisks literally.
Use \_ for literal underscores.
Use \# for literal hash.
```

**Renders as:** Use \*asterisks\* to show asterisks literally.

---

## Task Lists (GitHub Flavor)

### Use for Checklists

**Syntax:**
```markdown
- [ ] Incomplete task
- [x] Completed task
- [ ] Another task
```

**Renders as:**
- [ ] Incomplete task
- [x] Completed task
- [ ] Another task

**Use in:**
- Acceptance criteria sections
- Quality checklists
- Step-by-step verification

---

## Common Mistakes

### 1. No Language on Code Blocks

❌ ` ```
ruby code here
```

✅ ` ```ruby
ruby code here
```

### 2. Absolute Paths for Internal Links

❌ `[Guide](/docs/guide.md)`
✅ `[Guide](./guide.md)`

### 3. Skipped Heading Levels

❌ `# Title` then `### Subsection`
✅ `# Title` then `## Section` then `### Subsection`

### 4. No Blank Lines Around Headings/Code

❌
```markdown
Text
## Heading
More text
```

✅
```markdown
Text

## Heading

More text
```

### 5. Poor Table Formatting

❌
```markdown
|A|B|
|---|---|
|1|2|
```

✅
```markdown
| Column A | Column B |
|----------|----------|
| Value 1  | Value 2  |
```

---

## Validation Checklist

- [ ] Uses ATX-style headings (#)
- [ ] One H1 per document
- [ ] No skipped heading levels
- [ ] Blank lines around headings
- [ ] All code blocks have language specified
- [ ] Tables have proper structure
- [ ] Tables use `-` for empty cells
- [ ] Internal links are relative paths
- [ ] External links include protocol
- [ ] Link text is descriptive
- [ ] Lists use `-` for unordered
- [ ] Lists use `1.` for ordered
- [ ] Nested lists use 2-space indentation
- [ ] Emphasis used sparingly
- [ ] Metadata formatted consistently
- [ ] Blank lines for separation
- [ ] No multiple consecutive blank lines

---

## Quick Reference

| Element | Syntax | Example |
|---------|--------|---------|
| Heading 1 | `# Title` | # Title |
| Heading 2 | `## Section` | ## Section |
| Bold | `**text**` | **text** |
| Italic | `*text*` | *text* |
| Code inline | `` `code` `` | `code` |
| Code block | ` ```lang` | ```ruby
code
``` |
| Link | `[text](url)` | [text](url) |
| Image | `![alt](url)` | ![alt](url) |
| List | `- item` | - item |
| Ordered | `1. item` | 1. item |
| Quote | `> text` | > text |
| Rule | `---` | --- |
| Task | `- [ ] task` | - [ ] task |
| Table | `\| A \| B \|` | \| A \| B \| |
