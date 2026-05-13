#!/usr/bin/env bash
# verify.sh — Chapter 8 — Your first project: a working app on your machine

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/08-your-first-project"
APP_DIR="${STUDENT_ROOT}/canonical-project"

# Drill 1 — versions captured
if [ ! -s "${DRILL_DIR}/01-versions.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-versions.txt"
  echo "      Run: node --version > ${DRILL_DIR}/01-versions.txt && pnpm --version >> ${DRILL_DIR}/01-versions.txt"
  exit 1
fi

VERS_LINES=$(grep -c '\S' "${DRILL_DIR}/01-versions.txt" 2>/dev/null || echo 0)
if [ "${VERS_LINES}" -lt 2 ]; then
  echo "FAIL: Drill 1 — expected at least 2 version strings (node, pnpm)."
  exit 1
fi

# Drill 2 — Next.js app scaffolded
if [ ! -d "${APP_DIR}" ]; then
  echo "FAIL: Drill 2 — expected ${APP_DIR} to exist."
  echo "      Did you scaffold a Next.js app inside student/canonical-project/?"
  exit 1
fi

if [ ! -f "${APP_DIR}/package.json" ]; then
  echo "FAIL: Drill 2 — expected ${APP_DIR}/package.json to exist."
  exit 1
fi

if ! grep -q '"next"' "${APP_DIR}/package.json"; then
  echo "FAIL: Drill 2 — ${APP_DIR}/package.json does not list 'next' as a dependency."
  echo "      Did the scaffolder actually run, and did you scaffold a Next.js app?"
  exit 1
fi

if [ ! -d "${APP_DIR}/app" ]; then
  echo "FAIL: Drill 2 — expected ${APP_DIR}/app/ folder (App Router)."
  exit 1
fi

# Drill 3 — screenshot + commit proof
if [ ! -s "${DRILL_DIR}/02-localhost-screenshot.png" ]; then
  echo "FAIL: Drill 3 — expected ${DRILL_DIR}/02-localhost-screenshot.png."
  echo "      Run the dev server, open localhost:3000, screenshot, save it."
  exit 1
fi

if [ ! -s "${DRILL_DIR}/03-first-commit.txt" ]; then
  echo "FAIL: Drill 3 — expected ${DRILL_DIR}/03-first-commit.txt."
  echo "      After committing, run: git log -1 --oneline > ${DRILL_DIR}/03-first-commit.txt"
  exit 1
fi

echo "Chapter 8 verified — first real project scaffolded and committed."
exit 0
