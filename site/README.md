# The Solo Operator's Manual

A static phrasebook for non-technical operators who build production software with AI agents. Dark engineering-doc visual, mobile-first, AI-crawler-friendly, zero analytics.

## Develop locally

```sh
pnpm install
pnpm dev          # http://localhost:4321
```

## Scripts

| Script | What it does |
|---|---|
| `pnpm dev` | Dev server on port 4321 |
| `pnpm build` | Type-check then static build to `dist/` |
| `pnpm check` | TypeScript + Astro diagnostics |
| `pnpm lint` | ESLint |
| `pnpm format` | Prettier write |
| `pnpm format:check` | Prettier check (CI-friendly) |
| `pnpm test` | Playwright smoke at four viewports |
| `pnpm a11y` | pa11y WCAG 2.1 AA gate (requires dev server running) |

## Stack (pinned)

- Astro 5 static output
- TypeScript strict
- IBM Plex Mono + Plex Sans Condensed self-hosted via `@fontsource`
- Vanilla custom elements; no React/Vue/Svelte
- CSS custom properties; no Tailwind
- Cloudflare Pages deploy target

Full stack constraints: see `_internal/handoff/STACK.md`.

## Authoring a new phrasebook entry

1. Copy `src/content/phrasebook/_TEMPLATE.md.txt` to `src/content/phrasebook/<slug>.md`.
2. Fill in every field. The Zod schema in `src/content/config.ts` enforces shape and rejects raw HTML, prompt-injection patterns, and length overruns.
3. Update the `coveredBy` field on the matching placeholder row in `src/pages/phrasebook.astro` so the stub disappears from the index.
4. `pnpm build` to verify.

## Where to look

- **Agent rules:** `CLAUDE.md` — binding constraints, authority hierarchy, end-of-session behavior. Every cold-start agent reads this first.
- **Execution plan:** `MASTER-PLAN.md` — phase-organized task catalog with T-NNN identifiers. Pick the lowest-numbered `not-started` task in the active phase.
- **Reviews:** `_internal/reviews/2026-05-15-*-review.md` — three independent audits (security, architecture, content/voice). Findings drive Phase 0.5.
- **Visual reference:** `_internal/proposal-mockup-v2.html` — the validated visual proposal.
- **Content source:** `_internal/verified-principles.md` and `_internal/claude-insights-full/` — the canon and corpus the manual draws from.

## Style and discipline

- No emojis, no time estimates, no menus, no production-software vocab (use "real software"). See `CLAUDE.md`.
- Contractions: write the way you'd say it — "can't," "won't," "you'll" — not "cannot," "will not," "you will."
- Sterilization is mandatory on every public surface — no client names, project names, session IDs, work-substance details, dollar amounts.
- Mobile-first CSS. Default styles target 375px; `@media (min-width: ...)` enhances up.
- Every visual change is browser-validated at 375 / 768 / 1024 / 1440 before being claimed done.

## Deploy

Cloudflare Pages, static output. See `MASTER-PLAN.md` Phase 8.

— *Last revision: 2026-05-15*
