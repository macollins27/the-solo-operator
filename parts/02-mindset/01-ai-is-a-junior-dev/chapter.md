# Chapter 9 — AI is a Junior Dev

## Learning objective

The student can describe Claude as a junior team member (not an oracle, peer, or search engine), and predict what kind of work a junior team member produces well, badly, or not at all without supervision.

## Prerequisites

- Completed: Chapter 8 — Your first project: a working app on your machine
- Concepts: chat-vs-agent, tool-call-vs-text-summary-truth-hierarchy

## Core concept

The mental model you hold of Claude determines what you get. The right model is load-bearing, and it is not the one most people pick.

**The wrong models: oracle, peer, search engine.** An oracle is asked vague questions and is expected to know. A peer collaborates as an equal and pushes back when you're wrong. A search engine returns a deterministic result. None match what's happening. Claude isn't retrieving — it's generating. Claude doesn't push back like a peer; it tends to comply. Claude doesn't know your project — it guesses what you probably mean, plausibly and sometimes wrongly. These models keep you tuning your prompt as if a magic phrase will fix a context-and-supervision problem.

**The right model: Claude is the engineer; you are the operator.** You are not co-engineering. You are not Claude's peer or customer. You are Claude's operator. The operator's job is to **specify the outcome, push the boundary of what the AI is willing to attempt, evaluate the work product against the artifact, and refuse refusals**. Every technical call between outcomes belongs to Claude. When Claude asks "would you like httpOnly cookies or bearer tokens for the mobile session?" the right answer: "That's an engineering call. Make it. Tell me your reasoning. I'll approve or push back."

What follows from this inversion:

**You don't pick from menus.** A technical menu offered to a non-technical operator is a routed decision — Claude has the context to choose well; you don't. Picking randomly accumulates bad decisions. The intervention: "Don't give me a menu. Pick one with reasoning."

**You don't accept the first refusal.** When Claude says "I can't browser-validate from CLI," "this requires a paid service," "I don't have access" — the refusal is almost always wrong. The tool exists; the AI is pattern-matching "AIs can't do X" framing. Ask for proof: "Show me the tool you tried, the error it returned."

**You raise the floor with structure.** A fresh session is unreliable by default. A session with a tight `CLAUDE.md`, a hook catching known failures, a skill bundling a known-good workflow, and an MCP server exposing project data is reliable by structure.

**You verify against the artifact.** Tool output is truth. Chat narration is hint. The Bash output, the file diff, the screenshot — those are the work. Chapter 12 names this discipline; you start practicing it here.

In practice: when something hard or ambiguous comes up, you do NOT carry the technical weight. You push. You ask for the recommendation. You evaluate the reasoning. You approve or redirect. The system gets built by Claude doing the engineering and you keeping Claude from quitting on you.

## Worked example

You ask Claude to add member subscription billing to MembershipKit. Claude reads the schema, opens the existing payment files, and responds:

> "Two questions before I start. First — should subscription renewals charge automatically via Stripe webhooks, or should we send a manual renewal link? Second — for past-due accounts, do you want a 7-day grace period or immediate suspension?"

**Prompter's response:** "Uh, I don't know. What do you think? Let's do automatic charges and 7-day grace. Sounds reasonable."

What just happened: Claude routed two technical-product calls to a non-engineer. The prompter picked, partly randomly, with no real evaluation. Multiply by 30 such decisions across the feature and the cumulative drift is large. Operator overhead silently subverted the contract.

**Operator's response:** "Those are engineering calls. Make them. For each, tell me the call, the reasoning, and the main alternative you rejected. I'll approve or push back."

Claude returns:

> "Automatic charges via Stripe webhooks. Reasoning: industry default, matches the rest of MembershipKit's Stripe integration, no extra UI surface to maintain, recoverable from idempotency keys on retry. Rejected alternative: manual renewal — better for organizations with unusual billing cadences, but you have none of those in spec yet.
>
> 7-day grace period. Reasoning: matches Stripe's default `past_due` behavior; gives the admin time to follow up before suspension feels punitive. Rejected alternative: immediate suspension — cleaner state machine but creates support tickets when cards expire silently."

The operator reads the reasoning. The reasoning is sound. The operator says "proceed." Claude builds.

Same task. Same model. Different management. The operator never carried a technical weight they couldn't carry. Claude carried it — because Claude is the engineer.

## The rule

> The AI is the engineer; you are the operator. You specify the outcome, you push the boundary of what the AI is willing to attempt, and you evaluate the work against the artifact. Every technical call between those outcomes belongs to the AI. When the AI offers you a menu, refuse it — ask for the recommendation with reasoning, then approve or redirect.

## Common mistakes

**Mistake 1 — Accepting the menu.** The AI offers two or three options. Recognition phrase: "Which would you prefer?" or "your call." The intervention: "Pick one with reasoning. I'll approve or push back."

**Mistake 2 — Accepting the first refusal.** "I can't browser-validate from CLI," "this requires a paid VPS." The tool usually exists. Intervention: "Show me the tool you tried, the error it returned, the flag you tested."

**Mistake 3 — Treating Claude's confidence as evidence.** "I've fixed the bug." "Tests pass." Confident tone is not evidence. The Bash output, Git diff, and screenshot are. Look for 30 seconds before believing.

**Mistake 4 — "What do you want me to do?"** The AI's most frequent abdication phrase. Variants: "How would you like to proceed?", "your call." Intervention: "Tell me what you'd do, and why. I'll approve or push back."

## Drill

You'll observe the difference management makes. Artifacts go in `student/drills/09-ai-is-a-junior-dev/`.

**Drill 1 — Vague vs specific.** Open Claude Code in your fork. Ask the vague version of a task: "Add a hello-world API route to my MembershipKit app." Watch Claude work. After it finishes, ask Claude to list 3 assumptions it made that you didn't tell it. Save those 3 assumptions to `student/drills/09-ai-is-a-junior-dev/01-vague-assumptions.txt`.

**Drill 2 — Specific re-do.** Revert Claude's change (`git restore .`). Ask Claude the specific version: "Add a GET API route at `/api/hello` in `student/canonical-project/` that returns `{ message: 'hello' }` as JSON. Don't add any other files or modify any other files. Show me the diff before applying it." Note how the interaction differs. Save your observation (3-5 sentences) to `student/drills/09-ai-is-a-junior-dev/02-specific-interaction.txt`.

**Drill 3 — The junior-dev framing.** Write a short list — 4-6 lines — to `student/drills/09-ai-is-a-junior-dev/03-things-id-tell-a-new-hire.txt`. Each line: something you'd tell a brand-new engineer joining your team on their first day. (Examples: "Read the README first." "Never push to main directly." "Always ask before you delete something.") These are the same things you should be telling Claude — and they're what `CLAUDE.md` is for in Part 3.

## Checkpoint question

> You ask Claude to add notifications to MembershipKit. Claude responds: "I can do this either as email-only, in-app-only, or both. Each has tradeoffs — email reaches inactive members, in-app is cheaper, both is more work. Which would you like?" You feel a small impulse to pick "both" because it sounds the most thorough. Before you answer Claude, walk through: what's wrong with the way Claude just framed this, what's the right response from you, and what would the correct response from Claude look like in your reply's wake?

<!-- Rewriter audit trail
Grounded in verified principles: P1 (operator built the system by pushing capabilities, not by writing it themselves), P2 (decisions belong to engineer = AI; own-it/solve-it/present-it/await-approval), P3 (push first, accept "no" second; the false-refusal patterns)
Worked example surface: MembershipKit subscription billing
Rewrite date: 2026-05-13
-->
