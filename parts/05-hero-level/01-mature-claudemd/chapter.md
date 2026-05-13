# Chapter 32 — Hero level: the mature CLAUDE.md

## Learning objective

The student can read and explain a mature, battle-tested CLAUDE.md — recognizing the patterns a long-running operating discipline takes — and identify which sections of their own CLAUDE.md correspond to which moments in their operator journey.

## Prerequisites

- Completed: Chapter 31 — Practice: The audit log
- Concepts: what-is-claudemd, five-rank-authority-hierarchy, corpus-as-moat

## Core concept

Part 5 is hero level. You may never reach it. You don't have to. But seeing it gives every prior chapter its weight.

A mature CLAUDE.md — one authored, broken, sharpened, and consolidated over months of full-time operation — looks different from the one you wrote in Chapter 19. Yours is correct but young. A mature one shows the SHAPE that emerges when rules have survived contact with reality.

The shape is consistent enough across mature projects to be teachable:

**Top section — identity and quality bar.** Establishes what the project is and what the target is in measurable terms. Not "high quality" but a specific rubric: "Code is written to acquisition-grade standards. Concretely: every SELECT WHERE includes organizationId and the soft-delete predicate; money is bigint integer cents; timestamps are timestamptz; cross-org fetches return NOT_FOUND; no z.any() in Zod; file size cap 500 lines, function cap 200." Numbers, exact rules.

**Middle section — incident-authored standing rules.** Twenty to fifty single-line rules, each earned from a specific moment. Patterns from mature systems:

- "Never edit framework versions (Next.js, React, TS) without explicit approval."
- "Never bypass git hooks (--no-verify)."
- "Never use `git stash` (banned after 2026-03-20 incident: 20+ commits lost)."
- "Never produce time estimates in plans, dispatches, or work products."
- "Spec is truth; source is the defendant. 'Reconcile' is not a verb. SPEC-GAP only ADDS requirements; never weakens."
- "Every utility in packages/api/lib/* has tests covering happy path, boundaries, and every documented error branch."
- "No `z.any()`, `z.unknown()`, or `.passthrough()` in Zod input schemas."

Notice the **DATES and INCIDENT REFERENCES** on the load-bearing items. "Banned after 2026-03-20 incident: 20+ commits lost." The date + incident tag is the audit trail for the next reader (or the next AI) asking "why is this rule here?" Without the tag, the rule reads as arbitrary; with the tag, the rule reads as earned.

**Section — the authority hierarchy.** Four ranks listed explicitly. Operator-authored spec / domain rules / product vision rank first as TRUTH. The codebase backend ranks second as behavioral truth about current state, NOT authority over what the system should do. The operator's hand-built prototypes rank third as the visual contract (pixel-perfect target). Another agent's downstream code / README / intermediate plan is NOT in the hierarchy — evidence only. When spec and source disagree, source is wrong. "Reconcile" is not a verb.

**Section — process discipline.** The pipeline: spec → contract → build-source → review-source → gate → QA → fix-source. Each command names the skill and what it does. The pipeline is in the file so the AI follows it without re-explaining each session.

**Section — what NEVER happens.** Things mature operators have learned the hard way to forbid. Each entry names the exact tool, path, or pattern banned, with a date or incident reference on the load-bearing items:

- "Never use `git stash` (lost 20+ commits, March 2026)."
- "Never silently continue past an error (Two-Option Rule)."
- "Never offer 'stopping point' / 'natural pause' / 'rest is execution' language."
- "Never ask 'what do you want me to do?' — propose ONE recommendation with reasoning."
- "Never edit framework versions without approval."

**Section — links to subdocs and authority documents.** A mature CLAUDE.md doesn't try to contain everything. It points to: per-package CLAUDE.md files, the constitution, the anti-patterns catalog, the feedback corpus index, the domain-rules tree, the testing-patterns doc. Each subdoc loads on demand. CLAUDE.md is the entry point, not the manual.

**Section — SUPERSEDED audit trail.** Rules that have been replaced are marked SUPERSEDED with a date + successor path + one-clause reason, with the body of the original preserved. The marker is load-bearing: it's how automated tooling (and future operators) know the file is no longer authoritative while preserving the evidence of what was tried.

**Length.** Mature CLAUDE.md files run roughly 200-400 lines after months of incident-driven authoring. Yours might be 30-80 at first. The growth is healthy — every rule earned its line. Bloat (vague prose, redundant entries, no subdoc links) is the failure mode to trim against.

## Worked example

You audit your CLAUDE.md against a mature reference. You notice:

