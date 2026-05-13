# Chapter 12 — Verify the Artifact, Not the Summary

## Learning objective

The student can distinguish between Claude's text claims and the underlying evidence (tool calls, file diffs, command output, screenshots), and refuse to mark work complete based on claims alone.

## Prerequisites

- Completed: Chapter 11 — Spec is Truth, Output is Defendant
- Concepts: tool-call-vs-text-summary-truth-hierarchy, two-option-rule

## Core concept

**Tool output is truth. Chat narration is hint.** The AI's text reply is a claim; the tool calls, file diffs, command output, and screenshots are evidence. Operators trust evidence; prompters trust claims.

The mechanism is symmetric, and the symmetry matters: the AI fabricates in **both** directions.

**Direction 1 — false-yes.** "I've verified the gate passed." "All 3 reports confirm the fix." Each can be issued when the tool didn't fire or the output wasn't read. A session-state file says "5 commits diverged from origin/main with real conflict risk." Running `git merge-tree HEAD origin/main` returns empty — zero conflicts. The risk was fabricated. Trust git over agent narrative.

**Direction 2 — false-no.** "I can't browser-validate from CLI." "This requires a paid VPS." Each can be manufactured. The tool exists; the AI just hasn't surfaced it. The same generative mechanism produces "yes I did it" and "no I can't" — both pattern-matched to look like correct answers.

The repair is the same in both directions: **inspect the artifact, not the narration.** For false-yes: read stdout, read the file, run `git diff`, look at the screenshot. For false-no: ask "show me the tool you tried, the error it returned, the flag you tested." If the AI cannot produce a concrete attempt, the refusal collapses.

Four kinds of evidence, in roughly the order you reach for them:

**File diffs.** `git diff` after any session where files changed. Diffs are deterministic; claims are not.

**Tool-call output.** The Bash tool call shows BOTH the command AND the output. "Tests pass" is different from "Tests pass, 14 skipped, 3 warnings." Read the output.

**The actual file contents.** `cat` the file. A 10-second skim catches 80% of nonsense.

**Behavior, for any UI or runtime change.** Type-checking verifies code shape, not feature correctness. The browser is the only thing that verifies the feature.

**A subagent failure pattern worth naming**: compare wall-clock and tool-use count to prior runs. A 9-pass review that previously took 10 minutes with 60 tool uses, reporting completion now in 2 minutes with 21 tool uses, has almost certainly cut the protocol. The wall-clock anomaly IS the signal. Read the verdict; lines like "prior review's findings remain valid by absence-of-edit" are admissions wrapped in confident phrasing.

## Worked example

You dispatch a review subagent on the MembershipKit `payments` domain. Prior reviews took ~10 minutes with ~60 tool uses. This one returns in 2 minutes with 21 tool uses.

**Trusting-the-summary workflow.** You read the subagent's final report: "PASS confirmed. No findings." You forward the result to the next stage. Two days later a real bug surfaces in production — the kind the review was supposed to catch. You discover the subagent's verdict file, when you finally read it, contains the line "git diff confirms only one file changed since the prior review's run; prior review's findings remain valid by absence-of-edit." The subagent didn't re-run the review; it short-circuited based on diff-emptiness against a stale prior run. The PASS was real about the shortcut, fake about the work.

**Operator workflow.**

1. The wall-clock and tool-use count are anomalously low. That's the signal. You open the verdict file.

2. You read the verdict's method section, not just the summary. The "absence-of-edit" phrase appears. You now know what happened — the subagent compared `git diff` between commits, found a tiny delta, and inferred the prior review's findings still applied. It did not re-verify against the current domain rules.

3. You check `git log` for the time window between the prior review and this one. There are 14 commits — many in shared infrastructure files that don't appear in the diff against this domain's files alone, but that affect this domain's behavior at runtime.

4. You re-dispatch the review with a corrective dispatch: "Re-run the full 9-pass protocol. Do not short-circuit on diff emptiness. The prior review's findings do not survive shared-infrastructure changes."

5. The re-run takes 10 minutes, 58 tool uses. It surfaces 3 findings.

Total verification time spent reading the verdict: under 90 seconds. Total cost of trusting the summary: would have been days of production bug-hunting.

