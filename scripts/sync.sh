#!/usr/bin/env bash
# sync.sh — deploy agent-toolkit assets to ~/.claude/
#
# Source of truth lives in this repo. Sync pushes:
#   commands/*.md  -> ~/.claude/commands/
#   hooks/*.sh     -> ~/.claude/hooks/
#   skills/{name}/ -> ~/.claude/skills/{name}/   (rules below)
#
# Skill rules (per CONVENTIONS.md):
#   - Action skill = a skills/{name}/ folder that has a matching commands/{name}.md.
#     Deploy WITHOUT its SKILL.md (the command file registers the slash command).
#     Skip entirely if the folder has no support files beyond SKILL.md.
#   - Reference / regular skill = no matching command file.
#     Deploy the whole folder including SKILL.md.
#
# Flags:
#   --dry-run   show what would change, write nothing
#   --delete    pass --delete to rsync (mirror; removes files on dest not in source)
#                WARNING: only use this if the repo is the complete picture.
#   -v          verbose rsync output

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_ROOT="${HOME}/.claude"

# OpenClaw personal-skills directory. Reference skills (no command file) are
# additionally deployed here so the OpenClaw agent can use the same skill from
# the same source of truth. Skipped silently if the directory doesn't exist
# (i.e. this Mac doesn't run OpenClaw).
OPENCLAW_SKILLS_ROOT="${HOME}/.agents/skills"

DRY_RUN=0
DELETE=0
VERBOSE=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --delete)  DELETE=1 ;;
    -v)        VERBOSE=1 ;;
    -h|--help)
      sed -n '2,20p' "${BASH_SOURCE[0]}"
      exit 0
      ;;
    *) echo "unknown arg: $arg" >&2; exit 2 ;;
  esac
done

RSYNC_FLAGS=(-a)
[[ $VERBOSE -eq 1 ]] && RSYNC_FLAGS+=(-v)
[[ $DRY_RUN -eq 1 ]] && RSYNC_FLAGS+=(--dry-run)
[[ $DELETE  -eq 1 ]] && RSYNC_FLAGS+=(--delete)

bold()   { printf '\033[1m%s\033[0m\n' "$*"; }
warn()   { printf '\033[33m! %s\033[0m\n' "$*" >&2; }
ok()     { printf '\033[32m✓ %s\033[0m\n' "$*"; }
header() { printf '\n\033[1;36m== %s ==\033[0m\n' "$*"; }

# -- 1. commands -------------------------------------------------------------
header "commands  →  ${DEST_ROOT}/commands/"
mkdir -p "${DEST_ROOT}/commands"
if [[ -d "${REPO_ROOT}/commands" ]]; then
  rsync "${RSYNC_FLAGS[@]}" \
    --include='*.md' --exclude='*' \
    "${REPO_ROOT}/commands/" "${DEST_ROOT}/commands/"
  ok "commands synced ($(ls "${REPO_ROOT}/commands"/*.md 2>/dev/null | wc -l | tr -d ' ') files)"
else
  warn "no commands/ directory in repo"
fi

# -- 2. hooks ----------------------------------------------------------------
header "hooks  →  ${DEST_ROOT}/hooks/"
mkdir -p "${DEST_ROOT}/hooks"
if [[ -d "${REPO_ROOT}/hooks" ]]; then
  rsync "${RSYNC_FLAGS[@]}" --chmod=u+rx,g+rx,o+rx \
    --include='*.sh' --exclude='*' \
    "${REPO_ROOT}/hooks/" "${DEST_ROOT}/hooks/"
  ok "hooks synced ($(ls "${REPO_ROOT}/hooks"/*.sh 2>/dev/null | wc -l | tr -d ' ') files)"
else
  warn "no hooks/ directory in repo"
fi

# -- 3. skills ---------------------------------------------------------------
if [[ -d "$OPENCLAW_SKILLS_ROOT" ]]; then
  header "skills  →  ${DEST_ROOT}/skills/ + ${OPENCLAW_SKILLS_ROOT}/ (reference skills only)"
