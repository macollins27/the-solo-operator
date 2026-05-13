# Chapter 9 — AI is a Junior Dev

## Learning objective

The student can describe Claude as a junior team member (not an oracle, peer, or search engine), and predict what kind of work a junior team member produces well, badly, or not at all without supervision.

## Prerequisites

- Completed: Chapter 8 — Your first project: a working app on your machine
- Concepts: chat-vs-agent, tool-call-vs-text-summary-truth-hierarchy

## Core concept

How you THINK about Claude determines what you GET from Claude. The mental model is load-bearing. Most people pick a wrong one and stay stuck there for months.

Three wrong mental models, all common:

**Wrong model 1: Claude is an oracle.** You ask, Claude knows. Asking a vague question and getting a vague answer feels like a query that needs better phrasing. People keep tuning their prompt as if the answer is hidden behind the right magic words. But Claude doesn't know your project unless you've told it. It guesses what you probably mean. The guesses are usually plausible. Sometimes they're wrong. The fix is not better prompts — it's better context.

**Wrong model 2: Claude is a peer.** You're collaborating; Claude is another engineer. This sounds respectful but it's wrong. A peer pushes back when you're wrong. Claude often doesn't. A peer notices something out of scope you missed. Claude generally won't. A peer carries the weight of caring about your project's outcome. Claude carries no weight. Treating Claude as a peer leaves you with no manager — and the work product reflects it.

**Wrong model 3: Claude is a search engine.** You type a question, you get an answer. But Claude isn't retrieving a result — it's generating one. The same question can produce different answers in different sessions. The answer is shaped by what you said earlier, what file you happen to be in, what's in the system prompt. Search engines are deterministic and external; Claude is probabilistic and contextual. Treating it as search makes you stop verifying.

The right model: **Claude is a junior team member.** A fast, smart, never-tired, never-bored junior. Better at some things than you are (typing, syntax, knowing 17 libraries' APIs). Worse at others (judgment calls, knowing what your customer wants, knowing when to STOP and ask).

What follows from this model:

**You manage.** You set the standards (`CLAUDE.md`). You define the workflow (skills). You enforce the rules (hooks). You decide what's in scope. You decide what "done" means. You verify the work before it ships. A junior without a manager produces junior-quality work; a junior with a strong manager produces senior-quality work. Same with Claude.

**You write specs, not vibes.** "Build me a sign-up form" gives Claude license to invent. "Add a sign-up form with email + password (8+ chars), redirect to /onboarding on success, show inline error on failure" gives Claude a target. The first prompt is a wish; the second is a spec. Operators write the second.

**You catch mistakes early.** A junior who runs unchecked for two weeks does two weeks of work that may need to be redone. Catch the mistake on day one and you've saved 13 days. With Claude, "day one" is "this turn." The verification cost is small; the regret cost is huge.

**You raise the floor with structure.** A new junior is unreliable by default. A junior with a tight team operating manual, a code style guide, a list of patterns to use, and a senior pair-reviewing every PR is reliable by structure. Same junior, different floor. Most of the rest of this course is about how to build that structure for Claude.

What the junior is GREAT at: typing, syntax, looking up APIs you don't remember, generating boilerplate, refactoring within a file, explaining unfamiliar code, writing tests for the happy path. Use Claude for these freely.

What the junior is BAD at without supervision: architectural choices, security tradeoffs, "should we even build this," subtle business-logic decisions, knowing when to stop and ask, distinguishing "this works" from "this is right." Verify Claude on these heavily — or don't delegate them at all.

What the junior CANNOT do: care about your project's outcome the way you do. Hold the constraints in your head that you haven't written down. Notice when "I've worked around it" hides a deeper problem. You are the only one with those capabilities. They're yours.

## Worked example

Two operators want to add a "forgot password" link to their app.

**Operator A** asks: "Add a forgot password feature to my app." Claude reads some files, writes a new route, a form, an email-sending function, a token table, a reset endpoint. It looks reasonable. The operator skims the diff, says "looks good," ships. Two weeks later they find: the reset tokens never expire, the email template hardcodes a domain the operator doesn't own, the form's CSRF protection was forgotten. Each is a bug a junior might miss.

**Operator B** asks the same starting question. Then before letting Claude write code: "Before you implement, list the security-relevant choices you're making: token expiration, email content, CSRF, rate limiting, account-enumeration prevention. For each, propose your default and ask me." Claude writes the list. Operator B confirms or corrects each. Then Claude implements. The result has tokens that expire in 15 minutes, an email that doesn't hardcode anything, CSRF protection, rate limiting, and account-enumeration prevention (same message whether the email exists or not).

Same junior. Same task. Different management. Operator B's product is shippable; Operator A is doing two weeks of debugging.

## The rule

> Claude is a junior team member, not an oracle, peer, or search engine. You manage; you verify; you set the structure that makes junior work reliable. Skip the management and you get junior work; do the management well and you get senior work from a junior at junior speed.

## Common mistakes

**Mistake 1 — Assuming Claude knows what you mean.** Your project has 14 conventions Claude doesn't know about because you haven't written them down. Claude makes plausible guesses. They're often wrong in small ways that compound. The fix is `CLAUDE.md` (Part 3) — but the mindset comes first: assume Claude knows NOTHING about your project until you've told it explicitly.

**Mistake 2 — Skipping the "before you implement, list the choices" step.** Juniors are happiest implementing — they want to type code. They're worst at the choice-listing step. Force the listing. "Before you change anything, tell me what assumptions you're about to make." Claude will say things like "I'm assuming you want to use cookies for auth" — and you'll say "no, use JWT" — and the next two hours of work just got saved.

**Mistake 3 — Treating Claude's confidence as evidence.** Claude's text reply often sounds confident. "I've fixed the bug." "This will handle all the edge cases." "The tests pass." Confidence is not evidence. The tool calls are evidence. The Git diff is evidence. The test output is evidence. Operators verify against evidence, not against tone.

## Drill

You'll observe the difference management makes. Artifacts go in `student/drills/09-ai-is-a-junior-dev/`.

**Drill 1 — Vague vs specific.** Open Claude Code in your fork. Ask the vague version of a task: "Add a hello-world API route to my MembershipKit app." Watch Claude work. After it finishes, ask Claude to list 3 assumptions it made that you didn't tell it. Save those 3 assumptions to `student/drills/09-ai-is-a-junior-dev/01-vague-assumptions.txt`.

**Drill 2 — Specific re-do.** Revert Claude's change (`git restore .`). Ask Claude the specific version: "Add a GET API route at `/api/hello` in `student/canonical-project/` that returns `{ message: 'hello' }` as JSON. Don't add any other files or modify any other files. Show me the diff before applying it." Note how the interaction differs. Save your observation (3-5 sentences) to `student/drills/09-ai-is-a-junior-dev/02-specific-interaction.txt`.

**Drill 3 — The junior-dev framing.** Write a short list — 4-6 lines — to `student/drills/09-ai-is-a-junior-dev/03-things-id-tell-a-new-hire.txt`. Each line: something you'd tell a brand-new engineer joining your team on their first day. (Examples: "Read the README first." "Never push to main directly." "Always ask before you delete something.") These are the same things you should be telling Claude — and they're what `CLAUDE.md` is for in Part 3.

## Checkpoint question

> You're delegating "set up the database schema for MembershipKit" to a brand-new junior engineer on their first day. You're delegating the same task to Claude. What are two things you'd do for the junior that you would NOT have thought to do for Claude before this chapter — and which of them is actually MORE important to do with Claude than with the junior?
