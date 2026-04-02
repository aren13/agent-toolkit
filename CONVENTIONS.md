# Conventions

This project follows a **convention-over-configuration** philosophy. Learn the pattern once, predict every name.

---

## Universal Naming Convention: `{domain}-{action}`

All skills, commands, files, folders, SQL objects, and documentation follow the same pattern:

```
{domain}            -- Reference/knowledge (the "basket")
{domain}-{action}   -- Executable action (the "fruit")
```

### Rules

1. **Domain prefix**: short, recognizable, registered in the Domain Prefix Registry below
2. **Action suffix**: concise imperative verb (`ship`, `craft`, `audit`, `fast`, `organize`)
3. **Separator**: kebab-case (hyphens only) -- colons are reserved for plugin namespaces
4. **Bare domain = reference skill**: `docs` loads documentation standards, `git` loads git conventions
5. **Domain + action = command**: `/git-ship` runs the workflow, `/docs-craft` creates a doc
6. **Case**: always lowercase

### File and Folder Naming

- kebab-case for all file and folder names
- Max 50 characters
- No spaces or special characters
- Descriptive but concise

---

## Domain Prefix Registry

Each prefix maps to exactly one domain. Check this table before creating new skills.

| Prefix | Domain | Reference Skill | Action Commands |
|--------|--------|-----------------|-----------------|
| `git` | Git operations | `git` | `git-ship`, `git-fast`, `git-audit` |
| `docs` | Documentation | `docs` | `docs-craft`, `docs-organize`, `docs-audit` |
| `rails` | Rails conventions | `rails` | `rails-gen`, `rails-dev`, `rails-test` |
| `draw` | Diagrams | `excalidraw-diagram` | - |
| `peek` | Screen interaction | `peekaboo` | - |

**Reserved (collides with Claude Code built-ins):** `debug`, `batch`, `loop`, `simplify`

---

## Skill Architecture

### Two mechanisms, two purposes

| Mechanism | Location | Purpose | Activation |
|-----------|----------|---------|------------|
| **Reference skill** | `~/.claude/skills/{domain}/SKILL.md` | Load conventions and standards as context | Auto-loads via `triggers:` on reference queries |
| **Action command** | `~/.claude/commands/{domain}-{action}.md` | Execute a workflow with dynamic context | User types `/{domain}-{action}` or Claude matches from description |

### Rules

1. **Every action skill MUST have a command file.** Action skills execute workflows and need dynamic context (`!`backtick`` syntax), `allowed-tools` restrictions, and `$ARGUMENTS` support. These are only available in command files.

2. **Reference skills MUST NOT have action-implying triggers.** Triggers load context. If a user says "audit my docs" and the reference skill loads instead of the audit command, they get standards recited instead of an audit running. Only use triggers for reference queries ("documentation standards", "naming conventions").

3. **Action skills MUST NOT have triggers.** Claude matches user intent to commands via their `description` field. No triggers needed. Adding triggers to both base and action creates collisions.

4. **Action command descriptions MUST be clear and specific.** Claude uses the `description` frontmatter to decide which command to invoke. Write it so Claude can match user intent without ambiguity.

5. **Action commands reference the base skill for standards.** Every action command should include a line like: "Follow the {domain} reference skill at `~/.claude/skills/{domain}/SKILL.md`"

### Reference Skill Triggers (correct)

```yaml
# docs/SKILL.md -- reference queries only
triggers:
  - documentation standards
  - naming conventions
  - writing standards
  - document types

# git/SKILL.md -- reference queries only
triggers:
  - git conventions
  - commit standards
  - branch naming
  - pr template
```

### Reference Skill Triggers (wrong -- implies actions)

```yaml
# DO NOT use these on reference skills
triggers:
  - create documentation    # implies action -> should be /docs-craft
  - audit documentation     # implies action -> should be /docs-audit
  - commit changes          # implies action -> should be /git-ship
  - push changes            # implies action -> should be /git-ship
```

