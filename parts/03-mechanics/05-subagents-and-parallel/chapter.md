# Chapter 23 — Subagents and parallel work

## Learning objective

The student can describe how the Task tool dispatches subagents, distinguish long-context vs minimal-context dispatch prompts, predict when each is appropriate, dispatch a subagent, and explain why parallel write work needs isolated file states.

## Prerequisites

- Completed: Chapter 22 — MCP servers
- Concepts: conversation-turns, context-window-finite

## Core concept

A **subagent** is a separate AI run dispatched from inside your session — it does its own work, returns a result, and stays OUT of your main conversation context. In Claude Code, you dispatch a subagent by calling the **`Task` tool** with a `subagent_type` (commonly `general-purpose`) and a `prompt`. The subagent is a fresh assistant run: it has no access to your prior conversation, only what you write into its dispatch `prompt`.

What varies between dispatches is not "fork vs fresh" — every Task subagent starts fresh. What varies is **how much context you pack into the dispatch prompt**:

**Long-context dispatch.** You inline the relevant conversation history, decisions, file paths, and constraints directly into the `prompt`. The subagent inherits everything it needs by reading the prompt itself. Use when the work is creative or context-dependent — the subagent needs the framing the main session has built up.

**Minimal-context dispatch.** You give the subagent a crisp self-contained brief and pointers (file paths, command names, schema locations). The subagent reads what it needs from disk. Use when the task is bounded and well-specified — auditing files against a checklist, generating a report from known inputs.

Either way, the subagent's full transcript stays OUT of your main context; only the structured return comes back. That is the load-bearing property: subagents keep the orchestrator's context small. The main session defines the work and composes returns; subagents do bounded chunks without filling the main window.

The discipline that makes the pattern work is **fresh-context isolation**: every verification step must actually be dispatched as a separate `Task`, not done inline. The orchestrator is biased by the same reasoning thread that produced the work being verified. Isolation is a feature, not a cost — and since every Task subagent is structurally fresh, you get isolation by default as long as you actually dispatch.

Two anti-patterns this prevents:

**1. "I'll do the verification in-context to save a dispatch."** The compression feels faster and removes the independent check. Fresh review catches drift the original thread cannot see.

**2. "Adversarial review is overkill here."** That phrase appears exactly when the review step is most likely to protect you.

Three composition patterns mature operators use:

**Pattern A — Parallel diagnostic dispatch.** For high-stakes questions, dispatch two or more independently briefed subagents and triangulate returns.

**Pattern B — Per-layer fan-out.** Dispatch one subagent per layer, then compose the results.

**Pattern C — Pipeline dispatch.** Run spec → contract → build → review → fix as separate bounded stages.

Use three model tiers: small/fast for classification and simple checks; workhorse for normal implementation/debugging/review; strongest for architecture, unfamiliar codebases, hard diagnosis, and high-risk planning. Name the reason when overriding upward.

A **worktree** is a second working directory connected to the same Git history. It gives another agent a separate file state and branch. Subagents isolate context, not files; parallel write work needs a worktree, separate checkout, or equivalent isolation.

Worktrees do not isolate ports, env vars, databases, credentials, queues, or external services. File isolation is necessary for parallel writes; it is not full process isolation.

## Worked example

You ask the AI to audit MembershipKit for the 20 anti-patterns from Chapter 18.

**Without subagents:** the AI reads every file in the codebase, processes the audit in one session. Context fills with 30,000 tokens of file content and 5,000 tokens of audit prose. The next ask in this session is slow because context is large.

**With a Task dispatch (minimal-context):** the AI dispatches via the `Task` tool: "Audit `student/canonical-project/` against the 20 anti-patterns at `parts/02-mindset/.../chapter.md`. Return a structured list: pattern number, file path, line, evidence quote. Under 1,000 words." The subagent does the audit, writes a report to a file, returns the report path + a summary. Your context grew by 500 tokens. The full audit lives on disk.

