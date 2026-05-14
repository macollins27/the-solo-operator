#!/usr/bin/env bash
# verify.sh — Chapter 23 — Subagents and parallel work

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/23-subagents-and-parallel"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-fresh-result.txt" \
  "Drill 1 — capture the minimal-context Task dispatch's return summary."
check_nonempty "${DRILL_DIR}/02-fork-result.txt" \
  "Drill 2 — capture the long-context Task dispatch's return summary."
check_nonempty "${DRILL_DIR}/03-context-growth.txt" \
  "Drill 3 — note how much each subagent's output added to context (Claude's estimate)."

echo "Chapter 23 verified — subagent dispatch drills complete."
exit 0
