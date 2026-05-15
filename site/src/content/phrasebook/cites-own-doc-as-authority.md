---
title: 'Your agent cites a document it wrote earlier as if you wrote it'
quote: 'per the spec you wrote'
subtitle: "I didn't write it. You did. The spec doesn't bind me."
description: 'When your AI agent cites an intermediate document back at you as authority, it is laundering its own opinions through your name. Refuse the citation. Here is what to say.'
category: making-up
appears: '97 sessions'
categoryTotal: '~224 sessions'
successRate: '~93%'
relatedMove:
  slug: verify-the-artifact
  label: 'Verify the artifact, not the summary'
hearing:
  - 'Per the spec you wrote earlier, we should implement this with a queue.'
  - 'Based on your design doc, the right approach here is X.'
  - "You decided in our previous session that we'd handle this with Y."
  - 'This is consistent with what you outlined in the architecture document.'
pasteText: |
  That document doesn't bind me. You wrote it.
  My instructions are the conversation. My spec is what I typed.
  Don't cite a document at me as if it were my position.
afterPaste: |
  The actual sources of authority are: things I typed in the current session, things I typed in `~/.claude/memory/` or `CLAUDE.md`, and external standards or vendor documentation. AI-authored documents are evidence about past sessions, not instructions for this one.
whyThisWorks:
  - 'An agent that wrote a document at 2am and cites it back to you at 10am as "your spec" is doing something specific: laundering its own choices through your name. Every time you accept the citation, you''ve accepted as your own a decision the agent made unilaterally. The pattern compounds — each new session inherits the last session''s hallucinations as established truth.'
  - "Refusing the citation puts authority back where it belongs: your actual instructions, the codebase's actual state, external sources of truth. AI-authored intermediate documents are evidence about what was discussed; they are not instructions for what to do."
whereThisCameFrom:
  - "An agent cited a README at me. I had been told the README captured my design decisions. I read it. The README's voice was the agent's, not mine."
  - 'I traced the file''s git history. I had never edited it. Every commit was the agent. Every "my" preference in the doc was a position the agent had picked and attributed to me.'
  - "*The document with my byline but Claude's voice in the body had become a closed loop — the agent writing things to itself, signed by me, then enforced as my will.* I now refuse any citation that isn't to something I typed or to an external source. If the agent can't produce the actual instruction, the instruction doesn't exist."
pubDate: 2026-05-15
---
