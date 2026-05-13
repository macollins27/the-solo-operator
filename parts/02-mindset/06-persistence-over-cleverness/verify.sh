#!/usr/bin/env bash
# verify.sh — Chapter 14 — Persistence > Cleverness

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/14-persistence-over-cleverness"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-claudes-phrase.txt" \
  "Drill 1 — quote Claude's wind-down phrase (or note 'none')."
check_nonempty "${DRILL_DIR}/02-my-own-deferral.txt" \
  "Drill 2 — describe one thing you've been deferring + the next concrete edit."
check_nonempty "${DRILL_DIR}/03-redirect-result.txt" \
  "Drill 3 — write 2-3 sentences on how Claude reacted to the persistence redirect."

# Drill 2 should mention 'next' or 'edit' or 'do' — showing the next-edit framing was applied
if ! grep -qiE 'next|edit|step|do|fix|write|make' "${DRILL_DIR}/02-my-own-deferral.txt"; then
  echo "FAIL: Drill 2 — 02-my-own-deferral.txt should name a concrete next edit/action."
  exit 1
fi

echo "Chapter 14 verified — persistence drills complete."
exit 0
