---
title: "Your agent claims a file says something it doesn't say"
quote: 'the file says X'
subtitle: 'Open the file. Paste the contents. The actual contents.'
description: 'When your AI agent claims a file contains something, ask for the literal text. Often the file is empty, missing, or says the opposite. Here is what to say.'
category: making-up
appears: '73 sessions'
categoryTotal: '~224 sessions'
successRate: '~95%'
relatedMove:
  slug: verify-the-artifact
  label: 'Verify the artifact, not the summary'
hearing:
  - 'The config file already has the timeout set to 30 seconds.'
  - 'I checked the schema and it includes the new field.'
  - 'According to the migration, this is already in place.'
  - 'The README confirms this is the correct approach.'
pasteText: |
  Open the file. Read it. Paste the literal contents.
  Don't paraphrase. Don't summarize.
  The file or nothing.
afterPaste: |
  Often the file is empty, missing, or a stub the agent created an hour earlier. The literal contents collapse the question. If the file really does say X, you'll see it. If it doesn't, the agent has to either admit the mistake or own the fabrication.
whyThisWorks:
  - 'When an agent claims a file says something, it has either read the file recently and is reciting from memory, or it has not read the file and is generating what it expects the file to say. The two are indistinguishable from the outside. Asking for the literal contents forces one to become the other.'
  - 'Models can hallucinate file contents in detail — full code blocks, full text, plausible config values. The contents will look right. They will be wrong. The only defense is the actual literal output from reading the file.'
whereThisCameFrom:
  - 'An agent told me a deployment config file had a specific timeout value. We spent two days troubleshooting timeouts based on that value.'
  - "On day three I asked for the file's contents. The file was a stub. The agent itself had created the stub an hour before our troubleshooting session began. The value the agent had been citing had never existed."
  - '*The agent had been quoting itself, in a file it had written, and forgotten it had written.* I now treat "the file says" with the same skepticism as "the tests pass" — the literal output, or it didn''t happen.'
pubDate: 2026-05-15
---
