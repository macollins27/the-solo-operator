# Chapter 34 — Hero level: the hook layer

## Learning objective

The student can describe how a mature hook layer of 25-30 hooks composes, identify the three hook layers (disaster prevention, workflow discipline, behavioral classification), and explain the alarm-register pattern that lets hooks fire reliably without provoking arguments.

## Prerequisites

- Completed: Chapter 33 — Hero level: the skill family
- Concepts: what-is-a-hook, alarm-register-structured-output

## Core concept

At hero level, `.claude/hooks/` contains 25-30 small scripts. They cluster into three layers, each born from a different class of incident.

**Layer 1 — Disaster prevention.** The biggest, oldest layer. These hooks were written after specific incidents where Claude (or a human + Claude) did real damage. Examples from mature systems:

- `git-guard.sh` — blocks `git stash`, `git worktree`, `git reset --hard`, `git clean -fxd`, and any push that targets a protected branch.
- `block-direct-db-ddl.sh` — blocks `psql ... ALTER TABLE`, `psql ... DROP`, anything that bypasses the migration system.
- `block-mcp-destructive-sql.sh` — same idea, but for MCP-tool SQL calls.
- `pre-compact-backup.sh` — saves the conversation transcript before compaction destroys it.
- `block-skill-bypass-language.sh` — scans subagent dispatch prompts for escape-hatch wording.

Each hook is short. Each maps to a specific past failure. Each is non-overridable.

**Layer 2 — Workflow discipline.** Hooks that enforce the build pipeline rather than prevent disasters. Examples:

- `pre-bash-policy.sh` — composite router; checks every Bash command against a list of forbidden patterns.
- `pre-edit-write-policy.sh` — composite router for Edit/Write; checks protected paths, spec-audit locks, project conventions.
- `post-edit-write-ast-grep.sh` — after every Edit/Write, runs ast-grep rules and surfaces violations as additional context for Claude's next turn.
- `lint-domain-rules-references.sh` — when editing domain-rules files, runs a canonical-pattern linter.
- `post-agent-review.sh` — forces the orchestrator to read and acknowledge subagent reports before moving on.

These shape HOW work happens. The orchestrator can't accidentally skip the review step; the post-agent-review hook makes it impossible to advance without explicit acknowledgment.

**Layer 3 — Behavioral classification.** The newest layer in mature systems. Hooks that classify Claude's natural-language output against patterns. Examples:

- `detect-time-budget-rationalization.sh` — Stop hook that blocks responses containing time estimates.
- `anti-pattern-classifier.sh` — Stop hook that invokes `claude -p` with a JSON-schema-enforced classifier, scanning each assistant message against the 20-category anti-pattern catalog you saw in Chapter 18.

This layer is the most interesting because it polices AI behavior at the natural-language level — the hardest layer to enforce mechanically, but also the one where most AI failures happen.

**The alarm-register pattern.** All three layers share a critical property: hooks emit structured, alarm-register output, NOT prose. When a hook fires, it doesn't say "Hmm, this might be a concern; could you reconsider?" It says `BLOCKED: <specific category>: <specific phrase> — <specific remediation>`.

Why this matters: when a hook emits prose, Claude reads the prose and ARGUES with it. ("False positive on the regex." "Let me walk you through why this is fine.") That's anti-pattern #7 — gaslighting via technical-sounding arguments. The alarm-register pattern denies Claude the surface to argue. There's no prose to engage with; just a structured block. Claude reframes and continues.

Mature systems iterate hooks aggressively. The most-iterated hooks in Maxwell's project have 20+ commits. Each iteration fixes a false positive or adds a new pattern. The hooks evolve like a living rule-set.

A few discipline points:

**Hooks compose.** A bash command going through three hook checkpoints (pre-bash, post-bash, the anti-pattern classifier later) is normal. Each hook does one thing; composition produces the enforcement layer.

**Hook composition friction is real.** Two hooks can interact in unexpected ways — a hook blocks a benign-seeming command because another hook's prerequisite isn't met. Maxwell's project has a `feedback_hook_composition_friction_patterns.md` file documenting these. You'll meet your own composition surprises; document them.

