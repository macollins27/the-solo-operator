# Chapter 40 — The skill iteration protocol

## Learning objective

The student can explain the 9-step skill-iteration protocol used by mature operators when modifying any working skill, apply it to one skill in their own fork, and recognize the "fixes for shits and giggles" failure mode the protocol prevents.

## Prerequisites

- Completed: Chapter 39 — When to write a rule vs. a hook
- Concepts: what-is-a-skill, root-cause-vs-bandaid

## Core concept

Skills are living documents. They evolve. Sometimes a skill breaks; sometimes a new failure mode demands an amendment; sometimes a skill is over-fitted to old assumptions and needs to be re-fit. Every change is necessary.

But every change is also dangerous. A skill that's been working for 30 days has been touched by dozens of sessions; agents and operators have come to rely on its specific behavior. Modifying part of it can regress another part nobody was thinking about.

A mature project hit this hard once. Twenty-five iterations on one skill across six days. Each "fixing the root cause" in good faith; each subtly regressing a previously-working section. Contract artifact grew 5,750 → 6,708 lines. Findings inflated 25 → 750+. Six days lost. Diagnosis: "fixes for shits and giggles" — modifications to parts not broken, made because the agent felt they could be improved.

The integrity principle: **never modify something that is not broken.** Working lines stay untouched. Only diagnosed-defect lines change. Every modified line carries justification; every non-modified line in the touched area carries documented "why it stays."

The 9-step protocol:

**Step 0 — Cap check.** On 3rd+ attempt at the same finding class, STOP. The failure is in your diagnosis, not the skill. Escalate.

**Step 1 — Cite the exact failure verbatim.** Not paraphrased. The exact words / behavior that's wrong.

**Step 1.5 — Rule out non-skill causes.** Contract bug? Input bug? Context-budget bug? Operator-decision bug? Only proceed if the failure is the skill itself. Most-skipped step.

**Step 2 — Cite the exact skill lines.** A **fresh-context observer** — a freshly-dispatched subagent that has not seen the failure — confirms the line attribution independently before you proceed. Self-review is biased by the same reasoning thread; the fresh-context observer is the bias-break.

**Step 3 — Articulate current invariants.** What the skill IS doing right that you don't want to break. Identify the ONE invariant changing; others survive.

**Step 4 — Three test cases.** (a) OLD failing case → should still fail; (b) NEW failing case → should now pass; (c) NEW working case → should remain unchanged. The third is load-bearing.

**Step 5 — Write the diff with line-by-line justification.** Every modified line: WHY changed. Every non-modified line in the touched area: WHY it stays.

**Step 6 — Apply + run all three tests.** Old fails; new passes; working unchanged. If working changes, diagnosis was wrong — REVERT.

**Step 7 — Commit with diff justification.** Conventional-commits prefix; body describes failure, cause, change, three test results. The body is the audit trail.

Two anti-patterns the protocol prevents:

**"While I'm here" cleanup.** During a real bug fix, the agent takes the opportunity to "improve structure," "tighten wording," "refactor for clarity" in unrelated sections. Each modification has nonzero chance of introducing a new defect. The protocol forces naming invariants explicitly so cleanup attempts are visible.

**Load-bearing removal without replacement.** Diagnostic correlates with long-running infrastructure (auto-format ran cleanly 7 weeks across 300,000+ lines; two halts observed in the last day). Prior-art evidence (7 weeks clean) dominates two recent observations. The right move when implicating long-running infrastructure: ADD a backup mechanism FIRST; THEN test by disabling; only after confirmation decide whether to remove permanently — even then, leave the backup.

## Worked example

You notice your `finish-chapter` skill (Chapter 20) sometimes commits even when `verify.sh` emits warnings — it's only checking the exit code, not the output. You want to add stderr inspection.

Following the protocol:

- Step 0: first attempt. Proceed.
- Step 1: exact failure verbatim: "On 2026-05-22 the skill committed Ch 22 even though `verify.sh` stderr said 'WARNING: drill artifact path looks wrong.' Exit 0."
- Step 1.5: non-skill cause check — not a `verify.sh` bug; not an input bug. Confirmed skill bug.
- Step 2: exact skill lines: step 3 of SKILL.md says "run `verify.sh`, read exit code." A fresh-context observer confirms the same attribution.
- Step 3: current invariants: "exit 0 = pass; commit with structured message; report SHA." Changing: also scan stderr. Surviving: structured message + SHA reporting.
- Step 4: three test cases — (a) exit 0 + stderr WARNING → should NOT commit after fix; (b) exit 0 + clean stderr → should commit; (c) exit 1 → should NOT commit (already correct, must remain correct).
- Step 5: step 3 becomes "run `verify.sh`; check exit code AND scan stderr for /WARN|ERROR/i. If either fails, STOP." Inline justification: "Without stderr check, warnings ship as clean commits — Ch22 case 2026-05-22."
- Step 6: apply; run all three. Old fails-to-commit (correct); new commits (correct); failing case still fails (correct).
- Step 7: commit `fix(finish-chapter): also fail on stderr warnings`. Body cites the three test results.

