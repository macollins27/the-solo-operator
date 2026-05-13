#!/usr/bin/env bash
# verify.sh — Chapter 41 — The supersession pattern

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/41-supersession-pattern"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-candidate.txt" \
  "Drill 1 — name an artifact + why it should be superseded."
check_nonempty "${DRILL_DIR}/02-diff.txt" \
  "Drill 2 — show the supersession diff."
check_nonempty "${DRILL_DIR}/03-reason-sharpening.txt" \
  "Drill 3 — before/after sharpening of the supersession reason."

# Drill 2 should mention SUPERSEDED
if ! grep -qiE 'SUPERSEDED|superseded' "${DRILL_DIR}/02-diff.txt"; then
  echo "FAIL: Drill 2 — diff should contain the SUPERSEDED marker."
  exit 1
fi

echo "Chapter 41 verified — supersession-pattern drills complete."
exit 0
