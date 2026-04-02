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

1. **Domain prefix**: 2-5 characters, unique, registered in the Domain Prefix Registry below
2. **Action suffix**: concise imperative verb (`commit`, `create`, `audit`, `fast`)
3. **Separator**: kebab-case (hyphens only) -- colons are reserved for plugin namespaces
4. **Bare domain = reference**: `/git` loads git standards, `/doc` loads doc standards
5. **Domain + action = executable**: `/git-commit` runs the workflow, `/doc-create` creates a doc
6. **Case**: always lowercase

### File and Folder Naming

- kebab-case for all file and folder names
- Max 50 characters
- No spaces or special characters
- Descriptive but concise

---

## Domain Prefix Registry

Each prefix maps to exactly one domain. Check this table before creating new skills.

| Prefix | Domain | Description |
|--------|--------|-------------|
| `git` | Git operations | Commits, branches, PRs, sync |
| `doc` | Documentation | Writing, auditing, restructuring |
| `rail` | Rails conventions | Models, controllers, views |
| `draw` | Diagrams | Excalidraw, visual diagrams |
| `org` | File organization | Folder structure, naming, cleanup |
| `peek` | Screen interaction | macOS UI capture and control |
| `sql` | Database/SQL | Schema, migrations, queries |
| `dep` | Deployment | CI/CD, infrastructure |
| `tst` | Testing | Test creation, coverage, runners |
| `api` | API design | Endpoints, contracts, SDKs |
| `sec` | Security | Auditing, hardening, scanning |
| `cfg` | Configuration | Settings, environment, dotfiles |
| `dbg` | Debugging | Investigation, diagnosis |
| `net` | Networking | DNS, VPN, firewall |
| `mon` | Monitoring | Logs, alerts, dashboards |
| `ml` | Machine learning | Models, training, inference |

**Reserved (collides with Claude Code built-ins):** `debug`, `batch`, `loop`, `simplify`

---

## Skill Structure

### Reference Skill (the "basket")

Contains standards, rules, templates, and reference material for a domain.

```
skills/{domain}/
  SKILL.md              -- Domain reference (conventions, standards)
  references/           -- Supporting documents (optional)
  templates/            -- Templates for the domain (optional)
```

### Action Skill (the "fruit")

An executable action that belongs to a domain and inherits its reference skill's standards.

```
skills/{domain}-{action}/
  SKILL.md              -- Action definition and workflow
```

### Example: Git Domain

```
skills/
  git/SKILL.md              --> /git         (reference: commit standards, branch naming)
  git-commit/SKILL.md       --> /git-commit  (full workflow: analyze, commit, push)
  git-fast/SKILL.md         --> /git-fast    (quick commit, no ceremony)
  git-pr/SKILL.md           --> /git-pr      (create PR from branch)
  git-sync/SKILL.md         --> /git-sync    (pull --rebase, resolve conflicts)
```

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
docs/doc.md                   -- Documentation standards
docs/doc-templates.md         -- Template reference
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

---

## Adding New Domains

1. Choose a 2-5 character prefix that does not collide with existing prefixes or Claude Code built-ins
2. Add the prefix to the Domain Prefix Registry in this file
3. Create the reference skill at `skills/{domain}/SKILL.md`
4. Create action skills at `skills/{domain}-{action}/SKILL.md` as needed
