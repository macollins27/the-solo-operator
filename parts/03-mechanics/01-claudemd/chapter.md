# Chapter 19 — CLAUDE.md

## Learning objective

The student can write their own `CLAUDE.md` for the MembershipKit project, place it at the right path so Claude Code reads it at session start, and verify that Claude is following the rules they wrote.

## Prerequisites

- Completed: Chapter 18 — The Anti-Pattern Vocabulary
- Concepts: spec-as-authority, five-rank-authority-hierarchy, operator-as-manager

## Core concept

`CLAUDE.md` is the file Claude Code reads at the start of every session in a project. It's how you tell Claude how YOUR project works — rules, conventions, what to do, what not to do — without re-explaining every time you open a new session.

The file is just plain markdown. It can live in two places that matter:

- **Project-level**: `CLAUDE.md` in the root of your project (your fork of the course repo). Reads on every session in that project.
- **Per-directory**: `CLAUDE.md` in any subfolder of your project. Reads when Claude is working in that subtree.

There's also a user-global one at `~/.claude/CLAUDE.md` for rules you want across every project on your machine. You won't need that yet.

What goes in `CLAUDE.md`:

**1. Standing rules for this project.** Things like "every commit message must mention the relevant chapter," "no time estimates in plans," "use tRPC for all API calls, not raw fetch." Each rule is one line, declarative, actionable.

**2. Authority hierarchy.** A small block that says "my typed instructions outrank everything; my spec files in `docs/` outrank generated docs; Claude-authored intermediate documents have lowest authority."

**3. References to your feedback corpus.** Links to your `student/feedback/` folder. Claude reads `CLAUDE.md` at session start; if it mentions your feedback files, Claude knows where to look for rules you've authored from past incidents.

**4. Stack conventions.** What language, framework, packages. Useful so Claude doesn't suggest things that don't fit. Example: "We use Drizzle, not Prisma. Don't suggest Prisma. Don't use `prisma` in any file path."

**5. Forbidden behaviors.** Specific failure modes you want to block. Operators add to this list every time something bites them. Examples: "Never use `as any`," "Never wrap code in `try/catch` without a logged error type," "Never silently skip a failing test."

What does NOT go in `CLAUDE.md`:

- Long essays about software philosophy (use docs/ for that)
- Auto-generated content (Claude rewriting CLAUDE.md is a yellow flag — you author this file)
- Time-sensitive notes ("for this week we're doing X")
- Anything that would be wrong if it ran in a fresh session 6 months from now

The shape that works: short, scannable, declarative. Operators have CLAUDE.md files of 50-200 lines. Each line earns its keep. If a rule isn't getting enforced, the rule isn't there or isn't clear enough — and you sharpen it.

A typical CLAUDE.md skeleton:

```markdown
# Project rules

You are working on MembershipKit, a community membership manager.

## Standing rules

- Spec is truth; output is defendant.
- Two-option rule: fix it or stop and present.
- Never use time estimates.
- Decisions belong to me; propose ONE recommendation with reasoning, not menus.
- Verify the artifact, not the summary.

## Authority hierarchy (top wins)

1. My typed instructions in the current session
2. Spec files in docs/
3. The actual shipped code
4. Generated documentation
5. Claude-authored intermediate documents

## Stack

- Next.js (App Router)
- TypeScript strict
- Postgres + Drizzle (NOT Prisma)
- Better Auth
- Vitest

## Forbidden

- `as any` or any type assertion without a sentence-justification
- `try/catch` without a specific error type and a log statement
- Silent test skips
- Touching `canonical-project/` (the reference); only `student/canonical-project/` is mine

## My feedback corpus

See student/feedback/INDEX.md for rules authored from incidents.
```

That's a real CLAUDE.md. Yours will start simpler and grow.

Claude reads this at session start automatically — no command needed. You verify by asking Claude in a fresh session: "What rules am I operating under in this project?" Claude should be able to summarize the file back to you. If it can't, the file isn't being read (wrong path, wrong name) or your rules are too vague to summarize.

## Worked example

Session 1 — Without `CLAUDE.md`:

You: "Add an auth-protected route at `/dashboard`."

Claude: scaffolds the route. Picks NextAuth (you wanted Better Auth). Adds Prisma queries (you use Drizzle). Inserts `console.log` debug statements (you forbid those).

Session 2 — Same task with `CLAUDE.md`:

(Claude reads `CLAUDE.md` at session start — sees Better Auth, Drizzle, no `console.log`.)

You: "Add an auth-protected route at `/dashboard`."

Claude: scaffolds the route. Uses Better Auth's `getSession`. Drizzle query. No `console.log`. Asks before adding any new dependency.

Same task, two paths. The CLAUDE.md is where you encode "how my project works" once, so you don't have to repeat it 50 times.

## The rule

> CLAUDE.md is your project's standing instructions. Author it, place it at the project root, keep it short and declarative. Every rule earns its keep; every recurring annoyance becomes a new line; the file grows with you. Without it, every session starts from zero; with it, sessions start from your accumulated knowledge.

## Common mistakes

**Mistake 1 — Writing CLAUDE.md as an essay.** A 5,000-word CLAUDE.md is unscannable. Claude reads it but the rules drown in prose. Keep rules short, declarative, one per line. If a rule needs a paragraph of explanation, the explanation goes in `docs/`; only the rule itself goes in CLAUDE.md.

**Mistake 2 — Letting Claude write CLAUDE.md for you.** Tempting to delegate. Don't. CLAUDE.md is your authority document; an AI-authored authority document is a category error (Chapter 17 hierarchy). Author it yourself, even if you ask Claude to draft a starting outline.

**Mistake 3 — Forgetting to update it.** A bite happens. You write a feedback file. You don't promote the rule into CLAUDE.md when it's repeated multiple times. Claude keeps making the same family of mistake because the rule isn't where Claude can see it. The link from feedback corpus → CLAUDE.md is where rules become enforced.

## Drill

Artifacts go in your fork at the project root (`student/CLAUDE.md`) — yes, this drill produces a REAL CLAUDE.md, not just a drill artifact.

**Drill 1 — Author your first CLAUDE.md.** At the root of your fork, in a folder called `student/`, create the file `student/CLAUDE.md`. Include at minimum: a one-line description of your project, 3 standing rules (pick from the 10 mindset principles in Part 2), the 5-rank authority hierarchy, and a "Forbidden" section with at least 2 entries.

**Drill 2 — Verify Claude reads it.** Open Claude Code in your fork. In the FIRST message of the session, ask: "Summarize the rules in my CLAUDE.md back to me — what am I operating under in this project?" Save Claude's response to `student/drills/19-claudemd/01-claude-summary.txt`. Confirm Claude correctly summarized YOUR rules (not generic ones).

**Drill 3 — Add a rule from a bite.** Find one of the feedback files you authored in Chapter 16 (you have at least one). Promote ONE of its rules into your `student/CLAUDE.md` — copy the actionable rule into the "Standing rules" or "Forbidden" section. Save the updated `CLAUDE.md` and write a 2-sentence summary of which rule you promoted and why to `student/drills/19-claudemd/02-promoted-rule.txt`.

## Checkpoint question

> You add a rule to your `CLAUDE.md`: "Never use the `Math.random()` function for anything related to security or auth — use `crypto.randomUUID()` or a proper secure random source instead." A week later you find Claude wrote `const token = Math.random().toString(36)` in your auth code. Did your CLAUDE.md fail? Walk through what to check, in order, before deciding whether to re-author the rule, sharpen its phrasing, or add mechanical enforcement (a hook).
