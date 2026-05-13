#!/usr/bin/env bash
# verify.sh — Chapter 6 — The conversation loop and context window

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/06-conversation-loop-and-context"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-my-conversation.txt" \
  "Drill 1 — write the turn count + tool-call count from a short session."
check_nonempty "${DRILL_DIR}/02-memory-test.txt" \
  "Drill 2 — save Claude's response when asked to recall '7,341' within the same session."
check_nonempty "${DRILL_DIR}/03-session-boundary.txt" \
  "Drill 3 — save Claude's response when asked to recall '7,341' in a NEW session."

# Drill 1 should mention turn count or number
if ! grep -qiE 'turn|[0-9]' "${DRILL_DIR}/01-my-conversation.txt"; then
  echo "FAIL: Drill 1 — 01-my-conversation.txt should mention turn count."
  exit 1
fi

# Drill 2 — student's transcript should mention the number (Claude remembered)
if ! grep -qE '7[,]?341' "${DRILL_DIR}/02-memory-test.txt"; then
  echo "FAIL: Drill 2 — Claude's response should have included the number 7,341."
  echo "      If it didn't, the conversation got long enough to drop it OR you forgot to give it. Re-run."
  exit 1
fi

# Drill 3 — student's transcript should show Claude did NOT recall.
# We can't easily detect a negative, so just require non-empty content (handled above).

echo "Chapter 6 verified — conversation-loop drills complete."
exit 0
