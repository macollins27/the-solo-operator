# AI-Ready Ticket

Use this format for issues, tasks, or prompts assigned to an AI coding agent.

## Goal

What should change?

## User Outcome

What should the user be able to do after this is complete?

## Context

Relevant background:

- Existing behavior:
- Desired behavior:
- Why this matters:

## Relevant Files

Known files:

- `path/to/file`

If the exact files are unknown, tell the agent to find them and report the map before editing.

## Constraints

- Do not change unrelated behavior.
- Do not change dependency versions unless explicitly required.
- Do not edit instruction files, hooks, MCP configs, or CI workflows.
- Follow existing project patterns.
- Keep the diff small and reviewable.

Project-specific constraints:

- 

## Acceptance Criteria

The task is complete when:

- [ ] 
- [ ] 
- [ ] 

Acceptance criteria should describe behavior, not implementation guesses.

Bad:

- "Add tests."

Better:

- "Add a test proving a canceled subscription cannot access paid content after grace-period expiry."

## Verification

Commands to run:

```sh

```

Browser/API checks:

- 

Expected evidence:

- command output
- screenshot
- API response
- database row
- diff summary

## Out of Scope

Explicitly not included:

- 

If the agent discovers an out-of-scope issue, it should surface it with evidence and severity. It should not silently fix or silently ignore it.

## Review Risks

Pay special attention to:

- authorization
- data integrity
- migrations
- edge cases
- UI state
- performance/cost
- hidden deferrals

## Agent Instructions

Before editing:

1. Read the relevant spec and files.
2. Report the file map and intended edit plan.
3. Proceed only when the plan is concrete.

Before completion:

1. Run verification.
2. Review the diff.
3. Report evidence and residual risk.

