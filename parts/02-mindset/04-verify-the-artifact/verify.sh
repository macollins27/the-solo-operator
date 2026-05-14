#!/usr/bin/env bash
# verify.sh — Chapter 12 — Verify the Artifact, Not the Summary

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/12-verify-the-artifact"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-evidence.txt" \
  "Drill 1 — capture 'git diff' AND 'cat' output as evidence of what Claude actually did."
check_nonempty "${DRILL_DIR}/02-claim-vs-reality.txt" \
  "Drill 2 — compare Claude's typecheck claim to the actual command output."
check_nonempty "${DRILL_DIR}/03-browser-screenshot.png" \
  "Drill 3 — screenshot of localhost:3000 showing the UI change."

# Drill 1 should look like it has both diff and cat content
if ! grep -qiE 'diff|---|\+\+\+|export|function|greet' "${DRILL_DIR}/01-evidence.txt"; then
  echo "FAIL: Drill 1 — 01-evidence.txt doesn't look like it contains git diff + cat output."
  exit 1
fi

# Drill 2 should mention typecheck or pnpm or pass/fail
if ! grep -qiE 'typecheck|pnpm|pass|fail|tsc|error' "${DRILL_DIR}/02-claim-vs-reality.txt"; then
  echo "FAIL: Drill 2 — 02-claim-vs-reality.txt should mention the typecheck command/result."
  exit 1
fi

if ! grep -q 'Do NOT write implementation yet' "${DRILL_DIR}/02-claim-vs-reality.txt"; then
  echo "FAIL: Drill 2 — include a failing-test-first prompt with the exact phrase: Do NOT write implementation yet"
  exit 1
fi

echo "Chapter 12 verified — verify-the-artifact drills complete."
exit 0
