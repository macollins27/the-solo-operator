#!/usr/bin/env bash
# verify.sh — Chapter 19 — CLAUDE.md

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/19-claudemd"

# Drill 1 — student authored a CLAUDE.md
if [ ! -s "${STUDENT_ROOT}/CLAUDE.md" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${STUDENT_ROOT}/CLAUDE.md"
  echo "      Author your first CLAUDE.md with project description, 3 rules, authority hierarchy, forbidden section."
  exit 1
fi

# Check for required sections (case-insensitive)
for required in 'rules' 'forbidden' 'authority|hierarchy'; do
  if ! grep -qiE "${required}" "${STUDENT_ROOT}/CLAUDE.md"; then
    echo "FAIL: Drill 1 — CLAUDE.md is missing a section matching: ${required}"
    exit 1
  fi
done

# Word count sanity: CLAUDE.md should be 50-1500 words (not a 5000-word essay, not a one-liner)
WORDS=$(wc -w < "${STUDENT_ROOT}/CLAUDE.md")
if [ "${WORDS}" -lt 50 ]; then
  echo "FAIL: Drill 1 — CLAUDE.md is only ${WORDS} words. Add at least standing rules + authority + forbidden."
  exit 1
fi
if [ "${WORDS}" -gt 1500 ]; then
  echo "FAIL: Drill 1 — CLAUDE.md is ${WORDS} words. Too long; keep it scannable. Move prose into docs/."
  exit 1
fi

# Drill 2 — Claude summary
if [ ! -s "${DRILL_DIR}/01-claude-summary.txt" ]; then
  echo "FAIL: Drill 2 — expected non-empty ${DRILL_DIR}/01-claude-summary.txt"
  echo "      Ask Claude to summarize your CLAUDE.md and paste the response."
  exit 1
fi

# Drill 3 — promoted rule note
if [ ! -s "${DRILL_DIR}/02-promoted-rule.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/02-promoted-rule.txt"
  echo "      Note which rule you promoted from feedback corpus into CLAUDE.md."
  exit 1
fi

echo "Chapter 19 verified — CLAUDE.md authored, summarized, and promoted from feedback."
exit 0
