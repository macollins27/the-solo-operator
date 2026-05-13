# Chapter 24 — The session lifecycle

## Learning objective

The student can describe the four phases of a Claude Code session (start, work, compaction or wind-down, exit), recognize when context is filling up, write a handoff doc that allows a future session to resume work cleanly, and decide when to exit-and-restart vs continue.

## Prerequisites

- Completed: Chapter 23 — Subagents and parallel work
- Concepts: context-window-finite, conversation-turns

## Core concept

Every Claude Code session moves through four phases:

**Phase 1 — Start.** You `cd` into a project. You run `claude`. Claude reads CLAUDE.md, registers MCP servers, loads any project skills, and presents a prompt. Fast. Free. The session's context starts at maybe 5-15k tokens (system prompt + config files).

**Phase 2 — Work.** You and Claude do the thing. Each turn adds tokens — your messages, Claude's replies, tool calls and their outputs, file contents Claude read. The context grows. Linear cost per turn at first; the slope is shallow if you're disciplined about what enters context.

**Phase 3 — Compaction or wind-down.** Eventually the context approaches the model's window limit. Claude Code does **compaction** — it summarizes older turns to make room for new work. Compaction is lossy. Details from earlier turns can disappear. You'll see a "Compacting conversation..." message; the session continues, but the texture is different. (Wind-down is the alternative: you `/exit` voluntarily before compaction. Same shape, different trigger.)

**Phase 4 — Exit.** You `/exit`. The conversation ends. The context is gone. Any state worth persisting needs to be on disk by now — a file you wrote, a row in your student.db, a commit. Anything still only in the conversation is lost.

The operator skill is reading where you are in the cycle and acting accordingly:

**Early in a session (Phase 2, low context).** Be generous with reads, exploration, and discussion. Cheap.

**Mid-session (Phase 2, growing context).** Be deliberate. Don't `Read` files Claude doesn't need. Don't paste big blobs of content. Use MCP queries over file reads where possible.

**Late session (approaching Phase 3).** Decide: is the next thing best done in this session, or in a fresh one? If you're done with a task, COMMIT WHAT YOU HAVE before the context compacts. If you need to keep going on something complex, WRITE A HANDOFF DOC describing where you are, then `/exit` and restart fresh.

A handoff doc is short — 1-2 paragraphs plus a list of files involved and the next concrete action. It lives at a known path (e.g. `student/state/handoff-<date>.md`). When you start a fresh session, your first action is "read the latest handoff doc" — and Claude is oriented in seconds without your needing to re-explain anything.

A typical handoff doc:

```markdown
# Handoff — 2025-05-13 evening

## Where we are
Building the dues-plan-create form in MembershipKit. Schema is in place
(migration committed: sha abc1234). Form skeleton exists at
`student/canonical-project/app/(admin)/plans/new/page.tsx` but
validation is missing.

## Next concrete action
Add Zod validation to the form: monthlyAmountCents must be a positive
integer; planName required; billingInterval must be 'monthly' or
'annual'. After validation, wire up the submit handler to call
`api.plans.create.mutate(...)`.

## Open questions
- Should the plan name be unique within an org? Decision pending.
- Currency: USD-only for v1, or multi-currency support? Out of scope
  for now per spec.md line 47.

## Files involved
- student/canonical-project/app/(admin)/plans/new/page.tsx
- student/canonical-project/lib/validators/plans.ts (to create)
- docs/spec.md (reference)
```

Five minutes to write. Saves 30 minutes of re-orientation on the next session.

When to exit and restart vs continue:

**Continue when:** the task is close to done, you're on a productive trajectory, the context is below ~50% of the window. The cost of restarting (lost trajectory + handoff-doc time) outweighs the cost of continuing.

**Exit and restart when:** the conversation has drifted noticeably; Claude is getting confused or repeating things; you've used parallel subagents and your main thread has a lot of summary residue; the context is past ~70% of the window. Restart is cheaper than wrestling a polluted session.

**Always commit before exit.** Anything not in Git is fragile. The discipline becomes habit: end-of-session = git status, git add, git commit. If there's nothing committable, write a handoff doc and exit.

## Worked example

You've been working on the dues-payment feature for two hours. You've made real progress: schema, API route, form skeleton. Validation is half-done. Context is 60% full. You're about to step away for the day.

**Bad pattern.** You `/exit` without saving state. Tomorrow you start a fresh session, ask Claude to "pick up where we left off," and you spend the first 45 minutes re-explaining — and missing details that were only in the prior session's working memory.

**Good pattern.** Before `/exit`:

1. `git status` — see what's uncommitted. Stage everything that's ready.
2. `git commit -m "Add dues-plan schema + form skeleton; validation in progress"`.
3. Write `student/state/handoff-2025-05-13.md` describing where you are, what's next, open questions.
4. `/exit`.

Tomorrow, fresh session, first message: "Read student/state/handoff-2025-05-13.md and tell me what the next concrete edit is." Claude orients in seconds. You start producing within a minute, not 45.

## The rule

> Sessions are bounded. Anything not on disk at exit is gone. End each session with a clean commit and (if work remains) a short handoff doc at a known path. Start each session by reading the most recent handoff. The handoff doc is your project's session-to-session memory.

## Common mistakes

**Mistake 1 — Not committing before exit.** You `/exit` with uncommitted work. Next session, Claude reads the working tree and finds half-finished changes with no context. The handoff is implicit and unreliable. Always commit (or stash if you must — but Maxwell's discipline bans stash for this reason).

**Mistake 2 — Wrestling a compacted session.** The session has compacted twice; Claude is forgetting things. You keep going. You spend 30 minutes re-establishing context that compaction lost. Cheaper to `/exit`, write a handoff if needed, and restart fresh with the relevant context surfaced from disk.

**Mistake 3 — Writing handoff docs no one reads.** You write the handoff doc; future-you doesn't read it because future-you forgot it exists. The fix: put a line in `CLAUDE.md` instructing Claude to look for the most recent file in `student/state/` at session start. Now every session reads the handoff automatically.

## Drill

Artifacts go in your fork. The handoff doc is real.

**Drill 1 — Write a handoff doc.** At the end of a real session (or right now, simulating end-of-session), author `student/state/handoff-<today's-date>.md`. Include: Where we are, Next concrete action, Open questions, Files involved. Save the path of the handoff doc to `student/drills/24-session-lifecycle/01-handoff-path.txt`.

**Drill 2 — Read it back in a fresh session.** Open a NEW Claude Code session in your fork. Your first message: "Read the most recent file in student/state/ and tell me what the next concrete edit is." Save Claude's response to `student/drills/24-session-lifecycle/02-fresh-orientation.txt`. Note how long it took (in turns) to be productively oriented vs how long it would have without the handoff.

**Drill 3 — Add the handoff-read instruction to CLAUDE.md.** Edit your `student/CLAUDE.md` (from Chapter 19). Add a line in the standing-rules or a new section saying something like: "At session start, after loading rules, read the most recent file in student/state/ if one exists." Save the diff/snippet to `student/drills/24-session-lifecycle/03-claudemd-update.txt`.

## Checkpoint question

> Three sessions in a row, you've ended in the middle of a complex feature without writing a handoff. The fourth session you sit down and Claude is wildly confused about what you're building. Walk through what to do in the immediate term (this session) AND in the longer term (across future sessions) to fix this. Two answers, one for each timeframe.
