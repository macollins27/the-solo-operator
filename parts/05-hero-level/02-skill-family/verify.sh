#!/usr/bin/env bash
# verify.sh — Chapter 33 — Hero level: the skill family

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/33-skill-family"

if [ ! -s "${DRILL_DIR}/01-skill-roles.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-skill-roles.txt"
  exit 1
fi

# Drill 1 should mention at least one of the four roles
if ! grep -qiE 'writer|reviewer|dispatcher|recover' "${DRILL_DIR}/01-skill-roles.txt"; then
  echo "FAIL: Drill 1 — should classify each skill by role (writer/reviewer/dispatcher/recover)."
  exit 1
fi

REVIEWER_SKILL="${STUDENT_ROOT}/.claude/skills/review-my-change/SKILL.md"
if [ ! -s "${REVIEWER_SKILL}" ]; then
  echo "FAIL: Drill 2 — expected reviewer skill at ${REVIEWER_SKILL}"
  exit 1
fi

# Reviewer skill should declare itself read-only
if ! grep -qiE 'read.only|no edit|no write|no.*mutating' "${REVIEWER_SKILL}"; then
  echo "FAIL: Drill 2 — reviewer SKILL.md should explicitly declare itself read-only."
  exit 1
fi

if [ ! -s "${DRILL_DIR}/02-pipeline.txt" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${DRILL_DIR}/02-pipeline.txt"
  exit 1
fi

echo "Chapter 33 verified — skill-family drills complete."
exit 0
