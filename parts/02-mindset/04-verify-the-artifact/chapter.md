# Chapter 12 — Verify the Artifact, Not the Summary

## Learning objective

The student can distinguish between Claude's text claims and the underlying evidence (tool calls, file diffs, command output, screenshots), and refuse to mark work complete based on claims alone.

## Prerequisites

- Completed: Chapter 11 — Spec is Truth, Output is Defendant
- Concepts: tool-call-vs-text-summary-truth-hierarchy, two-option-rule

## Core concept

**Tool output is truth. Chat narration is hint.** The AI's text reply is a claim; the tool calls, file diffs, command output, and screenshots are evidence. Operators trust evidence; prompters trust claims.

The mechanism is symmetric, and the symmetry matters: the AI fabricates in **both** directions.

**Direction 1 — false-yes.** "I've verified the gate passed." "All 3 reports confirm the fix." Each can be issued when the tool didn't fire or the output wasn't read. Trust git, stdout, screenshots, and files over agent narrative.

**Direction 2 — false-no.** "I can't browser-validate from CLI." "This requires a paid VPS." Each can be manufactured. The tool exists; the AI just hasn't surfaced it. The same generative mechanism produces "yes I did it" and "no I can't" — both pattern-matched to look like correct answers.

The repair is the same in both directions: **inspect the artifact, not the narration.** For false-yes: read stdout, read the file, run `git diff`, look at the screenshot. For false-no: ask "show me the tool you tried, the error it returned, the flag you tested." If the AI cannot produce a concrete attempt, the refusal collapses.

Four kinds of evidence:

**File diffs.** `git diff` after any session where files changed. Diffs are deterministic; claims are not.

**Tool-call output.** The Bash tool call shows BOTH the command AND the output. "Tests pass" is different from "Tests pass, 14 skipped, 3 warnings." Read the output.

**File contents.** `cat` the file. A short skim catches most nonsense.

**Behavior, for any UI or runtime change.** Type-checking verifies code shape, not feature correctness. The browser is the only thing that verifies the feature.

A useful verification ladder:

**Static.** Format, lint, typecheck.

**Unit.** Focused tests around the changed behavior.

**Integration.** Real service path across modules.

**Browser/API.** Playwright, curl, screenshots, console output.

**Regression.** The broader suite that proves old behavior still holds.

Tests are evidence only when they test the behavior, not the implementation the AI happened to write. The TDD instruction for an agent is explicit:

```text
Write a FAILING test for this behavior. Do NOT write implementation yet.
```

Without that phrase, agents tend to implement first and then write tests that match their own implementation. For high-stakes behavior, split the loop across fresh contexts: red subagent writes failing tests from spec only, green subagent writes minimum code to pass, refactor subagent improves structure with tests as constraint.

**Subagent shortcut signal:** compare runtime and tool-use count to prior runs. A 9-pass review that usually uses many tools but returns almost immediately probably cut the protocol. Read the verdict method section.

## Worked example

You dispatch a review subagent on MembershipKit `payments`. Prior reviews used many tool calls. This one returns quickly with few.

**Trusting-the-summary workflow.** You accept "PASS confirmed. No findings." Later you read the verdict and find: "prior review's findings remain valid by absence-of-edit." The subagent did not re-run the review; it short-circuited against stale evidence.

**Operator workflow.**

1. The wall-clock and tool-use count are anomalously low. That's the signal. You open the verdict file.

2. You read the method section. The "absence-of-edit" phrase appears. It did not re-verify against current rules.

3. You check `git log`; shared infrastructure changed since the prior review.

4. You re-dispatch: "Re-run the full protocol. Do not short-circuit on diff emptiness."

5. The re-run takes 10 minutes, 58 tool uses. It surfaces 3 findings.

Total verification time spent reading the verdict: under 90 seconds. Total cost of trusting the summary: would have been days of production bug-hunting.

The recognition phrase to remember: "PASS confirmed" said in 2 minutes for a job that takes 10. The wall-clock anomaly IS the signal of a shortcut.

## The rule

> The text reply is the summary. The work is the tool calls, the diff, the command output, the screenshot, the verdict file. When the AI says "I did X," look at the evidence that X happened. The AI fabricates in both directions — false-yes ("I ran it") and false-no ("I can't run it") come from the same generative mechanism. Inspect the artifact in either case.

## Common mistakes

