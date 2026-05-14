# Chapter 42 — The consolidation pattern

## Learning objective

The student can recognize when their feedback corpus has accumulated enough related entries to warrant consolidation, perform a consolidation pass that absorbs multiple feedback files into a single CLAUDE.md rule (or other authoritative artifact), and preserve the original files as historical evidence.

## Prerequisites

- Completed: Chapter 41 — The supersession pattern
- Concepts: corpus-as-moat, supersession-vs-deletion

## Core concept

The feedback corpus grows linearly. Every bite produces a file. After three months, fifty files; after a year, a hundred-fifty. Reading every file at every session start is impossible (token cost) and counterproductive (most rules don't apply to today's session).

The fix: **periodic consolidation**. Quarterly (or when the corpus crosses a threshold), the operator does a consolidation pass — read across the corpus, identify clusters of related rules, absorb each cluster into ONE authoritative rule in CLAUDE.md or another high-authority document. The originals become historical (marked SUPERSEDED with a pointer to the consolidated rule).

The result: the active rule surface stays bounded — roughly 30-50 lines of CLAUDE.md plus 10-20 active feedback files — while the FULL history remains preserved in superseded form. The session reads only the active surface, fast.

A mature project ran an explicit consolidation pass that absorbed roughly 100 individual feedback files into CLAUDE.md in one batch. The pass produced a drop log documenting exactly what was consolidated, why, and where each consolidated rule now lives. Without that pass, the corpus would have been too large to scan; with it, the active surface stayed sharp.

Four categories of consolidation a typical drop log uses:

**1. "Already in CLAUDE.md."** Rules that duplicated something already in CLAUDE.md by the time the consolidation happened. Drop the standalone file; the CLAUDE.md text is authoritative.

**2. "Superseded by a new file."** Older state docs replaced by a current-state file. History stays in `.archive/` for audit; the current file is canonical.

**3. "Derivable from code."** Rules the codebase or config files now make obvious (e.g., "no `git stash`" — the deny-list in `settings.json` shows this directly). Drop the feedback file; the code is authoritative.

**4. "Consolidated."** Multiple feedback files merging into one new file or section. The drop log explicitly maps "feedback A, feedback B, feedback C → new section X in CLAUDE.md."

The discipline that makes consolidation safe:

**Always preserve the body.** Even when marking SUPERSEDED, the original body stays readable. Future operators can see the path of evolution. Per Chapter 41: the marker says "don't follow this anymore"; the body shows "this is what was once thought."

**Document the mapping in a drop log.** A consolidation pass produces a synthesis-drop log naming exactly which files were consolidated and where their rules now live. The log is the audit trail.

**Don't rush.** A focused consolidation pass pays for itself many times over in the operating arc that follows. Don't try to do it in one rushed sweep; you'll miss subtle relationships between rules.

**Run on a known cadence.** Quarterly works for most operators. Or trigger when the corpus crosses a count threshold (50 files, say). Don't wait until you have 200 files and the corpus is unreadable.

Signals it's time for consolidation:

- CLAUDE.md has stayed the same size for months while the feedback corpus has 3x'd.
- You find yourself authoring the same kind of rule repeatedly — different surfaces, same family.
- A new operator (or future-you) asks "where do I look for X?" and the answer is "search across 60 feedback files." Bad sign.
- The active corpus is too big to grep through during a session.

## Worked example

Four months of operating. Your `student/feedback/` has 35 files. You notice clusters:

- 6 files about test discipline (`feedback_e2e_never_fake`, `feedback_never_weaken_tests`, `feedback_never_delete_tests`, `feedback_4800_fake_tests_incident`, ...).
- 5 files about verification (`feedback_browser_verify`, `feedback_verify_artifact`, `feedback_read_before_forensics`, ...).
- 4 files about money discipline (`feedback_money_floats`, `feedback_cents_not_dollars`, `feedback_parsefloat_in_money`, ...).
- 20 various one-offs.

Consolidation pass:

