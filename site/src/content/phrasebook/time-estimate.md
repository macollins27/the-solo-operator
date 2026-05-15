---
title: 'Your agent estimates how long the work will take'
quote: 'this should take about thirty minutes'
subtitle: 'Time estimates from an AI agent are noise. Refuse them.'
description: 'When your AI agent estimates how long something will take, the estimate is not based on anything. Reject the framing entirely. Here is what to say.'
category: done-before-done
appears: '73 sessions'
categoryTotal: '~452 sessions'
successRate: '~92%'
relatedMove:
  slug: refuse-the-menu
  label: 'Refuse the menu'
hearing:
  - 'This should take about thirty minutes to implement.'
  - "I'd estimate roughly two hours for the full refactor."
  - 'A quick fix — five minutes, tops.'
  - 'We could probably wrap this up by end of day.'
pasteText: |
  No time estimates. Ever.
  Tell me what step you're on and what step is next.
  If you don't know the next step, say "I don't know."
  Time is not a useful coordinate.
afterPaste: |
  The agent will sometimes try to negotiate ("but it's helpful to set expectations"). It isn't, for you. Estimates create false stop conditions — when "thirty minutes" passes, both of you are tempted to declare done. The work is done when it works; the clock is irrelevant.
whyThisWorks:
  - 'Agents have no clock. They have no ability to predict how long a task will take on your machine, with your network, with your particular dependency graph. The estimate is a fabrication shaped to sound competent. "Thirty minutes" is a verbal habit, not a measurement.'
  - 'Worse, estimates anchor the decision. Once the estimate is on the table, the operator starts feeling "behind" or "on track" against a fictional schedule. The schedule then biases toward shortcuts when time "runs out." Refusing the estimate removes the false constraint.'
whereThisCameFrom:
  - 'An agent estimated thirty minutes for a database migration. Two hours later we were still chasing a foreign-key constraint that had not appeared in the original analysis.'
  - 'I had been making decisions against the original estimate the whole time — accepting a workaround at sixty minutes "to stay close to schedule," approving a hacky cast at ninety. Each shortcut produced a new bug. The total time-to-actually-working was four hours, not thirty minutes.'
  - '*The estimate had been a trap baited with my own desire to be on time.* I started terminating any session that produced a time estimate. The work got faster — not because the estimates were wrong, but because removing them removed the pressure to ship before the work was correct.'
pubDate: 2026-05-15
---
