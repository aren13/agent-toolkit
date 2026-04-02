---
skill_name: rails-dev
version: 1.0.0
description: Start the Rails development server using bin/ds
allowed-tools: Bash(bin/ds*), Bash(bin/dev*), Bash(bin/rails server*), Bash(rails server*), Bash(lsof -i*), Bash(kill *)
argument: options
---

## Context

- Server script exists: !`test -f bin/ds && echo "bin/ds found" || (test -f bin/dev && echo "bin/dev found" || echo "no dev script found")`
- Port 3000 in use: !`lsof -ti:3000 2>/dev/null && echo "port 3000 occupied" || echo "port 3000 free"`

## User Options

$ARGUMENTS

## Your Task

Start the Rails development server. Follow the rails reference skill at `~/.claude/skills/rails/SKILL.md`.

### Rules

1. **Prefer `bin/ds`** -- this is the project's dev server script. Fall back to `bin/dev`, then `bin/rails server`
2. **Check port 3000** -- if occupied, report the PID and ask before killing it
3. **Run in background** -- start the server so the user can continue working

### Options Parsing

| Flag | Effect |
|------|--------|
| `restart` | Kill existing server on port 3000, then start fresh |
| `stop` | Kill the server on port 3000 and exit |
| `port:NNNN` | Use a different port |

### Workflow

1. Check if port 3000 (or specified port) is in use
2. If `stop`: kill the process and report. Done.
3. If `restart` or port occupied: kill existing process first
4. Start the server using the best available script
5. Report: which script used, port, PID

Execute autonomously. Only ask for confirmation before killing processes (unless `restart` or `stop` was explicitly requested).
