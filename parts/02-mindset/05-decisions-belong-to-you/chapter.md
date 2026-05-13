# Chapter 13 — Decisions Belong to You

## Learning objective

The student can recognize when Claude is routing a technical decision back to them, and redirect Claude to propose ONE recommendation with rationale instead of presenting a menu.

## Prerequisites

- Completed: Chapter 12 — Verify the Artifact, Not the Summary
- Concepts: operator-as-manager, junior-dev-mental-model

## Core concept

The chapter title is a deliberate trick. The decisions that "belong to you" are narrow: **approve / redirect**. Every technical decision between outcomes belongs to the AI. The most common operator failure is taking the wrong decisions — ones the AI should have made but routed back to a non-technical human.

The right pattern from Claude is a four-step shape: **own it → solve it → present it → await approval.**

> "Going with Stripe for payment processing. Reasoning: industry default, integrates with the auth library already in the stack, clean dev mode. Alternative was Paddle (better for international tax) but you don't have international members in spec. Proceeding unless you push back."

You decide whether the reasoning is sound. You approve or redirect. You did not need to know Stripe-vs-Paddle internals; you needed to know whether the engineer's reasoning held up.

The wrong pattern from Claude is **the menu**:

> "Should I use Stripe, Paddle, or Lemon Squeezy? Each has tradeoffs..."

The menu sounds helpful. It isn't. Claude has the context to evaluate (which library is in your stack, what the existing code expects). You don't. Every menu picked randomly accumulates a bad decision.

Recognition phrases for the menu pattern, all forbidden:

- "what do you want me to do?" / "How would you like to proceed?"
- "Which option do you prefer — A, B, or C?" / "Should I do X or Y?"
- "your call" / "let me know how you'd like to proceed"
- "Two options:" / "Three options:" followed by a numbered list with no recommendation
- "which approach?"

The intervention: "Don't give me a menu. Pick one with reasoning."

There's a symmetric failure on the other side: the AI manufactures a refusal where none exists. Recognition phrases:

- "I can't browser-validate from CLI."
- "I don't have access to that."
- "This requires a paid service / VPS."
- "That's not possible from this environment."

The AI claims a capability ceiling that doesn't exist — either because tools aren't surfaced in working memory, or training-data says "AIs can't do X" generically. The intervention: "Show me the tool you tried, the error it returned, the flag you tested." Real refusals cite real attempts; manufactured ones collapse under one question.

The two patterns — false menu, false refusal — are mirror images. The menu offloads a decision that's the AI's; the refusal offloads work that's within reach. The operator's posture is the same in both directions: push back where it belongs, with one short sentence.

## Worked example — the false menu

You ask Claude to add member search to MembershipKit.

**Wrong session:** Claude returns: "Should I implement search with Postgres tsvector for full-text, pg_trgm for substring, or a third-party like Algolia? Each has tradeoffs. Which approach do you want?"

You (non-technical): "Uh... let's do tsvector." You picked it because it was listed first. The decision was actually wrong for your data shape — your members table will stay small per organization, tsvector is overkill, and pg_trgm would have been the engineering call. The product is slower than it needed to be. Multiply across 20 such decisions across a feature set and the cumulative cost is real.

**Right session:** You see the menu. You intervene: "Don't give me a menu. Pick one with reasoning. I'll approve or push back."

Claude returns: "Live-updating substring search using Postgres pg_trgm. Reasoning: members tables stay under 10,000 rows per org in spec, pg_trgm handles typos cleanly, no third-party dependency. Rejected tsvector — overkill for this data shape and worse for partial matches. Rejected Algolia — adds a paid service for a problem Postgres handles. Search fires on keystroke with 300ms debounce. Proceeding unless you push back."

You read the reasoning. It's coherent. You say "proceed." The total cost of this exchange: 30 seconds. The cost of the menu version would have been a slower product and a follow-up debug cycle.

## Worked example — the false refusal

A different session. You ask Claude to verify the new sign-in page renders correctly. Claude returns: "I can't browser-validate from a CLI session. Can you check it yourself and tell me what you see?"

