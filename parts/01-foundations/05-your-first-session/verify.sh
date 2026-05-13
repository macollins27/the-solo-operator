#!/usr/bin/env bash
# verify.sh — Chapter 5 — Your first Claude Code session

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/05-your-first-session"

# Drill 1 — README summary captured
if [ ! -s "${DRILL_DIR}/01-readme-summary.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-readme-summary.txt"
  echo "      Ask Claude to summarize the README in 3 sentences, save the reply."
  exit 1
fi

WORDS=$(wc -w < "${DRILL_DIR}/01-readme-summary.txt")
if [ "${WORDS}" -lt 15 ]; then
  echo "FAIL: Drill 1 — 01-readme-summary.txt has only ${WORDS} words; expected a 3-sentence summary."
  exit 1
fi

# Drill 2 — permission observation
if [ ! -s "${DRILL_DIR}/02-permission-observation.txt" ]; then
  echo "FAIL: Drill 2 — expected non-empty ${DRILL_DIR}/02-permission-observation.txt"
  echo "      Write one or two sentences about the permission prompt you saw (or didn't see)."
  exit 1
fi

# Drill 3 — three tool names listed
if [ ! -s "${DRILL_DIR}/03-tools-i-saw.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/03-tools-i-saw.txt"
  echo "      List 3 tool names you saw Claude use, one per line."
  exit 1
fi

LINES=$(grep -c '\S' "${DRILL_DIR}/03-tools-i-saw.txt" 2>/dev/null || echo 0)
if [ "${LINES}" -lt 3 ]; then
  echo "FAIL: Drill 3 — 03-tools-i-saw.txt has ${LINES} non-empty lines; need at least 3."
  exit 1
fi

echo "Chapter 5 verified — first-session drills complete."
exit 0
