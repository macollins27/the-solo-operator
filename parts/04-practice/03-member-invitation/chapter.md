# Chapter 27 — Practice: Member invitation flow

## Learning objective

The student ships an invite-by-email flow for MembershipKit: an admin enters an email address, a unique invitation link is generated and sent, and the invitee can click the link to join the organization with a pre-bound email.

## Prerequisites

- Completed: Chapter 26 — Practice: Dues plan and subscription
- Concepts: feature-build-discipline-loop, money-as-integer-cents

## Core concept

Third practice. New content: **secure token generation**, **single-use links via atomic check-and-update**, and **stripped HTML at the API boundary**. Three security primitives every operator needs.

A naive implementation generates a random number, puts it in the URL, accepts it back when someone clicks. Three classes of bug at three layers: predictable random, no expiration, no single-use enforcement. We'll do it right.

The narrow spec:

> **Feature: member invitation flow.**
> 1. An admin (org-owner or org-admin) enters a target email and role to invite (admin / manager / member).
> 2. The system creates an `invitation` row: id (UUIDv7), email, role, token, organizationId, expiresAt (24h from now), usedAt (null), createdBy.
> 3. The `token` is generated via `crypto.randomUUID()` or equivalent cryptographic random — NEVER `Math.random()`.
> 4. The system sends an email with `/invite/<token>`. Dev = log-to-console; prod = transactional provider.
> 5. The invitee clicks the link. If the token is unknown, expired, or already used → generic "invalid or expired link" message. Same message for all three cases.
> 6. If valid → invitee completes sign-up (email pre-filled). On success: `invitation.usedAt = now()`, user gets the invited role in the org.
> 7. The claim is atomic: `UPDATE invitations SET used_at = now(), claimed_by = $userId WHERE id = $id AND used_at IS NULL AND expires_at > now() RETURNING *`. Zero rows returned → generic invalid message. Race-safe.
> 8. All free-text inputs (the email's display name, the invitation message) are sanitized server-side via `sanitizeText` at the tRPC boundary before database write — HTML stripped, not just escaped at render. React JSX auto-escaping is rendering-layer defense, NOT storage-layer defense.

Eight lines. The security rules are baked in.

Why each detail matters:

**UUIDv7 for the row id, `crypto.randomUUID()` (v4) for the TOKEN.** Different generators for different roles. The id wants time-ordered values for sequential B-tree inserts — Node's `crypto.randomUUID()` returns v4, so use the `uuid` npm package (`uuidv7()`) or Postgres `uuid_generate_v7()` for the row id. The token wants unpredictability — `crypto.randomUUID()` (v4) is correct; time-ordering does not matter.

**The atomic UPDATE WHERE used_at IS NULL.** A naive two-step flow (SELECT check, then UPDATE mark) races: two simultaneous clicks both pass the SELECT, both UPDATE, double-claim ships. The single-statement form is atomic; zero rows returned = token was unknown, expired, or already used — you can't tell which, which is the property you want.

**Generic error message.** "Invalid or expired" for ALL failure modes. Don't tell the attacker which case applies; they can't iterate. Information-asymmetry discipline.

**Server-side HTML stripping at the tRPC boundary.** Sanitize at storage even when the only consumer is React JSX. JSX auto-escaping is a rendering-layer defense, not storage. The moment a second consumer ships (email template, CSV export, mobile client), unescaped HTML in the database becomes stored XSS. Sanitize at the API boundary via `Zod .transform(sanitizeText)`; centralize the sanitizer; never trust per-output-channel escaping as the only defense.

## Worked example

Condensed:

- Spec saved.
- AI proposes the schema. You check: `token` is `text`, indexed, unique. `expires_at` is `timestamptz`. `used_at` is nullable `timestamptz`. ✓ The unique index on `token` is a full unique index (not partial — tokens don't get soft-deleted; they expire).
- AI proposes the create-invitation API. You eyeball: token generation uses `crypto.randomUUID()`. ✓ The Zod input for the optional `message` field is `z.string().max(500).transform(sanitizeText)` — HTML stripped at the boundary. ✓
- AI proposes the claim-invitation API. First draft: `SELECT * FROM invitations WHERE token = $1; if (row && !row.used_at && row.expires_at > now()) { UPDATE ... SET used_at = now() }`. TOCTOU race. You intervene: "Single atomic UPDATE: `UPDATE invitations SET used_at = now(), claimed_by = $userId WHERE token = $token AND used_at IS NULL AND expires_at > now() RETURNING id, email, role, organization_id`. Zero rows returned → throw the generic invalid-link error."
- AI proposes the invite-acceptance page. First draft: three different error messages for three failure modes (unknown / expired / used). Enumeration leak. You intervene: "All three cases show: 'This invitation is invalid or has expired.' No differentiation."
- AI proposes the invite-email template. You catch: the optional message field is interpolated into HTML without escaping. You intervene: "The message is already HTML-stripped at the storage boundary via `sanitizeText`. The email template still needs to escape on output as a second layer — defense in depth, but NEVER as the only defense. The stored value MUST already be safe before any output path touches it."
- You wire up email-in-dev to log to console. Test via Playwright MCP: admin creates invite → console shows link → you paste → sign-up form pre-fills email → submit → invitation marked used → second click on the link shows the generic invalid error. ✓
- Commit per step.

## The rule

> Security tokens use cryptographic random, not `Math.random()`. Single-use is enforced by the database, atomically, via `UPDATE ... WHERE ... AND used_at IS NULL RETURNING ...` — never check-then-update. All failure modes show the same error to outsiders. Free-text inputs are sanitized at the API boundary, before storage. React JSX escaping is defense-in-depth, never the only defense.

## Common mistakes

**Mistake 1 — `Math.random()` for tokens.** `Math.random()` is fine for game logic and random colors. It is NOT cryptographically secure — its output is predictable given enough samples. Tokens, password reset codes, session ids: use `crypto.randomUUID()` or `crypto.randomBytes()`. Operators block `Math.random` in security-relevant code via a hook or ast-grep rule the moment they ship the first feature that handled secrets.

**Mistake 2 — Two-step claim that races.** "First SELECT to check, then UPDATE to mark" has a race window. Two clicks at the same instant both pass the check, both UPDATE, both succeed. The fix is one atomic UPDATE with the predicate in the WHERE clause, returning the affected row(s). The same principle applies to all "check-then-modify" flows.

**Mistake 3 — Helpful error messages that leak information.** "User with email X already exists" leaks which emails are registered (enumeration — Chapter 25). "This invitation has already been used" leaks that the token was valid but spent. Generic messages preserve information asymmetry. Default to generic; only differentiate when you've confirmed who else can read the response.

**Mistake 4 — Trusting React JSX escaping as your XSS defense.** "JSX auto-escapes, so it's safe." It's safe for THIS render path. The first time a second consumer of the data ships — an email template, a CSV export, a mobile client — the unescaped HTML in the database becomes stored XSS. Sanitize at storage. Centralize the sanitizer. JSX escaping is defense-in-depth, not your only defense.

## Drill

Artifacts in your fork.

**Drill 1 — Author the spec.** Create `student/specs/member-invitation.md` with at least 8 numbered lines including: crypto-random for tokens, atomic claim via UPDATE-with-predicate-RETURNING, generic error message for all failure modes, server-side HTML stripping at the API boundary. Save path to `student/drills/27-member-invitation/01-spec-path.txt`.

**Drill 2 — Ship the feature.** Build it. By the end you should be able to: sign in as admin, create an invite → see the link in your dev console → click the link → sign up with the pre-filled email → land in the org as the invited role. Verify the atomic-claim property: in two browser tabs, click the same invite link rapidly — only one should succeed; the other gets the generic invalid message. Screenshot the resulting member list to `student/drills/27-member-invitation/02-member-list.png`.

**Drill 3 — Security audit grep.** Grep your `student/canonical-project/` for `Math.random`. There should be NO matches in any security-relevant code. Also grep for SQL patterns like `SELECT.*token` followed by JS-side checks; there should be NONE — every token check should be the atomic UPDATE form. Save both grep outputs to `student/drills/27-member-invitation/03-security-grep.txt`.

## Checkpoint question

> A friend tells you their invite system works great. The accept page shows three different error messages: "Invitation not found," "Invitation expired," "Invitation already used." They're proud of the clear messaging. They also tell you the claim flow does a SELECT to check the invitation, then a separate UPDATE if it looks valid, "for readability." Walk through BOTH problems in 3-4 sentences — name the enumeration leak AND the TOCTOU race, and name the structural fixes for each.

<!-- Rewriter audit trail
Grounded in verified principles: P65 (TOCTOU on count limits and single-use claims needs atomic UPDATE-with-predicate or SELECT FOR UPDATE within a transaction), P66 (stripped HTML at the API boundary; per-output-channel escaping is defense-in-depth failure; React JSX is rendering-layer defense, not storage-layer), and informed by P64 (FORBIDDEN means authorization, BAD_REQUEST means malformed input — kept generic messages distinct from server errors)
Worked example surface: MembershipKit invitation atomic claim + HTML-stripped optional message
Rewrite date: 2026-05-13
-->
