#!/usr/bin/env bash
# verify.sh — Chapter 24 — The session lifecycle

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/24-session-lifecycle"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

# Drill 1 — handoff doc exists in student/state/
HANDOFF_COUNT=$(find "${STUDENT_ROOT}/state" -maxdepth 1 -name 'handoff-*.md' 2>/dev/null | wc -l | tr -d ' ')
if [ "${HANDOFF_COUNT}" -lt 1 ]; then
  echo "FAIL: Drill 1 — expected at least one handoff-*.md in ${STUDENT_ROOT}/state/"
  echo "      Author your first session handoff doc."
  exit 1
fi

# Check handoff doc has the required sections
LATEST=$(find "${STUDENT_ROOT}/state" -maxdepth 1 -name 'handoff-*.md' | head -1)
for section in 'Where' 'Next' 'Files'; do
  if ! grep -qiE "${section}" "${LATEST}"; then
    echo "FAIL: Drill 1 — handoff doc ${LATEST} missing section: ${section}"
    echo "      Required sections: Where we are, Next concrete action, Files involved (Open questions optional)."
    exit 1
  fi
done

check_nonempty "${DRILL_DIR}/01-handoff-path.txt" \
  "Drill 1 — save the path of the handoff doc you wrote."
check_nonempty "${DRILL_DIR}/02-fresh-orientation.txt" \
  "Drill 2 — capture Claude's response in a fresh session reading the handoff."
check_nonempty "${DRILL_DIR}/03-claudemd-update.txt" \
  "Drill 3 — show the CLAUDE.md update that instructs Claude to read student/state/."

# Drill 3 — confirm CLAUDE.md was actually updated with state-reading instruction
if [ -s "${STUDENT_ROOT}/CLAUDE.md" ]; then
  if ! grep -qiE 'state|handoff' "${STUDENT_ROOT}/CLAUDE.md"; then
    echo "FAIL: Drill 3 — CLAUDE.md does not mention reading student/state/ or handoff."
    echo "      Add a line instructing Claude to read the latest handoff at session start."
    exit 1
  fi
fi

echo "Chapter 24 verified — session-lifecycle drills complete. Part 3 (Mechanics) is done."
exit 0
