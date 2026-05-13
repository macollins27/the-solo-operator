# Chapter 28 — Practice: Event creation and RSVP

## Learning objective

The student ships event creation and RSVP for MembershipKit: an admin creates an event with date, time, and capacity; members can RSVP yes/no/maybe; the system shows a roster and prevents over-capacity.

## Prerequisites

- Completed: Chapter 27 — Practice: Member invitation flow
- Concepts: feature-build-discipline-loop, atomic-claim-via-update-with-predicate

## Core concept

Fourth practice. New content: **timestamptz everywhere**, **TOCTOU on capacity limits via SELECT FOR UPDATE**, **canonical FORBIDDEN error messages**. Three patterns that recur across most real apps.

The narrow spec:

> **Feature: events and RSVPs.**
> 1. Admin (org-owner / org-admin / manager) creates an event: title, description, startsAt, endsAt, location, capacity (nullable; null = unlimited).
> 2. `startsAt` and `endsAt` are stored as `timestamptz`. The application converts to user timezone only at the display boundary. No bare `TIMESTAMP` columns anywhere.
> 3. Members can RSVP with status: 'yes' | 'no' | 'maybe'. Stored as Postgres enum or text with CHECK constraint.
> 4. A member has at most one active RSVP per event. Re-RSVP updates the existing row via `INSERT ... ON CONFLICT (event_id, member_id) DO UPDATE`.
> 5. If capacity is set and the event already has `capacity` yes-RSVPs, additional yes-RSVPs fail with the canonical error: `FORBIDDEN` code, message exactly `"Event is at capacity"`. Concurrency-safe via transaction + `SELECT ... FOR UPDATE` on the event row.
> 6. Event detail page shows: event metadata + count of yes/no/maybe + list of yes-RSVPs (for admins) or yes/maybe count only (for members).
> 7. Event creation validates: `startsAt < endsAt`; capacity (if set) is a positive integer; capacity capped at `2147483647`.
> 8. Cross-organization event access returns `NOT_FOUND`, never `FORBIDDEN` — the organizationId predicate is in the SQL WHERE clause.

Eight lines. Time discipline, enum discipline, concurrency discipline, error-code discipline.

Why each:

**`timestamptz` everywhere.** A `timestamp` column without timezone stores no zone info. The app pretends it's UTC; Postgres returns it as whatever the connection's `TZ` session var is. Different developers, different timezones, different bugs. `timestamptz` stores as UTC and tags the zone; the app converts to user timezone only at display. The rule is mechanical: in mature systems, an ast-grep rule blocks `timestamp("...")` without `{ withTimezone: true }`.

**Enum as Postgres enum or CHECK-constrained text.** A naked `varchar` accepts any string. A typo like `"yse"` instead of `"yes"` ships. The database refuses if you encode the constraint at the column level. Application validation also helps; the database is the last line of defense.

**Capacity check is transactional with SELECT FOR UPDATE.** The naive flow (`SELECT count(*); if (count >= capacity) throw; INSERT`) races. Two concurrent requests pass the count check; both INSERT; capacity exceeded. The fix is mandatory: wrap check-and-insert in a transaction; `SELECT id FROM events WHERE id = $1 FOR UPDATE` locks the event row for the duration of the transaction; the second request waits, sees the updated count, fails the check. Same principle as the atomic claim in Chapter 27, applied to count limits.

**Canonical FORBIDDEN message.** `FORBIDDEN` means authorization failed; `BAD_REQUEST` means the input was malformed. Mixing them confuses the client. The canonical at-capacity error is `FORBIDDEN` with message exactly `"Event is at capacity"` — exact code, exact message, character-by-character. A shared helper builds the error; the review pass compares emitted messages against the canonical string. Every `FORBIDDEN` carries a non-empty message; bare `throw new TRPCError({ code: "FORBIDDEN" })` with no message is forbidden — the message is the load-bearing diagnostic.

## Worked example

Compressed:

