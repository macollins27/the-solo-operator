#!/usr/bin/env bash
# verify.sh — Chapter 22 — MCP servers

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/22-mcp-servers"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-active-servers.txt" \
  "Drill 1 — list every MCP server name from your .mcp.json."
check_nonempty "${DRILL_DIR}/02-state-response.txt" \
  "Drill 2 — capture the response from mcp__course-curriculum__student_state."
check_nonempty "${DRILL_DIR}/03-read-vs-query.txt" \
  "Drill 3 — note which tool Claude used for each of the two questions."

# Drill 2 should mention something state-related
if ! grep -qiE 'chapter|concept|student|current|completed' "${DRILL_DIR}/02-state-response.txt"; then
  echo "FAIL: Drill 2 — 02-state-response.txt doesn't look like a student-state response."
  echo "      It should mention current chapter, completed chapters, or concepts known."
  exit 1
fi

# Drill 3 should mention specific tool names (Read or mcp__)
if ! grep -qiE 'Read|mcp__' "${DRILL_DIR}/03-read-vs-query.txt"; then
  echo "FAIL: Drill 3 — should name the specific tool Claude used (Read, mcp__course-curriculum__..., etc.)."
  exit 1
fi

echo "Chapter 22 verified — MCP server drills complete."
exit 0
