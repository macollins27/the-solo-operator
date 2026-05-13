# Chapter 26 — Practice: Dues plan and subscription

## Learning objective

The student ships a working dues-plan model and member-subscription flow for MembershipKit: an admin can create a plan with a price and billing interval, and a member can subscribe to it via Stripe test mode.

## Prerequisites

- Completed: Chapter 25 — Practice: Auth flow for MembershipKit
- Concepts: feature-build-discipline-loop, spec-as-authority

## Core concept

Second practice chapter. Same discipline loop as auth (spec → recommendation → build → verify → intervene → commit), different feature, more money. Specifically: money. This feature introduces the rule operators learn early and never forget: **money is stored as integer cents, never as floating-point dollars**.

Why integer cents: floating point math is lossy. `0.1 + 0.2` in JavaScript equals `0.30000000000000004`. For dues, taxes, totals, this rounds wrong eventually — and rounding errors in money are how class-action lawsuits start. Operators store cents (`bigint` or `integer` column type), do all arithmetic in cents, and only convert to dollars at the display layer. Once. Carefully.

The narrow spec for this chapter:

> **Feature: dues plans and subscriptions.**
> 1. Admin (org-owner role) can create a dues plan: name, monthly amount in cents, billing interval ('monthly' or 'annual').
> 2. The monthly amount must be a positive integer; reject zero or negative values.
> 3. Plans belong to one Organization. Members of that org can view their org's plans.
> 4. A member can subscribe to a plan. Each member has at most one active subscription per org.
> 5. Subscription uses Stripe (test mode for now). On checkout success, the Subscription row is updated to status='active'.
> 6. Money is stored as integer cents everywhere. No floats. No `parseFloat`. No `toFixed`.
> 7. The plan-create form validates monthlyAmountCents > 0 client-side AND server-side; both fail gracefully with the same error message.

Seven lines. Authoritative. The whole rest of the build defers to this.

This chapter is also where you'll meet **Stripe test mode** — the real Stripe API but with test cards (like `4242 4242 4242 4242`) that never charge real money. Your Anthropic-account-grade dev environment can fully exercise Stripe without a real card on file.

## Worked example

Some of what'll happen in your session (compressed):

- You write the spec, save it at `student/specs/dues-plan.md`.
- You ask Claude to plan the feature against the spec. Claude lists assumptions ("schema columns will be `dues_plan_id`, `organization_id`, `name`, `monthly_amount_cents`, `billing_interval`; subscription table similar"). You approve.
- Claude generates the Drizzle migration. You eyeball it: `monthlyAmountCents` is `bigint`, NOT `numeric`. Good — money discipline applied. You apply the migration.
- Claude generates the create-plan API route. You see Claude wrote `monthlyAmount: z.number()`. Anti-pattern: not enforced to be integer cents. You intervene: "The Zod schema must be `z.number().int().positive()` AND named `monthlyAmountCents` to make the unit explicit." Claude updates.
- Claude generates the form. You eyeball: there's a `parseFloat` somewhere. Anti-pattern: floats touching money. You intervene: "Replace `parseFloat` with `parseInt`. The form's input should be in dollars, but you multiply by 100 on the client to get cents before sending. Do this in a single helper called `dollarsToCents` so the conversion is named." Claude updates.
- Stripe setup: Claude asks "should I use Stripe Subscriptions or Payment Intents?" Anti-pattern: menu. You redirect: "Pick one with reasoning." Claude recommends Subscriptions (recurring billing pattern matches the feature). You approve.
- You wire up the test mode keys per `.env.local`. You navigate to the form, fill it out, use test card `4242 4242 4242 4242`. Subscription appears in your Stripe test dashboard.
- You commit per step: schema, API, form, Stripe integration. Five small commits.

End state: a working dues plan with a working subscription. Money discipline preserved throughout.

## The rule

> Money is integer cents. Always. Every column, every Zod schema, every variable name: `*_cents`. No floats. No `parseFloat`. No `toFixed`. Convert to dollars exactly once, at the display boundary. This rule has saved more careers than any other line in this course.

## Common mistakes

**Mistake 1 — Storing money as `numeric` or `decimal` in the database.** It feels right ("money has decimal places"). It's wrong (rounding, format ambiguity, currency confusion). Integer cents in a `bigint` column. Always.

**Mistake 2 — `parseFloat` ever touching money.** Even once. The form input might be a string like `"24.99"`. Parse that as a float, multiply by 100, you get `2498.999999...`. Round it, you get `2499`. Off-by-one penny errors compound. The right path: parse as `Number(value)` THEN check `Number.isInteger(value * 100)` OR use a tested cents-conversion helper.

**Mistake 3 — Letting Stripe webhook handling slide.** Stripe sends webhooks for subscription lifecycle events (active, past_due, canceled). If you don't handle them, your DB's `subscription.status` drifts from reality. Your spec line 5 says "On checkout success, the Subscription row is updated to status='active'." How does that happen? Via webhook. Stub the webhook handler in this chapter even if you only handle the success case — Chapter 30 will deepen it.

## Drill

Artifacts go in your fork. The feature is real.

**Drill 1 — Author the spec.** Create `student/specs/dues-plan.md` with at least 7 spec lines including the money-as-integer-cents rule. Save the path to `student/drills/26-dues-plan/01-spec-path.txt`.

**Drill 2 — Ship the feature.** Build it end-to-end. By the end you should be able to (a) sign in as an admin, (b) create a dues plan via the UI, (c) sign in as a member, (d) subscribe to that plan using Stripe test card `4242 4242 4242 4242`, and (e) see the subscription as 'active' in your database. Screenshot the active subscription (either in your app's UI or in the Stripe test dashboard) and save to `student/drills/26-dues-plan/02-subscription.png`.

**Drill 3 — Money discipline log.** Document at least one specific moment in your session where you caught a money-discipline violation (or where Claude proactively used integer cents). Format:

```
Where: <file path>
What Claude did first: <e.g. "z.number().positive() for monthlyAmount">
My intervention or Claude's correct pattern: <what was applied>
Why it matters: <one sentence>
```

Save to `student/drills/26-dues-plan/03-money-discipline.txt`.

## Checkpoint question

> A coworker shows you their version of MembershipKit and proudly points to the dues schema: `monthly_amount DECIMAL(10, 2)`. They say "this gives me dollars-and-cents precision." Walk through what's wrong with this in 2-3 sentences, and what they'd need to change (schema, code, tests) to fix it — without preaching about it.
