# Chapter 23 — Subagents and parallel work

## Learning objective

The student can describe the difference between a fork subagent and a fresh subagent, predict when each is appropriate, dispatch one of each from their own session, and read the results without polluting their main conversation.

## Prerequisites

- Completed: Chapter 22 — MCP servers
- Concepts: conversation-turns, context-window-finite

## Core concept

A **subagent** is a separate AI run dispatched from inside your session — it does its own work, returns a result, and stays OUT of your main conversation context. Subagents come in two flavors:

**Fork subagents** inherit your full conversation context up to the moment of dispatch. They know what you and the AI have established. Their output stays out of your main context — only a terse return summary comes back.

**Fresh subagents** start with zero context. You give them the full briefing in the dispatch prompt. They don't know anything you haven't told them. Their output also stays out of your main context.

Why this architecture is load-bearing: a single context window can hold roughly one to three hours of full feature work before compaction starts to degrade quality. A feature can require ten times that. The orchestrator-subagent pattern resolves this — the orchestrator stays clean and small, subagents do the chunks, the orchestrator composes the structured returns over a longer wall-clock without filling its own context.

The discipline that makes the pattern work is **fresh-context isolation**: every verification step the protocol specifies as "fresh subagent" must actually be a fresh subagent. No exceptions for "small" or "obvious" or "I already have the files loaded." The orchestrator is biased by the same reasoning thread that produced the work being verified — self-verification reproduces the framing that produced the defect. Isolation is a feature, not a cost. Memory is a hypothesis; training is a hypothesis. A fresh subagent has neither, and that's exactly what makes its verdict credible.

Two specific anti-patterns the fresh-context discipline guards against:

**1. "I'll do the verification in-context to save a dispatch."** The compression feels faster and eliminates the discipline. The map step catches one class of drift; the map-verify step (which has to be a fresh dispatch) catches identifier drift, scope drift, and silent semantic bugs that the orchestrator's own framing missed. Skipping map-verify ships compile errors AND silent semantic defects.

**2. "Step 4 (adversarial review) is overkill for this layer."** This phrasing is the willpower test. The protocol exists because review subagents catch real defects in roughly forty percent of layers across mature projects. Skipping the step because "I feel tired at hour 8" is exactly when the step is load-bearing.

Three composition patterns mature operators use:

**Pattern A — Parallel diagnostic dispatch.** When a question is high-stakes and the cost of a wrong diagnosis is large, dispatch two or more subagents on the same question, independently briefed. Triangulate the returns. Single-agent diagnostics miss things the agent's specific blind spots cannot see — empirically, the first agent on a parallel diagnostic catches bugs the second misses, and vice versa.

**Pattern B — Per-layer fan-out.** When a single subagent can't hold all the context for a multi-layer artifact, a wrapper script dispatches one subagent per layer in parallel. Each subagent has fresh attention budget for just its layer. The orchestrator composes the layers after.

**Pattern C — Pipeline dispatch.** A feature requires spec → contract → build → review → fix. Each is a separate subagent. The orchestrator runs them in sequence, reading the structured exit of each before dispatching the next.

A model-selection discipline that pays off immediately: default to the smaller model for most dispatches; reserve the strongest model for genuinely strongest-model-needed tasks. A mature project running many parallel sessions hits API rate limits primarily on the strongest-model dispatches; sessions using the smaller model for subagent work have effectively zero rate-limit hits even at high concurrency. The cost-effective default for verification, single-procedure builds, and reviews is the smaller model.

## Worked example

You ask the AI to audit MembershipKit for the 20 anti-patterns from Chapter 18.

**Without subagents:** the AI reads every file in the codebase, processes the audit in one session. Context fills with 30,000 tokens of file content and 5,000 tokens of audit prose. The next ask in this session is slow because context is large.

**With a fresh subagent:** the AI dispatches a fresh subagent: "Audit `student/canonical-project/` against the 20 anti-patterns at `parts/02-mindset/.../chapter.md`. Return a structured list: pattern number, file path, line, evidence quote. Under 1,000 words." The subagent does the audit, writes a report to a file, returns the report path + a summary. Your context grew by 500 tokens. The full audit lives on disk.

