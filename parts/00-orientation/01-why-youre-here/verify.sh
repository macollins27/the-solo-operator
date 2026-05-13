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

# Strict-case check: macOS's default filesystem is case-insensitive, so
# the -f test above will match index.md / Index.md / etc. Cross-check the
# directory listing for the exact uppercase name so a student on a Mac
# doesn't pass here and break for a Linux/CI teammate later.
if ! ls "${STUDENT_ROOT}/feedback" 2>/dev/null | grep -qx 'INDEX.md'; then
  echo "FAIL: ${STUDENT_ROOT}/feedback/INDEX.md must be named exactly INDEX.md (uppercase, .md extension)."
  echo "      Drill: rename the file so it matches exactly."
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
