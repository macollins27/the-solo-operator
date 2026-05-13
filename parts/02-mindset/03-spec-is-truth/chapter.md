# Chapter 11 — Spec is Truth, Output is Defendant

## Learning objective

The student can name the authority hierarchy of their project (their written intent on top, AI output on the bottom), and refuse to "reconcile" a spec to match what Claude actually produced.

## Prerequisites

- Completed: Chapter 10 — The Two-Option Rule
- Concepts: operator-as-manager, two-option-rule

## Core concept

**Your written intent is authoritative. Your AI's output is the defendant.**

When the two disagree, the AI's output is wrong. Not the spec. Not "open for interpretation." The output. You fix the output. You do not "update the spec to match what was built." Doing that — letting the built artifact rewrite your intent retroactively — is the single most common way operators lose control of their projects without noticing.

This sounds obvious. It isn't, in practice, because the failure mode is invisible:

- You spec a feature: "passwords must be at least 12 characters." Claude builds it but enforces only 8. You notice when reviewing. You decide "well, 8 is fine for now" and update the spec. **The output just changed your spec.** Next time you read the spec, it says 8. You forget you ever wanted 12. The system drifted.

- You spec a data model: "users have one organization." Claude builds it with users having many. You notice. You think "actually many makes sense, let me update the diagram." **The output rewrote your data model.** Now every future feature uses many-to-many because the spec says so.

- You spec a workflow: "after payment, send a receipt." Claude builds it without the receipt step. You miss it during review. The first user pays. No receipt. You debug for two hours, find the missing step, and then face a choice: was the receipt step ALWAYS supposed to be there (Output is Defendant: yes), or did you change your mind without writing it down (Spec is Truth, but actually the spec was never updated)? If you can't tell, your project has lost its ground truth.

The opposite is also true and worth saying: **YOU can update the spec at any time.** What's forbidden is letting the OUTPUT update the spec by drift. If you decide 8-character passwords are actually fine, write that decision down — explicitly, in the spec, with a reason — BEFORE you accept the output. That's a spec change. It's auditable. Anyone (including future you) can read why.

The shape of the discipline:

1. Write what you want, before you build. Even one paragraph. Even one bullet list.
2. Build against that spec.
3. When the build differs from the spec, ASK FIRST: is the spec wrong, or the build? Make the call deliberately.
4. If the spec is right and the build is wrong: fix the build. Period.
5. If the spec was actually wrong and you want to change your mind: update the spec EXPLICITLY, with a reason, before accepting the build.

What you NEVER do:

- Look at the built thing, decide it's "close enough," and tacitly assume the spec was always this.
- Tell Claude "actually the spec should match what you built" — that's giving Claude authority over your intent.
- Discover a drift weeks later and try to reconstruct what was supposed to be true.

This principle applies at every scale: a 3-line spec for a small function, a 50-line spec for a feature, a 50-page spec for a whole product. Same rule. Same authority hierarchy.

## Worked example

You're adding a "delete account" feature to MembershipKit. You write a one-paragraph spec:

> When a user deletes their account, all their personal data is soft-deleted (preserved with a deletedAt timestamp, but excluded from all queries). Their payment history is preserved permanently (we need it for tax records). Their event check-ins are kept anonymized (we keep the count, not the name). Confirmation email goes out before the delete actually fires.

You ask Claude to implement it. Claude reads your spec, builds the feature. You review.

**Drift case 1 — silent omission.** Claude implemented soft-delete and payment preservation and check-in anonymization but forgot the confirmation email. The feature works. You almost approve it.

Wrong move: "Looks good, let's ship." (Spec said confirmation email. Build doesn't have it. You're tacitly accepting the build over the spec.)

Right move: "The confirmation email isn't there. Add it, then I'll review again." (Spec is truth.)

**Drift case 2 — silent expansion.** Claude implemented the spec AND added a 24-hour grace period during which users can undo the delete. You think the grace period is actually a nice idea.

Wrong move: "I like the grace period — let me update my mental model and ship this." (Build just added scope to your spec. Even if you like the addition, you didn't decide it; Claude did.)

Right move: "I like the grace period but it wasn't in the spec. Let me add it to the spec explicitly with the rule that the delete fires at 24h+1min." (Spec change you authored, not drift.)

**Drift case 3 — semantic disagreement.** Claude implemented "soft-deleted but excluded from queries" but you discover that admin-only audit queries DO need to see soft-deleted users. The spec didn't say "all" should be "all non-admin." Both you and Claude could argue either reading.

Wrong move: Pick one and ship. Either way, the spec is now ambiguous and the next operator reading it won't know what was intended.

Right move: "The spec was ambiguous. I'm clarifying it now: admin audit queries see deleted users; everything else excludes them. Update the spec to say that, then update the code to match the clarified spec." (You're the source of authority; you resolve the ambiguity in the spec, not in the code.)

## The rule

> Spec is truth; output is defendant. When they disagree, the spec wins by default. You can change your mind — but the change happens in the spec, explicitly, before you accept the output. Never let the artifact rewrite the intent by drift.

## Common mistakes

**Mistake 1 — "Close enough" approvals.** Build differs from spec in a small way. You wave it through. Over 30 features, 30 small drifts accumulate. The product two weeks later isn't what you wrote down. Catch every drift on the turn it happens; the catching cost is small, the accumulation cost is huge.

**Mistake 2 — Updating the spec to match output.** Claude produces something different from spec. You like the output. You "update the spec to reflect the actual implementation." The output just rewrote your intent. You may genuinely have changed your mind — but make the change a DECISION (with reasoning) rather than a RECONCILIATION (silent). The diff in the spec history is the auditable record.

**Mistake 3 — Spec'ing in your head only.** You "know what you want" but you didn't write it down. When the build differs, you have no ground truth to compare against — just your memory, which is unreliable and unauditable. Even one paragraph of written intent beats none. Write the spec, however small, before the build.

## Drill

Artifacts go in `student/drills/11-spec-is-truth/`.

**Drill 1 — Write a small spec.** In your fork, create a file at `student/drills/11-spec-is-truth/01-feature-spec.md`. Pick a small imaginary feature (a markdown todo-list page, a hello-world API route, a contact form — anything). Write a 5-8 line spec for it. Include at least 3 specific requirements (the route, the inputs, the outputs).

**Drill 2 — Build it, find the drift.** Open Claude Code. Ask Claude to implement what's in your spec file (reference it by path). After Claude finishes, compare what Claude built against your spec line by line. Find at least one drift (something built differently from spec, or something missing, or something added). Save your drift list to `student/drills/11-spec-is-truth/02-drift-list.md`. Format: `- Spec: X. Build: Y.`

**Drill 3 — Resolve drift correctly.** For each drift in your list, write a one-line decision: either "fix the build" or "change the spec, here's why." Save to `student/drills/11-spec-is-truth/03-resolution.md`. Then actually carry out the resolution — if you're changing the build, ask Claude to fix it; if you're changing the spec, edit the spec file. Either way, the spec and the build end up in agreement.

## Checkpoint question

> Two weeks ago you spec'd MembershipKit's event-checkin feature to require admin approval for after-hours check-ins. Today, reviewing the code, you find Claude built check-ins to allow themselves at any time and the admin-approval requirement is missing entirely. You vaguely remember discussing this with Claude during the original build session and possibly agreeing that admin approval was over-engineered. There's nothing in writing. The build is shipped to one user already. Walk through, in order, how you handle this — what you do first, what you check, what you change, and how you avoid the same situation next time.
