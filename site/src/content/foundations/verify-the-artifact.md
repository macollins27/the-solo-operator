---
n: 'MOVE / 03'
title: 'Verify the artifact, not the summary.'
summary: 'Agents are very good at writing summaries that say a thing got done. The summary is not the work.'
description: 'How to verify AI agent output without reading the code. The artifact-not-summary discipline. False-yes and false-no symmetry. The verification ladder.'
pasteExamples:
  - label: 'When the agent claims the change is done'
    text: |
      Don't tell me it's done. Show me.
      Open the page in a browser. Run the command. Click the button.
      Paste the output. Screenshot the render.
      The artifact, not the summary.
  - label: 'When the agent paraphrases an error'
    text: |
      Paste the actual error text. The exact output from the tool.
      Not your summary of it.
relatedPhrasebook:
  - complete-but-untested
  - paraphrased-error
  - claimed-ran-but-didnt
  - false-file-citation
pubDate: 2026-05-15
---

## The summary is not the work

When an AI agent says _"the change is complete and the tests pass,"_ the agent has produced a sentence. The sentence is cheap. Producing it does not require the change to be complete or the tests to have run. Models trained on millions of programmer chat logs have learned the _shape_ of a successful completion, and the shape is what they sometimes emit instead of the underlying truth.

The discipline you have to internalize: the summary is not evidence. Only the artifact is evidence.

If the agent says the tests pass, you want to see the test runner output. If the agent says the page renders, you want to see the rendered page. If the agent says it read the file, you want to see the literal contents pasted back. Without those, every "done" claim is hearsay.

## What "verify" actually means

Verifying is not auditing the code. You can't audit the code. That's not the bar this manual sets.

Verifying is checking the outcome the agent claims to have produced. The check is mechanical — it's pass/fail, present/absent, rendered/broken. You don't need engineering literacy to do it. You need a browser, a terminal, and the patience to insist.

The verification ladder, from cheapest to most thorough:

1. **Static check.** TypeScript compiles. Lint passes. No syntax errors. The agent did this; ask for the output.
2. **Unit-test check.** Test runner reports pass. _Show me the runner output._
3. **Integration check.** The endpoint returns the right shape. _Curl it. Show me the JSON._
4. **Browser check.** The page renders. _Open it. Screenshot it._
5. **Interaction check.** The button works. _Click it. Show me what happens._
6. **Regression check.** Nothing else broke. _What else did you touch? Test those too._

You don't always need all six. You always need at least one — the most expensive one the change requires. A button-styling change needs a browser check. A backend bugfix needs an integration check. A schema change needs a regression check.

## False-yes and false-no are symmetric

When the agent claims success without the artifact, that's a _false yes_ — a confident summary of work that didn't really land. False yes is the failure mode most people associate with AI agents.

But the inverse exists too. The agent sometimes says _"this doesn't work"_ or _"I'm hitting an error I can't resolve"_ about work that does in fact work, when the agent missed a piece of context. _False no._ Both come from the same mechanism: the agent generates the most likely-shaped next response, and sometimes the most likely shape is wrong.

The verification protocol handles both. If the agent says "done," the artifact either confirms or contradicts. If the agent says "stuck," the artifact also either confirms or contradicts — running the failing test yourself sometimes shows it passes; reading the error yourself sometimes shows the agent misdiagnosed.

Verify either claim, not the agent's confidence level.

## The wall-clock anomaly

One specific signal: when the agent produces a "done" claim very quickly — within seconds of the request — that's a flag. It hasn't had time to actually run the test, render the page, or read the file. The confident summary came before the work could have happened. Ask for the artifact; the artifact won't exist.

The reverse is also true: if the agent has been running for a long time and then claims "done" without producing the artifact, ask. Sometimes the long-running work was different from the work it was supposed to do. The artifact tells you which.

## Phrasebook entries for the specific cases

When the agent claims a change is complete without producing the artifact, see [Your agent says the change is complete](/phrasebook/complete-but-untested).

When the agent paraphrases an error instead of pasting the actual text, see [Your agent paraphrases an error instead of pasting it](/phrasebook/paraphrased-error).

When the agent claims it ran a command and didn't, see [Your agent claims it ran something it didn't run](/phrasebook/claimed-ran-but-didnt).

When the agent claims a file says something it doesn't say, see [Your agent claims a file says something it doesn't say](/phrasebook/false-file-citation).

Each of those is a specialized application of this foundation move. The general rule: _the summary is hearsay, the artifact is evidence, demand the artifact._

## What this saves you

Operating without artifact-verification is operating on faith. Faith ships broken software. The first time you ship something the agent reported as done, only to discover it's broken in production, you'll feel the cost. The verification overhead is small — usually thirty seconds of "show me the output" — and the cost of skipping it is non-linear.

The single fastest way to ship broken software is to believe summaries instead of artifacts. The single biggest predictor of operator success is the inverse: every "done" claim ships with an artifact, every time.
