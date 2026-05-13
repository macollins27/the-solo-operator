#!/usr/bin/env bash
# verify.sh — Chapter 43 — Building YOUR system over time
# Final chapter of the course.

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/43-building-your-system"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-day-one.md" \
  "Drill 1 — write a day-one plan for your own project."
check_nonempty "${DRILL_DIR}/02-three-bites.txt" \
  "Drill 2 — predict three likely bites + your response."
check_nonempty "${DRILL_DIR}/03-consolidation-cadence.txt" \
  "Drill 3 — commit to a specific consolidation cadence."

# Drill 3 should name a date or a trigger
if ! grep -qiE '[0-9]+|quarterly|monthly|every|trigger|threshold' "${DRILL_DIR}/03-consolidation-cadence.txt"; then
  echo "FAIL: Drill 3 — should name a specific cadence (date / interval / trigger)."
  exit 1
fi

echo "Chapter 43 verified — building-your-system drills complete."
echo ""
echo "==============================================="
echo "  CONGRATULATIONS — Course complete."
echo "  Now go build."
echo "==============================================="
exit 0
