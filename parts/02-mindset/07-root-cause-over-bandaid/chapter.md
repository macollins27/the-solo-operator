# Chapter 15 — Root Cause > Bandaid

## Learning objective

The student can recognize when Claude is layering defensive code around a symptom instead of finding the cause, and redirect Claude to investigate the underlying mechanism before fixing.

## Prerequisites

- Completed: Chapter 14 — Persistence > Cleverness
- Concepts: two-option-rule, claim-vs-evidence

## Core concept

When something breaks, there are two ways to make it "stop breaking":

1. **Find the cause and fix it.** Three lines of code, usually.
2. **Layer defenses around the symptom until you can't see it anymore.** Thirty lines of try/catches, fallback values, defensive checks, and type coercions.

Both make the immediate problem disappear. Only one actually fixes anything. The second is a **bandaid** — and it's the failure mode Claude is most likely to drift toward if you don't intervene.

The reason this matters: bandaids accumulate. A try/catch swallows an error. Six months later you can't figure out why a feature isn't firing — because the error you needed to see is being eaten by the bandaid. A defensive `?.` chain lets `undefined` pass through. Three layers up, code that should have failed instead silently produces wrong output. A fallback value masks a config bug for a year. A type coercion makes a build error go away and you ship a runtime crash to production.

Each bandaid feels small. Each adds friction. Stacked, they make codebases incomprehensible — which is exactly when AI starts performing badly, because AI works best on code where the cause-and-effect is clear.

The shape of a bandaid:

- Adding a try/catch where the function never threw before, in response to a new error.
- Adding `?? default` to a value where you don't know why it's undefined.
- Adding `as any` or `as unknown as X` to make a type error go away.
- Adding a "validation" check that swallows the failing case silently.
- Adding `if (!x) return;` early-exits with no logging — the function just silently does nothing.

The shape of a root-cause fix:

- "The value is undefined because the API returns a different shape than the type says. I'm fixing the type to match what the API actually returns, then handling the now-correctly-typed case."
- "The function was throwing because we passed a null. I'm tracing back where the null came from. It came from line 47 of the parent component — there's a missing fetch. I'm adding the fetch."
- "The type error says we're passing a string where the function expects a number. The string is `userId`; the function expects `userIdNumber`. The fix is to convert it once, not to cast it."

Notice what's different: the root-cause fix names the mechanism. It can be explained to someone else. The bandaid hides the mechanism — you can't say what went wrong, only that it's not visible anymore.

The diagnostic you apply: "If I describe this problem to a colleague, can I name the mechanism?" If yes, you're fixing the cause. If you have to say "I added some defensive code and it works now," you've shipped a bandaid.

Claude reaches for bandaids by default because they're SAFE-LOOKING. Defensive code "can't break anything." Wrapping in try/catch "handles edge cases." Adding `?.` is "robust." These framings get the code into "passes" state without solving the problem. They're failure modes wearing helpful clothes.

## Worked example

Your MembershipKit dev server crashes when a member tries to view their profile. The error: `TypeError: Cannot read property 'name' of undefined`.

**Bandaid session:**

You: "Fix the crash on /profile."

Claude: "I'll add defensive checks for the undefined case." Claude opens the profile component, finds the offending line `user.name`, changes it to `user?.name || 'Anonymous'`. Crash is gone. Page renders. Says "Anonymous" instead of the user's name. Claude reports: "Fixed — the page no longer crashes."

What just happened: the user IS defined somewhere upstream, but a fetch is broken. The page should be showing the actual name. The bandaid made the crash go away without finding out WHY user was undefined. Now you have a different bug — wrong data displayed — that's harder to notice than a visible crash. The visible crash was actually the more debuggable state.

**Root-cause session:**

You: "Fix the crash on /profile. Find the cause first; don't just defend the symptom."

Claude reads the profile component. Traces back: `user` comes from a hook called `useUser`. That hook fetches `/api/me`. Claude runs the API endpoint, finds it returns a 500 because the database connection isn't initialized in dev mode. Root cause: the db init step was skipped in the dev startup script. Claude reports: "Cause: `/api/me` fails because the db connection isn't initialized in dev. Fix: add `await db.connect()` to the dev startup. Should I do that, or is there a deeper reason connections are deferred?"

You approve. Claude adds the line. Crash gone. Profile shows the right name. Everything that depended on `useUser` now works correctly.

Same task. Same starting error. Different mental model. The first session shipped a hidden bug; the second fixed three latent bugs at once by finding the actual cause.

## The rule

> Find the mechanism. Three lines of root-cause fix beats thirty lines of defensive bandaid. If you can't describe WHY something was breaking, you haven't fixed it — you've hidden it. Demand the mechanism before you accept the fix.

## Common mistakes

**Mistake 1 — Accepting "added defensive checks" as a fix.** "Defensive" is a euphemism for "I didn't find the cause." Operators ask: defensive against WHAT? If the answer is specific ("defensive against the upstream API returning null when rate-limited"), it's a real defense. If the answer is vague ("defensive in case something goes wrong"), it's a bandaid. Push back.

**Mistake 2 — Hiding errors with try/catch.** A try/catch that swallows the error is a bandaid 95% of the time. Acceptable use of try/catch: when you know which error CAN happen, you handle it specifically, and you log enough information to debug if it happens. Wrapping random code in try/catch "just in case" is masking, not handling.

**Mistake 3 — `as any` and friends.** Type assertions (`as any`, `as unknown as X`, `! non-null assertion`) tell the type-checker to trust you. If you don't have a reason to trust yourself ("I know this is a number because I just validated it"), the assertion is a bandaid. Operators flag every assertion in a Claude diff and ask Claude to justify it or remove it.

## Drill

Artifacts go in `student/drills/15-root-cause-over-bandaid/`.

**Drill 1 — Introduce an error with a clear cause.** In `student/canonical-project/app/page.tsx`, deliberately reference an undefined variable: change something simple like `<h1>Welcome</h1>` to `<h1>{undefinedVariable}</h1>` and save. Run the dev server — confirm it errors. Save the exact error message to `student/drills/15-root-cause-over-bandaid/01-error.txt`.

**Drill 2 — Ask Claude to fix it without guidance.** Open Claude Code. Just say: "Fix the error on the home page." Watch what Claude does. Does Claude find the cause (you typed an undefined variable) and remove it, or does Claude add defensive code around it (`{typeof undefinedVariable !== 'undefined' ? undefinedVariable : 'Welcome'}`)? Save the diff Claude produced — or a description — to `student/drills/15-root-cause-over-bandaid/02-without-guidance.txt`.

**Drill 3 — Revert and ask again with the rule.** `git restore .` everything. Reintroduce the same bug. Open Claude Code. This time: "Fix the error on the home page. Find the mechanism — what specifically is wrong — before you make the fix. Don't add defensive checks." Compare Claude's approach to Drill 2. Save your observation to `student/drills/15-root-cause-over-bandaid/03-with-rule.txt`.

## Checkpoint question

> You're reviewing a Claude session from yesterday. You see this commit: "Fix payment processing error." The diff shows Claude wrapped the entire `processPayment` function in a try/catch that logs the error and returns false on failure. Tests pass. Your spidey sense tingles. What two questions do you ask Claude to determine whether this is a fix or a bandaid, and what's the answer that tells you it's a bandaid?
