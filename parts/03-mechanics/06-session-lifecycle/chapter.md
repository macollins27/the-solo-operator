# Chapter 24 — The session lifecycle

## Learning objective

The student can describe the four phases of a Claude Code session (start, work, compaction or wind-down, exit), recognize when context is filling up, write a handoff doc that allows a future session to resume work cleanly, and decide when to exit-and-restart vs continue.

## Prerequisites

- Completed: Chapter 23 — Subagents and parallel work
- Concepts: context-window-finite, conversation-turns

## Core concept

Every Claude Code session moves through four phases.

**Phase 1 — Start.** You open the project. The AI reads instructions, registers tools, loads skills, and presents a prompt.

**Phase 2 — Work.** You and the AI do the thing. Every turn adds tokens — your messages, the AI's replies, tool calls and their outputs, file contents Read.

**Phase 3 — Compaction or wind-down.** Eventually context fills. Compaction replaces older turns with a summary. **Compaction is lossy**: decision reasons, corrections, deleted files, and active-vs-historical memory frequently disappear.

**Phase 4 — Exit.** Anything not on disk by exit is gone. The conversation is not recoverable.

The protection is **write memory BEFORE compaction**. Before a long session compacts, write a memory file covering files changed/deleted, current task state, decisions with reasons, open questions, and gotchas. Commit it.

Trusting a post-compaction summary as truth has shipped defects. Treat it as a hint and re-derive facts from disk.

After compaction, do a **lost-context check**: modified files, deleted files and why, open decisions, failing tests, commands run, spec constraints, known bugs, next concrete edit. Verify against disk and Git. If fuzzy, restart from the handoff.

A handoff doc is durable memory: short, dense, known path, read first next session. Example:

```markdown
# Handoff — 2026-05-13 evening

Where we are:
Building the dues-plan-create form. Schema committed. Form skeleton exists; validation is missing.

Next concrete edit:
Add validation: monthlyAmountCents positive integer; planName required; billingInterval monthly or annual. Wire submit handler.

Architectural decisions made (and why):
- Money stored as integer cents (bigint), not decimal. Reason:
  float ambiguity. Locked.
- Plan deletion soft-deletes via deletedAt timestamptz, never
  hard delete. Reason: sync-readiness for future mobile clients.

Files involved:
- student/canonical-project/app/(admin)/plans/new/page.tsx
- student/canonical-project/lib/validators/plans.ts (to create)
- docs/spec.md (reference)

Gotchas:
- The existing migration uses bigint, not numeric. Don't
  introduce numeric anywhere.
```

When to exit and restart vs continue:

**Continue** when the task is close to done, the session is coherent, and context is below ~50%.

**Exit and restart** when conversation drifts, the AI repeats, you've corrected the same mistake twice, subagent residue pollutes the thread, or context is past ~70%.

**Always commit before exit.** Anything not in Git is fragile. If there's nothing committable, write a handoff and exit.

## Worked example

You've been working on the dues-payment feature for two hours. Real progress: schema, API route, form skeleton. Validation is half-done. Context is 60% full. You're about to step away for the day.

**Bad pattern.** You exit without saving state. Tomorrow you start a fresh session, ask the AI to "pick up where we left off," and spend the first 45 minutes re-explaining — and missing details only the prior session held.

**Good pattern.** Before exit:

1. `git status` — see what's uncommitted. Stage specific files.
2. `git commit -m "Add dues-plan schema + form skeleton; validation in progress"`
3. Write `student/state/handoff-2026-05-13.md` covering: where you are, next concrete edit, architectural decisions with reasons, files involved, gotchas.
4. Exit.

Tomorrow, fresh session, first message: "Read `student/state/handoff-2026-05-13.md` and tell me what the next concrete edit is." The AI orients in seconds. You produce within a minute.

If the session had compacted instead of being cleanly exited, the same handoff doc protects you. The post-compaction summary may have lost the architectural-decision rationale; the handoff doc has it. You re-derive facts from the durable file rather than trusting the lossy summary.

## The rule

> Sessions are bounded. Anything not on disk at exit (or before compaction) is gone. Write a handoff doc covering files-changed-and-why, current task state, architectural decisions with reasons, open questions, gotchas. Commit. Trust the handoff file; treat post-compaction summaries as hints and re-derive facts from on-disk authority.

## Common mistakes

**Mistake 1 — Trusting a post-compaction summary as truth.** "The summary captures the key decisions." It captures what the auto-summarizer guessed mattered, optimized for keeping the agent functional. Corrections, deleted files, architectural rationale, and active-vs-historical memory frequently disappear. The fix is durable on-disk memory written BEFORE compaction; the handoff doc is the manual version.

**Mistake 2 — No commit before exit.** Uncommitted work at exit becomes ambient state the next session reads without context. The next AI sees half-finished diffs with no story; the implicit handoff is unreliable. Always commit (specific paths, not `git add -A`).

**Mistake 3 — Handoff docs that no one reads.** You write the handoff; future-you forgets it exists. The fix is structural: a line in CLAUDE.md instructing the AI to look for the most recent file in `student/state/` at session start, or a SessionStart hook that prints "latest handoff: <path>" at the top of the session. The doc only pays off if it's consulted.

**Mistake 4 — Wrestling a compacted session past the trust break.** The session has compacted twice; the AI is forgetting things and repeating itself. You keep going. You spend thirty minutes re-establishing context that compaction lost. Cheaper to exit, write the handoff, restart fresh.

**Mistake 5 — Arguing after two failed corrections.** You correct the same issue twice and keep pushing in the same thread. The failed approaches are now part of the context and can become poison. Stop, write the current facts to disk, restart with a tighter prompt and the verified artifact paths.

## Drill

Artifacts go in your fork. The handoff doc is real.

**Drill 1 — Write a handoff doc.** At the end of a real session (or right now, simulating end-of-session), author `student/state/handoff-<today's-date>.md`. Include: Where we are, Next concrete edit, Architectural decisions made (and why), Files involved, Gotchas. Save the path to `student/drills/24-session-lifecycle/01-handoff-path.txt`.

**Drill 2 — Read it back in a fresh session.** Open a NEW Claude Code session in your fork. Your first message: "Read the most recent file in student/state/ and tell me what the next concrete edit is." Save the AI's response to `student/drills/24-session-lifecycle/02-fresh-orientation.txt`.

**Drill 3 — Add the handoff-read instruction to CLAUDE.md.** Edit `student/CLAUDE.md`. Add a line in the standing-rules section or a new section saying something like: "At session start, after loading rules, read the most recent file in student/state/ if one exists." Save the diff to `student/drills/24-session-lifecycle/03-claudemd-update.txt`.

## Checkpoint question

> Three sessions in a row you've ended in the middle of a complex feature without writing a handoff. The fourth session you sit down and the AI is wildly confused about what you're building. Walk through what to do in the immediate term (this session) AND in the longer term (across future sessions) to fix this. Include the lost-context check you would run, and name what specifically the post-compaction summary is missing that a handoff doc would have preserved.

<!-- Rewriter audit trail
Grounded in verified principles: P57 (memory before compaction; never trust post-compaction summaries; post-compaction agents inherit a partial picture and re-invoke deleted tools), and informed by P5 (tool output is truth; chat narration and stale state files are hints), P6 (trust git over agent narrative)
Worked example surface: MembershipKit dues-payment feature handoff before end-of-day exit
Rewrite date: 2026-05-13
-->
