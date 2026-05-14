# Chapter 43 — Building YOUR system over time

## Learning objective

The student can describe the early arc of solo operation on their own project, name the rule-cadence and consolidation cadence that produce a working system, and identify the moat-building loop that compounds.

## Prerequisites

- Completed: Chapter 42 — The consolidation pattern
- Concepts: All Part 6 chapters; the full Part 5 hero-level destination

## Core concept

This is the final chapter. Everything in this course pointed here: you, operating your own project, building your own system — not the course's MembershipKit, but whatever you actually care about.

The early arc of solo operation produces most of your system. Here's the cadence:

**Initial setup.** Choose your lab bench. Claude Code is the course default, but the system must be portable. Author minimal `AGENTS.md` first: project identity, authority hierarchy, setup commands, done criteria, protected paths. Add `CLAUDE.md` only as the Claude-specific overlay.

**Early operating.** Operate the project. Don't try to be clever. Just work. Every time something bites you — the AI does something wrong, you have to correct, a session goes sideways — STOP and author a feedback file. The bite is the evidence; the file captures the rule. Don't promote yet; collect.

**Pattern recognition.** Continue operating. Notice patterns. When you see the second instance, promote the rule into the right layer: portable rule in `AGENTS.md`, tool-specific rule in an overlay, deterministic rule in a hook or linter.

**First mechanical layer.** Add the first hook. By now there's at least one failure mode that recurs even after CLAUDE.md rule. The hook is the response — the bite frequency justifies the maintenance cost. Author the hook; wire into `settings.json`; verify it fires. The promotion from CLAUDE.md prose to hook is the discipline ladder operationalized.

**First skill.** Author your first skill. By now you've done some workflow three or more times. Package it. The skill is small (50-100 lines of SKILL.md). Frontmatter (name + description), Forbidden Behaviors section (imperative bans), numbered protocol body. Invoke via slash command. The first skill is the proof you understand the SKILL.md anatomy; subsequent skills compose into your workflow library.

**Consolidation territory.** The feedback corpus is now meaningful. You do your first consolidation pass — feedback files shrink, `AGENTS.md` / overlays sharpen, hook layer grows, skill library grows.

**Hero level emerges.** The system is real. You're operating at Stage 2 of the trust-calibration arc most of the time. Walk-test is solid for shorter windows. Your moat is forming. You're authoring your own MCP servers; `.mcp.json` has 2-3 entries.

**Universal layer begins.** The walk-test extends. You add security boundaries, worktree policy, cost controls, workflow evals, and tool contracts. Your role is system-author, not active supervisor.

The moat-building loop, in one sentence: **bite → feedback file → (recurs) → CLAUDE.md rule → (still bites) → SKILL.md amendment or ast-grep rule → (still bites) → hook → (language-level pattern) → anti-pattern classifier catalog → bite no longer possible.**

Each cycle costs minutes. Each cycle's benefit compounds. After enough cycles, the system contains hundreds of rules in dozens of places, all wired up. The system catches what you can't.

Three disciplines for the long arc:

**1. Don't pre-engineer.** Don't try to build the hero-level system from day one. You don't yet know what your specific failures will be. Wait for the bites. The bites design your system better than you can. Copying someone else's hero-level configuration produces a structure that doesn't match your domain and rules that don't apply to your actual incidents.

**2. Don't skip consolidation.** A year of feedback files without a consolidation pass is unusable. Run passes quarterly; preserve bodies; document the drop log.

**3. Audit-first, throughput-second.** Don't measure features-per-day at face value. Amortize debt back to the prior period. The honest number drives honest investment decisions; the inflated number ships defect-density disasters.

Part 7 extends this into the public tool landscape. The chapters were the map; operating is the territory.

## Worked example

Imagine yourself well into operating on your own project (NOT MembershipKit — your real thing).

Your `AGENTS.md` has portable rules. Your `CLAUDE.md` has Claude-specific habits. Your hooks, skills, and feedback corpus are small but real.

