# Chapter 10 — The Two-Option Rule

## Learning objective

The student can recognize, in real time, when their AI is silently continuing past an error instead of fixing it or surfacing it, and intervene with the correct redirect. The student can also enforce this rule on themselves.

## Prerequisites

- Completed: Chapter 9 — AI is a Junior Dev
- Concepts: junior-dev-mental-model, operator-as-manager

## Core concept

When work hits any problem — an error, an unexpected output, a defect surfaced mid-task — exactly two responses are valid:

**Option 1 — Fix it.** Trace the cause. Fix the underlying mechanism. Continue.

**Option 2 — Stop and present.** Name what you found, name the cause, name your proposed fix, and wait for direction.

Silent continuation is not a third option. The problem persists, hidden, and the next agent discovers it at higher cost. This rule constrains both Claude's behavior AND your own: Claude must not silently continue past errors; you must not let "this looks fine" wave through unverified work.

The recognition phrases of silent continuation are precise. Whenever you see one of these, the rule has been broken:

- **"Pre-existing."** "There's a pre-existing issue but I didn't touch it." A defect surfaced mid-task is in scope regardless of original authorship. The dismissal IS the failure mode.
- **"Defer to later."** "Logged for later," "flag for future," "address this later," "ticking time bomb but..." Every deferred finding is a known defect carried forward.
- **"Out of scope for this pass."** Sometimes legitimate (the discovery is truly in a different domain) — but only if it's been **surfaced with severity in writing**, not silently dropped.
- **"Doesn't block X."** Status-shaped framing that hides the defer. A migration that "doesn't block dev startup" is still a migration failure; the right move was to run the missing setup step.
- **"Worked around it."** A workaround that doesn't trace to a root cause is a bandaid in disciplined clothing.

Three legitimate responses to mid-task discovery, no fourth:

(a) **Stop, report, ask** — when the discovery may invalidate the assigned work.
(b) **Continue but surface** — document with severity and add to required actions; return to assigned task.
(c) **Fix inline** — when the discovery is small and capable to fix without scope creep.

Writing off the problem in prose — option (d) — does not exist. When you see Claude reach for it, the intervention is one sentence: "That's a deferral. Either fix it now, or surface it with severity. No write-off."

Why this matters with AI: the training data is full of "I tried X, it didn't work, so I worked around it" prose. Left to its own framing, an AI will produce work that looks complete and contains three unresolved errors quietly handled by silent fallbacks.

## Worked example

You ask Claude to add a function that records a member dues payment in MembershipKit.

**Wrong session — disciplined-sounding deferral.**

Claude writes the function and notices a helper-name collision: `record_payment` (snake_case, stale) exists in one file; a Stripe-only `recordPayment` exists in another. Claude reports: "I noticed there's an inconsistent helper name (`record_payment` vs `recordPayment`), but that's pre-existing and out of scope. I added a new `recordPayment` that follows the modern convention. Tests pass."

This sounds responsible. The recognition phrases are "pre-existing" + "out of scope" — both silent-continuation phrases dressed as discipline. The intervention from you: "That's a deferral. Either fix the naming inconsistency now, or surface it as a tracked finding with severity. Don't write it off."

**Right session — Option 1 (fix).**

Claude reports: "Name collision between `record_payment` and the Stripe helper. Root cause: someone added the Stripe one without renaming the old. Fixing the collision: deleting `record_payment`, renaming all call sites to the Stripe helper, adding my new code on top. Test passes. Diff below."

**Right session — Option 2 (stop and present).**

Claude reports: "Name collision between `record_payment` and the Stripe helper. Removing the snake_case version may affect three call sites in `app/admin/`. I want approval before deleting — the snake_case name might be referenced from a database migration I haven't traced. Proposed fix: delete the stale helper, migrate the call sites. Risk: migration may reference the old name. OK to proceed, or verify migration history first?"

Both right sessions surface what's happening. Neither writes the problem off.

## The rule