The protocol catches "while I'm here" cleanup at Step 3 (naming what's NOT changing) and working-case regression at Step 6 (third test failure means diagnosis was wrong).

## The rule

> Never modify what isn't broken. Every skill change follows the 9-step protocol: cite failure verbatim, rule out non-skill causes, cite lines (verified by a fresh-context observer), articulate invariants, three explicit test cases, line-by-line diff justification, apply + test, commit with audit-trail body. Slow + correct beats fast + regressing.

## Common mistakes

**Mistake 1 — Skipping Step 1.5.** "Of course it's the skill, I just ran the skill and got the bad output." Confirmation bias. The failure could be the contract input, the operator decision that produced the contract, or a context-budget issue. The non-skill-cause check forces a separation between symptom and source.

**Mistake 2 — Skipping Step 2's fresh-context observer.** Self-review on a skill defect is biased by the same reasoning thread that produced the framing of the failure. The observer is the bias-break: a fresh subagent that hasn't seen the failure, reads only the skill body + the cite, must independently arrive at the same line attribution. If observer disagrees, re-diagnose.

**Mistake 3 — Skipping Step 4.** Three explicit test cases feels heavyweight. ("I'll just try the fix.") Without explicit predictions, regressions hide. The working-case test is the load-bearing one; when it changes when it shouldn't, the diagnosis was wrong.

**Mistake 4 — Not capping at 3 attempts.** Each attempt feels closer to the fix. After three, the issue isn't the skill — it's the model of the problem. Step 0 forces re-diagnosis at the cap.

**Mistake 5 — Load-bearing removal without replacement.** The diagnostic correlates with long-running infrastructure (auto-format / a hook / a gate step). Instinct says remove it. The N-week prior-art evidence dominates the recent observations. ADD a backup mechanism first; THEN test by disabling; even after confirmation, leave the backup. Removing without replacement is what produces the regression you weren't expecting.

## Drill

Artifacts in your fork.

**Drill 1 — Identify a skill to iterate.** Pick one of your skills (`finish-chapter` from Chapter 20 is fine). Find ONE specific thing about it you'd improve. Save the exact-failure description + skill-lines-responsible to `student/drills/40-skill-iteration-protocol/01-target.txt`.

**Drill 2 — Walk the protocol.** For the change you identified, write Step 1.5 (rule out non-skill causes), Step 3 (invariants), Step 4 (three test cases), Step 5 (diff justification). Save to `student/drills/40-skill-iteration-protocol/02-walkthrough.txt`.

**Drill 3 — Apply OR revert with a fresh-context observer.** EITHER apply the change to your skill file AND dispatch a fresh subagent to confirm Step 2's line attribution before you make the edit; run all three test cases. OR explicitly decide NOT to make this change because the working-case risk isn't justified. Save the outcome (including the observer's verdict if you ran one) to `student/drills/40-skill-iteration-protocol/03-outcome.txt`.

## Checkpoint question

> A teammate excitedly tells you they've been iterating on the `/build-source` skill all week — 12 commits, "really sharpening it up." You look at the commit log and see each commit changes ~50 lines across 5 different sections of the skill. Walk through 3-4 sentences naming what's likely going wrong, which specific Steps of the 9-step protocol they're skipping, and what you'd ask them to demonstrate before the next iteration.

<!-- Rewriter audit trail
Grounded in verified principles: P42 (skill iteration 9-step protocol; never modify what isn't broken; 6-day spiral evidence — contract grew 5750→6708 lines, findings inflated 25→750+), P43 (fresh-context observer rules out diagnosis bias before skill modification; Step 2 of the 9-step protocol), P44 (load-bearing infrastructure never removed without replacement; prior-art evidence dominates recent observations; auto-format 7-week clean run vs 2 recent halts example)
Worked example surface: MembershipKit finish-chapter skill iteration adding stderr inspection
Rewrite date: 2026-05-13
-->
