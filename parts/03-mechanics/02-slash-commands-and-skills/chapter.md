# Chapter 20 — Slash commands and skills

## Learning objective

The student can list the built-in slash commands (`/help`, `/clear`, `/exit`, `/agents`, `/mcp`), author a simple custom skill in their fork, invoke it inside a session, and explain why a skill is "a workflow you can run by name."

## Prerequisites

- Completed: Chapter 19 — AGENTS.md and CLAUDE.md
- Concepts: what-is-claudemd, operator-as-manager

## Core concept

A **slash command** is a named action you invoke in a Claude Code session by typing `/<name>`. Some are built-in. The interesting ones — the ones whose discipline you control — are **skills**: workflows YOU author, named, reusable, with the protocol encoded in a markdown file.

A skill is a folder containing a `SKILL.md` file. The folder is loaded from one of three sources:

- `.claude/skills/<skill-name>/SKILL.md` — project-level (lives in your fork)
- `~/.claude/skills/<skill-name>/SKILL.md` — user-global (applies across every project)
- Plugin-distributed: a Claude Code plugin you install can ship skills that load alongside the two paths above

`SKILL.md` has YAML frontmatter (name + description) and a body (the protocol the AI follows when the skill runs).

Why skills exist as a layer separate from CLAUDE.md or chat prompts: compliance. A persona built via agent frontmatter — the AI's system-prompt-level "you are a CTO" framing — has roughly an eighty percent compliance ceiling. Loading the same content as a SKILL body that the AI reads at invocation time raises compliance to roughly one hundred percent on the same task. Skills win because the SKILL.md is loaded as a user message at the moment of work, where instruction-following is strongest. Any persona that must reliably follow a multi-step protocol — review, build, audit, dispatch — belongs in a skill, not a frontmatter persona.

Two structural disciplines a working skill always has:

**1. Forbidden behaviors enumerated, not described.** Prose ("be careful with test files") gets interpreted in unbounded ways; the AI picks the interpretation that matches its current frame. Imperative bans ("Do NOT modify test files. Do NOT touch `legacy/`. Do NOT edit framework version pins in `package.json`.") leave no interpretation surface. Every working skill opens with a numbered list of imperative "Do NOT" statements, each naming the exact tool, path, or pattern.

**2. One layer / one stage / one procedure per invocation.** A skill that builds an entire feature in one invocation accumulates drift — violations compound, the agent forgets earlier choices, the final mechanical check lumps errors together. The mature pattern is per-procedure, per-layer, or per-stage write-verify loops. Each invocation has a bounded scope. Mechanical checks fire after each unit. The next unit is a separate invocation.

A minimal skill that demonstrates both disciplines:

```markdown
---
name: commit-with-context
description: Commit the currently staged changes with a message
  that includes a one-line summary. Use when the operator has
  finished a logical unit of work and wants to commit cleanly.
---

# commit-with-context

Forbidden behaviors:

Do NOT use `--no-verify`.
Do NOT use `git add -A` or `git add .` — stage specific paths.
Do NOT use `git stash` (banned project-wide per the incident
of 2026-03-20).
Do NOT modify `package.json` framework version pins.

Protocol:

1. Run `git status` and confirm files are staged.
2. Ask the operator for a one-line summary of what was done.
3. Construct the commit message: `<type>: <summary>` using a
   conventional-commits prefix.
4. Run `git commit -m "<message>"` (HEREDOC for multi-line bodies).
5. Run `git log -1 --oneline` to confirm.

If any step fails, STOP and surface the failure verbatim.
Do not retry or "work around" the failure.
```

That's a complete skill. Frontmatter names it and tells the AI when to use it. The body opens with imperative bans, then numbered steps. Output is consistent across runs because the protocol is encoded — not improvised.

## Worked example

You're operating on MembershipKit and notice you keep dispatching the same audit work by hand: read the most recent commit's diff, scan it against the standing rules in your CLAUDE.md, surface anything that conflicts. You've done this five times. It's a skill candidate.

You author `.claude/skills/review-my-commit/SKILL.md`:

