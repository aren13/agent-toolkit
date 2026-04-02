# Writing Style Reference

Complete guide to writing style, tone, and language standards for documentation.

## Core Principles

1. **Clarity over cleverness** - Be direct and clear
2. **Active over passive** - Make it clear who does what
3. **Present over past** - Describe current state in present tense
4. **Imperative for instructions** - Tell user directly what to do
5. **Specific over vague** - Use concrete details
6. **Simple over complex** - Choose simple words and structures

---

## Language Requirements

### English Only (Unless Specified)

**Rule:** All documentation must be written in English by default.

**Reasoning:**
- Global audience accessibility
- Consistency across project
- Easier maintenance

**Exception:** If project specifies a different primary language (e.g., Turkish for tr locale), follow that specification.

---

## Voice and Tense

### Active Voice

**Rule:** Use active voice where the subject performs the action.

**Active (Good):**
- "The system handles requests"
- "Run the command to start the server"
- "The API returns JSON responses"
- "Update the configuration file"

**Passive (Avoid):**
- "Requests are handled by the system" ❌
- "The command should be run to start the server" ❌
- "JSON responses are returned by the API" ❌
- "The configuration file should be updated" ❌

**Why:** Active voice is clearer, more direct, and easier to understand.

**When Passive is OK:**
- When the actor is unknown or irrelevant: "The database is backed up daily"
- When focus is on the object: "Users are authenticated via OAuth"

---

### Present Tense for Current State

**Rule:** Use present tense to describe how things currently work.

**Present (Good):**
- "The system handles authentication"
- "Users can create donations"
- "The API supports JSON and XML"
- "Errors return a 400 status code"

**Past (Avoid for current state):**
- "The system was designed to handle authentication" ❌
- "Users could create donations" ❌
- "The API supported JSON and XML" ❌
- "Errors returned a 400 status code" ❌

**When Past is OK:**
- Describing historical events: "Version 1.0 was released in 2020"
- In fix documents: "The vulnerability was discovered during audit"
- In summaries: "The team completed the migration"

---

### Imperative Mood for Instructions

**Rule:** Use imperative mood (commands) for instructions, not suggestions.

**Imperative (Good):**
- "Run the tests"
- "Install the dependencies"
- "Update the configuration"
- "Restart the server"

**Avoid These Patterns:**
- "You should run the tests" ❌ (hedging)
- "You need to install the dependencies" ❌ (indirect)
- "We recommend that you update the configuration" ❌ (first-person plural)
- "The server should be restarted" ❌ (passive)
- "It's best to restart the server" ❌ (weak)

**Why:** Direct instructions are clearer and more confident.

---

## Clarity Guidelines

### No Vague Language

**Rule:** Be specific with versions, times, quantities, and outcomes.

**Vague (Avoid):**
- "This might take a while" ❌
- "Soon we will release..." ❌
- "Some users may experience..." ❌
- "Recently updated" ❌
- "Large file" ❌

**Specific (Good):**
- "This takes approximately 2-5 minutes" ✅
- "Version 2.0 will be released in Q2 2024" ✅
- "Users without admin role may experience..." ✅
- "Updated on 2024-01-15" ✅
- "Files larger than 10MB" ✅

### Define Acronyms

**Rule:** Define acronyms and abbreviations on first use in each document.

**Good:**
- "Content Security Policy (CSP)" - then use "CSP" after
- "Application Programming Interface (API)" - then use "API" after
- "Command-Line Interface (CLI)" - then use "CLI" after

**Pattern:**
```
First use: Full Term (ACRONYM)
Subsequent: ACRONYM
```

**Common acronyms that still need definition:**
- CSP, API, CLI, REST, CRUD, SQL, JSON, XML, HTTP, HTTPS
- Even common ones should be defined on first use

---

## Formatting Standards

### No Emojis

**Rule:** Do not use emojis in documentation.

**Why:**
- Reduces readability in terminals
- Inconsistent rendering across platforms
- Unprofessional appearance
- Screen reader issues

