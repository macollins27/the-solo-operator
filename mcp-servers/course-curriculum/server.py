#!/usr/bin/env python3
"""course-curriculum MCP server.

Stdio MCP server exposing chapter content + student state for the
Solo Operator's Manual course. Called by Claude Code via .mcp.json.

Tools exposed:
  - student_state(student_id) -> dict | None
  - create_student(student_id) -> dict
  - get_chapter(chapter_n) -> dict (structured sections)
  - next_chapter(student_id) -> int | None
  - mark_completed(student_id, chapter_n, score)
  - mark_stuck(student_id, chapter_n, summary)
  - log_confusion(student_id, chapter_n, summary)
  - list_concepts_taught_so_far(through_chapter) -> list[str]
  - find_chapter_for_question(query) -> dict | None
  - park_question(student_id, question, target_chapter)
  - end_session(student_id, summary)
"""

from __future__ import annotations

import asyncio
import re
import sqlite3
import sys
from pathlib import Path
from typing import Any

import yaml
from mcp.server.fastmcp import FastMCP

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------

SERVER_DIR = Path(__file__).resolve().parent
REPO_ROOT = SERVER_DIR.parent.parent
PARTS_DIR = REPO_ROOT / "parts"
SCHEMA_PATH = SERVER_DIR / "schema.sql"
STUDENT_DB = REPO_ROOT / "student" / "student.db"

# Schema section headings, in canonical order. Used to slice chapter.md.
CHAPTER_SECTIONS = [
    "Learning objective",
    "Prerequisites",
    "Core concept",
    "Worked example",
    "The rule",
    "Common mistakes",
    "Drill",
    "Checkpoint question",
]


# ---------------------------------------------------------------------------
# Database (lazy-initialized SQLite)
# ---------------------------------------------------------------------------


def _db() -> sqlite3.Connection:
    STUDENT_DB.parent.mkdir(parents=True, exist_ok=True)
    init_needed = not STUDENT_DB.exists()
    conn = sqlite3.connect(STUDENT_DB)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    if init_needed:
        conn.executescript(SCHEMA_PATH.read_text())
        conn.commit()
    return conn


# ---------------------------------------------------------------------------
# Chapter discovery + parsing
# ---------------------------------------------------------------------------


def _chapter_dir(chapter_n: int) -> Path | None:
    """Find the directory for chapter N by scanning parts/."""
    for part_dir in sorted(PARTS_DIR.glob("[0-9]*-*")):
        for ch_dir in sorted(part_dir.glob("[0-9]*-*")):
            meta_path = ch_dir / "meta.yml"
            if not meta_path.exists():
                continue
            try:
                meta = yaml.safe_load(meta_path.read_text())
                if meta.get("chapter", {}).get("number") == chapter_n:
                    return ch_dir
            except yaml.YAMLError:
                continue
    return None


def _parse_chapter_md(md_text: str) -> dict[str, str]:
    """Slice chapter.md into a dict keyed by schema section name."""
    sections: dict[str, str] = {}
    # Pattern matches `## Section name` headings
    pattern = re.compile(r"^##\s+(.+?)\s*$", re.MULTILINE)
    matches = list(pattern.finditer(md_text))
    for i, m in enumerate(matches):
        heading = m.group(1).strip()
        start = m.end()
        end = matches[i + 1].start() if i + 1 < len(matches) else len(md_text)
        sections[heading] = md_text[start:end].strip()
    return sections


def _load_chapter(chapter_n: int) -> dict[str, Any] | None:
    ch_dir = _chapter_dir(chapter_n)
    if ch_dir is None:
        return None
    meta = yaml.safe_load((ch_dir / "meta.yml").read_text())
    md = (ch_dir / "chapter.md").read_text()
    sections = _parse_chapter_md(md)
    return {
        "meta": meta,
        "sections": {key: sections.get(key, "") for key in CHAPTER_SECTIONS},
        "path": str(ch_dir.relative_to(REPO_ROOT)),
    }


