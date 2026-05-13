# Chapter 19 — CLAUDE.md

## Learning objective

The student can write their own `CLAUDE.md` for the MembershipKit project, place it at the right path so Claude Code reads it at session start, and verify that Claude is following the rules they wrote.

## Prerequisites

- Completed: Chapter 18 — The Anti-Pattern Vocabulary
- Concepts: spec-as-authority, five-rank-authority-hierarchy, operator-as-manager

## Core concept

`CLAUDE.md` is the file Claude Code reads at the start of every session in a project. It is the prose authority layer — the one the AI reads before it decides anything else. The file lives at three resolution paths: project root (`CLAUDE.md` in your fork), per-package or per-directory (`packages/.../CLAUDE.md`, loaded when the AI works in that subtree), and user-global (`~/.claude/CLAUDE.md`, loaded in every project). The project-root file is what you'll author first.

The prose authority layer has a known compliance ceiling. Behavioral rules in prose hold roughly seventy to eighty percent of the time. The remaining twenty-to-thirty percent is where sycophantic completion bias overrides the rule the moment its violation makes a task feel "done." This matters because it tells you what CLAUDE.md is FOR and what it is NOT for. CLAUDE.md is the place to document standing project context, name the authority hierarchy, and capture rules that don't yet warrant mechanical enforcement. CLAUDE.md is NOT the place to put rules whose violation must be impossible — those belong in hooks, which fire at the tool boundary and cannot be rationalized around.

What goes in CLAUDE.md:

**1. Identity and quality bar.** Project name, what the AI is operating on, the testable quality target. Numbers, not aspirations. "Every SELECT WHERE includes the org predicate and the soft-delete predicate. Every money column is integer cents. Every timestamp is `timestamptz`." Mechanical, citable.

**2. Standing rules from incidents.** One line each, declarative, actionable. Every line was earned from a specific moment something went wrong. Dates and incident references stay on the line — they are the audit trail for the next reader (or the next AI) asking "why is this rule here?"

**3. The authority hierarchy.** Explicit. Operator-authored specification ranks first. Source code has zero authority over what the system should do — it is behavioral truth about current state, the defendant in any disagreement with spec, never a witness. Downstream AI-authored documents (READMEs the AI drafted, plans, intermediate session-state files) are evidence about prior reasoning, not authority over current decisions.

**4. References to feedback corpus + subdocs.** CLAUDE.md is the entry point, not the manual. It links to per-package CLAUDE.md files, the anti-pattern catalog, the feedback corpus index, the constitution. Each subdoc loads on demand.

**5. Forbidden behaviors.** Specific items the AI has tried, the operator has caught, and the operator wants enforced even at the prose-rule layer. Each entry names the exact tool, path, or pattern banned.

The shape that works: short, dense, scannable, one-line rules. Operators with mature systems run CLAUDE.md files of 200-400 lines after months of incident-driven authoring. Yours starts smaller. Every line earns its keep; every recurring incident becomes a new line; the file grows linearly with operating experience.

Two things to refuse: bloat (rewrite prose paragraphs as one-liners), and AI-authored authority documents (you author CLAUDE.md; the AI may draft a starting outline, but the operator owns every line that ships).

## Worked example

You author the first draft for MembershipKit at `student/CLAUDE.md`:

```markdown
# MembershipKit — Project rules

You are working on MembershipKit, a community membership manager.

## Quality bar

Code is written to acquisition-grade standards. Concretely:
- Every SELECT WHERE includes organizationId AND a notDeleted() predicate.
- Money is stored as integer cents (bigint), never numeric or float.
- Every timestamp column is timestamptz; no bare TIMESTAMP.
- Cross-organization fetches return NOT_FOUND, never FORBIDDEN.

## Authority hierarchy (top wins)

1. My typed instructions in the current session
2. Spec / domain-rules files in docs/specs/
3. The current shipped code (behavioral truth, not authority)
4. AI-authored intermediate documents (evidence, not authority)

When spec and source disagree, source is wrong. "Reconcile" is not a verb.

## Standing rules

- Two-option rule: fix it or stop and present. Never silently continue.
- No time estimates anywhere — no "this will take N hours," no
  "Phase 2 (~10 minutes)."
- Decisions belong to you. Recommend ONE option with reasoning,
  not a menu.
- Browser-validate every UI change via Playwright MCP before claiming done.
- Verify the artifact; tool output is truth, chat narration is hint.

## Forbidden

- `git stash` (lost work incident; never use)
- `--no-verify` on commits
- `as any` type assertions
- `parseFloat` / `toFixed` on money values
- `Math.random()` for tokens, ids, or anything security-relevant
```

