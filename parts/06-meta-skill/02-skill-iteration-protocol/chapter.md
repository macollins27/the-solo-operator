# Chapter 40 — The skill iteration protocol

## Learning objective

The student can explain the 9-step skill-iteration protocol used by mature operators when modifying any working skill, apply it to one skill in their own fork, and recognize the "fixes for shits and giggles" failure mode the protocol prevents.

## Prerequisites

- Completed: Chapter 39 — When to write a rule vs. a hook
- Concepts: what-is-a-skill, root-cause-vs-bandaid

## Core concept

Skills are living documents. They evolve. Sometimes a skill breaks; sometimes a new failure mode demands an amendment; sometimes a skill is over-fitted to old assumptions and needs to be re-fit to new ones. Every change is necessary.

But every change is also dangerous. A skill that's been working for 30 days has been touched by dozens of sessions; agents and operators have come to rely on its specific behavior. Modifying part of it can regress another part that nobody was thinking about.

Maxwell's project hit this failure mode hard at one point: 25 successive iterations on a single skill, each "fixing the root cause" in good faith, each subtly regressing previously-working sections. Contract size grew from 5,750 → 6,708 lines; findings inflated from 25 to 750+. Six days lost. The diagnosis: "fixes for shits and giggles" — modifications to parts of the skill that weren't broken, made because the agent felt they could be improved.

The integrity principle: **never modify something that is not broken.** Working lines stay untouched. Only diagnosed-defect lines change. Every modified line carries documented justification. Every NON-modified line in the touched area carries documented "why it stays."

The 9-step protocol that operationalizes this:

**Step 0 — Cap check.** If you're on your 3rd+ attempt at the same finding class, STOP. Escalate. The failure is no longer in the skill; it's in your diagnosis.

**Step 1 — Cite the exact failure verbatim.** Not paraphrased. The exact words / exact behavior that's wrong. Write it down before touching the skill.

**Step 1.5 — Rule out non-skill causes.** Is the failure actually a contract bug? An input bug? A context-budget bug? An operator-decision bug? Only proceed if the failure is genuinely caused by the skill.

**Step 2 — Cite the exact skill lines responsible.** Point at the specific lines in `SKILL.md`. A fresh-context observer (a fresh subagent) confirms before you proceed.

**Step 3 — Articulate the skill's current invariants.** Write down what the skill IS doing right that you don't want to break. Identify the ONE invariant being changed. The others survive.

**Step 4 — Three test cases.** Write three test cases: (a) the OLD/failing case → should fail; (b) the NEW/failing case → should pass after fix; (c) a NEW/working case → should remain unchanged. Three explicit predictions.

**Step 5 — Write the diff with justification.** Every modified line: a comment explaining WHY changed. Every non-modified line in the touched area: a comment explaining WHY it stays. The justification is the audit trail.

**Step 6 — Apply + run all three tests.** Old case fails. New case passes. Working case unchanged. If the working case CHANGES, REVERT. Diagnosis was wrong. Rediagnose.

**Step 7 — Commit with diff justification in the message.** The commit message names the failure, the cause, the change, the three test results. The history is auditable.

The protocol is slow. That's the point. The cost of slow + correct is much lower than the cost of fast + regressing-previously-working-things.

You won't iterate skills that often. Most weeks, skills don't change. But when they do, the protocol is your safety net.

## Worked example

You notice that your `finish-chapter` skill (from Chapter 20) sometimes commits even when verify.sh emits warnings — it's only checking the exit code, not the output. You want to add stderr inspection.

Following the protocol:

- Step 0 — first attempt at this finding. Proceed.
- Step 1 — exact failure: "On 2025-05-22 the skill committed Ch 22 even though verify.sh stderr said 'WARNING: drill artifact path looks wrong.' Wall-clock 47s, gate green."
- Step 1.5 — is this a skill bug or something else? The skill explicitly only checks exit code. The warning was on stderr. Confirmed skill bug.
- Step 2 — exact skill lines: SKILL.md step 3 says "run verify.sh, read exit code." That's the line. A fresh-context subagent confirms.
- Step 3 — current invariants: "exit 0 = pass; commit happens with structured message; reports SHA." Changing: also check stderr for "WARNING" lines. Surviving: structured message + SHA reporting.
- Step 4 — three test cases:
  - Old/failing: verify.sh exit 0 with stderr WARNING → currently commits. Should now NOT commit.
  - New/passing: verify.sh exit 0 with clean stderr → should commit normally.
  - Working/unchanged: verify.sh exit 1 → should NOT commit (already correct).
- Step 5 — write the diff. Step 3 of SKILL.md becomes: "run verify.sh; check exit code AND scan stderr for /WARN|ERROR/i. If either fail, STOP." Justification: "Without stderr check, warnings ship as clean commits."
- Step 6 — apply. Test all three cases against a real run. Old case now doesn't commit (correct). New case commits (correct). Failing case still doesn't commit (correct).
- Step 7 — commit: `fix(finish-chapter): also fail on stderr warnings (caught Ch22 case 2025-05-22)`. Diff justification inline.

Slow? Yes. Necessary? When the alternative is regressing working behavior on a load-bearing skill, yes. The protocol catches the "fixes for shits and giggles" failure mode at Step 3 (forcing you to name what's NOT changing) and Step 6 (verifying the working-case test).

## The rule

> Never modify what isn't broken. Every skill change follows the 9-step protocol: cite failure, cite lines, articulate invariants, write three test cases, justify modified + non-modified lines, apply + test, commit with audit trail. Slow + correct beats fast + regressing.

## Common mistakes

**Mistake 1 — Skipping Step 3.** Articulating current invariants feels redundant. ("Of course I know what the skill does.") Skipping it means you don't NOTICE the working part you accidentally regress until the next iteration. Always write down what's NOT changing.

**Mistake 2 — Skipping Step 4.** Three test cases feels heavyweight. ("I'll just try the fix.") Without explicit predictions, regressions hide. The working-case test is the load-bearing one; if it changes when it shouldn't, the diagnosis was wrong.

**Mistake 3 — Not capping at 3 attempts.** You keep iterating on the same skill, each attempt feeling closer to the fix. After three attempts, the issue isn't the skill — it's your model of the problem. Step 0 forces a re-diagnosis.

## Drill

Artifacts in your fork.

**Drill 1 — Identify a skill to iterate.** Pick one of your skills (the `finish-chapter` from Chapter 20 is fine). Find ONE specific thing about it you'd improve. Save the exact-failure description + skill-lines-responsible to `student/drills/40-skill-iteration-protocol/01-target.txt`.

**Drill 2 — Walk the protocol.** For the change you identified, write out Steps 3 (invariants), 4 (three test cases), and 5 (diff justification). Save to `student/drills/40-skill-iteration-protocol/02-walkthrough.txt`. You don't have to actually run the test cases today — just author them.

**Drill 3 — Apply OR revert.** Either: apply the change to your skill file, run a real verification of your three test cases. OR: explicitly decide NOT to make this change because the working-case risk isn't justified. Save the outcome to `student/drills/40-skill-iteration-protocol/03-outcome.txt`.

## Checkpoint question

> A teammate excitedly tells you they've been iterating on the `/build-source` skill all week — 12 commits, "really sharpening it up." You look at the commit log and see each commit changes ~50 lines across 5 different sections of the skill. What's likely going wrong, and what would you say to them in 2-3 sentences?
