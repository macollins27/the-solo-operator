#!/usr/bin/env bash
# verify.sh — Chapter 2 — The terminal
#
# Mechanical check: three drill artifacts exist with the expected shape.

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/02-the-terminal"

check_file_nonempty() {
  local path="$1"
  local message="$2"
  if [ ! -f "${path}" ]; then
    echo "FAIL: ${message}"
    echo "      Expected file: ${path}"
    exit 1
  fi
  if [ ! -s "${path}" ]; then
    echo "FAIL: ${message}"
    echo "      File exists but is empty: ${path}"
    exit 1
  fi
}

# Drill 1 — pwd output captured
check_file_nonempty "${DRILL_DIR}/01-my-home.txt" \
  "Drill 1 — capture the output of 'pwd' into 01-my-home.txt"

# The captured pwd should look like an absolute path (starts with / on
# Mac/Linux or contains a drive letter on Windows).
if ! grep -qE '^(/|[A-Za-z]:)' "${DRILL_DIR}/01-my-home.txt"; then
  echo "FAIL: Drill 1 — 01-my-home.txt does not contain an absolute path."
  echo "      Did you copy the output of 'pwd'? It should start with / or a drive letter."
  exit 1
fi

# Drill 2 — ls output captured
check_file_nonempty "${DRILL_DIR}/02-around-me.txt" \
  "Drill 2 — capture the output of 'ls' into 02-around-me.txt using 'ls > path'"

# Drill 3 — scratch folder exists AND verification output captured
if [ ! -d "${DRILL_DIR}/scratch" ]; then
  echo "FAIL: Drill 3 — expected folder ${DRILL_DIR}/scratch to exist."
  echo "      Run: mkdir ${DRILL_DIR}/scratch"
  exit 1
fi

check_file_nonempty "${DRILL_DIR}/03-scratch-exists.txt" \
  "Drill 3 — capture 'ls ${DRILL_DIR}/' output into 03-scratch-exists.txt"

if ! grep -q 'scratch' "${DRILL_DIR}/03-scratch-exists.txt"; then
  echo "FAIL: Drill 3 — 03-scratch-exists.txt does not mention 'scratch'."
  echo "      Did you run 'ls ${DRILL_DIR}/' after creating the scratch folder?"
  exit 1
fi

echo "Chapter 2 verified — terminal drills complete."
exit 0
