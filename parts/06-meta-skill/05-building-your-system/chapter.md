# Chapter 43 — Building YOUR system over time

## Learning objective

The student can describe the first 30 days as a solo operator on their own project, name the rule-cadence and consolidation cadence that produce a working system, and identify the moat-building loop that compounds over months.

## Prerequisites

- Completed: Chapter 42 — The consolidation pattern
- Concepts: All Part 6 chapters; the full Part 5 hero-level destination

## Core concept

This is the final chapter. Everything in this course pointed here: you, operating your own project, building your own system, over months — not the course's MembershipKit, but whatever you actually care about.

The first 30 days of solo operation produce most of your system. Here's the cadence:

**Day 1.** Install Claude Code (you've done this). Clone or scaffold your project. Author the minimal CLAUDE.md: 3-5 standing rules, an authority hierarchy, a forbidden section with 2-3 entries. Get a working `claude` session in your project. Total: less than the work you did setting up MembershipKit.

**Days 2-7.** Operate the project. Don't try to be clever. Just work. Every time something bites you — Claude does something wrong, you have to correct, a session goes sideways — STOP and author a feedback file. 60 seconds per file. By day 7 you might have 5-10 feedback files. Don't promote yet; just collect.

**Days 8-14.** Continue operating. Notice patterns. By now SOME bites are recurring — different surfaces, same family. When you see a second instance, promote the rule into CLAUDE.md. By day 14 you might have 15 feedback files and 8-10 CLAUDE.md rules. Sessions are starting to feel more directed because CLAUDE.md gives Claude project-specific context.

**Days 15-21.** Add the first hook. By now there's at least ONE failure mode that recurs even after CLAUDE.md rule. The hook is the response. Maxwell's first hook was `git-guard` after the worktree disaster. Yours might be `block-todo-commits` or `block-decimal-money-columns`. Whatever it is, the bite tells you. Author the hook; wire it into settings.json. Verify it fires.

**Days 22-30.** Author your first skill. By now you've done some workflow 3+ times. Package it. The skill is small — 50-100 lines of SKILL.md, numbered steps. Invoke it via slash command. The first skill is the proof that you understand the SKILL.md anatomy; subsequent skills compose into your workflow library.

By day 30 you have: a real CLAUDE.md (~30 lines, 8-15 rules), 15-25 feedback files, 1-2 hooks, 1 skill, and a project that's actually moving forward. Your sessions are markedly different from day 1 — fewer corrections, fewer wind-down moments, faster orientation.

**Day 30-90 (consolidation territory).** The feedback corpus is now meaningful. Around day 60 you do your first consolidation pass. ~50 feedback files → CLAUDE.md grows from 30 lines to 50; the active corpus drops back to 15-20 files. Your hook layer grows to 3-5. Your skill library grows to 3-5.

**Day 90+.** The system is real. You're operating at Stage 2 of the trust-calibration arc most of the time, occasionally Stage 3 on simple tasks. Your moat is forming.

**Day 180+.** You're well into Stage 3. The walk-test is solid 30-45 minutes. You're authoring your own MCP servers; your `.mcp.json` has 2-3 entries.

The moat-building loop, in one sentence: **bite → feedback file → (recurs) → CLAUDE.md rule → (still bites) → hook → (still bites) → ast-grep or classifier → (rule now mechanical) → bite no longer possible.**

Each cycle costs minutes. Each cycle's benefit compounds. After 180 days, the system contains hundreds of rules in dozens of places, all wired up. The system catches what you can't.

Two final disciplines for the long arc:

**1. Don't pre-engineer.** Don't try to build the hero-level system on day 1. You don't yet know what your specific failures will be. Wait for the bites. The bites design your system better than you can.

**2. Don't skip consolidation.** A year of feedback files without consolidation is unusable. Run consolidation passes quarterly; spend the 30-90 minutes; preserve the bodies; document the drop log.

The course ends here. From this point forward you're operating your own system on your own project. The chapters were the map; the 60 days of actual operating are the territory.

## Worked example

Imagine yourself 30 days from now, on your own project (NOT MembershipKit — your real thing).

You open Claude Code. Your fork's CLAUDE.md has 12 rules. Your `.claude/hooks/` has 2 hook scripts (block-todo-commits and one project-specific one you wrote). Your `.claude/skills/` has the finish-chapter equivalent and one project-specific skill (probably `/commit-with-jira` or `/run-feature-checklist`). Your `feedback/` has 22 files; INDEX.md groups them by theme.

You start a session. First message: "Read the latest handoff doc in `state/`." Claude does. Claude orients in 1 turn. The next 3 hours are productive — you ship a feature, hit 2 anti-patterns, intervene cleanly, commit per step.

End of session. You realize Claude tried a new flavor of `as any` you hadn't seen before. You author `feedback_<incident>.md` in 60 seconds. You write a session handoff. You `/exit`.

Tomorrow you start fresh. Claude reads the handoff. Claude has 22 feedback files indexed in your CLAUDE.md. Claude has 12 rules to follow. Claude is becoming, very specifically, YOUR junior dev.

A month later, your CLAUDE.md is 50 lines. Your feedback corpus is 50 files. You do your first consolidation pass — 90 minutes, drops the active corpus to 18 files, promotes 8 new rules into CLAUDE.md. The system is sharper after.

A year later, you have an MCP federation, 30 skills, 25 hooks, and you can walk away for an hour while a feature ships. That's hero level. It got there one bite at a time.

## The rule

> Operate the project. Author from bites, not from theory. Promote rules at recurrence frequency. Consolidate quarterly. Don't pre-engineer the hero level; let it emerge. The moat is the system YOU built, brick by brick — and the bricks are your own incidents.

## Common mistakes

**Mistake 1 — Trying to copy someone else's system.** You read Maxwell's project. You try to recreate his 28 hooks and 30 skills in your project on day 1. Most of them don't apply to your domain. The ones that do you'd have authored anyway. The cost: a week pre-engineering instead of a week operating. Don't copy; operate.

**Mistake 2 — Quitting after a week.** The first week feels chaotic. You're authoring feedback files but they're not yet rules. Sessions are still requiring corrections. You think "this isn't working." But the corpus needs accumulation; the compounding hasn't kicked in. Day 30 looks very different from day 7. Stay with it.

**Mistake 3 — Skipping consolidation forever.** "I'll consolidate when I have time." You never have time. The corpus grows. Your active surface degrades. After a year you can't find anything. The fix: schedule consolidation (every quarter, calendar entry, non-negotiable). The 30-90 minutes pays for itself in operating velocity for the next 90 days.

## Drill

Final drill. Artifacts in your fork.

**Drill 1 — Plan day 1.** Write a one-page plan at `student/drills/43-building-your-system/01-day-one.md` for the FIRST DAY you'll operate on your OWN project (not MembershipKit). What's the project? What's the minimal CLAUDE.md content? What's the first concrete thing you'd build? When will you start?

**Drill 2 — Predict your first three bites.** Based on what you know about yourself and the project you described in Drill 1, predict the first three failure modes you'll encounter (Claude doing something wrong). For each, predict the bite + your likely response. Save to `student/drills/43-building-your-system/02-three-bites.txt`.

**Drill 3 — Commit to a schedule.** Pick a SPECIFIC future date when you'll do your first consolidation pass on your own project's feedback corpus. Write the date + what triggers it (calendar entry, file count threshold, etc.) to `student/drills/43-building-your-system/03-consolidation-cadence.txt`.

## Checkpoint question

> You finish this course. Tomorrow you start operating on your own project (a small e-commerce shop you're building, your portfolio site, whatever it is). Six months from now, what does success look like — not in terms of features shipped, but in terms of the system you've built around your operation? Describe it in 3-4 sentences.
