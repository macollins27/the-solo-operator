# Chapter 0 — Why You're Here

## Learning objective

The student can explain in their own words the difference between "prompting an AI" and "operating an AI engineering system," and why the second is what this course teaches.

## Prerequisites

None. This is the orientation chapter.

- Completed: (none)
- Concepts: (none)

## Core concept

There are two ways to use AI to build software. One scales. The other doesn't.

**The way that doesn't:** PROMPTING. You open a chat. You describe what you want. You take the output, paste it somewhere, hope. When the AI says "I can't do that" you accept it. When the AI offers you a menu of three approaches, you pick one. When the AI says "tests pass" you believe it. The whole relationship is request-and-receive. You are a customer at a counter; the AI is whatever shows up on the tray.

**The way that scales:** OPERATING. You are not the customer. The AI is the engineer. Technical decisions belong to the AI. You push the boundary of what the AI is willing to attempt; you specify outcomes; you evaluate work product against the artifact; you refuse refusals. The system that gets built gets built by the AI doing the work AI is structurally good at, and you keeping the AI from quitting on you. Over time you accumulate rules, hooks, skills, and indexes — a system that produces work no one else's AI can produce. The system IS the moat.

The difference matters because every load-bearing failure mode of using AI to build software lives in PROMPTING. The AI invents a workaround instead of fixing the cause. The AI says "I can't browser-validate from CLI" when it can. The AI claims "the gate passed" without reading the actual command output. The AI gives you three options when it should have made the call itself. Prompters wear all of these. Operators have an answer to each — and the answer is a piece of the system, on disk, that prevents the failure for every future session.

OPERATING is what the rest of this course teaches: the mindset (you are the operator, not the engineer), the discipline (verify the artifact, never the summary; spec is truth; persistence over cleverness), the mechanics (Claude Code, hooks, skills, subagents, MCP), and the meta-skill (when something bites you, write the rule). By the end you have a working piece of software AND a system that produces software — both yours, both compounding.

## Worked example

Two operators are each building a small membership manager for their community — the canonical project for this course, MembershipKit.

**Person A prompts.** They open a session: "Add an auth flow with sign-up, sign-in, and password reset." The AI returns. The AI says "I'll use cookies for the session — do you want httpOnly or bearer tokens?" Person A doesn't know. Person A says "you decide." The AI picks, builds, returns. Person A skims the diff. The AI says "tests pass." Person A believes it. Two weeks later they hit a bug: signed-in users can re-submit the sign-in form, get a fresh session with the wrong organization context. They didn't catch it during review because they trusted the summary. They didn't have a rule preventing it because they didn't author one. The same shape of bug will hit them again — they have no system that remembers.

**Person B operates.** Same starting request. The AI says "I'll use cookies for the session — do you want httpOnly or bearer tokens?" Person B refuses the menu: "That's an engineering call. Make it. Tell me your reasoning. I'll approve or push back." The AI picks httpOnly, explains why, ships. Person B opens the page in a browser before saying done. Person B catches the missing reverse-guard on `/auth/sign-in`. The AI fixes it. Person B writes a four-line rule to disk: "When you finish any UI change, open it in a browser before reporting done. Cite the screenshot." Saves it to `student/feedback/feedback_browser_validate_ui.md`. Two weeks later, the same shape of failure tries to occur on a different feature — and doesn't, because every session reads that file at start.

Same task. Same AI. After three months Person A is still debugging the same families of bug. Person B has 30 such rules, an AI that doesn't make those mistakes, and a system that gets sharper every week.

## The rule

> You are not the engineer. The AI is the engineer. Your job is to specify the outcome, push the boundary of what the AI is willing to attempt, evaluate the work product against the artifact, and accumulate rules that prevent every failure mode you've already lived through. Build the system, not the prompt.

## Common mistakes

**Mistake 1 — Making technical decisions instead of refusing menus.** The AI offers "Option A, Option B, Option C — which do you prefer?" Prompters pick one (badly, randomly, because you don't have the context to choose). Operators refuse the menu: "Pick one with reasoning. I'll approve or push back." The technical call belongs to the AI; the approve/redirect belongs to you.

**Mistake 2 — Trusting AI summaries.** "I fixed the bug." "The tests pass." "The build is clean." These are claims, not evidence. The tool calls, the file diff, the command output, the browser screenshot — those are evidence. Operators look at the evidence in under 30 seconds before believing the claim. Every time.

**Mistake 3 — Letting incidents happen without writing the rule.** Something bites you. You fix it. You move on. Three weeks later the same shape of failure bites you again because you didn't write the rule down. The 60 seconds to author a four-line rule prevents the 60-minute re-debug. Operators write the rule the moment the incident is fresh; prompters keep re-discovering the same lessons.

## Drill

Your moat starts now. Even before you write code, you start a habit: when something bites you, you write it down. The course teaches this discipline in Chapter 16, but the habit's container is created here.

**Drill 1 — Create your feedback corpus directory.** Open Finder (Mac) or File Explorer (Windows). Navigate to your fork of the course repo. Inside the `student/` folder, create a folder named `feedback`. You should now have `student/feedback/`.

**Drill 2 — Author the INDEX file.** Inside `student/feedback/`, create a plain text file named `INDEX.md`. Open it in any text editor. Paste the following three lines and save:

```
# My feedback corpus

(Each time an AI bites me, I add an entry here pointing to a feedback_<slug>.md file in this folder.)
```

After this, `student/feedback/INDEX.md` exists. It will accumulate entries every time you author a feedback rule from one of your own incidents (Chapter 16 will show you the format).

**Drill 3 — Run the verify script.** Per the AI tutor's instructions, run `bash parts/00-orientation/01-why-youre-here/verify.sh ./student`. If your file is in the right place, the script exits 0 and the tutor advances you to Chapter 1.

By the end of this drill you have created the literal first artifact of your operating system: a place where the rules YOU author will live. The moat begins.

> **See Appendix E** for a reading list of external references that pair with this course. You don't need any of them to start — they're optional, calibrated to where you'll be after Parts 1-3.

## Checkpoint question

> A friend tells you: "I asked Claude to add a feature. It came back with 'I can implement this either as Option A (faster, less safe) or Option B (slower, more secure). Which would you prefer?' I picked B because it sounded safer." Your friend is asking you whether that was the right interaction. Walk them through what a prompter would do, what an operator would do, and which kind of failure mode they just enacted.

<!-- Rewriter audit trail
Grounded in verified principles: P1 (operator built the system by pushing capabilities), P2 (decisions belong to engineer = AI), P3 (push first, accept no second), P4 (false-yes/false-no symmetry), P21 (mechanical enforcement), P57 (memory before compaction), P68 (already-signed-in users)
Worked example surface: MembershipKit auth flow
Rewrite date: 2026-05-13
-->
