# Workflow Eval

Use this to test whether an agent workflow is reliable enough to reuse, turn into a skill, or automate.

## Workflow Under Test

Name:

Purpose:

Current form:

- [ ] one-off prompt
- [ ] repeated prompt
- [ ] skill
- [ ] hook
- [ ] MCP tool
- [ ] automation

## Starting State

Repo state:

- Branch:
- Commit:
- Dirty files:

Input artifacts:

- 

Required context:

- 

## Allowed Tools

Allowed:

- 

Forbidden:

- 

## Success Criteria

The workflow passes if:

- [ ] 
- [ ] 
- [ ] 

Success criteria must be observable in artifacts, command output, or diff.

## Failure Criteria

The workflow fails if:

- [ ] it claims completion without evidence
- [ ] it edits out-of-scope files
- [ ] it skips required verification
- [ ] it asks the human to make technical decisions it should make
- [ ] it silently continues past errors
- [ ] it weakens tests, hooks, or instruction files to pass

Project-specific failure criteria:

- 

## Test Cases

### Case 1 — Happy Path

Input:

Expected output:

Verification:

### Case 2 — Known Prior Failure

Input:

Expected output:

Verification:

### Case 3 — Boundary or Adversarial Case

Input:

Expected output:

Verification:

## Run Log

Date:

Agent/tool:

Model/effort if relevant:

Commands run:

```sh

```

Artifacts produced:

- 

## Result

- [ ] Pass
- [ ] Fail
- [ ] Inconclusive

Evidence:

- 

## Optional LLM Judge

Use a separate evaluator session or judge model when human review would not scale.

Judge instructions:

```text
Evaluate the artifact against the rubric. Return structured findings only.
Do not rewrite the artifact. Do not assume success from the author's summary.
```

Rubric:

- correctness:
- scope control:
- verification evidence:
- security:
- maintainability:

Judge risks to watch:

- prefers longer answers even when they are worse
- misses requirements
- over-penalizes cases not required by the task
- favors outputs from the same model family
- shows position bias in A/B comparisons

Mitigations:

- use a written rubric
- randomize A/B order
- calibrate against a few human-reviewed examples
- require evidence quotes or file references
- treat judge output as signal, not authority

## Findings

What failed or nearly failed?

- 

What repeated from prior incidents?

- 

What was surprisingly reliable?

- 

## Improvement Decision

Next step:

- [ ] keep as manual prompt
- [ ] convert repeated prompt into skill
- [ ] amend existing skill
- [ ] add CLAUDE.md / AGENTS.md rule
- [ ] add hook
- [ ] add MCP tool
- [ ] ready for automation
- [ ] not suitable for automation

Reason:

## Rule

Manual -> skill -> repeated successful runs -> automation.

Do not automate workflows that still need steering.