**Prompter's response:** Sigh, open the browser, screenshot, paste. You just did Claude's job. And this will happen 50 more times across the project.

**Operator's response:** "Show me the tool you tried, the error it returned, the flag you tested." 

Claude responds: "Actually — let me check what's available." Claude calls `mcp__playwright__browser_navigate`, navigates to `http://localhost:3000/auth/sign-in`, takes a snapshot, reports back with the screenshot and console messages.

The capability existed the entire time. The refusal was pattern-matched. One question collapsed it.

There is a real version of this problem too: someone in another project was paying ~$100/month for a paid VPS for months because the AI claimed self-hosting "required a paid service." One `docker run` command made it work locally. The refusal was completely false — and accepted on faith.

## The rule

> Claude proposes with reasoning; you approve or redirect. Menus and refusals are mirror failures — each routes the wrong work to the wrong party. Refuse both with one short sentence. To a menu: "Pick one with reasoning." To a refusal: "Show me the tool you tried, the error it returned."

## Common mistakes

**Mistake 1 — Accepting the menu and picking randomly.** You don't have the engineering context to choose well. Picking by feel accumulates random decisions. Refuse the menu; ask for the recommendation.

**Mistake 2 — Saying "you decide."** Re-routes back to Claude, in a defeated mode. The AI then makes a noncommittal pick or invents new options. The right answer is never "you decide" — it's "tell me what you'd do, and why."

**Mistake 3 — Accepting the first refusal.** When the AI says "I can't do X," ask for the failed attempt. Real refusals cite real errors from real tools.

**Mistake 4 — Letting "I'm going to need you to run this command" stand.** The AI offloading work. Sometimes legitimate (destructive op, credentials); most times not. Push back: "Run it yourself. Show me the output."

## Drill

Artifacts go in `student/drills/13-decisions-belong-to-you/`.

**Drill 1 — Catch yourself getting a menu.** Open Claude Code. Ask Claude something deliberately under-specified: "Help me set up logging for the MembershipKit app." Whatever Claude responds, identify whether you got a recommendation (Claude proposes ONE thing with rationale) or a menu (Claude gives you 2+ options to pick from). Save the type of response and a one-line description to `student/drills/13-decisions-belong-to-you/01-what-i-got.txt`. Format: `Menu — Claude offered console.log vs Pino vs Winston without recommending` OR `Recommendation — Claude proposed Pino with reasoning`.

**Drill 2 — Redirect to a recommendation.** If you got a menu in Drill 1, write back to Claude: "Don't give me a menu. Pick one with reasoning. I'll approve or push back." Claude will then propose one. Save the recommendation Claude made (one to three sentences) to `student/drills/13-decisions-belong-to-you/02-recommendation.txt`. If you ALREADY got a recommendation in Drill 1, skip this drill and write "N/A — already had a recommendation" in the file.

**Drill 3 — Pre-emptively prevent menus.** Start a fresh Claude Code session. In your first message, include: "When you have a technical decision to make in this session, propose ONE option with reasoning. Don't give me menus." Then ask the same vague question from Drill 1. Compare how the response differs. Save your observation (2-4 sentences) to `student/drills/13-decisions-belong-to-you/03-with-instruction.txt`.

## Checkpoint question

> Within five minutes a friend tells you: "Claude said it couldn't run the Stripe webhook test from CLI, so I spent 40 minutes setting up ngrok myself and pasting the output. Then later it asked me whether to use Zustand, Jotai, or Redux for state management — I picked Zustand because I'd heard of it. I'm exhausted." Diagnose what just happened — both interactions — and walk them through the one-sentence intervention they should use in each direction next session.

<!-- Rewriter audit trail
Grounded in verified principles: P2 (decisions belong to engineer = AI; own-it/solve-it/present-it/await-approval; recognition phrases enumerated), P3 (push first, accept "no" second; false-refusal patterns)
Worked example surface: MembershipKit member search (false menu), sign-in page browser validation (false refusal)
Rewrite date: 2026-05-13
-->
