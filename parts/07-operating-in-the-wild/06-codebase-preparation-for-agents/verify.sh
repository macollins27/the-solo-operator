#!/usr/bin/env bash
# verify.sh — Chapter 49 — Operating in the Wild: codebase preparation

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/49-codebase-preparation"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-setup-checklist.md" \
  "Drill 1 — fill out the agent setup checklist for your project."
check_nonempty "${DRILL_DIR}/02-failure-signal.txt" \
  "Drill 2 — write a before/after failure signal."
check_nonempty "${DRILL_DIR}/03-setup-contract.txt" \
  "Drill 3 — write the setup contract for AGENTS.md."

if ! grep -qiE 'install|dev server|typecheck|test|seed|database|protected' "${DRILL_DIR}/01-setup-checklist.md"; then
  echo "FAIL: Drill 1 — checklist should cover setup, checks, seed/database, and protected paths."
  exit 1
fi

if ! grep -qiE 'expected|actual|input|id|repro|before|after' "${DRILL_DIR}/02-failure-signal.txt"; then
  echo "FAIL: Drill 2 — failure signal should include expected/actual and debugging context."
  exit 1
fi

for required in 'Install' 'Dev' 'Typecheck' 'Test' 'Seed' 'Protected'; do
  if ! grep -qi "${required}" "${DRILL_DIR}/03-setup-contract.txt"; then
    echo "FAIL: Drill 3 — setup contract missing: ${required}"
    exit 1
  fi
done

echo "Chapter 49 verified — codebase-preparation drills complete."
exit 0
