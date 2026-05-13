# Chapter 10 — The Two-Option Rule

## Learning objective

The student can recognize, in real time, when their AI is silently continuing past an error instead of fixing it or surfacing it, and intervene with the correct redirect. The student can also enforce this rule on themselves.

## Prerequisites

- Completed: Chapter 9 — AI is a Junior Dev
- Concepts: junior-dev-mental-model, operator-as-manager

## Core concept

When you — or your AI — hit a problem during work, exactly two valid responses exist:

**Option 1 — Fix it.** Identify the cause. Fix the underlying issue. Continue.

**Option 2 — Stop and present.** Describe the problem, name what you found, propose a fix, and wait for direction.

Silently continuing past the problem is not a third option. It looks like a third option. It feels like progress. But the problem is still there, unobserved, growing.

This is the single most important discipline in operating an AI agent. If you internalize one rule from this entire course, internalize this one.

Why it matters specifically with AI: junior team members under deadline pressure invent workarounds. AI under no pressure at all also invents workarounds, because it pattern-matches its training data — and the data is full of "I tried X, it didn't work, so I worked around it by Y" prose. Left to its own framing, an agent will happily produce work that looks complete but contains 3 unresolved errors quietly handled by silent fallbacks.

The shape of the failure mode:

- A test fails. Claude reports "Tests are running" and moves on.
- A function returns the wrong type. Claude wraps the call in a try/catch that swallows the error.
- A migration step fails. Claude skips it with a comment "// pre-existing issue, not in scope."
- An assumption Claude made turns out to be wrong. Claude adjusts surrounding code to accommodate the wrong assumption rather than questioning it.
- Permissions denied. Claude reports "I attempted X but couldn't complete it" and continues working on Y as if X didn't matter.

Each of these LOOKS like progress. None of them is. The system after these turns is in a strictly worse state than before — a hidden failure has been written into the foundation, and now you have to find it later when it costs more.

The right shapes, both valid:

**Fix:**
> "The test failed because the function expected an array but got a single object. I changed the function signature to accept both. Test passes now. Here's the diff."

**Stop and present:**
> "The test failed because the function expected an array but the spec says single object. I'm not sure whether the test is wrong or the spec is. Before I change either, here's what I see: [evidence]. Which is correct?"

Both are honest. Both are auditable. Both keep you in the loop.

What's wrong:
> "Tests are running." (silent skip)
> "I wrapped it in a try/catch to handle the error gracefully." (silent swallow)
> "I worked around it by..." (silent workaround)
> "There's a pre-existing issue I noticed but didn't address." (silent deferral)

Whenever you see those shapes from Claude, you intervene. Not later — now. The discipline only works if the rule is enforced every time.

## Worked example

You're working on the dues-payment feature of MembershipKit. You ask Claude to add a function that records a payment.

**Wrong session:**

Claude writes the function. Claude tries to call a helper that doesn't exist (Claude made up the name). Claude notices. Claude writes a new helper called the same thing instead of asking why the helper was missing. The session ends with "Done — the payment is recorded." You look at the diff later and find: Claude added a helper to your code that duplicates work another helper already does, the original missing-helper case is unresolved (probably a typo Claude was supposed to fix), and now you have two implementations of the same thing.

The failure: Claude saw a problem (helper missing), invented a workaround (new helper), and reported success. Silent continuation.

**Right session — Option 1 (Fix):**

Claude writes the function. Claude tries to call a helper called `record_payment`. The actual function is `recordPayment`. Claude notices the typo, fixes the call, runs the test, reports: "There was a typo — I called `record_payment` but the function is `recordPayment`. Fixed the casing. Test passes. Diff below."

**Right session — Option 2 (Stop and present):**

Claude writes the function. Claude tries to call `record_payment`. The function doesn't exist anywhere in the codebase. Claude reports: "I need a function to actually record the payment to the database, but I can't find one in the codebase. Three options: (a) I create `recordPayment()` in `lib/payments.ts` following the pattern of the other functions there; (b) you tell me the function is somewhere I should look; (c) the recording should happen elsewhere in the stack. Which one?"

Both right sessions surface what's happening. The wrong session doesn't.

## The rule

> When you hit a problem, fix it or stop and present. Silent continuation does not exist. If your AI silently continued past something, that's the moment to redirect — not later, not after you discover the consequence.

## Common mistakes

**Mistake 1 — Letting "I worked around it" slide.** The phrase is the smoking gun. Whenever you see "worked around," "for now," "as a stopgap," or "to keep things moving" in Claude's output, the next move is to stop everything and ask: what did you work around, why, and what's the proper fix? Almost every "I worked around X" is a hidden bug under construction.

**Mistake 2 — Accepting "Tests pass" without seeing the output.** "Tests pass" is a claim, not evidence. Look at the Bash tool call. Look at the actual test output. Is the number of tests run what you expected? Did any tests get skipped? Are there warnings? "Tests pass" while skipping 12 tests is not the same as "tests pass" while running all of them.

**Mistake 3 — Treating "pre-existing issue" as harmless.** Claude finds a problem unrelated to what you asked about. Claude says "there's a pre-existing issue but I didn't touch it." This is often correct discipline — don't expand scope. But surfacing it is mandatory. Saying nothing about the pre-existing issue and continuing is the failure mode. The right move is: name the issue, log it, and decide together whether to address now or later.

## Drill

You'll create a situation where Claude can either fix, surface, or silently continue. Artifacts go in `student/drills/10-two-option-rule/`.

**Drill 1 — Plant a bug Claude doesn't know about.** Open your `student/canonical-project/` in your terminal (not Claude Code yet). In any file (the easiest is `app/page.tsx` or whichever exists from your scaffold), introduce a deliberate small bug — change a function name, a missing comma, an undefined variable reference. Make it something the dev server would complain about. Write down what you changed in `student/drills/10-two-option-rule/01-planted-bug.txt`: file path, what you changed, what you expect to break.

**Drill 2 — Ask Claude to make an UNRELATED change.** Now open Claude Code. Ask Claude to add a brand-new file somewhere far from your bug (e.g., "create a new file `student/canonical-project/lib/utils.ts` with a function `capitalize(s)` that returns the string with first letter uppercased"). Watch what Claude does. Specifically: does Claude run `pnpm dev` or `pnpm build` or anything that would surface the planted bug? If yes, does Claude surface it, fix it, or skip past it? Save your observation to `student/drills/10-two-option-rule/02-what-claude-did.txt`.

**Drill 3 — Replay with the rule.** Revert all changes from Drill 1 and Drill 2 (`git restore .`). Replant the same bug. Open Claude Code. This time, in your first message, tell Claude: "Follow the Two-Option Rule. If you encounter ANY problem — including something unrelated to my request — either fix it and tell me, or stop and present it. Silent continuation is not allowed." Then ask the same unrelated change. Observe and save what's different to `student/drills/10-two-option-rule/03-with-the-rule.txt`.

## Checkpoint question

> Claude reports: "I added the function you asked for. There were some warnings during the build but they were pre-existing and not related to my change, so I continued. The function is working." You did not give Claude permission to "continue past warnings." Walk through what should happen next, in order: what do you say to Claude, what do you check, and what's the right outcome of this turn?
