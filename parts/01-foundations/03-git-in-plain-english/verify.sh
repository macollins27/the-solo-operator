#!/usr/bin/env bash
# verify.sh — Chapter 3 — Git in plain English
#
# Mechanical check: the student's practice repo exists with at least
# two commits and an about.txt file.

set -euo pipefail

STUDENT_ROOT="${1:-./student}"
REPO="${STUDENT_ROOT}/drills/03-git-in-plain-english/myrepo"

if [ ! -d "${REPO}" ]; then
  echo "FAIL: Expected directory ${REPO} to exist."
  echo "      Run: mkdir -p ${REPO}"
  exit 1
fi

if [ ! -d "${REPO}/.git" ]; then
  echo "FAIL: ${REPO} is not a Git repository."
  echo "      Run: cd ${REPO} && git init"
  exit 1
fi

if [ ! -f "${REPO}/about.txt" ]; then
  echo "FAIL: Expected ${REPO}/about.txt to exist (Drills 2 and 3)."
  echo "      Did you create the file and commit it?"
  exit 1
fi

COMMIT_COUNT=$(git -C "${REPO}" rev-list --all --count 2>/dev/null || echo 0)
if [ "${COMMIT_COUNT}" -lt 2 ]; then
  echo "FAIL: Repo at ${REPO} has ${COMMIT_COUNT} commits; need at least 2."
  echo "      Did you do both Drill 2 (first commit) and Drill 3 (second commit)?"
  exit 1
fi

# Sanity check on commit messages — neither should be empty
EMPTY_MSGS=$(git -C "${REPO}" log --format="%s" | grep -c '^$' || true)
if [ "${EMPTY_MSGS}" -gt 0 ]; then
  echo "FAIL: Found a commit with an empty message in ${REPO}."
  echo "      Every commit needs -m \"<message>\"."
  exit 1
fi

echo "Chapter 3 verified — repo at ${REPO} has ${COMMIT_COUNT} commits with messages."
exit 0
