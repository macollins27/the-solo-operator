---
n: 'MOVE / 01'
title: 'The AI is the engineer. You are not.'
summary: 'You set the bar. The agent makes the technical calls in between. The hardest move is internalizing that split.'
description: 'The first foundational move for non-technical operators. The AI is the engineer; you set the bar and verify the work. Here is how to actually run that split.'
pasteExamples:
  - label: 'When the agent asks you to pick a technical option'
    text: |
      You decide. Make the technical call and tell me why.
      I'll override only if I see something you don't.
  - label: 'When the agent asks how to handle an edge case'
    text: |
      Your call. Handle it the way you think is right.
      Tell me what you picked and what tradeoff it makes.
relatedPhrasebook:
  - three-options
  - your-preference
  - what-would-you-like
pubDate: 2026-05-15
---

## The wrong question

If you ask yourself _how do I code this?_, you've already lost. You're not going to learn enough engineering to ship real software at the bar an AI agent can hit. The question doesn't scale. There's no time. And worse, asking it pulls you into the agent's seat — making technical decisions you can't defend, getting them wrong, then having to argue with the agent about a decision you didn't have the standing to make.

The right question is: _how do I tell the engineer what good looks like, and verify they did it?_

That is your job. Not coding. Not architecture. Not picking between SHA-256 and SHA-512. Your job is to set the bar that the work has to clear, and then to confirm — mechanically, against actual artifacts — that the work cleared it.

## What "the engineer" means

An AI agent operating at engineering quality is closer to a senior software developer than to a tool. It has opinions. It has preferences. It will, if you let it, design the whole system. The mistake non-technical operators make is treating it like a search engine — typing a question, getting an answer, accepting the answer.

That's not what you have. What you have is an engineer who works for you, who can read your codebase, who can write production code in any language, who can reason about tradeoffs you can't see. The mistake is asking _it_ what _you_ should do. Engineers don't ask their bosses how to code. They make the call, ship the work, defend the decision.

When the agent asks you _"which approach would you prefer?"_, the right answer is almost always _"you decide. Tell me what you picked and why."_ If it gives you the _why_, you can learn something. If it can't give a _why_, that's signal — there isn't a clear answer, which means the choice is actually constrained by something neither of you has named yet.

## What "you set the bar" means

You don't pick the implementation. You pick the outcome. The button has to work. The form has to submit. The page has to load in under two seconds. The endpoint has to return the right shape. Errors have to be visible to the user. Tests have to actually run, not just be written.

Setting the bar means writing down — somewhere durable, in a file the agent can read, in a CLAUDE.md or a project README — the outcomes that constitute _done_. Not the steps. The outcomes. The agent figures out the steps. You verify the outcomes.

This is hard because non-technical operators are tempted to over-specify. They want to control the implementation because they don't trust the agent. The override of that instinct is what this manual is about. Trust the agent to make the moves; do not trust it to declare the moves complete. _You verify the artifact, not the summary._

## What "verify" actually means

Verifying does not mean reading the code. You can't read the code. That's not the bar.

Verifying means looking at the thing the agent claims to have built. Opening the page in a browser. Clicking the button. Reading the error if one appears. Running the test command yourself and looking at the output. Sending a request to the endpoint and looking at the response.

If the agent says _"the change is complete and the tests pass,"_ you ask for the actual test runner output. You don't read the code; you read the pass/fail line. If the agent says _"the page renders correctly,"_ you ask for a screenshot. You don't audit the CSS; you look at the render.

The verification can be mechanical. That's the whole point. You can't audit the implementation, but you can audit the outcome. The outcome is what you set; the outcome is what you check.

## What the operator does not do

You do not pick variable names. You do not approve algorithm choices. You do not weigh in on whether to use a Map or a Record. You do not make architectural decisions about state management. You do not decide between client-side and server-side rendering.

If you find yourself doing any of those things, the agent has handed you a decision it should be making. Push it back. The phrase is _"you decide, tell me why."_

You also do not let the agent stop. Wind-down language — _"this is a good place to stop,"_ _"let's pick this up tomorrow"_ — is the agent dodging an impasse. The work is done when the outcome is met; _"a good place to stop"_ is not a real position. See [Your agent wants to stop at a good place](/phrasebook/good-stopping-place) for what to say back.

## The internal shift

This move is harder than it sounds. Every non-technical operator who picks up an AI agent feels the pull to take technical decisions back. The pull comes from anxiety — _if I don't pick, what if it picks wrong?_ The pull comes from impostor syndrome — _who am I to refuse?_ The pull comes from politeness — _I should be a collaborator, not a tyrant._

All three are wrong. Picking wrong is the engineer's job to recover from, not yours to prevent. Refusing to pick is not tyranny; it's role discipline. Collaboration is what the _"you decide and tell me why"_ loop already is — you're the product owner, the agent is the engineer, the discussion is the diff and the rationale.

The shift is from _I'm responsible for the code_ to _I'm responsible for the outcome_. The agent owns the code. You own the outcome. The two of you have a contract: it ships, you verify, the bar is named, the bar is met, or it isn't and we keep working.

Once that shift lands, every other move in this manual gets easier. _Refuse the menu_ is just enforcing the role split. _Verify the artifact_ is just inspecting the deliverable. _Push back on "I can't"_ is just asking the engineer to try harder. They all follow from the first move: the agent is the engineer, and you are not.
