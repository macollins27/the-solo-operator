# Universal AI Agent Course Roadmap

This roadmap upgrades The Solo Operator's Manual from a Claude Code-centered course into a universal AI agent operating course.

Core position:

> This course teaches universal AI agent operation. Claude Code is the primary lab bench. The operating principles transfer to Codex, Cursor, Aider, Copilot, Gemini CLI, and whatever comes next.

## Decision

Keep the current 44 chapters as Core v1.

The current course already teaches the hard part:

- operator vs prompter
- artifact truth
- spec authority
- zero deferral
- root cause over bandaid
- memory discipline
- hooks, skills, MCP, subagents
- trust calibration

Do not rewrite that spine. Add the universal layer around it.

## Universal Layer

Add a new Part 7: `Operating in the Wild`.

Part 7 teaches the concepts students need after the core course, when they meet other tools, larger teams, real security boundaries, cost limits, and public agent workflows.

## Required Part 7 Chapters

### 1. Course Origin and Public Canon

Teach that this course is a field manual extracted from sustained real operation. That is its strength and its bias.

Include:

- honest origin framing
- Boris Cherny reference workflow
- Simon Willison daily-driver patterns
- Obra Superpowers
- Anthropic engineering canon
- why public workflows are references, not doctrine

Suggested line:

> This course is not a neutral survey. It is a field manual extracted from sustained real operation. Treat the principles as operating defaults to test, not scripture to copy.

### 2. Context Engineering

Teach context engineering as the named discipline that replaces shallow "prompt engineering."

Core operations:

- offload: move state out of chat into files, databases, MCP, specs
- reduce: compress or summarize without losing authority
- retrieve: load relevant context just in time
- isolate: separate work across sessions, subagents, and worktrees

Also teach:

- context poisoning
- context distraction
- context confusion
- context clash
- bounded investigation prompts

### 3. Agent Stack and Instruction Architecture

Teach the responsibility boundaries between agent primitives.

Cover:

- `AGENTS.md`
- `CLAUDE.md`
- directory-level instructions
- skills
- hooks
- MCP
- plugins
- harnesses
- subagents and agent teams

Rule:

Use the right primitive at the right layer. A behavioral constraint that must be impossible belongs in a hook, not a prose rule. A repeated workflow belongs in a skill, not repeated chat text.

### 4. Plan Mode, SDD, and Task Contracts

Teach planning as a reviewable artifact, not deferral.

Cover:

- when planning is mandatory
- when to skip planning
- Goal / Context / Constraints / Done When
- Spec-driven development spectrum
- four-part subagent contract:
  - objective
  - output format
  - tool/source guidance
  - task boundaries
- fresh-agent plan review for high-risk work

### 5. Task, Interface, and Model Selection

Teach students to choose the smallest surface that can do the job.

Cover:

- autocomplete
- chat
- local agent
- subagent
- background agent
- automation
- three-tier model routing
- cost-quality tradeoffs

Three-tier model routing should be taught vendor-neutrally:

- small/fast model for classification, extraction, formatting, simple review
- workhorse model for normal implementation and debugging
- strongest model for architecture, unfamiliar codebases, hard diagnosis, and high-risk planning

### 6. Codebase Preparation and TDD With AI

Teach that agent performance is bounded by repo readiness.

Cover:

- setup checklist
- verbose failure output
- seed data
- CI-equivalent commands
- browser verification
- verification ladder
- test quality
- TDD with AI

Required TDD phrase:

```text
Write a FAILING test for this behavior. Do NOT write implementation yet.
```

Advanced pattern:

- red subagent writes failing tests from spec only
- green subagent writes minimum implementation to pass tests
- refactor subagent improves structure with tests as constraint

### 7. Parallel Work and Worktrees

Teach worktrees as first-class isolation for parallel write work.

Rules:

- parallel read-only audits may share a checkout
- parallel write work needs isolated file states
- worktrees isolate files and branches
- worktrees do not isolate ports, databases, environment variables, or external services
- practical concurrency is limited by review capacity