def _all_chapters_sorted() -> list[dict[str, Any]]:
    """All chapters, sorted by chapter number, with meta + summary only (no full text)."""
    results = []
    for part_dir in sorted(PARTS_DIR.glob("[0-9]*-*")):
        for ch_dir in sorted(part_dir.glob("[0-9]*-*")):
            meta_path = ch_dir / "meta.yml"
            if not meta_path.exists():
                continue
            try:
                meta = yaml.safe_load(meta_path.read_text())
                results.append({"meta": meta, "path": str(ch_dir.relative_to(REPO_ROOT))})
            except yaml.YAMLError:
                continue
    return sorted(results, key=lambda c: c["meta"]["chapter"]["number"])


# ---------------------------------------------------------------------------
# MCP server
# ---------------------------------------------------------------------------

mcp = FastMCP("course-curriculum")


@mcp.tool()
def student_state(student_id: str) -> dict[str, Any] | None:
    """Return the student's full state, or None if no such student exists."""
    conn = _db()
    row = conn.execute("SELECT * FROM students WHERE id = ?", (student_id,)).fetchone()
    if row is None:
        return None
    completed = [
        dict(r) for r in conn.execute(
            "SELECT chapter_n, score, completed_at FROM completed_chapters WHERE student_id = ? ORDER BY chapter_n",
            (student_id,),
        ).fetchall()
    ]
    concepts = [
        r["concept"] for r in conn.execute(
            "SELECT concept FROM concepts_known WHERE student_id = ?", (student_id,)
        ).fetchall()
    ]
    parked = [
        dict(r) for r in conn.execute(
            "SELECT id, question, target_chapter, asked_at FROM parked_questions "
            "WHERE student_id = ? AND surfaced_at IS NULL ORDER BY asked_at",
            (student_id,),
        ).fetchall()
    ]
    return {
        **dict(row),
        "completed_chapters": completed,
        "concepts_known": concepts,
        "parked_questions": parked,
    }


@mcp.tool()
def create_student(student_id: str) -> dict[str, Any]:
    """Initialize a new student at chapter 0."""
    conn = _db()
    conn.execute("INSERT OR IGNORE INTO students (id) VALUES (?)", (student_id,))
    conn.commit()
    return student_state(student_id) or {}


@mcp.tool()
def get_chapter(chapter_n: int) -> dict[str, Any] | None:
    """Return chapter N as structured sections plus meta. None if not found."""
    return _load_chapter(chapter_n)


@mcp.tool()
def next_chapter(student_id: str) -> int | None:
    """Return the next chapter the student is eligible for, or None if course complete.

    Respects meta.yml prerequisites.chapters_completed.
    """
    conn = _db()
    completed_rows = conn.execute(
        "SELECT chapter_n FROM completed_chapters WHERE student_id = ? AND score = 'pass'",
        (student_id,),
    ).fetchall()
    completed = {r["chapter_n"] for r in completed_rows}

    for ch in _all_chapters_sorted():
        n = ch["meta"]["chapter"]["number"]
        if n in completed:
            continue
        prereqs = (ch["meta"].get("prerequisites") or {}).get("chapters_completed") or []
        if all(p in completed for p in prereqs):
            return n
    return None


@mcp.tool()
def mark_completed(student_id: str, chapter_n: int, score: str = "pass") -> dict[str, Any]:
    """Record chapter completion + write concepts_taught into concepts_known."""
    if score not in ("pass", "partial"):
        raise ValueError("score must be 'pass' or 'partial'")
    conn = _db()
    conn.execute(
        "INSERT OR REPLACE INTO completed_chapters (student_id, chapter_n, score) VALUES (?, ?, ?)",
        (student_id, chapter_n, score),
    )
    chapter = _load_chapter(chapter_n)
    if chapter and score == "pass":
        for concept in (chapter["meta"].get("concepts_taught") or []):
            conn.execute(
                "INSERT OR IGNORE INTO concepts_known (student_id, concept) VALUES (?, ?)",
                (student_id, concept),
            )
        nxt = next_chapter(student_id)
        if nxt is not None:
            conn.execute("UPDATE students SET current_chapter = ? WHERE id = ?", (nxt, student_id))
    conn.commit()
    return {"student_id": student_id, "chapter_n": chapter_n, "score": score}


