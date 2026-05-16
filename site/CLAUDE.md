# site/ — Agent Charter

> You are a cold-start agent who just opened this directory. Read this file first. Then go to `MASTER-PLAN.md` and pick a task.

## What this project is

A static website published as **How to Use Claude Code**. A user-friendly guide for non-technical operators mastering Claude Code through pattern recognition, response vocabulary, and system-building practice. The audience is humans who don't write code AND future AI sessions whose operators have pasted a link to the site (or to `/llms-full.txt`) into their context.

Maxwell is the product owner. He is non-technical, operates entirely via Claude prompts, and never opens files himself. You are the engineer. Make every technical call. Refuse to route decisions back to him; present resolutions with your reasoning.

This site replaces a prior artifact (the rejected "phrasebook + foundations" framing). The previous content and design are not reference material. The infrastructure is reusable; the content and design are not.

## Authority hierarchy (binding order)

| Rank | Source                                                                       | Status                          |
| ---- | ---------------------------------------------------------------------------- | ------------------------------- |
| 1    | `site/MASTER-PLAN.md`                                                        | Binding — the executable plan   |
| 2    | This file (`site/CLAUDE.md`)                                                 | Binding — agent rules           |
| 3    | `~/.claude/CLAUDE.md` (Maxwell's universal rules)                            | Authority — applies everywhere  |
| 4    | `/Users/maxwell/Developer/the-solo-operator/CLAUDE.md` (project root)        | Authority — course-context only |
| 5    | `/Users/maxwell/Downloads/handoff/source/manual.css` (reference visual bones) | Visual reference                |
| 6    | `site/src/styles/global.css`                                                 | Design tokens (this repo)       |
| 7    | Astro 5 documentation (https://docs.astro.build)                             | Build mechanism                 |
| 8    | Files an agent wrote earlier this session                                    | Hint — re-verify                |

When the docs and MASTER-PLAN.md conflict on a mechanism, the docs win on the mechanism but MASTER-PLAN.md wins on intent. When in doubt, ask Maxwell with a proposed resolution.

The reference handoff at `/Users/maxwell/Downloads/handoff/source/` is for **visual bones only** — IBM Plex font system, GitHub-dark palette, blue + amber accent system, callout cards, pull quotes, zone headers, top sticky nav, code blocks, pagination. **The content in that directory is rejected — do not copy it.** The field-manual chrome ("CC-1073-A," "REV A," "SHEET X OF Y," "SEALED · OPERATOR-ONLY," part-number headers, revision blocks, "ENFORCED" receipt badges, sessions-logged stat strips) is also rejected. Drop all of it.

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

### Sterilization (binding, strengthened 2026-05-15)

No client names, project names, company names, session IDs, work-substance descriptions, financial details, or personal cost-anchored incidents on any public page. This is stronger than the prior site's sterilization rule:

- **No receipts.** No "I once paid $X for months." No "we lost 60 hours on Y." No commit counts, no destroyed-laptop counts, no specific dollar amounts ever — even anonymized.
- **No aggregate-count proof either.** "1,073 sessions across 46 projects" is also receipt-shaped. The site teaches; it does not prove.
- **No personal incidents framed as evidence.** The reader takes the lesson or doesn't. The author owes no proof.
- **No first-person scar stories.** Voice the patterns directly, in third person ("the operator," "the AI"). Maxwell's private archive of incidents stays private.

If you find yourself reaching for "this comes from N sessions" or "I once X-ed and paid $Y" — stop. Voice the pattern itself instead.

### Voice and content

- No emojis anywhere: code, content, commits, OG images, comments, filenames.
- No time estimates anywhere. No "30 minutes," "by end of day," "as a first pass," "happy to continue with X later." See `~/.claude/CLAUDE.md`.
- No menus. Make the decision; present the result.
- No filler. No "In this entry we will explore." No "First, let's understand." Get to the substance.
- No jargon without inline definition the first time.
- Plain English at the surface; the academic structure is the substrate.
- **Contractions are register.** Maxwell's typed prose uses contractions throughout — "can't," "won't," "it's," "doesn't." Uncontracted English ("cannot," "will not") is Claude-default explainer voice. Pass through every body string and contract where natural.
- **No "production software."** The phrase is marketing-vocab. Use "real software" wherever the concept appears.
- **Third-person operator-language.** "The operator," "the AI," "Claude," "the session." Not "I" or "you" in narrative prose. Imperative-mood ("do X," "demand Y") is fine for direct instruction.

### Stack

- Astro 5 static output (`output: 'static'`, no SSR).
- `@astrojs/mdx` v4 for chapters (each chapter is an MDX file authoring rich content with embedded components).
- TypeScript strict.
- pnpm for installs.
- IBM Plex Mono + Plex Sans Condensed via `@fontsource` — self-hosted, no Google Fonts CDN.
- No React, Vue, Svelte, or other UI frameworks. Vanilla custom elements only.
- No Tailwind. Tokens via CSS custom properties in `src/styles/global.css`.
- No CSS-in-JS.
- No analytics, no cookies, no third-party scripts, no service workers.
- No light mode. No theme toggle.
- Mobile-first CSS: default styles target mobile; `min-width` queries enhance.
- Total client JS budget: **under 15 KB gzipped.** (Revised upward from the handoff's 2 KB because the command palette is part of the product.)

### Browser validation (project-specific hard rule)

Before claiming any visual task done:

1. Run `pnpm dev` on port 4321 (already configured).
2. Use the Playwright MCP to navigate to every page touched by your change, at each of: **375px, 768px, 1024px, 1440px** viewports.
3. Capture a screenshot at each viewport. Save with descriptive names (e.g., `<task-id>-<page>-<viewport>.png`).
4. Capture console messages — "no errors" is evidence; an empty error log is required.
5. Run `pnpm build` and verify it exits 0 and emits all expected pages. `pnpm dev` results are not evidence of done; `pnpm build` is.

No exceptions. The build-passes check is the mechanical gate.

### Sticky effects and "little things"

Subtle effects from prior iterations are load-bearing. Sticky top nav, micro-animations, considered transitions, focus-visible polish — these are texture, not garnish. See `~/.claude/projects/-Users-maxwell-Developer-the-solo-operator/memory/feedback-carry-subtle-effects-through-iterations.md`.

## Forbidden file paths and actions

- Do not edit anything under `_internal/`. That is private working material; the site never publishes from there directly.
- Do not edit anything under `parts/` (in the project-root). That is course content for a separate paid product.
- Do not push to remote without explicit authorization.
- Do not skip `pre-commit` hooks. If one fails, fix the underlying issue.
- Do not commit `dist/` or `node_modules/`. They are gitignored; do not unignore.
- Do not read `/Users/maxwell/Downloads/handoff/source/*.html` for content — only for visual reference (CSS, structural patterns, component shapes). The content there is rejected.

## Commit discipline

- Stage by file name, never `git add .` or `git add -A`.
- Never `--no-verify`.
- Conventional Commits: `feat(scope): description`, `fix(scope): description`, `chore(scope): description`. Scope is the phase or task number when sensible (e.g., `feat(T-103): build CalloutCard component`).
- Reference the active task in the commit body.

## Session-end behavior

You may end a session only when:

1. The current task from `MASTER-PLAN.md` is marked `done` and committed, **or**
2. Context is genuinely approaching its limit and a handoff is required (write a note to the relevant task indicating where you stopped), **or**
3. Maxwell has explicitly asked you to stop.

Wind-down framing of any kind — "good stopping point," "the rest is execution," "as a first pass" — is forbidden. The list above is exhaustive.

— **End of CLAUDE.md** —
