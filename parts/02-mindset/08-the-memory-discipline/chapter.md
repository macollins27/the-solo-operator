# Chapter 16 — The Memory Discipline

## Learning objective

The student can recognize when they've been bitten by a specific AI failure mode, write a durable rule from that incident in a reusable shape, and save it to their own feedback corpus where future sessions can re-read it.

## Prerequisites

- Completed: Chapter 15 — Root Cause > Bandaid
- Concepts: operator-as-manager, root-cause-vs-bandaid

## Core concept

When the operator corrects the AI, the correction is almost never a single-issue resolution. It's a **decision framework** that pre-empts a class of future questions. Most operators apply the answer and miss the framework — and the same family of failure recurs in a different surface form.

Example: the operator says "no time estimates." The AI strips estimates from the current plan. Five turns later the AI cites "~3-4 hours" in a different artifact because "that's a different document." The rule was about the reasoning, not the document. The framework wasn't extracted.

The discipline, both sides:

- **AI side:** when the operator answers any question, ask "what general principle does this encode? what classes of future questions does it pre-empt?" Save the principle as a durable rule on disk.
- **Operator side:** every incident becomes a rule. Four lines, saved to `student/feedback/feedback_<slug>.md`:

> **What happened.** One sentence — the failure.
> **The mechanism.** One or two sentences — the cause, not the symptom.
> **The rule.** One sentence in the form "When X, do Y. Never Z."
> **Evidence.** Date, commit, session reference.

A worked example of the shape:

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

Evidence: 2025-03-14, /api/pay endpoint session; commit 3a7f2c1.
```

Zero generalities. All specifics. No essay; an incident with a rule extracted.

**The promotion path.** Rules don't live in one place forever:

- **First incident:** feedback file. Specific, dated, low ceremony.
- **Second similar incident:** another feedback file. Same family, different surface.
- **Third+:** you've found a pattern. Consolidate into a `CLAUDE.md` rule that fires at every session start.
- **Mechanically detectable:** promote again — to a hook (Part 3). A hook fires at the tool boundary; it cannot be rationalized around.

Most rules stop at the feedback file. Some climb to CLAUDE.md. The few that climb to hooks pay back forever — every future session, mechanically. The path from feedback file to hook is the maturation track of every load-bearing rule in your project.

**The compaction trap.** When a long session approaches the context limit, the system auto-compacts — replaces older context with a generated summary optimized to "keep the agent functional," not to preserve corrections, decision reasons, deleted files. Within three messages post-compaction the AI commonly re-invokes a tool that was deleted earlier in the session, or repeats a mistake it had already been corrected on.

The repair: **write the memory file BEFORE compaction.** Save an artifact to disk covering files created/modified/deleted with reasons, current task state, architectural decisions with WHY, open questions. Commit. A fresh session reads the file and inherits the corrections; the auto-summary alone does not.

What kills the discipline: thinking "I'll remember." You won't. Three weeks later the same bug shape returns and you debug from scratch. Write the rule when it's fresh.

## Worked example

You catch Claude writing "(~30 min)" into a plan section in MembershipKit. You correct: "Strip time estimates from this plan."

**Surface-fix interpretation.** Claude edits the plan, removes the estimate. You move on. Twenty turns later Claude writes a session-state file that includes "since this morning I've completed Phase 1." Different surface, same failure — wall-clock anchoring. Claude treats it as fresh because "session-state isn't a plan." The framework was never extracted.

**Framework-extracted interpretation.** When you corrected the first time, you also wrote:

```
# feedback_no_time_framing.md

What happened: Claude wrote "(~30 min)" into a plan section. Pattern
appeared again 20 turns later as "since this morning" in a session-state.

Mechanism: The training-data prior says agents produce estimates as
helpful project management. Both inline durations AND retrospective
wall-clock framing trigger the same prior. The pattern is about reasoning,
not about which document.

Rule: Strip every wall-clock and duration reference from forward-looking
artifacts — plans, dispatches, session-states, reports. Wall-clock has
exactly one legitimate use: RETROSPECTIVE comparison of a finished
subagent against prior runs.