- Your "Standing rules" section has 5 entries. The reference has 24.
- Your forbidden section has 3 entries. The reference has 15, with dates on the load-bearing items.
- Your reference paths are absent. The reference links to a `feedback/INDEX.md`, an anti-patterns catalog, per-package CLAUDE.md files, the constitution, the testing patterns doc.
- Your file has no incident-dated rules.
- Your file has no SUPERSEDED markers.

The gap is the discipline of incident-driven authoring. You added rules in Chapter 19; you haven't added new ones from incidents in this course's drills. The fix is operational: every time something bites you (in this course or your own work), open CLAUDE.md and add a one-liner tagged with the incident. After three months you'll have thirty-plus rules. After a year, fifty-plus. The compound is your moat.

The SUPERSEDED gap is subtler. Eventually some of your early rules will be replaced — sharpened, reframed, or absorbed into a consolidated rule. The mature pattern: mark the old SUPERSEDED with the marker (date + successor path + reason) in the first blockquote line; keep the body. Don't delete. The deletion would destroy the audit trail.

## The rule

> A mature CLAUDE.md is incident-authored, fact-dense, linked (not bloated), and preserves history via SUPERSEDED markers rather than deletion. Every rule earns its line through a specific moment something went wrong; dates and incident references on the load-bearing items are the audit trail.

## Common mistakes

**Mistake 1 — Trying to write the mature CLAUDE.md upfront.** Beginners (or AIs) try to anticipate every rule. They write 200 lines of generic rules. The rules don't match reality because nothing has bitten yet. The file is unused. The right path: start small (Chapter 19); add rules as incidents happen; consolidate quarterly.

**Mistake 2 — Letting CLAUDE.md drift while the feedback corpus grows.** You author 50 feedback files over six months; CLAUDE.md is unchanged. The AI reads CLAUDE.md every session; it does NOT read your feedback corpus unless you link to it. Promote consolidated rules into CLAUDE.md so they get applied; the feedback files stay as the audit trail.

**Mistake 3 — Length without density.** A 1,500-line CLAUDE.md sounds mature but if 1,200 lines are prose explanations, the AI pattern-matches the conclusion and ignores the details. Mature files are dense — one-liners, explicit numbers, explicit paths. Prose belongs in subdocs.

**Mistake 4 — Deleting superseded rules instead of marking them.** "The old rule was just wrong; preserving it would confuse future readers." Deleting destroys the audit trail. The marker `SUPERSEDED YYYY-MM-DD by path (reason)` says "don't follow this anymore"; the body shows "this is what was once thought." Both are load-bearing.

## Drill

Artifacts in your fork.

**Drill 1 — Audit your CLAUDE.md.** Open `student/CLAUDE.md` and count: how many standing rules? How many entries in forbidden? Does it link to a feedback corpus? Any SUPERSEDED markers? Save a one-paragraph "current state of my CLAUDE.md" assessment to `student/drills/32-mature-claudemd/01-current-state.txt`.

**Drill 2 — Add three incident-authored rules.** Look back through your course drills. For three different chapters, identify a rule that came up. Add three new one-line rules to `student/CLAUDE.md`, each tagged with the chapter (or date) that produced it. Save the diff to `student/drills/32-mature-claudemd/02-three-rules.txt`.

**Drill 3 — Trim and link.** Read your CLAUDE.md end-to-end. Identify ONE thing that's too prose-y (more than ~3 lines for a rule that could be one). Trim it. Identify ONE subdoc you should link to from CLAUDE.md instead of inlining. Add the link. Save the before/after to `student/drills/32-mature-claudemd/03-trim-and-link.txt`.

## Checkpoint question

> A mature project's CLAUDE.md has a rule: "Never use `git stash` (lost 20+ commits, March 2026)." A new operator reads this and asks "isn't this overkill? Stash is a normal Git tool." Walk through what they're missing about how mature operators encode rules — and what specifically the date + incident reference is doing for the next reader (and the next AI session) that a bare rule could not.

<!-- Rewriter audit trail
Grounded in verified principles: P21 (mechanical enforcement beats behavioral rules; the rules in CLAUDE.md are the prose layer with ~70-80% compliance; date + incident reference is the audit-trail discipline), P9 (authority hierarchy with source code at zero authority; "reconcile" is not a verb; four-rank hierarchy with operator-authored spec at top), P56 (SUPERSEDED marker is load-bearing for audit trail + hook routing; first blockquote line; body preserved)
Worked example surface: MembershipKit operator's CLAUDE.md audited against mature-reference shape
Rewrite date: 2026-05-13
-->
