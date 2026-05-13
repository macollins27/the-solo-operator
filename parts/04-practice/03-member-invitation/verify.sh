#!/usr/bin/env bash
# verify.sh — Chapter 27 — Practice: Member invitation flow

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/27-member-invitation"
SPEC="${STUDENT_ROOT}/specs/member-invitation.md"

if [ ! -s "${SPEC}" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${SPEC}"
  exit 1
fi

SPEC_LINES=$(grep -cE '^\s*[0-9]+\.' "${SPEC}" 2>/dev/null || echo 0)
if [ "${SPEC_LINES}" -lt 5 ]; then
  echo "FAIL: Drill 1 — ${SPEC} should have at least 5 numbered spec lines (found ${SPEC_LINES})."
  exit 1
fi

# Spec must mention crypto random / single-use / generic error
if ! grep -qiE 'crypto|cryptographic|randomUUID|randomBytes' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference cryptographic random generation for tokens."
  exit 1
fi
if ! grep -qiE 'single.use|used.?at|expire' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference single-use and/or expiration."
  exit 1
fi

if [ ! -s "${DRILL_DIR}/01-spec-path.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-spec-path.txt"
  exit 1
fi

if [ ! -s "${DRILL_DIR}/02-member-list.png" ]; then
  echo "FAIL: Drill 2 — expected screenshot ${DRILL_DIR}/02-member-list.png"
  exit 1
fi

if [ ! -s "${DRILL_DIR}/03-no-math-random.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/03-no-math-random.txt with grep result for Math.random"
  exit 1
fi

# The grep result should NOT show matches in security-relevant code
# Permissive: file should contain the grep command + outcome
if ! grep -qiE 'grep|Math.random|no match|0 results|none' "${DRILL_DIR}/03-no-math-random.txt"; then
  echo "FAIL: Drill 3 — expected the grep command and its result documented."
  exit 1
fi

echo "Chapter 27 verified — invitation flow shipped with security primitives."
exit 0
