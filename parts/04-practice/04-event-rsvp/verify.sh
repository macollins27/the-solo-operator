#!/usr/bin/env bash
# verify.sh — Chapter 28 — Practice: Event creation and RSVP

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/28-event-rsvp"
SPEC="${STUDENT_ROOT}/specs/event-rsvp.md"

if [ ! -s "${SPEC}" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${SPEC}"
  exit 1
fi

SPEC_LINES=$(grep -cE '^\s*[0-9]+\.' "${SPEC}" 2>/dev/null || echo 0)
if [ "${SPEC_LINES}" -lt 5 ]; then
  echo "FAIL: Drill 1 — ${SPEC} should have at least 5 numbered spec lines (found ${SPEC_LINES})."
  exit 1
fi

if ! grep -qiE 'timestamptz|time zone|timezone' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference timestamptz / time zone storage."
  exit 1
fi
if ! grep -qiE 'enum|check.constraint|status.*yes|status.*no|status.*maybe' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference enum/check-constraint for RSVP status."
  exit 1
fi
if ! grep -qiE 'capacity|concurren|atomic|transaction' "${SPEC}"; then
  echo "FAIL: Drill 1 — spec should reference capacity concurrency-safety."
  exit 1
fi

if [ ! -s "${DRILL_DIR}/01-spec-path.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-spec-path.txt"
  exit 1
fi
if [ ! -s "${DRILL_DIR}/02-event-state.png" ]; then
  echo "FAIL: Drill 2 — expected screenshot ${DRILL_DIR}/02-event-state.png"
  exit 1
fi
if [ ! -s "${DRILL_DIR}/03-timestamp-types.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/03-timestamp-types.txt"
  exit 1
fi
if ! grep -qiE 'timestamp with time zone|timestamptz' "${DRILL_DIR}/03-timestamp-types.txt"; then
  echo "FAIL: Drill 3 — 03-timestamp-types.txt should confirm timestamptz columns."
  exit 1
fi

echo "Chapter 28 verified — events and RSVPs shipped with date/timezone/concurrency discipline."
exit 0
