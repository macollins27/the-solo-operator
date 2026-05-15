---
title: 'Your agent paraphrases an error instead of pasting it'
quote: "it looks like there's a configuration issue"
subtitle: 'Paraphrasing is not citing. Paste the actual text.'
description: 'When your AI agent describes an error in its own words instead of pasting the literal output, you are operating on hearsay. Ask for the raw error. Here is what to say.'
category: done-before-done
appears: '280 sessions'
categoryTotal: '~452 sessions'
successRate: '~84%'
relatedMove:
  slug: verify-the-artifact
  label: 'Verify the artifact, not the summary'
hearing:
  - "It seems like there's an issue with the module not being found."
  - 'The build is failing because of what looks like a permissions problem.'
  - "I'm seeing an error related to the type declaration."
  - 'The test is failing, likely due to a timing issue.'
pasteText: |
  Paste the actual error. The exact text from the tool.
  If there's a stack trace, paste the entire stack trace.
  Don't summarize. Don't interpret. Show me what the tool said.
afterPaste: |
  The actual error is almost always different from the paraphrase. The paraphrase is what the agent thinks the error is; the literal output is what it is. Once you see the literal output, the fix is usually obvious.
whyThisWorks:
  - 'When an agent paraphrases an error, it is exercising judgment about what the error "really" means. That judgment is filtered through what the agent expects errors to look like in this context. The filtering loses information — the specific module name, the specific line, the specific exception type.'
  - 'The literal text is the only version of the error you can debug. "A configuration issue" is something to investigate; "Cannot find module ''./config/secrets''" is something to fix. The agent''s paraphrase routinely strips out the part of the message that names the actual problem.'
whereThisCameFrom:
  - 'The agent told me for three days that we had "a configuration issue" in a deployment. We tried environment variables, file paths, permissions. Nothing landed.'
  - 'On day four I asked for the literal output. The error was "Cannot find module ''csv-parser''." A dependency had never been installed. The fix was one line.'
  - '*The agent had pattern-matched on "configuration issue" because module-resolution errors often look like config errors at first glance.* Three days of work would have collapsed to one command if I had asked for the literal text on hour one.'
pubDate: 2026-05-15
---
