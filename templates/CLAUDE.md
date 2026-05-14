# CLAUDE.md

This file is the Claude Code-specific operating file for this project.

It should stay short, dense, and earned from real incidents. Generic advice belongs in subdocs. Rules whose violation must be impossible belong in hooks.

`AGENTS.md` is the vendor-neutral repo instruction file. This file adds Claude Code-specific behavior on top.

## Project

You are working on:

Purpose:

Primary user:

## Quality Bar

Code is written to acquisition-grade standards. Concretely:

- Every feature is built against an authored spec.
- Every database query is scoped to the correct tenant or ownership boundary.
- Money is stored as integer cents, never float or decimal dollars.
- Timestamps use timezone-aware storage.
- UI changes are browser-verified before completion.
- Security-sensitive paths are reviewed before completion.

Replace these bullets with project-specific rules as the system matures.

## Authority Hierarchy

Top wins:

1. The human's typed instruction in the current session.
2. Authored specs and domain rules.
3. `AGENTS.md` and this `CLAUDE.md`.
4. Current source code as evidence of existing behavior.
5. AI-authored plans, notes, summaries, and handoffs.

When spec and source disagree, source is the defendant. Do not "reconcile" by weakening the spec.

## Standing Rules

- Verify the artifact, not the summary.
- Tool output is truth; chat narration is hint.
- Fix the root cause, not the symptom.
- If blocked, either fix the blocker or stop and present the evidence.
- Do not offer technical menus to the human. Make one recommendation with reasoning.
- Do not invent time estimates or use time budget framing.
- Do not claim a UI change is complete without browser verification.
- Do not modify instruction files, hooks, MCP configs, or setup workflows unless explicitly asked.
- Use pointers, not copies: link to task-specific docs instead of pasting long guidance here.
- Do not use this file for code style rules that a formatter, linter, or typechecker can enforce.

## Forbidden

- `git reset --hard`
- `git clean -fd`
- force-push
- `git stash`
- `--no-verify`
- committing secrets
- broad refactors unrelated to the task
- changing framework or dependency versions without approval

Add project-specific forbidden operations as incidents justify them.

## MCP Protocol

If an MCP server exposes project state, query it before grepping or reading raw files.

Use raw file reads when:

- the file itself is the artifact under review
- no MCP server exposes the needed state
- the MCP result is stale or insufficient

Files remain authoritative. MCP is the precision-targeting layer.

## Linked Subdocs

Keep this file as the entry point. Put longer guidance in focused subdocs.

Examples:

- `docs/agent/building.md`
- `docs/agent/testing.md`
- `docs/agent/database.md`
- `docs/agent/security.md`
- `docs/agent/review.md`

If the active tool supports file imports such as `@path/to/file.md`, use them deliberately and keep the imported files short enough to stay readable.

## Session Protocol

At session start:

1. Confirm working directory.
2. Read this file and `AGENTS.md`.
3. Check for the latest handoff or state file if the project uses one.
4. Check `git status`.
5. For non-trivial work, map relevant files before editing.

Before claiming done:

1. Review `git diff`.
2. Run the relevant checks.
3. Browser-verify UI changes.
4. Report evidence and remaining risk.

## Handoff Protocol

For long or interrupted work, write a handoff file containing:

- current task
- files changed
- decisions made and why
- checks run
- failures or open questions
- next concrete edit

Do not rely on conversation memory or compaction summaries as durable state.

## Links

- Feedback corpus:
- Anti-pattern catalog:
- Code review protocol:
- Security boundaries:
- Project specs:
