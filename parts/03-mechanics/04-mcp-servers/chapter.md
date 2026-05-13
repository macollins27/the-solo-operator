# Chapter 22 — MCP servers

## Learning objective

The student can explain what an MCP server is, name three things MCP servers do that file reads and Bash commands cannot, list the MCP servers active in their fork, and query one of them from a Claude Code session.

## Prerequisites

- Completed: Chapter 21 — Hooks
- Concepts: what-is-claudemd, conversation-turns

## Core concept

**MCP** stands for **Model Context Protocol**. An MCP server is a small program that exposes data or capabilities to Claude as **tools** — additional things Claude can call alongside Read, Write, Edit, Bash, etc.

Why this exists: Claude can already read files and run commands. But that means burning tokens to load file contents into context every time you need them. If you have 200 chapters of curriculum, or 1,000 CTO decisions, or 500 customer records, you can't keep loading all of them on every question. An MCP server lets Claude QUERY the data at the speed of an API call rather than read it at the cost of file tokens.

Three things MCP servers do that Read and Bash cannot:

**1. Return structured, queryable data on demand.** "Get me chapter 19" returns just that chapter, not the whole curriculum. "List the rate-limiting CTO decisions" returns just those, not the entire decisions document. The MCP server holds the data; Claude pulls what it needs.

**2. Persist state across sessions.** An MCP server can write to a SQLite database, a JSON file, anywhere. The state survives session boundaries. This is how this course's `student.db` works — your progress persists because the MCP server saves it.

**3. Connect to outside systems.** An MCP server can talk to a database, a Slack workspace, a Jira board, a GitHub repo, a cloud bucket. Claude querying the MCP is querying the outside world by proxy, with the MCP handling auth and shape.

The course you're taking has SIX-ish MCP servers wired into your fork (or will, by the time you've set things up). One of them — `course-curriculum` — exposes the curriculum content + your student state. You've been interacting with it implicitly via the AI tutor every session.

MCP servers are configured in `.mcp.json` in your project root. The format is small:

```json
{
  "mcpServers": {
    "course-curriculum": {
      "command": "python3",
      "args": ["mcp-servers/course-curriculum/server.py"]
    }
  }
}
```

That says: when Claude Code opens this project, run `python3 mcp-servers/course-curriculum/server.py` as a stdio MCP server. Claude can call any tool that server exposes by name (prefixed `mcp__course-curriculum__<tool_name>`).

The tools that server exposes (from Chapter 8's `course-curriculum` server):

- `mcp__course-curriculum__student_state(student_id)` — read your progress
- `mcp__course-curriculum__get_chapter(n)` — load a specific chapter
- `mcp__course-curriculum__next_chapter(student_id)` — what to teach next
- `mcp__course-curriculum__mark_completed(...)` — record completion
- ...and several more

When you ask the AI tutor a question like "what chapter am I on?", Claude doesn't have to read every file in the curriculum to figure out — it calls `student_state(student_id)` and gets the answer in milliseconds.

When you should use an MCP server:

- You have data Claude will need REPEATEDLY across sessions (state, indexes, lookups).
- You want Claude to query rather than re-derive (querying is cheaper than reading every time).
- The data lives somewhere structured (a database, a service, a deterministic computation).

When you should NOT use an MCP server:

- One-off lookups (just have Claude run a command).
- Data that changes shape every time (MCP servers like contracts; arbitrary shapes are hard to expose).
- Tiny projects (the infrastructure overhead isn't worth it).

The MCP server you'll use most as a beginner is the one that already exists for the course. Later (Part 5), you'll build small MCP servers of your own — for instance, a server that indexes YOUR feedback corpus so Claude can query "what rule applies to silent failures?" against your authored rules.

## Worked example

You're operating a session and want to know which chapters you've completed. Three ways to do it:

**Way 1 — Read everything.** Have Claude `Read` every meta.yml in `parts/`, parse out the completion state (somewhere), produce a list. Slow, token-expensive, and there's no completion state in the meta.yml anyway — that lives in your student state DB.

**Way 2 — Bash queries.** Have Claude `Bash` into the SQLite file directly with `sqlite3 student/student.db "SELECT chapter_n FROM completed_chapters"`. Works, but requires Claude to know the schema and the file path, and every query is shell parsing.

**Way 3 — MCP.** Claude calls `mcp__course-curriculum__student_state("default-student")`. One tool call. Returns a structured dict including completed chapters. Cheap, fast, type-correct, and no shell parsing required.

Way 3 is what an MCP server enables. As your project grows, more and more queries shift from Way 1/2 to Way 3, and the savings compound.

## The rule

> MCP servers turn repeated queries into fast structured calls. Read for one-off browsing. Bash for ad-hoc commands. MCP for structured data Claude needs again and again. Hero-level systems are built on a federation of small MCP servers, each exposing one slice of project state.

## Common mistakes

**Mistake 1 — Re-reading data the MCP already serves.** You ask Claude "what's my current chapter?" and Claude reads `student/.claude/state.json` instead of calling `mcp__course-curriculum__student_state`. Educate Claude in your CLAUDE.md: "When state data is available via MCP, prefer the MCP tool over file reads."

**Mistake 2 — Bundling unrelated things into one MCP server.** A single MCP server with 30 tools across 8 unrelated domains is a maintenance trap. Split into multiple servers (curriculum, state, search, …). Each one stays small.

**Mistake 3 — Treating MCP as magic.** MCP servers are just programs you can read. Their source is on disk. When something behaves weirdly, open the server file (`mcp-servers/course-curriculum/server.py` for this course) and read it. You don't need to be a Python expert to spot the obvious problems.

## Drill

Artifacts go in `student/drills/22-mcp-servers/`.

**Drill 1 — Find the active servers.** In your fork, find the `.mcp.json` file. List every server name in it (the keys under `mcpServers`). Save them, one per line, to `student/drills/22-mcp-servers/01-active-servers.txt`.

**Drill 2 — Query an MCP tool.** Open Claude Code. Ask: "Use mcp__course-curriculum__student_state to look up my progress." Watch the tool call. Save the response (the state dict Claude got back) to `student/drills/22-mcp-servers/02-state-response.txt`. If the response is large, capture the key fields: current chapter, completed chapters count, concepts known count.

**Drill 3 — Compare reads vs queries.** In a fresh session, ask Claude two questions: (a) "What's the title of Chapter 12?" — observe which tool Claude uses (Read of the chapter file, or `mcp__course-curriculum__get_chapter(12)`). (b) "Find a chapter that explains soft deletes" — observe which tool Claude uses. For each, save the tool name + the response size (rough estimate is fine) to `student/drills/22-mcp-servers/03-read-vs-query.txt`.

## Checkpoint question

> You're starting a new project where you'll be building a community library catalog with 50,000 books. You expect to be asking Claude things like "find books by author X," "list books due back this week," "show me books in the 'romance' category." Should you have Claude `Read` your catalog every time, `Bash` SQLite queries, or expose an MCP server? Walk through the tradeoffs in 3-4 sentences, with one specific reason MCP wins or loses.
