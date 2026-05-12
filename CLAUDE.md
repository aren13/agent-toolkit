# Agent Toolkit — Claude Working Notes

This repo is the **source of truth** for the contents of `~/.claude/`: skills, slash commands, hooks, and shared helpers. Anything that lives in the global Claude Code config and matters across machines belongs here.

## Layout

```
agent-toolkit/
  skills/            -- SKILL.md sources (reference + action skills)
  commands/          -- Slash command definitions ({domain}-{action}.md)
  hooks/             -- Shell hooks consumed by ~/.claude/settings.json
  scripts/           -- Setup, sync, and infrastructure scripts
  prompt-shorthand-modes.md  -- Speech-friendly prompt mode shortcuts
  CONVENTIONS.md     -- Universal naming + skill architecture spec
  README.md          -- User-facing project intro
```

## Working rules

1. **Read `CONVENTIONS.md` before adding or renaming anything.** The `{domain}` / `{domain}-{action}` rule and the action-vs-reference skill split are non-obvious and easy to violate.
2. **Edit in-repo, not in `~/.claude/`.** When a global skill/command/hook needs changing, change it here and run `scripts/sync.sh` to deploy. The repo wins; never reverse-sync.
3. **Reference skills** (`skills/{domain}/`) deploy to `~/.claude/skills/{domain}/` with their `SKILL.md`. They use `triggers:` for reference queries only — never action verbs.
4. **Action skills** (`skills/{domain}-{action}/`) keep `SKILL.md` in the repo as source of truth, but on deploy the `SKILL.md` is **omitted** from `~/.claude/skills/{domain}-{action}/`. Only supporting files (workflows/, references/) deploy. The `commands/{domain}-{action}.md` file is what registers the slash command.
5. **Every action skill must have a matching command file** in `commands/`. Sync enforces this.
6. **Use `name:`, never `skill_name:`** in SKILL.md frontmatter (Claude Code warns on the latter).
7. **No AI tool references in commits** (no "Claude", "Anthropic", "AI-generated").

## Common tasks

| Task | How |
|------|-----|
| Add a new action skill | Create `skills/{domain}-{action}/SKILL.md` + `commands/{domain}-{action}.md`, then run `scripts/sync.sh` |
| Add a new domain | Append to the Domain Prefix Registry in `CONVENTIONS.md`, then create the reference skill |
| Edit a hook | Change `hooks/{name}.sh`, run sync, the file lands in `~/.claude/hooks/` (settings.json already references it) |
| Deploy everything | `scripts/sync.sh` |

## What this repo deliberately excludes

- `~/.claude/agents/` — kept local per machine
- `~/.claude/settings.json` — machine-specific permissions/env
- `~/.claude/plugins/`, `projects/`, `tasks/`, `sessions/` — runtime state, not config
