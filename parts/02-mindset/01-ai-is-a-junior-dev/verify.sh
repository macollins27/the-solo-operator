#!/usr/bin/env bash
# verify.sh — Chapter 9 — AI is a Junior Dev

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/09-ai-is-a-junior-dev"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-vague-assumptions.txt" \
  "Drill 1 — list 3 assumptions Claude made on the vague task."
check_nonempty "${DRILL_DIR}/02-specific-interaction.txt" \
  "Drill 2 — write 3-5 sentences on how the specific-prompt interaction differed."
check_nonempty "${DRILL_DIR}/03-things-id-tell-a-new-hire.txt" \
  "Drill 3 — list 4-6 things you'd tell a brand-new engineer on their first day."

# Drill 1 — should have at least 3 entries
LINES=$(grep -c '\S' "${DRILL_DIR}/01-vague-assumptions.txt" 2>/dev/null || echo 0)
if [ "${LINES}" -lt 3 ]; then
  echo "FAIL: Drill 1 — 01-vague-assumptions.txt has ${LINES} non-empty lines; need at least 3."
  exit 1
fi

# Drill 2 — should have substantial content (not just one word)
WORDS=$(wc -w < "${DRILL_DIR}/02-specific-interaction.txt")
if [ "${WORDS}" -lt 20 ]; then
  echo "FAIL: Drill 2 — 02-specific-interaction.txt has only ${WORDS} words; expected 3-5 sentences."
  exit 1
fi

# Drill 3 — should have at least 4 lines
HIRE_LINES=$(grep -c '\S' "${DRILL_DIR}/03-things-id-tell-a-new-hire.txt" 2>/dev/null || echo 0)
if [ "${HIRE_LINES}" -lt 4 ]; then
  echo "FAIL: Drill 3 — 03-things-id-tell-a-new-hire.txt has ${HIRE_LINES} non-empty lines; need at least 4."
  exit 1
fi

echo "Chapter 9 verified — junior-dev mental-model drills complete."
exit 0
