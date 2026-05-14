#!/usr/bin/env bash
# verify.sh — Chapter 50 — Operating in the Wild: parallel work and orchestration

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/50-parallel-orchestration"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-worktree-plan.md" \
  "Drill 1 — write a worktree plan."
check_nonempty "${DRILL_DIR}/02-effort-scaling.txt" \
  "Drill 2 — classify four tasks by parallel effort."
check_nonempty "${DRILL_DIR}/03-dispatch-pack.txt" \
  "Drill 3 — write two bounded read-only audit dispatches."

for required in 'Branch' 'Directory' 'ports' 'database' 'Merge'; do
  if ! grep -qi "${required}" "${DRILL_DIR}/01-worktree-plan.md"; then
    echo "FAIL: Drill 1 — worktree plan missing: ${required}"
    exit 1
  fi
done

EFFORT_COUNT=$(grep -Eic 'one agent|1 agent|two|three|four|2-4|no parallel|parallel' "${DRILL_DIR}/02-effort-scaling.txt" || true)
if [ "${EFFORT_COUNT}" -lt 4 ]; then
  echo "FAIL: Drill 2 — should classify four tasks by effort/parallelism."
  exit 1
fi

for required in 'Objective' 'Output format' 'Tool' 'boundaries|Boundaries' 'artifact|Artifact'; do
  if ! grep -qEi "${required}" "${DRILL_DIR}/03-dispatch-pack.txt"; then
    echo "FAIL: Drill 3 — dispatch pack missing: ${required}"
    exit 1
  fi
done

echo "Chapter 50 verified — parallel-orchestration drills complete."
exit 0
