#!/usr/bin/env bash
# verify.sh — Chapter 11 — Spec is Truth, Output is Defendant

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/11-spec-is-truth"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-feature-spec.md" \
  "Drill 1 — write a 5-8 line spec for a small feature."
check_nonempty "${DRILL_DIR}/02-drift-list.md" \
  "Drill 2 — list the drift(s) between your spec and Claude's build."
check_nonempty "${DRILL_DIR}/03-resolution.md" \
  "Drill 3 — for each drift, decide fix-the-build or change-the-spec."

# Drill 1 should have at least 3 lines of requirements
SPEC_LINES=$(grep -c '\S' "${DRILL_DIR}/01-feature-spec.md" 2>/dev/null || echo 0)
if [ "${SPEC_LINES}" -lt 3 ]; then
  echo "FAIL: Drill 1 — 01-feature-spec.md has ${SPEC_LINES} non-empty lines; need at least 3."
  exit 1
fi

# Drill 2 should mention 'Spec' or 'Build' to show comparison
if ! grep -qiE 'spec|build|drift|missing|added|different' "${DRILL_DIR}/02-drift-list.md"; then
  echo "FAIL: Drill 2 — 02-drift-list.md should compare spec vs build."
  echo "      Format: '- Spec: X. Build: Y.'"
  exit 1
fi

# Drill 3 should show resolution decisions
if ! grep -qiE 'fix|change|spec|build|update' "${DRILL_DIR}/03-resolution.md"; then
  echo "FAIL: Drill 3 — 03-resolution.md should show fix-the-build or change-the-spec decisions."
  exit 1
fi

echo "Chapter 11 verified — spec-as-truth drills complete."
exit 0
