#!/usr/bin/env bash
# verify.sh — Chapter 1 — What a computer actually does
#
# Mechanical check: three drill artifacts exist in the student's fork.

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/01-what-a-computer-does"

# Drill 1 — screenshot exists and is non-empty
if [ ! -s "${DRILL_DIR}/01-repo-folder.png" ]; then
  echo "FAIL: Drill 1 — expected non-empty screenshot at ${DRILL_DIR}/01-repo-folder.png"
  echo "      Take a screenshot of your course repo folder and save it there."
  exit 1
fi

# Drill 2 — file listing has at least 5 non-empty lines
if [ ! -f "${DRILL_DIR}/02-my-files.txt" ]; then
  echo "FAIL: Drill 2 — expected file at ${DRILL_DIR}/02-my-files.txt"
  echo "      Create the file and list 5 filenames from canonical-project/."
  exit 1
fi

LINES=$(grep -c '\S' "${DRILL_DIR}/02-my-files.txt" 2>/dev/null || echo 0)
if [ "${LINES}" -lt 5 ]; then
  echo "FAIL: Drill 2 — ${DRILL_DIR}/02-my-files.txt has ${LINES} non-empty lines; need at least 5."
  exit 1
fi

# Drill 3 — process name file exists and has at least 1 non-empty line
if [ ! -f "${DRILL_DIR}/03-one-process.txt" ]; then
  echo "FAIL: Drill 3 — expected file at ${DRILL_DIR}/03-one-process.txt"
  echo "      Open Activity Monitor / Task Manager, pick a process, write its name there."
  exit 1
fi

PLINES=$(grep -c '\S' "${DRILL_DIR}/03-one-process.txt" 2>/dev/null || echo 0)
if [ "${PLINES}" -lt 1 ]; then
  echo "FAIL: Drill 3 — ${DRILL_DIR}/03-one-process.txt is empty."
  exit 1
fi

echo "Chapter 1 verified — all three drill artifacts present."
exit 0
