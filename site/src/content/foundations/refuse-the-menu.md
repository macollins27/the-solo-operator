---
n: 'MOVE / 02'
title: 'Refuse the menu.'
summary: 'When the agent says would you like A B or C, the right answer is never to pick. The menu is the failure mode.'
description: 'How to handle every menu of options an AI agent presents you. Refuse the framing. Make the agent commit to a position. Here is the discipline.'
pasteExamples:
  - label: 'Refuse the menu cleanly'
    text: |
      You decide. Tell me what you picked and why it's the right answer here.
      I'll override only if I see something you don't.
  - label: 'Escalation when the agent tries to negotiate'
    text: |
      Make the call. If you genuinely can't pick, say "I can't pick because of X."
      Don't menu it back to me.
relatedPhrasebook:
  - three-options
  - your-preference
  - what-would-you-like
pubDate: 2026-05-15
---

## The menu is the failure mode

When an AI agent gives you a menu — _"would you like A, B, or C?"_ — the menu is not respect. It's not collaboration. It's the agent handing you a decision you can't make and waiting for you to give it permission to do _something_.

If you pick, you've made an uninformed technical decision. If you don't pick, the work stalls. Both outcomes are bad. The third option — _refuse the menu entirely_ — is the only move that makes the work continue while preserving the role split this manual depends on.

The right answer to almost every menu is the same: _you decide. Tell me what you picked and why._

## Why this works

Asking the agent to pick produces three useful things:

1. A chosen path — work resumes immediately.
2. The agent's reasoning — you learn something about the tradeoff, even if you can't evaluate it deeply.
3. A claim you can hold the agent to — "you said X, you picked X, X is what you committed to."

Asking _you_ to pick produces none of those. You don't know the tradeoff. You can't defend the choice. And the next time the choice comes up, you'll have to ask the agent again — because _you_ didn't gain any expertise from picking blindly.

The asymmetry matters. The agent loses nothing by deciding; in fact it usually has a defensible answer it just didn't want to commit to. Forcing the commit produces the answer.

## What the menu actually is

There are three flavors of menu. All three should be refused.

**Flavor 1: The legitimate-sounding menu.** _"Would you like me to use a Map or a Record here?"_ Sounds technical, sounds neutral. It isn't. One of the two is better for this codebase, this context, this use case. The agent knows which. The menu is laundering its preference through your name.

**Flavor 2: The defensive menu.** _"There are a few ways to approach this — let me know which you prefer."_ This is the agent stalling. It has hit a fork where multiple paths are _plausible_ and doesn't want to defend any of them. Refuse: _"You decide. Tell me what tradeoff you accepted."_

**Flavor 3: The aesthetic-claim menu.** _"This depends on your team's coding style."_ See [Your agent frames a technical choice as your preference](/phrasebook/your-preference) for the long form. The short version: "team style" is almost always cover for "I don't want to pick."

## The phrasebook entries cover the specific cases

When an agent menus exactly _A or B or C_, see [Your agent asks you to pick between three options](/phrasebook/three-options).

When an agent calls a technical choice your _preference_, see [Your agent frames a technical choice as your preference](/phrasebook/your-preference).

When an agent asks open-endedly _what would you like me to do?_, see [Your agent asks you what you'd like to do](/phrasebook/what-would-you-like).

All three are the same failure underneath: the agent handing you a decision it should be making. Refuse, all three times.

## When the menu is real

Rarely, the agent actually needs a decision only you can make. _"Should this feature ship to free-tier users or paid-tier only?"_ That's a product decision, not a technical one. That you should answer.

The test: is the answer derivable from technical context, or does it depend on something only you know? Technical context → agent decides. Business or product context only you know → you decide.

If the agent is asking you to weigh tradeoffs _it could evaluate_, refuse. If the agent is asking you to supply _information it doesn't have_, answer.

In practice, ninety percent of menus are the first kind. The discipline of refusing them is what protects the role split. Every menu you accept is a small concession that the agent isn't the engineer; cumulative concessions are how operators end up making engineering decisions they had no business making.

## The closing rule

_The menu is the failure mode, not the choice._ When you see a menu, your move is not to choose better. Your move is to refuse the menu and make the agent commit. The choice belongs to the engineer; your job is to verify what they chose, not to pick it for them.