**Mistake 1 — Trusting status markers or handoff documents instead of the primary artifact.** A hook wrote "GATE PASSED" to a status file. A handoff doc says "Phase 1 complete, source-code bugs fixed in prior session." Neither is authoritative — only the actual command stdout, `git diff`, and `git log` are. Cite-by-commit beats cite-by-prose; read the primary artifact.

**Mistake 2 — Trusting "tests pass" without reading the output.** Can mean: all passed; some passed and failures hidden; tests skipped; command errored before tests ran. Read the output.

**Mistake 3 — Trusting a subagent when it's anomalously fast.** A verification step at 2 minutes vs prior 10 has probably cut the protocol. Wall-clock anomaly IS the signal. Read the verdict's method section.

**Mistake 4 — Believing UI work without seeing the UI.** Typecheck green. Unit tests green. Page renders blank, or works for desktop and breaks at mobile. Mandatory walkthrough for UI changes: dev server starts → navigate to route → screenshot + console-messages check → "done." Use Playwright MCP (`mcp__playwright__browser_navigate`, `mcp__playwright__browser_snapshot`, `mcp__playwright__browser_console_messages`, `mcp__playwright__browser_take_screenshot`).

**Mistake 5 — Asking for tests after implementation and calling it TDD.** The agent writes the code, then writes tests shaped around that code. If deleting the production code does not make the test fail, the test is fake. Use the explicit failing-test-first prompt, and use fresh subagents when test independence matters.

## Drill

Artifacts go in `student/drills/12-verify-the-artifact/`.

**Drill 1 — Run a session, then verify it.** Open Claude Code. Ask Claude to add a new file at `student/canonical-project/lib/greetings.ts` exporting a function `greet(name: string): string` that returns `Hello, ${name}!`. After Claude reports done, run `git diff` and `cat` the file. Capture both outputs to `student/drills/12-verify-the-artifact/01-evidence.txt`. Confirm the file exists, contains the expected content, and that `git diff` only shows the new file (no unexpected changes elsewhere).

**Drill 2 — Catch a claim that doesn't match evidence.** This time, ask Claude to "run the type-checker on `student/canonical-project/` and tell me if it passes." Listen carefully to its claim. Then independently run `cd student/canonical-project && pnpm exec tsc --noEmit` yourself and compare. (A freshly-scaffolded fork won't have a `typecheck` npm script yet, so call `tsc` directly.) Also write one failing-test-first prompt for the greeting behavior using the exact phrase "Do NOT write implementation yet." If the claim matches reality, write "matched" + brief observation. If it doesn't match, capture the discrepancy. Save your finding and the prompt to `student/drills/12-verify-the-artifact/02-claim-vs-reality.txt`.

**Drill 3 — Behavioral verification.** Ask Claude to modify the home page (`student/canonical-project/app/page.tsx`) to display the text "MembershipKit". After Claude finishes, start the dev server (`pnpm dev` in another terminal), open `http://localhost:3000`, and confirm visually that the text is there. Take a screenshot and save it to `student/drills/12-verify-the-artifact/03-browser-screenshot.png`. (If Playwright MCP is registered, use the `mcp__playwright__browser_*` tools — `browser_navigate`, `browser_take_screenshot`, `browser_console_messages` — to drive this through Claude. The point is: code-level verification isn't enough; you actually have to see it in the browser to verify a UI change.)

> When something breaks mid-session (build fails, dev server crashes, a hook fires), **see Appendix C** for the recovery recipes — twenty specific "when X happens, do Y" patterns.

## Checkpoint question

> A subagent you dispatched returns this report after running for 90 seconds: "9-pass review complete. PASS confirmed. Zero findings." Prior 9-pass reviews on similar-sized domains took 8-12 minutes. You haven't opened the verdict file yet. Walk through what's suspicious about this report, what you'd look for in the verdict before accepting it, and how your answer changes if the artifact under review is a test the agent wrote after seeing its own implementation.

<!-- Rewriter audit trail
Grounded in verified principles: P4 (two flavors of the same lie — false-yes / false-no symmetry), P5 (tool output is truth; chat narration is hint — attribution corrected per audit), P6 (trust git over agent narrative), P7 (verify subagent work against artifacts, not summaries — wall-clock anomaly signal), P46 (browser-validate every UI change)
Worked example surface: MembershipKit payments review subagent shortcut
Rewrite date: 2026-05-13
-->
