# Chapter 27 — Practice: Member invitation flow

## Learning objective

The student ships an invite-by-email flow for MembershipKit: an admin enters an email address, a unique invitation link is generated and sent, and the invitee can click the link to join the organization with a pre-bound email.

## Prerequisites

- Completed: Chapter 26 — Practice: Dues plan and subscription
- Concepts: feature-build-discipline-loop, money-as-integer-cents

## Core concept

Third practice. The discipline loop you know; the new content is **secure token generation** and **single-use links**. Two security primitives every operator needs.

A naive implementation: generate a random number, put it in the URL, store it in the database, accept it back when someone clicks. This is broken at three levels — predictable random, no expiration, no single-use. We'll do it right.

The narrow spec:

> **Feature: member invitation flow.**
> 1. An admin (org-owner or org-admin role) enters a target email and a role to invite (admin / manager / member).
> 2. The system creates an `invitation` row with: id (UUIDv7), email, role, token, orgId, expiresAt (24h from now), usedAt (null initially), createdBy.
> 3. The `token` is generated via `crypto.randomUUID()` or equivalent cryptographic random — NEVER `Math.random()`.
> 4. The system sends an email with the link `/invite/<token>`. Email service in dev = log-to-console; in prod = transactional email provider.
> 5. The invitee clicks the link. If the token is unknown, expired, or already used → the page shows a generic "invalid or expired link" message.
> 6. If the token is valid → invitee completes sign-up (email pre-filled from invitation row). On success: `invitation.usedAt = now()`, user gets the invited role in the org.
> 7. Tokens are single-use: a successful claim sets `usedAt`; subsequent clicks show the same generic "invalid" message.

Seven lines. The security rules are baked in.

Why each detail matters:

- **UUIDv7 for ids, but `crypto.randomUUID` for the TOKEN.** The id can be predictable (it's a primary key). The token cannot be — predictable tokens are forgeable. Different purposes, different generators.
- **24-hour expiration.** Long enough for someone to read their email and respond; short enough that a leaked token isn't useful a week later. Specific number, not "soon."
- **Single-use enforced by `usedAt`.** Marking the token as used at claim time prevents replay attacks. The check is atomic — you `UPDATE invitations SET usedAt = now() WHERE id = ? AND usedAt IS NULL` and check the row count; that's how you avoid race conditions where two people try to claim at the same time.
- **Generic error message.** "Invalid or expired" for ALL failure modes — unknown token, expired token, already-used token. Don't tell the attacker which case applies; they can't iterate.
- **Email service is environment-aware.** Dev logs to console; prod sends real email. Don't accidentally email random people during local development.

## Worked example

A condensed flow your session might follow:

- Spec saved.
- Claude proposes the schema. You check: token is `text`, indexed, unique. expiresAt is `timestamptz`. usedAt is nullable `timestamptz`. ✓
- Claude proposes the create-invitation API. You eyeball: token generation uses `crypto.randomUUID()`, not `Math.random()`. ✓
- Claude proposes the claim-invitation API. You catch: the update query is `UPDATE invitations SET usedAt = now() WHERE id = ?` — missing the `AND usedAt IS NULL` predicate. Anti-pattern: TOCTOU race. You intervene: "Make the update atomic — include `AND usedAt IS NULL` in the WHERE clause, and check `rowCount === 1` after."
- Claude proposes the invite-acceptance page. You eyeball: three different error messages for three failure modes (unknown / expired / used). Security anti-pattern: enumeration leak. You intervene: "All three failure cases show the same message: 'This invitation is invalid or has expired.' No differentiation."
- You wire up email-in-dev to log to console. You test: admin creates invite → console shows link → you paste link → sign-up form pre-fills email → you submit → invitation marked used → second click on same link shows generic error.
- Commit per step.

End state: working secure invite flow.

## The rule

> Security tokens use cryptographic random, not regular random. Expire-and-single-use is enforced by the database, atomically, not by application logic. All failure modes show the same error to outsiders. These three rules apply to every link-based or token-based feature you'll ever build.

## Common mistakes

**Mistake 1 — `Math.random()` for tokens.** Math.random is fine for game logic and random colors. It is NOT cryptographically secure — its output is predictable given enough samples. Tokens, password reset codes, session ids: all use `crypto.randomUUID()` or `crypto.randomBytes()`. Operators block `Math.random` near anything security-relevant via a hook.

**Mistake 2 — Two-step claim that races.** "First check if the invite is unused (SELECT), then mark it used (UPDATE)" has a race window between the two queries. Two clicks at the same time both pass the SELECT, both UPDATE, both succeed. The fix: atomic UPDATE with WHERE predicate, then check rowCount. Same principle applies to all "check-then-modify" flows.

**Mistake 3 — Helpful error messages that leak information.** "User with email X already exists" tells an attacker which emails are registered. "This invitation has already been used" tells an attacker the token was valid but spent. Generic messages preserve information asymmetry. Helpful-to-users sometimes means specific-to-failure mode; helpful-to-attackers always means specific. Default to generic; only make it specific when you've thought through who else can read it.

## Drill

Artifacts in your fork.

**Drill 1 — Author the spec.** Create `student/specs/member-invitation.md` with at least 7 numbered spec lines including: the crypto-random rule, the expiration time, the single-use enforcement, the generic error message. Save path to `student/drills/27-member-invitation/01-spec-path.txt`.

**Drill 2 — Ship the feature.** Build it. By the end you should be able to: sign in as admin, create an invite → see the link logged to your dev console → click the link → sign up with the pre-filled email → land in the org as the invited role. Screenshot the resulting member list (showing the new member) to `student/drills/27-member-invitation/02-member-list.png`.

**Drill 3 — Security check.** Grep your `student/canonical-project/` for `Math.random`. There should be NO matches in any security-relevant code (anything involving tokens, ids, secrets). Save the grep command + result to `student/drills/27-member-invitation/03-no-math-random.txt`.

## Checkpoint question

> A friend tells you their invite system works great but the "click the link to accept" page shows three different error messages: "Invitation not found," "Invitation expired," and "Invitation already used." They're proud of the clear messaging. You wince. Explain in 2-3 sentences what the actual problem is, and what the right message is for all three cases.
