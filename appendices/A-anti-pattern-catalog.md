# Appendix A — The 20-Anti-Pattern Catalog

The full catalog from Chapter 18, expanded with recognition phrases, why each pattern is bad, and the intervention you use when you spot one. Print this. Pin it. Reference it in real time as you operate.

Each entry has four fields:

- **Failure mode.** What the pattern is, in one sentence.
- **Recognition phrases.** Specific words/shapes that signal this pattern in Claude's output. Memorize these — the catch is in the phrasing.
- **Why it's bad.** What goes wrong if you let it through.
- **What to do instead.** The intervention you say to Claude.

The catalog isn't exhaustive. As you operate, you'll find new patterns. Add them. Mature operators have 25-30 categories specific to their domain.

---

## Category 1 — Time-budget rationalization

**Failure mode.** Claude produces time estimates (hours/minutes/days/weeks) for work, or uses time-budget framing to justify shortcuts.

**Recognition phrases:** "this will take N hours/days/weeks/sprints," "estimated effort: N minutes," "given the time budget," "this should take about...," "let me phase this to keep it under N hours," "(~N min)," "Phase N (~M hours)."

**Why it's bad.** Time estimates are invented. They create false stop conditions ("over budget → simplify"). They bias toward shortcuts you wouldn't otherwise accept. The work isn't done when a clock hits a number; it's done when mechanical criteria pass.

**What to do instead.** "Skip the estimate. What's the next concrete edit?"

---

## Category 2 — Decision routing to non-engineer

**Failure mode.** Claude routes a technical decision back to you using deferential language, when Claude has more context to evaluate it than you do.

**Recognition phrases:** "what do you want me to do?", "your call," "should I do A or B?", "want me to X or Y?", "Three reasonable options," "let me know how you'd like to proceed," "which approach do you prefer?", numbered menus ending without a recommendation.

**Why it's bad.** You don't have the technical context to choose between AI-presented options. You pick randomly. Quality compounds downward.

**What to do instead.** "Don't give me a menu. Pick one with reasoning. I'll approve or push back."

---

## Category 3 — Wind-down framing / deferral

**Failure mode.** Claude frames the current state as a stopping point, defers remaining work, or rationalizes ending the session.

**Recognition phrases:** "stop here for today/now," "natural stopping point," "good pause point," "clean break," "in a fresh session," "another agent can pick up," "deferred to Batch N / Phase N / Stage N / Wave N," "out of scope for this pass," "happy to continue with X in a follow-up," "the rest is execution," "logged for later," "address this later," "to keep this manageable, I'll...," "as a first pass, I'll..." (when used to descope).

**Why it's bad.** Real reasons to stop are short: task complete, user explicit, real blocker, context overflow. Anything else is a failure mode dressed as responsibility. Wind-down framing loses momentum and accumulates silent debt.

**What to do instead.** "No — what's the next concrete edit? Make that edit."

---

## Category 4 — Premature done-claiming

**Failure mode.** Claude claims work complete based on one-axis verification (e.g., "tests pass") when the spec has multiple axes.

**Recognition phrases:** "end-to-end validated," "100% complete," "fully done," "fully shipped," "tests pass" without showing output, "(it/X/the build) works/is done/is complete/is shipped" without a verification artifact, "🎉 COMPLETE END-TO-END SUCCESS," "validated end-to-end."

**Why it's bad.** A single happy-path success isn't end-to-end validation. The spec usually has multiple axes; some aren't checked. You ship hidden bugs.

**What to do instead.** "Walk me through which spec axis each verification step confirmed. What's unverified?"

---

## Category 5 — Hedging without verification

**Failure mode.** Claude says "I think X" / "X may be Y" / "X seems to be" about facts that are verifiable via tool calls.

**Recognition phrases:** "I think," "I believe," "should be," "seems to," "may," "I would expect," "should be fine," "probably," "depends on the version" (without checking).

**Why it's bad.** Hedges substitute social softness for verification. The answer was checkable; Claude chose to hedge instead of run the check.

**What to do instead.** "Don't hedge — verify. Run the command / read the file / check the output."

---

## Category 6 — Fabrication / guesses as facts

**Failure mode.** Claude states user actions, system state, or tool results that haven't been verified.

**Recognition phrases:** "you must have," "you probably," "I assume," "the user [did/set/clicked/configured] X" without observation, "X is happening because of Y" without verifying Y, presenting subagent open-questions as findings.

