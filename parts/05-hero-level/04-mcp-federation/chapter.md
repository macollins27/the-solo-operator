# Chapter 35 — Hero level: the MCP federation

## Learning objective

The student can describe how a mature project exposes its state through a federation of small MCP servers, name the 6-8 server roles that typically emerge, and explain why "agents query, not read" replaces grep + Read at hero level.

## Prerequisites

- Completed: Chapter 34 — Hero level: the hook layer
- Concepts: what-is-mcp, mcp-federation-pattern

## Core concept

At hero level, your project doesn't have one MCP server — it has six or eight. Each one exposes a slice of project state. Together they form a **federation**. The AI queries the federation instead of grepping the filesystem.

The token-cost contrast is dramatic. A naive AI operating on a mature project might Read CLAUDE.md every session (4-15k tokens), Read the spec files for the current feature (3-10k tokens), Read prior decisions to check for past rulings (5-30k tokens), grep the codebase to find a function (variable per query).

The federation replaces this with structured queries:

- `mcp__orient__orient()` — one call. Returns 2.5KB containing project name, branch, finish-line criteria, latest decisions, open dispatches, findings summary.
- `mcp__decisions__query_decisions(topic)` — matching past decisions with rationale.
- `mcp__findings__recent_findings()` — latest QA findings; with `find_similar_bug(...)` for matching prior incidents.
- `mcp__memory__search_memory(query)` — matching feedback corpus entries.

Each query is a few hundred tokens. Cumulative token spend per session drops roughly 70-90%. The savings compound: smaller context = faster sessions = more iterations per day = better quality. Empirically, on a mature project, the orient call ships roughly 2.5KB of structured context that replaces roughly 30KB of file reads on a typical session opening.

The six to eight servers a mature project typically has:

**1. Orient.** The one-call orientation server. First action of every session: `orient()`. Returns project status, finish-line criteria, latest decisions, open dispatches, findings summary, federation list. Replaces re-reading CLAUDE.md / constitution / current-state files on every open.

**2. Memory.** Indexed access to the feedback corpus. `list_memory()`, `search_memory(query)`, `get_memory(slug)`, `recent_memory()`. Replaces `grep .claude/memory/*.md`.

**3. Decisions.** Indexed access to past CTO / operator decisions. `list_decisions()`, `query_decisions(topic)`, `get_decision(id)`, `decisions_for_domain(domain)`. Replaces `grep decisions.md`.

**4. Findings.** Indexed access to QA findings / open bug reports. `recent_findings()`, `query_findings(filter)`, `find_similar_bug(query)`. Replaces direct queries against a findings store.

**5. Ledger.** Dispatch + run history. `recent_dispatches()`, `runs_history()`, `last_completed()`. Replaces inspecting orchestrator state files directly.

**6. Code graph.** AST-based graph of the codebase. `god_nodes()` (most-connected functions), `get_neighbors(node)` ("who calls X"), `shortest_path(a, b)`. Replaces grep for "where is this used" / "what does this connect to."

**7. Domain-rules graph.** Same idea over your domain-rules documents. `god_nodes()` shows most-cited rules; `get_community(topic)` returns related rule clusters. Replaces grepping domain-rules markdown.

**8. Project-specific.** Whatever your domain needs — student state for a course, customer state for a CRM, asset graph for a media app.

These all stay SMALL (~150-300 lines each). The pattern is "thin Python (or TS) wrapping SQLite or markdown parsing." None is a heavy backend. Each does one job: expose one slice of project state as queryable tools.

The discipline that makes the federation actually pay off:

**1. The MCP-first protocol is in CLAUDE.md AND in a SessionStart hook.** Without an explicit instruction telling the AI to query the federation before reading files, the AI defaults to Read+Grep — that's the training-data prior. The mature pattern injects the MCP roster at session start via a hook ("Before reading from `.claude/docs/domain-rules/`, STOP. Query `mcp__decisions__query_decisions` or the corresponding MCP. Files are still authoritative; MCPs are the precision-targeting layer that replaces grep.").

**2. Each server is independent.** They don't depend on each other. The MCP federation appears AS-IF unified to the AI; each server is its own process. Failure of one server doesn't take down the others.

**3. Servers update automatically.** A launchd / cron / watchman process rebuilds graphs and indexes when source files change. Stale-by-default kills trust; auto-fresh maintains it.

