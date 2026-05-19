#!/usr/bin/env bash
# SessionEnd hook — archive transcript into AE space for KB ingestion.
#
# Stdin JSON: { session_id, transcript_path, cwd, reason, ... }
# Writes to ~/base/spaces/ae/claude-code-sessions/ per CLAUDE.md filename
# convention {YYYYMMDD}_{hash6}.{ext}:
#   <base>.jsonl       — raw transcript (immutable archive)
#   <base>.meta.json   — self-contained sidecar
#
# Token / cost / summary analysis is intentionally NOT done here. The raw
# .jsonl has everything; a Claude subagent can derive metrics on demand.

set -uo pipefail

DEST_DIR="$HOME/base/spaces/ae/claude-code-sessions"
mkdir -p "$DEST_DIR"

INPUT=$(cat)
SESSION_ID=$(printf '%s' "$INPUT" | jq -r '.session_id // ""')
TRANSCRIPT=$(printf '%s' "$INPUT" | jq -r '.transcript_path // ""')
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // ""')
REASON=$(printf '%s' "$INPUT" | jq -r '.reason // "unknown"')

[ -z "$SESSION_ID" ] && exit 0

DATE=$(date +%Y%m%d)
HASH6=$(printf '%s' "$SESSION_ID" | tr -d '-' | cut -c1-6)
BASE="${DATE}_${HASH6}"

if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  cp "$TRANSCRIPT" "${DEST_DIR}/${BASE}.jsonl" 2>/dev/null || true
fi

jq -n \
  --arg space "ae" \
  --arg session_id "$SESSION_ID" \
  --arg ended_at "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg reason "$REASON" \
  --arg cwd "$CWD" \
  --arg machine "${FLEET_MACHINE:-$(hostname -s)}" \
  --arg source "$TRANSCRIPT" \
  '{
    kind: "claude-code-session",
    space: $space,
    session_id: $session_id,
    ended_at: $ended_at,
    reason: $reason,
    cwd: $cwd,
    machine: $machine,
    source_transcript_path: $source
  }' > "${DEST_DIR}/${BASE}.meta.json"

exit 0
