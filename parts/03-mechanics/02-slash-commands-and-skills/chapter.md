# Chapter 20 — Slash commands and skills

## Learning objective

The student can list the built-in slash commands (`/help`, `/clear`, `/exit`, `/agents`, `/mcp`), author a simple custom skill in their fork, invoke it inside a session, and explain why a skill is "a workflow you can run by name."

## Prerequisites

- Completed: Chapter 19 — CLAUDE.md
- Concepts: what-is-claudemd, operator-as-manager

## Core concept

A **slash command** is a named action you invoke in a Claude Code session by typing `/<name>`. Some are built-in. Some you author yourself.

The built-ins you've already met:

- `/help` — list available commands
- `/clear` — clear the conversation, keep the session
- `/exit` — close the session
- `/agents` — manage subagents (later)
- `/mcp` — manage MCP servers (later)

The interesting ones are the ones YOU author. These are **skills**. A skill is a named, reusable workflow. You write a markdown file describing what the workflow does, where it lives, and what tools it uses. From then on, typing `/<your-skill-name>` invokes that workflow.

Why skills exist: anything you do TWICE in Claude is a candidate to package as a skill. "Run a security audit on the auth code." "Generate a Drizzle migration from a schema diff." "Audit a Claude session transcript for the 20 anti-patterns." Each can be a skill. Once authored, invoking the skill by name reproduces the workflow with zero re-explanation.

A skill is a folder containing a `SKILL.md` file. The folder lives at:

- `.claude/skills/<skill-name>/SKILL.md` — project-level (your fork)
- `~/.claude/skills/<skill-name>/SKILL.md` — user-global (every project)

The `SKILL.md` has YAML frontmatter (a small block with metadata) and a body (the protocol Claude follows when the skill runs).

A minimal skill:

```markdown
---
name: commit-with-context
description: Commit the currently staged changes with a message that includes the current chapter number, today's date, and a one-line summary. Use this when the student finishes a drill and wants to commit cleanly.
---

# commit-with-context

When invoked:

1. Run `git status` and confirm files are staged.
2. Read the most recent file path in the staged set to identify the chapter (e.g. `parts/02-mindset/02-the-two-option-rule/...` → chapter 10).
3. Ask the student for a one-line summary of what was done.
4. Run `git commit -m "<summary> (Ch <N>, <date>)"` with the values gathered.
5. Run `git log -1 --oneline` to confirm and show the result.

Do NOT bypass any hooks. Do NOT use `--no-verify`. If the commit fails, surface the failure verbatim and stop.
```

That's a complete skill. The frontmatter tells Claude WHEN to use this skill (description) and what it's called (name). The body tells Claude WHAT to do step by step.

To invoke: type `/commit-with-context` in a session. Claude reads `SKILL.md` and follows it. The output is consistent across runs because the protocol is encoded in the markdown — not in Claude's improvisation.

Why this matters operationally:

1. **Consistency.** Same workflow, every time. No variance.
2. **Shareable.** You can hand a skill to a friend; they get the same workflow. (Anatomy of Maxwell's project: 30 skills shared via a Git repo.)
3. **Auditable.** The skill file is the spec for the workflow. You read it; you know what's happening.
4. **Composable.** Skills can invoke other tools, including other skills. Hero-level pipelines are made of skills calling skills calling skills.

What skills are NOT for:

- One-off tasks (just ask Claude in chat).
- Things that change every time (a skill encodes a fixed pattern).
- Things that need lots of human judgment in the middle (those are conversations, not skills).

A skill works best when the workflow is repeatable and the steps don't vary much between runs.

## Worked example

You realize you've been doing the same thing five times: at the end of every chapter's drills, you run `bash parts/<part>/<chapter>/verify.sh ./student`, fix anything that fails, then commit with a message like "complete: Ch N drills". You're typing the same pattern over and over.

That's a skill candidate.

You author `.claude/skills/finish-chapter/SKILL.md`:

```markdown
---
name: finish-chapter
description: Verify the current chapter's drills, then commit the student fork with a standardized message. Use at the end of a chapter when the student has completed the drills.
---

# finish-chapter

When invoked:

1. Read student state via mcp__course-curriculum__student_state to identify the current chapter number N.
2. Compute the path to the chapter's verify.sh: parts/<part>/<chapter-folder>/verify.sh.
3. Run `bash <verify-path> ./student`. Read the exit code.
4. If exit non-zero: print the failure message; STOP. Do not commit.
5. If exit 0: stage student/ changes and run `git commit -m "Complete Chapter <N> drills"`.
6. Report the commit SHA.

If anything fails, follow the Two-Option Rule: fix or surface. Never silently skip.
```

Now from any session you type `/finish-chapter` and that whole 4-command flow runs reliably. Saved you typing; saved you forgetting a step; the verify.sh check happens EVERY time, mechanically.

## The rule

> Anything you do twice in Claude is a skill candidate. Author the skill in a single short markdown file; invoke it by name. Skills compound: as you write more, more of your day becomes a one-word invocation.

## Common mistakes

**Mistake 1 — Writing skills as essays.** A skill body that's 800 words of prose explaining philosophy is unusable. Claude can't extract the steps reliably. Skills are protocols, not blog posts. Numbered steps; concrete actions.

**Mistake 2 — Skills with too much variability.** "Generate a feature based on the user's input." That's just chat. A skill should encode a fixed flow with clear steps. If every invocation produces wildly different work, you don't have a skill, you have a chat.

**Mistake 3 — Forgetting the YAML frontmatter.** Without the `description` field, Claude doesn't know WHEN to use the skill. Without the `name` field, you can't invoke it. Frontmatter is required, not optional.

## Drill

Artifacts go in your fork. The skill is a real, working skill.

**Drill 1 — Author a starter skill.** Create the folder `.claude/skills/finish-chapter/` in your fork. Write a `SKILL.md` inside it with the frontmatter (name + description) and a numbered body. The skill's purpose: verify the current chapter's drills (`bash parts/.../verify.sh ./student`) and commit if it passes. You can copy the structure from the worked example above but write it in your own voice.

**Drill 2 — Invoke your skill.** Start a Claude Code session in your fork. Type `/finish-chapter`. Watch Claude follow the protocol. Save Claude's session output (the sequence of tool calls + final result) summary to `student/drills/20-skills/01-invocation-log.txt`. (Snapshot of the session is fine; don't paste an entire transcript.)

**Drill 3 — Author a second, different skill.** Pick another small workflow you've done at least twice in this course (examples: "summarize the last 5 chapters I completed," "show me my feedback corpus stats"). Author it as `.claude/skills/<your-skill-name>/SKILL.md`. Document the workflow in 5-10 numbered steps. Save the skill's path to `student/drills/20-skills/02-second-skill.txt`.

## Checkpoint question

> You author a skill called `/security-audit` that's supposed to look at your auth code, identify issues, and report them. Three weeks later you notice the skill has been doing slightly different things each time — sometimes thorough, sometimes shallow, sometimes skipping the password-policy check. Diagnose what's likely wrong with the `SKILL.md` file, and name two specific changes you'd make to it.
