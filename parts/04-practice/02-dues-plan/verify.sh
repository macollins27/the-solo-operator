#!/usr/bin/env bash
# verify.sh — Chapter 26 — Practice: Dues plan and subscription

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/26-dues-plan"
SPEC="${STUDENT_ROOT}/specs/dues-plan.md"

if [ ! -s "${SPEC}" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${SPEC}"
  exit 1
fi

SPEC_LINES=$(grep -cE '^\s*[0-9]+\.' "${SPEC}" 2>/dev/null || echo 0)
if [ "${SPEC_LINES}" -lt 5 ]; then
  echo "FAIL: Drill 1 — ${SPEC} should have at least 5 numbered spec lines (found ${SPEC_LINES})."
  exit 1
fi

# Spec should mention money-as-integer-cents discipline
if ! grep -qiE 'cent|integer' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference integer cents (the load-bearing rule of this chapter)."
  exit 1
fi

if [ ! -s "${DRILL_DIR}/01-spec-path.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-spec-path.txt"
  exit 1
fi

if [ ! -s "${DRILL_DIR}/02-subscription.png" ]; then
  echo "FAIL: Drill 2 — expected non-empty ${DRILL_DIR}/02-subscription.png"
  echo "      Screenshot of an active subscription in the app or Stripe test dashboard."
  exit 1
fi

if [ ! -s "${DRILL_DIR}/03-discipline-log.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/03-discipline-log.txt"
  echo "      Document a money-discipline or cross-org moment from your session."
  exit 1
fi

if ! grep -qiE 'cent|float|parseFloat|toFixed|integer|money|org|forbidden|not.?found|idor' "${DRILL_DIR}/03-discipline-log.txt"; then
  echo "FAIL: Drill 3 — discipline log should mention cents/float/integer/money or cross-org/IDOR explicitly."
  exit 1
fi

echo "Chapter 26 verified — dues plan + subscription shipped with money discipline."
exit 0