1. Read all 6 test-discipline files. Distill into ONE rule for CLAUDE.md: "Tests never get weakened to make them pass; tests are written against domain rules, not implementation; failed tests get fixed (not skipped) before commit. Every `it()` block calls the actual production code path; if you delete the production code and the test still passes, the test is broken. See `feedback_4800_fake_tests_incident.md` for the incident that locked this discipline." Reference the originals in the new CLAUDE.md section.
2. Mark the 6 originals SUPERSEDED with the marker pointing at the new CLAUDE.md section. Bodies preserved.
3. Do the same for the verification cluster (5 files → 1 rule).
4. Do the same for money discipline (4 files → 1 rule: "Money is integer cents everywhere. No `parseFloat`. No `toFixed` outside the sanctioned helper. Variable names carry the unit explicitly (`*Cents`). Cap at `.max(2147483647)` to prevent integer overflow.").
5. Write a drop log at `student/feedback/SYNTHESIS-DROPPED-<date>.md` documenting the pass.
6. The 20 one-offs stay as active feedback files; they haven't formed clusters yet.

Result: CLAUDE.md grew from 30 lines to 45 lines (3 new consolidated rules). Feedback corpus active surface dropped from 35 files to 20. The other 15 files still exist in superseded form; bodies still readable. Audit trail intact; cognitive load down.

## The rule

> Consolidate periodically. When 3+ feedback files cluster around one principle, distill into one CLAUDE.md rule (or other authoritative location). Mark originals SUPERSEDED with a pointer to the consolidated rule; preserve bodies as evidence. Document the pass in a drop log. The active corpus stays sharp; the full history stays auditable.

## Common mistakes

**Mistake 1 — Never consolidating.** Corpus grows for a year without a pass. By month 12 you have 200 files; nobody can read them; the rules drift back into ambient knowledge. Consolidation is the discipline that keeps the corpus useful at scale.

**Mistake 2 — Consolidating too eagerly.** You see two related feedback files and immediately consolidate. But two is below the threshold — you don't yet know if it's a real pattern or a coincidence. Wait for 3-4 instances; otherwise you're imposing structure ahead of evidence.

**Mistake 3 — Deleting instead of superseding.** Consolidation merges; it doesn't destroy. The superseded files stay (marked, with full body). The drop log records the mapping. Deleting loses the evolution.

**Mistake 4 — No drop log.** You consolidate and don't document what happened. Six months later, someone asks "what happened to my feedback file X?" — and there's no record. The drop log is the audit trail for the consolidation itself, separate from the SUPERSEDED markers on individual files.

## Drill

Artifacts in your fork.

**Drill 1 — Audit cluster candidates.** Read your `student/feedback/INDEX.md` and the feedback files. Identify any clusters of 2+ files around the same principle. Save the list to `student/drills/42-consolidation-pattern/01-clusters.txt`. For most students at this point, you might have 0-2 clusters — that's normal, you haven't accumulated enough.

**Drill 2 — Draft a consolidated rule.** Pick ONE cluster (real or hypothetical — you can invent 3 fake feedback files for this drill if your corpus isn't big enough yet). Distill into one CLAUDE.md-ready rule. Save the rule + which feedback files it would absorb to `student/drills/42-consolidation-pattern/02-consolidated-rule.txt`.

**Drill 3 — Author a drop-log template.** Write a template at `student/feedback/SYNTHESIS-DROPPED-TEMPLATE.md` you'll use when you eventually do a real consolidation pass. Sections: "Already in CLAUDE.md / Superseded by new file / Derivable from code / Consolidated." Each entry's format. Save the template path to `student/drills/42-consolidation-pattern/03-drop-log-template.txt`.

## Checkpoint question

> An operator has 80 feedback files after 6 months. They never run a consolidation pass. They complain that the AI "keeps making mistakes I've documented before." Walk through 3-4 sentences naming the technical reason the documented rules aren't being applied, the relationship to CLAUDE.md's compliance ceiling, and the operational fix.

<!-- Rewriter audit trail
Grounded in verified principles: P56 (SUPERSEDED marker for superseded artifacts; body preserved; first blockquote line; audit trail discipline), and informed by P21 (mechanical-enforcement promotion ladder; CLAUDE.md as the prose layer that needs maintenance to stay sharp), P8 (artifact is evidence; consolidated rule retains evidence of prior bites in superseded bodies)
Worked example surface: MembershipKit operator's 35-file corpus consolidation pass into 3 CLAUDE.md sections + drop log
Rewrite date: 2026-05-13
-->
