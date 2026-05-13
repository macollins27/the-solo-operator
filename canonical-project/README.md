# MembershipKit — the canonical teaching project

This is the running example every chapter of the course builds against.

You — the student — are going to build a working membership manager from scratch, one feature at a time, across all 50 chapters. By the end you'll have a real piece of software you can deploy and use for any community you belong to.

The course's `canonical-project/` is the REFERENCE implementation. Your own work lives in `student/canonical-project/` inside your fork of the course repo. Each drill adds one feature to your fork. You compare your work against the reference when you're stuck.

## What MembershipKit does

MembershipKit is a self-hostable membership manager for small communities — a gym, a church group, a neighborhood association, a club, a nonprofit chapter, a co-op, a school PTA. Anyone running a community where people pay dues, attend events, and share documents can use it.

Concretely:

- An admin creates a community, invites the first members, and sets up a dues plan
- Members sign up, pay their dues, RSVP to events, and check in at the door
- The admin can see who's paid, who's overdue, who's attended what, and message everyone at once
- An AI assistant answers questions like "Who's overdue on dues?", "Summarize last month's events", "Find members who attended the last three meetings"
- Every state change (a payment recorded, a member promoted, an event created) is written to an audit log

The product is small enough that a single non-engineer can understand the whole thing. It's also surface-rich enough to teach every pattern in the course — auth, multi-tenancy, money, real-time, file storage, background jobs, AI, audit trail.

## Domain entities

| Entity | Description |
|---|---|
| `Organization` | A community using MembershipKit. The multi-tenant boundary — all other rows scope to one. |
| `User` | Anyone with an account. Belongs to zero or more Organizations via `Membership`. |
| `Membership` | A User's relationship to an Organization. Carries `role` (admin / manager / member / guest) and permission columns. |
| `MembershipPlan` | A community's dues structure: `$25/month`, `$250/year`, free, etc. |
| `Subscription` | A Member's active plan. Tracks status (active / past_due / canceled) and renewal date. |
| `Payment` | A transaction record. Amount in integer cents. Linked to a Subscription and a Stripe charge. |
| `Event` | A community event: meeting, workshop, party, service day. Has start/end timestamps, location, capacity, description. |
| `EventCheckin` | A Member's attendance at an Event. Created in real-time when someone arrives. |
| `Document` | An uploaded file: bylaws PDF, member photo, receipt scan. Stored in S3 / local MinIO. |
| `Notification` | An activity-feed entry: "Sarah paid $25 on May 1", "Event 'Spring Cleanup' was created". |
| `AuditLog` | Every state-changing action recorded with actor, action, target, before/after, timestamp. |

## Tech stack

| Layer | Tool | Why |
|---|---|---|
| Framework | Next.js (App Router) | Server components for data fetching, client components for interactivity, one deploy target |
| Language | TypeScript (strict) | Type safety from DB schema to UI props |
| Database | Postgres + Drizzle ORM | Type-safe schema in TypeScript, the same shape on disk and in code |
| Auth | Better Auth | Self-hosted, supports cookies and bearer tokens (mobile-ready) |
| API | tRPC v11 | End-to-end type safety; calling a procedure feels like a function call |
| Payments | Stripe (test mode) | Subscription billing, the industry standard |
| Real-time | Soketi (self-hosted Pusher protocol) | WebSocket server you run in Docker locally; no SaaS dependency |
| File storage | AWS S3 / local MinIO | Presigned uploads; works the same in development and production |
| AI | Anthropic Claude API | Member directory search, event summaries, dues triage |
| Tests | Vitest + Playwright | Unit + integration + end-to-end browser tests |

Stack choices are deliberate. Every tool is widely used, well-documented, free or has a free tier large enough for course use, and runs cleanly on a Mac or Windows laptop with no commercial license.

## Build path across the course

The chapters are organized into six parts. Here's what gets built where.

**Part 0 — Why You're Here.** No code. Orientation only.

**Part 1 — Foundations (chapters 1–8).** You install everything. You clone the course repo. You start a Claude Code session. You run the reference `canonical-project/` and see MembershipKit running on `localhost:3000`. You do not write code yet; you learn what's on your screen.

**Part 2 — The Mindset (chapters 9–18).** Each chapter teaches one principle. The drills are small: introduce a deliberate bug, watch how Claude handles it; ask Claude to make a tiny change to your `student/canonical-project/` and verify the change matches what you asked for; observe an anti-pattern in a constructed AI transcript and name it.

**Part 3 — The Mechanics (chapters 19–24).** You start writing your own configuration. Your own `CLAUDE.md` for your fork. Your first skill. Your first hook. Your first MCP query. You configure your AI to work the way you want it to.

**Part 4 — The Discipline in Practice (chapters 25–31).** You build major features against your fork. Auth flow. Dues plan creation. Member invite. Event creation. Real-time check-in. AI directory search. Each drill ships a real feature you can demo.

**Part 5 — Hero Level (chapters 32–38).** You compose the discipline at scale. You build a Stop-hook anti-pattern classifier against your fork. You build a small MCP server that indexes your canonical-project's domain rules. You run a multi-agent dispatch where one fork designs a feature, another builds it, another reviews. You see your system catch its own failures.

**Part 6 — Authoring Your Own (chapters 39–50).** You apply everything to a project of your own choosing. Could be MembershipKit for a community you actually belong to. Could be a completely different project. You learn how to extract the patterns and apply them anywhere.

By the end of chapter 50 your `student/canonical-project/` is a working membership manager. You can deploy it. You can use it. You can show your friends what you built.

## Reference vs student work

The course's `canonical-project/` is the REFERENCE. It's the answer key. It's what MembershipKit looks like when it's done.

Your `student/canonical-project/` is YOUR build. You write it across the drills. It will look different from the reference in places — your own commenting style, your own naming choices, your own design tweaks. The drills don't require pixel-matching the reference; they require the feature to work and the `verify.sh` for that chapter to pass.

When you're stuck, you compare. When you're done with a chapter's drill, you commit your fork.

## Status of this directory

This directory is the reference implementation in progress. As the course is authored, code lands here chapter by chapter — same way you'll build your own fork. The reference is always one step ahead of the student so you can compare without spoilers.

## License

MembershipKit (the canonical project) is MIT-licensed. The course content around it is separately licensed (see top-level `LICENSE`). You can deploy MembershipKit for your own community at no cost.
