# Chapter 37 — Hero level: the orchestrator + subagent gestalt

## Learning objective

The student can describe the orchestrator-and-subagent pattern at hero level — how one main session dispatches dozens of subagents to do parallel work, how subagents return structured signals the orchestrator composes, and how the pattern stays auditable without becoming chaos.

## Prerequisites

- Completed: Chapter 36 — Hero level: the anti-pattern classifier
- Concepts: task-tool-dispatches-subagents, long-context-vs-minimal-context-dispatch, structured-exit-signals

## Core concept

At hero level the operator runs a SESSION that doesn't do heavy lifting itself. It dispatches. The orchestrator session is small, light, focused. Actual work happens in subagents.

The pattern:

1. **Orient.** First action: `mcp__orient__orient()`.
2. **Plan.** Decide the next step. Often: dispatch one or more subagents.
3. **Dispatch.** Forks for context-aware work; fresh for crisply-scoped. Often parallel — 3-7 simultaneously.
4. **Subagents work.** Each runs 50-200 tool calls. Output stays out of orchestrator context.
5. **Subagents return structured signals.** `STAGE-COMPLETE: <stage>` + JSON exit object. Not prose.
6. **Compose.** Read the structured signals; decide the next dispatch (or commit / report / close).
7. **Cross-skill input via authority documents.** Operator feedback flows by editing the on-disk authority file, NOT by passing string arguments. The next skill invocation reads the file fresh.

The dispatch-prompt-length question is an unresolved tension in mature operating discipline. Two views, both evidence-backed:

**View A — long prompts for non-skilled subagents.** Dispatching a general-purpose subagent with no `/SKILL` invocation: the agent has nothing to anchor on except the dispatch. The mature pattern is labeled sections (Task, Required Reading, Background, Transformation Pattern, Forbidden List, Verification Criteria, Reporting Format), minimum ~7,000 characters for complex tasks. Short prompts produce drift; the subagent invents scope, modifies CLAUDE.md "while I'm here."

**View B — minimal triggers for skilled subagents.** Dispatching a subagent that invokes `/SKILL`: the skill body owns the discipline. The dispatch is a minimal trigger ("Invoke `/page-build` with args: 'contacts --stage map'. Out-of-scope (each forbidden): CLAUDE.md, framework pins, `_shared/`."). Long prompts loaded with forensic citations warp the subagent's pattern-matching.

The reconciliation: the views address different surfaces. Skill body carries discipline when the dispatch invokes a skill; the dispatch prompt carries it when there's no skill.

Three composition patterns: **parallel diagnostic dispatch** (high-stakes -> 2+ agents independently briefed; triangulate), **per-layer fan-out** (one subagent per layer; orchestrator composes), **pipeline dispatch** (spec -> contract -> build -> review -> fix; structured exit before next stage).

Effort scaling is part of orchestration. One agent is enough for simple fact-finding. Two to four agents fit comparisons or independent audits. Ten-plus agents only make sense for broad, high-value work with strict output contracts and review capacity. Every dispatch needs four parts: objective, output format, tool/source guidance, and task boundaries. Missing any one invites drift.

Discipline layer that keeps composition from chaos:

**Mandate the skill; ban escape-hatch language.** "If the skill refuses, operate directly," "either path is acceptable," "you can do it without re-running the full skill protocol," "fallback to direct edits" — forbidden. The `block-skill-bypass-language.sh` hook catches these. Once the AI reads "either path is acceptable," it picks the lower-friction path and bypasses every quality check.

**Destructive ops belong in the orchestrator turn.** `git checkout --`, `rm -rf`, framework downgrades — operator-in-the-loop, NOT in subagent prompts. Subagents can't execute them anyway (hooks block); worse, a destructive op named in a session-state file becomes a vector for a downstream agent to attempt it without confirmation.

**Mandatory exit sentinels.** Every staged skill emits `STAGE-COMPLETE: <stage>` as its first output line and at termination, plus a JSON exit object. Orchestrator parses mechanically; missing sentinel = process-compliance failure.

**Mandatory checkpoints before every tool call.** Subagent halts have a forensic signature where the JSONL ends with a successful tool_result and no follow-up assistant turn. Every tool call is preceded by `[CHECKPOINT N/M: about to <verb> <target>; last completed=<previous>; retries_used=K/3]`. On halt, the post-mortem reads the last checkpoint.

**Retry caps non-negotiable.** Hard cap 3 retries per stage; all categories count (no re-categorization). On 4th failure: terminate with `STAGE-GATE-FAILED`, escalate. The 4th attempt signals the diagnosis is wrong, not that the budget should grow.

## Worked example

You're shipping live notifications across MembershipKit: schema migration, backend API, real-time channel, client subscription, preferences UI, audit log integration.