else
  header "skills  →  ${DEST_ROOT}/skills/"
fi
mkdir -p "${DEST_ROOT}/skills"

action_count=0
reference_count=0
skipped_count=0
orphan_skills=()
orphan_commands=()

for skill_dir in "${REPO_ROOT}/skills"/*/; do
  [[ -d "$skill_dir" ]] || continue
  skill_name="$(basename "$skill_dir")"
  command_file="${REPO_ROOT}/commands/${skill_name}.md"
  dest="${DEST_ROOT}/skills/${skill_name}/"

  if [[ -f "$command_file" ]]; then
    # Action skill: deploy without SKILL.md
    support_files="$(find "$skill_dir" -mindepth 1 -not -name 'SKILL.md' -print -quit 2>/dev/null || true)"
    if [[ -z "$support_files" ]]; then
      [[ $VERBOSE -eq 1 ]] && warn "skip $skill_name (action skill, no support files)"
      skipped_count=$((skipped_count + 1))
      continue
    fi
    mkdir -p "$dest"
    rsync "${RSYNC_FLAGS[@]}" --exclude='SKILL.md' "$skill_dir" "$dest"
    action_count=$((action_count + 1))
  else
    # Reference / regular skill: deploy whole folder
    if [[ ! -f "${skill_dir}SKILL.md" ]]; then
      orphan_skills+=("$skill_name (no SKILL.md, no command)")
      continue
    fi
    mkdir -p "$dest"
    rsync "${RSYNC_FLAGS[@]}" "$skill_dir" "$dest"
    reference_count=$((reference_count + 1))

    # Also deploy reference skills into OpenClaw's personal-skills dir so
    # the Aren agent sees them. Action skills are NOT deployed here because
    # their command files use Claude-specific !backtick syntax.
    if [[ -d "$OPENCLAW_SKILLS_ROOT" ]]; then
      mkdir -p "${OPENCLAW_SKILLS_ROOT}/${skill_name}"
      rsync "${RSYNC_FLAGS[@]}" "$skill_dir" "${OPENCLAW_SKILLS_ROOT}/${skill_name}/"
    fi
  fi
done

# Detect orphan commands (command file with no matching skill folder)
if [[ -d "${REPO_ROOT}/commands" ]]; then
  for cmd in "${REPO_ROOT}/commands"/*.md; do
    [[ -f "$cmd" ]] || continue
    cmd_name="$(basename "$cmd" .md)"
    if [[ ! -d "${REPO_ROOT}/skills/${cmd_name}" ]]; then
      orphan_commands+=("$cmd_name")
    fi
  done
fi

ok "skills synced (action: $action_count, reference: $reference_count, skipped: $skipped_count)"

# -- 4. report ---------------------------------------------------------------
if [[ ${#orphan_skills[@]} -gt 0 ]]; then
  header "orphan skills (no command, no SKILL.md)"
  for o in "${orphan_skills[@]}"; do warn "$o"; done
fi

if [[ ${#orphan_commands[@]} -gt 0 ]]; then
  header "orphan commands (no matching skills/{name}/ folder)"
  for o in "${orphan_commands[@]}"; do warn "$o"; done
fi

# -- 5. prompt-shorthand-modes.md symlink -----------------------------------
header "prompt-shorthand-modes.md symlink"
src="${REPO_ROOT}/prompt-shorthand-modes.md"
link="${DEST_ROOT}/prompt-shorthand-modes.md"
if [[ -f "$src" ]]; then
  current="$(readlink "$link" 2>/dev/null || true)"
  if [[ "$current" == "$src" ]]; then
    ok "symlink already points at repo"
  elif [[ $DRY_RUN -eq 1 ]]; then
    warn "would repoint $link -> $src"
  else
    [[ -e "$link" || -L "$link" ]] && rm "$link"
    ln -s "$src" "$link"
    ok "repointed $link -> $src"
  fi
fi

[[ $DRY_RUN -eq 1 ]] && header "DRY RUN — no files written"

bold "done."
