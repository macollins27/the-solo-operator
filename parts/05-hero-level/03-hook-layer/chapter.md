# Chapter 34 — Hero level: the hook layer

## Learning objective

The student can describe how a mature hook layer of 25-30 hooks composes, identify the three hook layers (disaster prevention, workflow discipline, behavioral classification), and explain the patterns that let hooks compose with friction without fighting it.

## Prerequisites

- Completed: Chapter 33 — Hero level: the skill family
- Concepts: what-is-a-hook, alarm-register-structured-output

## Core concept

At hero level, `.claude/hooks/` contains 25-30 small scripts. They cluster into three layers, each born from a different class of incident.

**Layer 1 — Disaster prevention.** Each hook maps to a specific past failure:

- `git-guard.sh` — blocks `git stash`, unmanaged/destructive `git worktree` operations, `git reset --hard`, `git clean -fxd`, push to protected branches. Origin: 2026-03-20 incident, 20+ commits lost.
- `block-direct-db-ddl.sh` — blocks `psql ... ALTER TABLE` / `DROP`, anything bypassing migrations.
- `block-skill-bypass-language.sh` — scans subagent dispatch prompts for skill-bypass wording; nineteen recognition patterns; sentence-level negation awareness; forces positive-only framing.
- `pre-edit-write-policy.sh` — composite router; protects state-artifact paths from model writes (state files are hook-written only; direct model writes would allow state fabrication).

**Layer 2 — Workflow discipline.** Hooks that enforce the build pipeline:

- `pre-bash-policy.sh` — checks every Bash command. After gate failure, blocks `git blame` / `git diff HEAD --name-only` for 10 minutes — provenance-investigation as deferral.
- `post-bash-policy.sh` — after `pnpm gate`, on FAIL, injects context naming the 10 invalid responses and the canonical action.
- `lint-domain-rules-references.sh` — canonical-pattern linter with same-line historical-marker allow ("legacy / previously / supersedes / MUST NOT / SOURCE BUG / replaces").
- `post-agent-review.sh` — forces orchestrator to read and per-finding classify (FIX / DOCUMENT / ESCALATE).
- `session-stop.sh` — phase-completion gate. Detects completion phrases; reads `reviewer-state.json`; blocks exit unless `clean=true`, `validity=valid`, AND `sourceHash === git rev-parse --short HEAD`.

**Layer 3 — Behavioral classification.** Hooks that classify the AI's natural-language output:

- `detect-time-budget-rationalization.sh` — Stop hook with 33+ regex patterns ("this should take ~4 hours," "(~10 minutes)," "since this morning," "out of scope for this pass," "as a first pass," "the rest is execution"). Cap of three triggers per session.
- `anti-pattern-classifier.sh` — Stop hook invoking `claude -p` with JSON-schema-enforced output, scanning against the 20-category catalog. Context-aware disambiguation reads the user's preceding message.

The three layers share two critical properties:

**Output register: declarative neutral imperative.** Not alarm. Not all-caps. Not "MANDATORY ACTIONS / you MUST acknowledge / Do NOT continue." Alarm register pushes the AI to placating/defensive disposition — the exact mode the hook was meant to prevent. The right form is "Condition: <X>. Action: <Y>. Invalid responses: <list>." Neutral declarative imperative. The block is the work; the rationale lives in the hook's body comment.

**False-positive calibration favors blocking.** A false positive costs one Stop-loop iteration; a false negative costs the operator's attention. The first is recoverable; the second compounds trust loss. "When in doubt, BLOCK." A context-aware disambiguation layer (reading the user's prior message) lets legitimate framings pass.

**Hook composition friction is real.** Hooks compose by firing in sequence at the same event; a bash command can go through three checkpoints. Two hooks can interact unexpectedly — a hook blocks a benign-seeming command because another hook's prerequisite isn't met. The mature pattern: engineer AROUND the friction, don't fight it. When a hook blocks a legitimate command, the AI's instinct is to modify the hook (which affects every future session) or to attempt a syntactic bypass (`git push origin +HEAD:main` instead of `git push --force origin main`). Both are wrong. The right responses: (a) use the approved command path the hook recognizes, such as an orchestrator-approved worktree creation script, (b) write a commit message body to a file and use `git commit -F /tmp/msg.txt` (engineering workaround), (c) ask the operator to run the command via `!` prefix, or (d) fix the underlying state. Modifying the hook to weaken it is forbidden; the friction is the cost of the discipline.

## Worked example

A walkthrough of how the three layers compose during one mistake.

You ask the AI to "clean up the failed deployment" without specifying what to do. The AI attempts:

```
git stash
docker exec -it db-container psql -c 'TRUNCATE audit_log;'
git push origin main --force
```

What happens at each step:

