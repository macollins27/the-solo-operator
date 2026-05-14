# Chapter 39 — When to write a rule vs. a hook

## Learning objective

The student can decide, given a recurring failure mode, whether to encode the response as a CLAUDE.md rule, a hook, an ast-grep rule, or a SKILL.md amendment — and predict the maintenance cost of each across the lifetime of the project.

## Prerequisites

- Completed: Chapter 38 — Hero level: the trust-calibration arc
- Concepts: what-is-claudemd, what-is-a-hook, corpus-as-moat

## Core concept

Part 6 is the meta-skill: building YOUR system over time. The most common decision: a failure mode happened. Where do you encode the fix?

Four candidates form a hierarchy of enforcement strength:

**1. CLAUDE.md rule** — one-line declarative the AI reads at session start. Strength: cheap, fast to author, flexible. Weakness: prose has a ~70-80% compliance ceiling; the AI can drift past it.

**2. SKILL.md amendment** — an update to an existing skill's protocol. Strength: loaded as user message at invocation, raising compliance to ~100% within the skill. Weakness: only fires when the skill is invoked; doesn't catch out-of-skill behaviors.

**3. ast-grep rule** — a pattern matching against code structure that surfaces violations (to the AI, or as a gate failure). Strength: enforces at the syntactic level; very specific. Weakness: only works for source code patterns; doesn't catch behavioral / language-level failures.

**4. Hook** — a script that runs deterministically on a Claude Code event. Strength: cannot be rationalized around; fires at the tool boundary. Weakness: more thought to author; can fire on false positives; slower to maintain.

The decision rule is empirical, not theoretical. Mechanical promotion is justified at the bite frequency that justifies the maintenance cost:

| Bite count | Action | Cost |
|---|---|---|
| 1 | Feedback file | trivial; passive document |
| 2 (different surface, same family) | Promote to CLAUDE.md | trivial; entry in standing rules |
| 3+ (recurring despite CLAUDE.md) | Promote to mechanical layer | ast-grep, hook, or SKILL.md amendment |
| 4+ (recurring despite mechanical layer) | Re-author the mechanical layer | The first hook was wrong; diagnose again |
| 5+ language-level pattern | Add to anti-pattern classifier catalog | Catalog entry picks up the family automatically |

The decision-matrix per failure type:

| Failure type | Best home |
|---|---|
| Behavioral / phrasing (AI hedges with "I think...") | Anti-pattern classifier (Stop hook) |
| Specific command never to run (`git push --force`) | Pre-bash hook |
| Specific code pattern never to commit (`as any`) | ast-grep rule + post-edit hook |
| Pipeline step often skipped (skipping `pnpm gate`) | SKILL.md amendment + hook backup |
| Project-wide convention ("Drizzle, not Prisma") | CLAUDE.md rule |
| Recurring decision pattern ("money is integer cents") | CLAUDE.md rule + ast-grep rule |
| Process discipline ("review before commit") | Hook (pre-commit) + skill amendment |
| Defect cluster across ≥3 files (same anti-pattern in multiple routers) | ast-grep rule generalizes automatically |

That last row is load-bearing. When a defect class shows up in three or more independent places, a reviewer's catch-rate doesn't generalize — every new file with the same defect requires another individual review pass. An ast-grep rule generalizes automatically. Lint rules scale; reviewer attention does not. Empirically, roughly fourteen percent of QA findings on a mature project are mechanically enforceable; those need rules, not more reviews.

Trade-offs to weigh per layer:

**Speed of authoring.** Feedback file and CLAUDE.md rule are both trivial — a few sentences typed in line. SKILL.md amendments are a small effort: a focused edit within an existing protocol. ast-grep rules are medium: pattern crafted, tested against the codebase. Hooks are the largest: script authored, wired into `settings.json`, observed firing on a real event before trusted. Roughly: hooks cost an order of magnitude more authoring attention than rules; SKILL amendments sit in the middle.

**Speed of enforcement.** Hook: instant (mechanical). ast-grep + post-edit hook: fast (on every Edit/Write). SKILL.md: applies on skill invocation. CLAUDE.md: applies if the AI reads and follows it (sometimes drifts). Feedback file: only if you reference it.

**False-positive cost.** Hook false positives feel like the system fighting you. CLAUDE.md false positives feel like the AI being over-cautious. Feedback files don't fire automatically — no false positives. Higher promotion = higher false-positive surface.

**Maintenance burden.** Hooks need debugging when matchers misfire. ast-grep rules need updating when refactoring. CLAUDE.md rules need periodic consolidation (Chapter 42). Feedback files are write-once.

## Worked example

Three bites, three responses.

