# Chapter 46 — Operating in the Wild: task, tool, and model selection

## Learning objective

The student can choose the right agent surface, context boundary, and model tier for a task, then justify the choice using risk, ambiguity, verification, and cost.

## Prerequisites

- Completed: Chapter 45 — Operating in the Wild: security boundaries
- Concepts: three-tier-model-routing, worktree-as-parallel-write-isolation, lethal-trifecta

## Core concept

Not every task deserves a full autonomous agent. The operator's first decision is the surface:

**Autocomplete.** Best for local completions, repetitive syntax, obvious variable names, and small edits where you already know the shape.

**Chat.** Best for explanation, brainstorming, comparing approaches, or turning vague thoughts into a spec. Chat advises; it does not own the repo.

**Local agent.** Best for scoped code changes with files, commands, tests, diffs, and a human nearby to review.

**Subagent.** Best for isolated research, review, audits, parallel diagnostics, or a bounded chunk that would bloat the main context.

**Worktree agent.** Best for parallel write work where another agent needs a separate file state and branch.

**Background/cloud agent.** Best for ticket-shaped work with clear acceptance criteria, setup commands, and review gates. Bad for fuzzy product discovery or high-permission tasks that still need steering.

**Automation.** Best after the workflow is stable: manual success, then skill, then repeated successful runs, then schedule. Do not automate workflows that still need judgment every time.

Model selection follows the same discipline. Use a small/fast model for classification, extraction, formatting, routing, simple review, and low-risk checks. Use the workhorse model for normal implementation, debugging, and code review. Use the strongest model for architecture, unfamiliar codebases, hard diagnosis, high-risk planning, and failures where lower tiers got stuck.

The deciding questions: Is the task scoped? Is it reversible? Is it verifiable? Does it touch private data, external systems, money, auth, migrations, or production? Does it need fresh context or file isolation? What would prove done?

## Worked example

Task: "Add a tooltip to the member status icon."

Surface: local agent or autocomplete. One file, low risk, easy visual verification. No plan mode unless the file is unfamiliar.

Model tier: workhorse or small/fast, depending on the edit. Strongest model is waste.

Done when:

```text
Icon has accessible label.
Tooltip appears on hover/focus.
No layout shift.
Browser screenshot verifies it.
```

Task: "Refactor billing permissions across API, UI, and audit logs."

Surface: local agent with plan-first workflow. Possibly split into subagents for audit/review. Use worktree if another write task runs in parallel.

Model tier: strongest for plan and risk review; workhorse for implementation chunks.

Done when: tests cover permission boundaries, browser/API checks hit real flows, audit-log behavior is verified, and fresh review checks for regressions.

## The rule

> Choose the smallest surface and lowest model tier that can produce verified work. Escalate for ambiguity, risk, unfamiliar code, parallel writes, or failed lower-tier attempts.

## Common mistakes

**Mistake 1 — Full agent for tiny edits.** A one-line typo fix becomes a plan, a repo scan, and a diff across unrelated files. Use autocomplete or a tight local edit.

**Mistake 2 — Chat for work that needs tools.** The chat answer sounds right but never ran tests, opened files, or produced a diff. If the task depends on repo truth, use an agent with tool access.

**Mistake 3 — Background agent for fuzzy work.** "Improve onboarding" is not a ticket. Background agents need outcome, scope boundaries, acceptance criteria, setup commands, and verification gates.

**Mistake 4 — Strongest model by default.** Maximum reasoning on every task burns cost and attention. Match tier to risk. Save strongest-model calls for places where better reasoning changes the outcome.

**Mistake 5 — Parallelism without review capacity.** Ten agents can produce ten diffs faster than you can inspect one. Your review bandwidth is the practical concurrency limit.

## Drill

Artifacts go in `student/drills/46-task-tool-model-selection/`.

**Drill 1 — Classify five tasks.** Write five realistic tasks for your project. For each, choose one surface: autocomplete, chat, local agent, subagent, worktree agent, background agent, or automation. Save to `student/drills/46-task-tool-model-selection/01-surface-choices.txt`.

**Drill 2 — Route the models.** For the same five tasks, choose small/fast, workhorse, or strongest. Give one sentence of reasoning for each. Save to `student/drills/46-task-tool-model-selection/02-model-routing.txt`.

**Drill 3 — Write one AI-ready ticket.** Pick the task that belongs to a background/cloud agent or local agent. Write it with Goal, Context, Constraints, and Done When. Include verification commands or artifacts. Save to `student/drills/46-task-tool-model-selection/03-ai-ready-ticket.txt`.

## Checkpoint question

> A teammate wants to launch five cloud agents overnight with the prompt "clean up the codebase and improve tests." Answer in 4-5 sentences. Name what's wrong with the task shape, which surface you would use first instead, what model tier belongs where, and what acceptance criteria would make one safe ticket.

<!-- Rewriter audit trail
Universalization pass: adds mode selection across autocomplete, chat, local agent, subagent, worktree agent, background agent, automation; adds three-tier model routing and AI-ready ticket shape.
Rewrite date: 2026-05-13
-->
