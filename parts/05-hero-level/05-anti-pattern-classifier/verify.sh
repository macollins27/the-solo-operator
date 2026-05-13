#!/usr/bin/env bash
# verify.sh — Chapter 36 — Hero level: the anti-pattern classifier

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/36-anti-pattern-classifier"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-architecture.txt" \
  "Drill 1 — sketch the classifier's data flow."

STUB="${STUDENT_ROOT}/.claude/hooks/anti-pattern-classifier-stub.sh"
if [ ! -s "${STUB}" ]; then
  echo "FAIL: Drill 2 — expected stub hook at ${STUB}"
  exit 1
fi

check_nonempty "${DRILL_DIR}/02-stub-path.txt" \
  "Drill 2 — path to the stub classifier hook."
check_nonempty "${DRILL_DIR}/03-twenty-first-pattern.txt" \
  "Drill 3 — propose a 21st anti-pattern in the catalog's format."

# Drill 1 should mention stdin/jq/claude or describe the flow elements
if ! grep -qiE 'stdin|message|catalog|claude|json|schema' "${DRILL_DIR}/01-architecture.txt"; then
  echo "FAIL: Drill 1 — architecture sketch should name the key components."
  exit 1
fi

# Drill 3 should mention recognition phrases / why bad / what to do instead
if ! grep -qiE 'recogn|phrase|why|instead' "${DRILL_DIR}/03-twenty-first-pattern.txt"; then
  echo "FAIL: Drill 3 — should follow catalog format (recognition phrases / why / what to do instead)."
  exit 1
fi

echo "Chapter 36 verified — anti-pattern classifier drills complete."
exit 0
