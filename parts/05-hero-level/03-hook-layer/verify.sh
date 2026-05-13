#!/usr/bin/env bash
# verify.sh — Chapter 34 — Hero level: the hook layer

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/34-hook-layer"

check_nonempty() {
  local path="$1"
  local hint="$2"
  if [ ! -s "${path}" ]; then
    echo "FAIL: expected non-empty ${path}"
    echo "      ${hint}"
    exit 1
  fi
}

check_nonempty "${DRILL_DIR}/01-hook-layers.txt" \
  "Drill 1 — classify each hook by layer (1/2/3)."
check_nonempty "${DRILL_DIR}/02-new-hook.txt" \
  "Drill 2 — path of a new Layer-2 hook authored."
check_nonempty "${DRILL_DIR}/03-alarm-register.txt" \
  "Drill 3 — before/after alarm-register comparison."

# Drill 1 should mention layer / disaster / workflow / behavioral
if ! grep -qiE 'layer|disaster|workflow|behavior' "${DRILL_DIR}/01-hook-layers.txt"; then
  echo "FAIL: Drill 1 — should classify by layer / type."
  exit 1
fi

# Drill 3 should mention BLOCKED or alarm-register pattern
if ! grep -qiE 'BLOCKED|alarm|structured|prose' "${DRILL_DIR}/03-alarm-register.txt"; then
  echo "FAIL: Drill 3 — should compare prose to alarm-register output."
  exit 1
fi

echo "Chapter 34 verified — hook-layer drills complete."
exit 0
