#!/usr/bin/env bash
# verify.sh — Chapter 4 — What Claude Code is, what it isn't
#
# Mechanical check: three drill artifacts exist with expected shape.

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/04-what-claude-code-is"

# Drill 1 — claude --help output
if [ ! -s "${DRILL_DIR}/01-claude-help.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-claude-help.txt"
  echo "      Run: claude --help > ${DRILL_DIR}/01-claude-help.txt"
  exit 1
fi

# Sanity check: claude --help output mentions 'claude' or 'usage' somewhere
if ! grep -qiE 'claude|usage|options' "${DRILL_DIR}/01-claude-help.txt"; then
  echo "FAIL: Drill 1 — 01-claude-help.txt does not look like 'claude --help' output."
  echo "      Did you redirect the right command's output?"
  exit 1
fi

# Drill 2 — one feature note
if [ ! -s "${DRILL_DIR}/02-one-feature.txt" ]; then
  echo "FAIL: Drill 2 — expected non-empty ${DRILL_DIR}/02-one-feature.txt"
  echo "      Pick a Claude Code feature from the docs and write one sentence about it."
  exit 1
fi

# Sanity check: should contain a colon (the requested format)
if ! grep -q ':' "${DRILL_DIR}/02-one-feature.txt"; then
  echo "FAIL: Drill 2 — 02-one-feature.txt missing 'feature: description' format."
  echo "      Expected: <feature name>: <one-sentence description>"
  exit 1
fi

# Drill 3 — three agent-vs-chat differences
if [ ! -s "${DRILL_DIR}/03-agent-vs-chat.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/03-agent-vs-chat.txt"
  echo "      List 3 concrete differences between Claude Code (agent) and chat."
  exit 1
fi

LINES=$(grep -c '\S' "${DRILL_DIR}/03-agent-vs-chat.txt" 2>/dev/null || echo 0)
if [ "${LINES}" -lt 3 ]; then
  echo "FAIL: Drill 3 — 03-agent-vs-chat.txt has ${LINES} non-empty lines; need at least 3."
  exit 1
fi

echo "Chapter 4 verified — Claude Code orientation drills complete."
exit 0