- Spec saved.
- AI proposes schema. You check: `starts_at` / `ends_at` are `timestamptz`. RSVP table has `(event_id, member_id)` unique constraint. Status is a Postgres enum `rsvp_status`. ✓
- AI proposes the create-event form. You eyeball: the form takes "May 15, 2026, 7pm in admin's local TZ" and serializes to an ISO string with offset; the server uses `new Date(isoString)` to normalize to UTC. ✓
- AI proposes the RSVP route. First draft: `INSERT ... ON CONFLICT DO UPDATE` for the upsert; capacity check via `SELECT count(*)` THEN conditional insert. Race condition. You intervene: "Wrap in a transaction. First: `SELECT id, capacity FROM events WHERE id = $1 AND organization_id = $2 AND deleted_at IS NULL FOR UPDATE` — locks the event row. If zero rows: `throw new TRPCError({ code: 'NOT_FOUND' })`. Then count yes-RSVPs; if `count >= capacity`, throw `FORBIDDEN` with exact message `Event is at capacity`. Else upsert."
- AI proposes the event detail. You catch: cross-org access via `SELECT * FROM events WHERE id = $1; if (event.organizationId !== orgId) throw FORBIDDEN`. Same anti-pattern as Chapter 26. You intervene: "Org predicate in the SQL WHERE; zero rows → NOT_FOUND."
- AI proposes a bare `throw new TRPCError({ code: "FORBIDDEN" })` for the capacity case (no message). You intervene: "Every FORBIDDEN carries a non-empty message. The capacity message is the canonical string `Event is at capacity`."
- Playwright MCP: create event with capacity=2; sign in as three different members; first two RSVP yes successfully; third gets FORBIDDEN with the canonical message. Roster shows two yes-RSVPs to the admin. ✓
- SQL verification: `SELECT column_name, data_type FROM information_schema.columns WHERE table_name='events';` confirms `_at` columns are `timestamp with time zone`. ✓
- Commits per step.

## The rule

> Dates: `timestamptz`, UTC in the database, local in the display. Enums: real enums or CHECK constraints, never naked strings. Capacity: transactional with `SELECT ... FOR UPDATE`, never check-then-insert. Error codes: `FORBIDDEN` means auth, `BAD_REQUEST` means input — canonical message per condition, exact text, never bare.

## Common mistakes

**Mistake 1 — Bare `timestamp` columns.** Without `with time zone`, Postgres stores no timezone info; behavior depends on the connection's TZ session var. The bug surfaces in production when one user is in a different timezone from the developer who shipped. Always `timestamptz`. The discipline is enforceable mechanically: ast-grep rule `no-naked-timestamp`.

**Mistake 2 — TOCTOU on capacity.** Check-then-insert races at boundary load. Two requests pass the check; both insert; the limit is exceeded. The fix is a transaction with `SELECT ... FOR UPDATE` on the parent row. Same shape as the atomic claim in Chapter 27. Pick the pattern; commit to it.

**Mistake 3 — Bare `FORBIDDEN` with no message.** `throw new TRPCError({ code: "FORBIDDEN" })` with empty message is forbidden — clients can't distinguish causes, debugging surfaces become hostile. Every FORBIDDEN carries a non-empty, canonical message. The capacity message is exactly `"Event is at capacity"`; the missing-active-org message is exactly `"Active organization required"`. Character-by-character match.

**Mistake 4 — Status as `varchar` with no constraint.** `status varchar(20)` accepts any string. A typo ships. The database is your last line of defense — use it. Postgres enums or CHECK constraints prevent the bug at the column level; application validation is the first line, the database is the last.

## Drill

Artifacts in your fork.

**Drill 1 — Author the spec.** Create `student/specs/event-rsvp.md` with at least 8 numbered lines including: `timestamptz` storage, enum/CHECK status, capacity via `SELECT FOR UPDATE`, canonical `FORBIDDEN` message for at-capacity, NOT_FOUND for cross-org. Save path to `student/drills/28-event-rsvp/01-spec-path.txt`.

**Drill 2 — Ship the feature.** Build end-to-end. By the end you should be able to: sign in as admin, create an event with capacity=2 at a specific time → sign in as 3 members → first two RSVP yes → third gets `Event is at capacity` → admin sees the roster of 2 yes-RSVPs. Screenshot the roster or the capacity error to `student/drills/28-event-rsvp/02-event-state.png`.

**Drill 3 — Verify timestamptz.** Run `SELECT column_name, data_type FROM information_schema.columns WHERE table_name='events' AND column_name LIKE '%_at';`. Save the result to `student/drills/28-event-rsvp/03-timestamp-types.txt`. All `_at` columns should show `timestamp with time zone`.

## Checkpoint question

> A teammate ships an event feature where `starts_at` is `timestamp` (no time zone). It works locally. In production, all events display shifted by exactly 4 hours for users in Eastern time. They also tell you the capacity check is a `SELECT count(*); if (count >= cap) throw; INSERT` flow. Walk through BOTH bugs in 3-4 sentences — name the timezone class, name the TOCTOU class, and what to change at the column and query layers.

<!-- Rewriter audit trail
Grounded in verified principles: P65 (TOCTOU on count limits via SELECT FOR UPDATE on parent row within transaction), P64 (FORBIDDEN means authorization, BAD_REQUEST means malformed input; canonical message per condition, exact text, character-by-character match; bare FORBIDDEN with no message is forbidden), P61 (cross-org access returns NOT_FOUND not FORBIDDEN)
Worked example surface: MembershipKit event with capacity=2 + transactional RSVP claim
Rewrite date: 2026-05-13
-->
