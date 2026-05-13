# Chapter 31 — Practice: The audit log

## Learning objective

The student ships an audit log for MembershipKit: every state-changing action is recorded with actor, action, target entity, before/after snapshots, and timestamp; admins can browse the log; tampering is impossible.

## Prerequisites

- Completed: Chapter 30 — Practice: AI member-directory search
- Concepts: feature-build-discipline-loop, timestamptz-utc-storage

## Core concept

Seventh and final practice. New content: **append-only data**, **transactional audit writes that fail-closed**, **redaction at write time**, and the discipline that prevents an audit log from becoming a data-breach surface.

An audit log answers "who did what, when, and what changed" for every mutating action. It's load-bearing for three reasons: regulatory (enterprises ask), debugging (when a bug is reported, the audit log is the first place to look), and security (when something exploits the app, the log shows what was touched).

The discipline that makes an audit log trustworthy:

**1. Writes happen INSIDE the same transaction as the mutation.** Not after commit, not via a background job. Mutation and audit row succeed together or fail together. `writeAuditLog(tx, ...)` runs INSERT within the same tx.

**2. Append-only, enforced at the DB role level.** The application's DB role has INSERT + SELECT on the audit table; UPDATE and DELETE are revoked. A bug or attacker can't rewrite history. Migrations (higher-privileged role) can still alter the table — intentional and rare.

**3. Before/after snapshots in JSON.** When a role changes, the row stores `before: {role: 'member'}` and `after: {role: 'admin'}`. Six months later, reading the row alone explains what happened.

**4. Redaction at write time.** Audit rows can contain secrets if you're not careful — reset tokens, session ids, PII. Redacted-at-write-time means the audit log is safe to read: passwords as `[REDACTED]`, tokens as a hash, full secrets never reaching the log.

The narrow spec:

> **Feature: audit log.**
> 1. Every state-changing action (create / update / delete / role-change / payment / invitation / RSVP / check-in) writes an `audit_log` row.
> 2. Each row: `id` (UUIDv7), `occurred_at` (`timestamptz`), `actor_user_id`, `actor_ip_address`, `action` (enum), `entity_type` (enum), `entity_id`, `before_json` (nullable JSONB), `after_json` (JSONB), `organization_id`, `metadata_json` (nullable JSONB).
> 3. `audit_log` is APPEND-ONLY. The application's DB role has INSERT + SELECT only; UPDATE and DELETE permissions are revoked at migration time.
> 4. Writes happen INSIDE the same database transaction as the mutation they audit. `writeAuditLog()` takes the `tx` object as a parameter. If the audit insert fails, the mutation fails — no silent loss.
> 5. Admin (org-owner role) can browse their org's audit log with filters: actor, action, entityType, date range. Cross-org reads return `NOT_FOUND` (the org predicate is in the SQL WHERE clause; never `FORBIDDEN`).
> 6. Browsing returns paginated results, max 100 per page, sorted by `occurred_at DESC`.
> 7. Sensitive fields are redacted in `metadata_json` BEFORE persisting — passwords, full tokens, credit card numbers, anything that would be hostile in a stored XSS scenario. Centralized `redactSensitive()` helper runs at write time.
> 8. Retention: audit logs are retained for 7 years (regulatory norm). No auto-purge before that. Soft-deletes do not apply (the audit log is itself the deletion record).

Eight lines. The audit log is the closest thing to a permanent record your app has.

The retention number is intentional. Mature operators apply different retention policies per data class: audit logs at 7 years (regulatory minimum across most jurisdictions); error logs at 90 days (debugging only); user content never auto-purged (soft-delete only — the user can request hard delete, but the system never volunteers it). Picking the wrong number is what gets shipped products fined; picking the right number is encoded once in CLAUDE.md and applied per table.

## Worked example

Compressed:

- Spec saved.
- AI proposes the `audit_log` table. You eyeball: columns are right. You ask for a migration that REVOKEs UPDATE and DELETE from the application's DB role. AI adds the migration. ✓
- AI proposes a `writeAuditLog()` helper that takes `db` or `tx` as a parameter. You spot-check: the helper INSERTs against the audit table using the passed tx; redaction runs before the insert. ✓
- AI proposes adding `writeAuditLog()` calls in each mutation route. You spot-check one: the call is INSIDE the transaction, using the same `tx` object. ✓
- You catch a route where `writeAuditLog` runs AFTER `tx.commit()`. You intervene: "Move the audit call inside the transaction. If the audit insert fails after commit, you have a mutation with no record — fail-closed means both succeed or both fail."
- AI proposes the admin audit-browser. You eyeball: filters work; pagination max-100; sorted `occurred_at DESC`. The cross-org case uses `WHERE organization_id = $userOrgId` — NOT_FOUND on empty set. ✓
- AI proposes a metadata_json field containing the password the user attempted in a sign-in event. You catch: that's logging a secret. You intervene: "Redact at write time. Passwords never reach metadata_json; log `[REDACTED]`. Full tokens never reach metadata_json; log a SHA-256 hash if you need to compare across rows."
- Playwright MCP: change a member's role; check audit_log; row exists with before/after JSON. Connect to dev DB as the application role; try `UPDATE audit_log SET action = 'something else' WHERE id = '<row-id>'`. Permission denied. ✓
- Test redaction: log a synthetic password reset; verify `metadata_json` says `"[REDACTED]"`, not the actual token. ✓
- Commit per step.

## The rule

> Audit logs are append-only (DB role permissions revoke UPDATE/DELETE), transactional (`writeAuditLog(tx, ...)` inside the same transaction as the mutation), and redacted at write time. Cross-org reads return NOT_FOUND. Retention: 7 years for audit logs, 90 days for error logs, never auto-purge user content. The discipline is encoded once, applied per table.

## Common mistakes

**Mistake 1 — Audit writes outside the transaction.** "I'll commit the mutation, then write the audit." If the audit insert fails after the mutation commit, you have a mutation with no record. The fix: same transaction, atomic. If the audit insert can't happen, the mutation doesn't happen. `writeAuditLog(tx, ...)` takes the transaction; fails together.

**Mistake 2 — Audit log writable by the application role.** Even with rules saying "don't UPDATE audit rows," the application's DB role allows it; a bug or attacker could rewrite history. Revoke UPDATE and DELETE on the table for the application role at migration time. Migrations (higher-privileged role) can still alter the table; the application cannot.

**Mistake 3 — Logging secrets.** "Reset email sent to user X with token Y" where Y is the actual token. The audit row now contains the secret; anyone who can read the audit log can take over that user's account. Redact at write time: log `[REDACTED]` or a hash, never the value. Audit logs are safe to read only if they were written safely.

**Mistake 4 — Wrong retention number.** Auto-purging audit logs after 30 days because "they're getting large" forfeits regulatory compliance and security forensics. Auto-purging user content because "we don't need it" is how lawsuit-bait gets shipped. Encode the retention numbers in CLAUDE.md once: audit 7 years, error logs 90 days, user content never auto-purge. Apply per table at migration time.

## Drill

Artifacts in your fork.

**Drill 1 — Author the spec.** Create `student/specs/audit-log.md` with at least 8 spec lines including append-only via revoked role permissions, transactional `writeAuditLog(tx, ...)`, redaction at write time, retention numbers per data class. Save path to `student/drills/31-audit-log/01-spec-path.txt`.

**Drill 2 — Ship the feature.** Build end-to-end. By the end: perform mutating actions in your app (role change, RSVP, check-in) → open the audit browser as admin → see rows with before/after data. Screenshot the audit browser showing at least 3 actions to `student/drills/31-audit-log/02-audit-browser.png`.

**Drill 3 — Test tampering AND redaction.** Connect to your dev database as the APPLICATION role. Try `UPDATE audit_log SET action = 'something else' WHERE id = '<row-id>'`. Save the permission-denied error to the first half of `student/drills/31-audit-log/03-tamper-and-redact.txt`. Then trigger a synthetic password-reset that writes an audit row; SELECT the row and confirm `metadata_json` shows `[REDACTED]` or a hash, never the actual token. Save the SELECT result to the second half.

## Checkpoint question

> A junior developer proposes the audit-log design: every mutation triggers an async background job that inserts an audit row eventually. They argue it's faster and more scalable. Walk through what's wrong with this in 3-4 sentences, naming the two specific failure modes (mutation succeeds + audit fails; audit succeeds + mutation fails) and the structurally-correct alternative.

<!-- Rewriter audit trail
Grounded in verified principles: P61 (cross-org NOT_FOUND in audit browse), P64 (canonical error codes and authorization layer; same principle applied to audit-write fail-closed semantics), and CTO-default retention values from the cto-briefing Section 8 (audit 7 years, error logs 90 days, user content never auto-purge) which the verified-principles encode as the recurring-decision-default cluster
Worked example surface: MembershipKit audit_log table with revoked UPDATE/DELETE + transactional writeAuditLog + redaction
Rewrite date: 2026-05-13
-->
