#!/usr/bin/env bash
# verify.sh — Chapter 38 — Hero level: the trust-calibration arc

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/38-trust-calibration"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-my-stage.txt" \
  "Drill 1 — assess your current trust stage."
check_nonempty "${DRILL_DIR}/02-guards-vs-supervision.txt" \
  "Drill 2 — map your mechanical guards to the supervision they replace."
check_nonempty "${DRILL_DIR}/03-next-guard.txt" \
  "Drill 3 — propose one concrete next guard to add."

# Drill 1 should mention a stage
if ! grep -qiE 'stage|level|[1-4]' "${DRILL_DIR}/01-my-stage.txt"; then
  echo "FAIL: Drill 1 — should identify a specific stage (1-4)."
  exit 1
fi

echo "Chapter 38 verified — trust-calibration drills complete. Part 5 (Hero Level) is done."
exit 0
