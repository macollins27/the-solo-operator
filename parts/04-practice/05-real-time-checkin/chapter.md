# Chapter 29 — Practice: Real-time event check-in

## Learning objective

The student ships a real-time check-in feature for MembershipKit: admins watch a live feed of who's arriving at an event, with each new check-in appearing in their browser within seconds — no refresh.

## Prerequisites

- Completed: Chapter 28 — Practice: Event creation and RSVP
- Concepts: feature-build-discipline-loop, timestamptz-utc-storage

## Core concept

Fifth practice. New content: **WebSockets** and the **pub/sub pattern**. The first feature in this course where the browser stays connected to the server and gets pushed updates as they happen.

Architecture in one paragraph: members tap a "check me in" button → API records an `EventCheckin` row → API also publishes a `checkin.created` event to a real-time channel scoped to that event → any browser subscribed to that channel receives the event and updates its UI. The pub/sub layer is **Soketi** (a self-hosted Pusher-compatible WebSocket server). Soketi runs locally in Docker; no SaaS needed.

The narrow spec:

> **Feature: real-time event check-in.**
> 1. A member with an active 'yes' RSVP to an event can check themselves in via a button on the event detail page.
> 2. Check-in creates an `EventCheckin` row: id, eventId, memberId, checkedInAt (UTC timestamp).
> 3. Idempotent — checking in twice for the same event creates only one row.
> 4. After successful check-in, the API publishes a `checkin.created` event to channel `event-<eventId>` with `{ memberId, checkedInAt, memberName }`.
> 5. The admin's event roster page subscribes to `event-<eventId>` and renders new check-ins in real time without page refresh.
> 6. WebSocket auth: only org members can subscribe to that org's event channels.
> 7. Dev: Soketi runs in Docker on localhost:6001. Production: same Soketi config on the deployed VPS.

Seven lines. The pattern (browser-subscribes-to-server-pushes) generalizes to every real-time feature you'll ever build — chat, presence, live counters, notifications, ticker tape.

A few discipline points specific to WebSockets:

- **The browser disconnects sometimes.** Internet drops, tabs sleep, users switch networks. The client library reconnects automatically, but YOUR code shouldn't assume a continuous connection. Treat the WebSocket as "best effort live updates"; the database is the source of truth.
- **Channel auth is real auth.** Anyone with the eventId can try to subscribe to `event-<eventId>`. The Soketi setup must check, on each subscribe attempt, whether the user is allowed. Same auth principles as API routes: deny by default, allow with explicit check.
- **Don't broadcast secrets.** The event payload (`{ memberId, checkedInAt, memberName }`) goes to every subscriber. Member name is fine; email or phone is not. Be specific about what fields ship.

## Worked example

Compressed:

- Spec saved.
- Claude proposes the schema change (`event_checkin` table). You check: timestamptz on `checkedInAt`, unique constraint on `(eventId, memberId)`. ✓
- Claude proposes the API. You eyeball: idempotency via INSERT ... ON CONFLICT DO NOTHING. ✓
- Claude proposes the Soketi setup. You check: docker-compose has Soketi listening on 6001 with a test app id + key + secret in `.env.local`. Claude proposes adding the env vars to `.env.example` (without real secrets). ✓
- Claude proposes the channel-auth endpoint. You eyeball: it calls `requireSession()`, looks up the user's org membership, confirms the requested event belongs to their org, returns the Pusher auth token. ✓
- Claude proposes the admin roster page client. You see Claude wrote `pusher.subscribe('event-${eventId}')` and bound to `checkin.created`. ✓
- You wire it up. Open two browser windows: admin on the roster page, member on the event detail page. Member clicks check-in. Admin's roster updates within 1 second. ✓
- You disconnect the member's wifi briefly, reconnect, click check-in again. Idempotent — no second row. ✓
- Commits per step.

## The rule

> Real-time features publish events; subscribers render. The database is the source of truth; the WebSocket is best-effort live updates. Channel subscription requires real auth, same as API routes. Don't broadcast fields you wouldn't put on an API response.

## Common mistakes

**Mistake 1 — Assuming the WebSocket is always connected.** Code that only updates the UI via WebSocket events misses the case where the connection dropped. The fix: on initial page load and on every reconnect, fetch the current state via REST; THEN apply incoming WebSocket events on top. Belt + suspenders.

**Mistake 2 — Channel auth that's missing or rubber-stamps.** Anyone who guesses an eventId can subscribe and watch the live roster. The channel-auth endpoint must do the same scoping checks your API routes do. "Authenticate then authorize" applies to subscriptions too.

**Mistake 3 — Broadcasting fields you wouldn't put on the API.** A check-in event payload of `{ memberName, memberEmail, memberPhone }` is a privacy fail — every subscriber sees every member's contact info. Decide what's safe to broadcast and ship only that.

## Drill

Artifacts in your fork.

**Drill 1 — Author the spec.** Create `student/specs/real-time-checkin.md` with at least 7 numbered lines including channel auth, idempotency, and field-scope discipline. Save path to `student/drills/29-real-time-checkin/01-spec-path.txt`.

**Drill 2 — Ship the feature.** Build it end-to-end. By the end you should be able to open two browser windows side by side (admin + member), have the member click "check in," and watch the admin's roster update within ~1 second. Take a screenshot of both windows side by side (or sequential screenshots showing the before/after of the admin's view), save to `student/drills/29-real-time-checkin/02-realtime-update.png`.

**Drill 3 — Channel-auth test.** Try to subscribe to a channel you shouldn't be allowed to (e.g., `event-some-other-orgs-event-id`) using the browser's developer tools or a small script. Confirm the subscription is denied. Save the denial response or your observation to `student/drills/29-real-time-checkin/03-channel-auth-test.txt`.

## Checkpoint question

> Your real-time feature ships. A week later a security researcher tells you they were able to listen to every event channel across every organization just by guessing channel names. You're surprised because the channels need an auth token to subscribe. Walk through what's probably wrong, in 2-3 sentences, and where you'd look first to fix it.