**With parallel diagnostics:** for "is there an enumeration leak in auth?", dispatch three Task subagents with identical briefs, compare returns, and investigate disagreements.

**With parallel implementation:** one agent refactors billing UI while another adds invitation-expiry tests. Those are write tasks, so each gets its own worktree and merge review.

## The rule

> Dispatch via the `Task` tool when the work would otherwise blow up your context or when you need parallel signal. Pack the dispatch prompt with rich context for creative / context-dependent work; keep it minimal for crisply-scoped tasks. Use worktrees for parallel write work. Context isolation is not file isolation.

## Common mistakes

**Mistake 1 — Doing verification work in-context "to save a dispatch."** The compression feels faster and removes the independent check. When the protocol calls for a Task dispatch, no "small" exception — only an actual dispatch is isolated.

**Mistake 2 — Defaulting to the strongest model on every dispatch.** "Better safe than sorry" burns rate-limit headroom and cost without matching capability to task. Verification, single-procedure builds, and routine code reviews are handled cleanly by lower tiers. Use small/fast for simple checks, workhorse for normal implementation, strongest for genuinely hard reasoning; name the reason when overriding.

**Mistake 3 — Single-agent diagnostics on high-stakes questions.** One fallible reasoner means one set of blind spots. For high-stakes questions, dispatch multiple agents and triangulate.

**Mistake 4 — Peeking at the full transcript.** Reading the whole subagent transcript pulls tool noise into your context. Trust the structured return; ask a follow-up if needed.

**Mistake 5 — Running parallel writers in one checkout.** Agents discover files while working. Use separate worktrees or keep one writer active at a time.

## Drill

Artifacts go in `student/drills/23-subagents-and-parallel/`.

**Drill 1 — Minimal-context dispatch.** In a Claude Code session, ask the AI to dispatch a subagent via the `Task` tool (with `subagent_type: general-purpose`) on a bounded, self-specified task — e.g., "Read parts/00-orientation/01-why-youre-here/chapter.md and report whether it follows the locked chapter schema. Return a list of which schema sections are present and which (if any) are missing." The dispatch prompt should contain the brief + the file path; nothing else needed. Save the subagent's return summary to `student/drills/23-subagents-and-parallel/01-fresh-result.txt`.

**Drill 2 — Long-context dispatch.** In the same session, ask the AI to dispatch another `Task` subagent on a context-dependent question, this time inlining the relevant prior conversation directly into the dispatch prompt — e.g., "Below is a summary of what we have established this session: [the AI fills this in]. Given that, explain which chapter concept the student is practicing and what artifact path should be produced next." Save the return summary to `student/drills/23-subagents-and-parallel/02-fork-result.txt`.

**Drill 3 — Compare context and file isolation.** After both dispatches return, ask the AI: "Roughly how much did each subagent's return add to my main context, and would either task have needed a worktree if it were allowed to edit files?" Save the answer to `student/drills/23-subagents-and-parallel/03-context-growth.txt`. Compare to what would have happened if the AI had done the work inline.

## Checkpoint question

> You want to audit your codebase for 8 different security concerns: auth, SQL injection, CSRF, secrets in code, rate limiting, input validation, output encoding, session management. Each audit is independent and read-only. Walk through how you'd structure this with `Task` dispatches — one combined dispatch or eight separate ones, long-context vs minimal-context prompts, parallel vs sequential — then explain what would change if the agents were allowed to edit files.

<!-- Rewriter audit trail
Grounded in verified principles: P28 (fresh-context subagent isolation; never "in-context because faster"; isolation is a feature; memory/training are hypotheses), P32 (high-stakes diagnosis dispatches two+ identically-briefed agents and triangulates), P41 (default-mode model selection is wrong; default to smaller model; reserve strongest for genuinely strongest-needed tasks)
Worked example surface: MembershipKit auth flow parallel diagnostic for enumeration leak
Rewrite date: 2026-05-13
-->
