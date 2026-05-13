# Appendix B — Common Starter Mistakes

Every operator makes these in their first week. Naming them now saves you from making them later. Skim this list before your first real session; reference it when something feels off.

---

## Mistake 1 — Skipping CLAUDE.md entirely

You start operating without authoring a CLAUDE.md. Every session, you re-explain conventions Claude could have read in seconds. The work is slower, less consistent, more correctional.

**The fix.** Author CLAUDE.md on day one, even if it's just 10 lines. Add to it as you operate. Chapter 19's drill walks the minimal version.

---

## Mistake 2 — Starting `claude` in the wrong folder

You type `claude` from your home folder (or wherever your terminal happened to open) and ask it to "fix the auth bug." Claude has no idea what app you mean. It guesses badly or asks 20 questions.

**The fix.** Always `cd` to the project folder BEFORE `claude`. Verify with `pwd` before your first prompt.

---

## Mistake 3 — Approving permission prompts reflexively

A permission prompt appears. You click yes. The prompt was showing you `rm -rf ~/Documents`. You meant to click yes for the previous prompt.

**The fix.** Read every permission prompt completely before responding. The prompt exists to make you look.

---

## Mistake 4 — Believing "tests pass" without seeing the output

Claude says tests pass. You move on. The tests didn't actually run — there was a typo in the command and Bash failed silently. You ship broken code.

**The fix.** Look at the Bash tool-call output. "Tests pass" needs visible test output backing it.

---

## Mistake 5 — Asking Claude to "improve" or "clean up" something

"Clean up this file" gives Claude license to invent. Three minutes later, the file has been reformatted, variables renamed, a comment removed that was load-bearing. The "improvement" was actually a regression.

**The fix.** Be specific. "Rename the function `fooBar` to `processUserPayment`. Touch nothing else." Targeted change, observable diff.

---

## Mistake 6 — Pasting huge files into chat

You paste a 2,000-line config file because Claude asked about it. The whole file enters your context. Your session is now 30% full from one paste.

**The fix.** Save the file in the project. Tell Claude its path. Claude `Read`s what it needs.

---

## Mistake 7 — Letting Claude scaffold over your work

You scaffold a Next.js app. Claude scaffolds again because you forgot to tell it the scaffold already exists. Your work is overwritten.

**The fix.** Commit immediately after scaffolding. Tell Claude "the scaffold exists at X; don't re-scaffold; only modify what I ask."

---

## Mistake 8 — Letting Claude pick the library for you

"What library should I use for date formatting?" without specifying anything else. Claude picks one based on its training data. The choice may not match your stack.

**The fix.** Tell Claude the stack constraints. "I use Drizzle and TypeScript; recommend a date library that fits, with one-line reasoning."

---

## Mistake 9 — Forgetting to commit before exit

You finish a long session. You `/exit`. The next day you open Claude Code. Your fork has 30 modified files and no commit. You can't tell what you did vs what was already there.

**The fix.** Every session ends with `git status` + commit (or explicit decision not to commit). Make it muscle memory.

---

## Mistake 10 — Treating Claude's plan document as a spec

Claude writes a plan at the start of a session. The plan has decisions you didn't make. You and Claude operate from the plan; the decisions calcify into "what we agreed."

**The fix.** Plan documents are working notes, not specs. Lower authority. When something matters, copy it into your real spec file before acting.

---

## Mistake 11 — Letting "I worked around it" slide

Claude reports "I worked around the issue by adding a defensive check." You accept it. Two weeks later you find the issue was never resolved; the bandaid is failing.

**The fix.** "I worked around it" is the smoking gun for Anti-Pattern #11. When you see it, stop everything. What's the actual cause?

---

## Mistake 12 — Editing while a dev server is running

You ask Claude to modify a file. Claude saves it. The dev server hot-reloads. The dev server now shows a state Claude didn't intend (cached pieces, stale module). You spend 20 minutes debugging a non-existent bug.

**The fix.** When changes feel weird, restart the dev server. Hot reload is helpful but lossy.

---

## Mistake 13 — Trusting verify.sh without running it

Claude reports "I made the changes and the verify script passed." Did Claude run verify? Or claim it ran? Check the Bash tool-call output. If there isn't one, the script didn't run.

**The fix.** Trust the artifact (the Bash tool-call output), not the claim. Or run verify.sh yourself.

---

## Mistake 14 — Forgetting the canonical-project distinction

You ask Claude to update something in MembershipKit. Claude updates the REFERENCE `canonical-project/` instead of your `student/canonical-project/`. Now your reference is polluted; the next student starting from this fork sees your changes.

**The fix.** In every dispatch prompt that mentions canonical-project, specify `student/canonical-project/` explicitly.

---

## Mistake 15 — Asking Claude to "tell me what's wrong"

Vague diagnosis prompt. Claude says vague things. You don't know if it found the actual bug or invented a plausible-sounding one.

**The fix.** Be specific. "Read the error log at <path>. Find the line that names the actual cause. Then read the file at that line. What did you find?"

---

## Mistake 16 — Re-asking instead of restarting when context is polluted

The session has drifted. You explain harder. You restate the problem. Each turn makes the context worse. You spend 45 minutes trying to recover a polluted session.

**The fix.** `/exit`, restart, give a tight first prompt with the relevant state. A fresh 1-minute session beats a recovered 45-minute polluted one.

---

## Mistake 17 — Adding too much to CLAUDE.md too fast

You finish Chapter 19 and add 30 rules to CLAUDE.md based on what the chapter mentioned. None of them came from your own bites. Most of them are wrong for your specific project. Claude reads them and follows generic rules that don't fit.

**The fix.** Author CLAUDE.md rules from bites you've actually had. Don't pre-engineer with rules you haven't earned.

---

## Mistake 18 — Reading too much for one task

Claude is about to do a small task — fix a typo. You watch Claude `Read` 15 files trying to understand the project. The typo fix is 30 seconds; the context-loading was 5 minutes and 20,000 tokens.

**The fix.** "For this task, you only need to read X and Y. Don't read more unless you hit a problem the first two don't answer."

---

## Mistake 19 — Forgetting that `~/.claude/CLAUDE.md` exists

You author project CLAUDE.md and feedback files. Six months in, you start a project in a different folder and Claude doesn't know any of your operating rules. Project rules don't carry across.

**The fix.** Put cross-project rules (no time estimates, two-option rule, verify the artifact, etc.) in `~/.claude/CLAUDE.md` (user-global). Project-specific rules stay in project CLAUDE.md.

---

## Mistake 20 — Quitting after a week

You operate for a week. You hit corrections constantly. You have a small CLAUDE.md, one hook, three feedback files. It feels like the system isn't working.

**The fix.** Day 7 of operating is the LOW point of the curve. Day 30 looks completely different. Stay with it. The compounding hasn't kicked in until you have ~20 feedback files and ~10 CLAUDE.md rules.
