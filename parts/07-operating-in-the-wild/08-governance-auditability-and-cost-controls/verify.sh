#!/usr/bin/env bash
# verify.sh — Chapter 51 — Operating in the Wild: governance and cost controls

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/51-governance-cost"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-review-gates.txt" \
  "Drill 1 — define review gates for agent-authored changes."
check_nonempty "${DRILL_DIR}/02-audit-entry.md" \
  "Drill 2 — write an audit log entry for an agent change."
check_nonempty "${DRILL_DIR}/03-cost-controls.md" \
  "Drill 3 — define cost controls and stop conditions."

if ! grep -qiE 'test|typecheck|lint|review|screenshot|approval|protected|security' "${DRILL_DIR}/01-review-gates.txt"; then
  echo "FAIL: Drill 1 — review gates should include checks/review/protected surfaces."
  exit 1
fi

for required in 'actor' 'prompt|ticket' 'tool' 'changed|files' 'verification' 'reviewer|decision'; do
  if ! grep -qiE "${required}" "${DRILL_DIR}/02-audit-entry.md"; then
    echo "FAIL: Drill 2 — audit entry missing: ${required}"
    exit 1
  fi
done

if ! grep -qiE 'small|fast|workhorse|strongest|limit|cap|stop|budget|cost' "${DRILL_DIR}/03-cost-controls.md"; then
  echo "FAIL: Drill 3 — cost controls should mention model tiers, limits, and stop conditions."
  exit 1
fi

echo "Chapter 51 verified — governance/cost-control drills complete."
exit 0
