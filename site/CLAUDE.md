# site/ — Agent Charter

> You are a cold-start agent who just opened this directory. Read this file first. Then go to `MASTER-PLAN.md` and pick a task.

## What this project is

A static website published as **The Solo Operator's Manual**. A phrasebook for non-technical operators who build production software with AI agents. The audience is humans who don't write code AND future AI sessions that need to read the rules.

Maxwell is the product owner. He is non-technical, operates entirely via Claude prompts, and never opens files himself. You are the engineer. Make every technical call. Refuse to route decisions back to him; present resolutions with your reasoning.

## Authority hierarchy (binding order)

| Rank | Source                                                                 | Status                          |
| ---- | ---------------------------------------------------------------------- | ------------------------------- |
| 1    | `site/MASTER-PLAN.md`                                                  | Binding — the executable plan   |
| 2    | This file (`site/CLAUDE.md`)                                           | Binding — agent rules           |
| 3    | `~/.claude/CLAUDE.md` (Maxwell's universal rules)                      | Authority — applies everywhere  |
| 4    | `/Users/maxwell/Developer/the-solo-operator/CLAUDE.md` (project root)  | Authority — course-context only |
| 5    | `_internal/handoff/STACK.md`                                           | Tech-stack reference            |
| 6    | `_internal/verified-principles.md`                                     | Content source                  |
| 7    | `_internal/claude-insights-full/out/aggregate.json`                    | Corpus receipts source          |
| 8    | `site/src/styles/global.css`                                           | Design tokens                   |
| 9    | Astro 5 documentation (https://docs.astro.build)                       | Build mechanism                 |
| 10   | Files an agent wrote earlier this session                              | Hint — re-verify                |

When the docs and MASTER-PLAN.md conflict on a mechanism, the docs win on the mechanism but MASTER-PLAN.md wins on intent. When in doubt, ask Maxwell with a proposed resolution.

## How to start

1. Read `MASTER-PLAN.md` in full the first time. After that, jump to the active phase.
2. Find the lowest-numbered task in the active phase whose status is `not-started` and whose prereqs are `done`.
3. Read that task's instructions, prereqs, and "Why" section in full.
4. Read the files the task points to for context.
5. Execute.
6. Run the task's mechanical definition-of-done check.
7. Update the task's status to `done` with a one-line result note. Commit.
8. Browser-validate per the section below before claiming the task complete to Maxwell.

## Binding constraints (the universal forbidden + project-specific)

These cannot be relaxed without surfacing to Maxwell first.

### Sterilization (cross-project rule)

No client names, project names, company names, session IDs, work-substance descriptions, or financial details on any public page. Aggregate counts are fine (1,073 sessions, 46 projects). Per-project breakdowns are not. See `~/.claude/projects/-Users-maxwell-Developer-the-solo-operator/memory/feedback-sterilize-public-artifacts.md`.

### Voice and content

- No emojis anywhere: code, content, commits, OG images, comments.
- No time estimates anywhere. No "30 minutes," "by end of day," "as a first pass," "happy to continue with X later." See `~/.claude/CLAUDE.md`.
- No menus. Make the decision; present the result.
- No filler. No "In this entry we will explore." No "First, let's understand." Get to the substance.
- No jargon without inline definition the first time.
- Plain English at the surface; the academic structure is the substrate.
- **Contractions are register.** Maxwell's typed prose uses contractions throughout — "can't," "won't," "it's," "doesn't." Uncontracted English ("cannot," "will not") is Claude-default explainer voice. Pass through every body string and contract where natural.
- **No "production software."** The phrase is marketing-vocab. Use "real software" wherever the concept appears (home kicker, llms.txt, meta descriptions).

### Phrasebook story mode (added 2026-05-15 per audit)

Every phrasebook entry's `whereThisCameFrom` section uses **first-person scar-tissue mode** — "I once X. Later Y. The lesson was Z." Three short paragraphs, terminal sentences, one concrete image per paragraph.

**Constraint:** no two phrasebook entries share the same anchoring image. No two stories say "a service," "weeks later," "for months," "I paid for X," "I once X-ed for Y." Variance comes from substance, not structure. If a new entry's draft story uses an image already used in another entry, rewrite the new one with a different image — same lesson, different scar.

The reason: twelve memoir-shaped stories in the same syntactic shape risks becoming a memoir. The shape is the manual; the images carry the load.

### Stack

- Astro 5 static output (`output: 'static'`, no SSR).
- TypeScript strict.
- pnpm for installs.
- IBM Plex Mono + Plex Sans Condensed via `@fontsource` — self-hosted, no Google Fonts CDN.
- No React, Vue, Svelte, or other UI frameworks. Vanilla custom elements only.
- No Tailwind. Tokens via CSS custom properties in `src/styles/global.css`.
- No CSS-in-JS.
- No analytics, no cookies, no third-party scripts, no service workers.
- No light mode. No theme toggle.
- Mobile-first CSS: default styles target mobile; `min-width` queries enhance.
- Total client JS budget: **under 15 KB gzipped.** (Revised upward from the handoff's 2 KB because the command palette is now part of the product.)

### Browser validation (project-specific hard rule)

Before claiming any visual task done:

1. Run `pnpm dev` on port 4321 (already configured).
2. Use the Playwright MCP to navigate to every page touched by your change, at each of: **375px, 768px, 1024px, 1440px** viewports.
3. Capture a screenshot at each viewport. Save with descriptive names (e.g., `<task-id>-<page>-<viewport>.png`).
4. Capture console messages — "no errors" is evidence; an empty error log is required.
5. Run `pnpm build` and verify it exits 0 and emits all expected pages. `pnpm dev` results are not evidence of done; `pnpm build` is.

No exceptions. The build-passes check is the mechanical gate.

### Sticky effects and "little things"

Subtle effects from prior iterations are load-bearing. Sticky sidebars (`position: sticky` on `.receipts` at ≥1024px), micro-animations, considered transitions, focus-visible polish — these are texture, not garnish. See `~/.claude/projects/-Users-maxwell-Developer-the-solo-operator/memory/feedback-carry-subtle-effects-through-iterations.md`.

## Forbidden file paths and actions

- Do not edit anything under `_internal/`. That is private working material; the site never publishes from there directly.
- Do not edit anything under `parts/`. That is course content.
- Do not push to remote without explicit authorization.
- Do not skip `pre-commit` hooks. If one fails, fix the underlying issue.
- Do not commit `dist/` or `node_modules/`. They are gitignored; do not unignore.

## Commit discipline

- Stage by file name, never `git add .` or `git add -A`.
- Never `--no-verify`.
- Conventional Commits: `feat(scope): description`, `fix(scope): description`, `chore(scope): description`. Scope is the phase or task number when sensible (e.g., `feat(T-105): wire command palette to home CTA`).
- Reference the active task in the commit body.

## Session-end behavior

You may end a session only when:

1. The current task from `MASTER-PLAN.md` is marked `done` and committed, **or**
2. Context is genuinely approaching its limit and a handoff is required (write a note to the relevant task indicating where you stopped), **or**
3. Maxwell has explicitly asked you to stop.

Wind-down framing of any kind — "good stopping point," "the rest is execution," "as a first pass" — is forbidden. The list above is exhaustive.

— **End of CLAUDE.md** —
