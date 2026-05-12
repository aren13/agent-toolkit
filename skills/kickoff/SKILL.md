---
name: kickoff
description: Bootstrap a new project directory with CLAUDE.md, git, and a private GitHub repo. Use when the user runs /kickoff (with optional simple|detail|full mode) to initialize a fresh project folder that has no CLAUDE.md or git repository yet.
---

<essential_principles>
<principle name="three_modes">
This skill has three escalating modes. Each does MORE than the previous — more questions AND more output artifacts.

| Mode | Questions | Artifacts | Use when |
|------|-----------|-----------|----------|
| `simple` | 0 (infer from conversation) | `CLAUDE.md` only | Already discussed the project; just want scaffolding |
| `detail` | 3–5 focused questions | `CLAUDE.md` + `brief.md` | Have a rough idea; want a written brief |
| `full` | 8–12 thorough questions | `CLAUDE.md` + `brief.md` + `roadmap.md` + `TO-DOS.md` | New initiative; need complete planning baseline |

All modes always end with: `git init` → initial commit → `gh repo create --private --push`.
</principle>

<principle name="preflight_is_mandatory">
Before ANY mode, run preflight checks (see workflows/_preflight.md). If any check fails, stop and report — don't try to recover silently.

Required preflight:
1. `gh auth status` — GitHub CLI must be authenticated
2. `git rev-parse --git-dir 2>/dev/null` — must NOT already be a git repo (abort if it is)
3. `test -f CLAUDE.md` — must NOT already exist (abort if it does)
4. `pwd` — must not be `$HOME` or a parent of common dev roots (sanity check)
</principle>

<principle name="github_repo_always_auto">
Every mode creates a private GitHub repo automatically. Do NOT ask the user "should I create a repo?" — they already opted in by invoking this skill. Use the directory's basename as the repo name unless the user specified otherwise.
</principle>

<principle name="absolute_dates">
When writing dates into any artifact (CLAUDE.md, brief.md, etc.), use the absolute date provided in the system context — never relative phrases like "today" or "this week".
</principle>
</essential_principles>

<intake>
The user invoked `/kickoff` with an argument: `simple`, `detail`, or `full` (passed as `$ARGUMENTS`).

**If the argument is one of `simple` / `detail` / `full`:** route directly to that workflow without asking.

**If the argument is empty or unrecognized:** ask via AskUserQuestion which mode they want, with these three options.
</intake>

<routing>
| Argument | Workflow |
|----------|----------|
| `simple` | `workflows/simple.md` |
| `detail` | `workflows/detail.md` |
| `full` | `workflows/full.md` |
| empty / other | Ask user via AskUserQuestion, then route |

After loading the workflow, ALSO read `workflows/_preflight.md` first — every workflow runs preflight before its mode-specific steps.
</routing>

<reference_index>
Reusable knowledge in `references/`:

- `github-setup.md` — `gh` commands, repo conventions, auth troubleshooting
- `gitignore-defaults.md` — sensible defaults by project type
</reference_index>

<templates_index>
Output structures in `templates/` — workflows COPY these and fill placeholders:

- `claude-md-simple.md` — minimal CLAUDE.md (simple mode)
- `claude-md-detail.md` — CLAUDE.md with brief link (detail mode)
- `claude-md-full.md` — CLAUDE.md with full doc index (full mode)
- `brief.md` — project brief template (detail + full)
- `roadmap.md` — phased roadmap template (full only)
- `todos.md` — TO-DOS.md template (full only)
</templates_index>

<workflows_index>
| Workflow | Purpose |
|----------|---------|
| `_preflight.md` | Shared preflight checks — runs first in every mode |
| `simple.md` | Zero-question scaffold from conversation history |
| `detail.md` | 3–5 questions → CLAUDE.md + brief.md |
| `full.md` | 8–12 questions → CLAUDE.md + brief.md + roadmap.md + TO-DOS.md |
</workflows_index>

<success_criteria>
A kickoff is complete when:
- [ ] Preflight passed (or aborted cleanly with reason)
- [ ] All artifacts for the chosen mode exist in pwd
- [ ] `git init` ran and initial commit was created
- [ ] Private GitHub repo created and pushed (`gh repo view` confirms)
- [ ] User shown a one-line summary with the repo URL
</success_criteria>
