# Chapter 52 — Operating in the Wild: MCP and tool ergonomics

## Learning objective

The student can design or audit an MCP tool contract so an agent can choose it correctly, call it safely, interpret its result, and verify its output.

## Prerequisites

- Completed: Chapter 51 — Operating in the Wild: governance and cost controls
- Concepts: mcp-tool-contract-design, lethal-trifecta, workflow-eval

## Core concept

Tools are contracts between deterministic systems and nondeterministic agents.

A normal program calls an API because a developer wrote the sequence. An agent chooses whether to call a tool, which tool to call, what parameters to pass, and how to use the result. If the tool contract is vague, the agent guesses.

Good tool contracts have six properties:

**Clear name.** `decisions_query(topic)` beats `search(query)` when many servers expose search. Namespacing is not style; it helps the agent choose.

**Unambiguous parameters.** `decision_id` beats `id`. `organization_id` beats `org`. Parameters should encode the shape the tool expects.

**Workflow-shaped granularity.** Too granular forces the agent to sequence raw API calls it may not understand. Too coarse hides checkpoints. One tool should answer one operator question with enough evidence to verify.

**Token-efficient response.** Return the answer, ids, source paths, timestamps, confidence or match score when useful, and next lookup handles. Do not dump whole files unless the tool's job is to fetch full content.

**Safety contract.** State whether the tool is read-only, destructive, idempotent, open-world, externally communicating, or permissioned. Treat annotations as hints, not security boundaries.

**Verification path.** The result should include enough evidence that the agent or operator can verify it: source record id, file path, command to rerun, or audit log entry.

Production MCP also needs operations: per-user auth, least-privilege tokens, rate limits, schema validation, idempotency keys, logging, versioning, and rollback. Local stdio servers are good for fast private workflows. Remote servers are useful for shared services, but they increase auth, network, and governance requirements.

## Worked example

Weak tool:

```text
name: search
description: Search things.
parameters:
  q: string
```

Better tool:

```text
name: decisions_query
description: Search operator-authored decision records by topic. Use this before reading raw decision files when the user asks about prior rulings.
parameters:
  topic: string
  limit: integer, default 5
response:
  decisions: [{ decision_id, title, summary, rationale, source_path, decided_at }]
  no_match_guidance: string
safety:
  read_only: true
  external_communication: false
```

The better version tells the agent when to call it, what to pass, what it gets back, and how to verify the answer.

## The rule

> Design tools for the agent as the caller: clear name, precise parameters, workflow-shaped granularity, token-efficient output, safety contract, and verification path.

## Common mistakes

**Mistake 1 — API-shaped tools.** You expose every backend endpoint one-to-one. The agent must infer the workflow sequence and misses required intermediate checks.

**Mistake 2 — Giant "do everything" tools.** One tool performs search, mutation, notification, and cleanup. The agent loses checkpoints and the operator loses review boundaries.

**Mistake 3 — Vague names in a crowded toolset.** Five tools named `search` compete. The agent guesses and then stitches unrelated results together.

**Mistake 4 — Treating annotations as enforcement.** `readOnlyHint` helps the model choose, but it is not a permission boundary. The server and API must enforce safety.

**Mistake 5 — No eval after tool changes.** You rewrite descriptions and assume agents will behave better. Run comparable tasks before and after, then score tool choice, parameter correctness, and result handling.

## Drill

Artifacts go in `student/drills/52-mcp-tool-ergonomics/`.

**Drill 1 — Audit a tool contract.** Pick one MCP tool you use or could imagine for your project. Using `templates/mcp-tool-contract.md`, describe its name, purpose, parameters, response shape, safety contract, and verification path. Save to `student/drills/52-mcp-tool-ergonomics/01-tool-contract.md`.

**Drill 2 — Improve ergonomics.** Rewrite one weak part of the tool: name, description, parameter, response, or safety contract. Explain what agent mistake the rewrite prevents. Save to `student/drills/52-mcp-tool-ergonomics/02-ergonomics-improvement.txt`.

**Drill 3 — Write a tool eval.** Write a small eval task that would prove the agent chooses the right tool and uses its response correctly. Include pass/fail criteria. Save to `student/drills/52-mcp-tool-ergonomics/03-tool-eval.txt`.

## Checkpoint question

> Your MCP server has tools named `search`, `get`, `update`, and `send`. The agent keeps calling the wrong one and sometimes sends external messages before review. Answer in 4-5 sentences: what is wrong with the tool contracts, how you would rename or reshape them, what safety boundary belongs in the server, and what eval would prove improvement.

<!-- Rewriter audit trail
Universalization pass: adds MCP/tool ergonomics, granularity, namespacing, safety contracts, production operations, and eval-driven tool-description improvement.
Rewrite date: 2026-05-13
-->
