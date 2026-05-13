#!/usr/bin/env bash
# verify.sh — Chapter 13 — Decisions Belong to You

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/13-decisions-belong-to-you"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-what-i-got.txt" \
  "Drill 1 — note whether Claude gave you a menu or a recommendation."
check_nonempty "${DRILL_DIR}/02-recommendation.txt" \
  "Drill 2 — capture the recommendation Claude proposed after redirecting."
check_nonempty "${DRILL_DIR}/03-with-instruction.txt" \
  "Drill 3 — observe how a pre-emptive 'no menus' instruction changed the response."

# Drill 1 should mention 'menu' or 'recommendation'
if ! grep -qiE 'menu|recommend' "${DRILL_DIR}/01-what-i-got.txt"; then
  echo "FAIL: Drill 1 — 01-what-i-got.txt should classify the response as menu or recommendation."
  exit 1
fi

echo "Chapter 13 verified — decisions-belong-to-you drills complete."
exit 0
