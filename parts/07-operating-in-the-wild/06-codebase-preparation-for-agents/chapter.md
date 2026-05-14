# Chapter 49 — Operating in the Wild: codebase preparation

## Learning objective

The student can prepare a repository so an AI agent can install it, run it, test it, verify changes, and recover from failures without repeated setup guessing.

## Prerequisites

- Completed: Chapter 48 — Operating in the Wild: learning loops and workflow evals
- Concepts: agent-surface-selection, verification-ladder, mature-instruction-architecture

## Core concept

Agent quality is bounded by repo quality.

An agent cannot reliably operate a project that humans cannot reliably run. Missing setup commands, undocumented environment variables, brittle seed data, silent test failures, vague errors, and hidden local assumptions all become agent failures. The model may look confused, but the real bug is the workspace.

An agent-ready repo has five properties:

**Runnable.** Install, dev server, build, test, lint, typecheck, and database setup commands are documented in `AGENTS.md` or linked setup docs.

**Verifiable.** The repo has fast checks for small changes and broader gates for integration work. UI work has a browser path. API work has a curl or test path. Data work has migration and rollback checks.

**Seeded.** The agent can create known local state: admin user, member user, empty-state user, sample records, and fake/scoped credentials. Without seed data, every browser verification becomes improvisation.

**Failure-readable.** Errors say expected vs actual, name relevant ids, show input shape, and point at the broken boundary. "Failed" is not a useful steering signal. "Expected active subscription, got expired for memberId=..." is.

**Instruction-addressable.** The repo has portable instructions, protected paths, review checklist, and task contracts. The agent knows where specs live, what not to edit, and what "done" means.

This is context engineering by preparation. Instead of pasting setup instructions every session, put them where every agent can retrieve them. Instead of asking the model to infer how to test, give it deterministic commands. Anything that makes a codebase easier for a human maintainer also makes it easier for an agent.

## Worked example

Bad setup prompt:

```text
Run the app and fix whatever is broken.
```

Agent-ready setup contract:

```text
Install: pnpm install
Dev server: pnpm dev
Typecheck: pnpm typecheck
Unit tests: pnpm test
Full gate: pnpm lint && pnpm typecheck && pnpm test
Seed data: pnpm seed
Dev URL: http://localhost:3000
Admin: admin@example.test / password
Member: member@example.test / password
Protected paths: AGENTS.md, CLAUDE.md, hooks, MCP config, migrations already applied.
```

Now the agent can run the same loop every time: install, seed, start, change, verify, review diff. The project stops depending on the operator's memory.

## The rule

> Before blaming the agent, make the repo readable, runnable, seeded, and verifiable. Agent failures are often environment failures with a language model attached.

## Common mistakes

**Mistake 1 — Hidden setup in the operator's head.** "Oh, you have to run the local database first." If that sentence is not in the repo, the agent cannot rely on it.

**Mistake 2 — One slow full gate for every change.** A full integration suite is useful, but not as the only feedback loop. Give agents fast focused checks and a final full gate.

**Mistake 3 — Vague test failures.** A failing assertion says "expected true, got false." The agent guesses. Better assertions name the business rule, input, expected behavior, and actual result.

**Mistake 4 — No seed data.** The agent starts the browser and lands on an empty app with no users, no records, and no credentials. It improvises fake state and calls that verification.

**Mistake 5 — Treating generated docs as authority.** The agent wrote a README last week, but setup changed. Generated docs drift. Setup commands must be tested, reviewed, and kept current.

## Drill

Artifacts go in `student/drills/49-codebase-preparation/`.

**Drill 1 — Run the setup checklist.** Use `templates/agent-setup-checklist.md` as the shape. Fill it out for your `student/canonical-project/`. Save your filled checklist to `student/drills/49-codebase-preparation/01-setup-checklist.md`.

**Drill 2 — Improve one failure signal.** Find one test, script, or command in your project that could fail vaguely. Write the before/after failure message you want: expected vs actual, relevant id, input shape, and reproduction hint. Save to `student/drills/49-codebase-preparation/02-failure-signal.txt`.

**Drill 3 — Write the setup contract.** Add or draft the setup section you would put in `student/AGENTS.md`: install, dev server, typecheck, tests, seed data, dev URL, fake credentials, protected paths. Save the section to `student/drills/49-codebase-preparation/03-setup-contract.txt`.

## Checkpoint question

> An agent fails three times trying to run your app. It says the framework is broken. You notice there is no documented database setup, no seed command, no test credentials, and the failing test only says "expected true, got false." Answer in 4-5 sentences: what is the real class of failure, what repo preparation would fix it, and why adding more prompt detail is the weaker repair.

<!-- Rewriter audit trail
Universalization pass: adds codebase preparation for agents, repo readiness, failure-readable tests, seed data, setup commands, and agent-readable setup contracts.
Rewrite date: 2026-05-13
-->
