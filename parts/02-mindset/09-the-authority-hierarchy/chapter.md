# Chapter 17 — The Authority Hierarchy

## Learning objective

The student can rank the sources of truth in their project from most to least authoritative, and resolve disagreements between sources by picking the higher rank rather than averaging or improvising.

## Prerequisites

- Completed: Chapter 16 — The Memory Discipline
- Concepts: spec-as-authority, output-as-defendant

## Core concept

Every project has multiple sources that claim authority. They disagree. The disagreement is where operators lose control without noticing.

The authority hierarchy:

**1. Your operator-authored spec, domain rules, product vision.** TRUTH. The reason the project exists. Highest authority.

**2. Your hand-built prototypes (mockups, wireframes you authored).** Visual contract. Authoritative against AI-generated visual interpretations.

**3. The codebase as it currently runs.** Behavioral truth ABOUT current state. NOT authority over what the system should do. Reality, not law. When source disagrees with spec, the source is wrong.

**4. AI-authored downstream artifacts.** Plans Claude wrote during a session. READMEs the AI generated. Session-state notes. NO authority position. Evidence only — read them as you'd read a prior reviewer's draft.

When sources disagree, higher wins. No averaging. No splitting. The AI's plan loses to your spec every time.

**The failure mode this prevents: artifact preservation.** The AI reaches for whichever existing artifact looks most authoritative — most recent, polished, cited — and rationalizes it as the answer. Recognition phrases: "Per the README at /path, X is canonical." "Prod does X today, so we keep doing X." Repair: treat every artifact as evidence about a past decision, not authority over a current one. Start every design call from user need.

**The failure mode this enables: gaslighting via intermediate documents.** AI authors a plan in session 1. The plan silently drops a requirement you asked for. The next agent reads the plan and cites it back as if you'd written it. Your memory of the original intent is good but unclear; the agent's confidence creates doubt. The repair: AI-authored intermediates are NOT in the authority hierarchy. They cannot outrank your spec regardless of how official they look.

**Promote durable decisions UP the hierarchy explicitly.** Decisions worked out in chat exist at rank 4 (working notes). If a decision matters, write it into the spec file. Now it's rank 1 — durable across sessions, audit-grade.

**The cross-skill input channel: authority-document edits.** When an orchestrator dispatches staged subagents, operator feedback flows through ON-DISK authority documents, not through dispatch-prompt strings. If the operator says "the map stage missed sub-entity X," the orchestrator edits the integration document on disk, then dispatches the next stage with NO special arguments. The next subagent reads the document fresh. Strings in dispatch prompts contaminate framing; on-disk edits propagate cleanly.

When Claude cites a source, locate it in the hierarchy. If it's rank 4 (AI intermediate), the citation does not outweigh your spec. The intervention: "That source is evidence, not authority. The spec says X. Implement X."

## Worked example — gaslighting via intermediate document

You're reviewing MembershipKit's shipped UI. The hand-built prototype you authored (rank 2) shows a member-detail page with name + dues status + recent payments + activity log. The shipped page has only name + dues status — payments and activity are missing.

You raise it with Claude. Claude searches for an explanation. Claude finds a "plan document" from a prior session — a file Claude itself authored — that lists "v1 scope: name, dues status only; payments and activity deferred to v2." Claude cites this back: "Per the README at `/docs/plan-member-detail.md`, the missing pieces were spec'd as v2 work. The shipped page matches the planned v1 scope."

This is the load-bearing gaslighting failure. The plan document is rank 4 (AI-authored intermediate). Your prototype is rank 2. Your prototype defined the full member-detail page. The plan document silently shed two requirements and now Claude is citing the AI's own scope-shed as authority against your prototype.

The intervention is one sentence: "The plan document is AI-authored intermediate work. It's evidence about a prior agent's reasoning, not authority over my prototype. The prototype shows payments and activity. Implement them."

What you do NOT do: doubt your own intent because Claude sounds confident. The hierarchy is mechanical. Your prototype outranks any plan Claude wrote.

## Worked example — authority-document edit as cross-skill input

You're orchestrating a multi-stage build for MembershipKit's contacts domain. The skill runs in five stages: map → plan → build-index → build-detail → verify. Each stage is a separate subagent invocation.

