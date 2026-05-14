#!/usr/bin/env bash
# verify.sh — Chapter 48 — Operating in the Wild: learning loops and workflow evals

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/48-learning-loops-evals"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${STUDENT_ROOT}/learnings.md" \
  "Drill 1 — create or update student/learnings.md."
check_nonempty "${DRILL_DIR}/01-learnings-excerpt.txt" \
  "Drill 1 — save an excerpt with three atomic learnings."
check_nonempty "${DRILL_DIR}/02-promotion-decision.txt" \
  "Drill 2 — decide where one learning should be promoted."
check_nonempty "${DRILL_DIR}/03-workflow-eval.txt" \
  "Drill 3 — write a workflow eval for the promoted learning."

LEARNING_LINES=$(grep -Ec '^- |^[0-9]+\\.' "${DRILL_DIR}/01-learnings-excerpt.txt" || true)
if [ "${LEARNING_LINES}" -lt 3 ]; then
  echo "FAIL: Drill 1 — excerpt should contain at least three atomic learning bullets."
  exit 1
fi

if ! grep -qiE 'AGENTS.md|CLAUDE.md|skill|hook|MCP|tool|learnings.md|automation' "${DRILL_DIR}/02-promotion-decision.txt"; then
  echo "FAIL: Drill 2 — promotion decision should name the target layer."
  exit 1
fi

for required in 'task' 'pass' 'fail' 'evidence'; do
  if ! grep -qi "${required}" "${DRILL_DIR}/03-workflow-eval.txt"; then
    echo "FAIL: Drill 3 — workflow eval missing: ${required}"
    exit 1
  fi
done

echo "Chapter 48 verified — learning-loop/workflow-eval drills complete."
exit 0
