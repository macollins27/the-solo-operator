#!/usr/bin/env bash
# verify.sh — Chapter 35 — Hero level: the MCP federation

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/35-mcp-federation"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-my-federation.txt" \
  "Drill 1 — list current MCP servers + what each exposes."
check_nonempty "${DRILL_DIR}/02-missing-server.txt" \
  "Drill 2 — describe a missing server you'd add."
check_nonempty "${DRILL_DIR}/03-mcp-first.txt" \
  "Drill 3 — show the CLAUDE.md update adding the MCP-first protocol."

echo "Chapter 35 verified — MCP federation drills complete."
exit 0
