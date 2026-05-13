# Chapter 37 — Hero level: the orchestrator + subagent gestalt

## Learning objective

The student can describe the orchestrator-and-subagent pattern at hero level — how one main session dispatches dozens of subagents to do parallel work, how subagents return structured signals the orchestrator composes, and how the pattern stays auditable without becoming chaos.

## Prerequisites

- Completed: Chapter 36 — Hero level: the anti-pattern classifier
- Concepts: fork-subagent-inherits-context, fresh-subagent-zero-context, structured-exit-signals

## Core concept

At hero level you (the operator) are running a SESSION that doesn't do much heavy lifting itself. It dispatches. The orchestrator session is small, light, focused. The actual work happens in subagents — sometimes a dozen running in parallel, sometimes a single chain of dependent dispatches.

The pattern:

1. **Orchestrator orients.** First action: `mcp__orient__orient()`. The session knows where it is.
2. **Orchestrator plans.** Decides the next step. Often: dispatch one or more subagents.
3. **Orchestrator dispatches.** Forks (for context-aware work) or fresh subagents (for crisply-scoped work). Often in parallel — 3-7 subagents fired simultaneously.
4. **Subagents work.** Each one runs its 50-200 tool calls. Output stays out of orchestrator context.
5. **Subagents return structured signals.** Not prose; JSON or YAML blocks. "Stage X complete. Artifacts at <paths>. Findings: <list>."
6. **Orchestrator composes.** Reads the structured signals. Decides the next dispatch (or commits / reports / wraps up).
7. **Repeat.**

The orchestrator is the conductor. It never plays the instruments itself. It cues. It listens. It cues again.

Why this matters at scale:

A single context window can hold maybe 1-3 hours of full feature work before compaction starts to degrade quality. But a feature can require 20 hours of work. The pattern that resolves this: orchestrator stays clean and small; subagents do the chunks; the orchestrator composes the chunks over a longer wall-clock without ever filling its own context.

This is what makes "20-40 engineer throughput" possible — not raw model speed, but the ARCHITECTURE that prevents context exhaustion at the orchestrator layer. The subagents are parallel; the composition is sequential; the operator is one person.

Three patterns operators use at hero level:

**Pattern A — Parallel diagnostic dispatch.** A high-stakes question (a tricky bug, a security review) gets dispatched to 2-3 subagents IN PARALLEL on the same question. Each returns its independent verdict. Convergence = high confidence. Divergence = each subagent is fallible, dig deeper. Maxwell's project uses this routinely.

**Pattern B — Per-layer fan-out via wrapper script.** When a single subagent can't hold all the context for a multi-layer artifact (e.g. a 16-layer build contract), a wrapper script (`scripts/contract-feature.ts`) dispatches one subagent per layer in parallel. Each subagent has fresh attention budget for just its layer. The orchestrator composes the layers after.

**Pattern C — Pipeline dispatch.** A feature requires: spec → contract → build → review → fix. Each is a separate subagent. The orchestrator runs them in sequence, reading the structured exit of each before dispatching the next. The orchestrator never sees the full content of any stage — just the structured signal.

The discipline layer that keeps this from being chaos:

**Dispatch prompts mandate skill invocation as sole entry point.** "Run /review-source" — not "review the code somehow." The skill is the contract; the prompt enforces it. NO escape-hatch language ("if the skill refuses, operate directly"). Maxwell's `feedback_no_skill_bypass_language` got an orchestrator fired over this exact failure.

**Dispatch prompts list forbidden modifications explicitly.** Subagents extrapolate from "in scope"; they refuse from "explicitly forbidden." So you list: "DO NOT modify CLAUDE.md, framework versions, _shared/ files."

**Subagent returns are READ before next dispatch.** The `post-agent-review` hook from Chapter 34 forces this — the orchestrator can't skip reading what came back.

**Failures surface specifically.** A subagent doesn't return "something went wrong." It returns: "FAIL: <category> at <file>:<line>. Evidence: <quote>." The orchestrator can act on that. Vague failures cascade into orchestrator confusion.

