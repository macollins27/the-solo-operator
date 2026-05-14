#!/usr/bin/env bash
# verify.sh — Chapter 46 — Operating in the Wild: task, tool, and model selection

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/46-task-tool-model-selection"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-surface-choices.txt" \
  "Drill 1 — classify five tasks by agent surface."
check_nonempty "${DRILL_DIR}/02-model-routing.txt" \
  "Drill 2 — route the same five tasks to model tiers."
check_nonempty "${DRILL_DIR}/03-ai-ready-ticket.txt" \
  "Drill 3 — write one AI-ready ticket with Goal, Context, Constraints, Done When."

SURFACE_COUNT=$(grep -Eic 'autocomplete|chat|local agent|subagent|worktree|background|cloud|automation' "${DRILL_DIR}/01-surface-choices.txt" || true)
if [ "${SURFACE_COUNT}" -lt 5 ]; then
  echo "FAIL: Drill 1 — should classify five tasks using the chapter's surfaces."
  exit 1
fi

MODEL_COUNT=$(grep -Eic 'small|fast|workhorse|strongest|model|tier' "${DRILL_DIR}/02-model-routing.txt" || true)
if [ "${MODEL_COUNT}" -lt 5 ]; then
  echo "FAIL: Drill 2 — should route five tasks to model tiers with reasoning."
  exit 1
fi

for required in 'Goal' 'Context' 'Constraints' 'Done When'; do
  if ! grep -q "${required}" "${DRILL_DIR}/03-ai-ready-ticket.txt"; then
    echo "FAIL: Drill 3 — ticket missing section: ${required}"
    exit 1
  fi
done

if ! grep -qiE 'test|verify|screenshot|diff|command|check|done' "${DRILL_DIR}/03-ai-ready-ticket.txt"; then
  echo "FAIL: Drill 3 — ticket should include verification commands or artifacts."
  exit 1
fi

echo "Chapter 46 verified — task/tool/model-selection drills complete."
exit 0
