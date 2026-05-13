#!/usr/bin/env bash
# verify.sh — Chapter 29 — Practice: Real-time event check-in

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/29-real-time-checkin"
SPEC="${STUDENT_ROOT}/specs/real-time-checkin.md"

if [ ! -s "${SPEC}" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${SPEC}"
  exit 1
fi

SPEC_LINES=$(grep -cE '^\s*[0-9]+\.' "${SPEC}" 2>/dev/null || echo 0)
if [ "${SPEC_LINES}" -lt 5 ]; then
  echo "FAIL: Drill 1 — ${SPEC} should have at least 5 numbered spec lines (found ${SPEC_LINES})."
  exit 1
fi

if ! grep -qiE 'auth|channel.auth|subscription' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference channel auth."
  exit 1
fi
if ! grep -qiE 'idempoten|on.conflict|unique' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference idempotency of check-in."
  exit 1
fi

if [ ! -s "${DRILL_DIR}/01-spec-path.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-spec-path.txt"
  exit 1
fi
if [ ! -s "${DRILL_DIR}/02-realtime-update.png" ]; then
  echo "FAIL: Drill 2 — expected screenshot ${DRILL_DIR}/02-realtime-update.png"
  exit 1
fi
if [ ! -s "${DRILL_DIR}/03-channel-auth-test.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/03-channel-auth-test.txt"
  exit 1
fi

echo "Chapter 29 verified — real-time check-in shipped with channel auth."
exit 0
