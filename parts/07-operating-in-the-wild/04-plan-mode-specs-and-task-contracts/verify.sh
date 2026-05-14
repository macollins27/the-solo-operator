#!/usr/bin/env bash
# verify.sh — Chapter 47 — Operating in the Wild: plan mode and task contracts

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/47-plan-mode-task-contracts"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-plan-classification.txt" \
  "Drill 1 — classify five tasks as plan-first or skip-plan."
check_nonempty "${DRILL_DIR}/02-task-contract.txt" \
  "Drill 2 — write Goal / Context / Constraints / Done When for one task."
check_nonempty "${DRILL_DIR}/03-subagent-dispatch.txt" \
  "Drill 3 — write the four-part subagent dispatch."

CLASS_COUNT=$(grep -Eic 'plan-first|skip-plan|skip plan|plan first' "${DRILL_DIR}/01-plan-classification.txt" || true)
if [ "${CLASS_COUNT}" -lt 5 ]; then
  echo "FAIL: Drill 1 — should classify five tasks as plan-first or skip-plan."
  exit 1
fi

for required in 'Goal' 'Context' 'Constraints' 'Done When'; do
  if ! grep -q "${required}" "${DRILL_DIR}/02-task-contract.txt"; then
    echo "FAIL: Drill 2 — task contract missing section: ${required}"
    exit 1
  fi
done

if ! grep -qiE 'test|verify|screenshot|diff|command|browser|review' "${DRILL_DIR}/02-task-contract.txt"; then
  echo "FAIL: Drill 2 — Done When should include concrete verification artifacts."
  exit 1
fi

for required in 'Objective' 'Output format' 'Tool' 'boundaries|Boundaries'; do
  if ! grep -qE "${required}" "${DRILL_DIR}/03-subagent-dispatch.txt"; then
    echo "FAIL: Drill 3 — subagent dispatch missing: ${required}"
    exit 1
  fi
done

echo "Chapter 47 verified — plan-mode/task-contract drills complete."
exit 0
