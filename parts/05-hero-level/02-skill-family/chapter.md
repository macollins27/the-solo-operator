# Chapter 33 — Hero level: the skill family

## Learning objective

The student can describe how 20-30 skills compose into a pipeline at hero level, identify the four roles skills play in a mature system (writing, reviewing, dispatching, recovering), and map their own current skill folder against the pattern.

## Prerequisites

- Completed: Chapter 32 — Hero level: mature instruction architecture
- Concepts: what-is-a-skill, anything-done-twice-is-a-skill-candidate

## Core concept

At hero level, the `.claude/skills/` folder contains 20-30 skills. They're not random workflows — they form a **pipeline**. Each skill plays one of four roles; skills of different roles compose into the full build loop.

The four roles:

**1. Writers.** Skills that produce new artifacts: code, specs, configs. Examples: `specify` (write a domain spec), `contract` (extract a layer-based build plan from a spec), `build-source` (implement one layer with per-procedure write-verify loop), `frontend-implement` (turn a wireframe into React).

**2. Reviewers.** Skills that read artifacts and produce findings. They DON'T write code — they audit. Examples: `review-source` (nine-pass adversarial review against contract + domain rules; emits structured findings), `spec-audit` (audit a spec against architecture + inventory), `test-audit` (audit tests for quality patterns), `frontend-review` (audit shipped frontend against wireframe).

**3. Dispatchers.** Skills that orchestrate other skills, typically across subagents. Examples: `contract-feature` (writes a multi-domain contract by fanning out one subagent per layer), `qa-runner` (dispatches QA subagents per flow), `cto` (read-only judge that decides between options).

**4. Recoverers.** Skills that respond to failure. Examples: `fix-source` (per-bug fix cycle), `test-fix` (repair broken tests without weakening assertions), `qa-verify` (verify a finding is real, not a false positive), `domain-status` (read current state and recommend next action).

A typical workflow uses skills from all four roles in sequence:

```
specify → contract → build-source → review-source → pnpm gate → qa-audit → fix-source
 (write)  (write)    (write)        (review)        (mechanical) (review)   (recover)
```

`gate` is a script you compose once you've reached this maturity level — typically `pnpm lint && pnpm exec tsc --noEmit && pnpm test`. If you don't have one yet, run `pnpm lint && pnpm exec tsc --noEmit` as the equivalent.

Each skill is small (~200-500 lines of SKILL.md). Each skill calls specific tools. The pipeline emerges from composition, not from any single skill being huge.

Three discipline points that make a mature skill family work:

**1. Single responsibility per skill.** No mega-skill that does everything. The skill that writes a Layer Brief does not also dispatch the build for it. Different role; different skill. Writers don't audit themselves; reviewers don't rewrite code; dispatchers don't do the work.

**2. Per-layer / per-stage / per-procedure decomposition.** A skill that builds an entire feature in one invocation accumulates drift — violations compound, the AI forgets earlier choices, the final gate run lumps errors together. The mature pattern is one stage per invocation. `build-source` builds ONE LAYER of a domain — not the whole domain. `page-build` runs ONE STAGE per invocation — `map`, `plan`, `build-index`, `build-detail`, `verify` — each terminating with a structured exit sentinel. Each invocation has bounded scope; mechanical checks fire at the boundary; the next stage is a separate dispatch.

**3. Structured exit signals.** Every staged skill requires the FIRST line of output to be a structured sentinel naming scope + ISO8601 timestamp. Every TERMINATION emits a sentinel plus a JSON exit object. The orchestrator parses mechanically. A missing sentinel is a process-compliance failure, flagged alongside the raw response. Without sentinels, the orchestrator can't tell whether the subagent actually completed scope or stopped halfway — re-dispatch is unsafe and skipping forward is unsafe.

A mature system also distinguishes:

- **Project skills** at `.claude/skills/<name>/` — apply to this project.
- **User-global skills** at `~/.claude/skills/<name>/` — apply across all your projects.
- **Plugin skills** distributed via plugins — opted in.

The same operator can have very different skill needs across projects. A healthcare project doesn't need a `dues-plan-validate` skill; a community app doesn't need `medical-record-export`. The split keeps each project's skill set focused on the project's actual surface.

## Worked example

A walkthrough of how skills compose in a real feature build:

1. You add the renewal-reminder feature to MembershipKit.
2. Run `/specify renewal-reminders` — the `specify` skill produces `domain-rules/renewal-reminders.md`.
3. Run `/contract renewal-reminders` — the `contract` skill produces a build contract: which procedures, which Layers, which invariants per Layer. The skill's first output line is `STAGE-COMPLETE: contract` followed by a JSON object with the artifact path.
4. Run `/build-source renewal-reminders --layer 1` — the `build-source` skill builds Layer 1. After each procedure: 15 mechanical grep checks. After the layer: `pnpm gate` as hard gate. Final output: `STAGE-COMPLETE: build-source layer 1` + JSON with files changed and gate-result SHA.
5. Repeat for layer 2, layer 3, ... Each is a separate dispatch with its own sentinel.
6. Run `/review-source renewal-reminders` — nine passes of structured review. Emits findings as a JSON array.
7. Triage findings; dispatch `/fix-source` per finding. Each fix re-runs gate.
8. Once all findings are closed: run `/qa-audit renewal-reminders --flow signup`. Dispatches a QA subagent.
9. If QA finds bugs: `/fix-source` again; re-gate; re-QA.

Eight skill invocations across six skill types, each emitting structured sentinels. The pipeline is YOUR composition; the skills are the units. Each unit is auditable; each transition is structured.

## The rule

> Skills come in four roles: writers, reviewers, dispatchers, recoverers. Single responsibility per skill. One layer / one stage / one procedure per invocation. Every staged skill emits a structured sentinel as its first line of output and at termination — the orchestrator parses mechanically, never interprets prose.

## Common mistakes

**Mistake 1 — One mega-skill that does everything.** "Build a feature from spec to shipped" sounds appealing; in practice the mega-skill branches internally and is impossible to debug. Splitting into specify + contract + build-source + review-source + fix-source produces five reusable units that compose into the pipeline. Roles stay clean.

**Mistake 2 — Skills that bypass each other.** A `build-source` skill that also "auto-reviews its work" is doing two roles, badly. Reviews need a fresh-context, adversarial agent — not the same one that just wrote the code. Self-review is biased by the same reasoning thread that produced the work. Maintain role boundaries.

**Mistake 3 — Skills without structured exit signals.** A skill that ends with "Done!" tells the orchestrator nothing actionable. A skill that ends with `STAGE-COMPLETE: <stage>` + a JSON exit object lets the orchestrator decide the next dispatch mechanically. Without sentinels, you have prose; with them, you have a protocol.

**Mistake 4 — Skills that try to build everything in one invocation.** Accumulated drift. The mature pattern is per-stage / per-layer / per-procedure with mechanical checks at each boundary. Each invocation has bounded scope; the next unit is a separate dispatch.

## Drill

Artifacts in your fork.

**Drill 1 — Audit your skill folder.** List all skills in `student/.claude/skills/`. Classify each by role (writer / reviewer / dispatcher / recoverer). Save the classification to `student/drills/33-skill-family/01-skill-roles.txt`. Format: `<skill-name>: <role>`.

**Drill 2 — Add a reviewer skill with a sentinel.** Author `student/.claude/skills/review-my-change/SKILL.md` — a small reviewer skill that reads the most recent commit's diff, checks the changes against your CLAUDE.md rules, and reports findings (no edits — review-only). The skill body opens with imperative bans ("Do NOT call Edit / Write / mutating Bash"). The skill's first output line must be `REVIEW-STAGE: <date>`; the final line must be `STAGE-COMPLETE: review` followed by a JSON object summarizing findings.

**Drill 3 — Structure the pipeline.** Write a paragraph at `student/drills/33-skill-family/02-pipeline.txt` describing the build pipeline YOU would compose for your fork: which writer + reviewer + dispatcher + recoverer skills, in what sequence, with what structured signal at each transition. You don't have to run this pipeline today; design it on paper.

## Checkpoint question

> You're operating a system where the same skill writes code AND audits it. Tests pass; CI green; deploys clean. The system has been in production for 3 months. Then a critical bug ships. Walk through what's probably wrong with the setup in 3-4 sentences — name the role-boundary violation, the self-verification bias it produces, and what skill-role discipline would have caught the bug before it reached production.

<!-- Rewriter audit trail
Grounded in verified principles: P45 (one layer / one stage / one procedure per invocation prevents drift), P36 (mandatory exit sentinels make multi-stage workflows mechanically resumable; STAGE-COMPLETE first line + JSON exit; missing sentinel = process-compliance failure), P28 (fresh-context isolation; reviewers must not be the same agent that wrote the work — self-verification is biased by the same reasoning thread)
Worked example surface: MembershipKit renewal-reminders feature build with eight staged skill invocations
Rewrite date: 2026-05-13
-->