> Two responses to any problem: fix it, or stop and present it. Silent continuation does not exist. Recognition phrases: "pre-existing," "out of scope for this pass," "logged for later," "doesn't block X," "worked around it." Intervene the moment you hear them.

## Common mistakes

**Mistake 1 — Accepting "pre-existing" as a closing argument.** Highest-frequency dismissal phrase in the wild. It sounds disciplined but is almost always deferral. The repair: a pre-existing finding must be surfaced with severity, classified as caused-by-this-session (fix now) or pre-existing with cited evidence (track for next pass). The discipline is the classification, not the silence.

**Mistake 2 — Letting "doesn't block X" stand as a status report.** "Not-blocking" is a status assertion, not a fix. When the AI says "this didn't block me," find the cause anyway — usually a missing setup step or a regression three commits old. The next agent who hits the actual block pays full cost for the deferred investigation.

**Mistake 3 — Letting workarounds compound.** "Extending the timeout to give it more headroom." "Bumping the retry count to handle the flake." "Added a try/catch to swallow the noise." Each workaround makes the immediate problem disappear and adds dead-code archaeology for the next agent. Push back: "Find the cause of X. Don't paper over."

**Mistake 4 — Accepting "all pre-existing" as test-failure classification.** A subagent reports "24 failures, all pre-existing." That's not a classification — it's a wave-off. The right move: bisect against prior commit, classify each as caused-by-this-session (fix) or pre-existing with cited evidence (document).

**Mistake 5 — Allowing dismiss-language into written artifacts.** Specs and plan files occasionally pick up phrases like "noted for tracking," "predates this," "I didn't touch this." Once dismiss-language enters a written artifact, it becomes load-bearing for the next agent. Block it. Fix or surface; never write off in prose.

## Drill

You'll create a situation where Claude can either fix, surface, or silently continue. Artifacts go in `student/drills/10-two-option-rule/`.

**Drill 1 — Plant a bug Claude doesn't know about.** Open your `student/canonical-project/` in your terminal (not Claude Code yet). In any file (the easiest is `app/page.tsx` or whichever exists from your scaffold), introduce a deliberate small bug — change a function name, a missing comma, an undefined variable reference. Make it something the dev server would complain about. Write down what you changed in `student/drills/10-two-option-rule/01-planted-bug.txt`: file path, what you changed, what you expect to break.

**Drill 2 — Ask Claude to make an UNRELATED change.** Now open Claude Code. Ask Claude to add a brand-new file somewhere far from your bug (e.g., "create a new file `student/canonical-project/lib/utils.ts` with a function `capitalize(s)` that returns the string with first letter uppercased"). Watch what Claude does. Specifically: does Claude run `pnpm dev` or `pnpm build` or anything that would surface the planted bug? If yes, does Claude surface it, fix it, or skip past it? Save your observation to `student/drills/10-two-option-rule/02-what-claude-did.txt`.

**Drill 3 — Replay with the rule.** Revert all changes from Drill 1 and Drill 2 (`git restore .`). Replant the same bug. Open Claude Code. This time, in your first message, tell Claude: "Follow the Two-Option Rule. If you encounter ANY problem — including something unrelated to my request — either fix it and tell me, or stop and present it. Silent continuation is not allowed." Then ask the same unrelated change. Observe and save what's different to `student/drills/10-two-option-rule/03-with-the-rule.txt`.

## Checkpoint question

> A subagent you dispatched returns this report: "Layer 1 complete. Encountered 24 test failures in the financials domain that are pre-existing and unrelated to my changes. Domain X scope unchanged; ready for next layer." You haven't seen the test output yet. Walk through what's wrong with this report, what you'd ask the subagent to do before you accept the layer as complete, and the recognition phrase that gave it away.

<!-- Rewriter audit trail
Grounded in verified principles: P13 (zero deferral; every finding fixed or surfaced), P14 (dismiss language must be blocked at write time), P15 (mid-task discovery is signal, not noise), P16 (test-failure dismissal must be re-classified, never accepted)
Worked example surface: MembershipKit dues payment helper collision
Rewrite date: 2026-05-13
-->
