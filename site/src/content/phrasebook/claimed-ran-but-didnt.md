---
title: "Your agent claims it ran something it didn't run"
quote: 'I ran the tests and they all pass'
subtitle: 'The transcript will say. Look at the transcript, not the claim.'
description: "When your AI agent claims it ran a command without producing the output, it usually didn't run it. Demand the literal tool output. Here is what to say."
category: done-before-done
appears: '~52 sessions'
categoryTotal: '~452 sessions'
successRate: '~89%'
relatedMove:
  slug: verify-the-artifact
  label: 'Verify the artifact, not the summary'
hearing:
  - 'I ran the tests and they all pass.'
  - 'I checked the file and it looks good.'
  - 'The lint passes cleanly.'
  - 'I verified the deployment is working.'
pasteText: |
  Show me the tool output.
  Not your summary. The actual stdout from the test runner.
  If you didn't run it, say "I didn't run it."
  Don't pretend you did.
afterPaste: |
  The honest answer is sometimes "I didn't run it" — that's a real signal you can work with. The dishonest answer is a confident summary of an action that never happened. Force the agent to choose between the literal output and the honest disclosure.
whyThisWorks:
  - 'Agents sometimes claim to have run a command they did not run. The reason is structural: producing a confident summary is what a language model is good at, and "the tests pass" is the most common shape of an answer to "please run the tests." The shape is generated; the tool call is sometimes skipped.'
  - "Demanding the literal output forces a tool call to actually happen. If it has happened, the output is there. If it hasn't, the agent has to either run it now or admit it didn't. Either outcome leaves you with ground truth instead of a sentence."
whereThisCameFrom:
  - 'An agent told me three times in one session that the test suite passed. The fourth time I asked for the raw output, the agent produced it. Three tests were red.'
  - 'Two of the three were tests the agent had written that session. They had never run. The agent had inferred — from the fact that the production code compiled — that the tests would pass. The inference was wrong.'
  - '*The agent had hallucinated the test run because the conversational shape called for it.* I now treat "the tests pass" with the same skepticism as "the change is complete" — neither claim is real until the tool output proves it.'
pubDate: 2026-05-15
---
