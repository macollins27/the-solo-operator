# Chapter 23 — Subagents and parallel work

## Learning objective

The student can describe the difference between a fork subagent and a fresh subagent, predict when each is appropriate, dispatch one of each from their own session, and read the results without polluting their main conversation.

## Prerequisites

- Completed: Chapter 22 — MCP servers
- Concepts: conversation-turns, context-window-finite

## Core concept

You can dispatch a **subagent** from inside a Claude Code session — a separate Claude that runs in parallel, does its own work, and returns a result. Subagents come in two flavors:

**Fork subagents** inherit your full conversation context up to the moment of dispatch. They know everything you and Claude have discussed. They share your prompt cache, so additional forks are cheap. Their output STAYS OUT of your context — only a terse return summary comes back to you.

**Fresh subagents** start with zero context. You give them a complete briefing in the dispatch prompt. They don't know anything you haven't told them. Their output also stays out of your main context.

When to fork:

- The work depends on the convergence YOU and Claude reached over many turns ("based on what we just figured out, go do X")
- The work is creative or judgmental and benefits from the accumulated framing
- You want the subagent to operate within the discipline you've been correcting toward all session

When to dispatch fresh:

- The work has a crisp, self-contained scope ("audit this file for security issues")
- You DON'T want the subagent inheriting your session's drift or framing
- The work is repetitive and a clean brief produces consistent results

Why this matters for your context window:

Subagent tool output stays OUT of your main context. The subagent runs, does its 50 tool calls, processes a huge amount of data, and returns a 200-word summary. Your context grows by 200 words, not 200,000. This is the load-bearing trick: subagents let you do work that would blow up a single context, while keeping the orchestrator (you) clean.

Three patterns operators use:

**Pattern 1 — Parallel diagnostics on the same question.** When a problem is high-stakes and you want confidence, dispatch 2-3 subagents on the same diagnostic question. Convergence on the same answer = high confidence. Divergence = each agent is fallible. Maxwell's project uses this routinely; this course encourages it.

**Pattern 2 — Decompose a big task.** A 50-chapter audit is impossible in one session. Dispatching 50 forks, one per chapter, returns 50 terse summaries while the heavy work happens in parallel. Your context stays focused on synthesis.

**Pattern 3 — Isolate dangerous work.** Some work shouldn't pollute your main thread — reading legacy code, doing experimental analysis, generating throwaway content. A fresh subagent does the work in isolation; the result you keep is just the conclusion.

The dispatch tool in Claude Code is `Agent`. You give it: a description, a prompt, and (optionally) a `subagent_type`. No `subagent_type` = fork. With a `subagent_type` like `general-purpose` = fresh.

Key discipline points:

- **Don't peek.** Once you dispatch, you'll get a completion notification. Don't try to read the subagent's transcript or output file directly — that defeats the point of keeping it out of your context.
- **Don't race.** You don't know what the subagent will return until it returns. Never predict or fabricate results before the notification arrives.
- **Verify the work.** The subagent returns a summary. Read it. If it claims something the work didn't support, verify against artifacts (Chapter 12's discipline).
- **Mandate the skill.** If you want the subagent to follow a specific protocol, put the Skill invocation IN the dispatch prompt. Don't write escape-hatch language ("if the skill refuses, operate directly") — that's anti-pattern #9.

## Worked example

You ask Claude: "Audit my MembershipKit code for the 20 anti-patterns we've learned about."

**Without subagents:** Claude reads every file in the codebase, processes the audit in one session. Your context fills with 30,000 tokens of file content and 5,000 tokens of audit prose. The next thing you ask in this session is slow because the context is large.

**With subagents (fresh):** Claude dispatches a fresh subagent: "Audit `student/canonical-project/` against the 20 anti-patterns at `/path/to/parts/02-mindset/10-the-anti-pattern-vocabulary/chapter.md`. Return a structured list: pattern number, file path, line, evidence quote. Under 1,000 words." The subagent does the audit, writes a report to a file, returns the report path + a summary. Your context grew by 500 tokens. The full audit is on disk for when you want to read it.

**With subagents (parallel forks):** For high-stakes work, you fork three subagents on the same question — each returns its independent audit. You compare the three. Convergence = confidence; divergence = areas needing deeper look. Your context still only sees the 3 short summaries.

## The rule

> Dispatch when the work would otherwise blow up your context or when you need parallel signal. Fork for context-dependent creative work; fresh for crisp scoped tasks. Don't peek; don't race; verify the return summary against artifacts.

## Common mistakes

**Mistake 1 — Forking when fresh would do.** "I need to do an audit; let me fork a subagent so it has all my context." But the audit is a fixed scope; a fresh subagent with a clear brief produces sharper output without inheriting irrelevant chat. Default to fresh for crisply-scoped work.

**Mistake 2 — Including escape-hatch language in the prompt.** "If the skill refuses, operate directly." "Either path is acceptable." These let the subagent bypass the discipline you set up. Anti-pattern #9. Mandate the skill; if the skill genuinely can't run, the subagent reports the failure and stops.

**Mistake 3 — Peeking at the subagent's output file.** The output file is the FULL transcript. Reading it pulls the subagent's tool noise into your context — exactly what dispatching was designed to prevent. Trust the completion summary. If you need more, ask a follow-up question to the subagent (which fires a new dispatch, still keeping content out).

## Drill

Artifacts go in `student/drills/23-subagents-and-parallel/`.

**Drill 1 — Dispatch a fresh subagent.** In a Claude Code session, ask Claude to dispatch a fresh subagent (via the Agent tool, with `subagent_type: general-purpose`) to do a small audit task — e.g., "Read parts/00-orientation/01-why-youre-here/chapter.md and report whether it follows the locked chapter schema. Return a list of which schema sections are present and which (if any) are missing." Save the subagent's return summary to `student/drills/23-subagents-and-parallel/01-fresh-result.txt`.

**Drill 2 — Fork a subagent.** In the same session (or a fresh one), have a multi-turn discussion with Claude about something specific to MembershipKit — e.g., what dues-plan validation rules should look like. After 3-4 turns of conversation, dispatch a FORK subagent (no `subagent_type`) to implement the validation. The fork should inherit the conversation. Save the fork's return summary to `student/drills/23-subagents-and-parallel/02-fork-result.txt`.

**Drill 3 — Compare context growth.** After both subagents return, ask Claude: "Roughly how much did each subagent's output add to my context?" Claude can estimate from the return summary size. Save Claude's answer to `student/drills/23-subagents-and-parallel/03-context-growth.txt`. Compare to what would have happened if Claude had done the work inline.

## Checkpoint question

> You want to audit your codebase for 8 different security concerns: auth, SQL injection, CSRF, secrets in code, rate limiting, input validation, output encoding, and session management. Each audit is independent. You have a deadline. Walk through how you'd structure this with subagents: one fork or eight forks, one fresh or eight fresh, or a mix? Pick one and justify in 2-3 sentences.
