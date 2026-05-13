#!/usr/bin/env bash
# verify.sh — Chapter 16 — The Memory Discipline

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
DRILL_DIR="${STUDENT_ROOT}/drills/16-the-memory-discipline"
FEEDBACK_DIR="${STUDENT_ROOT}/feedback"

# Drill 1 — incident description
if [ ! -s "${DRILL_DIR}/01-the-incident.txt" ]; then
  echo "FAIL: Drill 1 — expected non-empty ${DRILL_DIR}/01-the-incident.txt"
  echo "      Describe a recent AI bite in your own words, one paragraph."
  exit 1
fi

# Drill 2 — a feedback file authored
FEEDBACK_FILES=$(find "${FEEDBACK_DIR}" -maxdepth 1 -name 'feedback_*.md' 2>/dev/null | wc -l | tr -d ' ')
if [ "${FEEDBACK_FILES}" -lt 1 ]; then
  echo "FAIL: Drill 2 — expected at least one feedback_*.md file in ${FEEDBACK_DIR}/"
  echo "      Author your first durable rule using the four-line shape."
  exit 1
fi

# Check the most recent feedback file has the four required sections
LATEST_FEEDBACK=$(find "${FEEDBACK_DIR}" -maxdepth 1 -name 'feedback_*.md' | head -1)
for section in 'What happened' 'Mechanism' 'Rule' 'Evidence'; do
  if ! grep -qi "${section}" "${LATEST_FEEDBACK}"; then
    echo "FAIL: Drill 2 — feedback file ${LATEST_FEEDBACK} is missing section: ${section}"
    echo "      The four-line shape requires: What happened / Mechanism / Rule / Evidence"
    exit 1
  fi
done

# Drill 3 — INDEX.md
if [ ! -s "${FEEDBACK_DIR}/INDEX.md" ]; then
  echo "FAIL: Drill 3 — expected non-empty ${FEEDBACK_DIR}/INDEX.md"
  echo "      List every feedback file you've authored with a one-line description."
  exit 1
fi

# INDEX.md should reference the feedback file
FEEDBACK_BASENAME=$(basename "${LATEST_FEEDBACK}" .md)
if ! grep -q "${FEEDBACK_BASENAME}" "${FEEDBACK_DIR}/INDEX.md"; then
  echo "FAIL: Drill 3 — INDEX.md does not reference ${FEEDBACK_BASENAME}."
  echo "      Add a line for the feedback file you wrote in Drill 2."
  exit 1
fi

echo "Chapter 16 verified — memory-discipline drills complete. Your moat has its first entry."
exit 0
