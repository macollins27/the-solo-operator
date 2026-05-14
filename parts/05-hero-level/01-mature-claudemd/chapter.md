# Chapter 32 — Hero level: mature instruction architecture

## Learning objective

The student can read and explain mature `AGENTS.md` / `CLAUDE.md` architecture, recognize which rules belong in which layer, and identify which sections of their own instruction files came from real operating incidents.

## Prerequisites

- Completed: Chapter 31 — Practice: The audit log
- Concepts: what-is-agentsmd, what-is-claudemd, four-rank-authority-hierarchy, corpus-as-moat

## Core concept

A mature instruction architecture — authored, broken, sharpened, and consolidated over months — looks different from the one you wrote in Chapter 19. Yours is correct but young. A mature one shows the shape that emerges when rules survive reality.

The shape is consistent enough across mature projects to be teachable:

**Root portable file — AGENTS.md.** Cross-tool base: identity, quality bar, authority hierarchy, build/test commands, protected paths, and durable project rules.

**Tool overlay — CLAUDE.md.** Claude-specific behavior: slash commands, hook names, MCP tool names, session habits, compaction rules. It points back to `AGENTS.md`; it does not duplicate the base.

**Identity and quality bar.** Measurable targets, not "high quality": org predicates, integer cents, timestamp type, file caps, forbidden schema shortcuts.

**Incident-authored standing rules.** Twenty to fifty single-line rules, each earned from a specific moment:

- "Never edit framework versions (Next.js, React, TS) without explicit approval."
- "Never bypass git hooks (--no-verify)."
- "Never use `git stash` (banned after 2026-03-20 incident: 20+ commits lost)."
- "Never produce time estimates in plans, dispatches, or work products."
- "No `z.any()`, `z.unknown()`, or `.passthrough()` in Zod input schemas."

Dates and incident references are load-bearing. They explain why a rule exists and prevent future readers from treating it as arbitrary.

**Authority hierarchy.** Operator spec ranks first. Code is behavioral truth, not authority. AI-authored plans are evidence only. When spec and source disagree, source is wrong.

**Process discipline.** The pipeline: spec → contract → build → review → gate → QA → fix. The file names the workflow so the AI does not improvise it every session.

**What never happens.** Exact tool/path/pattern bans, with dates where the rule is incident-born:

- "Never use `git stash` (lost 20+ commits, March 2026)."
- "Never silently continue past an error (Two-Option Rule)."
- "Never offer 'stopping point' / 'natural pause' / 'rest is execution' language."
- "Never edit framework versions without approval."

**Links to subdocs.** A mature root file points to per-package instructions, anti-pattern catalog, feedback index, domain rules, and testing patterns. The root file is the entry point, not the manual.

**Deterministic enforcement.** Code style, formatting, and type correctness belong in formatters, linters, typecheckers, and hooks. The instruction file names the command; the tool enforces the rule.

**SUPERSEDED audit trail.** Replaced rules are marked with date, successor path, and reason. The marker tells agents not to follow the old rule while preserving evidence.

**Length.** Mature root files can reach 200-400 dense lines. Bloat is vague prose, duplicated rules, and no subdoc links.

## Worked example

You audit your instruction files and notice:

- Your `AGENTS.md` has 5 standing rules. The reference has 24.
- Your `CLAUDE.md` repeats half of `AGENTS.md` instead of only adding Claude-specific behavior.
- Your forbidden section has 3 entries and no dates.
- Your reference paths are absent.
- Your files have no incident-dated rules.
- Your files have no SUPERSEDED markers.

The fix is operational: every time something bites you, add a one-liner to the right layer. Portable rule? `AGENTS.md`. Claude-specific rule? `CLAUDE.md`. Deterministic rule? formatter, linter, typechecker, or hook.

For replaced rules, mark the old version SUPERSEDED with date, successor path, and reason. Do not delete the audit trail.

## The rule

> Mature instruction architecture is portable at the base, tool-specific at the overlay, incident-authored, fact-dense, linked, and mechanically enforced where prose is too weak. Every rule earns its line through a specific moment something went wrong.

## Common mistakes

**Mistake 1 — Trying to write the mature architecture upfront.** Beginners (or AIs) try to anticipate every rule. They write 200 lines of generic rules. The rules don't match reality because nothing has bitten yet. The file is unused. The right path: start small (Chapter 19); add rules as incidents happen; consolidate quarterly.

**Mistake 2 — Letting instruction files drift while the feedback corpus grows.** You author 50 feedback files over six months; `AGENTS.md` and `CLAUDE.md` are unchanged. The AI reads the root files every session; it does NOT read your feedback corpus unless you link to it. Promote consolidated rules into the right layer so they get applied; the feedback files stay as the audit trail.

**Mistake 3 — Length without density.** A 1,500-line CLAUDE.md sounds mature but if 1,200 lines are prose explanations, the AI pattern-matches the conclusion and ignores the details. Mature files are dense — one-liners, explicit numbers, explicit paths. Prose belongs in subdocs.

**Mistake 4 — Deleting superseded rules instead of marking them.** "The old rule was just wrong; preserving it would confuse future readers." Deleting destroys the audit trail. The marker `SUPERSEDED YYYY-MM-DD by path (reason)` says "don't follow this anymore"; the body shows "this is what was once thought." Both are load-bearing.

**Mistake 5 — Duplicating the portable base into every overlay.** `CLAUDE.md`, Cursor rules, and Copilot instructions all repeat the same project contract. Now three files can drift. Put shared rules in `AGENTS.md`; overlays should reference it and add only tool-specific behavior.

## Drill

Artifacts in your fork.

**Drill 1 — Audit your instruction files.** Open `student/AGENTS.md` and `student/CLAUDE.md`. Count: how many standing rules? How many entries in forbidden? Does either file duplicate the other? Do they link to a feedback corpus? Any SUPERSEDED markers? Save a one-paragraph "current state of my instruction architecture" assessment to `student/drills/32-mature-claudemd/01-current-state.txt`.

**Drill 2 — Add three incident-authored rules.** Look back through your course drills. For three different chapters, identify a rule that came up. Add three new one-line rules to the right layer: portable in `student/AGENTS.md`, Claude-specific in `student/CLAUDE.md`. Tag each with the chapter (or date) that produced it. Save the diff to `student/drills/32-mature-claudemd/02-three-rules.txt`.

**Drill 3 — Trim and link.** Read both instruction files end-to-end. Identify ONE thing that's too prose-y (more than ~3 lines for a rule that could be one). Trim it. Identify ONE subdoc you should link to instead of inlining. Add the link. Save the before/after to `student/drills/32-mature-claudemd/03-trim-and-link.txt`.

## Checkpoint question

> A mature project's `AGENTS.md` has a rule: "Never use `git stash` (lost 20+ commits, March 2026)." Its `CLAUDE.md` adds the Claude-specific hook that blocks the command. A new operator asks "isn't this overkill? Stash is a normal Git tool." Walk through what they're missing about how mature operators encode rules — and why the portable rule, tool-specific hook, date, and incident reference all do different jobs.

<!-- Rewriter audit trail
Grounded in verified principles: P21 (mechanical enforcement beats behavioral rules; the rules in CLAUDE.md are the prose layer with ~70-80% compliance; date + incident reference is the audit-trail discipline), P9 (authority hierarchy with source code at zero authority; "reconcile" is not a verb; four-rank hierarchy with operator-authored spec at top), P56 (SUPERSEDED marker is load-bearing for audit trail + hook routing; first blockquote line; body preserved)
Worked example surface: MembershipKit operator's CLAUDE.md audited against mature-reference shape
Rewrite date: 2026-05-13
-->
