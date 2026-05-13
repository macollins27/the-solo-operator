# Chapter 41 — The supersession pattern

## Learning objective

The student can replace a rule (or feedback file, or CTO decision, or any authored artifact) cleanly when their thinking changes — preserving the audit trail of WHY it was replaced, without losing the prior reasoning.

## Prerequisites

- Completed: Chapter 40 — The skill iteration protocol
- Concepts: never-modify-what-isnt-broken, spec-as-authority

## Core concept

Rules get superseded. A rule that was right six months ago can be wrong now — because the system grew, because you learned something, because the original rule was based on incomplete information. Mature operators replace rules cleanly, with an audit trail.

The wrong way to replace a rule: delete the old, add the new. The audit trail is gone. Six months from now you (or another operator reading the project) won't know WHY the change happened. The current state looks like the only state that ever was.

The right way: mark the old SUPERSEDED with a date, a reason, and a pointer to the successor. Keep the body of the old rule. Add the new rule alongside (or in its own file). The history is preserved.

The supersession marker format (Maxwell's project uses this convention):

```
> **SUPERSEDED 2026-05-13 by `path/to/new-file.md` (short reason).**

[original body of rule preserved below]
```

The marker is the first blockquote line of the file. Three pieces of information:

1. **Date** — when the supersession happened.
2. **Successor path** — where the new authority lives.
3. **Reason** — one short clause naming WHY it was superseded.

The body of the old file is preserved below the marker. Why preserve the body? Because future operators reading the project's evolution need to understand what was tried and what was learned. The marker says "this was superseded"; the body says "this is what was once true."

When to supersede vs. just edit:

**Edit when:**
- The original rule was almost right but a phrase needs sharpening.
- A typo or grammatical issue.
- A factual correction within the original scope.

**Supersede when:**
- The conclusion of the rule has changed (was X; is now Y).
- The scope of the rule has changed (used to apply to A; now applies to B).
- A new rule exists that more comprehensively covers what the old one did.

The test: would a future operator find it useful to know what the old rule said? If yes, supersede. If no (the old rule was wrong in some trivial way), edit.

A few discipline points:

**The marker is load-bearing.** It's how automated tooling (and future operators) know the file is no longer authoritative. Mature projects have hooks that recognize the SUPERSEDED marker and treat the file as historical.

**Don't strip the body.** Deleting the body destroys the "what was tried" evidence. The marker says "this isn't current"; the body shows "this is the path we walked."

**Date in YYYY-MM-DD.** Sortable. Unambiguous. No "last Tuesday."

**Reason in one clause.** "New canonical-identity model" is enough. "Comprehensive 12-page analysis below" is not what a marker should say.

**Successor path is a link.** When you click it (or a future operator reads it), the new authority is right there. No hunting.

## Worked example

Six months into your project, you wrote a CLAUDE.md rule: "Use Math.random() for randomly choosing default avatars from the avatar set." It made sense at the time — avatars were a UI detail, low-stakes.

Then you added a feature where avatar selection seeds a randomization used in invitation tokens. Now Math.random() is in the security path. You realize: that rule needs to die.

**Wrong response:** edit the line in CLAUDE.md from "Use Math.random()" to "Use crypto.randomUUID()." The old reasoning is gone. Six months from now, the next operator wonders "why does this rule even exist?" — they have no way to know it was originally a UI choice that crossed into security.

**Right response:** supersede. Add a new feedback file `feedback_math_random_security_boundary.md` documenting the incident (avatar randomization fed into security tokens). Update CLAUDE.md to reference the new file. Mark the OLD CLAUDE.md line as superseded if it was a standalone rule, or replace it with a sharper one ("Math.random() is forbidden in any code that could touch security boundaries; use crypto.randomUUID()") with a comment citing the new feedback file.

Now six months later: the new operator reading CLAUDE.md sees "this rule was sharpened on 2025-05-13 because avatar logic crossed into security." They understand. They preserve the discipline. They avoid the same mistake.

## The rule

> Supersede; don't delete. The marker format (`SUPERSEDED YYYY-MM-DD by path (reason)`) preserves the audit trail. The body of the superseded artifact stays, so future operators can see what was tried. Sharpen the new rule with the lesson learned; cite the incident that triggered the change.

## Common mistakes

**Mistake 1 — Just deleting the old rule.** Saves time today; costs context forever. The next operator (or future-you) loses the ability to understand the evolution. Always supersede if the rule's scope or conclusion has changed.

**Mistake 2 — Stripping the body when adding the marker.** "I'll just leave the marker; the old text isn't useful." It IS useful — for the evolution narrative. Keep the body. The marker says "don't follow this anymore"; the body shows "this is what was once thought."

**Mistake 3 — Vague reasons.** "SUPERSEDED 2025-05-13 by file.md (we changed our minds)." That's not a reason. The reader still doesn't know what changed. Reasons are specific: "(canonical identity is now RESO UPI not Smarty)" — operator can immediately understand the why.

## Drill

Artifacts in your fork.

**Drill 1 — Find a candidate to supersede.** Look at your feedback corpus and CLAUDE.md. Find ONE artifact that's either out of date, too narrow, or has been replaced in your thinking. Identify it. Save the path + why it should be superseded to `student/drills/41-supersession-pattern/01-candidate.txt`.

**Drill 2 — Author the supersession.** Add the marker to the old file (without deleting body). Create the successor file (if applicable). Update CLAUDE.md or wherever the rule was referenced to point at the new authority. Save the diff to `student/drills/41-supersession-pattern/02-diff.txt`.

**Drill 3 — Write the reason properly.** Look at your marker's reason text. Sharpen it. Make it specific enough that the next reader understands immediately. Save the before/after to `student/drills/41-supersession-pattern/03-reason-sharpening.txt`.

## Checkpoint question

> An operator deletes a CLAUDE.md rule that's been in place for a year, replacing it with a different one. They argue "the old rule was just wrong; preserving it would confuse future readers." Walk through what they're missing about the supersession pattern in 2-3 sentences, and when (if ever) outright deletion is actually appropriate.
