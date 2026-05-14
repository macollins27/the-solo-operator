#!/usr/bin/env bash
# verify.sh — Chapter 44 — Operating in the Wild: origin and public canon

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/44-origin-and-public-canon"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-origin-bias.txt" \
  "Drill 1 — explain the course origin and bias."
check_nonempty "${DRILL_DIR}/02-public-canon-map.txt" \
  "Drill 2 — map three public references against the course."
check_nonempty "${DRILL_DIR}/03-operating-stance.txt" \
  "Drill 3 — write a portable operating stance for AGENTS.md."

if ! grep -qiE 'field|bias|universal|origin' "${DRILL_DIR}/01-origin-bias.txt"; then
  echo "FAIL: Drill 1 — should name the field-tested origin and non-universal bias."
  exit 1
fi

if ! grep -qiE 'Boris|Simon|Obra|Anthropic|public|canon' "${DRILL_DIR}/02-public-canon-map.txt"; then
  echo "FAIL: Drill 2 — should reference at least one public workflow/canon item from the chapter."
  exit 1
fi

if ! grep -qiE 'AGENTS.md|portable|verify|verification|done' "${DRILL_DIR}/03-operating-stance.txt"; then
  echo "FAIL: Drill 3 — should mention portable instructions and verification before done."
  exit 1
fi

echo "Chapter 44 verified — origin and public-canon drills complete."
exit 0
