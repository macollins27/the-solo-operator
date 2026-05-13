#!/usr/bin/env bash
# verify.sh — Chapter 39 — When to write a rule vs. a hook

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/39-rule-vs-hook"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-bite-audit.txt" \
  "Drill 1 — predict the future home of each feedback file."
check_nonempty "${DRILL_DIR}/02-promotion.txt" \
  "Drill 2 — show one feedback file promoted to its next layer."
check_nonempty "${DRILL_DIR}/03-prediction.txt" \
  "Drill 3 — predict a future bite + decide its layer."

# Drill 1 should mention layers
if ! grep -qiE 'feedback|claudemd|hook|ast.grep|classifier|skill' "${DRILL_DIR}/01-bite-audit.txt"; then
  echo "FAIL: Drill 1 — should map feedback files to specific enforcement layers."
  exit 1
fi

echo "Chapter 39 verified — rule-vs-hook drills complete."
exit 0
