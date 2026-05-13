#!/usr/bin/env bash
# verify.sh — Chapter 30 — Practice: AI member-directory search

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/30-ai-directory-search"
SPEC="${STUDENT_ROOT}/specs/ai-directory-search.md"

if [ ! -s "${SPEC}" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${SPEC}"
  exit 1
fi

SPEC_LINES=$(grep -cE '^\s*[0-9]+\.' "${SPEC}" 2>/dev/null || echo 0)
if [ "${SPEC_LINES}" -lt 5 ]; then
  echo "FAIL: Drill 1 — ${SPEC} should have at least 5 numbered spec lines (found ${SPEC_LINES})."
  exit 1
fi

if ! grep -qiE 'rate.limit|429' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference rate limiting."
  exit 1
fi
if ! grep -qiE 'injection|sanitiz|tag|wrap' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference input sanitization / wrapping against prompt injection."
  exit 1
fi

if [ ! -s "${DRILL_DIR}/01-spec-path.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-spec-path.txt"
  exit 1
fi
if [ ! -s "${DRILL_DIR}/02-search-working.png" ]; then
  echo "FAIL: Drill 2 — expected screenshot ${DRILL_DIR}/02-search-working.png"
  exit 1
fi
if [ ! -s "${DRILL_DIR}/03-injection-attempt.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/03-injection-attempt.txt"
  exit 1
fi

echo "Chapter 30 verified — AI search shipped with prompt + cost safety."
exit 0
