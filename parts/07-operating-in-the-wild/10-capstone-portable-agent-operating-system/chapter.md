# Chapter 53 — Operating in the Wild: portable agent operating system

## Learning objective

The student can assemble a portable agent operating system for their project: instructions, setup, security boundaries, task contracts, review gates, learning loop, and automation policy.

## Prerequisites

- Completed: Chapter 52 — Operating in the Wild: MCP and tool ergonomics
- Concepts: universal-agent-operating-spine, agent-governance, workflow-eval

## Core concept

The course ends where real operation begins.

A portable agent operating system is the set of files, rules, checks, tools, and habits that make agents useful across tools. It is not one prompt. It is not one model. It is the operating layer around the agent.

The minimum system:

**Instruction base.** `AGENTS.md` with project identity, authority hierarchy, setup commands, protected paths, and done criteria.

**Tool overlay.** Tool-specific files like `CLAUDE.md` that add local commands, hooks, MCP tools, slash commands, or session habits.

**Setup contract.** Install, run, test, seed, dev URL, fake credentials, and failure-output expectations.

**Security boundary.** Lethal-trifecta map, protected primitive files, network/filesystem/data rules, and review gates for external communication.

**Task contract.** Goal, Context, Constraints, Done When for work; four-part dispatch for subagents.

**Verification ladder.** Static, unit, integration, browser/API, regression, human/fresh review.

**Parallelism policy.** Read-only audits can share checkouts; write agents need worktrees; review bandwidth limits concurrency.

**Governance and cost.** Audit log, attribution, model-tier defaults, usage caps, retry limits, and stop conditions.

**Learning loop.** `learnings.md`, promotion rule, workflow evals, and a manual -> skill -> stable repeat -> automation ladder.

This system is portable because the principles are not Claude-specific. Claude Code remains the lab bench. The operating system transfers to Codex, Cursor, Aider, Copilot, Gemini CLI, cloud agents, and whatever comes next.

## Worked example

Your project's first portable system might contain:

```text
student/AGENTS.md
student/CLAUDE.md
student/learnings.md
student/docs/code_review.md
student/docs/security-boundaries.md
student/docs/agent-setup-checklist.md
student/docs/workflow-eval.md
student/docs/cost-controls.md
```

The first session prompt becomes short:

```text
Read AGENTS.md and CLAUDE.md.
Read the latest handoff if present.
Confirm setup commands and protected paths.
Then ask for the task contract before editing.
```

That is the compound effect of the course. The agent does not need a heroic prompt because the project carries the operating system.

## The rule

> Build the system, not the prompt. A portable agent operating system is instructions, setup, security, contracts, verification, governance, and learning loops carried in the repo.

## Common mistakes

**Mistake 1 — One mega prompt.** The operator tries to paste the entire operating system into every session. Put stable rules in files, tools, hooks, and templates.

**Mistake 2 — Claude-only architecture.** Everything lives in `CLAUDE.md`. Teammates using other agents lose the operating contract. Put portable rules in `AGENTS.md`; overlays add tool-specific behavior.

**Mistake 3 — No promotion path.** Learnings accumulate but never become rules, skills, hooks, or tool changes. The system records pain without reducing future pain.

**Mistake 4 — Automation before stability.** The operator schedules a workflow that still needs manual correction. Automation should follow repeated success, not hope.

**Mistake 5 — No final audit.** The files exist, but no one checks whether they conflict, duplicate, or leave gaps. A system needs periodic consolidation.

## Drill

Artifacts go in `student/drills/53-portable-agent-os/`.

**Drill 1 — Assemble the system map.** List the files that make up your portable agent operating system. Include instruction files, setup, security, review, cost, learning, and eval artifacts. Save to `student/drills/53-portable-agent-os/01-system-map.txt`.

**Drill 2 — Write the first-session protocol.** Write the first message you would give a fresh agent in your project. It must reference `AGENTS.md`, the tool overlay, latest handoff, setup commands, protected paths, and task contract. Save to `student/drills/53-portable-agent-os/02-first-session-protocol.txt`.

**Drill 3 — Run the final gap audit.** Audit your system against the minimum list in this chapter. Mark each item present, missing, or weak. Pick the top three repairs. Save to `student/drills/53-portable-agent-os/03-gap-audit.txt`.

## Checkpoint question

> A founder asks you for "the perfect prompt" to make agents build their app reliably. Answer in 4-5 sentences. Explain why a prompt is the wrong unit, what files and gates form the real operating system, and how the system stays portable across different agent tools.

<!-- Rewriter audit trail
Universalization pass: capstone chapter assembling the universal agent operating course into a portable repo-carried operating system.
Rewrite date: 2026-05-13
-->
