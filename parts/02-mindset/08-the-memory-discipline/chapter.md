# Chapter 16 — The Memory Discipline

## Learning objective

The student can recognize when they've been bitten by a specific AI failure mode, write a durable rule from that incident in a reusable shape, and save it to their own feedback corpus where future sessions can re-read it.

## Prerequisites

- Completed: Chapter 15 — Root Cause > Bandaid
- Concepts: operator-as-manager, root-cause-vs-bandaid

## Core concept

Every time Claude bites you, you have a choice:

1. **Fix the specific instance, move on, hope it doesn't recur.**
2. **Write the rule. Save it. Apply it forward.**

Option 1 is the default. It's what almost everyone does. The cost: the same kind of mistake recurs in different surface forms — and you don't notice the pattern because each instance feels like a new problem. After three months you have 30 small recurring issues you keep solving for the first time.

Option 2 is the moat. Each incident becomes a durable rule that prevents the entire class of failures going forward. You build a corpus — your `feedback/` folder, your `CLAUDE.md`, your hooks. The corpus IS the moat. It's the thing no one else can copy because it's authored from your specific mistakes. After three months you have 30 rules and an AI that doesn't make those mistakes anymore.

The discipline is small per incident, huge over time. Three to five sentences per rule. The shape that works:

> **What happened.** One-sentence description of the failure.
>
> **The mechanism.** One or two sentences naming WHY it happened — the cause, not the symptom.
>
> **The rule.** One sentence in the form "When X, do Y. Never Z." — actionable and memorizable.
>
> **Evidence.** One reference to where this happened — a date, a session, a commit, a file path.

That's it. Four lines. Save it as a `feedback_<short-name>.md` file in your fork's `student/feedback/` folder. Reference it from your `CLAUDE.md` (Part 3). Now every future Claude Code session in your project sees the rule.

A worked example of the durable shape:

```
# feedback_no_silent_bandaids.md

What happened: Claude wrapped the failing payment function in a try/catch
that returned false on error, silently hiding a database connection bug
for 3 days.

Mechanism: Defensive code masks the cause. A try/catch with no specific
error type and no logging removes the only signal that something is wrong.

Rule: When Claude proposes a try/catch, demand the specific error type
being caught and a log statement. If Claude can't name the error type,
the try/catch is a bandaid; refuse it.

Evidence: 2025-03-14, session adding /api/pay endpoint; commit 3a7f2c1
where I caught the bandaid; commit 5b9e441 fixing the actual db connection.
```

Notice what's in this file: zero generalities, all specifics. Notice what's NOT in this file: a long essay about how try/catches are bad in general. Operators write incident-specific rules; pundits write essays.

Some rules go in different places over time:

- **First time** something happens, you write a feedback file. Specific, dated.
- **Second time** a similar thing happens, you write a SECOND feedback file. Different incident, same family.
- **Third time**, you notice the pattern. You consolidate the two feedback files into one rule in your `CLAUDE.md` ("Never use try/catch without a specific error type and a log statement"). The two feedback files get archived but stay readable.
- **Fourth time**, the rule is in CLAUDE.md, Claude reads it at session start, the failure never happens again — unless something subtle differs. If it does, you write a new feedback file noting the subtle difference, and so on.

This is how Maxwell's hero-level system was built. Not from a master plan. From 30+ incidents, each producing a rule, accumulating into a corpus over 60 days. Your corpus starts here, with one rule.

What KILLS the discipline: not writing the rule down. You think "oh, that won't happen again, I'll remember." You don't remember. Three weeks later the same family of bug bites you, and you debug from scratch.

What KEEPS the discipline: writing the rule down BEFORE you fix the bug, in the heat of the moment when you remember the mechanism most clearly.

## Worked example

You're using Claude Code to add an event-creation form to MembershipKit. Claude implements the form, you ship it. A week later a community admin reports that creating an event with a date in the past silently succeeds — there's no validation. You spec'd "events must be in the future" but Claude omitted it.

The fix is easy (add date validation). The DURABLE move is the rule:

```
# feedback_spec_completeness.md

What happened: Claude implemented the event-create form but skipped the
"events must be in the future" validation from my spec. I missed it in
review. A user created an event in the past.

Mechanism: My review compared the file Claude wrote to my own memory of
the spec, not to the spec document. The omitted check wasn't visible
without a line-by-line spec-to-code comparison.

Rule: When reviewing AI-implemented features, compare the spec
DOCUMENT (file in repo) to the code line by line. Don't trust memory of
the spec. If the feature has 5 spec lines, the review has 5 confirmations.

Evidence: 2025-04-02, event-create feature; commit 8c4d1ae shipped the
bug; commit 9e2f7b1 added the missing validation.
```

Now this rule lives in `student/feedback/`. Your next `CLAUDE.md` update can reference it. Every future feature review you do follows the rule because you wrote it down when it was raw.

Without the rule, you'd hit the same family of bug (different spec line, different feature) in a month and have to figure out the lesson again.

## The rule

> Every incident is a rule's first draft. Three sentences per rule, saved to your feedback folder, with the mechanism named. The corpus you build from incidents is the moat — nobody else has your specific rules because nobody else got bitten in your specific way. Write them down.

## Common mistakes

**Mistake 1 — "I'll remember."** You won't. Memory degrades; the rule doesn't. Three weeks later the same bug shape returns and you debug from scratch. The 60 seconds to write the rule saves 60 minutes later.

**Mistake 2 — Writing essays instead of incidents.** A 2,000-word reflection on "AI failure modes I've observed" is a blog post, not a rule. Operators write 3-5 sentences per incident, with specifics. Brevity is what makes the corpus usable by future AI agents.

**Mistake 3 — Storing rules where no one (including Claude) reads them.** A rule in a Google Doc is invisible to Claude Code. A rule in `student/feedback/some-bite.md` referenced from `CLAUDE.md` is visible at every session start. Put the rule where the tool can see it.

## Drill

Artifacts go in `student/drills/16-the-memory-discipline/` AND a new permanent file in `student/feedback/`.

**Drill 1 — Recall a recent bite.** Think back to something Claude (or any AI) did wrong recently. Could be from earlier in this course, could be from any other AI interaction you've had. Write a one-paragraph description of the incident at `student/drills/16-the-memory-discipline/01-the-incident.txt`. Don't worry about the rule shape yet — just describe what happened in plain English.

**Drill 2 — Write the durable rule.** Now transform that incident into the four-line durable shape: What happened, Mechanism, Rule, Evidence. Save it to a real permanent file at `student/feedback/feedback_<your-slug>.md` (pick a short slug describing the failure class — e.g. `feedback_silent_workaround.md`). This file is now part of your moat.

**Drill 3 — Link from CLAUDE.md.** You don't have a CLAUDE.md in your fork yet (that's the next part). For now, create a placeholder at `student/feedback/INDEX.md` listing every feedback file you author with a one-line description. Add a line for the feedback file you just wrote. This is how you'll later wire the corpus into CLAUDE.md.

## Checkpoint question

> You've authored your first feedback file. A week later Claude does something stupid that vaguely resembles what your feedback file describes — same family, different surface. What do you do: write a brand new feedback file, edit the existing one, or consolidate? Answer in 2-3 sentences, and name the deciding factor.
