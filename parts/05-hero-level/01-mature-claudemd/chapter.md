# Chapter 32 — Hero level: the mature CLAUDE.md

## Learning objective

The student can read and explain a mature, battle-tested CLAUDE.md — recognizing the patterns a 60-day-old operating discipline takes — and identify which sections of their own CLAUDE.md correspond to which moments in their operator journey.

## Prerequisites

- Completed: Chapter 31 — Practice: The audit log
- Concepts: what-is-claudemd, five-rank-authority-hierarchy, corpus-as-moat

## Core concept

Part 5 is hero level. You may never reach it. You don't have to. But seeing it gives every prior chapter its weight.

A mature CLAUDE.md — one that's been authored, broken, sharpened, and consolidated for ~60 days of full-time operation — looks very different from the one you wrote in Chapter 19. Yours is correct but young. A mature one shows the SHAPE that emerges when the rules have survived contact with reality.

This chapter walks through the anatomy of a mature CLAUDE.md, section by section. Read it; recognize the patterns; map them back to chapters you've completed.

**Top section — identity and quality bar.** The first 5-10 lines establish what the project is and what the quality target is. A mature CLAUDE.md states the bar in measurable terms: "Code in this codebase is written to acquisition-grade engineering standards: 90/100+ on the rubric an acquirer's technical due diligence team applies. Concretely, every SELECT WHERE includes organizationId and the soft-delete predicate; every money column is bigint integer cents; every timestamp column is timestamptz."

Numbers, not aspirations. "Acquisition-grade" + the specific rules that operationalize it. Beginners write "high quality"; operators write "90/100+ on this specific rubric, enforced by these specific checks."

**Middle section — the lived rules.** A mature CLAUDE.md has 20-50 standing rules, each one a single line, each one earned from an incident. Examples:

- "Never edit framework versions (Next.js, React, TS) without explicit approval."
- "Never bypass git hooks (--no-verify)."
- "Never produce time estimates in plans, dispatches, or work products."
- "Spec is truth; output is defendant."
- "Every utility in packages/api/lib/* has tests covering happy path, boundaries, and every documented error branch."
- "File size cap: 500 code lines per source file, 200 per function."
- "No z.any(), z.unknown(), or .passthrough() in Zod input schemas."

Each is short. Each is specific. Each maps to a moment when the rule wasn't in place and something broke. The rules accumulated over time; new ones get added when something new breaks.

**Section — the authority hierarchy.** Five ranks listed explicitly. (You wrote yours in Chapter 17.) A mature version names the document paths: "1. typed instructions; 2. constitution.md + cto-briefing.md; 3. _shared/*.md rules; 4. domain-rules/{product}/{domain}.md; 5. source code (zero authority — the defendant)."

**Section — process discipline.** The four-stage pipeline: spec → contract → build → review → gate → QA → fix. The pipeline is in the file so Claude follows it without re-explaining each session.

**Section — what NEVER happens.** Things mature operators have learned the hard way to forbid. Examples Maxwell's project includes:

- "Never use git stash (lost 20+ commits, March 2026)."
- "Never silently continue past an error (Two-Option Rule)."
- "Never offer 'stopping point' / 'natural pause' language."
- "Never ask 'what do you want me to do?'"
- "Never edit framework versions without approval."

Notice the DATES and EVIDENCE on some of these. Mature operators tag the rule with the incident that produced it. The next operator (including future-you) reads "lost 20+ commits, March 2026" and understands not just WHAT to do but WHY.

**Section — links to subdocs.** A mature CLAUDE.md doesn't try to contain everything. It points to specialized docs: testing patterns, domain rules, anti-pattern catalog, feedback corpus index. Each subdoc is read on demand by Claude or the operator. The CLAUDE.md is the entry point, not the manual.

**Length.** Mature CLAUDE.md files are 200-400 lines. Yours is probably 30-80 right now. The growth is healthy — every rule earned its line.

**Anti-pattern: bloat.** A 2,000-line CLAUDE.md is broken. Either the rules are too prosy (rewrite as one-liners), or the doc is trying to be the whole manual (extract to subdocs). Mature CLAUDE.md authors trim as aggressively as they add.

## Worked example

You're auditing your own CLAUDE.md and comparing it to a mature reference. You notice:

- Your "Standing rules" section has 4 entries. The reference has 24.
- Your forbidden section has 3 entries. The reference has 15.
- Your reference paths are absent. The reference links to a `feedback/INDEX.md`, an anti-patterns catalog, and per-package CLAUDE.md files.
- Your file has no incident-dated rules.

The gap is the discipline of incident-driven authoring. You added rules in Chapter 19, but you haven't added new ones from incidents in this course's drills. The fix: every time something bites you (in this course or your own work), open CLAUDE.md and add a one-liner. After three months you'll have 30+ rules. After a year, 50+. The compound is your moat.

## The rule

> A mature CLAUDE.md is incident-authored, fact-dense, and linked rather than bloated. Every rule earns its line through a specific moment something went wrong. The file grows linearly with operating experience; growth is healthy; bloat (vague prose, redundant entries, no subdoc links) is the failure mode to trim against.

## Common mistakes

**Mistake 1 — Trying to write the mature CLAUDE.md upfront.** Beginners (or AIs) try to anticipate every rule they'll need. They write 200 lines of generic rules. The rules don't match reality because nothing has bitten yet. The file is unused. The right path: start small (Chapter 19); add rules as incidents happen; consolidate quarterly.

**Mistake 2 — Letting CLAUDE.md drift while feedback corpus grows.** You author 50 feedback files over six months. Each one names a specific incident. But CLAUDE.md is unchanged. Claude reads CLAUDE.md every session; Claude does NOT read your feedback corpus unless you link to it. Promote the consolidated rules into CLAUDE.md so they get applied; the feedback files stay as the audit trail.

**Mistake 3 — Length-without-density.** A 1,500-line CLAUDE.md sounds mature but if 1,200 lines are prose explanations, Claude pattern-matches the conclusion and ignores the details. Mature files are dense — one-liners, explicit numbers, explicit paths. Prose belongs in subdocs.

## Drill

Artifacts in your fork.

**Drill 1 — Audit your CLAUDE.md.** Open `student/CLAUDE.md` and count: how many standing rules? How many entries in forbidden? Does it link to a feedback corpus? Save a one-paragraph "current state of my CLAUDE.md" assessment to `student/drills/32-mature-claudemd/01-current-state.txt`.

**Drill 2 — Add three incident-authored rules.** Look back through your course drills. For three different chapters (your choice), identify a rule that came up. Add three new one-line rules to `student/CLAUDE.md`, each tagged with the chapter that produced it. Save the diff (the three lines you added) to `student/drills/32-mature-claudemd/02-three-rules.txt`.

**Drill 3 — Trim and link.** Read your CLAUDE.md end-to-end. Identify ONE thing that's too prose-y (more than ~3 lines for a rule that could be one). Trim it. Identify ONE subdoc you should link to from CLAUDE.md instead of inlining. Add the link. Save the before/after to `student/drills/32-mature-claudemd/03-trim-and-link.txt`.

## Checkpoint question

> Maxwell's project CLAUDE.md has a rule: "Never use git stash (lost 20+ commits, March 2026)." A new operator reads this and asks "isn't this overkill? Stash is a normal Git tool." Walk through what they're missing about how mature operators encode rules — and what specifically the date + incident reference is doing for the next reader.
