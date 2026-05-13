# Chapter 39 — When to write a rule vs. a hook

## Learning objective

The student can decide, given a recurring failure mode, whether to encode the response as a CLAUDE.md rule, a hook, an ast-grep rule, or a SKILL.md amendment — and predict the maintenance cost of each over a 6-month horizon.

## Prerequisites

- Completed: Chapter 38 — Hero level: the trust-calibration arc
- Concepts: what-is-claudemd, what-is-a-hook, corpus-as-moat

## Core concept

Part 6 is the meta-skill: building YOUR system over time. The most common decision you'll face: a failure mode happened. Where do you encode the fix?

Four candidates:

**1. A CLAUDE.md rule** — a one-line declarative rule Claude reads at session start. Strength: cheap, fast to author, flexible. Weakness: Claude can drift past it (anti-pattern #15 if you keep having to re-state).

**2. A hook** — a script that runs deterministically on a Claude Code event. Strength: cannot be argued with. Weakness: requires more thought to author, can fire on false positives, slower to maintain.

**3. An ast-grep rule** — a pattern that matches against code structure and surfaces violations to Claude (or fails the gate). Strength: enforces at the syntactic level; can be very specific. Weakness: only works for source code patterns; doesn't catch behavioral failures.

**4. A SKILL.md amendment** — an update to an existing skill's protocol. Strength: encoded inside the workflow itself, applies every invocation. Weakness: only fires when the skill is invoked; doesn't catch out-of-skill behaviors.

The decision matrix:

| Failure type | Best home |
|---|---|
| Behavioral / phrasing (Claude says "I think...") | Anti-pattern classifier (Stop hook) |
| Specific command never to run (`git push --force`) | Pre-bash hook |
| Specific code pattern never to commit (`as any`) | ast-grep rule + post-edit hook |
| Pipeline step often skipped (skipping `pnpm gate`) | SKILL.md amendment + hook backup |
| Project-wide convention ("Drizzle not Prisma") | CLAUDE.md rule |
| Recurring decision pattern ("money is integer cents") | CLAUDE.md rule + ast-grep rule |
| Process discipline ("review before commit") | Hook (pre-commit) + skill amendment |

The hierarchy of enforcement: behavioral classifier > deterministic hook > ast-grep rule > SKILL.md > CLAUDE.md > feedback file.

Beginners author at the BOTTOM of the hierarchy (feedback files only). Operators promote rules UP the hierarchy as they recur. The bite frequency tells you where the rule should live:

- Bit you once → feedback file.
- Bit you twice (slightly different surface) → CLAUDE.md rule + the second feedback file.
- Bit you three times → ast-grep rule or SKILL.md amendment. The pattern is now common enough that mechanical detection is worth the authoring cost.
- Bit you four times → hook. The pattern is recurring enough that human supervision isn't working; deterministic blocking is necessary.
- Bit you five times AND it's a language-level failure → add to the anti-pattern classifier's catalog. The classifier picks it up automatically going forward.

Each promotion has a maintenance cost. Feedback files require almost zero maintenance. Hooks have to be debugged when they false-positive. ast-grep rules have to be updated when your code patterns evolve. Don't pre-promote — wait for the bite frequency to justify the cost.

Trade-offs to weigh:

**Speed of authoring.** Feedback file: 60 seconds. CLAUDE.md rule: 60 seconds. ast-grep rule: 10-30 minutes. Hook: 20-60 minutes. SKILL.md amendment: 5-20 minutes.

**Speed of enforcement.** Hook: instant (mechanical). ast-grep: fast (runs on Edit/Write). SKILL.md: applies on invocation. CLAUDE.md: applies if Claude reads it (sometimes Claude drifts). Feedback file: only if you reference it.

**False-positive cost.** Hook false-positives feel like the system fighting you. CLAUDE.md false-positives feel like Claude being too cautious. Feedback files don't fire automatically so no false positives. Higher-promotion = higher false-positive surface.

**Maintenance burden.** Hooks need debugging when matchers misfire. ast-grep rules need updating when refactoring. CLAUDE.md rules need consolidation (Chapter 42). Feedback files are forever.

## Worked example

Three different bites; three different responses.

**Bite 1.** Claude wrote "I think the tests should pass." You're annoyed but it's once. Action: feedback file. `feedback_no_thinking_hedging.md` — describes the incident, rule "When verifying tests, run the test, don't think about it." Done in 60 seconds.

**Bite 2.** Two weeks later, same family of bite. Claude wrote "This should be straightforward." Same underlying failure (hedge without verify). Now it's twice. Action: promote. Add to CLAUDE.md: "Never say 'should' or 'I think' about verifiable facts. Run the verification first." Reference the two feedback files in CLAUDE.md. Done in another 60 seconds.

**Bite 3.** A week later, hedge appears in a session as the final assistant message: "Tests should be fine." Now it's gotten through three sessions. CLAUDE.md isn't catching it because the failure is sneaking past Claude's self-policing. Time to promote to the anti-pattern classifier catalog. Add "Category N — verifier-substitution hedging" with recognition phrases ("should be," "I think," "ought to"). The classifier will catch this pattern automatically going forward. Done in 5 minutes.

The cost ramp matches the bite frequency. Three small efforts beat one mega-effort upfront when you didn't know the failure mode existed.

## The rule

> Promote rules up the hierarchy at the bite frequency that justifies the maintenance cost. Once = feedback file. Twice = CLAUDE.md. Three+ = hook / ast-grep / SKILL.md / classifier. Don't pre-promote; don't fail to promote when the bite recurs.

## Common mistakes

**Mistake 1 — Pre-promoting.** A theoretical failure mode you've read about somewhere becomes a hook. The hook never fires. You forget you wrote it. Three months later it false-positives on something legitimate and you waste an hour debugging. Wait for the bite; the bite tells you the pattern is real.

**Mistake 2 — Never promoting.** You write 40 feedback files. CLAUDE.md is still 30 lines. The same patterns keep biting you in slightly different forms because Claude never sees the consolidated rule. Promotion is the moat; without it, the corpus is just a journal.

**Mistake 3 — Wrong layer.** A behavioral failure (Claude hedging) gets encoded as an ast-grep rule (which doesn't match natural language). The rule never fires. The failure keeps happening. Match the layer to the failure type per the table.

## Drill

Artifacts in your fork.

**Drill 1 — Audit your bites.** Read your `student/feedback/INDEX.md`. For each feedback file, predict where it should live LONG-term: feedback file (this is the first instance), CLAUDE.md rule (recurring), hook (need mechanical), ast-grep (need source-level), classifier (behavioral). Save to `student/drills/39-rule-vs-hook/01-bite-audit.txt`.

**Drill 2 — Promote one.** Pick one feedback file that's recurred or that you predict will. Promote it to its next layer up. (For most students this is moving a feedback rule into CLAUDE.md.) Save the before/after to `student/drills/39-rule-vs-hook/02-promotion.txt`.

**Drill 3 — Predict a future bite.** Look at your code or your operating pattern. Predict ONE failure mode you'll probably hit in the next month. Decide where to encode it WHEN it happens (don't write the rule yet — just decide the layer). Save your prediction + chosen layer + rationale to `student/drills/39-rule-vs-hook/03-prediction.txt`.

## Checkpoint question

> A friend asks: "I have 60 feedback files but the same bugs keep biting me. What am I doing wrong?" Walk through the diagnosis in 2-3 sentences, naming the specific discipline they're missing and the specific next step.
