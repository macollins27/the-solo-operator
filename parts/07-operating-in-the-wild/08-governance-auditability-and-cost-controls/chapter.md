# Chapter 51 — Operating in the Wild: governance and cost controls

## Learning objective

The student can define review gates, audit trails, attribution, protected surfaces, and cost limits for agent work in solo or team settings.

## Prerequisites

- Completed: Chapter 50 — Operating in the Wild: parallel work and orchestration
- Concepts: protected-agentic-primitive-files, review-bandwidth-as-concurrency-limit, workflow-eval

## Core concept

Governance means agent work remains accountable.

For a solo operator, governance is lightweight: session transcript, git diff, commits, test output, screenshots, decision notes, and cost log. For a team, the same principle becomes review gates, audit logs, branch rules, protected files, agent identity, and spending limits.

The rule is simple: agent-authored work passes the same gates as human-authored work. If anything, AI work gets stricter gates until trust is earned mechanically. Do not create "AI exception paths" that bypass tests, code review, security scans, or protected-branch rules.

Auditability asks six questions:

**Who or what acted?** Human, local agent, cloud agent, subagent, automation.

**What prompt or ticket started it?** The task contract or issue is part of the record.

**What tools ran?** Commands, MCP calls, browser actions, external APIs.

**What changed?** Git diff, files, migrations, generated artifacts.

**What verified it?** Tests, lint, typecheck, screenshots, review, evals.

**Who accepted it?** Human reviewer, fresh review agent, CI gate, or explicit operator approval.

Attribution matters. Distinguish human-authored, AI-authored, AI-reviewed, and AI-committed changes when your context requires it. The point is not ceremony; the point is knowing how much review burden belongs on the change.

Cost controls are governance too. Agent spending can spike through parallel sessions, strongest-model overuse, runaway loops, or background jobs without stop conditions. Set model defaults, usage limits, alert thresholds, and stop rules before launching broad work. Cost budgets are safety rails, not time estimates.

## Worked example

Bad governance:

```text
Cloud agent assigned issue: "clean up auth."
Agent opens PR with 31 files changed.
Tests skipped because setup failed.
PR says "minor refactor."
Merged because diff looked plausible.
```

Good governance:

```text
Ticket includes Goal / Context / Constraints / Done When.
Agent runs in isolated branch.
Protected paths require human approval.
PR description lists changed files, behavior, tests, risks, rollback.
CI passes. Fresh reviewer checks auth/security paths.
Human approves after reading diff and screenshots.
Cost limit prevents retry loop after two failed setup attempts.
```

The difference is not trust in the model. It is the audit trail around the work.

## The rule

> Agent-authored work needs traceability: task, tools, diff, checks, reviewer, and cost boundary. Never let AI work bypass gates you require from humans.

## Common mistakes

**Mistake 1 — AI exception paths.** "It's just agent work, so skip review." Backwards. Generated code can be fast, plausible, and wrong. It needs gates.

**Mistake 2 — No protected primitive files.** Agents casually edit `AGENTS.md`, hooks, MCP configs, setup workflows, or CI. Those files define future agent behavior and need stricter review.

**Mistake 3 — No attribution.** A later bug appears and no one knows whether the code was human-written, AI-written, AI-reviewed, or mechanically generated. The review burden becomes impossible to reconstruct.

**Mistake 4 — Unlimited background work.** A background agent loops on failing setup, retries with the strongest model, and burns budget without producing evidence. Every autonomous workflow needs stop conditions.

**Mistake 5 — Cost treated as shame instead of signal.** High spend is not automatically bad; unbounded spend without attribution is bad. Track which workflows consume cost and whether they reduce maintenance burden.

## Drill

Artifacts go in `student/drills/51-governance-cost/`.

**Drill 1 — Define review gates.** Write the gates agent-authored changes must pass in your project: checks, review, protected paths, screenshots, security review, or human approval. Save to `student/drills/51-governance-cost/01-review-gates.txt`.

**Drill 2 — Write an audit log entry.** Use `templates/governance-audit-log.md` as the shape. Create one audit entry for a hypothetical agent change, naming actor, prompt/ticket, tools, changed files, verification, reviewer, and decision. Save to `student/drills/51-governance-cost/02-audit-entry.md`.

**Drill 3 — Set cost controls.** Use `templates/cost-controls.md` as the shape. Define default model tiers, usage cap, stop conditions, and when strongest-model work is allowed. Save to `student/drills/51-governance-cost/03-cost-controls.md`.

## Checkpoint question

> A cloud agent opens a large PR that changes auth middleware, tests, `AGENTS.md`, and CI config. It says all checks pass, but the test command was skipped because setup failed. Answer in 4-5 sentences: what gates should block this, what audit facts are missing, what files require special review, and what cost/stop rule should have prevented the loop.

<!-- Rewriter audit trail
Universalization pass: adds governance, auditability, attribution, protected primitive files, and cost controls for solo and team agent workflows.
Rewrite date: 2026-05-13
-->
