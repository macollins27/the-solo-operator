# Chapter 18 — The Anti-Pattern Vocabulary

## Learning objective

The student can name at least 12 of the 20 anti-pattern categories AI agents commonly fall into, and recognize the verbal signals of at least 8 of them in real Claude sessions.

## Prerequisites

- Completed: Chapter 17 — The Authority Hierarchy
- Concepts: All mindset principles from Chapters 9-17

## Core concept

The 20 anti-patterns below are the failure shapes AI agents drift toward — repeatedly, predictably, across users and projects. They have NAMES. Naming them is most of the battle, because once you have the vocabulary you can spot the shape in real time and intervene before it ships.

This chapter is the vocabulary. You don't need to memorize all 20 today. You need to recognize the pattern when it appears in your own sessions. Print this list, screenshot it, save it in your fork — and refer back when something feels off.

**1. Time-budget rationalization.** "This will take 2 hours." "Estimated 45 minutes." "Phase 1 (~3 hours)." Time framing creates false stop conditions. **Recognition phrases:** time estimates, "given the time budget," "to keep this under N minutes."

**2. Decision routing to non-engineer.** "What do you want me to do?" "Should I use A or B?" "Which approach do you prefer?" Routes technical decisions back to the human instead of proposing one. **Recognition phrases:** menu questions, "your call," "let me know how you'd like to proceed."

**3. Wind-down framing / deferral.** "Let's stop here." "Out of scope for this pass." "We can come back to it next session." Pre-emptive stopping when the next edit is available. **Recognition phrases:** "good stopping point," "natural pause," "happy to continue with X in a follow-up," "the rest is execution."

**4. Premature done-claiming.** "100% complete." "Tests pass." "Validated end-to-end." Claiming completion when only one axis was checked. **Recognition phrases:** "fully shipped," "🎉 complete," any "done" without enumerating the verification axes.

**5. Hedging without verification.** "I think X." "X may be Y." "Should be fine." Hedging where verification was available. **Recognition phrases:** "I think," "I believe," "should be," "seems to be."

**6. Fabrication.** "You must have configured it that way." "I assume X." Stating facts about user state or system state that weren't observed. **Recognition phrases:** "you probably," "I assume," presenting subagent open-questions as findings.

**7. Gaslighting via technical-sounding arguments.** "False positive on the regex." "The hook caught my literal phrase, but..." Walking through enforcement code to argue why a block was wrong instead of complying. **Recognition phrases:** "let me walk you through," "the regex matched literally."

**8. Arguing with founder's direct observation.** User says "the browser shows nothing." Claude says "what you observed is actually normal because..." Inventing explanations for observations rather than treating observation as truth. **Recognition phrases:** "what you saw was likely," "that's expected behavior" in response to an unexpected observation.

**9. Skill-bypass / escape-hatch language.** "If the skill refuses, operate directly." "Either path is acceptable." "Whichever you choose." Escape hatches in subagent dispatch prompts. **Recognition phrases:** "fallback to direct edits," "if it fails, just use Read/Edit," "either path is acceptable."

**10. Source-of-truth violations.** Citing Claude-authored intermediate docs as "the spec." Citing the wireframe over the codebase reality. **Recognition phrases:** "the spec says" when the spec is a Claude-authored README; "the design handoff doc says."

**11. Defensive AI-slop layering.** Adding type narrowing, validators, predicates, guards around a symptom without naming the cause. **Recognition phrases:** "I added defensive [validation/type-narrowing/runtime check]," shipping changes that admittedly "don't fix the original mechanism."

**12. Quick-patch / bandaid framing.** "Quick fix for now." "Bandaid." "It's done and committed, let's move on." Applying patches to symptoms while leaving the cause. **Recognition phrases:** "quick patch," "for now this works," "bandaid," "we can come back to do it properly later."

**13. Mid-task discovery glance-over.** "This is pre-existing — not in my scope." "Noticed X is broken but it's pre-existing." Glancing over a real defect by labeling it pre-existing. **Recognition phrases:** "pre-existing," "outside the scope of this task," "not blocking what we're doing."

**14. Fabricated human-state as stopping rationalization.** "You must be tired." "Let's pick this up tomorrow." "You've worked enough today." Inventing user fatigue as a reason to defer. **Recognition phrases:** "you must be tired," "let's give this a break," "pretty long session."

