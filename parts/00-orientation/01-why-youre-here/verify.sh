#!/usr/bin/env bash
# verify.sh — Chapter 0 — orientation
#
# After this chapter, the student should have created the first artifact of
# their operating system: student/feedback/INDEX.md. The moat starts here.

set -euo pipefail

STUDENT_ROOT="${1:-./student}"

if [ ! -f "${STUDENT_ROOT}/feedback/INDEX.md" ]; then
  echo "FAIL: expected ${STUDENT_ROOT}/feedback/INDEX.md to exist."
  echo "      Drill: create the file with the three starter lines from Chapter 0."
  exit 1
fi

# Sanity check: should have some content
if [ ! -s "${STUDENT_ROOT}/feedback/INDEX.md" ]; then
  echo "FAIL: ${STUDENT_ROOT}/feedback/INDEX.md is empty."
  echo "      Paste the three starter lines from Chapter 0's Drill 2."
  exit 1
fi

echo "Chapter 0 verified — your moat has its first file at ${STUDENT_ROOT}/feedback/INDEX.md."
exit 0