Required existing-course fix:

Resolve the Chapter 34 tension where a mature hook blocks `git worktree`. Make the ban project-specific or add an orchestrator-approved exception path.

### 8. Security Boundaries and the Lethal Trifecta

Teach the lethal trifecta as the central agent-security frame.

The dangerous combination:

- access to private data
- exposure to untrusted content
- an external communication path

The repair is structural. Remove or constrain at least one leg at the tool, API, environment, or review layer. Do not pretend prompt instructions solve it.

Callbacks must appear in MCP, plugin, browser/tool, and automation lessons.

### 9. Review, Governance, and Auditability

Teach agent work as auditable engineering work.

Cover:

- code review protocol
- AI-ready tickets
- structured PR descriptions
- agent-authored vs AI-reviewed vs AI-committed work
- protected primitive files
- team and solo audit trails

Rule:

Agent-authored code passes the same gates as human-authored code. If anything, it needs stricter gates until trust is earned mechanically.

### 10. Learning Loops and Workflow Evals

Teach recursive system improvement.

Cover:

- feedback files
- `learnings.md`
- CLAUDE.md promotion
- LLM-as-judge
- evaluator bias
- workflow evals
- manual -> skill -> stable repeat -> automation

Rule:

Do not automate workflows that still need steering.

## Existing Chapters To Patch

Patch before writing Part 7 so the new layer fits naturally.

| Chapter | Patch |
|---|---|
| Ch. 6 | Add context engineering vocabulary and four operations. |
| Ch. 12 | Add verification ladder and TDD with AI. |
| Ch. 19 | Add AGENTS.md split, pointers-not-copies, style-in-linters, instruction limits. |
| Ch. 22 | Add MCP minimalism and tool ergonomics. |
| Ch. 23 | Add worktrees for parallel write work. |
| Ch. 24 | Add two-corrections-then-reset and lost-context check. |
| Ch. 32 | Add mature AGENTS.md / CLAUDE.md / subdoc architecture. |
| Ch. 35 | Add MCP curation, granularity, namespacing, trust boundaries. |
| Ch. 37 | Add four-part dispatch contracts and effort scaling. |
| Ch. 38 | Add cost, fatigue, measurement, and model-routing concepts. |
| Ch. 43 | Add universal agent maturity ladder. |

## Templates

The reusable template kit lives in `templates/`.

Required templates:

- `AGENTS.md`
- `CLAUDE.md`
- `code_review.md`
- `agent-setup-checklist.md`
- `ai-ready-ticket.md`
- `security-boundaries.md`
- `workflow-eval.md`

These are starter shapes, not authority. The student authors their final versions from their project and incidents.

## Appendices To Add

Add or expand appendices:

- Public Reference Workflows and Reading Canon
- Agent Tool Landscape
- Agent Security and Red-Teaming
- MCP Design Notes
- Failure-Mode Taxonomies

## Launch Gates

Before public student use:

- every chapter follows schema
- every drill produces an artifact
- every `verify.sh` fails on missing and empty artifacts
- every checkpoint tests transfer, not memorization
- glossary covers new terms
- contradiction scan passes:
  - no menus vs interview me first
  - no time estimates vs cost budgets
  - MCP federation vs MCP minimalism
  - parallel subagents vs worktree safety
  - plan-first vs planning as deferral
  - hooks vs protected primitive files
- beta tested with:
  - total beginner
  - technical but agent-new
  - experienced AI user with bad habits

## Artifact Graduation

Students should leave with:

- `student/AGENTS.md`
- `student/CLAUDE.md`
- feedback corpus
- at least one skill
- at least one hook
- at least one MCP query result
- at least one handoff/state file
- code review protocol
- AI-ready ticket
- security boundary file
- workflow eval

## Current Execution Order

1. Patch templates.
2. Patch existing chapters.
3. Add Part 7 skeleton.
4. Write Part 7 chapters.
5. Add `meta.yml` and `verify.sh`.
6. Update glossary and appendices.
7. Run full audit.
8. Beta test.

