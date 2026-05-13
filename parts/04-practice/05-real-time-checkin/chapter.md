# Chapter 29 — Practice: Real-time event check-in

## Learning objective

The student ships a real-time check-in feature for MembershipKit: admins watch a live feed of who's arriving at an event, with each new check-in appearing in their browser within seconds — no refresh.

## Prerequisites

- Completed: Chapter 28 — Practice: Event creation and RSVP
- Concepts: feature-build-discipline-loop, timestamptz-utc-storage

## Core concept

Fifth practice. New content: **WebSockets**, **pub/sub channel auth**, **field-scope discipline on broadcast payloads**, and the operator-discipline lesson that started one specific anti-pattern: **the false-refusal that a feature can't be implemented "without a paid VPS."**

Architecture in one paragraph: a member taps "check me in" → the API records an `EventCheckin` row → the API publishes a `checkin.created` event to a channel scoped to that event → any browser subscribed to that channel receives the event and updates its UI. The pub/sub layer is Soketi (self-hosted Pusher-compatible WebSocket server). Soketi runs locally in Docker; no SaaS needed.

That last detail is the operator-discipline lesson. The naive AI response to "set up Soketi" can be "self-hosting requires a paid VPS" — a manufactured constraint that doesn't exist. Soketi is open-source; `docker run` makes it work locally. The right operator response: pushback. "Show me what you tried. Show me the documentation. Try the docker-compose path." The AI finds the obvious answer in one or two tool calls; the false-refusal evaporates. This pattern recurs across infrastructure features ("I can't browser-validate from CLI," "this needs an API key you must provide"). Demand proof of the limit before accepting it.

The narrow spec:

> **Feature: real-time event check-in.**
> 1. A member with an active 'yes' RSVP can check in via a button on the event detail page.
> 2. Check-in creates an `event_checkin` row: id, eventId, memberId, checkedInAt (`timestamptz`), within a transaction joined with an audit-log insert.
> 3. Idempotent: re-clicking creates no second row. Enforced via unique `(event_id, member_id)` constraint plus `ON CONFLICT DO NOTHING`.
> 4. After successful check-in, the API publishes `checkin.created` to channel `event-<eventId>` with payload `{ memberId, checkedInAt, memberDisplayName }`.
> 5. The admin's event roster page subscribes to `event-<eventId>` and renders new check-ins in real time without page refresh.
> 6. Channel auth: only org members can subscribe to that org's event channels. The auth endpoint calls `requireSession()`, verifies the user's org membership, confirms the requested event belongs to their org, returns the auth token. Deny by default.
> 7. The broadcast payload includes only the fields safe to ship to every subscriber. `memberDisplayName` is fine; `email`, `phone`, `address` are forbidden — fields you wouldn't put on an unauthenticated API response don't belong on a broadcast.
> 8. Dev: Soketi runs in Docker on `localhost:6001`. Production: same Soketi config on the deployed VPS. Local-CI parity: the same docker-compose runs in both environments.

Eight lines. Pub/sub architecture; channel auth as real auth; field-scope discipline.

Three WebSocket-specific points:

**Browser disconnects.** Internet drops, tabs sleep, networks switch. Client library reconnects; your code should not assume continuous connection. Database is truth; WebSocket is best-effort delta-delivery. On initial load and every reconnect, fetch current state via REST; then apply incoming events on top.

**Channel auth is real auth.** Anyone with `eventId` can attempt subscribe. The Soketi auth endpoint checks, on each subscribe, whether the user is allowed. Same principles as API routes: deny by default; org+event scope check; return NOT_FOUND-equivalent on cross-org (no enumeration via channel-auth codes).

**Don't broadcast sensitive fields.** Payload goes to every subscriber. Decide field-scope deliberately; mirror API response scoping. If a field requires auth+role to fetch via REST, it doesn't belong on a broadcast.

## Worked example

Compressed:

- Spec saved.
- AI proposes the schema. You check: `timestamptz` on `checked_in_at`; unique `(event_id, member_id)`. ✓
- AI proposes the API. You eyeball: idempotency via `INSERT ... ON CONFLICT DO NOTHING`. Within a transaction. ✓
- AI proposes Soketi setup. Initial response: "Setting up Soketi requires a paid VPS." False-refusal — Soketi is open-source software. You intervene: "Soketi runs in Docker locally. Try `docker-compose up soketi` with the standard config. Show me what you tried." The AI investigates, finds the docker-compose path, ships a working local Soketi on port 6001 in three tool calls.
- AI proposes the channel-auth endpoint. You eyeball: calls `requireSession()`, looks up user's org membership, verifies the requested event belongs to their org. Cross-org subscribe attempt returns the same deny response as a non-existent event — no enumeration via the channel-auth response. ✓
- AI proposes the admin roster client. First draft: subscribes to `event-${eventId}` and only updates via WebSocket events. You catch: a disconnect during the event would silently miss check-ins until reconnect. You intervene: "On page load and on every reconnect, fetch the current roster via REST. Then apply incoming WebSocket events on top. Belt + suspenders."
- AI proposes the broadcast payload `{ memberId, memberName, memberEmail, memberPhone, checkedInAt }`. Field-scope violation. You intervene: "Email and phone are not on the broadcast. Payload is `{ memberId, checkedInAt, memberDisplayName }` only. The admin can fetch contact details via REST if needed; the broadcast doesn't carry them."
- Playwright MCP: open two browser windows. Admin on the roster page; member on the event detail page. Member clicks check-in. Admin's roster updates within ~1 second. ✓
- Disconnect the member's wifi briefly, reconnect, click check-in again. Idempotent — no second row. ✓
- Commits per step.

## The rule

> Real-time features publish events; subscribers render. The database is source of truth; the WebSocket is best-effort live updates. Channel subscription requires real auth, same as API routes. Don't broadcast fields you wouldn't put on an unauthenticated API response. And: when the AI claims infrastructure needs a paid service, demand proof — false-refusal is a recurring failure mode.

## Common mistakes

**Mistake 1 — Trusting the AI's "this requires a paid service" claim without pushback.** Mature operators have lost real money to this pattern — paying months of subscription fees for SaaS substitutes when the open-source self-hosted version was available locally via `docker run`. The discipline is mandatory pushback: "Show me the tool you tried, the error it returned, and the documentation you consulted." Most claimed infrastructure constraints don't exist; the AI surfaced them from training-data priors.

**Mistake 2 — Assuming the WebSocket is always connected.** Code that only updates the UI via WebSocket events misses the case where the connection dropped. On initial load AND every reconnect, fetch current state via REST; then apply incoming WebSocket events on top. The database is truth; the WebSocket is delta-delivery.

**Mistake 3 — Channel auth that rubber-stamps.** Anyone who guesses an `eventId` can subscribe and watch the live roster. The channel-auth endpoint must do the same org+role scoping checks the API routes do. "Authenticate then authorize" applies to subscriptions. Cross-org attempts return the same deny response as a non-existent event — no enumeration.

**Mistake 4 — Broadcasting fields you wouldn't return unauthenticated.** A payload of `{ memberName, memberEmail, memberPhone }` is privacy fail — every subscriber sees every member's contact info, regardless of whether each subscriber individually has access to those fields via REST. Decide field scope by the same rule as API responses; cap to the minimum every subscriber should see.

## Drill

Artifacts in your fork.

**Drill 1 — Author the spec.** Create `student/specs/real-time-checkin.md` with at least 8 numbered lines including channel auth scoping, idempotency via unique constraint, field-scope discipline on the broadcast payload, and the database-as-truth / WebSocket-as-delta architecture. Save path to `student/drills/29-real-time-checkin/01-spec-path.txt`.

**Drill 2 — Ship the feature.** Build it end-to-end with Soketi running locally in Docker. By the end you should open two browser windows side by side — admin + member — have the member click "check in," and watch the admin's roster update within ~1 second. Screenshot both windows side by side to `student/drills/29-real-time-checkin/02-realtime-update.png`.

**Drill 3 — Channel-auth test.** Attempt to subscribe to a channel you shouldn't be allowed to (`event-some-other-orgs-event-id`) using browser dev tools or a small script. Confirm the subscription is denied. Save the denial response (or your observation) to `student/drills/29-real-time-checkin/03-channel-auth-test.txt`.

## Checkpoint question

> Your real-time feature ships. A week later a security researcher tells you they were able to subscribe to every event channel across every organization just by guessing channel names. You're surprised because the channels need an auth token. Walk through what's probably wrong in 2-3 sentences — name where the check is missing, what an attacker exploits, and what the auth endpoint must verify before issuing the token.

<!-- Rewriter audit trail
Grounded in verified principles: P3 (push first, accept "no" second — false-refusal patterns: "self-hosting requires a paid VPS"; Maxwell paid ~$100/mo for months on a false claim; demand proof of the limit), P61 (cross-org access scoping; channel-auth applies same org-scoping rules), P54 (local-gate-equals-CI parity — same docker-compose in dev and CI)
Worked example surface: MembershipKit event check-in with self-hosted Soketi in Docker
Rewrite date: 2026-05-13
-->