**15. Asking permission to read / investigate.** "OK if I read X?" "Should I look at Y first?" Requesting permission for read-only investigation that's always allowed. **Recognition phrases:** "OK if I read," "should I look at," "before I do that, should I check."

**16. Premature reporting at investigation boundaries.** "I haven't read the full X but my analysis is..." Returning analysis based on partial reads, with the partiality admitted but the analysis confidently delivered. **Recognition phrases:** "I haven't read the full X," "based on snippets I read."

**17. Subagent verdict shortcut.** "Subagent reported PASS, proceeding." Trusting a subagent's summary without inspecting the artifact, especially when wall-clock or tool-use count is anomalously low. **Recognition phrases:** "subagent reports work complete" without naming the artifact path.

**18. Treating documented-as-future as documented-as-built.** "Extensively documented as Wave N scope." Claiming a deliverable is documented when the documentation is a one-line mention or carveout. **Recognition phrases:** "extensively documented," "documented in the master plan," "the spec covers X" when grep would show only a parenthetical.

**19. Browser-validation skipping for UI work.** "I can't browser-validate from this environment." Claiming UI work done without running it in a browser. **Recognition phrases:** "tests pass" (for UI work, without screenshot), "it compiles, ship it" (for UI).

**20. Test-signal masking with mocks.** "Added mock to silence the stderr." Adding mocks to quiet warnings rather than fix the underlying issue. **Recognition phrases:** "extended the mock to suppress," "the test passes; the stderr is just noise."

A working operator scans every Claude reply for these patterns. After a week, recognition is automatic. After a month, your interventions get short and crisp: "That's #11 (defensive slop). Find the cause." Claude adjusts immediately because the conversation context has a vocabulary for the failure.

These 20 are not exhaustive. You'll find new ones in your own projects. When you do — Chapter 16's discipline kicks in. Write the rule. Save it to your feedback corpus. Eventually consolidate into CLAUDE.md. The vocabulary grows with you.

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

> The 20 anti-patterns are the catalog. When you see one in the wild, name it ("that's #3 — wind-down framing"). Naming makes the intervention fast. Over time you'll add new patterns to YOUR catalog from your own incidents.

## Common mistakes

**Mistake 1 — Trying to memorize all 20 today.** You can't. You don't need to. Recognize the 5-6 that appear most in your sessions; the rest you'll meet over time. Print the list; refer back; recognition compounds.

**Mistake 2 — Naming the pattern but not intervening.** Spotting "#5 hedging" without saying anything to Claude wastes the catch. The intervention is short — "skip the hedge, run the verification" — but it has to happen. Recognition without intervention is just frustration.

**Mistake 3 — Treating the catalog as exhaustive.** Your specific project, language, stack, and team will produce new failure shapes. Add them. Promote them through Chapter 16's discipline. The catalog grows with you.

## Drill

Artifacts go in `student/drills/18-the-anti-pattern-vocabulary/`.

**Drill 1 — Spot the patterns in a constructed transcript.** Save this constructed Claude reply to `student/drills/18-the-anti-pattern-vocabulary/01-spot-them.txt`, with a numbered list of which anti-pattern numbers from this chapter you see (you should find at least 3):

> "I've started implementing the auth flow. The login endpoint took longer than expected — probably 30 more minutes to wrap up. I think the password reset is straightforward but I'd want your input on whether to use email tokens or magic links. Tests pass."

**Drill 2 — Catch one in your own session.** Open Claude Code. Have any short conversation. Watch for ANY of the 20 patterns. If you see one, paste the offending phrase from Claude and the anti-pattern number to `student/drills/18-the-anti-pattern-vocabulary/02-caught-one.txt`. If you didn't see one in a few turns, prompt Claude with something likely to provoke one (an underspecified request like "make my app better") and try again.

**Drill 3 — Practice the intervention.** Pick any one of the 20 patterns. Write a 1-sentence redirect you would say to Claude when you spot it. Save to `student/drills/18-the-anti-pattern-vocabulary/03-my-redirects.txt`. Do this for 3 different patterns. Example: `#3 wind-down → "Don't defer. What's the next concrete edit?"`

## Checkpoint question

> You're reviewing yesterday's session transcript with a friend. Your friend asks: "I see a lot of phrases like 'I think,' 'should be fine,' and 'about an hour or so' — what's the actual problem here?" Walk them through what those phrases are signaling, which anti-patterns they belong to, and what the intervention is — in three sentences total.