- Orient. Plan. Decide: shared infrastructure (notification dispatch) + per-domain integration.
- Dispatch 1 (fresh, skilled): `/contract-feature notifications`. Returns `STAGE-COMPLETE: contract` + JSON with artifact path, layers, panel-review verdict.
- The operator notices the contract missed a sub-entity. Rather than passing feedback as a string argument, you EDIT THE INTEGRATION DOC ON DISK. The next dispatch reads the updated file with no special args.
- Dispatch 2: `/build-feature notifications --layer 0`. Returns `STAGE-COMPLETE: build-feature layer 0` + files/gate_sha/gate_result.
- Dispatches 3-7 (parallel): one per per-domain layer. Each returns its sentinel.
- Orchestrator collects 5 structured returns. Composes.
- Dispatch 8: `/review-source notifications`. Returns 4 findings as JSON.
- Dispatches 9-12 (parallel): one per finding, `/fix-source`. Each returns `fixed; gate passed`.
- Dispatch 13: `/qa-audit notifications`. Returns `zero blockers`.
- Commit; handoff; close.

Orchestrator context stays small because only structured returns come back.

## The rule

> The orchestrator dispatches; doesn't do. Subagents run in parallel where possible, return structured signals, stay OUT of orchestrator context. Skill-invoking dispatches use minimal triggers; non-skill dispatches use long structured prompts with labeled sections. Cross-skill input flows through on-disk authority documents, never as string arguments. Retry cap is 3; the 4th attempt is a diagnosis failure, not a budget extension.

## Common mistakes

**Mistake 1 — Orchestrator doing the work itself.** You dispatch one subagent, get the return, and then START EDITING FILES yourself. The orchestrator's context fills with file contents. Two more dispatches and the orchestrator is compacting. The fix: orchestrator dispatches; subagents edit; orchestrator only composes.

**Mistake 2 — Vague dispatch prompts to non-skilled subagents.** "Audit my code" lets the subagent define the audit. The fix is labeled sections, forbidden list, and structured-return format.

**Mistake 3 — Over-prompting a skilled subagent.** A long briefing can warp a skilled subagent's pattern-matching. The skill body owns the discipline; the dispatch should be a minimal trigger.

**Mistake 4 — Passing user feedback as a string argument.** "Run `/contract-feature notifications` AND make sure to include the X sub-entity." The string is opaque to the skill body and contaminates the dispatch. The mature pattern: edit the on-disk authority file to add X; dispatch with no special args. The next skill invocation reads the file fresh.

**Mistake 5 — Re-categorizing failures across retries.** "Attempt 1 was a prettier issue; attempt 2 was a typecheck issue; they don't both count toward the cap." Forbidden. Every retry counts. On 4th failure, terminate and escalate; the 4th attempt is the signal the diagnosis is wrong.

## Drill

Artifacts in your fork.

**Drill 1 — Map your current orchestrator pattern.** Write 4-6 sentences at `student/drills/37-orchestrator-gestalt/01-my-pattern.txt` describing how you currently use the AI. Are you doing work in the orchestrator session or dispatching? If dispatching, are dispatches parallel or serial? Where does context live? Where does cross-step input flow — string arguments, or on-disk authority documents?

**Drill 2 — Dispatch in parallel.** In a Claude Code session, dispatch THREE fresh subagents in a single message (three Agent tool calls in parallel). Each does a small audit task (e.g., "summarize what Chapter X teaches"). Save the three structured returns to `student/drills/37-orchestrator-gestalt/02-parallel-returns.txt`.

**Drill 3 — Write two dispatch prompt templates.** Author two reusable dispatch templates at `student/drills/37-orchestrator-gestalt/03-dispatch-template.txt`: (a) a long structured template for a non-skilled subagent with objective, output format, tool/source guidance, task boundaries, forbidden list, and verification criteria; (b) a minimal trigger template for a skilled subagent (`/SKILL` invocation + one-line forbidden list). Include the forbidden phrases the `block-skill-bypass-language` hook would catch — and confirm your templates avoid them.

## Checkpoint question

> You're orchestrating a feature build and notice your context is at 60% before implementation has even started — just a few dispatches in. Walk through 3-4 sentences naming what's likely happening, where in the dispatch pattern context is leaking, what specifically to change at the next subagent boundary (skill-invoking vs non-skill-invoking dispatch style), and what the retry cap tells you if your "fix" attempts on this leak fail twice in a row.

<!-- Rewriter audit trail
Grounded in verified principles: P29 (skill bypass language forbidden in dispatch prompts; ~80% → ~100% compliance step; hook with 19 patterns), P30 (destructive ops belong in orchestrator turn, not subagent prompts), P31 (subagent dispatch prompt length — extractor divergence WEAK; long prompt discipline for non-skilled subagents vs minimal trigger for skilled subagents; reconciliation hypothesis preserved), P36 (mandatory exit sentinels for staged workflows; STAGE-COMPLETE first line + JSON exit), P37 (mandatory checkpoint emissions before every tool call for halt observability), P38 (subagent halt signatures forensically distinct), P39 (retry caps non-negotiable; re-categorizing across retries forbidden; 3-attempt cap; SOUNDNESS-STOP on 4th), P40 (authority-document editing as cross-skill input channel, not string arguments)
Worked example surface: MembershipKit live notifications — 13 staged dispatches with sentinels + edit-authority-doc-not-args pattern + minimal-trigger style
Rewrite date: 2026-05-13
-->
