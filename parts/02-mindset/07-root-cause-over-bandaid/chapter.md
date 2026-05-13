# Chapter 15 — Root Cause > Bandaid

## Learning objective

The student can recognize when Claude is layering defensive code around a symptom instead of finding the cause, and redirect Claude to investigate the underlying mechanism before fixing.

## Prerequisites

- Completed: Chapter 14 — Persistence > Cleverness
- Concepts: two-option-rule, claim-vs-evidence

## Core concept

When wrong output appears, two responses are possible:

1. **Trace it to the cause and fix it there.** Usually a few lines. The mechanism stops being broken.
2. **Layer defenses around the symptom.** Try/catches, fallback values, defensive guards, type coercions. The output stops being visible; the mechanism is unchanged.

The second pattern is the bandaid — the failure mode the AI reaches for by default. Every layer "can't break anything"; every wrap "handles edge cases." They stack.

The discipline is the **Feynman question**: keep asking "why?" until the answer names the source-of-the-source. A test fails. Why? The function returns null. Why? The upstream fetch errors. Why? The API returns 500. Why? The dev database isn't initialized. Fix at the source: add the connection init. Not at the symptom: not a `?.` chain papering over the null.

Specific bandaid shapes that recur:

**Dispatch-correction bandaid.** A skill produces wrong output. The AI's instinct is to add "correction notes" to downstream dispatch prompts — patching consumers. Wrong. The broken skill produces wrong output for every future domain. Fix the skill.

**Timeout-bump bandaid.** A subagent hits a wall-clock cap. The AI's instinct is to bump the cap. Measure first. If wall-clock is hitting the cap from legitimate growth, raise. If from new infrastructure thrash, raising hides the regression.

**Test-noise bandaid.** A test emits stderr from a side-effect path. The AI's instinct is to extend the mock until stderr is silent. The stderr is the price for not over-mocking; silencing it removes future visibility.

**Gate-retry bandaid.** Gate fails. Agent re-runs hoping it passes. A gate that retries without a code change is a flake. "Investigating provenance" via `git blame` after a gate failure is the same pattern in deferral clothing — looking for someone else to blame.

**When stuck, dispatch diagnosis BEFORE further fix attempts.** When two fix attempts haven't converged, the third won't either — "diagnose from failure context" carries the same framing bias that produced the first two. Dispatch a read-only research subagent with full context. The subagent produces a written diagnosis. THEN apply fixes against the diagnosis, not guesses.

**Three categories of CI failure you must distinguish before fixing.** A budget-style check fails (bundle size, secret scanner, threshold). The AI's reflex is "the code is wrong." Categories:

- **Stale config.** Budget sized N commits ago; legitimate growth occurred. Fix: raise.
- **Real regression.** Code crossed a real line. Fix: revert or refactor.
- **False positive.** Test fixture, AWS doc example. Fix: allowlist.

Output an explicit category before any code change. Conflating produces the wrong fix every time.

## Worked example

CI on your MembershipKit fork fails on the bundle-budget check. The build output says the client bundle exceeds the configured threshold by 14 kB.

**Bandaid session — fix-without-diagnosis.**

You: "Fix the bundle-budget failure."

Claude's first move: raise the threshold from 250 kB to 280 kB. Threshold passes. Claude reports: "Bundle budget adjusted." You merge. Two weeks later production load times have grown noticeably — the budget you "fixed" was actually a real regression. You shipped 30 kB of accidental dependency import.

**Bandaid session — second-fix-without-diagnosis.**

Different attempt at the same problem. Claude's first move: drop a dependency that's used in three places. Threshold passes. Two weeks later three features that depended on the dropped library are broken. The fix was guessing-shaped; the cause was never diagnosed.

**Root-cause session — dispatch diagnosis BEFORE fix attempts.**

You: "Bundle budget failed. Don't fix yet. Dispatch a read-only diagnosis subagent first with full context — the budget history, recent commits, and the build output."

