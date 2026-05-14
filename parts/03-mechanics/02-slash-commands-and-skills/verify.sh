#!/usr/bin/env bash
# verify.sh — Chapter 20 — Slash commands and skills

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/20-skills"
SKILL_DIR="${STUDENT_ROOT}/.claude/skills"

# Drill 1 — finish-chapter skill authored
SKILL_PATH="${SKILL_DIR}/finish-chapter/SKILL.md"
if [ ! -s "${SKILL_PATH}" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${SKILL_PATH}"
  echo "      Author the finish-chapter skill with YAML frontmatter + numbered body."
  exit 1
fi

# Should have frontmatter delimiters
if ! grep -q '^---' "${SKILL_PATH}"; then
  echo "FAIL: Drill 1 — SKILL.md missing YAML frontmatter delimiters (--- lines)."
  exit 1
fi

# Should have name + description in frontmatter
if ! grep -qiE '^name:' "${SKILL_PATH}"; then
  echo "FAIL: Drill 1 — SKILL.md missing 'name:' field in frontmatter."
  exit 1
fi
if ! grep -qiE '^description:' "${SKILL_PATH}"; then
  echo "FAIL: Drill 1 — SKILL.md missing 'description:' field in frontmatter."
  exit 1
fi

# Drill 2 — invocation log
if [ ! -s "${DRILL_DIR}/01-invocation-log.txt" ]; then
  echo "FAIL: Drill 2 — expected non-empty ${DRILL_DIR}/01-invocation-log.txt"
  echo "      Snapshot of /finish-chapter invocation."
  exit 1
fi

# Drill 3 — review-my-commit skill path
if [ ! -s "${DRILL_DIR}/02-review-skill.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/02-review-skill.txt"
  echo "      Path to your review-my-commit skill."
  exit 1
fi

SECOND_SKILL_PATH=$(head -1 "${DRILL_DIR}/02-review-skill.txt" | tr -d '\r\n')
# Strip leading 'Path:' or similar; check that whatever's named actually exists
SKILL_FILE=$(echo "${SECOND_SKILL_PATH}" | grep -oE '\.claude/skills/[^[:space:]]+SKILL\.md' || true)
if [ -n "${SKILL_FILE}" ]; then
  FULL_PATH="${STUDENT_ROOT}/${SKILL_FILE}"
  if [ ! -s "${FULL_PATH}" ]; then
    echo "FAIL: Drill 3 — referenced skill file does not exist at ${FULL_PATH}"
    exit 1
  fi
fi

echo "Chapter 20 verified — skills authored and invoked."
exit 0
