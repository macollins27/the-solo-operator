# Chapter 41 — The supersession pattern

## Learning objective

The student can replace a rule (or feedback file, or past decision, or any authored artifact) cleanly when their thinking changes — preserving the audit trail of WHY it was replaced, without losing the prior reasoning.

## Prerequisites

- Completed: Chapter 40 — The skill iteration protocol
- Concepts: never-modify-what-isnt-broken, spec-as-authority

## Core concept

Rules get superseded. A rule right six months ago can be wrong now — the system grew, the operator learned something, the original was based on incomplete information. Mature operators replace rules cleanly, with an audit trail.

The wrong way: delete the old, add the new. The audit trail is gone. Six months from now you (or another operator reading the project) won't know WHY the change happened. The current state looks like the only state that ever was.

The right way: mark the old SUPERSEDED with a date, a successor path, and a one-clause reason. Keep the body of the old rule. Add the new rule alongside (or in its own file). History preserved.

The supersession marker format:

```
> **SUPERSEDED YYYY-MM-DD by `path/to/successor.md` (short reason).**

[original body of rule preserved below]
```

The marker is the first blockquote line of the file. Three pieces of information:

1. **Date** in YYYY-MM-DD. Sortable. Unambiguous.
2. **Successor path** as a link to where the new authority lives.
3. **Reason** as one short clause naming WHY it was superseded.

The marker is load-bearing for two reasons:

**Audit trail.** A due-diligence reviewer (or future operator, or a fresh-context AI session) sees the deprecation date, the successor path, and the reason in one place. Deleting loses the history; renaming hides it. The marker says "don't follow this anymore"; the body shows "this is what was once thought."

**Hook routing.** Mature projects have a post-bash-policy hook that reads the first 5 lines of a `currentSpec` file. When the SUPERSEDED marker is present, the hook auto-quiets and falls through to the generic continuation message — agents don't get anchored on stale "next unchecked" tasks. Without the marker, agents would surface tasks from the stale file. With it, the routing is automatic.

The mechanics: the marker text MUST be in the first 5 lines and contain `SUPERSEDED` in caps. Body content is preserved below — do not strip it. Per the discipline that artifacts are evidence about past decisions rather than authority over current ones, the SUPERSEDED marker operationalizes the same principle for plan-shaped files.

When to supersede vs. just edit:

**Edit when:**
- The original was almost right but a phrase needs sharpening.
- A typo or grammatical issue.
- A factual correction within the original scope.

**Supersede when:**
- The conclusion has changed (was X; now Y).
- The scope has changed (used to apply to A; now applies to B).
- A new rule more comprehensively covers what the old one did.

The test: would a future operator find it useful to know what the old rule said? If yes, supersede. If no (the original was wrong in a trivial way), edit.

## Worked example

Six months into your project, you wrote a CLAUDE.md rule: "Use `Math.random()` for randomly choosing default avatars from the avatar set." It made sense at the time — avatars were a UI detail, low-stakes.

Then you added a feature where avatar selection seeds a randomization used in invitation tokens. Now `Math.random()` is in the security path. The rule needs to die.

**Wrong response:** edit the CLAUDE.md line from `Math.random()` to `crypto.randomUUID()`. The old reasoning is gone. Six months later, the next operator wonders "why does this rule even exist?" — they have no way to know it was originally a UI choice that crossed into security.

**Right response:** supersede. Create the new feedback file `feedback_math_random_security_boundary.md` documenting the incident (avatar randomization fed into security tokens). Mark the OLD CLAUDE.md line (if it was a standalone rule):

```
> **SUPERSEDED 2026-05-13 by `feedback_math_random_security_boundary.md` (avatar logic crossed into security boundary).**

Original rule: "Use Math.random() for randomly choosing default avatars from the avatar set." Reasoning at time of authoring: avatars were UI detail, low-stakes, performance favored over cryptographic primitives.
```

Replace the CLAUDE.md text with the sharpened rule: "`Math.random()` is forbidden in any code that could touch security boundaries. Use `crypto.randomUUID()`. See `feedback_math_random_security_boundary.md` for the avatar-randomization incident that produced this rule."

Now six months later, the new operator reading CLAUDE.md sees "this rule was sharpened on 2026-05-13 because avatar logic crossed into security." They understand. They preserve the discipline. They avoid the same mistake.

## The rule

> Supersede; don't delete. The marker format (`SUPERSEDED YYYY-MM-DD by path (reason)`) in the first blockquote line preserves the audit trail. The body stays. Sharpen the new rule with the lesson learned; cite the incident that triggered the change. The marker is load-bearing for two reasons: audit trail for future readers and hook routing that auto-quiets stale files.

## Common mistakes

**Mistake 1 — Just deleting the old rule.** Saves time today; costs context forever. The next operator (or future-you, or a fresh-context AI) loses the ability to understand the evolution. Always supersede if scope or conclusion has changed.

**Mistake 2 — Stripping the body when adding the marker.** "I'll leave the marker; the old text isn't useful." It IS useful — for the evolution narrative. Keep the body. The marker says "don't follow this anymore"; the body shows "this is what was once thought."

**Mistake 3 — Vague reasons.** "SUPERSEDED 2026-05-13 by file.md (we changed our minds)." Not a reason. The reader still doesn't know what changed. Reasons are specific: "(canonical identity is now RESO UPI not Smarty)" or "(avatar logic crossed into security boundary)" — one clause, specific.

**Mistake 4 — Marker not in the first 5 lines.** The hook routing reads the first 5 lines of the file. A marker buried in the middle of the body is invisible to the hook; the file is treated as authoritative anyway. The marker MUST be in the first 5 lines and contain `SUPERSEDED` in caps.

## Drill

Artifacts in your fork.

**Drill 1 — Find a candidate to supersede.** Look at your feedback corpus and CLAUDE.md. Find ONE artifact that's out of date, too narrow, or has been replaced in your thinking. Save the path + why it should be superseded to `student/drills/41-supersession-pattern/01-candidate.txt`.

**Drill 2 — Author the supersession.** Add the marker as the first blockquote line of the old file. Do NOT strip the body. Create the successor file (if applicable). Update CLAUDE.md or wherever the rule was referenced to point at the new authority. Save the diff to `student/drills/41-supersession-pattern/02-diff.txt`.

**Drill 3 — Sharpen the reason.** Look at your marker's reason text. Make it specific enough that the next reader understands immediately. Save the before/after to `student/drills/41-supersession-pattern/03-reason-sharpening.txt`.

## Checkpoint question

> An operator deletes a CLAUDE.md rule that's been in place for a year, replacing it with a different one. They argue "the old rule was just wrong; preserving it would confuse future readers." Walk through 3-4 sentences naming what they're missing about the supersession pattern — the audit-trail discipline, the hook-routing dependency, and when (if ever) outright deletion is appropriate.

<!-- Rewriter audit trail
Grounded in verified principles: P56 (SUPERSEDED marker is load-bearing for audit trail + hook routing; first blockquote line; body preserved below; marker text MUST be in first 5 lines and contain SUPERSEDED in caps; based on feedback_evaluate_dont_preserve principle that artifacts are evidence about past decisions, not authority over current ones), P8 (artifact is evidence; nothing is authority — supersession marker operationalizes this for plan-shaped files)
Worked example surface: MembershipKit avatar-randomization rule crossing into security boundary
Rewrite date: 2026-05-13
-->
