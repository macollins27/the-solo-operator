# Chapter 23 — Subagents and parallel work

## Learning objective

The student can describe fork subagents, fresh subagents, and worktrees; predict when each is appropriate; dispatch one of each subagent type; and explain why parallel write work needs isolated file states.

## Prerequisites

- Completed: Chapter 22 — MCP servers
- Concepts: conversation-turns, context-window-finite

## Core concept

A **subagent** is a separate AI run dispatched from inside your session — it does its own work, returns a result, and stays OUT of your main conversation context. Subagents come in two flavors:

**Fork subagents** inherit your full conversation context up to the moment of dispatch. They know what you and the AI have established. Their output stays out of your main context — only a terse return summary comes back.

**Fresh subagents** start with zero context. You give them the full briefing in the dispatch prompt. They don't know anything you haven't told them. Their output also stays out of your main context.

Why this architecture is load-bearing: subagents keep the orchestrator's context small. The main session defines the work and composes structured returns; subagents do bounded chunks without filling the main window.

The discipline that makes the pattern work is **fresh-context isolation**: every verification step specified as "fresh subagent" must actually be fresh. The orchestrator is biased by the same reasoning thread that produced the work being verified. Isolation is a feature, not a cost.

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

**With a fresh subagent:** the AI dispatches a fresh subagent: "Audit `student/canonical-project/` against the 20 anti-patterns at `parts/02-mindset/.../chapter.md`. Return a structured list: pattern number, file path, line, evidence quote. Under 1,000 words." The subagent does the audit, writes a report to a file, returns the report path + a summary. Your context grew by 500 tokens. The full audit lives on disk.

**With parallel diagnostics:** for "is there an enumeration leak in auth?", dispatch three fresh subagents, compare returns, and investigate disagreements.

**With parallel implementation:** one agent refactors billing UI while another adds invitation-expiry tests. Those are write tasks, so each gets its own worktree and merge review.

## The rule

> Dispatch when the work would otherwise blow up your context or when you need parallel signal. Fork for context-dependent creative work; fresh for crisply-scoped tasks; use worktrees for parallel write work. Context isolation is not file isolation.

## Common mistakes

**Mistake 1 — Doing fresh-context work in-context "to save a dispatch."** The compression feels faster and removes the independent check. When the protocol calls for fresh context, no "small" exception.

**Mistake 2 — Defaulting to the strongest model on every dispatch.** "Better safe than sorry" burns rate-limit headroom and cost without matching capability to task. Verification, single-procedure builds, and routine code reviews are handled cleanly by lower tiers. Use small/fast for simple checks, workhorse for normal implementation, strongest for genuinely hard reasoning; name the reason when overriding.

**Mistake 3 — Single-agent diagnostics on high-stakes questions.** One fallible reasoner means one set of blind spots. For high-stakes questions, dispatch multiple agents and triangulate.

**Mistake 4 — Peeking at the full transcript.** Reading the whole subagent transcript pulls tool noise into your context. Trust the structured return; ask a follow-up if needed.

**Mistake 5 — Running parallel writers in one checkout.** Agents discover files while working. Use separate worktrees or keep one writer active at a time.

## Drill

Artifacts go in `student/drills/23-subagents-and-parallel/`.

**Drill 1 — Dispatch a fresh subagent.** In a Claude Code session, ask the AI to dispatch a fresh subagent (via the Agent tool, with `subagent_type: general-purpose`) to do a small audit task — e.g., "Read parts/00-orientation/01-why-youre-here/chapter.md and report whether it follows the locked chapter schema. Return a list of which schema sections are present and which (if any) are missing." Save the subagent's return summary to `student/drills/23-subagents-and-parallel/01-fresh-result.txt`.

**Drill 2 — Dispatch a fork subagent.** In the same Claude Code session, ask the AI to dispatch a fork subagent on a context-dependent question: "Using the conversation so far, explain which chapter concept I am practicing and what artifact path I should produce next." Save the fork subagent's return summary to `student/drills/23-subagents-and-parallel/02-fork-result.txt`.

**Drill 3 — Compare context and file isolation.** After both subagent rounds return, ask the AI: "Roughly how much did each subagent's output add to my context, and would either task have needed a worktree if it were allowed to edit files?" Save the answer to `student/drills/23-subagents-and-parallel/03-context-growth.txt`. Compare to what would have happened if the AI had done the work inline.

## Checkpoint question

> You want to audit your codebase for 8 different security concerns: auth, SQL injection, CSRF, secrets in code, rate limiting, input validation, output encoding, session management. Each audit is independent and read-only. Walk through how you'd structure this with subagents — one fork or eight fresh, fresh-context vs context-inheriting, parallel vs sequential — then explain what would change if the agents were allowed to edit files.

<!-- Rewriter audit trail
Grounded in verified principles: P28 (fresh-context subagent isolation; never "in-context because faster"; isolation is a feature; memory/training are hypotheses), P32 (high-stakes diagnosis dispatches two+ identically-briefed agents and triangulates), P41 (default-mode model selection is wrong; default to smaller model; reserve strongest for genuinely strongest-needed tasks)
Worked example surface: MembershipKit auth flow parallel diagnostic for enumeration leak
Rewrite date: 2026-05-13
-->