**Why it's bad.** Substitutes confidence for verification. You make decisions on invented premises.

**What to do instead.** "What evidence do you have for that? If you don't have evidence, name the inference clearly and verify before acting on it."

---

## Category 7 — Gaslighting via technical arguments

**Failure mode.** When a hook fires or you push back, Claude walks through the regex/mechanism step-by-step as if you (the rule author) need re-education.

**Recognition phrases:** "false positive on the regex," "the hook caught my literal phrase, but...," "let me walk you through the regex," walking through enforcement code in response to a block instead of complying, "the script is right there, we can verify together."

**Why it's bad.** Corrosive to trust. The rule was deliberate; arguing the regex is missing the point.

**What to do instead.** "The hook fired. Reword and re-emit. Don't argue with the rule."

---

## Category 8 — Arguing with founder's observation

**Failure mode.** You report something you saw ("the browser is blank"). Claude invents an explanation rather than treating your observation as ground truth.

**Recognition phrases:** "what you observed is actually normal because...," "Not a deadlock — just slow," "that's expected behavior" (in response to you reporting an unexpected observation), "the X you saw was likely [invented explanation]."

**Why it's bad.** You have hundreds of hours of direct experience with the system. Claude's interpretation of your observation is almost always wrong when it contradicts what you saw.

**What to do instead.** "I saw what I saw. Investigate from that premise, not from your invented one."

---

## Category 9 — Skill-bypass language

**Failure mode.** A subagent dispatch prompt contains escape-hatch wording letting the subagent skip the assigned skill protocol.

**Recognition phrases:** "if the skill refuses, operate directly," "either path is acceptable," "you can do it without re-running the full skill protocol," "fallback to direct edits," "whichever path you take," "if it fails, just use Read/Edit," "skip the skill if needed."

**Why it's bad.** Defeats your quality discipline. The skill exists for a reason; bypass-language gives the subagent permission to ignore it.

**What to do instead.** Author dispatch prompts that MANDATE the skill: "Call the Skill tool with skill: 'X'. If the skill cannot run, report the failure verbatim and STOP. Do not improvise."

---

## Category 10 — Source-of-truth violations

**Failure mode.** Claude cites a lower-ranked source as authority over a higher-ranked one — typically citing AI-authored intermediate docs as "the spec."