You start a session. First message: "Read the latest handoff doc in `state/`." The AI does. Orients in one turn. The next focused window is productive — you ship a feature, hit two anti-patterns, intervene cleanly, commit per step.

End of session. You realize the AI tried a new flavor of `as any` you hadn't seen before. You author `feedback_<incident>.md`. Write a session handoff. Exit.

Tomorrow you start fresh. The AI reads the handoff. The AI has ~25 feedback files indexed in your CLAUDE.md. The AI has fifteen rules to follow. The AI is becoming, specifically, YOUR junior dev.

Later, your feedback corpus is large enough to consolidate. You promote portable rules into `AGENTS.md`, Claude-specific rules into `CLAUDE.md`, and enforcement rules into hooks.

Eventually, you have a portable operating system that works across agents. That's hero level. It got there one bite at a time.

## The rule

> Operate the project. Author from bites, not from theory. Promote rules at recurrence frequency. Consolidate quarterly. Don't pre-engineer the hero level; let it emerge. Measure throughput honestly — audit-first. The moat is the system YOU built, brick by brick — and the bricks are your own incidents.

## Common mistakes

**Mistake 1 — Trying to copy someone else's system.** You read about a mature project. You try to recreate twenty-eight hooks and thirty skills in your project from day one. Most don't apply to your domain. The ones that do you'd have authored anyway. The cost: a week pre-engineering instead of operating. Don't copy; operate.

**Mistake 2 — Quitting early.** The first week feels chaotic. You're authoring feedback files but they're not yet rules. Sessions still require corrections. You think "this isn't working." But the corpus needs accumulation; compounding hasn't kicked in yet. Stay with it.

**Mistake 3 — Skipping consolidation forever.** "I'll consolidate when I have time." You never have time. The corpus grows. The active surface degrades. Eventually you can't find anything. The fix: schedule consolidation as non-negotiable; the focused pass pays for itself in operating velocity across the arc that follows.

**Mistake 4 — Counting features-per-day at face value.** Throughput measured naively looks great. Each shipped feature carries latent defects. Cleanup later costs days that aren't charged back to the feature rate. The honest measurement amortizes cleanup back to the prior period — and produces a feature-per-day rate that reflects real velocity, not apparent velocity.

## Drill

Final drill. Artifacts in your fork.

**Drill 1 — Plan your starting point.** Write a one-page plan at `student/drills/43-building-your-system/01-day-one.md` for your first focused session on your OWN project (not MembershipKit). What's the project? What's the minimal CLAUDE.md content? What's the first concrete thing you'd build?

**Drill 2 — Predict your first three bites.** Based on what you know about yourself and the project from Drill 1, predict the first three failure modes you'll encounter (the AI doing something wrong). For each, predict the bite + your likely response layer (feedback file / CLAUDE.md / hook). Save to `student/drills/43-building-your-system/02-three-bites.txt`.

**Drill 3 — Commit to a consolidation cadence.** Pick a SPECIFIC future date when you'll do your first consolidation pass on your own project's feedback corpus. Write the date + the trigger (calendar entry, file-count threshold, etc.) to `student/drills/43-building-your-system/03-consolidation-cadence.txt`.

## Checkpoint question

> You finish this course. Tomorrow you start operating on your own project. At some point on the arc — not measured in calendar time — what does success look like, not in terms of features shipped, but in terms of the portable system you've built? Describe it in 3-4 sentences, naming specifically the artifacts that exist (`AGENTS.md`, tool overlay, hooks, skills, MCP/tool state, evals) and the trust-calibration stage you'd be at.

<!-- Rewriter audit trail
Grounded in verified principles: P10 (frameworks outlive corrections; extract the rule, not the answer — applied as the cross-bite-accumulation discipline that builds the system over time), P21 (mechanical-enforcement promotion ladder is the moat-building loop), P80 (audit-first, throughput-second; debt amortized; adjusted throughput differs from face-value throughput — the discipline applied to the operator's own self-measurement)
Worked example surface: an operator's own project arc — minimal CLAUDE.md → fifteen rules → first hook → first skill → consolidation pass → federation
Rewrite date: 2026-05-13
-->
