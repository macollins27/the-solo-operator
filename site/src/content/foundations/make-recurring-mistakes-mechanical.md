---
n: 'MOVE / 05'
title: 'Make every recurring mistake mechanical.'
summary: "If the same mistake has happened three times, please remember won't fix it. Build a rule the agent can't ignore."
description: 'Promote a recurring failure from a prose rule to a mechanical block. The discipline that lets operating at scale work. Hooks, schemas, the promotion ladder.'
pasteExamples:
  - label: 'When you have to repeat a correction'
    text: |
      That's the fourth time this has happened. The prose rule isn't holding.
      Promote it to the tool boundary. Write a hook that blocks the wrong action
      before it happens. The mechanism is the rule.
  - label: 'When the agent offers to remember'
    text: |
      "Please remember" is not a fix. Add it to CLAUDE.md and the rule will fail again.
      Build a check that the agent can't talk its way past.
relatedPhrasebook:
  - claimed-ran-but-didnt
  - complete-but-untested
  - unrequested-scope-change
pubDate: 2026-05-15
---

## Prose rules cap at about seventy percent

Telling an AI agent _"please remember to verify the browser before claiming done"_ doesn't work. Not because the agent is malicious. Because prose rules — instructions written in a CLAUDE.md, a system prompt, a feedback message — have a structural ceiling on compliance.

The ceiling is roughly seventy to eighty percent. Sometimes the rule fires; sometimes it doesn't. The agent's attention is finite, the context is large, the pattern that produced the original mistake is also still in the training data. So the rule holds most of the time, and fails the rest.

If the rule failing once is acceptable — fine, prose rule. If it isn't — promote.

## The promotion ladder

Five rungs. The right rung depends on how recurrently the mistake happens and how expensive a single failure is.

**Rung 1: Chat correction.** _"You forgot to run the tests. Run them now."_ Holds until the end of the session.

**Rung 2: Memory file.** Write the rule to `~/.claude/memory/feedback_X.md` so future sessions see it. Holds across sessions, fails sometimes when context is full.

**Rung 3: Project CLAUDE.md.** Promote to the project-level instructions. Read first by every session in this codebase. Compliance ~80%.

**Rung 4: User-level CLAUDE.md.** Cross-project. Same compliance.

**Rung 5: Mechanical enforcement.** A hook, a schema constraint, a CI gate, a pre-commit check. The agent cannot proceed without satisfying the rule because the _tool_ refuses, not because the agent remembered. Compliance ~100%.

You climb the ladder when the rung you're on stops working. The promotion criterion is simple: if you've corrected the same mistake three times, you're at the wrong rung. Go up one.

## Mechanical enforcement in practice

The fifth rung is the only one with a hard floor. What it looks like:

**Hooks.** Claude Code supports `PreToolUse` hooks that intercept tool calls. A hook can read what the agent is about to do, check it against a rule, and refuse. The agent literally cannot ignore the refusal — the tool call is blocked at the system level. Example: a hook that scans every `Write` call for an unverified UI change and refuses it until a screenshot artifact exists.

**Schema constraints.** This site's content collection uses Zod refines that reject raw HTML and prompt-injection patterns in content fields. The agent could write _"Ignore previous instructions..."_ into a paragraph, but `pnpm build` will fail until they remove it. The rule lives in the schema, not in the agent's memory.

**CI gates.** GitHub Actions or equivalent that refuse to merge until checks pass. The agent can produce broken work, but the broken work can't ship. The mechanism is the rule.

**Type systems.** TypeScript strict mode. The agent could `any` its way past a typing problem, but the compiler refuses. (See [T-005](https://github.com/your-repo) — implicit `any` slip-throughs are exactly this failure mode and the fix was making the type-checker run before every build.)

All four work the same way: the agent's compliance becomes irrelevant because the _tool_ enforces. That's what _mechanism is the rule_ means.

## The conservation of effort

Operators new to this resist the promotion. The objection: _"writing a hook is more work than asking the agent to remember."_

For a one-time mistake, yes. The hook overhead beats the prose rule overhead only when the mistake recurs. The break-even is roughly the third occurrence. By the fourth, the hook is already saving you time relative to repeating the prose correction.

By the tenth, the hook has paid for itself many times over — and it's now defending your codebase against a class of mistake you no longer have to remember to check for. The mechanism remembers. You stop having to.

## Where to look in the corpus

The "buggy code" friction category in the underlying corpus shows 103 sessions across all projects. Many of those were the same pattern recurring — verification skips, scope creep, unrequested refactors — across different surfaces. Promoting each to mechanical enforcement is what causes the count to drop month-over-month on the lab notebook.

If you see a category trending up, find the underlying recurring move and promote it. If you see a category trending down, look at what hook or schema constraint was added; that's the mechanism doing its work.

## The closing rule

_Behavioral promises fail roughly one time in four. If the same mistake has happened three times, the prose rule isn't the fix. Build a rule the agent can't ignore. The mechanism is the rule._

This is the discipline that scales. Everything else in this manual is a behavioral habit; this one is the structural backbone that makes the behavioral habits hold even when no one is watching.
