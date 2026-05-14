# Chapter 19 — AGENTS.md and CLAUDE.md

## Learning objective

The student can write a portable `AGENTS.md`, layer a Claude-specific `CLAUDE.md` on top, and verify that the active agent is following the rules they wrote.

## Prerequisites

- Completed: Chapter 18 — The Anti-Pattern Vocabulary
- Concepts: spec-as-authority, four-rank-authority-hierarchy, operator-as-manager

## Core concept

An **instruction file** is a markdown file an AI coding agent reads before it works in a repository. It gives the agent project facts it cannot infer safely from code alone: how to run checks, what rules matter, what not to touch, and which documents are authoritative.

`AGENTS.md` is the vendor-neutral instruction file. Use it for rules that should follow the repo across Claude Code, Codex, Cursor, Aider, Copilot, Gemini CLI, or any future agent that supports the standard. `CLAUDE.md` is the Claude Code-specific overlay. Use it for Claude-only commands, slash-command habits, Claude hooks, Claude MCP names, and Claude-specific recovery language. The portable base goes in `AGENTS.md`; the tool-specific layer goes in `CLAUDE.md`.

Claude Code reads `CLAUDE.md` at session start. It can exist at three scopes: project root (`./CLAUDE.md`), per-directory (a nested `CLAUDE.md` inside a subfolder, loaded when work touches that subtree), and user-global (`~/.claude/CLAUDE.md`, loaded in every project you open). The project-root file is what you'll author first.

The prose authority layer has a known compliance ceiling. Behavioral rules in prose hold roughly seventy to eighty percent of the time. Use instruction files for standing context, authority hierarchy, and rules that do not yet warrant mechanical enforcement. Rules whose violation must be impossible belong in hooks.

What goes in instruction files:

**1. Identity and quality bar.** Project name, what the AI is operating on, and measurable quality rules. Numbers, not aspirations.

**2. Standing rules from incidents.** One line each, declarative, actionable. Every line was earned from a specific moment something went wrong. Dates and incident references stay on the line — they are the audit trail for the next reader (or the next AI) asking "why is this rule here?"

**3. The authority hierarchy.** Explicit. Operator-authored specification ranks first. Source code is behavioral truth about current state, not authority over what should happen. AI-authored documents are evidence, not authority.

**4. References to feedback corpus + subdocs.** The root instruction file is the entry point, not the manual. It links to deeper docs the agent reads on demand.

**5. Forbidden behaviors.** Specific items the AI has tried, the operator has caught, and the operator wants enforced even at the prose-rule layer. Each entry names the exact tool, path, or pattern banned.

The shape that works: short, dense, scannable, one-line rules. Pointers, not copies. Put stable rules in the root, then point to task-specific subdocs. Mature files grow from incidents; yours starts small.

Refuse bloat, code-style prose that belongs in linters/formatters, and AI-authored authority documents. The AI may draft; the operator owns every line that ships.

## Worked example

You author the portable base at `student/AGENTS.md`:

```markdown
# MembershipKit — Agent instructions

MembershipKit is a community membership manager.

Authority hierarchy:

1. My typed instructions in the current session
2. Spec / domain-rules files in docs/specs/
3. The current shipped code (behavioral truth, not authority)
4. AI-authored intermediate documents (evidence, not authority)

When spec and source disagree, source is wrong. "Reconcile" is not a verb.

Checks:

- Run typecheck before claiming done.
- Browser-validate every UI change before claiming done.
- Review the diff for scope creep, hidden deferral, and missing tests.

Forbidden:

- `--no-verify` on commits
- `as any` type assertions
- `parseFloat` / `toFixed` on money values
```

Then add only Claude-specific behavior at `student/CLAUDE.md`:

```markdown
# MembershipKit — Project rules

Read AGENTS.md first. This file adds Claude Code-specific behavior on top.

Standing rules:

- Two-option rule: fix it or stop and present. Never silently continue.
- No time estimates anywhere — no "this will take N hours," no
  "Phase 2 (~10 minutes)."
- Browser-validate every UI change via Playwright MCP before claiming done.

Forbidden:

- `git stash` (lost work incident; never use)
- `Math.random()` for tokens, ids, or anything security-relevant
```

