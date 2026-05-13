#!/usr/bin/env bash
# verify.sh — Chapter 7 — Reading Claude's tool calls

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/07-reading-tool-calls"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-session-map.txt" \
  "Drill 1 — list each tool call you saw in order: 'ToolName — what it operated on'."
check_nonempty "${DRILL_DIR}/02-prediction.txt" \
  "Drill 2 — predict which tool(s) Claude would use for each task. One task per line."
check_nonempty "${DRILL_DIR}/03-prediction-vs-reality.txt" \
  "Drill 3 — pick one task, run it, write a comparison of prediction vs reality."

# Drill 1 should mention at least 2 tool names
SESSION_HITS=$(grep -ciE 'read|write|edit|bash|grep|glob|task' "${DRILL_DIR}/01-session-map.txt" || true)
if [ "${SESSION_HITS}" -lt 2 ]; then
  echo "FAIL: Drill 1 — 01-session-map.txt should mention at least 2 different tool calls."
  echo "      Expected lines like 'Read — path/to/file' or 'Glob — pattern'."
  exit 1
fi

# Drill 2 should have at least 4 non-empty lines (one per task)
PRED_LINES=$(grep -c '\S' "${DRILL_DIR}/02-prediction.txt" 2>/dev/null || echo 0)
if [ "${PRED_LINES}" -lt 4 ]; then
  echo "FAIL: Drill 2 — 02-prediction.txt has ${PRED_LINES} non-empty lines; need at least 4 (one per task)."
  exit 1
fi

# Drill 3 should mention at least one tool name (showing prediction-vs-reality involves naming tools)
if ! grep -qiE 'read|write|edit|bash|grep|glob|task' "${DRILL_DIR}/03-prediction-vs-reality.txt"; then
  echo "FAIL: Drill 3 — 03-prediction-vs-reality.txt should mention at least one specific tool name."
  exit 1
fi

echo "Chapter 7 verified — tool-call literacy drills complete."
exit 0