**With parallel diagnostics:** for a high-stakes audit question — "is there an enumeration leak in the auth flow?" — the orchestrator dispatches three fresh subagents on the same question, identically briefed. Returns compared. Two agree there's a leak at `/auth/sign-up`; one agrees and additionally flags `/auth/forgot-password`. The triangulation surfaces the second leak that any single agent might have missed.

## The rule

> Dispatch when the work would otherwise blow up your context or when you need parallel signal. Fork for context-dependent creative work; fresh for crisply-scoped tasks. Every verification step the protocol specifies as "fresh subagent" must actually be a fresh subagent — self-verification is biased by the same reasoning thread that produced the work being verified.

## Common mistakes

**Mistake 1 — Doing fresh-context work in-context "to save a dispatch."** The compression feels faster and eliminates the discipline that makes the architecture work. Map-verify, adversarial review, second-opinion diagnosis — when the protocol calls for fresh context, the orchestrator's framing is exactly the contaminant the protocol is guarding against. No "small" exception.

**Mistake 2 — Defaulting to the strongest model on every dispatch.** "Better safe than sorry" burns rate-limit headroom and cost without matching capability to task. Verification, single-procedure builds, and code reviews are handled cleanly by smaller models. Default to the smaller model; reserve the strongest for tasks that genuinely require it; name the reason when overriding.

**Mistake 3 — Single-agent diagnostics on high-stakes questions.** "One agent investigated and recommends X." The cost of a wrong diagnosis is large; trusting a single fallible reasoner puts all the risk on one set of blind spots. For high-stakes questions, dispatch two or more agents identically briefed and triangulate.

**Mistake 4 — Peeking at the subagent's output file.** The output file is the FULL transcript. Reading it pulls the subagent's tool noise into your context — exactly what dispatching was designed to prevent. Trust the structured return; if more is needed, fire a follow-up dispatch.

## Drill

Artifacts go in `student/drills/23-subagents-and-parallel/`.

**Drill 1 — Dispatch a fresh subagent.** In a Claude Code session, ask the AI to dispatch a fresh subagent (via the Agent tool, with `subagent_type: general-purpose`) to do a small audit task — e.g., "Read parts/00-orientation/01-why-youre-here/chapter.md and report whether it follows the locked chapter schema. Return a list of which schema sections are present and which (if any) are missing." Save the subagent's return summary to `student/drills/23-subagents-and-parallel/01-fresh-result.txt`.

**Drill 2 — Parallel diagnostic on the same question.** Author a single user message that fires TWO fresh subagent dispatches in parallel on the same audit question (e.g., "list the sections present in chapter X"). Compare the two returns. Save both + a one-sentence note on whether they converged or diverged to `student/drills/23-subagents-and-parallel/02-parallel-returns.txt`.

**Drill 3 — Compare context growth.** After both subagent rounds return, ask the AI: "Roughly how much did each subagent's output add to my context?" The AI can estimate from the return summary size. Save the answer to `student/drills/23-subagents-and-parallel/03-context-growth.txt`. Compare to what would have happened if the AI had done the work inline.

## Checkpoint question

> You want to audit your codebase for 8 different security concerns: auth, SQL injection, CSRF, secrets in code, rate limiting, input validation, output encoding, session management. Each audit is independent. Walk through how you'd structure this with subagents — one fork or eight fresh, fresh-context vs context-inheriting, parallel vs sequential — and name the ONE discipline that determines whether the architecture pays off.

<!-- Rewriter audit trail
Grounded in verified principles: P28 (fresh-context subagent isolation; never "in-context because faster"; isolation is a feature; memory/training are hypotheses), P32 (high-stakes diagnosis dispatches two+ identically-briefed agents and triangulates), P41 (default-mode model selection is wrong; default to smaller model; reserve strongest for genuinely strongest-needed tasks)
Worked example surface: MembershipKit auth flow parallel diagnostic for enumeration leak
Rewrite date: 2026-05-13
-->