**Avoid:**
- ✨ New Feature ❌
- ⚠️ Warning ❌
- 🚀 Getting Started ❌
- ✅ Completed ❌

**Use Instead:**
- "New Feature" or **New Feature** (bold)
- "Warning:" or **Warning:**
- "Getting Started"
- "[✓] Completed" or "**Status:** Completed"

---

### Minimal Bold/Italic

**Rule:** Use bold and italic sparingly for emphasis only.

**Appropriate Use:**
- **Bold:** Section labels, warnings, important terms
  - "**Prerequisites:** Ruby 3.2+"
  - "**Warning:** This deletes all data"
  - "The **primary** key must be unique"

- *Italic:* Introducing new terms, UI element names
  - "The *dependency injection* pattern..."
  - "Click the *Save* button"

**Overuse (Avoid):**
- **Every** **important** **word** **bolded** ❌
- *Too* *much* *italic* *text* ❌

---

### Consistent Terminology

**Rule:** Use the same term for the same concept throughout all docs.

**Choose one and stick with it:**

| Use | Don't mix with |
|-----|----------------|
| Execute | Run, Fire, Trigger |
| Configuration | Config, Setup, Settings |
| Environment variable | ENV, env var, environment var |
| Repository | Repo |
| Application | App |
| Production | Prod |
| Database | DB (in prose; DB OK in tables) |

**Be consistent within your project:**
- If existing docs use "config", continue using "config"
- If existing docs use "configuration", continue using "configuration"
- Don't switch between them

---

## Sentence Structure

### Keep Sentences Clear and Concise

**Good:**
- "Install Ruby 3.2 or higher."
- "The API returns JSON by default."
- "Run the tests before deploying."

**Too Complex:**
- "In order to proceed with the installation process, it is necessary to install Ruby version 3.2 or higher." ❌
- "The API, by default, will return responses in JSON format." ❌
- "Prior to deployment, the tests should be run." ❌

**Guidelines:**
- One idea per sentence
- 15-25 words per sentence (average)
- Break long sentences into multiple shorter ones
- Remove unnecessary words ("in order to" → "to")

---

## Avoid These Patterns

### First-Person Plural ("We")

**Avoid:**
- "We recommend running the tests" ❌
- "We suggest using PostgreSQL" ❌
- "We think this is the best approach" ❌
- "We've implemented a new feature" ❌

**Use Instead:**
- "Run the tests" ✅
- "Use PostgreSQL for best performance" ✅
- "This approach provides..." ✅
- "Version 2.0 includes a new feature" ✅

**Exception:** When speaking as the organization in introductions:
- "We built this platform to..." (in README)

---

### Time Estimates

**Avoid:**
- "This will take 2 hours" ❌
- "You can complete this in 30 minutes" ❌
- "This is a quick fix" ❌
- "Implementation takes about a week" ❌

**Why:**
- Time varies by user skill level
- Environment differences affect time
- Creates false expectations
- Hard to maintain accuracy

**Use Instead:**
- Describe steps clearly and let users judge
- If must give time, say "approximately" or give range
- "This typically takes 2-5 minutes" (for very short tasks)

---

### Hedging and Uncertainty

**Avoid:**
- "This might work" ❌
- "Possibly the best option" ❌
- "Could be useful" ❌
- "Maybe try this" ❌
- "Should probably work" ❌

**Be Confident:**
- "This works" ✅ or "This solves the problem" ✅
- "The best option is..." ✅
- "This is useful for..." ✅
- "Try this approach" ✅
- "This works in all versions" ✅

**When Genuine Uncertainty:**
If actually uncertain, be specific about the uncertainty:
- "This may fail if X condition exists"
- "Results vary depending on Y"
- "Check Z before proceeding"

---

## Examples and Code

### Concrete Examples

**Rule:** Use specific, working examples rather than abstract descriptions.

**Abstract (Weak):**
- "Configure the database connection with appropriate parameters" ❌

