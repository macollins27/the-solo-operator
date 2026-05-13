#!/usr/bin/env bash
# verify.sh — Chapter 17 — The Authority Hierarchy

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/17-the-authority-hierarchy"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-my-hierarchy.txt" \
  "Drill 1 — rank at least 5 sources of truth in your project from highest to lowest authority."
check_nonempty "${DRILL_DIR}/02-citation-analysis.txt" \
  "Drill 2 — identify the source Claude cited + its hierarchy rank."
check_nonempty "${DRILL_DIR}/03-promoted-decision.txt" \
  "Drill 3 — record the file path + the decision you promoted from chat to durable storage."

# Drill 1 — at least 5 lines
H_LINES=$(grep -c '\S' "${DRILL_DIR}/01-my-hierarchy.txt" 2>/dev/null || echo 0)
if [ "${H_LINES}" -lt 5 ]; then
  echo "FAIL: Drill 1 — 01-my-hierarchy.txt has ${H_LINES} non-empty lines; need at least 5."
  exit 1
fi

# Drill 2 — should mention rank or authority or hierarchy
if ! grep -qiE 'rank|authority|hierarchy' "${DRILL_DIR}/02-citation-analysis.txt"; then
  echo "FAIL: Drill 2 — 02-citation-analysis.txt should classify the citation's rank/authority."
  exit 1
fi

echo "Chapter 17 verified — authority-hierarchy drills complete."
exit 0
