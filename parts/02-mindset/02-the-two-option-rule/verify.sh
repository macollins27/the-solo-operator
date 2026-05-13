#!/usr/bin/env bash
# verify.sh — Chapter 10 — The Two-Option Rule

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/10-two-option-rule"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-planted-bug.txt" \
  "Drill 1 — document the bug you planted: file path, what you changed, what you expect to break."
check_nonempty "${DRILL_DIR}/02-what-claude-did.txt" \
  "Drill 2 — observe Claude's behavior without the rule; did it surface, fix, or skip the bug?"
check_nonempty "${DRILL_DIR}/03-with-the-rule.txt" \
  "Drill 3 — same scenario, this time prompted with the Two-Option Rule. Note what's different."

# Drill 1 should name a file path and what changed
WORDS=$(wc -w < "${DRILL_DIR}/01-planted-bug.txt")
if [ "${WORDS}" -lt 8 ]; then
  echo "FAIL: Drill 1 — 01-planted-bug.txt has only ${WORDS} words; expected file path + what changed + what should break."
  exit 1
fi

# Drills 2 and 3 should be observational paragraphs
W2=$(wc -w < "${DRILL_DIR}/02-what-claude-did.txt")
W3=$(wc -w < "${DRILL_DIR}/03-with-the-rule.txt")
if [ "${W2}" -lt 15 ] || [ "${W3}" -lt 15 ]; then
  echo "FAIL: Drills 2 and 3 should each be at least a few sentences of observation."
  echo "      Drill 2 words: ${W2}, Drill 3 words: ${W3} (need ≥15 each)"
  exit 1
fi

echo "Chapter 10 verified — Two-Option Rule drills complete."
exit 0
