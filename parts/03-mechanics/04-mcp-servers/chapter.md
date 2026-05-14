# Chapter 22 — MCP servers

## Learning objective

The student can explain what an MCP server is, name three things MCP servers do that file reads and Bash commands cannot, list the MCP servers active in their fork, and query one of them from a Claude Code session.

## Prerequisites

- Completed: Chapter 21 — Hooks
- Concepts: what-is-claudemd, conversation-turns

## Core concept

**MCP** stands for **Model Context Protocol**. An MCP server is a small program that exposes data or capabilities to the AI as **tools** — additional things the AI can call alongside Read, Write, Edit, Bash.

The load-bearing reason MCP servers exist in mature systems: they replace grep-on-files with structured queries. The AI can already Read files and run Bash. But that means burning tokens to load file contents into context every time. A mature project might have thirteen thousand lines of domain rules, hundreds of past decisions, hundreds of QA findings, an indexed feedback corpus. Grepping that on every question costs context. An MCP server holds the data and exposes queryable tools; the AI calls a tool and gets back exactly what it needs.

The token-economy difference is measurable. A "MCP-first" protocol in CLAUDE.md instructs the AI to query the federation before reading raw files. The empirical result on a mature project: roughly two-and-a-half kilobytes of structured-tool context replaces roughly thirty kilobytes of file reads on a typical orientation. Over hundreds of similar questions per project lifetime, the savings compound directly into longer productive sessions before context compaction starts to degrade quality.

Three things MCP servers do that Read and Bash cannot:

**1. Return structured, queryable data on demand.** "Get me decisions about org-scoping" returns three matching decisions in a few hundred tokens — not the whole decisions document. "Find similar bugs to this finding" returns the prior bug matches, not every finding ever recorded.

**2. Persist state across sessions.** An MCP server writes to SQLite or JSON; the state survives session boundaries. Your student-progress data persists through the course's `course-curriculum` server. The orient server in a mature project caches the last-decisions / open-dispatches / findings-summary view for fast retrieval each session start.

**3. Connect to outside systems with auth handled in the server.** Database queries, Slack workspaces, GitHub issues, cloud storage — the MCP server owns the auth and the shape; the AI just calls the tool.

MCP servers are configured in `.mcp.json` at the project root:

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

When Claude Code opens this project, that server starts as a stdio subprocess. Its tools become callable as `mcp__course-curriculum__<tool-name>`.

A mature project doesn't have one MCP server — it has six or eight. Each exposes a slice of project state: orient (one-call summary of project status), memory (indexed feedback corpus), decisions (past CTO/operator decisions), findings (open bug reports), ledger (dispatch history), code-graph (AST-based "who calls X" queries), domain-rules-graph (same idea over domain rules). Each server stays small — roughly one-hundred-fifty to three-hundred lines of thin code wrapping SQLite or markdown. Together they form a federation; the AI queries the federation instead of grepping the filesystem.

The MCP-first protocol that makes the federation pay off: in CLAUDE.md or in a SessionStart hook, the AI is instructed to call orient (or its equivalent) as its first action, and to query specific servers before reading raw files. Without that instruction, the AI defaults to Read+Grep and the federation goes unused.

MCP is not "more tools is better." Every server is executable code with permissions. Add a server only when it unlocks a real repeated workflow, and know its job, data boundary, and verification path. The right MCP server is workflow-shaped, not API-shaped: too granular and the agent has to guess a brittle sequence of calls; too coarse and the agent loses flexibility.

Security frame: an MCP server can create the **lethal trifecta** if it gives the agent private data, processes untrusted content, and provides an external communication path. Private data means files, databases, source code, credentials, or user records. Untrusted content means issues, emails, webpages, PDFs, comments, logs, or tool output controlled by someone else. External communication means posting, emailing, calling arbitrary APIs, loading remote URLs, or otherwise sending data out. If all three are present, prompt instructions are not enough. Remove or constrain one leg at the tool, API, sandbox, network, or review layer.

## Worked example

You want to know whether prior CTO decisions cover dues-plan deletion when there are active subscribers. Two paths:

**Without the federation:** the AI reads `docs/decisions.md` (~8,000 tokens), grep's for "dues-plan delete" (no direct hit), grep's broader for "delete" (200 matches, all loaded), reads a related portion of the codebase. Total context spend on this one question: ~25k tokens.