Evidence: 2026-03-14, MembershipKit infrastructure planning session.
```

Your CLAUDE.md references this file. The next session reads it at start and pre-empts every form of the failure — not just the one you saw.

**Variant: memory before compaction.** You're 90 minutes into a session adding the dues-renewal job. You've created three migrations, deleted two, decided between Postgres NOTIFY versus polling cron (chose polling). The auto-compaction message appears. The system will summarize older context — keeping the agent functional but losing the deletion reasons and the NOTIFY-vs-polling rationale.

The repair: before compaction triggers, ask Claude: "Write a session-state file at `student/state/session-2026-03-14.md` covering files kept, files deleted with reason, the NOTIFY-vs-polling decision and why I chose polling, current task state, and open questions. Commit immediately." Compaction runs against the now-redundant context. The next session reads the state file fresh and inherits the decisions cleanly.

## The rule

> Every correction is a framework, not an answer. Write the framework as a four-line rule and save it. The corpus is the moat. Before any long session approaches the context limit, write the state file BEFORE auto-compaction — compaction is optimized to keep the agent functional, not to preserve corrections.

## Common mistakes

**Mistake 1 — Applying corrections as one-offs instead of frameworks.** The operator says "no time estimates here." The AI strips them from THIS plan and re-introduces them in the next artifact. Every correction should be saved as a feedback file with the general principle named, then re-read in subsequent sessions.

**Mistake 2 — Trusting auto-compaction summaries.** A long session compacts. Three messages later the AI re-invokes a deleted tool, or repeats a mistake it had been corrected on. The compaction lost the corrections. Write the memory file to disk BEFORE compaction.

**Mistake 3 — Writing essays instead of incidents.** A 2,000-word reflection on "AI failure modes" is a blog post. A four-line incident note IS a rule. Brevity makes the corpus usable — by you, and by AI sessions reading it at start.

**Mistake 4 — Storing rules where Claude can't see them.** A rule in your notes app is invisible to a session. A rule in `student/feedback/some-bite.md` referenced from CLAUDE.md is visible at every session start. Put the rule where the tool reads from.

**Mistake 5 — Failing to promote up the ladder.** Feedback file → CLAUDE.md → hook. Most rules stop at feedback file; the few that climb to hook pay back forever.

## Drill

Artifacts go in `student/drills/16-the-memory-discipline/` AND a new permanent file in `student/feedback/`.

**Drill 1 — Recall a recent bite.** Think back to something Claude (or any AI) did wrong recently. Could be from earlier in this course, could be from any other AI interaction you've had. Write a one-paragraph description of the incident at `student/drills/16-the-memory-discipline/01-the-incident.txt`. Don't worry about the rule shape yet — just describe what happened in plain English.

**Drill 2 — Write the durable rule.** Now transform that incident into the four-line durable shape: What happened, Mechanism, Rule, Evidence. Save it to a real permanent file at `student/feedback/feedback_<your-slug>.md` (pick a short slug describing the failure class — e.g. `feedback_silent_workaround.md`). This file is now part of your moat.

**Drill 3 — Link from CLAUDE.md.** You don't have a CLAUDE.md in your fork yet (that's the next part). For now, create a placeholder at `student/feedback/INDEX.md` listing every feedback file you author with a one-line description. Add a line for the feedback file you just wrote. This is how you'll later wire the corpus into CLAUDE.md.

## Checkpoint question

> You corrected Claude on Tuesday: "Don't ask which library to use for X; pick one with reasoning." On Thursday Claude proposes a recommendation correctly. On Friday it asks "Should I use library A or library B for Y?" — a different question, same shape. Diagnose what failed (was it the framework extraction or the memory across sessions), and walk through what you should have done differently between Tuesday and Friday.

<!-- Rewriter audit trail
Grounded in verified principles: P10 (frameworks outlive corrections; extract the rule, not the answer), P57 (memory before compaction; never trust post-compaction summaries), P21 (mechanical enforcement promotion path — feedback file → CLAUDE.md → hook)
Worked example surface: MembershipKit time-estimate correction, dues-renewal session compaction
Rewrite date: 2026-05-13
-->
