#!/usr/bin/env bash
# verify.sh — Chapter 42 — The consolidation pattern

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/42-consolidation-pattern"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-clusters.txt" \
  "Drill 1 — list any clusters of related feedback files."
check_nonempty "${DRILL_DIR}/02-consolidated-rule.txt" \
  "Drill 2 — draft a consolidated rule + the files it absorbs."
check_nonempty "${DRILL_DIR}/03-drop-log-template.txt" \
  "Drill 3 — path to your drop-log template."

if [ ! -s "${STUDENT_ROOT}/feedback/SYNTHESIS-DROPPED-TEMPLATE.md" ]; then
  echo "FAIL: Drill 3 — expected ${STUDENT_ROOT}/feedback/SYNTHESIS-DROPPED-TEMPLATE.md"
  exit 1
fi

# Template should have the four section categories
for category in 'already in claudemd|already-in-claude|already in CLAUDE' 'superseded' 'derivable' 'consolidated'; do
  if ! grep -qiE "${category}" "${STUDENT_ROOT}/feedback/SYNTHESIS-DROPPED-TEMPLATE.md"; then
    echo "FAIL: Drill 3 — template missing section matching: ${category}"
    exit 1
  fi
done

echo "Chapter 42 verified — consolidation-pattern drills complete."
exit 0
