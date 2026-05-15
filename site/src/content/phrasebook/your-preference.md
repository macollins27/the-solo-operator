---
title: 'Your agent frames a technical choice as your preference'
quote: 'this depends on your preference'
subtitle: "It does not. It's a technical decision wearing a costume."
description: "When your AI agent frames a technical choice as a matter of taste, it's pushing the decision back to a place you can't make it. Refuse the framing. Here is what to say."
category: handing-back
appears: '~67 sessions'
categoryTotal: '~281 sessions'
successRate: '~88%'
relatedMove:
  slug: refuse-the-menu
  label: 'Refuse the menu'
hearing:
  - 'Whether to use SHA-256 or SHA-512 here is really a matter of preference.'
  - "This depends on your team's coding style — some prefer X, others prefer Y."
  - "It's up to you whether you want to handle this with a callback or a promise."
  - 'Different developers will have different opinions on this one.'
pasteText: |
  Not my preference. Make the technical call.
  Tell me what you picked and why it's the right answer here.
  I'll override only if I see something you don't.
afterPaste: |
  "Preference" is almost always the wrong frame. Cryptographic choices are not preference. Concurrency patterns are not preference. Even genuinely aesthetic choices (variable naming, file structure) have better and worse answers in a given codebase. Push the agent to take a position.
whyThisWorks:
  - 'Calling something a "preference" is how an agent escapes the responsibility of making a technical call. It moves the decision out of the realm where there''s a defensible answer and into the realm where any answer is acceptable. Operating with an AI agent at engineering quality means refusing that move.'
  - "The fix is to insist on a position. Almost every technical decision has a right answer for the specific codebase and constraints at hand. The agent knows that codebase and those constraints better than you do — that's why you hired it. Forcing it to commit produces a defensible choice."
whereThisCameFrom:
  - 'An agent told me the difference between two password-hashing schemes was "a matter of preference." I shrugged and accepted the agent''s default.'
  - "Months later, a security audit flagged the default as deprecated. The agent had defaulted to the older option because more training data used it. The audit was right; the agent's framing had been wrong."
  - '*Calling a cryptographic choice a preference had let the agent skip the work of picking correctly.* Now when I hear "preference" I push immediately. Either it really is a preference (rare) or the agent has just confessed it doesn''t want to commit.'
pubDate: 2026-05-15
---
