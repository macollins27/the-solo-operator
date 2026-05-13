#!/usr/bin/env bash
# verify.sh — Chapter 40 — The skill iteration protocol

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/40-skill-iteration-protocol"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-target.txt" \
  "Drill 1 — identify the skill + exact failure + skill lines responsible."
check_nonempty "${DRILL_DIR}/02-walkthrough.txt" \
  "Drill 2 — write Steps 3 (invariants), 4 (three test cases), 5 (diff justification)."
check_nonempty "${DRILL_DIR}/03-outcome.txt" \
  "Drill 3 — applied the change OR explicitly decided not to."

# Drill 2 should mention invariants / test cases
if ! grep -qiE 'invariant|test|case|fail|pass|change' "${DRILL_DIR}/02-walkthrough.txt"; then
  echo "FAIL: Drill 2 — should walk through invariants and test cases."
  exit 1
fi

echo "Chapter 40 verified — skill-iteration-protocol drills complete."
exit 0