**4. Hard rule: query before you read.** Codified in CLAUDE.md. Reinforced via the SessionStart hook injecting the roster. Without that, agents default to grep, the federation goes unused, and the token-savings disappear.

## Worked example

Two ways the same task plays out.

**Task:** "Are there any prior decisions about how we handle dues-plan deletion when there are active subscribers?"

**Naive (no federation):**
- AI reads `docs/decisions.md` (~8,000 tokens).
- Greps for "dues-plan delete" — no direct hit.
- Greps broader for "delete" — 200 matches across the file, all loaded.
- Reads a related portion of the codebase to see what was done before.
- Total: ~25,000 tokens spent on this one question.

**With federation:**
- AI calls `mcp__decisions__query_decisions("dues plan delete with active subscribers")`.
- Server returns top 3 matching decisions in ~500 tokens total.
- AI reads ONLY the matching decisions (already returned).
- AI calls `mcp__code-graph__get_neighbors("deleteDuesPlan")` to see what currently depends on it. Server returns ~200 tokens of edges.
- Total: ~1,000 tokens spent. Roughly 25x cheaper. Same answer quality.

Across hundreds of similar questions per project lifetime, federation savings dominate. The eight MCP servers on a mature project pay for themselves in a single multi-hour session.

## The rule

> Agents query, not read. Build small MCP servers (~150-300 lines each) exposing project state as structured tools. The federation pays for itself in a single multi-hour session via ~70-90% token reduction. First action of every session: `orient()` — a 2.5KB summary replaces ~30KB of file reads. The MCP-first protocol lives in CLAUDE.md AND in a SessionStart hook; without explicit instruction, agents default to Read+Grep.

## Common mistakes

**Mistake 1 — One mega-server with 50 tools across 10 concerns.** Unmaintainable. Split by concern: memory, decisions, code graph, findings, ledger, project-specific. Each one does one job; each one fails independently.

**Mistake 2 — Stale indexes.** The MCP server's data is rebuilt manually once a month. Three weeks of code changes don't appear in queries. The operator loses trust; drifts back to Read+Grep. Auto-rebuild on file changes is non-negotiable.

**Mistake 3 — Not telling the AI to use the federation.** You build six servers; you don't update CLAUDE.md or wire a SessionStart hook. The AI grep's anyway. The MCP-first protocol has to be EXPLICIT — both in the standing-rules file and in the session-open injection. Without that, the federation is decorative.

**Mistake 4 — Treating MCP as magic.** MCP servers are programs on disk. When something behaves weirdly, open the server source and read it. You don't need to be a Python expert to spot the obvious bugs. The federation isn't a black box — it's a small set of small files.

## Drill

Artifacts in your fork.

**Drill 1 — Audit your federation.** Look at your `.mcp.json`. How many servers are wired? Name each, with one-line "what slice of state it exposes." Save to `student/drills/35-mcp-federation/01-my-federation.txt`. For most students at this point, there's one server: `course-curriculum`.

**Drill 2 — Identify a missing server.** Think about your fork. What's a slice of state you'd want queryable that ISN'T currently? Examples: a server over your `student/feedback/` corpus; over your `student/specs/` files; one indexing the canonical-project's domain entities. Pick one. Describe what it'd expose and why. Save to `student/drills/35-mcp-federation/02-missing-server.txt`.

**Drill 3 — Add MCP-first to CLAUDE.md.** Edit `student/CLAUDE.md`. Add a section (or amend standing rules) instructing the AI to use MCP queries before grepping or reading raw files. Save the diff to `student/drills/35-mcp-federation/03-mcp-first.txt`.

## Checkpoint question

> A new operator looks at your `.mcp.json` and sees six servers wired. They ask "isn't this over-engineered? Couldn't I just have the AI Read and Grep?" Defend the federation in 3-4 sentences — name the specific cost ratio (KB-of-structured-context vs KB-of-file-reads), the specific orient pattern, and the specific failure mode the federation prevents.

<!-- Rewriter audit trail
Grounded in verified principles: P58 (MCP-first protocol replaces grep-on-files with structured queries; SessionStart hook injects MCP roster; ~2.5KB context replaces ~30KB of file reads on orientation; "files are still authoritative; MCPs are the precision-targeting layer that replaces grep")
Worked example surface: MembershipKit decisions+code-graph federation query for dues-plan deletion (25x cost reduction)
Rewrite date: 2026-05-13
-->
