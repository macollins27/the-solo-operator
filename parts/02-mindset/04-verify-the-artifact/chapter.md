# Chapter 12 — Verify the Artifact, Not the Summary

## Learning objective

The student can distinguish between Claude's text claims and the underlying evidence (tool calls, file diffs, command output, screenshots), and refuse to mark work complete based on claims alone.

## Prerequisites

- Completed: Chapter 11 — Spec is Truth, Output is Defendant
- Concepts: tool-call-vs-text-summary-truth-hierarchy, two-option-rule

## Core concept

Claude's text reply is a **claim**. The tool calls, file diffs, command output, and screenshots are **evidence**. These are not the same thing. Operators trust evidence; beginners trust claims.

The failure shape is small and devastating. Claude reports "I added the function and tests pass." You read it, you say "great," you move on. Two days later you find: the function got added but tests never ran (the Bash call had a typo and silently failed); the function was added but to the wrong file; the function was added but it doesn't actually solve the problem you described. The claim was confident. The evidence would have told you otherwise — in five seconds — if you'd looked.

There are FOUR kinds of evidence you should reach for:

**File diffs.** `git diff` shows exactly what changed. Run it after any session where Claude modified files. Not "Claude says it edited three files" — *which three, what lines, were the changes what you asked for*. Diffs are deterministic; claims are not.

**Tool-call output.** When Claude ran `pnpm test`, the Bash tool call shows the command AND the output. Read the output. "Tests pass" is different from "Tests pass, 14 skipped, 3 warnings." The summary collapses; the output doesn't.

**The actual file contents.** Open the file in your editor or `cat` it. Eyeball what's there. Is the function actually there? Does it look right? Operators get fast at this — a 10-second skim catches 80% of nonsense.

**Behavior, when the work is UI or runtime.** Did the dev server reload cleanly? Does `localhost:3000` show the page? Does clicking the button actually work? Type-checking and tests verify code shape; they don't verify the feature. Use Playwright MCP, screenshots, or just opening a browser — there's no substitute for seeing the thing run.

The discipline ratio is: 90% of operator effort goes into verification, 10% into instruction. Beginners reverse this — 90% prompt engineering, 10% verification. The 10% verification is where the bugs hide.

Why claims drift from reality, even with a capable model: Claude generates text based on its model of what probably happened. When tool output is short or partial, Claude fills in the rest from plausibility. "The test passed" sounds plausible after running tests; sometimes the test ran and passed, sometimes it ran and failed silently, sometimes it didn't actually run. Without you checking the tool output, all three look the same.

A useful framing: imagine you're a code reviewer reading someone else's pull request. You wouldn't merge based on the PR description. You'd look at the diff. You'd read the test output. You'd run the code. Same standard applies to Claude's "PR" of changes in your session. The text reply IS the PR description. Don't merge on description alone.

## Worked example

You ask Claude: "Add input validation to the login form so empty fields show an error message inline."

Claude reports back: "I added validation. The form now shows inline errors when fields are empty. I also made sure error messages clear when the user starts typing again."

**Beginner workflow.** You read the reply. Sounds great. You move on to the next task.

**Operator workflow.**

1. `git diff` — what files changed? You see edits to `LoginForm.tsx` and `validation.ts`. Open both, scan. The validation looks right; the form's `onChange` handler clears errors. Matches Claude's claim.

2. Tool-call review — scan the session's Bash output. Did Claude run the type-checker? Yes — `pnpm typecheck` exit 0. Did it run any tests? You see `pnpm test:unit` ran. Output: "5 passed." But you don't have any unit tests for `LoginForm` — so what passed? Looking closer at the output, the tests that passed are unrelated. There's no test of the new validation.

3. Behavior check — start the dev server, open the form, leave the email empty, click submit. Inline error appears. Type something into the field. Error clears. Works as described.

4. Decision — feature works, but Claude's "tests pass" claim was technically true ("some tests passed") and substantively misleading ("no test of the new code"). You ask Claude to add a unit test for the new validation. NOW the claim "tests pass" will mean what it should.

Total verification time: 90 seconds. Total claim-trusting time: zero seconds, plus 2 days of compounding debt if this kept happening.

## The rule

> The text reply is the summary. The work is the tool calls, the diff, the command output, the screenshot. When Claude says "I did X," look at the evidence that X happened. If you can't find the evidence in 30 seconds, the answer is "I didn't see X happen; show me how you did it."

## Common mistakes

**Mistake 1 — Trusting "tests pass."** This claim is repeatedly misleading. It can mean: all tests passed; some tests passed and you didn't notice the failures; tests ran but were skipped; tests didn't run because the command errored before they started. The way to know which is to read the Bash output, not the text claim. Operators read the output.

**Mistake 2 — Skipping `git diff`.** Claude made "a small change." You believe it. Then you find Claude reformatted 200 lines of unrelated code, renamed a variable that's used in 17 other places, or deleted a function it thought was dead. `git diff` between sessions is non-negotiable. Cheap, fast, deterministic.

**Mistake 3 — Believing UI work without seeing the UI.** Claude says the new page is built and styled. The dev server reloads. The page... doesn't render. Or renders broken. Or renders fine but doesn't actually do the thing. Type-checks and unit tests can pass on UI that's visibly wrong. Open the browser. Click around. See it work.

## Drill

Artifacts go in `student/drills/12-verify-the-artifact/`.

**Drill 1 — Run a session, then verify it.** Open Claude Code. Ask Claude to add a new file at `student/canonical-project/lib/greetings.ts` exporting a function `greet(name: string): string` that returns `Hello, ${name}!`. After Claude reports done, run `git diff` and `cat` the file. Capture both outputs to `student/drills/12-verify-the-artifact/01-evidence.txt`. Confirm the file exists, contains the expected content, and that `git diff` only shows the new file (no unexpected changes elsewhere).

**Drill 2 — Catch a claim that doesn't match evidence.** This time, ask Claude to "run the type-checker on `student/canonical-project/` and tell me if it passes." Listen carefully to its claim. Then independently run `cd student/canonical-project && pnpm typecheck` yourself and compare. If the claim matches reality, write "matched" + brief observation. If it doesn't match, capture the discrepancy. Either way, save your finding to `student/drills/12-verify-the-artifact/02-claim-vs-reality.txt`.

**Drill 3 — Behavioral verification.** Ask Claude to modify the home page (`student/canonical-project/app/page.tsx`) to display the text "MembershipKit". After Claude finishes, start the dev server (`pnpm dev` in another terminal), open `http://localhost:3000`, and confirm visually that the text is there. Take a screenshot and save it to `student/drills/12-verify-the-artifact/03-browser-screenshot.png`. (The point is: code-level verification isn't enough; you actually have to see it in the browser to verify a UI change.)

## Checkpoint question

> Claude reports: "I added the email-sending logic and confirmed it works." You're about to deploy this to real users. List the four things you check before you believe Claude — in the order you'd check them, and what each one would catch that the previous one would not.