**Concrete (Strong):**
```ruby
# config/database.yml
production:
  adapter: postgresql
  database: myapp_production
  host: localhost
  pool: 5
```

### Complete Examples

**Rule:** Show complete, runnable examples.

**Incomplete:**
```bash
bundle install
# ...other steps
rails server
```

**Complete:**
```bash
# Install dependencies
bundle install

# Create database
bundle exec rails db:create

# Run migrations
bundle exec rails db:migrate

# Start server
bundle exec rails server
```

---

## Lists and Structure

### Use Lists for Multiple Items

**Poor (Prose):**
"The prerequisites are Ruby 3.2 or higher and PostgreSQL 12 or higher and Redis 6 or higher and Node.js 16 or higher." ❌

**Good (List):**
"Prerequisites:
- Ruby 3.2 or higher
- PostgreSQL 12 or higher
- Redis 6 or higher
- Node.js 16 or higher"

### Parallel Structure

**Rule:** Keep list items in the same grammatical form.

**Not Parallel:**
- Install Ruby
- PostgreSQL installation
- You should set up Redis ❌

**Parallel:**
- Install Ruby
- Install PostgreSQL
- Install Redis ✅

Or:

- Ruby installation
- PostgreSQL installation
- Redis installation ✅

---

## Accessibility

### Screen Reader Friendly

**Guidelines:**
- No ASCII art or decorative characters
- No emoji (as mentioned)
- Descriptive link text (not "click here")
- Alt text for images (if used)
- Clear heading hierarchy
- Lists for sequential items

**Bad Links:**
- "Click [here](link) for more info" ❌
- "[Link](url)" ❌

**Good Links:**
- "[Installation Guide](link)" ✅
- "See the [API Reference](link)" ✅

---

## Tone

### Professional but Friendly

**Appropriate Tone:**
- Clear and direct
- Helpful and supportive
- Professional
- Respectful of reader's time

**Avoid:**
- Overly casual: "Just do this awesome thing!" ❌
- Condescending: "Obviously, you should..." ❌
- Apologetic: "Sorry, but you need to..." ❌
- Overly formal: "One must endeavor to..." ❌

**Good Examples:**
- "Install the dependencies"
- "This guide covers API authentication"
- "Follow these steps to deploy"
- "The system supports both JSON and XML"

---

## Writing Checklist

Use this checklist when writing or reviewing:

**Voice and Tense:**
- [ ] Uses active voice
- [ ] Uses present tense for current state
- [ ] Uses imperative mood for instructions
- [ ] Avoids first-person plural ("we")

**Clarity:**
- [ ] No vague language
- [ ] Specific versions, dates, quantities
- [ ] Acronyms defined on first use
- [ ] Consistent terminology
- [ ] No time estimates

**Formatting:**
- [ ] No emojis
- [ ] Bold/italic used sparingly
- [ ] Clear sentence structure
- [ ] Appropriate use of lists

**Examples:**
- [ ] Concrete, specific examples
- [ ] Complete, runnable code
- [ ] Examples are tested

**Accessibility:**
- [ ] Descriptive link text
- [ ] Clear heading hierarchy
- [ ] Screen reader friendly

**Tone:**
- [ ] Professional
- [ ] Direct and confident
- [ ] Respectful of reader

---

## Common Transformations

Quick reference for improving common patterns:

| Instead of... | Write... |
|---------------|----------|
| "You should run..." | "Run..." |
| "It is recommended to..." | "[Do the thing]" |
| "We recommend..." | "[Do the thing]" |
| "The command should be run" | "Run the command" |
| "This might work" | "This works" or "Try this" |
| "This takes a while" | "This takes approximately X minutes" |
| "Recently updated" | "Updated YYYY-MM-DD" |
| "In order to" | "To" |
| "Due to the fact that" | "Because" |
| "At this point in time" | "Now" |
| "In the event that" | "If" |
| "It is important to note that" | (Remove, state directly) |
