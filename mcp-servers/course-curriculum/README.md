# course-curriculum MCP

Stdio MCP server exposing the Solo Operator's Manual curriculum and per-student state. Claude Code queries this server to load chapters, track progress, and decide what to teach next.

## What it serves

| Tool | Purpose |
|---|---|
| `student_state(id)` | Full state for a student: current chapter, completed chapters, concepts known, parked questions |
| `create_student(id)` | Initialize a new student at chapter 0 |
| `get_chapter(n)` | Return chapter N as structured sections + meta |
| `next_chapter(id)` | Compute next eligible chapter (respects prerequisites) |
| `mark_completed(id, n, score)` | Record completion; promote student; bank concepts |
| `mark_stuck(id, n, summary)` | Author-review signal that the chapter has a gap |
| `log_confusion(id, n, summary)` | Spaced-repetition signal |
| `list_concepts_taught_so_far(through_n)` | Concepts the student is expected to know |
| `find_chapter_for_question(q)` | Keyword-match off-syllabus questions to a chapter |
| `park_question(id, q, target_chapter)` | Defer a question to the chapter that will answer it |
| `end_session(id, summary)` | Record session-end note + timestamp |

## State location

Per-student SQLite database at `<repo>/student/student.db`. Auto-created on first call. Each student's fork has its own DB.

## Install

From this directory:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -e .
```

Requires Python 3.11+.

## Smoke test

After installing:

```bash
# Validate import
python3 -c "import server; print('OK')"

# Run interactively (Ctrl-C to exit) — server speaks stdio MCP
python3 server.py
```

To exercise tools without running the MCP, you can import directly:

```bash
python3 -c "
import server
print('chapter 0:', server.get_chapter(0))
print('new student:', server.create_student('test-student'))
print('next chapter:', server.next_chapter('test-student'))
"
```

If `get_chapter(0)` returns a dict with `meta` and `sections` keys, the parser is working. If it returns None, no chapter at that number has been authored yet — author one in `parts/00-orientation/01-*/` and re-run.

## Wiring into Claude Code

The repo's `.mcp.json` registers this server. Claude Code auto-loads it when you open a session in the repo root. The pedagogy SKILL (at `pedagogy/SKILL.md`) calls these tools as its first action of every session.

## Why thin and Python

- Python's stdlib has SQLite + YAML + re; no compiled deps beyond the MCP SDK.
- The server is content-thin: it parses markdown + YAML and shuttles SQLite rows. Nothing AI-side lives here.
- ~250 lines total. Easy to read, easy to fork, easy to extend.

## V2 ideas (not blocking V1)

- `find_chapter_for_question` upgrade to embeddings (sentence-transformers) when the simple keyword match misclassifies enough questions to matter
- `recall_due` view that surfaces chapters due for spaced repetition based on `confusion_events`
- Multi-student support via shared DB (current model is one DB per fork)
