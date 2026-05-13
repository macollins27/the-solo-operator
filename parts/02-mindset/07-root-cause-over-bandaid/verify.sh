#!/usr/bin/env bash
# verify.sh — Chapter 15 — Root Cause > Bandaid

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/15-root-cause-over-bandaid"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-error.txt" \
  "Drill 1 — capture the error message after introducing the bug."
check_nonempty "${DRILL_DIR}/02-without-guidance.txt" \
  "Drill 2 — describe (or paste) Claude's fix when asked without guidance."
check_nonempty "${DRILL_DIR}/03-with-rule.txt" \
  "Drill 3 — observe how the explicit 'find the mechanism' instruction changed the fix."

W2=$(wc -w < "${DRILL_DIR}/02-without-guidance.txt")
W3=$(wc -w < "${DRILL_DIR}/03-with-rule.txt")
if [ "${W2}" -lt 10 ] || [ "${W3}" -lt 10 ]; then
  echo "FAIL: Drills 2 and 3 should each be at least a couple sentences."
  echo "      Drill 2: ${W2} words, Drill 3: ${W3} words (need ≥10 each)"
  exit 1
fi

echo "Chapter 15 verified — root-cause-over-bandaid drills complete."
exit 0
