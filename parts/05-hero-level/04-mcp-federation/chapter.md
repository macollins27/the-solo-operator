# Chapter 35 — Hero level: the MCP federation

## Learning objective

The student can describe how a mature project exposes its state through a federation of small MCP servers, name the 6-8 server roles that typically emerge, and explain why "agents query, not read" replaces grep + Read at hero level.

## Prerequisites

- Completed: Chapter 34 — Hero level: the hook layer
- Concepts: what-is-mcp, mcp-federation-pattern

## Core concept

At hero level, your project doesn't have one MCP server — it has six or eight. Each one exposes a slice of project state. Together they form a **federation**. Claude queries the federation instead of grepping the filesystem.

The contrast in token cost is dramatic. A naive Claude operating on a mature project might:
- Read CLAUDE.md every session (4-15k tokens)
- Read the spec files relevant to the current feature (3-10k tokens)
- Read prior CTO decisions to check for past rulings (5-30k tokens)
- Grep the codebase to find a function (variable per query)

The federation replaces this with structured queries:
- `mcp__orient__orient()` → 2.5KB return containing branch, finish-line criteria, latest decisions, open dispatches, findings summary.
- `mcp__decisions__query_decisions(topic)` → matching CTO decisions with rationale.
- `mcp__findings__recent_findings()` → latest QA findings.
- `mcp__memory__search_memory(query)` → matching feedback corpus entries.

Each query is a few hundred tokens. Cumulative token spend per session drops 70-90%. That savings is compound: smaller context = faster sessions = more iterations per day = better quality.

The 6-8 servers a mature project tends to have:

**1. Orient.** The one-call orientation server. First action of every session: `orient()`. Returns project name, git state, finish-line criteria, latest decisions, open dispatches, findings summary, federation list. Replaces re-reading CLAUDE.md / constitution / current-state.

**2. Memory.** Indexed access to the feedback corpus. `list_memory()`, `search_memory(query)`, `get_memory(slug)`. Replaces `grep .claude/memory/*.md`.

**3. Decisions.** Indexed access to past CTO/operator decisions. `list_decisions()`, `query_decisions(topic)`, `get_decision(id)`. Replaces `grep decisions.md`.

**4. Findings.** Indexed access to QA findings or open bug reports. `recent_findings()`, `query_findings(filter)`. Replaces direct DB queries against a findings SQLite.

**5. Ledger.** Dispatch + run history. `recent_dispatches()`, `runs_history()`. Replaces inspecting orchestrator state files directly.

**6. Code graph.** AST-based graph of the codebase. `god_nodes()` (most-connected functions), `get_neighbors(node)` (who calls X), `shortest_path(a, b)`. Replaces grep for "where is this used" / "what does this connect to."

**7. Domain-rules graph.** Same idea but over your domain-rules documents. `god_nodes()` shows the most-cited rules; `get_community(topic)` returns related rule clusters. Replaces grepping domain-rules markdown.

**8. Project-specific.** Whatever your domain needs — student state for a course, customer state for a CRM, asset graph for a media app.

These all stay SMALL (~150-300 lines each). The pattern is "thin Python wrapping SQLite or markdown parsing." None is a heavy backend. Each does one job: expose one slice of project state as queryable tools.

A few discipline points about federations:

**Each server is independent.** They don't depend on each other (or you have a coordination nightmare). The MCP federation appears AS-IF unified to Claude but each server is its own process. Failure of one server doesn't take down the others.

**Servers update automatically.** A mature setup has a launchd / cron / watchman process that rebuilds graphs and indexes when source files change. So MCP query results are always fresh — never stale.

**Hard rule: query before you read.** In CLAUDE.md, the operator instructs Claude to consult the federation before reading raw files. Cost difference is huge; freshness is the same.

## Worked example

Compare two ways the same task plays out.

**Task:** "Are there any prior decisions about how we handle dues-plan deletion when there are active subscribers?"

**Naive (no federation):**
- Claude reads `docs/decisions.md` (8,000 tokens).
- Claude grep's for "dues-plan delete" — finds nothing direct, broader grep needed.
- Claude grep's for "delete" — 200 matches across the file, all loaded into context.
- Claude reads a related portion of the codebase to see what was done before.
- Total: ~25k tokens spent on this one question.

**With federation:**
- Claude calls `mcp__decisions__query_decisions("dues plan delete with active subscribers")`.
- Server returns top 3 matching decisions in ~500 tokens total.
- Claude reads ONLY the matching decisions (already returned).
- Claude calls `mcp__code-graph__get_neighbors("deleteDuesPlan")` to see what currently depends on it.
- Server returns ~200 tokens of edges.
- Total: ~1k tokens spent. ~25x cheaper than the naive path. Same quality of answer.

Over hundreds of similar questions per project lifetime, the federation savings dominate. This is the actual reason Maxwell's project built 8 MCP servers: it pays for itself in a single multi-hour session.

## The rule

> Agents query, not read. Build small MCP servers (~150-300 lines each) exposing project state as structured tools. The federation pays for itself in a single multi-hour session via 70-90% token reduction. Each session's first action: orient (a 2.5KB summary replaces 30KB of file reads).

## Common mistakes

**Mistake 1 — One mega-server.** A single MCP server with 50 tools across 10 unrelated concerns is unmaintainable. Split by concern: memory server, decisions server, code graph server, etc. Each one does one job.

**Mistake 2 — Stale indexes.** The MCP server's data is rebuilt manually once a month. Three weeks of code changes don't show up in queries. Operators lose trust in the federation. The fix: auto-rebuild on file changes via launchd/cron/watch. Fresh indexes are non-negotiable.

**Mistake 3 — Not telling Claude to use the federation.** You build 8 servers; you don't update CLAUDE.md to say "consult the federation before grepping." Claude grep's anyway. The MCP-first protocol has to be in CLAUDE.md, explicit, prioritized — same way authority hierarchy is.

## Drill

Artifacts in your fork.

**Drill 1 — Audit your federation.** Look at your `.mcp.json`. How many servers are wired? Name each, with one-line "what slice of state it exposes." Save to `student/drills/35-mcp-federation/01-my-federation.txt`. (For most students at this point, there's one server: course-curriculum.)

**Drill 2 — Identify a missing server.** Think about your fork. What's a slice of state you'd want queryable that ISN'T currently? Examples: a server over your `student/feedback/` corpus; a server over your `student/specs/` files; a server that indexes the canonical-project's domain entities. Pick one. Describe what it'd expose and why. Save to `student/drills/35-mcp-federation/02-missing-server.txt`.

**Drill 3 — Add MCP-first to CLAUDE.md.** Edit `student/CLAUDE.md`. Add a section (or amend the standing rules) instructing Claude to use MCP queries before grepping or reading raw files. Save the diff to `student/drills/35-mcp-federation/03-mcp-first.txt`.

## Checkpoint question

> A new operator joins your project. They look at your `.mcp.json` and see 6 servers wired. They ask "isn't this over-engineered? Couldn't I just have Claude `Read` and `Grep`?" Defend the federation in 2-3 sentences, with a specific cost ratio and a specific failure mode the federation prevents.
