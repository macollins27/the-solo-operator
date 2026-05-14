# Chapter 11 — Spec is Truth, Output is Defendant

## Learning objective

The student can name the authority hierarchy of their project (their written intent on top, AI output on the bottom), and refuse to "reconcile" a spec to match what Claude actually produced.

## Prerequisites

- Completed: Chapter 10 — The Two-Option Rule
- Concepts: operator-as-manager, two-option-rule

## Core concept

**Your written intent is the spec. The output is the defendant.**

When they disagree, the output is wrong. Not the spec. Not "open for interpretation." Not "reconcilable." You fix the output to match the spec. You do not "update the spec to match the output" — that's how operators lose control of their projects without noticing.

"Reconcile" is not a verb here. The word implies meeting in the middle. There is no middle. There is the spec (truth) and the output (defendant). When a reviewer surfaces "output does X at line Y but the spec covers Z," two legitimate responses:

- **The spec is right, the output is wrong** — fix the output. Default.
- **The spec is genuinely missing a requirement** — ADD the requirement to the spec, then change the output if needed. Critically: a SPEC-GAP finding can only ADD requirements; it can never remove, weaken, or delete them. The spec only grows.

There is no third option that says "weaken the spec to match the output." That destroys your ground truth.

The four-tier authority hierarchy underneath:

1. **Your authored spec, domain rules, product vision** — TRUTH.
2. **Your hand-built prototypes (mockups, wireframes)** — visual contract.
3. **The codebase as it currently runs** — behavioral truth ABOUT current state. NOT authority over what the system should do.
4. **AI-authored downstream artifacts (READMEs, plans, intermediate decisions)** — evidence only. Not in the hierarchy as authority.

When Claude cites a source, locate it. If Claude is citing tier 4 to override tier 1, the citation does not carry the weight Claude claims. The intervention: "That source is evidence, not authority. The spec says X. Implement X."

The failure mode this triggers: **artifact preservation**. The AI sees an existing README, a pattern in another file, a prior decision — and rationalizes the current code as canonical because it exists. The bias keeps state by default. The discipline: every artifact is evidence about a past decision, not authority over a current one. Start every design call from user need, not from "what's already there."

## Worked example

You wrote a short spec for MembershipKit's organization scope:

> Organizations are the tenancy boundary. Every business record (members, plans, payments, events) belongs to exactly one organization. Cross-organization access is forbidden. When a user tries to access a record from another organization, the API returns NOT_FOUND (never FORBIDDEN — FORBIDDEN reveals the record exists in another org and leaks enumeration).

You ask Claude to add the dues-plan API. Claude builds it. The review subagent flags: the source code SELECTs the plan by id only, then post-fetches and compares `row.organizationId !== ctx.orgId`, throwing FORBIDDEN on mismatch.

**The wrong move (training-data reflex):** "Two valid options exist. We could change the spec to allow FORBIDDEN here for clarity, or we could change the output. Which would you like?"

This is the output-as-witness fallacy. The output is the defendant. The spec is truth. There is no menu. The intervention from you is one sentence: "Spec says NOT_FOUND with org-scoping in SQL. Output does FORBIDDEN with post-fetch comparison. Output is wrong. Fix the output to match the spec."

Claude fixes the output — adds `AND organization_id = $orgId` to the SELECT WHERE, returns NOT_FOUND when zero rows. The spec is unchanged because the spec was already correct.

**A second worked example — the SPEC-GAP variant.** Your spec for event check-ins says check-ins are recorded with a member id and a timestamp. The review surfaces: output records check-ins WITH the timestamp but ALSO captures the kiosk device id, and there's no field for device id in the spec.

Two readings of this:

(a) The spec was complete; the device-id capture is out-of-scope output bloat that needs to be removed.

(b) The spec was incomplete; device-id capture is a real audit requirement the spec missed.

Both can be true; you decide which. **What's NOT a legitimate move: leaving the spec ambiguous and letting the output define the contract.** Pick a reading, write it into the spec explicitly with reasoning, then make the code match. If you decide (b), the spec gains a new requirement ("check-ins capture the kiosk device id for audit traceability"). The spec only gained; it never lost. That's SPEC-GAP working correctly — additive, never subtractive.

## The rule

> Spec is truth; output is defendant. "Reconcile" is not a verb. When they disagree, fix the output to match the spec. If the spec was genuinely incomplete, ADD requirements to the spec — SPEC-GAP only grows, never shrinks. Source code, READMEs, prior plans, and other AI-authored artifacts are evidence about past decisions, not authority over current ones.

## Common mistakes

**Mistake 1 — "Reconciling" the spec to match the output.** Most expensive operator mistake. Recognition phrases: "the code does X, so the spec must mean Y," "let's reconcile the spec and the code," "maybe the spec was wrong here." Repair: "Output is the defendant. The spec says X. Fix the output."

**Mistake 2 — Treating "the existing README" or "prior code" as canonical.** Recognition phrases: "Per the README at /path, X is canonical," "Prod does X today, so we keep doing X." Every artifact is evidence about a past decision, not authority over the current one. Push back.

**Mistake 3 — Letting SPEC-GAP weaken the spec.** Reviewer finds "output does X but no rule covers it." AI's reflex: classify as SPEC-GAP and propose removing the conflicting rule. SPEC-GAPs only ADD. Intervention: "If the output violates an existing rule, file a FIX."

**Mistake 4 — Spec'ing in your head only.** Without a written spec you have no ground truth — just memory. Even one paragraph beats zero. The exact strings matter: "Active organization required" is a specific contract; "an error when the org isn't set" is not.

## Drill

Artifacts go in `student/drills/11-spec-is-truth/`.

**Drill 1 — Write a small spec.** In your fork, create a file at `student/drills/11-spec-is-truth/01-feature-spec.md`. Pick a small imaginary feature (a markdown todo-list page, a hello-world API route, a contact form — anything). Write a 5-8 line spec for it. Include at least 3 specific requirements (the route, the inputs, the outputs).

**Drill 2 — Build it, find the drift.** Open Claude Code. Ask Claude to implement what's in your spec file (reference it by path). After Claude finishes, compare what Claude built against your spec line by line. Find at least one drift (something built differently from spec, or something missing, or something added). Save your drift list to `student/drills/11-spec-is-truth/02-drift-list.md`. Format: `- Spec: X. Build: Y.`

**Drill 3 — Resolve drift correctly.** For each drift in your list, write a one-line decision: either "fix the build" or "change the spec, here's why." Save to `student/drills/11-spec-is-truth/03-resolution.md`. Then actually carry out the resolution — if you're changing the build, ask Claude to fix it; if you're changing the spec, edit the spec file. Either way, the spec and the build end up in agreement.

## Checkpoint question

> A review finds: your spec says payment amounts are stored as integer cents. The source code stores some payment amounts as decimal(10,2) — dollars — in three tables that were added more recently. Claude suggests two options to you: "(A) update the spec to allow both formats; (B) update the source to use integer cents everywhere." Diagnose what's wrong with how Claude framed this. Then walk through the right move, citing why one of those options shouldn't exist at all.

<!-- Rewriter audit trail
Grounded in verified principles: P8 (the artifact is evidence; nothing is authority), P9 (the authority hierarchy: source code has zero authority; "reconcile" is not a verb; SPEC-GAP only adds requirements), P40 (authority-document editing is the cross-skill input channel — surfaces the discipline of editing spec on disk to propagate authority)
Worked example surface: MembershipKit org scoping (NOT_FOUND not FORBIDDEN), event check-in device id
Rewrite date: 2026-05-13
-->
