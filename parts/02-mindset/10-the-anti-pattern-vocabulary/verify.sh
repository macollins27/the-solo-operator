#!/usr/bin/env bash
# verify.sh — Chapter 18 — The Anti-Pattern Vocabulary

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/18-the-anti-pattern-vocabulary"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-spot-them.txt" \
  "Drill 1 — list the anti-pattern numbers you spotted in the constructed transcript."
check_nonempty "${DRILL_DIR}/02-caught-one.txt" \
  "Drill 2 — paste the offending phrase from a real session + the anti-pattern number."
check_nonempty "${DRILL_DIR}/03-my-redirects.txt" \
  "Drill 3 — 3 interventions, one per anti-pattern."

# Drill 1 should reference at least 3 anti-pattern numbers (1-20)
SPOT_NUMS=$(grep -oE '#?(1[0-9]|20|[1-9])' "${DRILL_DIR}/01-spot-them.txt" | wc -l | tr -d ' ')
if [ "${SPOT_NUMS}" -lt 3 ]; then
  echo "FAIL: Drill 1 — should identify at least 3 anti-pattern numbers in the constructed transcript."
  echo "      Found ${SPOT_NUMS}."
  exit 1
fi

# Drill 3 should have at least 3 redirect lines
REDIRECT_LINES=$(grep -c '\S' "${DRILL_DIR}/03-my-redirects.txt" 2>/dev/null || echo 0)
if [ "${REDIRECT_LINES}" -lt 3 ]; then
  echo "FAIL: Drill 3 — 03-my-redirects.txt has ${REDIRECT_LINES} non-empty lines; need at least 3 redirects."
  exit 1
fi

echo "Chapter 18 verified — anti-pattern vocabulary drills complete. Part 2 (Mindset) is done."
exit 0
