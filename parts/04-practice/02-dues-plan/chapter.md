# Chapter 26 — Practice: Dues plan and subscription

## Learning objective

The student ships a working dues-plan model and member-subscription flow for MembershipKit: an admin can create a plan with a price and billing interval, and a member can subscribe to it via Stripe test mode.

## Prerequisites

- Completed: Chapter 25 — Practice: Auth flow for MembershipKit
- Concepts: feature-build-discipline-loop, spec-as-authority

## Core concept

Second practice. Same discipline loop, different feature, with money. This is where you encode the rule mature operators learn early and never abandon: **money is stored as integer cents, never as `numeric` or float.**

Integer cents is the only acceptable money storage format. Every column is `bigint` (or `integer` where the range allows). No `numeric(12,2)` for amounts. No `parseFloat` on money values. No `Number.toFixed` outside a sanctioned conversion helper. Variable names carry the unit explicitly: `monthlyAmountCents`, not `monthlyAmount`. Conversion to dollars happens exactly once, at the display boundary, via a named helper.

The reason is mechanical, not aesthetic. Floating-point arithmetic on money produces silent disagreement: `0.1 + 0.2` evaluates to `0.30000000000000004` in JavaScript. Comparisons silently fail. Sums silently drift. The drift accumulates per-row, per-day, per-month. When discovered six months later, reconciliation requires forensic-level investigation across every row that ever participated in a calculation. Integer cents eliminates the entire class of bug.

The discipline is enforced mechanically when mature: an `ast-grep` rule `no-float-money` blocks `Number.toFixed` outside the sanctioned helper; a hook blocks `parseFloat` on identifiers ending in `Cents` / `Amount` / `Price`. While you're learning, you enforce it via the spec, your CLAUDE.md, and live intervention in the session.

The narrow spec for this chapter:

> **Feature: dues plans and subscriptions.**
> 1. Admin (org-owner role) can create a dues plan: name, monthly amount in cents, billing interval ('monthly' or 'annual').
> 2. The monthly amount must be a positive integer; reject zero or negative values.
> 3. Plans belong to one organization. Members of that org can view their org's plans.
> 4. A member can subscribe to a plan. Each member has at most one active subscription per org.
> 5. Subscription uses Stripe (test mode). On checkout success, the Subscription row updates to status='active'.
> 6. Money is stored as integer cents EVERYWHERE. No floats. No `parseFloat`. No `Number.toFixed` outside the sanctioned conversion helper.
> 7. The plan-create form validates `monthlyAmountCents > 0` AND `Number.isInteger(monthlyAmountCents)` client-side AND server-side; both fail with the same error message.
> 8. The plan table has a unique index on `(organizationId, name)` AS A PARTIAL INDEX `WHERE deleted_at IS NULL` — soft-deleted plans don't block creating a new plan of the same name in the same org.

Eight lines. Two patterns are doing load-bearing work past money discipline: org-scoping (line 3) and the partial unique index (line 8). Both come up below.

Why the partial index matters: every unique index on a soft-delete table must be partial with `WHERE deleted_at IS NULL`. A full unique index makes soft-deletion irreversible from the UX angle — once a plan named "Premium" is soft-deleted, the user can't create a new plan named "Premium" because the unique index still rejects the insert against the soft-deleted row. The partial index restricts uniqueness to live rows; soft-deleted rows are invisible to the constraint.

This chapter also introduces **Stripe test mode** — the real Stripe API with test cards (`4242 4242 4242 4242`) that never charge real money.

## Worked example

Compressed:

- Spec saved at `student/specs/dues-plan.md`.
- AI plans the feature against the spec. Lists assumptions: schema columns `id`, `organizationId`, `name`, `monthlyAmountCents`, `billingInterval`, `deletedAt`, `createdAt`, `updatedAt`. You approve.
- AI generates the Drizzle migration. You eyeball: `monthlyAmountCents` is `bigint`, NOT `numeric`. ✓ All timestamp columns are `timestamptz`. ✓ The unique index on `(organizationId, name)` includes `WHERE deleted_at IS NULL` — partial index ✓.
- AI generates the create-plan API route. Initial draft: `monthlyAmount: z.number()`. Spec violation: not enforced integer; missing the `Cents` suffix. You intervene: "Zod must be `z.number().int().positive().max(2147483647)` AND named `monthlyAmountCents` to make the unit explicit. Cap at 2^31-1 to prevent overflow."
- AI generates the form. You catch `parseFloat`. You intervene: "Replace `parseFloat` with `Number(value)`; multiply by 100 in a named helper `dollarsToCents(dollars: number): number` that throws if the result isn't an integer."
- AI generates the subscribe route. You eyeball: the cross-organization fetch uses `SELECT * FROM dues_plans WHERE id = $1` then post-fetch checks `row.organizationId !== ctx.session.activeOrganizationId` and throws `FORBIDDEN`. This is the IDOR enumeration anti-pattern. You intervene: "Put the org-scope predicate IN the SQL WHERE clause: `WHERE id = $1 AND organization_id = $2 AND deleted_at IS NULL`. Zero rows → `NOT_FOUND`, not `FORBIDDEN`. `FORBIDDEN` leaks that the row exists in another org."
- Stripe setup: AI asks "Stripe Subscriptions or Payment Intents?" Menu — anti-pattern. You redirect: "Pick one with reasoning." AI recommends Subscriptions (recurring billing matches the feature). Approved.
- You wire test-mode keys to `.env.local`. Navigate via Playwright MCP, fill the form, use test card `4242 4242 4242 4242`. Subscription appears in your Stripe test dashboard.
- Commits per step.

