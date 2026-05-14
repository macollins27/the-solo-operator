#!/usr/bin/env bash
# verify.sh — Chapter 31 — Practice: The audit log

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/31-audit-log"
SPEC="${STUDENT_ROOT}/specs/audit-log.md"

if [ ! -s "${SPEC}" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${SPEC}"
  exit 1
fi

SPEC_LINES=$(grep -cE '^\s*[0-9]+\.' "${SPEC}" 2>/dev/null || echo 0)
if [ "${SPEC_LINES}" -lt 5 ]; then
  echo "FAIL: Drill 1 — ${SPEC} should have at least 5 numbered spec lines (found ${SPEC_LINES})."
  exit 1
fi

if ! grep -qiE 'append.only|revoke|update|delete' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference append-only / revoke UPDATE+DELETE."
  exit 1
fi
if ! grep -qiE 'transaction|atomic|same.tx' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference writes-inside-transaction."
  exit 1
fi
if ! grep -qiE 'redact|sensitive|password|token' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference redaction of sensitive fields."
  exit 1
fi

if [ ! -s "${DRILL_DIR}/01-spec-path.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-spec-path.txt"
  exit 1
fi
if [ ! -s "${DRILL_DIR}/02-audit-browser.png" ]; then
  echo "FAIL: Drill 2 — expected screenshot ${DRILL_DIR}/02-audit-browser.png"
  exit 1
fi
if [ ! -s "${DRILL_DIR}/03-tamper-and-redact.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/03-tamper-and-redact.txt"
  exit 1
fi

# Tamper-and-redact file should mention permission-denied (tamper half) and redaction (redact half)
if ! grep -qiE 'permission|denied|not authoriz|cannot|insufficient' "${DRILL_DIR}/03-tamper-and-redact.txt"; then
  echo "FAIL: Drill 3 — tamper-and-redact file should show permission-denied for UPDATE on audit_log."
  exit 1
fi
if ! grep -qiE 'redact|\[REDACTED\]|hash|sha|sensitive' "${DRILL_DIR}/03-tamper-and-redact.txt"; then
  echo "FAIL: Drill 3 — tamper-and-redact file should show the redacted/hashed value from the audit row."
  exit 1
fi

echo "Chapter 31 verified — audit log shipped, tamper-resistant. Part 4 (Practice) is done."
exit 0