The diagnosis subagent returns: "The threshold was set 6 weeks ago at 250 kB. 569 commits since then. Bundle has grown 22 kB in legitimate features (member-import flow, Stripe webhook handlers, event-checkin client logic). Of the 14 kB over budget, 12 kB is legitimate growth and 2 kB is a tree-shaking miss in `@membershipkit/icons` that pulls the full icon set instead of named imports. **Diagnosis: STALE CONFIG with legitimate growth + one fixable tree-shake.** Recommended fix: raise threshold to 275 kB and switch the icon import to named imports to recover the 2 kB."

Two distinct fixes, each addressing a real cause. You approve both. Bundle passes. No new latent bugs introduced.

The three categories at work here: **stale config** (the 12 kB of legitimate growth) and a **real regression** (the 2 kB tree-shake miss). Without diagnosis, both would have been treated as either-or — and either choice alone would have shipped a defect.

## The rule

> Find the mechanism. Trace every wrong output backward to the source. If a class of error has repeated, dispatch diagnosis BEFORE further fix attempts — the same framing bias that produced fix attempts one and two will produce attempt three. For CI failures: distinguish stale config from real regression from false positive before any code change.

## Common mistakes

**Mistake 1 — Patching the consumer instead of fixing the source.** A skill produces wrong output. The AI adds "correction notes" to downstream dispatches. The skill keeps producing the same wrong output for every future call. Fix the skill.

**Mistake 2 — Bumping a limit without measuring.** Subagent hits a wall-clock cap. The AI raises the cap. Measure first. Recognition phrase: "Extending the timeout to give it more headroom."

**Mistake 3 — Silencing test stderr noise.** A test emits stderr from a side-effect path. The AI extends the mock until stderr is silent. The stderr was the signal; silencing it removes future visibility.

**Mistake 4 — Re-running gate after failure without changing code.** A gate that passes "on retry" is a flake, not a fix. Recognition phrase: "Investigating whether the failure is 'pre-existing' or 'not your fault.'"

**Mistake 5 — Accepting `as any` and `!` as fixes.** A type assertion tells the type-checker "trust me." Without a specific reason to trust yourself, the assertion is a bandaid. Flag every assertion; require justification or removal.

## Drill

Artifacts go in `student/drills/15-root-cause-over-bandaid/`.

**Drill 1 — Introduce an error with a clear cause.** In `student/canonical-project/app/page.tsx`, deliberately reference an undefined variable: change something simple like `<h1>Welcome</h1>` to `<h1>{undefinedVariable}</h1>` and save. Run the dev server — confirm it errors. Save the exact error message to `student/drills/15-root-cause-over-bandaid/01-error.txt`.

**Drill 2 — Ask Claude to fix it without guidance.** Open Claude Code. Just say: "Fix the error on the home page." Watch what Claude does. Does Claude find the cause (you typed an undefined variable) and remove it, or does Claude add defensive code around it (`{typeof undefinedVariable !== 'undefined' ? undefinedVariable : 'Welcome'}`)? Save the diff Claude produced — or a description — to `student/drills/15-root-cause-over-bandaid/02-without-guidance.txt`.

**Drill 3 — Revert and ask again with the rule.** `git restore .` everything. Reintroduce the same bug. Open Claude Code. This time: "Fix the error on the home page. Find the mechanism — what specifically is wrong — before you make the fix. Don't add defensive checks." Compare Claude's approach to Drill 2. Save your observation to `student/drills/15-root-cause-over-bandaid/03-with-rule.txt`.

## Checkpoint question

> CI on your fork fails twice in a row with different errors — first a flaky integration test, then a secret-scanner alert on an AWS doc example used as a test fixture. Claude proposes Fix 1 (rerun the gate; the test usually passes) and Fix 2 (allowlist the AWS string). The first proposal feels off; the second sounds reasonable. Walk through: which is a bandaid and which is a legitimate fix, why, and what the right move is for the bandaid case.

<!-- Rewriter audit trail
Grounded in verified principles: P17 (root cause, not symptom; Feynman framing; workarounds compound), P18 (gate-retry-without-code-change is a flake; agents must not pretend otherwise), P19 (diagnosis subagent BEFORE fix attempts when error class repeats), P20 (stale config vs real regression vs false positive — three distinct CI failures)
Worked example surface: MembershipKit bundle-budget CI failure
Rewrite date: 2026-05-13
-->
