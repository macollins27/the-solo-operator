# Chapter 44 — Operating in the Wild: origin and public canon

## Learning objective

The student can explain what parts of this course are field-tested operating doctrine, what parts are public reference workflows, and how to compare them without treating either as universal law.

## Prerequisites

- Completed: Chapter 43 — Building YOUR system over time
- Concepts: corpus-as-moat, mature-instruction-architecture, three-tier-model-routing

## Core concept

This course is not a neutral survey. It is a field manual extracted from sustained operation: one operator, one serious project, one tool-shaped environment, many real failures, and a long feedback loop. That origin is the strength. It gives the course its hard edge on enforcement, anti-fabrication, hooks, skills, MCP, subagents, and operator psychology. It is also the bias. Field-tested does not mean universal.

Public agent practice gives you the comparison set. Boris Cherny's reference workflow shows high-concurrency Claude Code operation: many sessions, plan-first PR work, slash commands, review subagents, allowlisted permissions, and strong verification loops. Simon Willison's public writing gives the professional culture: deliver code you have proven to work, use red/green testing, keep templates, and collect things you know how to do. Obra Superpowers shows reusable skill discipline and multi-agent red/green/refactor patterns. Anthropic's engineering canon gives the conceptual foundation: context engineering, simple agent patterns before complex ones, tool contracts, and orchestrator-worker research systems.

The tool landscape is broader than the lab bench: Claude Code, Codex, Cursor, Aider, Copilot, Gemini CLI, Windsurf, Devin, Cline, Roo Code, Replit, and whatever replaces them. The substrate is converging around the same primitives: instruction files, plan-then-execute, tool calls, MCP, subagents, review gates, and context isolation.

The mature operator stance is neither tool tribalism nor trend-chasing. Use this course as your spine. Use public workflows as references. When they agree, trust the convergence. When they disagree, ask what context changed: solo vs team, low-risk vs high-risk, read-only vs write-heavy, local vs cloud, prototype vs production, cost-sensitive vs quality-first.

## Worked example

You compare two recommendations:

- This course says repeated violations become hooks.
- A public workflow says the creator's setup is surprisingly vanilla and relies heavily on plan mode plus verification.

These do not conflict. They describe different layers. Vanilla setup can work when the operator is expert, attentive, and running tight verification loops. Hooks become valuable when a failure has repeated, the cost of another miss is high, or the team needs the rule to survive beyond one operator's attention.

The operator answer is:

```text
I will start with a short AGENTS.md, a short CLAUDE.md, plan-first workflow for complex changes, and manual diff review.
If the same violation happens twice, I promote it: rule -> skill -> hook, depending on whether the fix is guidance, workflow, or enforcement.
```

That answer respects both sources without flattening them into dogma.

## The rule

> Treat this course as a field-tested spine, not scripture. Treat public workflows as reference implementations, not replacements for judgment.

## Common mistakes

**Mistake 1 — Turning the corpus into law.** "The course says hooks matter, so every project starts with 30 hooks." Wrong. Hooks are earned by repeated or high-cost failures. Before that, use rules, reviews, and manual discipline.

**Mistake 2 — Copying public celebrity workflows.** "Boris runs many sessions, so I should too." His workflow assumes expert review capacity, strong verification habits, and isolated checkouts. Copy the principle; scale the concurrency to your current review bandwidth.

**Mistake 3 — Tool tribalism.** "This is a Claude Code course, so other agents don't matter." Wrong. Claude Code is the primary lab bench. The transferable skill is operating agents through context, tools, verification, security boundaries, and feedback loops.

**Mistake 4 — Treating public docs as softer than field failures.** Public docs give names and frames the field has converged on: context engineering, AGENTS.md, MCP, plan mode, worktrees, evals, prompt injection. You need that vocabulary to generalize the course outside one project.

## Drill

Artifacts go in `student/drills/44-origin-and-public-canon/`.

**Drill 1 — Name the origin.** Write 5-7 sentences explaining the course's origin and bias: what makes it strong, and what makes it non-universal. Save to `student/drills/44-origin-and-public-canon/01-origin-bias.txt`.

**Drill 2 — Map the public canon.** Pick three public references from this chapter. For each, write one thing it reinforces from the course and one thing it adds that the course did not originally emphasize. Save to `student/drills/44-origin-and-public-canon/02-public-canon-map.txt`.

**Drill 3 — Choose the operating stance.** Write the first paragraph you would put in your own project's `AGENTS.md` to make it tool-portable. It must mention the lab bench you use, the fact that instructions are portable, and the verification gate before "done." Save to `student/drills/44-origin-and-public-canon/03-operating-stance.txt`.

## Checkpoint question

> A teammate says, "This course came from one person's project, so we should ignore the opinionated parts and just follow official docs." Answer in 4-5 sentences. Name what the field-tested layer gives you, what public docs give you, and how you decide what to adopt in your own project.

<!-- Rewriter audit trail
Universalization pass: adds honest origin framing, public reference workflows (Boris Cherny, Simon Willison, Obra Superpowers, Anthropic engineering canon), and cross-tool landscape orientation. Keeps Claude Code as lab bench while making the transferable operating layer explicit.
Rewrite date: 2026-05-13
-->