**With the federation:** the AI calls `mcp__decisions__query_decisions("dues plan delete with active subscribers")`. The server returns the top three matching decisions in ~500 tokens total. The AI calls `mcp__code-graph__get_neighbors("deleteDuesPlan")` to see what currently depends on it; ~200 tokens of edges. Total: ~1,000 tokens. Roughly twenty-five times cheaper for the same quality of answer.

The federation pays for itself in a single multi-hour session. Across a project lifetime, the token-savings compound directly into longer productive sessions, faster orientation per session, and freedom to query speculatively without anxiety about context cost.

## The rule

> MCP servers turn repeated queries into fast structured calls. Read for one-off browsing; Bash for ad-hoc commands; MCP for structured project state the AI needs repeatedly. The MCP-first protocol in CLAUDE.md tells the AI to query before reading. The federation pays for itself in a single multi-hour session via ~70-90% token reduction on indexed queries.

## Common mistakes

**Mistake 1 — Re-reading data the MCP already serves.** You ask "what's my current chapter?" and the AI Reads `student/.claude/state.json` instead of calling `mcp__course-curriculum__student_state`. Educate via CLAUDE.md: "When state data is available via MCP, prefer the MCP tool over file reads." Without that explicit rule, the AI defaults to Read+Grep because that's the training-data prior.

**Mistake 2 — One mega-server with thirty tools across eight concerns.** Unmaintainable. Split by concern: a memory server, a decisions server, a code-graph server, etc. Each one stays small (~150-300 lines). Each one fails independently — if the decisions server is down, the memory server still works.

**Mistake 3 — Stale indexes.** The MCP server's data is rebuilt manually once a month. Three weeks of code changes don't appear in queries. The operator loses trust in the federation and drifts back to Read+Grep. The fix is auto-rebuild on file changes (launchd, cron, watchman). Fresh indexes are non-negotiable; stale-by-default kills the federation.

**Mistake 4 — Not telling the AI to use the federation.** You build six servers; you don't update CLAUDE.md. The AI grep's anyway. The MCP-first protocol has to be explicit, prioritized, and (for mature projects) reinforced via a SessionStart hook that prints the MCP roster at the top of every session.

**Mistake 5 — Trusting MCP because it feels official.** MCP servers are programs. They can read files, hold tokens, call APIs, or expose bad tool contracts. Run trusted servers, keep scopes narrow, prefer read-only tools where possible, and treat tool descriptions as prompts the agent will follow.

## Drill

Artifacts go in `student/drills/22-mcp-servers/`.

**Drill 1 — Find the active servers.** In your fork, find the `.mcp.json` file. List every server name in it (the keys under `mcpServers`). Save them, one per line, to `student/drills/22-mcp-servers/01-active-servers.txt`.

**Drill 2 — Query an MCP tool.** Open Claude Code. Ask: "Use mcp__course-curriculum__student_state to look up my progress." Watch the tool call. Save the response (the state dict the AI got back) to `student/drills/22-mcp-servers/02-state-response.txt`.

**Drill 3 — Compare reads vs queries.** In a fresh session, ask the AI two questions: (a) "What's the title of Chapter 12?" — observe which tool the AI uses (Read of the chapter file, or `mcp__course-curriculum__get_chapter(12)`). (b) "Find a chapter that explains soft deletes" — observe which tool the AI uses. For each, save the tool name + rough response size to `student/drills/22-mcp-servers/03-read-vs-query.txt`.

## Checkpoint question

> You're starting a new project where you'll build a community library catalog with 50,000 books. You expect to ask the AI things like "find books by author X" and "list books due back this week." Should you have the AI `Read` your catalog every time, `Bash` SQLite queries, or expose an MCP server? Walk through the tradeoffs in 3-4 sentences, naming one specific cost ratio, one failure mode the federation prevents, and whether this server creates any leg of the lethal trifecta.

<!-- Rewriter audit trail
Grounded in verified principles: P58 (MCP-first protocol replaces grep-on-files with structured queries; ~2.5KB context replaces ~30KB of file reads on orientation), and informed by P59/P60 (verify before stating; documented means decomposed — the federation enables fast verification queries that prose-reading discourages)
Worked example surface: MembershipKit decisions federation query for dues-plan deletion
Rewrite date: 2026-05-13
-->
