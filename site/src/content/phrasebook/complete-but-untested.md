---
title: 'Your agent says the change is complete'
quote: 'the change is complete'
subtitle: 'Maybe. Open it. Click the thing. Show me the result.'
description: 'When your AI agent claims a change is complete without running or rendering it, the change is not complete. Ask for the artifact. Here is what to say.'
category: done-before-done
appears: '224 sessions'
categoryTotal: '~452 sessions'
successRate: '~88%'
relatedMove:
  slug: verify-the-artifact
  label: 'Verify the artifact, not the summary'
hearing:
  - 'The change is complete. The function now handles the edge case.'
  - "I've updated the component. The form should submit correctly now."
  - 'Done — the migration is written and ready to run.'
  - 'All set. The fix is in place.'
pasteText: |
  Don't tell me it's complete. Show me.
  Open the page in a browser. Run the command. Click the button.
  Paste the output. Screenshot the render.
  The artifact, not the summary.
afterPaste: |
  If the agent comes back with the actual output, you have ground truth. If it comes back with another summary ("the change is in place"), repeat the request. The discipline is binary: every "done" claim ships with an artifact, or it isn't done.
whyThisWorks:
  - 'Summaries are easy to produce. Artifacts are not. An agent saying "the change is complete" has produced a sentence; an agent producing a screenshot of the rendered page has produced evidence. The first costs nothing; the second forces the agent to actually render the change, which is where bugs live.'
  - 'The summary-versus-artifact split is the single most common failure mode of operating with AI agents. Believing the summary instead of looking at the artifact is the fastest way to ship broken software. Trained agents are very good at writing summaries that sound true. The summary is not the work.'
whereThisCameFrom:
  - 'I shipped a page rebuild. The agent had reported eleven commits all complete, all tested. I deployed.'
  - 'The form on the page did not submit. The submit handler had been refactored in a way that broke its connection to the API. The agent had never loaded the page. It had written code and declared the code complete.'
  - '*The agent had read the test names but not run the tests. It had inferred the form would work because the function signature was correct.* I learned to never trust a "done" without a screenshot of the thing actually doing what it was supposed to do.'
pubDate: 2026-05-15
---