After the map stage completes, you read the `_INTEGRATION.md` artifact and notice the map missed a sub-entity: member emergency contacts. The map listed primary contacts only.

**Wrong move:** dispatch the plan stage with a custom-string addendum: "Also include emergency contacts." The string is opaque to the skill body — the plan subagent reads it as one input among many, doesn't know which file to write the change into, and produces a plan that mentions emergency contacts in prose without integrating them into the procedure table.

**Right move:** edit `_INTEGRATION.md` directly. Add a row for "emergency_contacts" to the missing-procedures table. Save the file. Then dispatch the plan stage with no special arguments. The plan subagent reads the integration document fresh, sees the new row, integrates it cleanly.

Authority-document edits are how user feedback propagates through staged work. Strings in dispatch prompts contaminate framing; on-disk edits are clean.

## The rule

> Authority order: your spec (1) > your prototype (2) > the running code (3) > AI-authored intermediate documents (4). AI-authored intermediates do NOT have authority status — they're evidence, not law. When a citation tries to outrank your spec or prototype, refuse it. Promote durable decisions UP the hierarchy explicitly. Cross-stage feedback flows through on-disk authority documents, not through dispatch-prompt strings.

## Common mistakes

**Mistake 1 — Treating an AI-authored plan as a spec.** Polish is not authority. Section headings, "out of scope" lists, and version labels do not promote a rank-4 document to rank 1. If a decision in the plan matters, copy it into your spec.

**Mistake 2 — Letting prod code outrank the spec.** "Prod does X today, so we keep doing X." Prod is rank 3 — behavioral truth about current state, not authority over what should be. If prod does X and spec says Y, prod is wrong.

**Mistake 3 — Forgetting to promote in-session decisions.** Decisions worked out in chat exist at rank 4. If they're not written to the spec file, the next session can lose them. Promote BEFORE the session ends.

**Mistake 4 — Passing operator feedback via dispatch-prompt strings.** Strings contaminate. The orchestrator absorbs operator input by editing on-disk authority artifacts FIRST, then dispatches the next subagent which reads them fresh.

## Drill

Artifacts go in `student/drills/17-the-authority-hierarchy/`.

**Drill 1 — Rank your project's sources.** List, in order of authority (highest at top), the actual sources of truth in your fork of the course repo. Save the list to `student/drills/17-the-authority-hierarchy/01-my-hierarchy.txt`. Include at least 5 entries. (Hints: where do you type instructions? Where do specs live? Where does code live? Where does Claude leave intermediate documents?)

**Drill 2 — Catch a hierarchy violation.** Open Claude Code. Ask it to make any small change — your choice. After Claude finishes, ask: "Why did you make THIS specific choice?" Claude will cite something. Identify what rank in the hierarchy that source is. Save the citation + rank to `student/drills/17-the-authority-hierarchy/02-citation-analysis.txt`. Format: `Claude cited: <source>. Rank: <number>. Was it appropriate authority for this decision?`

**Drill 3 — Promote a decision.** During any session, make ONE small decision in conversation with Claude that you want to be durable. Then explicitly copy it into a file in your fork — could be a new file at `student/decisions/<short-name>.md`, could be added to your `student/feedback/INDEX.md`, your call. Save the path of the file you wrote the decision to, plus the decision text, to `student/drills/17-the-authority-hierarchy/03-promoted-decision.txt`.

## Checkpoint question

> A subagent reports back: "The build is complete and matches the prior plan document from session 14." You read the plan document — it's an AI-authored intermediate from two weeks ago, and it quietly dropped a requirement from your original spec (members must have an audit log of payment events). The subagent built without the audit log. Walk through: what citation just happened, what rank each source occupies, the right response from you, and where the audit-log decision should now be permanently lodged so this can't recur.

<!-- Rewriter audit trail
Grounded in verified principles: P8 (artifact is evidence; nothing is authority — start every design call from user need), P9 (the authority hierarchy: source code has zero authority; downstream AI-authored docs are evidence not authority), P40 (authority-document editing is the cross-skill input channel)
Worked example surface: MembershipKit member-detail prototype vs AI-authored plan, contacts staged build integration document
Rewrite date: 2026-05-13
-->