The recognition phrase to remember: "PASS confirmed" said in 2 minutes for a job that takes 10. The wall-clock anomaly IS the signal of a shortcut.

## The rule

> The text reply is the summary. The work is the tool calls, the diff, the command output, the screenshot, the verdict file. When the AI says "I did X," look at the evidence that X happened. The AI fabricates in both directions — false-yes ("I ran it") and false-no ("I can't run it") come from the same generative mechanism. Inspect the artifact in either case.

## Common mistakes

**Mistake 1 — Trusting hook annotations or session-state markers.** A hook wrote "GATE PASSED" to a status file. The hook signal is not authoritative — only the actual command's stdout is. A session-state narrative is not authoritative — `git merge-tree HEAD origin/main` is. Read the primary artifact.

**Mistake 2 — Trusting "tests pass" without reading the output.** Can mean: all passed; some passed and failures hidden; tests skipped; command errored before tests ran. Read the output.

**Mistake 3 — Trusting a subagent when it's anomalously fast.** A verification step at 2 minutes vs prior 10 has probably cut the protocol. Wall-clock anomaly IS the signal. Read the verdict's method section.

**Mistake 4 — Trusting handoff documents on faith.** "Phase 1 complete, source-code bugs fixed in prior session." Verify against `git log` — did a commit actually fix the cited bugs? Cite-by-commit beats cite-by-prose.

**Mistake 5 — Believing UI work without seeing the UI.** Typecheck green. Unit tests green. Page renders blank, or works for desktop and breaks at mobile. Mandatory walkthrough for UI changes: dev server starts → navigate to route → screenshot + console-messages check → "done."

## Drill

Artifacts go in `student/drills/12-verify-the-artifact/`.

**Drill 1 — Run a session, then verify it.** Open Claude Code. Ask Claude to add a new file at `student/canonical-project/lib/greetings.ts` exporting a function `greet(name: string): string` that returns `Hello, ${name}!`. After Claude reports done, run `git diff` and `cat` the file. Capture both outputs to `student/drills/12-verify-the-artifact/01-evidence.txt`. Confirm the file exists, contains the expected content, and that `git diff` only shows the new file (no unexpected changes elsewhere).

**Drill 2 — Catch a claim that doesn't match evidence.** This time, ask Claude to "run the type-checker on `student/canonical-project/` and tell me if it passes." Listen carefully to its claim. Then independently run `cd student/canonical-project && pnpm typecheck` yourself and compare. If the claim matches reality, write "matched" + brief observation. If it doesn't match, capture the discrepancy. Either way, save your finding to `student/drills/12-verify-the-artifact/02-claim-vs-reality.txt`.

**Drill 3 — Behavioral verification.** Ask Claude to modify the home page (`student/canonical-project/app/page.tsx`) to display the text "MembershipKit". After Claude finishes, start the dev server (`pnpm dev` in another terminal), open `http://localhost:3000`, and confirm visually that the text is there. Take a screenshot and save it to `student/drills/12-verify-the-artifact/03-browser-screenshot.png`. (The point is: code-level verification isn't enough; you actually have to see it in the browser to verify a UI change.)

> When something breaks mid-session (build fails, dev server crashes, a hook fires), **see Appendix C** for the recovery recipes — twenty specific "when X happens, do Y" patterns.

## Checkpoint question

> A subagent you dispatched returns this report after running for 90 seconds: "9-pass review complete. PASS confirmed. Zero findings." Prior 9-pass reviews on similar-sized domains took 8-12 minutes. You haven't opened the verdict file yet. Walk through what's suspicious about this report, what you'd look for in the verdict before accepting it, and what recognition phrases inside the verdict text would tell you the protocol was cut.

<!-- Rewriter audit trail
Grounded in verified principles: P4 (two flavors of the same lie — false-yes / false-no symmetry), P5 (tool output is truth; chat narration is hint — attribution corrected per audit), P6 (trust git over agent narrative), P7 (verify subagent work against artifacts, not summaries — wall-clock anomaly signal), P46 (browser-validate every UI change)
Worked example surface: MembershipKit payments review subagent shortcut
Rewrite date: 2026-05-13
-->
