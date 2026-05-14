#!/usr/bin/env bash
# verify.sh — Chapter 25 — Practice: Auth flow for MembershipKit

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/25-auth-flow"

# Drill 1 — spec exists with at least 5 spec lines
SPEC="${STUDENT_ROOT}/specs/auth-flow.md"
if [ ! -s "${SPEC}" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${SPEC}"
  echo "      Author your auth-flow spec with at least 7 specific spec lines."
  exit 1
fi

SPEC_LINES=$(grep -cE '^\s*[0-9]+\.' "${SPEC}" 2>/dev/null || echo 0)
if [ "${SPEC_LINES}" -lt 5 ]; then
  echo "FAIL: Drill 1 — ${SPEC} should have at least 5 numbered spec lines (found ${SPEC_LINES})."
  exit 1
fi

if [ ! -s "${DRILL_DIR}/01-spec-path.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-spec-path.txt"
  exit 1
fi

# Drill 2 — signed-in screenshot
if [ ! -s "${DRILL_DIR}/02-signed-in.png" ]; then
  echo "FAIL: Drill 2 — expected non-empty ${DRILL_DIR}/02-signed-in.png"
  echo "      Sign up in your browser, take a screenshot of the dashboard / welcome state."
  exit 1
fi

# Drill 3 — security defaults observed
if [ ! -s "${DRILL_DIR}/03-security-defaults.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/03-security-defaults.txt"
  echo "      Document the two security-default observations (neutral signup response + reverse-guard redirect)."
  exit 1
fi

# Security-defaults file should mention auth-relevant security content
if ! grep -qiE 'password|session|enumer|csrf|brute|hash|crypto|token|rate.?limit|neutral|reverse.?guard|redirect' "${DRILL_DIR}/03-security-defaults.txt"; then
  echo "FAIL: Drill 3 — security-defaults file should reference the observed defaults (neutral signup response, reverse-guard redirect, session/password/enumeration discipline)."
  exit 1
fi

echo "Chapter 25 verified — auth flow shipped, with security defaults documented."
exit 0
