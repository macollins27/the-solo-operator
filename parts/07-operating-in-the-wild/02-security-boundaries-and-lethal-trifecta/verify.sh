#!/usr/bin/env bash
# verify.sh — Chapter 45 — Operating in the Wild: security boundaries

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/45-security-boundaries"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-trifecta-map.txt" \
  "Drill 1 — map private data, untrusted content, and external communication."
check_nonempty "${DRILL_DIR}/02-boundary-fix.txt" \
  "Drill 2 — remove or mechanically constrain at least one trifecta leg."
check_nonempty "${DRILL_DIR}/03-protected-surfaces.txt" \
  "Drill 3 — add protected agentic primitive files to your instruction file."

if ! grep -qiE 'private|secret|credential|repo|database|file' "${DRILL_DIR}/01-trifecta-map.txt"; then
  echo "FAIL: Drill 1 — should identify private data, or explicitly say it is absent."
  exit 1
fi

if ! grep -qiE 'untrusted|public|issue|email|web|pdf|comment|log|absent' "${DRILL_DIR}/01-trifecta-map.txt"; then
  echo "FAIL: Drill 1 — should identify untrusted content, or explicitly say it is absent."
  exit 1
fi

if ! grep -qiE 'external|send|post|network|api|comment|push|upload|absent' "${DRILL_DIR}/01-trifecta-map.txt"; then
  echo "FAIL: Drill 1 — should identify external communication, or explicitly say it is absent."
  exit 1
fi

if ! grep -qiE 'read-only|sandbox|allowlist|draft|human|approval|scoped|sanitize|no-network|block' "${DRILL_DIR}/02-boundary-fix.txt"; then
  echo "FAIL: Drill 2 — should name a concrete structural boundary."
  exit 1
fi

PROTECTED_COUNT=$(grep -Eic 'AGENTS.md|CLAUDE.md|hook|skill|MCP|mcp|settings|workflow|config|\.env' "${DRILL_DIR}/03-protected-surfaces.txt" || true)
if [ "${PROTECTED_COUNT}" -lt 3 ]; then
  echo "FAIL: Drill 3 — should name several protected primitive files or folders."
  exit 1
fi

echo "Chapter 45 verified — security-boundaries drills complete."
exit 0
