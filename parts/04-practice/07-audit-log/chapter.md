# Chapter 31 — Practice: The audit log

## Learning objective

The student ships an audit log for MembershipKit: every state-changing action is recorded with actor, action, target entity, before/after snapshots, and timestamp; admins can browse the log; tampering is impossible.

## Prerequisites

- Completed: Chapter 30 — Practice: AI member-directory search
- Concepts: feature-build-discipline-loop, timestamptz-utc-storage

## Core concept

Seventh and final practice. New content: **append-only data**, **structured event capture**, and **observability discipline**.

An audit log answers "who did what, when, and what changed" for every mutating action in your app. It's load-bearing for three reasons: regulatory (if you ever ship to enterprises, they'll ask), debugging (when a bug is reported, the audit log is the first place you look), and security (if someone exploits your app, the log shows what they touched).

The narrow spec:

> **Feature: audit log.**
> 1. Every state-changing action (create / update / delete / role-change / payment / invitation / RSVP / check-in) writes an audit_log row.
> 2. Each row: id (UUIDv7), occurredAt (timestamptz), actorUserId, actorIpAddress, action (enum), entityType (enum), entityId, beforeJson (nullable), afterJson, organizationId, metadataJson (nullable).
> 3. Audit_log is APPEND-ONLY. No UPDATE permission on the table; no DELETE permission. Even admins cannot edit history.
> 4. Writes happen INSIDE the same database transaction as the mutation they audit. If the audit insert fails, the mutation fails. (No silent loss.)
> 5. Admin (org-owner role) can browse their org's audit log with filters: actor, action, entityType, date range.
> 6. Browsing returns paginated results, max 100 per page, sorted by occurredAt DESC.
> 7. Sensitive fields are redacted in metadataJson before persisting (e.g., never log passwords, full credit card numbers, or full session tokens — log a hash or "[REDACTED]" instead).

Seven lines. The audit log is the closest thing to a permanent record your app has.

Why each:

- **Same transaction.** If the audit row commits but the data row doesn't, the audit is wrong. If the data commits but the audit doesn't, you have a mutation with no record. Wrap both in one transaction; succeed together or fail together.
- **Append-only.** Postgres enforces via revoked permissions: the application role has INSERT and SELECT but not UPDATE or DELETE on audit_log. Even your code can't accidentally rewrite history. (You CAN still drop the table or row via a migration; that requires intentional opt-in.)
- **Before/after snapshots.** When a member's role changes from 'member' to 'admin', the audit row contains `before: {role: 'member'}` and `after: {role: 'admin'}`. Six months later, reading the row alone is enough to understand what happened — you don't need to reconstruct from other tables.
- **Redact sensitive data.** "We have the audit log" is a security WIN only if the audit log itself is safe to read. Logging passwords or full secrets is how audit logs become data breaches.

## Worked example

Compressed:

- Spec saved.
- Claude proposes the audit_log table. You eyeball: columns are right; permissions are NOT yet set. You ask Claude to add a migration that REVOKEs UPDATE and DELETE from the application role. ✓
- Claude proposes a `writeAuditLog()` helper that wraps an INSERT. You eyeball: the helper takes `db` as a parameter (so it joins existing transactions). ✓
- Claude proposes adding `writeAuditLog()` calls inside each mutation route. You spot-check one: the call is INSIDE the transaction, with the same `tx` object. ✓
- You catch one route that calls `writeAuditLog` AFTER the transaction commits. Anti-pattern: race; if the audit insert fails after the mutation succeeds, you have a mutation with no record. You intervene: "Move the audit call inside the transaction." Claude refactors.
- Claude proposes the admin audit-browser page. You eyeball: filters work; pagination works; sorted by occurredAt DESC. ✓
- You test: change a member's role; check audit_log; row exists with before/after. Try to UPDATE the audit_log row directly via your DB client — permission denied. ✓
- You check redaction: log a synthetic password reset; verify the audit metadata says `"[REDACTED]"` not the actual token. ✓
- Commits per step.

## The rule

> Audit logs are append-only, transactional, redacted at write time. Every mutating action gets an audit row in the same transaction. The database refuses UPDATE and DELETE. Sensitive fields never reach the log. This is the pattern for every audit log you'll ever build.

## Common mistakes

**Mistake 1 — Audit writes outside the transaction.** You commit the mutation, then write the audit row. If the audit write fails, you have a mutation with no audit. The fix: same transaction, atomic. If the audit insert can't happen, the mutation doesn't happen.

**Mistake 2 — Audit log writable by application code.** Even if you have rules saying "don't update audit rows," your application's DB role allows it. A bug or attacker could rewrite history. Revoke UPDATE and DELETE on the table for the application role. Migrations (which use a higher-privileged role) can still alter the table; the application can't.

**Mistake 3 — Logging secrets.** You log "Reset email sent to user X with token Y" where Y is the actual token. The audit row now contains the secret. Anyone who can read the audit log can take over that user's account. Redact at write time: log `"[REDACTED]"` instead of the token, or log only the hash, or log only that a reset was sent — not the value.

## Drill

Artifacts in your fork.

**Drill 1 — Author the spec.** Create `student/specs/audit-log.md` with at least 7 spec lines including append-only, transactional, redaction. Save path to `student/drills/31-audit-log/01-spec-path.txt`.

**Drill 2 — Ship the feature.** Build it end-to-end. By the end you should be able to: perform a few mutating actions in your app (role change, RSVP, check-in) → open the audit-log browser as an admin → see rows for each action with before/after data. Screenshot the audit browser showing at least 3 different actions to `student/drills/31-audit-log/02-audit-browser.png`.

**Drill 3 — Test tampering.** Connect to your dev database directly (psql or a GUI client) using the APPLICATION role (not the migration role). Try `UPDATE audit_log SET action = 'something else' WHERE id = '<some-row-id>';`. Save the error message (permission denied) to `student/drills/31-audit-log/03-tamper-test.txt`.

## Checkpoint question

> A junior developer on a team you're mentoring proposes the audit-log design: every mutation triggers an async background job that inserts an audit row eventually. They argue it's faster and more scalable. Walk through what's wrong with this in 2-3 sentences, and what the right design is for the trade-off they're trying to make.
