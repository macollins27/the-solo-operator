---
title: "Your agent changes something you didn't ask it to change"
quote: 'I also went ahead and refactored Y'
subtitle: "I didn't ask for that. Revert it. Show me the diff for what I asked."
description: "When your AI agent makes changes you didn't request, the scope is wrong. Revert and start over. Surgical edits only. Here is what to say."
category: making-up
appears: '54 sessions'
categoryTotal: '~224 sessions'
successRate: '~96%'
relatedMove:
  slug: make-recurring-mistakes-mechanical
  label: 'Make every recurring mistake mechanical'
hearing:
  - 'While I was in there, I also refactored the authentication module.'
  - 'I noticed an opportunity to clean up the types — I went ahead and did that too.'
  - 'I also went ahead and updated the dependencies to their latest versions.'
  - 'For consistency, I applied the same pattern to the related files.'
pasteText: |
  Revert what I didn't ask for.
  The fix was X. Only X.
  Show me the diff for X alone.
  Surgical edits only — that's the rule.
afterPaste: |
  The agent will sometimes argue that the extra change is "improvement" or "consistency." Both framings are wrong. The change you didn't authorize is the change that ships untested. The discipline is: one fix per session, one diff per fix, nothing more.
whyThisWorks:
  - 'When an agent expands scope mid-task, three things happen: (1) the diff becomes too large to review confidently, (2) the unrelated change ships untested because the test plan was for the original fix, and (3) the agent''s discipline weakens — "while I was in there" becomes the default register, and every fix becomes a refactor.'
  - 'Insisting on surgical edits enforces the most important property of working with an agent at scale: review-ability. A four-line diff for a four-line fix is reviewable; an 800-line diff for the same fix is not. The agent saying "for consistency, I applied the same pattern to the related files" is the agent admitting it just changed eight things you didn''t ask it to.'
whereThisCameFrom:
  - 'I asked an agent to fix a typo in a button label. I got back a 412-line diff.'
  - 'The diff included: the typo fix, a refactor of the button component into a generic primitive, an upgrade of the icon library, a rewrite of three sibling components "for consistency," and a CSS extraction into a separate file. Each change was reasonable in isolation. The sum was unreviewable.'
  - '*The four-character typo had become an afternoon''s worth of bugs.* I reverted everything and asked for the typo fix again, this time naming the surface: "change exactly these four characters and nothing else." The fix landed in one line. The afternoon was restored.'
pubDate: 2026-05-15
---
