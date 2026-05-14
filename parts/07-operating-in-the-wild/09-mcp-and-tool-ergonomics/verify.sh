#!/usr/bin/env bash
# verify.sh — Chapter 52 — Operating in the Wild: MCP and tool ergonomics

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/52-mcp-tool-ergonomics"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-tool-contract.md" \
  "Drill 1 — audit or design one MCP tool contract."
check_nonempty "${DRILL_DIR}/02-ergonomics-improvement.txt" \
  "Drill 2 — rewrite one weak part of the tool contract."
check_nonempty "${DRILL_DIR}/03-tool-eval.txt" \
  "Drill 3 — write a tool-choice/use eval."

for required in 'name' 'parameter' 'response' 'safety' 'verification'; do
  if ! grep -qi "${required}" "${DRILL_DIR}/01-tool-contract.md"; then
    echo "FAIL: Drill 1 — tool contract missing: ${required}"
    exit 1
  fi
done

if ! grep -qiE 'rename|description|parameter|response|safety|prevents|mistake' "${DRILL_DIR}/02-ergonomics-improvement.txt"; then
  echo "FAIL: Drill 2 — should explain the ergonomic rewrite and prevented mistake."
  exit 1
fi

if ! grep -qiE 'task|pass|fail|tool|parameter|response|criteria' "${DRILL_DIR}/03-tool-eval.txt"; then
  echo "FAIL: Drill 3 — tool eval should include task and pass/fail criteria."
  exit 1
fi

echo "Chapter 52 verified — MCP/tool-ergonomics drills complete."
exit 0