---

## Skill Structure

### In the project repo (source of truth)

```
skills/
  {domain}/
    SKILL.md              -- Reference skill (conventions, standards)
    references/           -- Supporting documents (optional)
    templates/            -- Templates for the domain (optional)
  {domain}-{action}/
    SKILL.md              -- Action skill definition and workflow
    workflows/            -- Sub-workflows (optional, for complex skills)
```

### On the machine (global deployment)

```
~/.claude/skills/
  {domain}/
    SKILL.md              -- Reference skill (with triggers)
    references/           -- Supporting docs
    templates/            -- Templates
  {domain}-{action}/
    workflows/            -- Workflow files only (NO SKILL.md)

~/.claude/commands/
  {domain}-{action}.md    -- Command file (dynamic context, allowed-tools)
```

**Key difference:** Action skills have SKILL.md in the project repo (source of truth) but NOT in `~/.claude/skills/` on the machine. Only the command file in `~/.claude/commands/` registers them. This prevents double-registration in the skill list.

Supporting files (workflows, references) go to `~/.claude/skills/{domain}-{action}/` without a SKILL.md so the command can reference them.

### Example: Git Domain

```
Project repo:                          Machine (~/.claude/):
skills/                                skills/
  git/SKILL.md          ─────────►       git/SKILL.md (with triggers)
  git/references/       ─────────►       git/references/
  git-ship/SKILL.md     ──┐
  git-fast/SKILL.md     ──┤           commands/
  git-audit/SKILL.md    ──┴─────────►   git-ship.md (command)
                                         git-fast.md (command)
                                         git-audit.md (command)
```

### Example: Docs Domain

```
Project repo:                          Machine (~/.claude/):
skills/                                skills/
  docs/SKILL.md         ─────────►       docs/SKILL.md (with triggers)
  docs/references/      ─────────►       docs/references/
  docs/templates/       ─────────►       docs/templates/
  docs-craft/SKILL.md   ──┐               docs-craft/workflows/ (no SKILL.md)
  docs-craft/workflows/ ──┤
  docs-organize/SKILL.md──┤           commands/
  docs-audit/SKILL.md   ──┴─────────►   docs-craft.md (command)
                                         docs-organize.md (command)
                                         docs-audit.md (command)
```

---

## Adding New Domains

1. Choose a prefix that does not collide with existing prefixes or Claude Code built-ins
2. Add the prefix to the Domain Prefix Registry in this file
3. Create the reference skill at `skills/{domain}/SKILL.md` with **reference-only triggers**
4. Create action skills at `skills/{domain}-{action}/SKILL.md`
5. Create command files at `~/.claude/commands/{domain}-{action}.md` for each action skill
6. Deploy: copy reference skill to `~/.claude/skills/`, copy commands to `~/.claude/commands/`

---

## SQL Naming

Tables and columns follow the same domain-prefix logic.

```sql
-- Tables: snake_case, domain prefix groups related tables
skill_definitions
skill_executions
skill_metrics

-- Columns: snake_case, descriptive
created_at
updated_at
domain_prefix

-- Migrations: sequential number + verb_noun
001_create_skill_definitions.sql
002_add_index_to_skill_executions.sql
```

---

## Documentation Naming

```
docs/{domain}.md              -- Domain overview
docs/{domain}-{topic}.md      -- Specific topic within domain
```

Example:

```
docs/git.md                   -- Git conventions overview
docs/git-branching.md         -- Branching strategy
docs/docs.md                  -- Documentation standards
docs/docs-templates.md        -- Template reference
```

---

## Commit Messages

Format: `{type}({scope}): {subject}`

**Types:** `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `style`, `chore`, `ci`, `revert`

**Rules:**
- Max 72 characters for subject line
- Imperative mood ("add" not "added")
- No period at end
- Body required for multi-file or non-trivial changes
- No AI tool references in commits