The overlay is short because `AGENTS.md` already carries the portable rules.

## The rule

> `AGENTS.md` is the portable prose authority layer; `CLAUDE.md` is the Claude-specific overlay. Keep both short, pointer-based, and operator-authored. Rules whose violation must be impossible go in hooks instead.

## Common mistakes

**Mistake 1 — Writing instruction files as essays.** A 5,000-word root instruction file is unscannable. The rules drown in prose. The AI pattern-matches the conclusion and ignores the details. Mature files are dense: one-liners, explicit numbers, explicit paths. Prose explanations go in subdocs.

**Mistake 2 — Letting the AI author authority files for you.** `AGENTS.md` and `CLAUDE.md` are authority documents. An AI-authored authority document is a category error in the four-rank hierarchy — downstream AI artifacts are evidence about past reasoning, not authority over current decisions. You author them yourself, even if you ask the AI to draft a starting outline. Then you cut, rewrite, sign.

**Mistake 3 — Skipping the promotion ladder.** A rule that has bitten you three times across CLAUDE.md is signaling that prose enforcement isn't holding. The right response is mechanical promotion — a hook, an ast-grep rule, an addition to the anti-pattern classifier catalog. Leaving the rule in CLAUDE.md and re-stating it louder is anti-pattern #15 (still in prose after the bite recurred).

**Mistake 4 — Bloat without trim.** The file grows to 2,000 lines as you add rules. You never run a consolidation pass. The dense top of the file is buried under the accumulated middle. Run consolidation periodically (Chapter 42); trim aggressively; preserve superseded rules with the SUPERSEDED marker rather than deleting.

**Mistake 5 — Sending prose to do a linter's job.** "Always format with project style" belongs in a formatter command and a hook, not as a paragraph in `CLAUDE.md`. Instruction files tell the agent which checks exist; deterministic tools enforce style.

## Drill

Artifacts go in your fork at the project root (`student/AGENTS.md` and `student/CLAUDE.md`) — yes, this drill produces REAL instruction files, not just drill artifacts.

**Drill 1 — Author your first instruction pair.** At the root of your fork, in a folder called `student/`, create `student/AGENTS.md` and `student/CLAUDE.md`. Put portable project rules, checks, and authority hierarchy in `AGENTS.md`. Put Claude-specific commands, hooks, MCP names, or session habits in `CLAUDE.md`. Include at minimum: a one-line project description, 3 standing rules, the four-rank authority hierarchy, and a "Forbidden" section with at least 2 entries.

**Drill 2 — Verify Claude reads them.** Open Claude Code in your fork. In the FIRST message of the session, ask: "Read my AGENTS.md and CLAUDE.md, then summarize the operating rules back to me — what am I operating under in this project?" Save Claude's response to `student/drills/19-claudemd/01-claude-summary.txt`. Confirm Claude correctly summarized YOUR rules (not generic ones).

**Drill 3 — Add a rule from a bite.** Find one of the feedback files you authored in Chapter 16. Promote ONE of its rules into `student/AGENTS.md` if it is portable, or `student/CLAUDE.md` if it is Claude-specific. Save the updated file and write a 2-sentence summary of which rule you promoted and why to `student/drills/19-claudemd/02-promoted-rule.txt`.

## Checkpoint question

> You add a portable rule to `AGENTS.md`: "Never use the `Math.random()` function for anything related to security or auth — use `crypto.randomUUID()` or a proper secure random source instead." A week later you find an agent wrote `const token = Math.random().toString(36)` in your auth code. Did the instruction file fail? Walk through what to check, in order, before deciding whether to move the rule, sharpen its phrasing, or promote to mechanical enforcement (a hook, linter, or ast-grep rule).

<!-- Rewriter audit trail
Grounded in verified principles: P21 (mechanical enforcement beats behavioral rules; ~70-80% prose compliance ceiling), P9 (authority hierarchy; source has zero authority; "reconcile" is not a verb), P8 (artifact is evidence; AI-authored docs are evidence not authority), P40 (authority-document editing as cross-skill channel), P56 (SUPERSEDED marker for superseded files)
Worked example surface: MembershipKit project-level CLAUDE.md skeleton
Rewrite date: 2026-05-13
-->
