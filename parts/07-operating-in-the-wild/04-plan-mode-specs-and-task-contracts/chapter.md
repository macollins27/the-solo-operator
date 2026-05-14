# Chapter 47 — Operating in the Wild: plan mode and task contracts

## Learning objective

The student can decide when planning is required, write an agent task contract with Goal / Context / Constraints / Done When, and recognize when planning has become deferral.

## Prerequisites

- Completed: Chapter 46 — Operating in the Wild: task, tool, and model selection
- Concepts: agent-surface-selection, background-agent-ticket-shape, spec-as-authority

## Core concept

Planning is not weakness. Bad planning is weakness.

A useful plan is a reviewable artifact: files to inspect, files likely to change, risks, verification commands, acceptance criteria, and stop conditions. It lets you catch a wrong mental model before the agent writes code. A deferral plan is different: it names phases without commits, promises future verification, hides uncertainty behind time estimates, or says "the rest is execution" while no artifact has changed.

Use plan-first workflow when the task is ambiguous, multi-file, high-risk, unfamiliar, security-sensitive, migration-heavy, or hard to reverse. Skip plan mode for tiny edits where the diff can be described in one sentence.

The default task contract:

```text
Goal:
What changes for the user or system.

Context:
Relevant files, errors, docs, screenshots, issue links, current behavior.

Constraints:
Architecture, style, security, protected paths, do-not rules.

Done When:
Tests, screenshots, command output, PR/diff review, behavior observed.
```

Spec-driven development is the larger version of the same discipline. A **spec** is an operator-authored statement of desired behavior and boundaries. The usual sequence is specify, plan, split into tasks, implement. Specs are useful when the agent needs product intent preserved across sessions or workers. Specs are overkill when they become markdown bureaucracy for a one-line fix.

Subagent dispatches need an even tighter four-part contract: objective, output format, tool/source guidance, and task boundaries. If you omit output format, the subagent returns prose you cannot compose. If you omit boundaries, it explores forever or edits outside its lane.

## Worked example

Bad prompt:

```text
Fix billing.
```

Better contract:

```text
Goal:
Members cannot access paid content after subscription expiry.

Context:
Relevant files are the subscription status procedure, dashboard access guard,
and billing webhook handler. Current bug: expired users still reach dashboard.

Constraints:
Do not change payment provider versions. Do not weaken auth middleware.
Use existing subscription status enum.

Done When:
Add failing test first. Implement minimum fix. Run unit tests for billing
and auth guard. Browser-check expired member redirects to billing page.
Review diff for unrelated changes.
```

For a review subagent:

```text
Objective: Audit the billing access fix for regressions.
Output format: Findings table with severity, file, line, evidence, fix.
Tool/source guidance: Read the spec, changed files, tests, and git diff only.
Task boundaries: Do not edit. Do not audit unrelated billing features.
```

## The rule

> Plan when the task is ambiguous, risky, multi-file, unfamiliar, or hard to reverse. Skip planning for obvious tiny edits. Every agent task needs Goal, Context, Constraints, and Done When.

## Common mistakes

**Mistake 1 — Planning as performance.** The agent writes a polished multi-phase plan with no file map, no risk, no verification, and no next edit. That is ceremony, not planning.

**Mistake 2 — Skipping planning on high-risk work.** "Just implement it" on auth, billing, migrations, permissions, or production data invites hidden assumptions. Ask for an explore-first plan, review it, then execute.

**Mistake 3 — Asking for a plan, then never reviewing it.** Plan mode only pays off if the operator reads the plan and challenges wrong assumptions before code changes.

**Mistake 4 — Letting specs replace enforcement.** A spec can say "never leak cross-organization data." A test, database policy, middleware guard, and review gate are what make that true.

**Mistake 5 — Dispatching subagents with vague output.** "Look into this" produces an essay. Specify objective, output format, sources/tools, and boundaries before dispatch.

## Drill

Artifacts go in `student/drills/47-plan-mode-task-contracts/`.

**Drill 1 — Classify planning need.** List five tasks from your project. Mark each as plan-first or skip-plan. Give one sentence of reasoning for each. Save to `student/drills/47-plan-mode-task-contracts/01-plan-classification.txt`.

**Drill 2 — Write a task contract.** Pick one plan-first task. Write Goal, Context, Constraints, and Done When. Include at least two verification artifacts. Save to `student/drills/47-plan-mode-task-contracts/02-task-contract.txt`.

**Drill 3 — Write a subagent dispatch.** Write a four-part dispatch for a review or audit subagent: Objective, Output format, Tool/source guidance, Task boundaries. Save to `student/drills/47-plan-mode-task-contracts/03-subagent-dispatch.txt`.

## Checkpoint question

> An agent returns a plan with five phases, time estimates, and "after that the rest is implementation." It names no files, no risks, no tests, and no done criteria. Answer in 4-5 sentences: is this useful planning or deferral, what is missing, and what exact contract would you ask for before allowing edits?

<!-- Rewriter audit trail
Universalization pass: adds plan mode without deferral, Goal / Context / Constraints / Done When, spec-driven-development framing, and four-part subagent dispatch contracts.
Rewrite date: 2026-05-13
-->
