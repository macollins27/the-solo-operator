#!/usr/bin/env bash
# verify.sh — Chapter 53 — Operating in the Wild: portable agent operating system

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/53-portable-agent-os"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-system-map.txt" \
  "Drill 1 — list your portable agent operating system files."
check_nonempty "${DRILL_DIR}/02-first-session-protocol.txt" \
  "Drill 2 — write a first-session protocol."
check_nonempty "${DRILL_DIR}/03-gap-audit.txt" \
  "Drill 3 — audit the system and pick top repairs."

if ! grep -qiE 'AGENTS.md|CLAUDE.md|setup|security|review|cost|learning|eval' "${DRILL_DIR}/01-system-map.txt"; then
  echo "FAIL: Drill 1 — system map should include instruction, setup, security, review/cost, learning/eval artifacts."
  exit 1
fi

for required in 'AGENTS.md' 'handoff' 'setup' 'protected' 'contract'; do
  if ! grep -qi "${required}" "${DRILL_DIR}/02-first-session-protocol.txt"; then
    echo "FAIL: Drill 2 — first-session protocol missing: ${required}"
    exit 1
  fi
done

if ! grep -qiE 'present|missing|weak|repair|gap' "${DRILL_DIR}/03-gap-audit.txt"; then
  echo "FAIL: Drill 3 — gap audit should mark present/missing/weak items and repairs."
  exit 1
fi

echo "Chapter 53 verified — portable-agent-operating-system drills complete."
exit 0
