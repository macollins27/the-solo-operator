# Agent Setup Checklist

Use this before asking an AI agent to work in a repository.

The goal is to make the repo readable, runnable, and verifiable by an agent without repeated setup guessing.

## Project Identity

- Project name:
- What it does:
- Primary user:
- Main stack:
- Package manager:
- Runtime version:
- Database:
- Deployment target:
- Default agent/tool:
- Default model/effort:

## Required Files

- [ ] `AGENTS.md` exists.
- [ ] Tool-specific instruction file exists if needed.
- [ ] README explains local setup.
- [ ] Specs or product rules exist.
- [ ] Environment example exists, such as `.env.example`.
- [ ] Test command is documented.
- [ ] Dev server command is documented.
- [ ] Database setup is documented.
- [ ] Seed data is documented.

## Commands

Install:

```sh

```

Run dev server:

```sh

```

Run unit tests:

```sh

```

Run integration tests:

```sh

```

Run typecheck:

```sh

```

Run lint:

```sh

```

Run format check:

```sh

```

Run full gate:

```sh

```

## Environment

- [ ] Required env vars are listed.
- [ ] Development values are safe.
- [ ] Production secrets are never pasted into agent context.
- [ ] Local database URL is documented.
- [ ] Test credentials are fake or scoped.
- [ ] External services have test mode instructions.

## Model and Cost Routing

Set defaults before work starts.

- [ ] Small/fast model for classification, extraction, formatting, routing, and simple review.
- [ ] Workhorse model for normal implementation, debugging, and code review.
- [ ] Strongest model for architecture, unfamiliar codebases, hard diagnosis, and high-risk planning.
- [ ] Cost or usage limits are known.
- [ ] Long-running/background work has explicit stop conditions.

Project defaults:

```text
Small/fast:
Workhorse:
Strongest:
Max spend/usage:
```

## Seed Data

Document how to create a local state the agent can test against.

```sh

```

Expected seed users:

- Admin:
- Member:
- Empty-state user:

## Browser Verification

Dev URL:

```text
http://localhost:3000
```

Critical flows:

- [ ] Sign up
- [ ] Sign in
- [ ] Sign out
- [ ] Main dashboard
- [ ] Most important feature flow

## Parallel Work Isolation

- [ ] Parallel write work uses separate worktrees, checkouts, or equivalent isolated file states.
- [ ] Parallel read-only audits may share a checkout.
- [ ] Each worktree or checkout has a plan for ports, env vars, databases, and external services.
- [ ] Review capacity is considered before launching parallel agents.

Notes:

```text

```

## Failure Output

Good tests and commands explain failures.

Check:

- [ ] Test failures show expected vs actual.
- [ ] API errors include useful local debugging information.
- [ ] Logs name relevant ids, input shape, and failing boundary.
- [ ] CI failures can be reproduced locally.

## Protected Surfaces

Agents should not casually edit:

- [ ] instruction files
- [ ] hooks
- [ ] MCP configs
- [ ] CI workflows
- [ ] dependency versions
- [ ] database migrations already applied
- [ ] auth/security code

Add project-specific protected paths:

```text

```

## Done

The repo is agent-ready when a fresh agent can:

- install dependencies
- run the app locally
- run the test/check commands
- find the relevant specs
- know what files not to touch
- verify a change without asking the human for missing setup
