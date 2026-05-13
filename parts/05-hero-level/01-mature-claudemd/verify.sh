#!/usr/bin/env bash
# verify.sh — Chapter 32 — Hero level: the mature CLAUDE.md

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/32-mature-claudemd"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-current-state.txt" \
  "Drill 1 — assess your current CLAUDE.md (rule count, structure)."
check_nonempty "${DRILL_DIR}/02-three-rules.txt" \
  "Drill 2 — add three incident-authored rules to your CLAUDE.md and show the diff."
check_nonempty "${DRILL_DIR}/03-trim-and-link.txt" \
  "Drill 3 — show one trim + one subdoc link added to CLAUDE.md."

# Drill 2 — should show three new lines (rules), with chapter references
RULES_LINES=$(grep -c '\S' "${DRILL_DIR}/02-three-rules.txt" 2>/dev/null || echo 0)
if [ "${RULES_LINES}" -lt 3 ]; then
  echo "FAIL: Drill 2 — should have at least 3 new rule lines."
  exit 1
fi

echo "Chapter 32 verified — mature-CLAUDE.md drills complete."
exit 0
