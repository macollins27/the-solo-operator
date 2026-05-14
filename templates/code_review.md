# Code Review Protocol

Use this file as reusable review instructions for AI-authored or human-authored changes.

The reviewer should find bugs, regressions, security issues, missing tests, and scope drift. The reviewer should not rewrite code unless explicitly asked.

## Inputs

- Diff or commit under review:
- Base branch or prior commit:
- Relevant spec:
- Relevant issue/ticket:
- Commands already run:

## Review Rules

- Review the artifact, not the summary.
- Treat tests passing as one signal, not proof.
- Prefer concrete findings with file paths and line numbers.
- Do not invent risk. If evidence is incomplete, say what is missing.
- Do not ask for stylistic changes unless they affect correctness, maintainability, security, or agreed project conventions.

## Passes

### 1. Scope

- Does the diff implement only the requested outcome?
- Are there unrelated refactors, dependency changes, or file moves?
- Did the agent modify instruction files, hooks, config, or setup workflows without approval?

### 2. Correctness

- Does the behavior match the spec?
- Are edge cases handled?
- Are errors handled at the right layer?
- Is the root cause fixed rather than hidden?

### 3. Security

- Are authorization checks enforced in code or database, not only in prompts or UI?
- Are secrets excluded from logs, commits, prompts, and audit rows?
- Is untrusted input treated as data, not instructions?
- Are tenant or ownership boundaries enforced in queries?

### 4. Tests

- Do tests prove behavior, not just coverage?
- Do tests include boundary values, error cases, and regression cases?
- Did the change weaken or delete tests?
- Are mocks hiding useful failure signals?

### 5. Data and Migrations

- Are migrations reversible or intentionally one-way?
- Are constraints enforced in the database where appropriate?
- Are indexes correct for soft deletes and tenant scope?
- Is audit logging transactional for state changes?

### 6. UI and Accessibility

- Was the UI checked in a browser?
- Does the behavior match the spec, not just compile?
- Are loading, empty, error, and success states handled?
- Are labels, focus, keyboard, and screen-reader basics preserved?

### 7. Performance and Cost

- Does the change add unbounded queries, loops, AI calls, or network calls?
- Are expensive paths rate-limited or cached?
- Is output bounded?

### 8. Maintainability

- Is the implementation consistent with local patterns?
- Are abstractions justified by real duplication or complexity?
- Are comments useful and current?
- Is the change easy to revert if needed?

### 9. Hidden Deferrals

Look for phrases or code shapes that mean work was deferred:

- "for now"
- "TODO" without owner or reason
- "temporary"
- "follow-up"
- "out of scope" added after discovery
- broad try/catch around unknown failures
- mocks that silence warnings

## Output Format

Return:

```markdown
## Findings

- [P0/P1/P2/P3] Title
  File: path:line
  Evidence:
  Why it matters:
  Suggested fix:

## Checks Reviewed

- Command:
- Result:

## Residual Risk

Anything not verified and why.
```

If no issues are found, say that clearly and name any remaining test or verification gaps.