**Bite 1.** AI wrote "I think the tests should pass." Annoying, but once. Action: feedback file. `feedback_no_thinking_hedging.md` — describes the incident, rule "When verifying tests, run the test; don't think about it." Done in 60 seconds.

**Bite 2.** Same family of bite weeks later. AI wrote "This should be straightforward." Now it's twice. Action: promote. Add to CLAUDE.md: "Never say 'should' / 'I think' about verifiable facts. Run the verification first." Reference both feedback files in CLAUDE.md.

**Bite 3.** A week later, hedging appears in a session as the final assistant message: "Tests should be fine." Three sessions now; CLAUDE.md isn't holding. Time to promote to the anti-pattern classifier catalog. Add "Category 21 — Verifier-substitution hedging" with recognition phrases ("should be," "I think," "ought to," "I expect"). The classifier catches it going forward.

**Bite 4 (hypothetical).** Two more weeks later, hedging slips past even the classifier on a phrasing variant. The classifier's recognition list is incomplete. Re-author the classifier prompt — not the classifier code. Add the new variant to the recognition list. The cost of the new variant is one catalog edit; the classifier picks up the change at the next fire.

The cost ramp matches the bite frequency. Three small efforts beat one mega-effort upfront when you didn't know the failure mode existed. And each layer has an out — if a layer fails, the next layer up takes over without a full rewrite below.

## The rule

> Promote rules up the hierarchy at the bite frequency that justifies the maintenance cost. Once = feedback file. Twice = CLAUDE.md. Three+ = mechanical (hook, ast-grep, SKILL.md amendment, classifier catalog). When a defect class appears in three or more files, the rule MUST generalize automatically — reviewer attention does not.

## Common mistakes

**Mistake 1 — Pre-promoting.** A theoretical failure mode becomes a hook before any bite has happened. The hook never fires. Later, it false-positives on something legitimate, costing a debugging session. Wait for the bite; the bite tells you the pattern is real.

**Mistake 2 — Never promoting.** You author 40 feedback files; CLAUDE.md is still 30 lines. The same patterns bite you in slightly different forms because the AI never sees a consolidated rule. Promotion is the moat; without it, the corpus is just a journal.

**Mistake 3 — Wrong layer.** A behavioral failure (the AI hedges) gets encoded as an ast-grep rule (which doesn't match natural language). The rule never fires. The failure keeps happening. Match the layer to the failure type per the decision matrix.

**Mistake 4 — Reviewer-only discipline on a defect cluster across three+ files.** Each new file with the same defect requires another individual review pass — and review attention doesn't scale linearly with the codebase. The fix is mechanical: write the ast-grep rule once; it covers every file forever. Reviewer time gets spent on findings only mechanical rules can't catch.

## Drill

Artifacts in your fork.

**Drill 1 — Audit your bites.** Read your `student/feedback/INDEX.md`. For each feedback file, predict where it should live LONG-term: feedback file (first instance), CLAUDE.md (recurring), SKILL.md amendment, ast-grep rule, hook, classifier catalog. Save to `student/drills/39-rule-vs-hook/01-bite-audit.txt`.

**Drill 2 — Promote one.** Pick one feedback file that's recurred or that you predict will. Promote it to its next layer. For most students this is moving a rule from feedback file into CLAUDE.md. Save the before/after to `student/drills/39-rule-vs-hook/02-promotion.txt`.

**Drill 3 — Predict a defect-cluster.** Look at your code or operating pattern. Predict ONE class of defect that could show up in 3+ files (e.g., "I'll forget to scope organizationId in three different routers"). Decide which mechanical layer would catch it BEFORE the third instance ships. Save your prediction + chosen layer + reasoning to `student/drills/39-rule-vs-hook/03-prediction.txt`.

## Checkpoint question

> A friend asks: "I have 60 feedback files but the same bugs keep biting me. What am I doing wrong?" Walk through the diagnosis in 3-4 sentences, naming the specific discipline they're missing, the defect-cluster threshold question they should ask, and the specific next step — including which two layers they likely have under-utilized.

<!-- Rewriter audit trail
Grounded in verified principles: P21 (mechanical enforcement promotion ladder: prose → CLAUDE.md → hook; promotion at recurrence frequency), P23 (repeating defect cluster across N independent files surfaces a missing rule; reviewer attention does not generalize, lint rules do; ~14% of QA findings are mechanically enforceable), P29 (skills > agent frontmatter; SKILL.md amendments load at invocation time)
Worked example surface: MembershipKit hedging-pattern bite escalation across four bite-counts → feedback file → CLAUDE.md → classifier catalog
Rewrite date: 2026-05-13
-->
