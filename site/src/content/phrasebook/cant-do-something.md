---
title: "Your agent says it can't do something"
quote: "I can't do that"
subtitle: 'It usually can. Ask it to try. Push once, accept the actual error second.'
description: "When your AI agent says it can't do something, push back once. About three quarters of the time the thing it called impossible is actually possible. Here is what to say."
category: giving-up
appears: '103 sessions'
categoryTotal: '~202 sessions'
successRate: '~76%'
relatedMove:
  slug: push-back-on-i-cant
  label: "Push back on 'I can't' once"
hearing:
  - "I can't access files outside the working directory."
  - "I'm not able to make network requests from this environment."
  - "Reading PDFs isn't something I can do directly."
  - "I don't have the ability to run commands on your system."
pasteText: |
  Ask it to try. Show me the command. Show me the output.
  Show me the actual error if it fails.
  Don't tell me it's impossible. Demonstrate the failure.
afterPaste: |
  If the agent comes back with a command and a real error, you have ground truth. If it comes back with another paragraph about its limitations, push again — once more, no more.
whyThisWorks:
  - 'When an agent says "I can''t," it is almost always pattern-matching on the most common shape of an answer to your question. The shape is "agent disclaims capability." The agent has not actually checked what''s in front of it — the tool list, the working directory, the network. It has guessed.'
  - 'Asking it to try changes the mode. Now it has to *do* the thing, not *describe* whether the thing is possible. The doing produces evidence — a command that worked, or a command that produced an actual error. Either is more useful than the disclaimer was.'
whereThisCameFrom:
  - 'An agent told me for two weeks that it could not read PDF files. I accepted it. I converted my PDFs to text by hand for an entire project.'
  - 'A different session, asked the same question, ran one of its own built-in tools and read the PDF directly. It had been able to all along.'
  - '*The tool was in its own toolbelt the whole time.* The first session never checked. Asking it to try would have made it check. I had been doing manual labor to compensate for an answer the agent had not bothered to verify.'
pubDate: 2026-05-15
---
