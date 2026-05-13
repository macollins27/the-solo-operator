# Chapter 28 — Practice: Event creation and RSVP

## Learning objective

The student ships event creation and RSVP for MembershipKit: an admin creates an event with date, time, and capacity; members can RSVP yes/no/maybe; the system shows a roster and prevents over-capacity.

## Prerequisites

- Completed: Chapter 27 — Practice: Member invitation flow
- Concepts: feature-build-discipline-loop, atomic-claim-via-update-with-predicate

## Core concept

Fourth practice. New content: **dates and timezones**, **capacity limits with concurrency**, **enum constraints**. These three patterns recur across most real apps.

The narrow spec:

> **Feature: events and RSVPs.**
> 1. Admin (org-owner / org-admin / manager) creates an event: title, description, startsAt, endsAt, location, capacity (nullable; null = unlimited).
> 2. startsAt and endsAt are stored as `timestamptz`. Times entered in admin's local timezone are converted to UTC on the way in.
> 3. Members can RSVP with status: 'yes' | 'no' | 'maybe'. Stored as enum.
> 4. A member has at most one active RSVP per event. Re-RSVP updates the existing row, doesn't create a new one.
> 5. If capacity is set and the event already has `capacity` yes-RSVPs, additional yes-RSVPs fail with "Event is at capacity." Concurrency-safe.
> 6. Event detail page shows: event metadata + count of yes/no/maybe + list of yes-RSVPs (for admins) or yes/maybe count only (for members).
> 7. Event creation validates: startsAt < endsAt; capacity (if set) is a positive integer.

Seven lines. Date discipline, enum discipline, concurrency discipline.

Why each:

- **`timestamptz` everywhere.** Stores as UTC; postgres handles the timezone tag. The display layer converts to the user's local time. Storing as bare `timestamp` (without timezone) is how you get the bug where every event shifts by 5 hours when daylight saving changes.
- **Enum stored as a TEXT or enum column with a CHECK constraint** ('yes', 'no', 'maybe'). Don't use `varchar` with no constraint — that lets typos in.
- **Re-RSVP updates the existing row.** Implementation: `INSERT ... ON CONFLICT (eventId, memberId) DO UPDATE`. One row per (event, member), regardless of how many times they re-RSVP.
- **Capacity check is concurrency-safe.** The simple version — count yes-RSVPs, then insert if under capacity — races. Two members RSVP'ing simultaneously can both pass the check. The fix: wrap in a transaction with `SELECT ... FOR UPDATE` on the event row, OR use a single SQL statement that counts and inserts atomically.

## Worked example

Compressed:

- Spec saved.
- Claude proposes schema. You check: startsAt/endsAt are `timestamptz`. RSVP table has `(eventId, memberId)` unique constraint. Status uses Postgres enum or CHECK. ✓
- Claude proposes the create-event form. You eyeball: the form takes "May 15, 2026, 7pm in New York" — does it serialize to UTC correctly? You ask Claude to walk you through the date handling. Claude shows the form sends an ISO string with the admin's timezone offset; the server uses `new Date(isoString)` which normalizes to UTC. ✓
- Claude proposes RSVP API. You see the implementation uses INSERT-then-COUNT-then-DELETE-on-overflow. Anti-pattern: TOCTOU race + clumsy. You intervene: "Use ON CONFLICT for the upsert, and check capacity in the same transaction using SELECT FOR UPDATE on the event row." Claude rewrites.
- You test: create event with capacity=2, sign in as three different members, all RSVP yes. Third one gets "Event is at capacity." ✓
- You test the timezone: create an event at 7pm New York time; verify the database row is stored at 23:00 UTC (or 00:00 the next day during DST); verify the event displays as 7pm to admin AND 7pm to a member also in NY timezone. ✓
- Commits per step.

## The rule

> Dates: timestamptz, UTC in the database, local in the display. Enums: real enums or CHECK constraints, never naked strings. Capacity: transactional or atomic, never check-then-insert. These three rules apply to every event-like, status-like, or limit-like feature you'll ever build.

## Common mistakes

**Mistake 1 — Bare `timestamp` columns.** Without `with time zone`, the database stores no timezone info. The app pretends the value is UTC; the database returns it as whatever the connection's TZ session var is. Different developers, different timezones, different bugs. Always `timestamptz`.

**Mistake 2 — TOCTOU on capacity.** "First count the yes-RSVPs, then insert if under capacity" is the textbook race. Two requests pass the check, two requests insert, capacity exceeded. The fix is atomic — either a transaction with `SELECT ... FOR UPDATE`, or a single SQL `INSERT ... WHERE (SELECT COUNT ...) < capacity`, or an explicit lock on the event row. Pick one; commit to it.

**Mistake 3 — Status as `varchar`.** A `status varchar(20)` column accepts any string. Tomorrow somebody writes `"yse"` instead of `"yes"` in a query and the bug ships. Postgres enums or CHECK constraints prevent this at the database level. Application validation also helps, but the database is the last line of defense — use it.

## Drill

Artifacts in your fork.

**Drill 1 — Author the spec.** Create `student/specs/event-rsvp.md` with at least 7 numbered spec lines including: timestamptz storage, enum constraint, capacity concurrency-safe. Save path to `student/drills/28-event-rsvp/01-spec-path.txt`.

**Drill 2 — Ship the feature.** Build it end-to-end. By the end you should be able to: sign in as admin, create an event with capacity=2 and a specific time → sign in as 3 members → first two RSVP yes successfully → third RSVP yes gets "Event is at capacity" → admin sees the roster of 2 yes-RSVPs. Screenshot one of these views (roster or full-capacity error) and save to `student/drills/28-event-rsvp/02-event-state.png`.

**Drill 3 — Verify timestamptz.** Run a SQL query against your dev database to confirm the event's `startsAt` column type. The query is `SELECT column_name, data_type FROM information_schema.columns WHERE table_name='events' AND column_name LIKE '%_at';` or similar. Save the result to `student/drills/28-event-rsvp/03-timestamp-types.txt`. All `_at` columns should show `timestamp with time zone`.

## Checkpoint question

> A teammate ships an event feature where `startsAt` is stored as a `timestamp` (no time zone). It works locally. In production, all events appear shifted by exactly 4 hours for users in Eastern time. They ask you what happened. Walk through the bug in 2-3 sentences, name what to change, and explain why the database column choice matters even when the application code "looks fine."
