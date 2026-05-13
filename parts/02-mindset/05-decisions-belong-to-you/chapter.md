# Chapter 13 — Decisions Belong to You

## Learning objective

The student can recognize when Claude is routing a technical decision back to them, and redirect Claude to propose ONE recommendation with rationale instead of presenting a menu.

## Prerequisites

- Completed: Chapter 12 — Verify the Artifact, Not the Summary
- Concepts: operator-as-manager, junior-dev-mental-model

## Core concept

You — the operator — are the decision-maker. Claude is the proposer and executor. The chain is:

**Claude proposes → you approve → Claude executes.**

That's the loop. It's not a vote. It's not a negotiation. It's a chain with three roles, and YOU are the only one who can approve.

Why this matters even more if you're non-technical: vague AI responses route decisions back to you using language that SOUNDS deferential ("which approach do you prefer?"), but you don't have the information to evaluate the options. So you pick one randomly, or you say "you decide," or you stall. Either way, the project's quality goes down — because random choices accumulate.

The right shape from Claude is not a menu. It's a **recommendation with rationale**. Something like:

> "I'd use Stripe for payment processing. Reasoning: industry default, free dev mode, integrates with Better Auth out of the box. The main alternative is Paddle (better for international tax) but you don't need that yet. OK to proceed with Stripe?"

That gives you a single proposal, the reasoning behind it, what the alternative would be, and a clear yes/no for you to make. You don't need to know Stripe vs Paddle in detail — you need to know whether the reasoning is sound. If it is, you say yes; if it isn't, you push back and ask for more reasoning. That's the right interaction shape.

What Claude WILL do, until you train it otherwise: present a menu.

> "Should I use Stripe, Paddle, or Lemon Squeezy? Each has tradeoffs. Stripe is most popular, Paddle handles international tax, Lemon Squeezy is simpler. Which would you like?"

That's wrong, even though it sounds helpful. It looks like Claude is "letting you decide." Actually Claude is routing the technical decision back to you when Claude has more context to evaluate it (which one is in your stack, what the rest of the code expects, what the future scope is). You don't have a way to choose well. The menu produces a worse outcome than a clean recommendation would.

The intervention is short: "Don't give me a menu. Pick one with reasoning. I'll approve, modify, or push back." Train this into every session. Over time, Claude in your project produces recommendations by default — because you've corrected the menu reflex enough times that the conversation context expects it.

What you DO decide:
- Whether the recommendation makes sense
- Whether the reasoning is honest
- Whether the proposed scope is right
- Whether to proceed, modify, or stop

What you DON'T decide:
- Whether to use `Map` or `Record<string, X>` for the implementation type
- Whether the variable should be camelCase or snake_case (the codebase already has a convention)
- Which library version of three available is fine
- Implementation details with no business consequence

The dividing line: does this decision have business consequences, or is it purely how something gets coded? Business consequences = you. How it gets coded = Claude. If Claude routes implementation choices back to you, redirect.

## Worked example

You're adding a search feature to MembershipKit.

**Wrong interaction:**

You: "Add search for members."

Claude: "Should I do full-text search or substring matching? Should the search be live-updating as the user types, or only on submit? Should I use Postgres tsvector, or pg_trgm, or a third-party like Algolia? Which approach do you want?"

You (non-technical): "Uh... I don't know. What do you think?"

Claude: "Each has tradeoffs..." [restates the menu]

This is broken. The decisions are routing to you and you have no basis to choose.

**Right interaction:**

You: "Add search for members."

Claude: "I'd build it as live-updating substring search using Postgres pg_trgm. Reasoning: members table will stay under 10,000 rows per organization for the foreseeable future, pg_trgm handles typos well, no third-party needed. Search will fire on each keystroke after 300ms debounce. Alternative would be Algolia if you grow past 100k members per org, but that's a future migration we don't need now. OK?"

You: "OK, proceed." (or "Wait, what's pg_trgm in plain English?" if you want to learn — Claude explains in two sentences, you approve.)

Same task. The right interaction took 30 seconds. The wrong one would have taken 20 minutes of confused back-and-forth.

## The rule

> Claude proposes (with reasoning); you approve; Claude executes. When Claude gives you a menu, push back: "Pick one with reasoning." The decision is yours, but the proposal is Claude's. Reversing this is the failure mode.

## Common mistakes

**Mistake 1 — "What do you want me to do?"** A small phrase that means Claude is routing the call to you. Hear it, intervene. The right next line from you is "tell me what you'd do, and why, and I'll approve or push back." Within a few sessions Claude will stop asking "what do you want me to do?" because the conversation pattern has been corrected.

**Mistake 2 — Picking randomly when given a menu.** You don't know the difference between options A and B. You pick A because it's listed first or sounds nicer. The randomness compounds across many decisions. The fix isn't to learn every tradeoff yourself — it's to refuse the menu and ask for a recommendation.

**Mistake 3 — Saying "you decide."** "You decide" routes the call back to Claude, which often produces no decision at all (Claude makes a noncommittal pick or invents new options). The right answer is never "you decide" or "what do you want me to do" — it's a recommendation with reasoning that you can engage with.

## Drill

Artifacts go in `student/drills/13-decisions-belong-to-you/`.

**Drill 1 — Catch yourself getting a menu.** Open Claude Code. Ask Claude something deliberately under-specified: "Help me set up logging for the MembershipKit app." Whatever Claude responds, identify whether you got a recommendation (Claude proposes ONE thing with rationale) or a menu (Claude gives you 2+ options to pick from). Save the type of response and a one-line description to `student/drills/13-decisions-belong-to-you/01-what-i-got.txt`. Format: `Menu — Claude offered console.log vs Pino vs Winston without recommending` OR `Recommendation — Claude proposed Pino with reasoning`.

**Drill 2 — Redirect to a recommendation.** If you got a menu in Drill 1, write back to Claude: "Don't give me a menu. Pick one with reasoning. I'll approve or push back." Claude will then propose one. Save the recommendation Claude made (one to three sentences) to `student/drills/13-decisions-belong-to-you/02-recommendation.txt`. If you ALREADY got a recommendation in Drill 1, skip this drill and write "N/A — already had a recommendation" in the file.

**Drill 3 — Pre-emptively prevent menus.** Start a fresh Claude Code session. In your first message, include: "When you have a technical decision to make in this session, propose ONE option with reasoning. Don't give me menus." Then ask the same vague question from Drill 1. Compare how the response differs. Save your observation (2-4 sentences) to `student/drills/13-decisions-belong-to-you/03-with-instruction.txt`.

## Checkpoint question

> A friend who's also operating Claude tells you they're stressed because every session ends with them making 5-10 small technical decisions they don't feel qualified to make. They say "Claude keeps asking me which library to use, which pattern to follow, which file to put things in, and I have no idea." Diagnose what's happening and tell them exactly what to do differently — in one or two sentences each.