That file is short, dense, and every line is actionable. The "Forbidden" section names specific tool/pattern bans, not vague guidance. Each item is enforceable — by Claude reading the rule, by you intervening, and (later) by hooks that promote the highest-stakes items.

## The rule

> CLAUDE.md is the prose authority layer with a ~70-80% compliance ceiling. Use it for identity, the authority hierarchy, rules earned from incidents, and links to subdocs. Author it yourself; never delegate the authoring. Rules whose violation must be impossible go in hooks instead.

## Common mistakes

**Mistake 1 — Writing CLAUDE.md as essay.** A 5,000-word CLAUDE.md is unscannable. The rules drown in prose. The AI pattern-matches the conclusion and ignores the details. Mature CLAUDE.md files are dense: one-liners, explicit numbers, explicit paths. Prose explanations go in subdocs that CLAUDE.md links to.

**Mistake 2 — Letting the AI author CLAUDE.md for you.** CLAUDE.md is an authority document. An AI-authored authority document is a category error in the four-rank hierarchy — downstream AI artifacts are evidence about past reasoning, not authority over current decisions. You author it yourself, even if you ask the AI to draft a starting outline. Then you cut, rewrite, sign.

**Mistake 3 — Skipping the promotion ladder.** A rule that has bitten you three times across CLAUDE.md is signaling that prose enforcement isn't holding. The right response is mechanical promotion — a hook, an ast-grep rule, an addition to the anti-pattern classifier catalog. Leaving the rule in CLAUDE.md and re-stating it louder is anti-pattern #15 (still in prose after the bite recurred).

**Mistake 4 — Bloat without trim.** The file grows to 2,000 lines as you add rules. You never run a consolidation pass. The dense top of the file is buried under the accumulated middle. Run consolidation periodically (Chapter 42); trim aggressively; preserve superseded rules with the SUPERSEDED marker rather than deleting.

## Drill

Artifacts go in your fork at the project root (`student/CLAUDE.md`) — yes, this drill produces a REAL CLAUDE.md, not just a drill artifact.

**Drill 1 — Author your first CLAUDE.md.** At the root of your fork, in a folder called `student/`, create the file `student/CLAUDE.md`. Include at minimum: a one-line description of your project, 3 standing rules (pick from the Part 2 mindset principles), the four-rank authority hierarchy, and a "Forbidden" section with at least 2 entries.

**Drill 2 — Verify Claude reads it.** Open Claude Code in your fork. In the FIRST message of the session, ask: "Summarize the rules in my CLAUDE.md back to me — what am I operating under in this project?" Save Claude's response to `student/drills/19-claudemd/01-claude-summary.txt`. Confirm Claude correctly summarized YOUR rules (not generic ones).

**Drill 3 — Add a rule from a bite.** Find one of the feedback files you authored in Chapter 16. Promote ONE of its rules into your `student/CLAUDE.md` — copy the actionable rule into the "Standing rules" or "Forbidden" section. Save the updated `CLAUDE.md` and write a 2-sentence summary of which rule you promoted and why to `student/drills/19-claudemd/02-promoted-rule.txt`.

## Checkpoint question

> You add a rule to your `CLAUDE.md`: "Never use the `Math.random()` function for anything related to security or auth — use `crypto.randomUUID()` or a proper secure random source instead." A week later you find Claude wrote `const token = Math.random().toString(36)` in your auth code. Did your CLAUDE.md fail? Walk through what to check, in order, before deciding whether to re-author the rule, sharpen its phrasing, or promote to mechanical enforcement (a hook or ast-grep rule).

<!-- Rewriter audit trail
Grounded in verified principles: P21 (mechanical enforcement beats behavioral rules; ~70-80% prose compliance ceiling), P9 (authority hierarchy; source has zero authority; "reconcile" is not a verb), P8 (artifact is evidence; AI-authored docs are evidence not authority), P40 (authority-document editing as cross-skill channel), P56 (SUPERSEDED marker for superseded files)
Worked example surface: MembershipKit project-level CLAUDE.md skeleton
Rewrite date: 2026-05-13
-->