## The rule

> Money is integer cents. Always. Every column `bigint`, every Zod schema `z.number().int().positive()`, every variable name `*Cents`. No `parseFloat`, no `toFixed` outside a sanctioned helper. Cross-organization fetches put the org predicate IN the SQL WHERE clause and return `NOT_FOUND` on zero rows — never `FORBIDDEN`. Unique indexes on soft-delete tables are partial with `WHERE deleted_at IS NULL`.

## Common mistakes

**Mistake 1 — Storing money as `numeric` or `decimal`.** Feels right ("money has decimal places"); is wrong (silent rounding, format ambiguity, currency confusion). Integer cents in a `bigint` column. Conversion to dollars happens at display, once, via a named helper. The discipline is encoded in the column type — the database refuses the wrong shape before the bug can ship.

**Mistake 2 — Cross-organization IDOR with post-fetch FORBIDDEN.** The most pervasive defect class in router code: `SELECT * FROM x WHERE id = $1`, then JS-side `if (row.organizationId !== orgId) throw FORBIDDEN`. Two bugs in one: (a) `FORBIDDEN` leaks that the row exists in another org (enumeration), (b) the SELECT spans organizations. The fix is mandatory: `organizationId` predicate IN the SQL WHERE clause; zero rows → `NOT_FOUND`.

**Mistake 3 — Full unique index on a soft-delete table.** "Unique on `(organization_id, name)` so users can't have two plans with the same name." Soft-deletes a plan; tries to create a new one with the same name; the full index rejects. The fix is the partial index: `CREATE UNIQUE INDEX ... WHERE deleted_at IS NULL`. Constraint applies only to live rows; soft-deleted rows are invisible to it.

**Mistake 4 — Missing integer cap.** `z.number().int().positive()` allows `Number.MAX_SAFE_INTEGER`. Postgres `integer` columns overflow at 2^31-1. Money cents columns should cap explicitly: `.max(2147483647)`. A missing cap is a Category-B source bug, not a design decision.

## Drill

Artifacts go in your fork. The feature is real.

**Drill 1 — Author the spec.** Create `student/specs/dues-plan.md` with at least 8 spec lines including the integer-cents-everywhere rule, the cross-org NOT_FOUND rule, and the partial unique index rule. Save the path to `student/drills/26-dues-plan/01-spec-path.txt`.

**Drill 2 — Ship the feature.** Build end-to-end. By the end you should be able to (a) sign in as admin, (b) create a dues plan via the UI, (c) sign in as a member of the same org, (d) subscribe via Stripe test card, (e) see the subscription as 'active' in your DB. Screenshot the active subscription to `student/drills/26-dues-plan/02-subscription.png`.

**Drill 3 — Money + security discipline log.** Document at least one specific moment in your session where you caught a money-discipline violation OR a cross-org IDOR. Format:

```
Where: <file path>
What AI did first: <e.g. "z.number().positive() for monthlyAmount"
  OR "SELECT * FROM plans WHERE id = $1 then post-fetch
  FORBIDDEN">
My intervention: <what was applied>
Why it matters: <one sentence>
```

Save to `student/drills/26-dues-plan/03-discipline-log.txt`.

## Checkpoint question

> A coworker shows their version of MembershipKit. The schema has `monthly_amount DECIMAL(10,2)`; the API has `SELECT * FROM plans WHERE id = $1; if (row.org_id !== userOrgId) throw FORBIDDEN;`. They say "the precision is great and the auth check is bulletproof." Walk through what's wrong with BOTH choices in 3-4 sentences — name the silent-disagreement risk on money and the enumeration leak on org-scope, and what they need to change at the schema, query, and error-code layers.

<!-- Rewriter audit trail
Grounded in verified principles: P62 (money is integer cents, never numeric or float; ast-grep no-float-money blocks Number.toFixed outside sanctioned helper), P61 (cross-org IDOR uses NOT_FOUND not FORBIDDEN; organizationId predicate IN the SQL WHERE clause; single most pervasive defect class), P63 (partial unique indexes on soft-delete tables, WHERE deleted_at IS NULL)
Worked example surface: MembershipKit dues-plan create + subscribe; Stripe test mode
Rewrite date: 2026-05-13
-->