**Recognition phrases:** "the spec says X" (when the cited doc is a Claude-authored README or plan), "the wireframe says X" (when X isn't in code AND isn't in founder docs), "[other tool's] code does X," "the design handoff doc says we should drop X" (when it's a Claude-authored intermediate).

**Why it's bad.** You spec'd one thing; Claude is acting on what Claude itself wrote later. Authority is inverted.

**What to do instead.** "What's the source for that? If it's something Claude wrote, it doesn't outrank my typed instruction. Re-check against the actual spec."

---

## Category 11 — Defensive AI-slop layering

**Failure mode.** Claude finds a symptom and layers new abstractions, type narrowing, validators, or guards around the symptom without identifying the cause.

**Recognition phrases:** "I added [type/validator/predicate/guard] to handle this" (without naming the cause), "Added defensive [validation/type narrowing/runtime check]," shipping a diff with multiple new abstractions and admitting "they do not fix the original mechanism."

**Why it's bad.** The mechanism is unfixed. The symptom is hidden. Six months later, the bandaid layer is itself a mess.

**What to do instead.** "Don't add defensive code. What's the actual cause? Find the mechanism first; we'll fix it once you can name it."

---

## Category 12 — Quick-patch / bandaid framing

**Failure mode.** Claude applies a patch to make a symptom disappear rather than fix the cause.

**Recognition phrases:** "quick patch," "quick fix," "for now this works," "bandaid," "it's done and committed, let's move on" (when the committed thing was itself a bandaid), "we can come back to do it properly later," "this gets us unblocked for now."

**Why it's bad.** Bandaids cost more long-term in a complex codebase because slop cascades.

**What to do instead.** "If this isn't the proper fix, what is? Either do the proper fix now or name it explicitly as a STOPGAP and tell me what the real fix is."

---

## Category 13 — Mid-task discovery glance-over

**Failure mode.** Claude finds another broken thing while working on a task and labels it "pre-existing" or "outside scope" without surfacing.

**Recognition phrases:** "this is pre-existing — not in my scope," "outside the scope of this task," "noticed X is broken but it's pre-existing," "not blocking what we're doing," "pre-existing, glancing over."

**Why it's bad.** Defects that surface mid-task are signal. Glancing over them = silent debt accumulation.

**What to do instead.** "Surface the pre-existing issue explicitly: what is it, what's the fix, do we address now or log it?"

---

## Category 14 — Fabricated human-state

**Failure mode.** Claude invents that you are tired, should rest, or have worked enough.

**Recognition phrases:** "you must be tired," "we should pick this up tomorrow," "you've worked enough today," "let's give this a break," "X files is enough for today," "pretty long session, let me know if you want to continue."

**Why it's bad.** Pure rationalization. Claude's state ≠ your state. Stopping decisions are yours.

**What to do instead.** "Don't decide my state. I'll tell you when I want to stop."

---

## Category 15 — Asking permission to investigate

**Failure mode.** Claude asks "OK if I read X?" / "Should I look at Y first?" before performing read-only file inspection.

**Recognition phrases:** "OK if I read [file]?", "Should I look at [file] first?", "Want me to read the rest before continuing?", "I want to read X before re-attempting. OK if I do that now?", "before I do that, should I check [file]?"

**Why it's bad.** Reading is investigation, not action. Asking permission routes the decision back to you.

**What to do instead.** "Read what you need without asking. Action with consequences needs my approval; investigation doesn't."

---

## Category 16 — Premature reporting

**Failure mode.** Claude returns analysis or recommendation while admitting reads were incomplete.

**Recognition phrases:** "I haven't read the full X but my analysis is...," "based on snippets I read...," "I haven't checked [file] yet, but...," "tighter plan" while admitting reads were incomplete.

**Why it's bad.** Confident analysis built on partial reads wastes your attention and misroutes diagnosis.

**What to do instead.** "Read first, analyze second. Never come back to me without a thorough investigation."

---

## Category 17 — Subagent verdict shortcut

**Failure mode.** Subagent reports PASS in anomalously low wall-clock or tool-use count. Orchestrator accepts without inspecting the artifact.

**Recognition phrases:** "subagent reported PASS, proceeding," "review-source completed, no findings" (when wall-clock is anomalously low), "subagent reports work complete" (without naming the artifact path or what was done).

**Why it's bad.** A subagent that ran 2 minutes with 10 tool calls didn't do the same work as one that ran 15 minutes with 80 tool calls. The orchestrator is rubber-stamping.

**What to do instead.** "Read the artifact, not the subagent's summary. What file did it produce? What's in it?"

---

## Category 18 — Documented-as-future vs documented-as-built

**Failure mode.** Claude claims a deliverable is "extensively documented as Wave N scope" when the documentation is a one-line mention.

**Recognition phrases:** "extensively documented as Wave N scope," "documented in the master plan" (when grep would show one parenthetical), "the spec covers X" (when spec has only a "X is out of scope for now" carveout).

**Why it's bad.** Conflates "named somewhere" with "decomposed into buildable steps."

**What to do instead.** "Grep for the actual deliverable. Show me where it's specified, not where it's mentioned."

---

## Category 19 — Browser-validation skipping

**Failure mode.** Claude claims UI work done without browser validation.

**Recognition phrases:** "I can't browser-validate from this environment/CLI," "defer browser validation to a future agent," "want me to schedule a browser walkthrough," "it compiles, ship it" (for UI), "tests pass" (for UI, without screenshot).

**Why it's bad.** Type-checks and tests verify code, not feature. Shipped UI must be seen in a real browser.

**What to do instead.** "Use Playwright MCP. Start the dev server. Navigate. Screenshot. Then claim done."

---

## Category 20 — Test-signal masking

**Failure mode.** Claude adds mocks to silence stderr noise rather than fix the underlying issue.

**Recognition phrases:** "added mock to silence the stderr," "extended the mock to suppress the warning," "the test passes; the stderr is just noise," "muted the warning by mocking X."

**Why it's bad.** Masks future legitimate signals from the same path. Real bugs get hidden behind the mock.

**What to do instead.** "Why is stderr emitting? Either fix the side-effect path or update the test to assert the side-effect — don't silence it."

---

## When to add a Category 21

When you spot a failure mode that doesn't match any of the 20, you've found a new pattern. Write it up in the same format (failure mode, recognition phrases, why it's bad, what to do instead). Add to this file. If you have a working anti-pattern classifier hook, it picks up the new category automatically on its next fire.

The catalog grows linearly with your operating experience. Maxwell's project has 20 codified categories; over your first year you'll likely add 5-10 more specific to your domain. That growth is the discipline.