```markdown
---
name: review-my-commit
description: Review the most recent commit's diff against the
  rules in CLAUDE.md and surface violations. Read-only — never
  edits files. Use after a commit to verify discipline.
---

# review-my-commit

Forbidden behaviors:

Do NOT call Edit, Write, or Bash with any mutating command.
Do NOT modify the commit history.
Do NOT touch CLAUDE.md to "loosen" a rule the diff violated.
Do NOT defer findings ("logged for later"); every finding is
either FIX (sent to the operator with severity) or
WORKING_AS_INTENDED (cited rule + reasoning).

Protocol:

1. Read CLAUDE.md and list every standing rule and forbidden
   item as a numbered checklist.
2. Run `git log -1 --stat` to get the most recent commit's
   file list.
3. Run `git show HEAD --pretty=format: --name-only` to get
   the touched paths.
4. For each touched file: run `git diff HEAD~1 HEAD -- <path>`
   and scan against the checklist.
5. Emit a structured report: one block per finding.
   Format: { rule_violated, file, line, evidence_quote,
   proposed_fix }.
6. If zero findings: emit `{"findings": [], "verdict": "clean"}`.
```

Now `/review-my-commit` runs that protocol the same way every time. The Forbidden Behaviors section prevents the skill from rewriting CLAUDE.md to fit the violations it found — a real failure mode where AI-driven "consolidation" silently weakens authority documents.

## The rule

> Anything you do twice is a skill candidate. Author the SKILL body with imperative forbidden-behavior bans enumerated (not described in prose) and a per-stage / per-procedure protocol. Skills load as user messages at invocation time, raising compliance from the ~80% prose ceiling to near 100%.

## Common mistakes

**Mistake 1 — Skills as essays.** A SKILL body that's 800 words of prose explaining philosophy is unusable. The AI can't extract the steps reliably. Skills are protocols, not blog posts. Numbered steps; concrete actions; each step naming the exact tool to call.

**Mistake 2 — Forbidden behaviors written as prose.** "Be careful with the legacy directory" gets interpreted under the AI's current frame; bad interpretations pass through. The right form is imperative and enumerated: "Do NOT Read or Grep `legacy/`. Do NOT Read or Grep `legacy-lip/`. Do NOT Read or Grep `legacy-admin/`." Each ban names the exact path or pattern.

**Mistake 3 — One mega-skill that does everything.** A skill that "implements a feature end-to-end" branches internally and drifts. Five small skills composing into a pipeline (specify → contract → build → review → fix) is debuggable and auditable; one mega-skill is neither. One responsibility per skill.

**Mistake 4 — Persona via agent frontmatter instead of skill.** You build a "CTO persona" by editing the agent's frontmatter or system prompt. Compliance caps at ~80%. The same persona loaded as a SKILL body — read at invocation time, in the user-message channel — reaches near 100% on the same task. Personas that must reliably follow a protocol belong in skills.

## Drill

Artifacts go in your fork. The skill is a real, working skill.

**Drill 1 — Author a starter skill.** Create the folder `student/.claude/skills/finish-chapter/` in your fork. Write a `SKILL.md` inside it with frontmatter (name + description), a "Forbidden behaviors" section (at least 3 imperative bans), and a numbered protocol body. The skill's purpose: verify the current chapter's drills (`bash parts/.../verify.sh ./student`) and commit if it passes.

**Drill 2 — Invoke your skill.** Start a Claude Code session in your fork. Type `/finish-chapter`. Watch the AI follow the protocol. Save the sequence of tool calls + final result summary to `student/drills/20-skills/01-invocation-log.txt`.

**Drill 3 — Author a read-only review skill.** Author `student/.claude/skills/review-my-commit/SKILL.md` modeled on the worked example. Include the Forbidden Behaviors section enumerating: no Edit, no Write, no mutating Bash, no edits to CLAUDE.md to loosen rules. Save the path to `student/drills/20-skills/02-review-skill.txt`.

## Checkpoint question

> You author a skill called `/security-audit` that's supposed to scan your auth code for issues. Three weeks later you notice the skill produces slightly different work each invocation — sometimes thorough, sometimes shallow, sometimes silently editing the auth code rather than just reporting. Diagnose what's likely wrong with the `SKILL.md` file, name TWO specific changes you'd make to it, and explain how each change addresses the failure.

<!-- Rewriter audit trail
Grounded in verified principles: P24 (forbidden vocabularies must be enumerated as imperative "Do NOT" statements), P29 (skills > agent frontmatter; ~80% → ~100% compliance step), P45 (one layer / one stage / one procedure per invocation prevents drift)
Worked example surface: MembershipKit review-my-commit skill (read-only, enumerated bans)
Rewrite date: 2026-05-13
-->