## Worked example

You're shipping a new feature: live notifications across MembershipKit. The work involves: schema migration, backend API, real-time channel, client subscription, notification preferences UI, audit log integration. Six pieces.

Hero-level orchestrator flow:

- Orient. Plan. Decide: feature requires shared infrastructure (notification dispatch) + per-domain integration (notifications to RSVPs, payments, role-changes).
- Dispatch subagent 1 (fresh): run `/contract-feature notifications`. Subagent produces a 6-layer contract. Returns: "contract at .../contract-sheets/notifications.md; 6 layers; panel review pass; READY."
- Dispatch subagent 2 (fresh): run `/build-feature notifications --layer 0` (shared infra). Returns: "Layer 0 built; gate passed; 3 files; SHA abc123."
- Dispatch subagents 3-7 (fresh, in parallel): one per per-domain layer (layers 1-5). All run simultaneously. Each returns its own structured signal.
- Orchestrator collects 5 structured returns. All passed. Composes.
- Dispatch subagent 8 (fresh): run `/review-source notifications`. Returns 4 findings. Orchestrator reads.
- Dispatch subagent 9-12 (fresh): one per finding, `/fix-source <finding>`. Parallel. Each returns: "fixed; gate passed."
- Dispatch subagent 13 (fresh): `/qa-audit notifications`. Returns: zero blockers.
- Orchestrator commits the work, writes the session handoff, closes.

Total wall-clock: ~3 hours, much of it parallel. Total orchestrator context growth: ~10k tokens (the 13 structured returns). Total work done: ~6 hours of equivalent serial effort. The orchestrator stayed clean throughout.

## The rule

> The orchestrator dispatches; doesn't do. Subagents run in parallel where possible, return structured signals, and stay OUT of orchestrator context. The discipline layer (mandate-skill prompts, post-agent-review hook, explicit forbidden list) keeps composition reliable. Hero-level throughput is the architecture, not the model speed.

## Common mistakes

**Mistake 1 — Orchestrator doing the work itself.** You dispatch one subagent, get the return, and then START EDITING FILES yourself. Now the orchestrator's context fills with file contents. Two more dispatches and the orchestrator is compacting. The fix: orchestrator dispatches; subagents edit; orchestrator only composes.

**Mistake 2 — Vague dispatch prompts.** "Audit my code" gives the subagent license to define the audit. Different runs produce different audits. The fix: mandate a specific skill, list forbidden modifications, specify the structured return format. Tight dispatch prompts produce repeatable work.

**Mistake 3 — Skipping the post-agent-review.** Subagent returns. Orchestrator reads only the first line of the return ("PASS"). The return contained important caveats further down. Decisions get made on the summary, not the substance. The `post-agent-review` hook forces full read; even without the hook, the discipline is: read the entire structured return before dispatching the next thing.

## Drill

Artifacts in your fork.

**Drill 1 — Map your current orchestrator pattern.** Write 4-6 sentences at `student/drills/37-orchestrator-gestalt/01-my-pattern.txt` describing how you currently use Claude. Are you doing work in the orchestrator session or dispatching? If dispatching, are dispatches parallel or serial? Where does context live?

**Drill 2 — Dispatch in parallel.** In a Claude Code session, dispatch THREE fresh subagents in a single message (using three Agent tool calls in parallel). Each one does a small audit task (e.g., "summarize what Chapter X teaches"). Save the three structured returns to `student/drills/37-orchestrator-gestalt/02-parallel-returns.txt`.

**Drill 3 — Write a tight dispatch prompt.** Author a dispatch prompt template you'd reuse for any future subagent dispatch. Should include: skill mandate, forbidden modifications list, structured return format. Save to `student/drills/37-orchestrator-gestalt/03-dispatch-template.txt`.

## Checkpoint question

> You're orchestrating a feature build and notice your context is at 60% after only 90 minutes of work. You haven't even started the implementation phase. What's likely happening, and what would you change in your dispatch pattern to stay clean for the next 3-4 hours of work?
