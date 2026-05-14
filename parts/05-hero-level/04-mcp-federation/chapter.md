# Chapter 35 — Hero level: the MCP federation

## Learning objective

The student can describe how a mature project exposes its state through a federation of small MCP servers, name the 6-8 server roles that typically emerge, and explain why "agents query, not read" replaces grep + Read at hero level.

## Prerequisites

- Completed: Chapter 34 — Hero level: the hook layer
- Concepts: what-is-mcp, mcp-federation-pattern

## Core concept

At hero level, your project doesn't have one MCP server — it has six or eight. Each one exposes a slice of project state. Together they form a **federation**. The AI queries the federation instead of grepping the filesystem.

The token-cost contrast is dramatic. A naive AI might read instruction files, specs, decisions, and grep output every session. The federation returns the relevant slice.

The federation replaces this with structured queries:

- `mcp__orient__orient()` — one call. Returns 2.5KB containing project name, branch, finish-line criteria, latest decisions, open dispatches, findings summary.
- `mcp__decisions__query_decisions(topic)` — matching past decisions with rationale.
- `mcp__findings__recent_findings()` — latest QA findings; with `find_similar_bug(...)` for matching prior incidents.
- `mcp__memory__search_memory(query)` — matching feedback corpus entries.

Each query is a few hundred tokens. Cumulative token spend per session drops roughly 70-90%. Smaller context means faster sessions and fewer compaction failures.

The six to eight servers a mature project typically has:

**1. Orient.** First action: `orient()`. Returns project status, finish-line criteria, latest decisions, open dispatches, findings summary, federation list.

**2. Memory.** Indexed access to the feedback corpus.

**3. Decisions.** Indexed access to past operator decisions.

**4. Findings.** Indexed access to QA findings and open bug reports.

**5. Ledger.** Dispatch and run history.

**6. Code graph.** AST-based "who calls X" and dependency queries.

**7. Domain-rules graph.** Related rule clusters and most-cited domain rules.

**8. Project-specific.** Whatever your domain needs — student state for a course, customer state for a CRM, asset graph for a media app.

These stay small. Each does one job: expose one slice of project state as queryable tools.

Tool design is part of the product. `decisions_query(topic)` beats `search(query)` when many servers expose search. Parameters should be unambiguous, and responses should include source paths or ids.

Granularity is the hard part. A server that exposes one tool per raw API endpoint makes the agent reconstruct a workflow it does not understand. A server that bundles a whole workflow into one giant "do everything" tool hides the checkpoints. Mature MCP tools are workflow-shaped: one tool answers one operator question with enough evidence to verify it.

The security boundary stays central. A federation with private memory, untrusted issue text, and a posting/API tool can create the lethal trifecta. The fix is structural: least privilege, read-only defaults, allowlists, auth, schema validation, idempotency, and human review before external sends.

The discipline that makes the federation actually pay off:

**1. The MCP-first protocol is in instructions and a SessionStart hook.** Without explicit instruction, the AI defaults to Read+Grep. The hook injects the MCP roster at session start.

**2. Each server is independent.** Failure of one server doesn't take down the others.

**3. Servers update automatically.** Stale-by-default kills trust; auto-fresh maintains it.

**4. Hard rule: query before you read.** Without this, the federation goes unused.

**5. Hard rule: curate before you connect.** If the operator cannot explain which server should answer which question, the agent will not reliably choose either. Start with one or two servers that remove obvious repeated waste. Add the next server only after the repeated workflow is real.

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

> Agents query, not read. Build small, curated MCP servers exposing project state as structured tools. The federation pays for itself via ~70-90% token reduction on indexed queries, but every server needs a purpose, permission boundary, verification path, and lethal-trifecta check.

## Common mistakes

**Mistake 1 — One mega-server with 50 tools across 10 concerns.** Unmaintainable. Split by concern: memory, decisions, code graph, findings, ledger, project-specific. Each one does one job; each one fails independently.

**Mistake 2 — Stale indexes.** The MCP server's data is rebuilt manually once a month. Three weeks of code changes don't appear in queries. The operator loses trust; drifts back to Read+Grep. Auto-rebuild on file changes is non-negotiable.

**Mistake 3 — Not telling the AI to use the federation.** You build six servers; you don't update CLAUDE.md or wire a SessionStart hook. The AI grep's anyway. The MCP-first protocol has to be EXPLICIT — both in the standing-rules file and in the session-open injection. Without that, the federation is decorative.

**Mistake 4 — Treating MCP as magic.** MCP servers are programs on disk. When something behaves weirdly, open the server source and read it. You don't need to be a Python expert to spot the obvious bugs. The federation isn't a black box — it's a small set of small files.

**Mistake 5 — Vague tools in a crowded federation.** Six servers all expose a tool named `search`. The agent guesses which one to call, mixes results, and fabricates a bridge between them. Namespacing and descriptions are not polish; they are how the nondeterministic caller finds the deterministic tool.

## Drill

Artifacts in your fork.

**Drill 1 — Audit your federation.** Look at your `.mcp.json`. How many servers are wired? Name each, with one-line "what slice of state it exposes." Save to `student/drills/35-mcp-federation/01-my-federation.txt`. For most students at this point, there's one server: `course-curriculum`.

**Drill 2 — Identify a missing server.** Think about your fork. What's a slice of state you'd want queryable that ISN'T currently? Examples: a server over your `student/feedback/` corpus; over your `student/specs/` files; one indexing the canonical-project's domain entities. Pick one. Describe what it'd expose, why, and which lethal-trifecta legs it does or does not create. Save to `student/drills/35-mcp-federation/02-missing-server.txt`.

**Drill 3 — Add MCP-first to CLAUDE.md.** Edit `student/CLAUDE.md`. Add a section (or amend standing rules) instructing the AI to use MCP queries before grepping or reading raw files. Save the diff to `student/drills/35-mcp-federation/03-mcp-first.txt`.

## Checkpoint question

> A new operator looks at your `.mcp.json` and sees six servers wired. They ask "isn't this over-engineered? Couldn't I just have the AI Read and Grep?" Defend the federation in 3-4 sentences — name the specific cost ratio, the orient pattern, the failure mode the federation prevents, and the security check every new server must pass before being added.

<!-- Rewriter audit trail
Grounded in verified principles: P58 (MCP-first protocol replaces grep-on-files with structured queries; SessionStart hook injects MCP roster; ~2.5KB context replaces ~30KB of file reads on orientation; "files are still authoritative; MCPs are the precision-targeting layer that replaces grep")
Worked example surface: MembershipKit decisions+code-graph federation query for dues-plan deletion (25x cost reduction)
Rewrite date: 2026-05-13
-->
