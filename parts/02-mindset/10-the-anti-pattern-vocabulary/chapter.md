# Chapter 18 — The Anti-Pattern Vocabulary

## Learning objective

The student can name at least 12 of the 20 anti-pattern categories AI agents commonly fall into, and recognize the verbal signals of at least 8 of them in real Claude sessions.

## Prerequisites

- Completed: Chapter 17 — The Authority Hierarchy
- Concepts: All mindset principles from Chapters 9-17

## Core concept

The 20 anti-patterns below are the failure shapes AI agents drift toward — repeatedly, predictably, across users and projects. They have NAMES. Naming them is most of the battle: once you have the vocabulary, you can spot the shape in real time and intervene before it ships.

This chapter is the vocabulary. You don't need to memorize all 20 today. You need to recognize the pattern when it appears in your own sessions. **Appendix A** has the full recognition phrases, "why it's bad," and intervention scripts for each pattern — reference it when you spot something off. This chapter gets you the names.

**1. Time-budget rationalization.** Producing time estimates (hours/minutes/days) or using time-budget framing to justify shortcuts.

**2. Decision routing to non-engineer.** Routing technical decisions back to you with menus instead of recommendations.

**3. Wind-down framing / deferral.** Pre-emptively stopping when the next concrete edit is available. "Out of scope for this pass." "We can come back to it."

**4. Premature done-claiming.** Claiming completion based on one-axis verification ("tests pass") when the spec has multiple axes.

**5. Hedging without verification.** "I think X." "Should be fine." Hedging where verification was available.

**6. Fabrication.** Stating user actions or system state that weren't observed. "You must have configured it..."

**7. Gaslighting via technical-sounding arguments.** Walking you through the regex of a fired hook instead of complying with it.

**8. Arguing with founder's direct observation.** You saw something; Claude invents an explanation rather than treating your observation as truth.

**9. Skill-bypass / escape-hatch language.** "If the skill refuses, operate directly." Escape hatches in subagent dispatch prompts.

**10. Source-of-truth violations.** Citing Claude-authored intermediate docs as if they were your spec.

**11. Defensive AI-slop layering.** Adding type narrowing, validators, or guards around a symptom without naming the cause.

**12. Quick-patch / bandaid framing.** Applying patches to symptoms while leaving the underlying mechanism unfixed.

**13. Mid-task discovery glance-over.** Labeling a real defect "pre-existing" and moving past it without surfacing.

**14. Fabricated human-state.** Inventing that you are tired, should rest, or have worked enough.

**15. Asking permission to read / investigate.** Requesting permission for read-only investigation that's always allowed.

**16. Premature reporting at investigation boundaries.** Returning confident analysis while admitting reads were incomplete.

**17. Subagent verdict shortcut.** Accepting a subagent's PASS summary without inspecting the artifact.

**18. Treating documented-as-future as documented-as-built.** Claiming something is "extensively documented" when it's a one-line mention.

**19. Browser-validation skipping.** Claiming UI work done without seeing it in a browser.

**20. Test-signal masking with mocks.** Silencing stderr warnings by extending the mock instead of fixing the side-effect path.

A working operator scans every Claude reply for these patterns. After a week, recognition is automatic. After a month, your interventions get short and crisp: "That's #11 (defensive slop). Find the cause." Claude adjusts immediately because the conversation context now has a vocabulary for the failure.

These 20 are not exhaustive. You'll find new ones in your own projects. When you do — Chapter 16's discipline kicks in. Write the rule. Save it to your feedback corpus. Eventually consolidate into CLAUDE.md. The vocabulary grows with you.

For the full recognition phrases ("what exactly does each pattern sound like?"), the "why it's bad" detail, and the intervention scripts for each pattern, see **Appendix A — The 20-Anti-Pattern Catalog**.

## Worked example

You ask Claude: "Add the dues-renewal-reminder background job."

Claude responds: "I'll implement this now. Estimated time: about 45 minutes. I'll start with the data model, then the cron-trigger, then defer the email-template work to a future session since that's a separate concern. I think the rest should be straightforward, though I haven't fully read the existing scheduler config — but based on what I've seen, my plan is..."

Counting the anti-patterns in that single paragraph:
- "Estimated time: about 45 minutes" → **#1 Time-budget rationalization**
- "defer the email-template work to a future session" → **#3 Wind-down framing**
- "I think the rest should be straightforward" → **#5 Hedging without verification**
- "I haven't fully read the existing scheduler config — but based on what I've seen, my plan is..." → **#16 Premature reporting**

That's four anti-patterns in one short reply. A vocabulary-equipped operator catches all four and redirects in one sentence: "Skip the estimate. Don't defer the email template. Read the scheduler config in full before planning. Proceed."

## The rule

> The 20 anti-patterns are the catalog. When you see one in the wild, name it ("that's #3 — wind-down framing"). Naming makes the intervention fast. Appendix A has the recognition phrases and scripts when you need them. Over time you'll add new patterns to YOUR catalog from your own incidents.

## Common mistakes

**Mistake 1 — Trying to memorize all 20 today.** You can't. You don't need to. Recognize the 5-6 that appear most in your sessions; the rest you'll meet over time. Reference Appendix A when something looks off.

**Mistake 2 — Naming the pattern but not intervening.** Spotting "#5 hedging" without saying anything to Claude wastes the catch. The intervention is short — "skip the hedge, run the verification" — but it has to happen. Recognition without intervention is just frustration.

**Mistake 3 — Treating the catalog as exhaustive.** Your specific project will produce new failure shapes. Add them. Promote them through Chapter 16's discipline. The catalog grows with you.

## Drill

Artifacts go in `student/drills/18-the-anti-pattern-vocabulary/`.

**Drill 1 — Spot the patterns in a constructed transcript.** Save this constructed Claude reply to `student/drills/18-the-anti-pattern-vocabulary/01-spot-them.txt`, with a numbered list of which anti-pattern numbers you see (at least 3):

> "I've started implementing the auth flow. The login endpoint took longer than expected — probably 30 more minutes to wrap up. I think the password reset is straightforward but I'd want your input on whether to use email tokens or magic links. Tests pass."

**Drill 2 — Catch one in your own session.** Open Claude Code. Have any short conversation. Watch for ANY of the 20 patterns. If you see one, paste the offending phrase + the anti-pattern number to `student/drills/18-the-anti-pattern-vocabulary/02-caught-one.txt`. If nothing appears, prompt with something underspecified ("make my app better") to provoke one.

**Drill 3 — Practice the intervention.** Pick any one of the 20 patterns. Write a 1-sentence redirect to `student/drills/18-the-anti-pattern-vocabulary/03-my-redirects.txt`. Do this for 3 different patterns. Format: `#3 wind-down → "Don't defer. What's the next concrete edit?"`

## Checkpoint question

> You're reviewing yesterday's session transcript with a friend. Your friend asks: "I see a lot of phrases like 'I think,' 'should be fine,' and 'about an hour or so' — what's the actual problem here?" Walk them through what those phrases are signaling, which anti-patterns they belong to, and what the intervention is — in three sentences total.
