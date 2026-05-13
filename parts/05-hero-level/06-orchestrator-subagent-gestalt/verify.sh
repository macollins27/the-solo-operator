#!/usr/bin/env bash
# verify.sh — Chapter 37 — Hero level: the orchestrator + subagent gestalt

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/37-orchestrator-gestalt"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-my-pattern.txt" \
  "Drill 1 — describe your current orchestrator pattern."
check_nonempty "${DRILL_DIR}/02-parallel-returns.txt" \
  "Drill 2 — capture three parallel subagent returns."
check_nonempty "${DRILL_DIR}/03-dispatch-template.txt" \
  "Drill 3 — write a reusable dispatch prompt template."

# Drill 3 should mention skill mandate / forbidden / structured return
if ! grep -qiE 'skill|forbidden|structured|return|format' "${DRILL_DIR}/03-dispatch-template.txt"; then
  echo "FAIL: Drill 3 — dispatch template should include skill mandate / forbidden list / structured return spec."
  exit 1
fi

echo "Chapter 37 verified — orchestrator-gestalt drills complete."
exit 0
