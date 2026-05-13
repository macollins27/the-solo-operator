#!/usr/bin/env bash
# verify.sh — Chapter 0 (orientation) has no machine-checkable drill.
#
# Orientation completion is verified by the student reaching Chapter 1
# in the AI tutor. This script always exits 0; the pedagogy SKILL handles
# orientation-chapter advancement via the checkpoint question only.

set -euo pipefail

echo "Chapter 0 (orientation) — no machine drill; checkpoint question is authoritative."
exit 0
