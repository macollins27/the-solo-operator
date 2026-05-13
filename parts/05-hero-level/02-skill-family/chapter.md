# Chapter 33 — Hero level: the skill family

## Learning objective

The student can describe how 20-30 skills compose into a pipeline at hero level, identify the four roles skills play in a mature system (writing, reviewing, dispatching, recovering), and map their own current skill folder against the pattern.

## Prerequisites

- Completed: Chapter 32 — Hero level: the mature CLAUDE.md
- Concepts: what-is-a-skill, anything-done-twice-is-a-skill-candidate

## Core concept

At hero level, the `.claude/skills/` folder contains 20-30 skills. They're not random workflows — they form a **pipeline**. Each skill plays one of four roles, and skills of different roles compose into the full build loop.

The four roles:

**1. Writers.** Skills that produce new artifacts: code, specs, configs. Examples from a mature system: `specify` (write a domain spec), `contract` (write a build contract from a spec), `build-source` (write code from a contract), `frontend-implement` (turn a wireframe into React).

**2. Reviewers.** Skills that read artifacts and produce findings. They DON'T write code — they audit it. Examples: `review-source` (9-pass adversarial review), `spec-audit` (audit a spec against architecture + inventory), `test-audit` (audit tests for quality), `frontend-review` (audit shipped frontend against wireframe).

**3. Dispatchers.** Skills that orchestrate other skills, typically across subagents. Examples: `contract-feature` (writes a multi-domain contract by fanning out one subagent per layer), `qa-runner` (dispatches QA subagents per flow), `cto` (read-only judge that decides between options).

**4. Recovers.** Skills that respond to failure. Examples: `fix-source` (per-bug fix cycle), `test-fix` (repair broken tests without weakening assertions), `qa-verify` (verify a finding is real, not a false positive), `domain-status` (read current state and recommend next action).

A typical workflow uses skills from all four roles, in sequence:

```
specify → contract → build-source → review-source → pnpm gate → qa-audit → fix-source
 (write)  (write)     (write)        (review)      (mechanical) (review)   (recover)
```

Each skill is small (~200-500 lines of SKILL.md). Each skill calls specific tools. The pipeline emerges from composition, not from any single skill being huge.

Key discipline points about a hero-level skill family:

**Skills have single responsibilities.** No mega-skill that does everything. The skill that writes a Layer Brief does not also dispatch the build for it. Different role; different skill.

**Skills produce structured exit signals.** When a skill finishes, it emits a JSON or YAML block summarizing what was done. The orchestrator (or the next skill in the pipeline) reads that block, not the skill's prose summary. Structured signals compose.

**Skills can't bypass each other.** A reviewer skill can't silently rewrite code; that's not its role. A writer skill can't approve its own output; that's the reviewer's job. The role separation is the moat against AI failure modes.

**Skills evolve via the skill-iteration protocol** (you'll see in Chapter 41). Never modify what isn't broken. Every skill change is justified per the 9-step protocol.

**Skills compose via wrapper scripts** when one skill has to fan out across multiple subagents. The wrapper script is in `scripts/`, not the skill. Skill responsibilities stay clean.

A mature system also distinguishes:

- **Project skills** at `.claude/skills/<name>/` — apply to this project's domain.
- **User-global skills** at `~/.claude/skills/<name>/` — apply across all your projects.
- **Plugin skills** — distributed via plugins, can be opted in.

The split matters because the same operator may have very different skill needs across projects. The MembershipKit project doesn't need a `medical-record-export` skill; a healthcare project doesn't need `dues-plan-validate`.

## Worked example

A walkthrough of how skills compose in a real feature build:

1. You decide to add the renewal-reminder feature to MembershipKit.
2. You run `/specify renewal-reminders` — invokes the `specify` skill, which produces `domain-rules/renewal-reminders.md` (a spec).
3. You run `/contract renewal-reminders` — invokes the `contract` skill, which reads the spec and produces a build contract: which procedures, which Layers, which invariants per Layer.
4. You run `/build-source renewal-reminders --layer 1` — invokes `build-source` per Layer. Writes the code. Runs `pnpm gate` (a script, not a skill) as a hard gate.
5. After all Layers: you run `/review-source renewal-reminders` — invokes `review-source`. 9 passes of structured review. Emits findings.
6. You triage findings, dispatch `/fix-source` per finding. Each fix re-runs gate.
7. Once all findings are closed: you run `/qa-audit renewal-reminders` — dispatches QA subagents per flow.
8. If QA finds bugs: `/fix-source` again, re-gate, re-QA.

Eight skill invocations across six skill types. The pipeline is YOUR composition; the skills are the units. Each unit is auditable; each transition is structured.

## The rule

> Skills come in four roles: writers, reviewers, dispatchers, recovers. A hero-level family has 20-30 skills composing into a pipeline. Each skill has one responsibility. Each transition between skills is via structured exit signals, not prose. The skill family is what makes the pipeline auditable and reliable.

## Common mistakes

**Mistake 1 — One mega-skill that does everything.** "Build a feature from spec to shipped" sounds appealing. In practice, the mega-skill has 30 internal branches and is impossible to debug. Splitting into specify + contract + build-source + review-source + fix-source produces five reusable units. The pipeline is the composition.

**Mistake 2 — Skills that bypass each other.** A `build-source` skill that also "auto-reviews its work" is doing two roles, badly. Reviews need a fresh-context, adversarial agent — not the same one that just wrote the code. Maintain role boundaries even when it feels redundant.

**Mistake 3 — Skills without structured exit signals.** A skill that ends with "Done!" tells the orchestrator nothing actionable. A skill that ends with a JSON block (`{"status": "complete", "files_changed": 3, "findings": []}`) lets the orchestrator decide what to do next. Mature skills always end with structured output.

## Drill

Artifacts in your fork.

**Drill 1 — Audit your skill folder.** List all skills you have so far in `student/.claude/skills/`. Classify each by role (writer / reviewer / dispatcher / recover). Save the classification to `student/drills/33-skill-family/01-skill-roles.txt`. Format: `<skill-name>: <role>`.

**Drill 2 — Add a reviewer skill.** Author `student/.claude/skills/review-my-change/SKILL.md` — a small reviewer skill that reads the most recent commit's diff, checks the changes against your CLAUDE.md rules, and reports findings (no edits — review-only). The skill should explicitly state in its body "This skill is READ-ONLY. Use only Read, Grep, Glob. Never call Edit, Write, or Bash with mutating commands."

**Drill 3 — Structure the pipeline.** Write a short paragraph at `student/drills/33-skill-family/02-pipeline.txt` describing the build pipeline YOU would compose for your fork: which writer + reviewer + dispatcher + recover skills, in what sequence, with structured signals at each transition. You don't have to actually run this pipeline today; design it on paper.

## Checkpoint question

> You're operating a system where the same skill writes code AND audits it. Tests pass; CI green; deploys clean. The system has been in production for 3 months. Then a critical bug ships. Walk through what's probably wrong with this setup — and what skill-role discipline would have caught the bug before it reached production.