@mcp.tool()
def mark_stuck(student_id: str, chapter_n: int, summary: str) -> dict[str, Any]:
    """Log that the student got stuck on chapter N. Author-review signal."""
    conn = _db()
    conn.execute(
        "INSERT INTO stuck_events (student_id, chapter_n, summary) VALUES (?, ?, ?)",
        (student_id, chapter_n, summary),
    )
    conn.commit()
    return {"logged": True, "chapter_n": chapter_n}


@mcp.tool()
def log_confusion(student_id: str, chapter_n: int, summary: str) -> dict[str, Any]:
    """Log a confusion event for spaced repetition."""
    conn = _db()
    conn.execute(
        "INSERT INTO confusion_events (student_id, chapter_n, summary) VALUES (?, ?, ?)",
        (student_id, chapter_n, summary),
    )
    conn.commit()
    return {"logged": True, "chapter_n": chapter_n}


@mcp.tool()
def list_concepts_taught_so_far(through_chapter: int) -> list[str]:
    """Concepts taught by chapters 0..through_chapter (inclusive), from meta.yml."""
    concepts: list[str] = []
    for ch in _all_chapters_sorted():
        n = ch["meta"]["chapter"]["number"]
        if n > through_chapter:
            break
        for c in (ch["meta"].get("concepts_taught") or []):
            if c not in concepts:
                concepts.append(c)
    return concepts


@mcp.tool()
def find_chapter_for_question(query: str) -> dict[str, Any] | None:
    """V1: keyword match against chapter learning_objective + concepts_taught + title.

    Returns the highest-scoring chapter or None. V2 would use embeddings.
    """
    q_tokens = {t.lower() for t in re.findall(r"\w+", query) if len(t) > 2}
    if not q_tokens:
        return None
    best: tuple[int, dict[str, Any]] | None = None
    for ch in _all_chapters_sorted():
        meta = ch["meta"]
        haystack = " ".join([
            meta.get("learning_objective", "") or "",
            meta["chapter"].get("title", "") or "",
            meta["chapter"].get("slug", "") or "",
            " ".join(meta.get("concepts_taught") or []),
        ]).lower()
        h_tokens = set(re.findall(r"\w+", haystack))
        score = len(q_tokens & h_tokens)
        if score == 0:
            continue
        if best is None or score > best[0]:
            best = (score, ch)
    return best[1] if best else None


@mcp.tool()
def park_question(student_id: str, question: str, target_chapter: int | None = None) -> dict[str, Any]:
    """Park an off-syllabus question to surface when relevant chapter is reached."""
    conn = _db()
    cur = conn.execute(
        "INSERT INTO parked_questions (student_id, question, target_chapter) VALUES (?, ?, ?)",
        (student_id, question, target_chapter),
    )
    conn.commit()
    return {"id": cur.lastrowid, "target_chapter": target_chapter}


@mcp.tool()
def end_session(student_id: str, summary: str) -> dict[str, Any]:
    """Record session-end note + timestamp."""
    conn = _db()
    conn.execute(
        "INSERT INTO session_log (student_id, session_started_at, session_ended_at, summary) "
        "VALUES (?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?)",
        (student_id, summary),
    )
    conn.execute("UPDATE students SET last_session_at = CURRENT_TIMESTAMP WHERE id = ?", (student_id,))
    conn.commit()
    return {"logged": True}


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------


if __name__ == "__main__":
    mcp.run()