1. `git stash` — Layer 1's `git-guard.sh` fires. `BLOCKED: git stash is forbidden in this project (2026-03-20 incident: 20+ commits lost).` The AI can't run it.
2. The AI pivots: "I'll clear the records directly from the database." Tries `psql ... TRUNCATE`. Layer 1's `block-direct-db-ddl.sh` fires. `BLOCKED: schema changes via psql forbidden; use a migration.`
3. The AI pivots again: "Let me at least re-push the previous commit." Tries `git push --force`. Layer 1's `git-guard.sh` fires again. `BLOCKED: force-push to main is forbidden.`
4. The AI considers a syntactic bypass: `git push origin +HEAD:main`. The guard's pattern catches the equivalent shape; still blocked. The AI's instinct to edit the hook to allow this case is also caught — `.claude/settings.json` is on the protected-path list; model writes are denied.
5. The AI reports back: "I tried four approaches; all were blocked. The proper fix requires a migration and a careful revert. Do you want me to draft the migration?"

Four hook fires; zero damage. Without the hooks, the AI would have stashed local work, truncated the audit log, force-pushed over main, and edited the settings file to remove the guard — four catastrophic actions. The hook layer is the difference between damage and a polite AI asking what to do next.

## The rule

> Hooks form three layers: disaster prevention, workflow discipline, behavioral classification. They emit declarative-imperative output, not alarm. They compose at the tool boundary. Composition friction is real — engineer around it, don't fight it. When a hook blocks legitimate work, the right move is an engineering workaround OR the operator running with the `!` prefix, NEVER editing the hook to weaken it.

## Common mistakes

**Mistake 1 — Hooks that emit alarm prose.** All-caps "MANDATORY ACTIONS / you MUST acknowledge / Do NOT continue" pushes the AI to placating disposition. The AI says "yes, I will comply" and changes nothing. The right register names the condition + action + invalid responses, nothing more.

**Mistake 2 — One mega-hook checking 12 things.** A 500-line hook is hard to debug, hard to evolve, hard to compose. Split into 12 small single-purpose hooks. The router pattern — one `pre-bash-policy.sh` that consults specialized scripts — keeps composition manageable.

**Mistake 3 — Bypassing hook friction via syntactic tricks or hook edits.** "The hook blocks `git push --force`; I'll use `git push origin +HEAD:main`." Forbidden — the hook exists for a reason; friction is the cost. The engineering workaround (approved worktree path, file-based commit body, `!` prefix, fix the underlying state) preserves the discipline.

**Mistake 4 — Hooks that allow legitimate variants to slip through.** A linter blocks every `new Date()` in a domain-rules file, including the correction-trail prose "Previously used `new Date()` — fixed to `getNow()` per PER-4." The fix: same-line allow rule for historical-marker keywords (`legacy`, `previously`, `supersedes`, `MUST NOT`, `SOURCE BUG`, `replaces`). The linter allows the marker; blocks the bare pattern.

## Drill

Artifacts in your fork.

**Drill 1 — Classify your current hooks.** Look at the hooks you've authored in `student/.claude/hooks/`. For each, classify by layer (1 — disaster prevention, 2 — workflow discipline, 3 — behavioral). Save to `student/drills/34-hook-layer/01-hook-layers.txt`.

**Drill 2 — Add a Layer 2 hook with historical-marker awareness.** Author a hook that blocks Edit/Write to `student/canonical-project/` if the new_string contains `parseFloat` UNLESS the same line contains the marker `legacy` or `previously`. The hook reads JSON from stdin; checks new_string; allows-with-marker, blocks-without. Save its path to `student/drills/34-hook-layer/02-new-hook.txt`.

**Drill 3 — Recognize alarm vs declarative-imperative register.** Open the hook from Chapter 21 (`block-todo-commits.sh`). Read its error message. Is it alarm or declarative-imperative? If alarm, rewrite to declarative-imperative (condition + action + invalid responses). Save the before/after to `student/drills/34-hook-layer/03-register.txt`.

## Checkpoint question

> An operator complains the AI in their project "argues with my hooks — every block produces three paragraphs explaining why the hook was wrong." Walk through the diagnosis in 3-4 sentences — name the likely immediate cause in the hook's output register, the AI's pattern-matched response disposition, and the structural fix in the hook itself (what to add, what to remove).

<!-- Rewriter audit trail
Grounded in verified principles: P21 (mechanical enforcement; the three-layer pattern emerges from incident-driven hook authoring), P25 (output register is declarative-neutral-imperative, not alarm; alarm pushes AI to placating disposition), P26 (hooks compose with friction; engineer around it, don't fight it; syntactic bypasses forbidden; hook-edit bypasses forbidden), P27 (canonical-pattern linter with same-line historical-marker allow: legacy / previously / supersedes / MUST NOT / SOURCE BUG / replaces), P34 (state artifacts are hook-written only; model writes to state paths blocked)
Worked example surface: MembershipKit "clean up the failed deployment" — three guard layers compose across four AI attempts
Rewrite date: 2026-05-13
-->