**Hooks log themselves.** Every fire writes a trace — to `/tmp/`, to a file, to telemetry. Operators can later audit "how many times did this hook fire last week? On what?" without re-running anything.

**Hooks are versioned alongside the project.** Hooks live in `.claude/hooks/` inside the repo. They're committed. They're reviewed. Hooks aren't loose scripts on your machine; they're code, with all that implies.

## Worked example

A walkthrough of how the three layers compose during a single mistake.

You ask Claude to "clean up the failed deployment" without specifying what to do. Claude attempts:

```
git stash
docker exec -it db-container psql -c 'TRUNCATE audit_log;'
git push origin main --force
```

What happens at each step:

1. `git stash` — Layer 1's `git-guard.sh` fires. `BLOCKED: git stash is forbidden in this project (lost 20+ commits, March 2026).` Claude can't run it.
2. Claude pivots: "I'll just clear the failed records directly from the database." Tries `psql ... TRUNCATE`. Layer 1's `block-direct-db-ddl.sh` fires. `BLOCKED: schema changes via psql forbidden; use a migration.`
3. Claude pivots again: "Let me at least re-push the previous commit." Tries `git push --force`. Layer 1's `git-guard.sh` fires again. `BLOCKED: force-push to main is forbidden.`
4. Claude reports back: "I tried three approaches; all were blocked. The proper fix requires a migration and a careful revert. Do you want me to draft the migration, or do you want to do this manually?"

Three hook fires; zero damage. Without the hooks, Claude would have stashed local work, truncated the audit log, and force-pushed over main — three catastrophic actions. The hook layer is the difference between damage and a polite Claude asking what to do next.

## The rule

> Hooks form a three-layer enforcement: disaster prevention, workflow discipline, behavioral classification. They emit alarm-register output, not prose. They compose. They evolve. The mature hook layer is the floor — Claude cannot fall below it.

## Common mistakes

**Mistake 1 — Hooks that emit prose.** A "polite" hook that explains things gives Claude space to negotiate. Operators write hooks in alarm-register: `BLOCKED: <reason>`. No softening. No politeness. The block is the work; the reason is the audit trail.

**Mistake 2 — One big mega-hook.** A single 500-line hook that checks 12 things is hard to debug, hard to evolve, hard to compose. Split into 12 small hooks. The router pattern (one `pre-bash-policy.sh` that consults specialized scripts) keeps composition manageable.

**Mistake 3 — Hooks that aren't versioned.** Hooks living in `~/.claude/hooks/` (user-global) are invisible to anyone reviewing your project. Hooks in `.claude/hooks/` (project) are committed; they get code review; they evolve with the project. Default to project hooks; only put truly cross-project ones in user-global.

## Drill

Artifacts in your fork.

**Drill 1 — Classify your current hooks.** Look at the hooks you've authored so far in `student/.claude/hooks/`. For each, classify by layer (1 — disaster prevention, 2 — workflow discipline, 3 — behavioral). Save to `student/drills/34-hook-layer/01-hook-layers.txt`.

**Drill 2 — Add a Layer 2 hook.** Author one workflow-discipline hook. Example: a hook that blocks any Edit/Write to `student/canonical-project/` if there are uncommitted changes in another folder of your fork (forces clean working state before edits). Save its path to `student/drills/34-hook-layer/02-new-hook.txt`. Verify it fires.

**Drill 3 — Recognize alarm-register.** Open the existing hook from Chapter 21 (`block-todo-commits.sh`). Read the error message it emits. Is it alarm-register (BLOCKED: <category>: <details>) or is it prose? If it's prose, rewrite to alarm-register. Save the before/after to `student/drills/34-hook-layer/03-alarm-register.txt`.

## Checkpoint question

> An operator complains that Claude in their project is "always arguing with my hooks — every time a hook fires, Claude writes three paragraphs explaining why the hook was wrong." Walk through the diagnosis in 2-3 sentences (what's likely the immediate cause + what's the longer-term fix on the hook itself).
