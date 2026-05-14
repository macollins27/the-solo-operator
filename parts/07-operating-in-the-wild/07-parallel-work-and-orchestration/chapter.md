# Chapter 50 — Operating in the Wild: parallel work and orchestration

## Learning objective

The student can design a parallel agent workflow that separates read-only audits from write tasks, uses worktrees for parallel edits, and dispatches subagents with bounded contracts and review capacity.

## Prerequisites

- Completed: Chapter 49 — Operating in the Wild: codebase preparation
- Concepts: worktree-as-parallel-write-isolation, four-part-subagent-contract, review-bandwidth-as-concurrency-limit

## Core concept

Parallel agents buy two things: isolation and speed. They also create coordination cost.

Use parallelism when the work decomposes cleanly:

**Read-only audits.** Several fresh subagents can inspect different concerns in the same checkout because they do not write files. Example: auth, data access, UI accessibility, and test quality audits.

**Parallel write work.** Each writer needs an isolated file state: worktree, separate checkout, or equivalent. Context isolation is not file isolation. A subagent can have a clean conversation and still overwrite another agent's disk changes if both write in the same checkout.

**Orchestrator-worker flow.** The main session is the orchestrator. It defines the plan, dispatches workers, receives structured returns, reviews outputs, and decides what to merge. Workers do bounded tasks and return artifacts. They do not define the overall strategy.

Effort scaling matters. One agent is enough for a simple fact. Two to four agents can compare approaches or audit independent concerns. Ten agents are only reasonable for broad, high-value research or migration work with strong output contracts. More agents without more review capacity creates unread diffs.

The mature pattern is disk artifacts, not giant chat summaries. A worker writes its report, diff, or findings to a known path and returns a short pointer: path, status, risks, verification run. The orchestrator reads only what it needs. This preserves context and leaves an audit trail.

Worktrees do not isolate everything. They isolate files and branches. Ports, databases, environment variables, queues, credentials, and external services still need namespacing or coordination. A worktree plan must name shared resources before agents start.

## Worked example

You need to improve MembershipKit's event flow.

Parallel read-only audit:

```text
Subagent A: audit event auth boundaries.
Subagent B: audit RSVP data model.
Subagent C: audit UI empty/error states.
Subagent D: audit tests for missing behavior.
```

All four are fresh, read-only, same checkout is fine. Each returns a findings file.

Parallel write work:

```text
Worktree 1: fix RSVP data model tests.
Worktree 2: improve UI empty states.
```

Each has its own branch and directory. Each has a setup contract, ports, database state, and verification commands. The orchestrator merges one at a time after review. If both changed shared components, the second worktree rebases after the first merge and reruns checks.

## The rule

> Parallel read-only work can share a checkout. Parallel write work needs isolated file states. The orchestrator owns strategy, merge order, and review capacity.

## Common mistakes

**Mistake 1 — Confusing fresh context with safe writes.** A fresh subagent has clean memory, not a separate filesystem. If it writes in the same checkout, it shares disk state.

**Mistake 2 — Launching more agents than you can review.** Ten agents finish. You skim. The defects enter through the review bottleneck. Parallelism is bounded by human or evaluator review capacity.

**Mistake 3 — No shared-resource plan.** Two worktrees both use port 3000 and the same local database. File isolation works; runtime verification lies because the processes collide.

**Mistake 4 — Letting workers invent strategy.** Workers choose architecture independently and return incompatible diffs. The orchestrator should set boundaries, interfaces, and merge order before dispatch.

**Mistake 5 — Reading every worker transcript.** You dispatch to save context, then pull full transcripts back into the main session. Have workers write artifacts and return concise pointers.

## Drill

Artifacts go in `student/drills/50-parallel-orchestration/`.

**Drill 1 — Write a worktree plan.** Use `templates/worktree-plan.md` as the shape. Plan one parallel write task for your project, including branch, directory, likely files, forbidden files, ports, database state, and merge plan. Save to `student/drills/50-parallel-orchestration/01-worktree-plan.md`.

**Drill 2 — Scale the effort.** List four tasks and choose one agent, two to four agents, or no parallelism for each. Give one sentence of reasoning. Save to `student/drills/50-parallel-orchestration/02-effort-scaling.txt`.

**Drill 3 — Orchestrator dispatch pack.** Write two subagent dispatches for a parallel read-only audit. Each must include objective, output format, tool/source guidance, task boundaries, and artifact path. Save to `student/drills/50-parallel-orchestration/03-dispatch-pack.txt`.

## Checkpoint question

> You want three agents to work on auth, billing, and dashboard UI at the same time. A teammate says fresh subagents are enough because their contexts are separate. Answer in 4-5 sentences. Name what fresh context isolates, what it does not isolate, when worktrees are required, and what shared resources still need coordination.

<!-- Rewriter audit trail
Universalization pass: adds first-class worktree orchestration, orchestrator-worker framing, effort scaling, artifact pattern, and review-capacity limits.
Rewrite date: 2026-05-13
-->
