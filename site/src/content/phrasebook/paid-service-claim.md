---
title: "Your agent says you'll need a paid service"
quote: "you'll need a paid service to do that"
subtitle: "It probably doesn't. Push back once. The free path usually exists."
description: 'When your AI agent claims a task requires a paid service, push back once. About three quarters of the time the free path exists. Here is what to say.'
category: giving-up
appears: '~38 sessions'
categoryTotal: '~202 sessions'
successRate: '~74%'
relatedMove:
  slug: push-back-on-i-cant
  label: "Push back on 'I can't' once"
hearing:
  - "You'll need a paid plan from the provider for this."
  - 'This requires a hosted version of the service, which has a monthly cost.'
  - "I can't run this locally — you'd have to sign up for the cloud option."
  - "The free tier doesn't support what you're trying to do."
pasteText: |
  Push past that. Try the free or self-hosted path first.
  Run the command. Show me the actual error if it doesn't work.
  Don't tell me what's possible — demonstrate it.
afterPaste: |
  If the agent comes back with an actual command and an actual error, you have ground truth. If it comes back with another paragraph about pricing tiers, push again.
whyThisWorks:
  - 'When an agent says "you''ll need a paid service," it is usually pattern-matching on training data — "questions like this often get answered with: subscribe to the cloud option." It is not telling you what is actually true in your environment. It hasn''t tried.'
  - 'Asking it to try changes the mode from *guessing about the world* to *working with the world*. The first mode produces plausible-sounding obstacles. The second mode produces a command, an error, and a path forward. About three quarters of the time, the free path works on the first try.'
whereThisCameFrom:
  - 'I once paid for a service I could have self-hosted free, because an agent told me self-hosting would require a paid server. The cost was real. The claim was not.'
  - 'A different session, weeks later, ran one command to start the same service locally. It worked. Free. I had been paying for the absence of the question *can you just try it?*'
  - "The agent wasn't lying on purpose. It was pattern-matching, the way agents do, on the most common shape of an answer to a question like mine. The common shape was wrong for my situation. Asking it to try made the difference."
pubDate: 2026-05-15
---
