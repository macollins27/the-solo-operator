#!/usr/bin/env bash
# verify.sh — Chapter 21 — Hooks

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/21-hooks"
HOOK="${STUDENT_ROOT}/.claude/hooks/block-todo-commits.sh"
SETTINGS="${STUDENT_ROOT}/.claude/settings.json"

# Drill 1 — hook script exists, is executable, blocks TODO
if [ ! -f "${HOOK}" ]; then
  echo "FAIL: Drill 1 — expected hook script at ${HOOK}"
  exit 1
fi

if [ ! -x "${HOOK}" ]; then
  echo "FAIL: Drill 1 — hook script is not executable. Run: chmod +x ${HOOK}"
  exit 1
fi

# Functional test — feed it a TODO commit JSON, expect exit 2
TODO_JSON='{"tool_input": {"command": "git commit -m \"TODO add feature\""}}'
if echo "${TODO_JSON}" | "${HOOK}" >/dev/null 2>&1; then
  echo "FAIL: Drill 1 — hook should have BLOCKED a 'TODO' commit (exit 2) but exited 0."
  exit 1
fi

# Functional test — feed it a clean commit, expect exit 0
CLEAN_JSON='{"tool_input": {"command": "git commit -m \"Add user dashboard route\""}}'
if ! echo "${CLEAN_JSON}" | "${HOOK}" >/dev/null 2>&1; then
  echo "FAIL: Drill 1 — hook should have ALLOWED a clean commit message but exited non-zero."
  exit 1
fi

# Drill 2 — settings.json wires the hook
if [ ! -s "${SETTINGS}" ]; then
  echo "FAIL: Drill 2 — expected non-empty ${SETTINGS}"
  exit 1
fi

if ! grep -q 'block-todo-commits' "${SETTINGS}"; then
  echo "FAIL: Drill 2 — settings.json does not reference block-todo-commits hook."
  exit 1
fi

if [ ! -s "${DRILL_DIR}/01-settings.txt" ]; then
  echo "FAIL: Drill 2 — expected non-empty ${DRILL_DIR}/01-settings.txt with settings.json content."
  exit 1
fi

# Drill 3 — block message captured
if [ ! -s "${DRILL_DIR}/02-block-message.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/02-block-message.txt"
  echo "      Capture the BLOCKED message Claude received when the hook fired."
  exit 1
fi

echo "Chapter 21 verified — hook authored, wired, and tested."
exit 0
