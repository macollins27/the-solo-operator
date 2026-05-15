# MASTER-PLAN.md — The Solo Operator's Manual

> **Read this in full the first time. After that, jump to the active phase.**
>
> This file is the binding execution plan for the website at `site/`. A cold-start agent who reads `site/CLAUDE.md` and this file has everything needed to pick a task and execute it without prior session context.

## 0. About this document

- **Purpose:** Single source of truth for what to build, in what order, by what mechanism.
- **Authority:** Binding. New work happens by adding a task here, not by side-channel improvisation.
- **Granularity:** Each task (T-NNN) is a single agent dispatch — one focused unit with self-contained context.
- **Status tracking:** Every task has a `Status:` line. Update it as work progresses. Permitted values: `not-started`, `in-progress`, `done`.
- **No time estimates anywhere.** Phases are shippable units, not calendar windows.

## 1. The artifact we are building

A static website at a custom domain (TBD), branded as **The Solo Operator's Manual**. A phrasebook for non-technical operators who build production software with AI agents.

**Audience (two-tier):**
1. Humans — non-technical operators landing cold. They have an agent misbehaving right now. They want the words to say back.
2. AI sessions — future Claude (or other agent) sessions whose operators have pasted a link to a specific principle page into their CLAUDE.md. The site is a citable rules surface.

**Animating thesis:**
> The operator sets the bar and refuses the menu. The AI makes every technical call in between. Because the operator cannot verify the technical layer, the apparatus verifies it mechanically — prose rules cap at ~70–80% compliance; only the tool boundary cannot be rationalized around.

**Three reading modes (the IA):**
- **The Phrasebook** (primary) — symptom-indexed lookup. Pick what your agent is doing, get the words to say back.
- **Start Here** — five foundational moves for new operators.
- **About** — sterilized origin story + corpus receipts.

## 2. Current state (what is built)

As of revision 2026-05-15:

- Astro 5.18 scaffold at `site/`, pnpm 10, Node 22 LTS, TypeScript strict.
- Design system: tokens in CSS custom properties, IBM Plex Mono + Plex Sans Condensed self-hosted via `@fontsource`, GitHub-dark palette, drafting-grid identity. Mobile-first responsive at breakpoints 640 / 1024.
- One layout (`src/layouts/Base.astro`) with full SEO meta block (title, description, canonical, OG, Twitter, JSON-LD), top nav, footer, skip-link.
- One custom element (`src/components/CopyButton.ts`) — vanilla, ~1 KB.
- Content collection at `src/content/phrasebook/` with Zod schema in `src/content/config.ts`.
- **1 of 13** phrasebook entries authored: `src/content/phrasebook/paid-service-claim.md`.
- Five pages live: `/`, `/phrasebook`, `/phrasebook/[slug]`, `/start-here`, `/about`. Plus `/404`, `/llms.txt`, `/sitemap-index.xml`.
- Browser-validated at 375 / 1440. Zero console errors.
- `pnpm build` passes; emits 6 HTML pages + llms.txt + sitemap. Client JS at ~1 KB gzipped.

**Site files of record:**

```
site/
├── CLAUDE.md                          (agent charter — bind first)
├── MASTER-PLAN.md                     (this file)
├── README.md                          (TBD — see T-004)
├── package.json
├── astro.config.mjs
├── tsconfig.json
├── public/
│   ├── robots.txt
│   └── favicon.svg
└── src/
    ├── layouts/
    │   └── Base.astro                 (SEO, nav, footer, fonts)
    ├── components/
    │   └── CopyButton.ts              (custom element)
    ├── content/
    │   ├── config.ts                  (Zod schemas)
    │   └── phrasebook/
    │       └── paid-service-claim.md  (1 of 13)
    ├── styles/
    │   └── global.css                 (tokens + base + components + responsive)
    └── pages/
        ├── index.astro
        ├── phrasebook.astro
        ├── phrasebook/[slug].astro
        ├── start-here.astro
        ├── about.astro
        ├── 404.astro
        └── llms.txt.ts
```

## 3. Binding constraints (cross-cuts every task)

Full list in `site/CLAUDE.md`. Quick reference for task execution:

1. **Sterilization.** No client names, project names, session IDs, work-substance descriptions on any public page. Every task that authors content runs the sterilization checklist (§ 4) before marking done.
2. **No emojis anywhere.** Including comments, commit messages, OG images.
3. **No time estimates.** Anywhere.
4. **No menus to Maxwell.** Make the call. Present the result.
5. **Mobile-first CSS.** Default styles target mobile; `min-width` queries enhance.
6. **No third-party scripts, analytics, cookies, service workers.** Static-only.
7. **Total client JS budget under 15 KB gzipped.** (Revised from handoff's 2 KB because the command palette is part of the product.)
8. **Browser-validate at 375 / 768 / 1024 / 1440 before claiming visual tasks done.** Zero console errors.
9. **`pnpm build` is the mechanical gate.** `pnpm dev` results are not evidence of done.
10. **Carry subtle effects through iterations.** Sticky sidebars, micro-animations, focus polish — these are load-bearing.

## 4. The sterilization checklist (run for every public-facing edit)

Before marking any content task `done`:

1. Search the diff for: client names, company names, project names, project acronyms (e.g., `PLW`), software brand names tied to specific work (e.g., `Stripe webhook`), session IDs (8-character hex strings, UUIDs), specific dollar amounts, specific people's names.
2. If any are found: redact them. Patterns:
   - Client/company name → "a small company" / "a client"
   - Project name → "a software ecosystem" / "a long-running project"
   - Specific software identifying the work → generic category ("a payment-integration bugfix") or drop the example entirely
   - Session ID → remove
   - Dollar amount → generalize ("for months") or drop
3. Aggregate counts are safe: `1,073 sessions`, `46 projects`, `145 behaviors`, `80 principles`. Per-project breakdowns are not.
4. Spot-check by reading the page in a browser and asking: "If a stranger reads this, what could they infer about Maxwell's clients?" If anything specific can be inferred, sterilize further.

## 5. Reference materials by topic

When a task says "read X for context," consult this map for which files apply.

### Content authoring (phrasebook entries, foundation moves)
- `_internal/verified-principles.md` — the canon. Each entry maps to one or more principles. Cite the principle (by theme letter + name, not by raw page reference) in the "Why this works" section.
- `_internal/foundational-principles.md` — the un-audited merged canon. Use only the principles that are also in verified-principles.md.
- `_internal/phase1/behaviors-v2.md` — 145 voice-filtered operator behaviors. Maps to recognition phrases.
- `_internal/phase1/index.md` — anti-pattern catalog with recognition phrases. Especially Section 3 (named failure patterns).
- `_internal/claude-insights-full/out/aggregate.json` — corpus counts. Use for receipt panels. Re-extract counts from this file; don't carry over numbers from prior versions of the site without verifying.
- `_internal/CLAUDE REPORTS/2026-05-14-full-corpus-1073sessions.html` — rendered corpus report with category counts.

### Voice
- `_internal/max.md` — Maxwell's first-person typed material. Read for cadence; never quote without sterilization.
- `_internal/phase1/voice-filter.md` — explains how to distinguish Maxwell's actual voice from Claude-played-persona output in source files.

### Design tokens and visual system
- `site/src/styles/global.css` — the binding token system + responsive breakpoints.
- `_internal/handoff/source/manual.css` — original handoff stylesheet (reference, not source of truth anymore).
- `_internal/handoff/DESIGN-SYSTEM.md` — design system specification.
- `_internal/proposal-mockup-v2.html` — the visual reference Maxwell validated on 2026-05-15. When in doubt about a layout decision, refer to this.

### SEO and structured data
- https://schema.org/TechArticle, schema.org/HowTo, schema.org/BreadcrumbList
- https://llmstxt.org — spec for `llms.txt` and `llms-full.txt`
- `_internal/handoff/SEO.md` — original SEO plan (reference).
- `_internal/handoff/AI-OPTIMIZATION.md` — original AI-crawler plan (reference).

### Astro
- https://docs.astro.build/en/getting-started/
- https://docs.astro.build/en/guides/content-collections/
- https://docs.astro.build/en/guides/view-transitions/
- https://docs.astro.build/en/recipes/

### Security
- https://content-security-policy.com — CSP reference
- https://infosec.mozilla.org/guidelines/web_security — Mozilla web security checklist
- https://web.dev/articles/security-headers — Google security headers overview

## 6. Architecture decisions (with rationale)

| Decision                                                    | Why                                                                                                  |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| Astro 5 static                                              | Zero JS by default. Per-component scoping. Content collections typed. AI-crawler friendly.           |
| Single content collection (`phrasebook`)                    | One Zod schema, one render path. Foundation moves are pages, not a collection (only five of them).   |
| Frontmatter-only entries (no MDX body)                      | Structured rendering. Designer has total control over layout. Markdown is brittle for complex pages. |
| Custom elements over framework                              | <15 KB JS budget. One built-in interactive surface (copy button + command palette).                  |
| CSS custom properties for tokens                            | No utility framework. One source of truth in `global.css`. Easy to retheme.                          |
| Mobile-first responsive                                     | Maxwell's directive 2026-05-15. Default is small; `min-width` adds up.                               |
| Sticky receipts at ≥1024px only                             | On mobile the panel stacks below content; sticky is meaningless.                                     |
| Cloudflare Pages deploy                                     | Free tier handles it. Free HTTPS. AI-crawler accessible. No vendor lock.                             |
| 15 KB total client JS budget                                | Command palette + copy button. Still ~10x smaller than a typical SPA.                                |
| Per-page Schema.org JSON-LD                                 | Boosts AI ingestion and traditional SEO.                                                             |
| llms.txt + llms-full.txt                                    | Audience explicitly includes future AI sessions; native AI-discovery channel.                        |

## 7. The Vercel-style command palette spec (Phase 2 reference)

The single largest new feature beyond content. Specified once here so each Phase 2 task can refer back without re-deriving.

### Trigger surfaces
- Keyboard: `Cmd+K` (Mac) / `Ctrl+K` (Win/Linux) anywhere on the site.
- Keyboard: `/` key when not focused on an input.
- Mouse: click the "Browse the phrasebook" prompt on the home page. (Currently a link; will be re-wired to open the palette.)

### Overlay structure (visual)
- Backdrop: `rgba(0,0,0,0.7)` with `backdrop-filter: blur(8px)`.
- Modal: centered, max-width 640px, full-width-with-padding on mobile (full-screen takeover below 640px viewport).
- Modal background: `var(--panel-2)`, border `1px solid var(--line-bright)`.
- Modal padding: 0 (search input at top, list below, both flush to edge).

### Search input
- Top of modal, sticky within.
- Placeholder: `Search the manual...`
- Auto-focus on open.
- Leader glyph: `>` in blue, monospaced. (Same as current home-page input.)
- ESC closes; arrow keys navigate the list (do not move cursor).

### Result list
- Grouped by section, in order: **Phrasebook**, **Foundations**, **Pages**.
- Section header: small kicker in muted color (`Phrasebook`, `Foundations`, `Pages`).
- Each row:
  - Left: kicker badge (category number for phrasebook, "MOVE/0N" for foundations, "PAGE" for pages).
  - Center: primary label (the agent quote for phrasebook entries; the move name for foundations; the page title for pages).
  - Right: keyboard hint when active (`↵ Open`).
- Active row: blue left border (3px), background `var(--panel-3)`, accent-color on the kicker.
- Mouse hover and keyboard navigation share the same active state.
- No results: a single row reading "No matches. Browse the phrasebook →" linking to `/phrasebook`.

### Behavior
- Real-time filter as user types. Matching: case-insensitive `includes()` against the label, the category, and the description. (Hand-rolled; no library.)
- Enter on active row navigates to the row's URL and closes the overlay.
- ESC closes without navigation.
- Click outside modal closes.
- On mobile (<640): modal takes full screen, search input stays sticky at top, cancel button (text) at top-right of modal.

### Search index (build-time)
- JSON manifest emitted at `/search.json` by a build-time endpoint at `src/pages/search.json.ts`.
- Manifest shape:
  ```json
  [
    {
      "section": "phrasebook",
      "label": "you'll need a paid service to do that",
      "url": "/phrasebook/paid-service-claim",
      "category": "It's giving up before trying",
      "description": "..."
    },
    { "section": "foundations", "label": "Refuse the menu.", "url": "/start-here#refuse-the-menu", ... },
    { "section": "pages", "label": "Where this came from", "url": "/about", ... }
  ]
  ```
- Fetched once on first palette-open via `fetch('/search.json')`. Cached for the session.

### Implementation
- Custom element `<command-palette>` defined in `src/components/CommandPalette.ts`.
- Mounted globally via `src/layouts/Base.astro` (single instance at end of body).
- Vanilla JS; no framework imports.
- Target gzipped size: < 8 KB.
- Animations: 120ms fade-in for backdrop, 160ms scale-up + fade for modal. `prefers-reduced-motion` disables.

## 8. Phase plan

Each phase is a shippable unit. Tasks within a phase can run in any order subject to prereqs. Phases run roughly in numeric order, but Phases 4-7 can interleave once Phase 1-2 are landed.

| Phase | Title                                | Result on completion                                                                                                |
| ----- | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| 0     | Foundation hardening                 | View transitions wired; pa11y/Playwright CI; a working README.                                                       |
| 0.5   | Pre-content fixes (audit-driven)     | The 27-task amendment from three reviews lands: typecheck passes, schema tightened, home page restructured, accessibility fails fixed, About voice rewritten, infrastructure (Prettier/ESLint/CI) wired. Blocks T-101. |
| 1     | Content to full coverage             | All 13 phrasebook entries + 5 foundation-move detail pages live.                                                     |
| 2     | Vercel-style command palette         | Cmd+K overlay live; home CTA re-wired; mobile takeover working.                                                      |
| 3     | Open Graph image generation          | Every page has a unique OG image, build-time generated.                                                              |
| 4     | Polish layer                         | Micro-animations, view transitions, copy-button states, reading progress on entries.                                 |
| 5     | Security hardening                   | CSP + HSTS + X-Content-Type-Options + Referrer-Policy + Permissions-Policy; AI bot policy in robots.txt.             |
| 6     | Performance gates                    | Lighthouse 100/100/100/100 on all pages; preloaded critical fonts; cache headers.                                    |
| 7     | AI-SEO + crawler optimization        | llms-full.txt; expanded Schema.org (BreadcrumbList, HowTo); internal linking density; AI bot allowlist live.         |
| 8     | Production deployment                | Live at custom domain on Cloudflare Pages, with smoke test and basic uptime monitoring.                              |

## 9. Task catalog

### Phase 0 — Foundation hardening

#### T-001 — Add Astro view transitions integration
- **Phase:** 0
- **Status:** not-started
- **Prereqs:** none
- **Read first:**
  - https://docs.astro.build/en/guides/view-transitions/
  - `site/src/layouts/Base.astro`
- **Files to edit:**
  - `site/src/layouts/Base.astro` (add `<ClientRouter />` from `astro:transitions`)
- **Instructions:**
  1. Import `ClientRouter` from `astro:transitions` in `Base.astro`.
  2. Render `<ClientRouter />` inside `<head>`.
  3. Add `transition:name` directives on the title block, the hero h1, and the receipts sidebar so they animate across navigations.
  4. Verify on `/phrasebook` → `/phrasebook/paid-service-claim` → back. The title block should crossfade.
  5. Respect `prefers-reduced-motion`.
- **Why:** Cross-page navigation should feel cohesive, not page-flash. View transitions are an Astro built-in; no extra JS budget cost.
- **Definition of done:** `pnpm build` exits 0. Visual check shows a smooth crossfade between phrasebook index and entry pages. `prefers-reduced-motion` disables them.

#### T-002 — Add Playwright smoke-test suite
- **Phase:** 0
- **Status:** not-started
- **Prereqs:** none
- **Read first:**
  - https://playwright.dev/docs/test-fixtures
  - `site/src/pages/` (the route list)
- **Files to create:**
  - `site/playwright.config.ts`
  - `site/tests/smoke.spec.ts`
- **Instructions:**
  1. Add `@playwright/test` to `devDependencies` via pnpm.
  2. Create `playwright.config.ts` configured for the four viewports (375 / 768 / 1024 / 1440), retries 0, base URL `http://localhost:4321`.
  3. In `smoke.spec.ts`: for each page (`/`, `/phrasebook`, `/phrasebook/paid-service-claim`, `/start-here`, `/about`, `/404`), assert: HTTP 200, `<title>` present, one `<h1>` present, zero console errors, no horizontal scrollbar.
  4. Add an `npm script`: `"test": "playwright test"`.
- **Why:** Mechanical regression gate. Every future task can run `pnpm test` to confirm no page is broken.
- **Definition of done:** `pnpm test` passes for all viewports and all pages.

#### T-003 — Add accessibility CI gate (pa11y or axe)
- **Phase:** 0
- **Status:** not-started
- **Prereqs:** T-002
- **Read first:** https://github.com/pa11y/pa11y-ci
- **Files to create:**
  - `site/.pa11yci.json`
- **Instructions:**
  1. Add `pa11y-ci` to devDependencies.
  2. Configure with standard WCAG 2.1 AA, all five page URLs at `http://localhost:4321`.
  3. Add npm script `"a11y": "pa11y-ci"`.
- **Why:** Accessibility is non-negotiable for a site whose audience explicitly includes screen-reader users and keyboard-only navigation.
- **Definition of done:** `pnpm a11y` exits 0 against the running dev server.

#### T-004 — Write `site/README.md`
- **Phase:** 0
- **Status:** not-started
- **Prereqs:** none
- **Read first:** `site/CLAUDE.md`, `site/MASTER-PLAN.md`
- **Files to create:** `site/README.md`
- **Instructions:**
  1. Human-readable orientation: what this is, how to develop locally (`pnpm install && pnpm dev`), how to deploy, where the master plan lives.
  2. No more than 80 lines. Maxwell will skim this once.
  3. Link to `CLAUDE.md` for agent rules and `MASTER-PLAN.md` for task list.
- **Why:** README is the first file a human collaborator opens. Should orient in 30 seconds.
- **Definition of done:** File exists, under 80 lines, accurate as of the current state.

### Phase 0.5 — Pre-content fixes (audit-driven)

Added 2026-05-15 in response to three independent reviewer findings. Phase 0.5 must complete before any Phase 1 content authoring begins. The findings are durable artifacts at:

- `_internal/reviews/2026-05-15-security-review.md`
- `_internal/reviews/2026-05-15-architecture-review.md`
- `_internal/reviews/2026-05-15-content-voice-review.md`

This phase has three tiers: Critical (T-005 through T-010), High (T-011 through T-020), Medium (T-021 through T-031). Tiers run in order; tasks within a tier can run in any order subject to prereqs. Phase 0.5 closes with a validation pass (the existing browser-validate task) that must succeed before T-101 unblocks.

#### Critical tier (blocks T-101)

##### T-005 — Fix pnpm check implicit-any errors
- **Status:** not-started
- **Prereqs:** none
- **Read first:** `site/src/pages/phrasebook.astro`, `site/src/pages/phrasebook/[slug].astro`, https://docs.astro.build/en/guides/content-collections/#querying-collections
- **Files to edit:** the two files above
- **Instructions:**
  1. In `phrasebook.astro`, import `CollectionEntry` from `astro:content` and annotate the `getCollection` result type and each `.filter`/`.map` callback parameter as `CollectionEntry<'phrasebook'>`.
  2. In `[slug].astro`, declare a local `Props` type with `entry: CollectionEntry<'phrasebook'>`, annotate `getStaticPaths` callbacks the same way, and cast `Astro.props` to `Props`.
  3. Run `pnpm check` — must exit 0.
- **Why:** Architecture review CRITICAL-1. The build doesn't catch implicit-any but `astro check` does. A cold-start agent who runs `pnpm check` before T-101 will be misled into thinking their work caused the failure.
- **Definition of done:** `pnpm check` exits 0 with 0 errors and 0 warnings.

##### T-006 — Add astro check to prebuild gate
- **Status:** not-started
- **Prereqs:** T-005
- **Files to edit:** `site/package.json`
- **Instructions:** Change the `build` script from `astro build` to `astro check && astro build`. Verify `pnpm build` fails if a type error is reintroduced (test by adding `const x: number = 'string'` temporarily, confirming build fails, then reverting).
- **Why:** Mechanical gate so future regressions can't land silently.
- **Definition of done:** `pnpm build` first runs `astro check`. Reintroducing a type error causes build to exit 1.

##### T-007 — Apply JSON-LD escape function
- **Status:** not-started
- **Prereqs:** none
- **Files to edit:** `site/src/layouts/Base.astro`
- **Instructions:** Add a helper function `safeJsonLd(obj)` that returns `JSON.stringify(obj).replace(/<\//g, '<\\/')`. Replace the `<script type="application/ld+json" set:html={JSON.stringify(schema)} />` with `set:html={safeJsonLd(schema)}`. Also add `is:inline` attribute on that script to silence the Astro hint.
- **Why:** Security review F-01 HIGH. `JSON.stringify` does not escape `</script>` sequences. Latent XSS in the build pipeline because AI agents author content.
- **Definition of done:** Helper present, used in Base.astro, no behavior change observable in browser. `pnpm check` exits 0 (hint cleared).

##### T-008 — Tighten content collection schema
- **Status:** not-started
- **Prereqs:** none
- **Files to edit:** `site/src/content/config.ts`, `site/src/content/phrasebook/paid-service-claim.md`, `site/src/pages/phrasebook/[slug].astro`
- **Instructions:**
  1. Drop `categoryLabel` and `categoryNumber` from the schema and frontmatter. Add a `CATEGORY_MAP` const in `[slug].astro` (and import into `phrasebook.astro`) that maps `category` → `{ number, label }`. Look up in the template.
  2. Add `.max()` caps: `quote.max(120)`, `subtitle.max(160)`, `pasteText.max(800)`. (Per content review: pasteText should be tight; 800 is a soft cap that allows the current 234-char example with headroom.)
  3. Constrain `relatedMove.slug` to `z.enum(['ai-is-the-engineer','refuse-the-menu','verify-the-artifact','push-back-on-i-cant','make-recurring-mistakes-mechanical'])`.
  4. Add `.refine()` on each entry of `whyThisWorks` and `whereThisCameFrom`: reject strings containing the regex `<[a-zA-Z]` (matches raw HTML tag openers; the `*italic*` shorthand uses no `<`).
  5. Update `paid-service-claim.md` frontmatter to remove `categoryLabel` and `categoryNumber`.
- **Why:** Architecture review §2.7 + security review F-03. Three fields that must stay in sync; schema permits drift. Length caps prevent layout overflow. Enum on slug prevents typos that fail silently. Refine on body fields closes the `set:html` injection path at schema level.
- **Definition of done:** `pnpm check` and `pnpm build` both exit 0. The published entry renders identically. Attempting to add `category: 'giving-up'` with no `categoryLabel` in frontmatter succeeds (because the field no longer exists).

##### T-009 — Convert hardcoded afterPaste paragraph to frontmatter
- **Status:** not-started
- **Prereqs:** T-008
- **Files to edit:** `site/src/content/config.ts`, `site/src/content/phrasebook/paid-service-claim.md`, `site/src/pages/phrasebook/[slug].astro`
- **Instructions:**
  1. Add an optional `afterPaste: z.string().max(400).optional()` field to the schema.
  2. In `paid-service-claim.md`, set `afterPaste: |\n  If the agent comes back with an actual command and an actual error, you have ground truth.\n  If it comes back with another paragraph about pricing tiers, push again.\n`.
  3. In `[slug].astro:64`, replace the hardcoded `<p class="body-copy">...</p>` after the paste block with a conditional `{d.afterPaste && <p class="body-copy">{d.afterPaste}</p>}`.
- **Why:** Content/voice review CRITICAL §10 Rewrite 5. The hardcoded sentence mentions "pricing tiers" — specific to the paid-service entry. Without this fix, every one of the next 12 entries will display the same irrelevant followup.
- **Definition of done:** The published entry still shows the followup paragraph. A new entry without `afterPaste` does not show any followup paragraph. `pnpm build` exits 0.

##### T-010 — Already amended in T-501 and T-502 above
- **Status:** done
- **Result:** T-501 CSP `script-src` now includes `'unsafe-inline'` + adds `object-src 'none'`. T-502 user-agent list replaces `Claude-Web` with `ClaudeBot`. Amendments are inline in Phase 5 task definitions.

#### High tier (should land before T-101)

##### T-011 — Lift Start Here cards into clickable anchors
- **Status:** not-started
- **Files to edit:** `site/src/pages/start-here.astro`, `site/src/styles/global.css`
- **Instructions:** Wrap each `.move` card in an `<a href="#${move.slug}">` element (interim, until T-150 creates `/start-here/<slug>` routes). Update `.move` CSS so the anchor behaves as the card (text-decoration: none, color: inherit, display: flex, flex-direction: column).
- **Why:** Architecture review HIGH-3 + content/voice §5. The cards show "Read →" but aren't clickable.
- **Definition of done:** Clicking anywhere on a `.move` card scrolls to its `#slug` anchor. Keyboard nav reaches each card.

##### T-012 — Fix home heading hierarchy (h1 → h2 → h3)
- **Status:** not-started
- **Files to edit:** `site/src/pages/index.astro`, `site/src/styles/global.css` (selector update)
- **Instructions:** The three mode tiles use `<h3>` with no intermediate `<h2>`. Wrap the modes section in `<section aria-labelledby="modes-heading">`, prepend a visually-hidden `<h2 id="modes-heading" class="sr-only">Three ways to read this manual</h2>` (add `.sr-only` utility in global.css), keep tiles as `<h3>`. Result: screen-reader hierarchy `h1 → h2 → h3`.
- **Why:** Architecture review HIGH-4. Trips screen-reader heading nav and pa11y CI (T-003).
- **Definition of done:** Heading order on `/` is h1, h2, h3, h3, h3. pa11y test passes.

##### T-013 — Ship placeholder og-default.png
- **Status:** not-started
- **Files to create:** `site/public/og-default.png`
- **Instructions:** Render a 1200×630 PNG with the brand title "The Solo Operator's Manual" centered in Plex Sans Condensed-style typography on the `#0a0d10` background, with a subtle drafting-grid underlay. Use any one-shot SVG-to-PNG path: a hand-authored SVG converted via `resvg-js`, an inline canvas-rendered PNG, or a build-time Satori call. Keep file size under 100 KB.
- **Why:** Architecture review HIGH-2 + security F-06. `og:image` defaults to a 404 file today. Every link preview is a broken image.
- **Definition of done:** `curl -I http://localhost:4321/og-default.png` returns 200. File is a valid PNG, 1200×630.

##### T-014 — Remove dead RSS link from Base.astro
- **Status:** not-started
- **Files to edit:** `site/src/layouts/Base.astro`
- **Instructions:** Delete the `<link rel="alternate" type="application/rss+xml" title=... href="/rss.xml" />` at Base.astro:91. RSS is deferred until Phase 7 backlog (see T-705 below).
- **Why:** Architecture HIGH-2 + security F-05. The endpoint doesn't exist; the link is a broken contract.
- **Definition of done:** No `<link rel="alternate" type="application/rss+xml">` in any built page. Feed reader 404s on this site simply because the link is gone, not advertised-then-broken.

##### T-015 — Redesign home page structure
- **Status:** not-started
- **Files to edit:** `site/src/pages/index.astro`
- **Instructions:**
  1. Delete the entire `.search-wrap` `<section>` (the prompt + helper + "Browse the phrasebook" link block).
  2. Insert a thesis paragraph between the `.subtle` subtitle and the `.modes` grid: *"If you don't write code but you ship software with AI agents, the work eventually comes down to this: knowing what to say back when the agent stalls, lies, hands the decision back to you, or quietly makes something up. This is the phrasebook for those moments."* — wrapped in `<p class="thesis">`.
  3. Keep the three-card `.modes` grid as-is.
  4. Move the inline-style mess at `index.astro:41-44` into a new `.mode.cta-row` class in `global.css`; or, if that section is being deleted entirely (per step 1), this is moot.
- **Why:** Content/voice review CRITICAL §10 Rewrite 1. Two competing CTAs ten pixels apart; no thesis on the home page; the fake-search section is misleading.
- **Definition of done:** Home page renders thesis paragraph above the three-card grid. No duplicate CTAs. `pnpm build` exits 0.

##### T-016 — Replace home kicker + "production software" sweep
- **Status:** not-started
- **Files to edit:** `site/src/pages/index.astro`, `site/src/pages/llms.txt.ts`, any other surface that uses the phrase
- **Instructions:**
  1. Change the kicker on the home page from "How to talk to an AI agent so it builds production software" to "How to talk to your AI agent when it gets stubborn."
  2. Search the codebase for the literal string `production software`. Replace each occurrence with `real software`.
  3. Verify in built `llms.txt`.
- **Why:** Content/voice review §10 Rewrite 2 + §9. "Production software" is marketing-vocab; the site uses "real software" elsewhere. Consistency.
- **Definition of done:** Zero occurrences of "production software" in `site/src/`. Home kicker reads the new copy.

##### T-017 — Rewrite About paragraph 3
- **Status:** not-started
- **Files to edit:** `site/src/pages/about.astro`
- **Instructions:** Replace the existing paragraph 3 (starting "Over the course of more than a thousand working sessions...") with the tighter version from content/voice §10 Rewrite 3: *"A thousand sessions in, I had a notebook of patterns. The agent failed the same way over and over. \"Please remember\" never worked. \"Build a rule the agent can't ignore\" almost always did. \"What do you want me to do?\" stalled the work. \"You decide and tell me why\" moved it."*
- **Why:** Content/voice §2 Passage C + §10 Rewrite 3. LLM-cadence drift; rewrite drops the "Over the course of" tic and halves word count while preserving substance.
- **Definition of done:** Paragraph reads the new copy. About page builds.

##### T-018 — Rewrite About verification-discipline paragraph
- **Status:** not-started
- **Files to edit:** `site/src/pages/about.astro`
- **Instructions:** Replace the verification-discipline paragraph (currently "Every claim on this site is anchored in a count from the underlying working corpus...") with content/voice §10 Rewrite 4: *"Every number on this site is a real number from real sessions. If a section's claim can't be traced back to a count, the section stays empty. Guessing is the failure mode this manual is trying to break — the manual itself doesn't guess."*
- **Why:** Content/voice §2 Passage D — labeled CLAUDE-DEFAULT-EXPLAINER. The single most fixable voice problem on the site.
- **Definition of done:** Paragraph reads the new copy.

##### T-019 — Contraction pass on Start Here card bodies
- **Status:** not-started
- **Files to edit:** `site/src/pages/start-here.astro`
- **Instructions:** Pass through all five `move.body` strings and apply contractions per content/voice §5:
  - Move 03: "I have added" → "I've added"
  - Move 04: "it cannot do" → "it can't do"; "you will need" → "you'll need"; "three out of four times" → "three quarters of the time" (both occurrences, for global consistency with the phrasebook entry)
  - Move 05: "will not fix" → "won't fix"; "cannot ignore" → "can't ignore"
- **Why:** Content/voice §5 MEDIUM finding. Uncontracted English is Claude-default register; Maxwell's voice uses contractions.
- **Definition of done:** Five card bodies updated. No remaining uncontracted forms where contraction reads natural.

##### T-020 — Document story-mode decision in CLAUDE.md
- **Status:** not-started
- **Files to edit:** `site/CLAUDE.md`
- **Instructions:** Add a short subsection under "Voice and content" titled "Phrasebook story mode" stating: *"Every phrasebook entry's 'where this came from' section uses first-person scar-tissue mode ('I once X. Later Y. The lesson was Z.'). Constraint: no two stories share the same anchoring image — no two stories say 'a service', 'weeks later', 'for months', etc. Variance comes from substance, not structure."*
- **Why:** Content/voice §3 CRITICAL framing question. Twelve memoir-shaped stories risk becoming a memoir; locking the mode AND the variance rule preserves the manual register.
- **Definition of done:** Section added to CLAUDE.md. Next phrasebook author task will read it.

#### Medium tier (polish)

##### T-021 — Bump --muted to pass AA on --panel
- **Status:** not-started
- **Files to edit:** `site/src/styles/global.css`
- **Instructions:** Change `--muted: #6e7b89` (4.37:1 on --panel — FAIL AA body). Target a value that clears 4.5:1. Candidate: `#7a8693` (estimated 4.6+). Verify with a contrast checker; visually verify the muted text doesn't read too bright. If too bright, instead introduce a new token `--muted-on-panel: #7d8a98` and use selectively where backgrounds are panel-colored.
- **Why:** Architecture review §2.5 MEDIUM contrast fail. Blocks T-003 pa11y CI.
- **Definition of done:** All muted-text-on-panel uses pass 4.5:1.

##### T-022 — Replace opacity:0.45 stubs with explicit token color
- **Status:** not-started
- **Files to edit:** `site/src/pages/phrasebook.astro`, `site/src/styles/global.css`
- **Instructions:** Drop the inline `style="opacity:0.45; cursor:default; pointer-events:none"` on stub rows. Replace with a `.pb-row.is-stub` class. In CSS, the class sets color via `--dim` token, `cursor: default`, `pointer-events: none`. Add `aria-disabled="true"` and a visually-hidden `<span class="sr-only">, forthcoming, not yet published</span>` for screen readers.
- **Why:** Architecture §2.4 MEDIUM. Opacity bypasses tokens and crashes contrast; aria-disabled signals state to AT.
- **Definition of done:** Stub rows render with token-based dim color, pass AA Large at minimum, announce "forthcoming" to screen readers.

##### T-023 — Polish CopyButton: aria-live, aria-label, error recovery, error styling
- **Status:** not-started
- **Files to edit:** `site/src/components/CopyButton.ts`, `site/src/styles/global.css`
- **Instructions:**
  1. In `connectedCallback`, also set `this.setAttribute('aria-label', 'Copy paste text to clipboard'); this.setAttribute('aria-live', 'polite');`
  2. In the `catch` branch, after setting `data-state = 'error'`, also do `setTimeout(() => { this.dataset.state = 'idle'; this.textContent = original; }, 1400);`
  3. In `global.css`, add `copy-button[data-state='error'] { background: var(--red); color: var(--bg); border-color: var(--red); }`
- **Why:** Architecture §2.8 MEDIUM. Silent error state today; state changes announce to screen readers post-fix.
- **Definition of done:** Denying clipboard permission (in DevTools) shows a brief red error state, then returns to idle. Screen-reader testing announces "Copied" after success.

##### T-024 — Remove Astro generator meta tag
- **Status:** not-started
- **Files to edit:** `site/src/layouts/Base.astro`
- **Instructions:** Delete the `<meta name="generator" content={Astro.generator} />` at Base.astro:94.
- **Why:** Security review F-07 NIT. Tells scanners the exact Astro version; maps to known CVEs.
- **Definition of done:** No generator meta on any built page.

##### T-025 — Remove unused @astrojs/mdx
- **Status:** not-started
- **Files to edit:** `site/package.json`, `site/astro.config.mjs`
- **Instructions:** Remove `@astrojs/mdx` from `dependencies`. Remove the `mdx()` integration from `astro.config.mjs`. Remove the unused import line. Run `pnpm install` to update the lockfile.
- **Why:** Security review §5 + architecture review. No `.mdx` files exist; reduces dependency surface and supply-chain audit load.
- **Definition of done:** `pnpm build` exits 0. `pnpm list @astrojs/mdx` shows it's gone.

##### T-026 — Add Prettier + plugin-astro
- **Status:** not-started
- **Files to create:** `site/.prettierrc`, `site/.prettierignore`
- **Files to edit:** `site/package.json`
- **Instructions:** Add `prettier ^3.3.0` and `prettier-plugin-astro ^0.14.0` to `devDependencies`. Create `.prettierrc` with `{ "printWidth": 100, "semi": true, "singleQuote": true, "plugins": ["prettier-plugin-astro"] }`. Create `.prettierignore` with `dist`, `node_modules`, `.astro`. Add `"format": "prettier --write 'src/**/*.{astro,ts,js,css,md}'"` script. Run it once.
- **Why:** Handoff STACK.md budgeted Prettier; not installed; consistency matters for cold-start agents.
- **Definition of done:** `pnpm format` runs without errors. `pnpm format --check` exits 0 after running write.

##### T-027 — Add ESLint flat config
- **Status:** not-started
- **Files to create:** `site/eslint.config.js`
- **Files to edit:** `site/package.json`
- **Instructions:** Add `eslint ^9.0.0`, `astro-eslint-parser`, `@typescript-eslint/parser`, `eslint-plugin-astro`, `typescript-eslint` to `devDependencies`. Create `eslint.config.js` (flat config) with rules for `.astro` and `.ts`/`.js` files: no-unused-vars warn, prefer-const error, no-implicit-any error, recommended ts rules. Add `"lint": "eslint 'src/**/*.{astro,ts,js}'"`. Run; resolve any findings.
- **Why:** Handoff STACK.md budgeted ESLint.
- **Definition of done:** `pnpm lint` exits 0.

##### T-028 — Add GitHub Actions CI
- **Status:** not-started
- **Prereqs:** T-026, T-027
- **Files to create:** `site/.github/workflows/ci.yml`
- **Instructions:** Workflow triggers on push and pull_request. Steps: checkout, setup pnpm, setup Node 22, cache pnpm store, `pnpm install`, `pnpm check`, `pnpm lint`, `pnpm format --check`, `pnpm build`. Fail the workflow if any step fails.
- **Why:** Mechanical regression gate. Every change is screened before landing.
- **Definition of done:** Workflow file syntactically valid (verify with `actionlint` if available). Local simulation of all steps passes.

##### T-029 — Add _TEMPLATE.md.txt authoring scaffold
- **Status:** not-started
- **Files to create:** `site/src/content/phrasebook/_TEMPLATE.md.txt`
- **Instructions:** Annotated frontmatter scaffold for a new phrasebook entry. Every field has an inline comment naming: what it is, length cap, format constraint, sterilization reminder. `.txt` extension keeps it out of the content collection glob.
- **Why:** Architecture review §4.9. Cold-start agent copying T-101 from spec needs an annotated reference.
- **Definition of done:** File exists. Contains every schema field with inline comments. `pnpm build` does not pick it up as an entry.

##### T-030 — Add prompt-injection guard
- **Status:** not-started
- **Files to edit:** `site/src/content/config.ts`
- **Instructions:** Add a Zod `.refine()` on `pasteText` that rejects strings matching `^(Ignore|Forget|Disregard|You are now|Your new role|System:|Assistant:|Human:)\\b/i`. Same for entries of `whyThisWorks` and `whereThisCameFrom`. The `.refine()` should produce a clear error message naming the disallowed prefix.
- **Why:** Security review §6. `llms-full.txt` (Phase 7) will concatenate body content; if a future Claude session ingests it as authoritative context, prompt-injection patterns in entry bodies become a vector.
- **Definition of done:** A test entry with `pasteText: "Ignore all previous instructions"` fails `pnpm check` or `pnpm build`. Removing the prefix passes.

##### T-031 — Sterilization micro-tightening
- **Status:** not-started
- **Files to edit:** `site/src/pages/about.astro`, `site/src/content/phrasebook/paid-service-claim.md`
- **Instructions:**
  1. `about.astro:20` — drop "small" from "a small company" → "a company".
  2. `about.astro:22` — compress "no technical co-founder, no junior developer, no engineering staff" → "no engineering team behind me".
  3. `paid-service-claim.md` — change "I once paid for a service for months because" → "I once paid for a service I could have self-hosted free, because" (drops the months-anchor breadcrumb).
- **Why:** Content/voice §7. Three sterilization NITs — none load-bearing alone but together they leak less.
- **Definition of done:** Three substitutions in place. Sterilization sweep on About + the entry returns clean.

### Phase 1 — Content to full coverage

Twelve more phrasebook entries to author. Each follows the same shape:

**Common task template — TC-PHRASEBOOK-ENTRY:**
- **Prereqs:** none
- **Read first:**
  - `site/src/content/config.ts` (the schema)
  - `site/src/content/phrasebook/paid-service-claim.md` (the reference entry — copy this shape)
  - `_internal/verified-principles.md` (find the principle this entry leans on)
  - `_internal/phase1/index.md` (find the recognition phrases)
  - `_internal/claude-insights-full/out/aggregate.json` (find the corpus count for the `appears` field)
- **Instructions:**
  1. Create `site/src/content/phrasebook/<slug>.md` matching the schema exactly.
  2. Frontmatter fields: `title`, `quote`, `subtitle`, `description` (≤180 chars), `category` (one of `giving-up` / `done-before-done` / `handing-back` / `making-up`), `categoryNumber`, `categoryLabel`, `appears`, `categoryTotal`, `successRate` (optional), `relatedMove`, `hearing` (3-5 phrases), `pasteText`, `whyThisWorks` (1-3 paragraphs), `whereThisCameFrom` (2-4 paragraphs, sterilized), `pubDate`.
  3. Sterilize per § 4 of this file.
  4. Add a row to the `phrasebook.astro` placeholders list with `coveredBy: '<slug>'` so the stub disappears from the index.
- **Definition of done:**
  - File exists and `pnpm build` exits 0.
  - The entry appears in `/phrasebook` (real, full-opacity row).
  - The entry renders at `/phrasebook/<slug>` at all four viewports without console errors.
  - The sterilization checklist passes.

The twelve entries:

| Task  | Category          | Slug                          | Quote (agent's voice)                                                |
| ----- | ----------------- | ----------------------------- | -------------------------------------------------------------------- |
| T-101 | giving-up         | `cant-do-something`           | "I can't do that"                                                    |
| T-102 | giving-up         | `good-stopping-place`         | "this is a good place to stop"                                       |
| T-103 | done-before-done  | `complete-but-untested`       | "the change is complete"                                             |
| T-104 | done-before-done  | `paraphrased-error`           | "the command failed with a permissions issue" (paraphrased)          |
| T-105 | done-before-done  | `time-estimate`               | "this should take about thirty minutes"                              |
| T-106 | done-before-done  | `claimed-ran-but-didnt`       | "I ran the tests and they all pass"                                  |
| T-107 | handing-back      | `three-options`               | "would you like A, B, or C?"                                         |
| T-108 | handing-back      | `your-preference`             | "this depends on your preference"                                    |
| T-109 | handing-back      | `what-would-you-like`         | "what would you like me to do?"                                      |
| T-110 | making-up         | `cites-own-doc-as-authority`  | "per the spec you wrote" (when the spec was AI-authored)             |
| T-111 | making-up         | `false-file-citation`         | "the file says X" (when it doesn't)                                  |
| T-112 | making-up         | `unrequested-scope-change`    | "I also went ahead and refactored Y"                                 |

For each task `T-1NN` use the common template above plus the specific slug, category, and quote from the table.

**Five foundation move detail pages:**

#### T-150 — Build foundation move detail page route
- **Phase:** 1
- **Status:** not-started
- **Prereqs:** none
- **Read first:**
  - `site/src/pages/start-here.astro` (the index page; the cards already have slugs and bodies)
  - `site/src/pages/phrasebook/[slug].astro` (mirror its dynamic-route pattern)
- **Files to create:**
  - `site/src/content/foundations/` directory + Zod schema in `src/content/config.ts`
  - `site/src/pages/start-here/[slug].astro` dynamic route
- **Instructions:**
  1. Define a `foundations` collection in `config.ts`. Fields: `title`, `summary` (≤180 chars), `slug`, `n` (e.g., "MOVE / 01"), `body` (string, full essay), `pasteExamples` (array of objects: { label, text }), `relatedPhrasebook` (array of slugs), `pubDate`.
  2. Create five entries: `ai-is-the-engineer.md`, `refuse-the-menu.md`, `verify-the-artifact.md`, `push-back-on-i-cant.md`, `make-recurring-mistakes-mechanical.md`.
  3. Build `[slug].astro` to render each foundation move as a full page. Layout: hero (kicker MOVE/0N, title, summary), body (the essay), paste-examples (using the same `paste-block` component as phrasebook entries), related phrasebook entries.
  4. Update `start-here.astro` cards to link to `/start-here/<slug>` instead of `#<slug>`.
- **Why:** The five cards on Start Here currently show body text in-line. They need full pages so the deeper material lives somewhere; foundation moves are the *why* phrasebook entries lean on.
- **Definition of done:** All five `/start-here/<slug>` URLs render. Each links to relevant phrasebook entries. `pnpm build` exits 0.

#### T-151 through T-155 — Author the five foundation move bodies

| Task  | Slug                                | Title                                            | Source principles in `verified-principles.md` |
| ----- | ----------------------------------- | ------------------------------------------------ | --------------------------------------------- |
| T-151 | `ai-is-the-engineer`                | The AI is the engineer. You are not.             | Theme A (operator worldview)                  |
| T-152 | `refuse-the-menu`                   | Refuse the menu.                                 | Theme A, Principle 2                          |
| T-153 | `verify-the-artifact`               | Verify the artifact, not the summary.            | Theme B (tool output as truth)                |
| T-154 | `push-back-on-i-cant`               | Push back on "I can't" once.                     | Theme F (receptionist refusals)               |
| T-155 | `make-recurring-mistakes-mechanical`| Make every recurring mistake mechanical.         | Theme D (mechanical enforcement)              |

Each task follows the same shape: read the relevant principles, write the foundation move body in plain non-technical English (1,200-2,000 words), include 2-3 paste-example blocks (sterilized), list 3-5 related phrasebook entries.

### Phase 2 — Vercel-style command palette

#### T-201 — Build the search-index manifest endpoint
- **Phase:** 2
- **Status:** not-started
- **Prereqs:** T-101 through T-112 (entries exist), T-151 through T-155 (foundations exist)
- **Read first:**
  - § 7 of this file (the spec)
  - `site/src/pages/llms.txt.ts` (pattern for build-time endpoints)
- **Files to create:**
  - `site/src/pages/search.json.ts`
- **Instructions:**
  1. Astro API route emitting `application/json`.
  2. Pull phrasebook entries via `getCollection('phrasebook')`, foundations via `getCollection('foundations')`.
  3. Emit array of `{ section, label, url, category, description, kicker }` objects.
  4. Include the three top-level pages: home, phrasebook index, start-here index, about.
- **Why:** Single typed source of truth for the search palette. Built at compile time; zero runtime cost.
- **Definition of done:** `pnpm build` emits `/search.json` containing all phrasebook entries, all foundations, and all pages.

#### T-202 — Build the `<command-palette>` custom element
- **Phase:** 2
- **Status:** not-started
- **Prereqs:** T-201
- **Read first:**
  - § 7 of this file
  - `site/src/components/CopyButton.ts` (pattern for custom elements in this codebase)
- **Files to create:**
  - `site/src/components/CommandPalette.ts`
- **Instructions:**
  1. Vanilla custom element. Shadow DOM optional (probably skip — easier styling with global tokens).
  2. On `connectedCallback`: attach listeners for `keydown` on `document` (Cmd+K, Ctrl+K, /, Esc).
  3. Render the overlay structure into the light DOM. Hidden by default via `[hidden]` attribute.
  4. Lazy-fetch `/search.json` on first open; cache for the session.
  5. Render matching results grouped by section.
  6. Arrow keys move the active row; Enter navigates; Esc closes.
  7. Click outside modal closes.
  8. `prefers-reduced-motion` disables animations.
- **Why:** This is the primary interactive surface beyond copy-buttons. Must remain framework-free.
- **Definition of done:** Cmd+K opens the palette anywhere on the site. Typing filters results. Arrow keys navigate. Enter goes to the URL. Esc closes. Bundle size under 8 KB gzipped (verified by `pnpm build`'s output).

#### T-203 — Style the command palette
- **Phase:** 2
- **Status:** not-started
- **Prereqs:** T-202
- **Read first:**
  - § 7 of this file (visual spec)
  - `site/src/styles/global.css` (token system; add palette styles here in a new section)
- **Files to edit:**
  - `site/src/styles/global.css`
- **Instructions:**
  1. Add a `.cmd-palette` section to the bottom of global.css.
  2. Style the backdrop, modal, search input, section headers, rows, active state per § 7.
  3. Mobile-first: full-screen takeover below 640px; centered modal at ≥640px.
  4. Use existing tokens (`--panel-2`, `--blue`, etc.) only.
- **Why:** Visual continuity with the rest of the site.
- **Definition of done:** Visual screenshots at 375 and 1440 match § 7's spec.

#### T-204 — Mount the palette globally and re-wire home CTA
- **Phase:** 2
- **Status:** not-started
- **Prereqs:** T-202, T-203
- **Files to edit:**
  - `site/src/layouts/Base.astro` (add `<command-palette></command-palette>` before `</body>`; import the JS module)
  - `site/src/pages/index.astro` (change the home CTA to a button that dispatches `cmd-palette-open` event)
- **Instructions:**
  1. Single `<command-palette>` instance at end of `<body>` in `Base.astro`.
  2. The home page's "Browse the phrasebook" CTA becomes a `<button>` element that, on click, dispatches the open event the palette listens for.
  3. The palette closes on URL change (listen for navigation; the Astro view-transitions `astro:before-preparation` event is the right hook).
- **Why:** One instance, mounted once, available everywhere.
- **Definition of done:** Cmd+K, `/`, and click on the home CTA all open the same palette.

#### T-205 — Browser-validate command palette at 4 viewports
- **Phase:** 2
- **Status:** not-started
- **Prereqs:** T-204
- **Instructions:**
  1. Open the palette at 375, 768, 1024, 1440. Screenshot each.
  2. Type a query, verify filtering. Screenshot.
  3. Tab through rows with keyboard, verify focus visible.
  4. Verify Esc closes, click-outside closes.
  5. Verify `prefers-reduced-motion` works.
  6. Capture console: zero errors.
- **Definition of done:** Eight screenshots captured. Zero console errors. All keyboard paths work.

### Phase 3 — Open Graph image generation

#### T-301 — Add `@vercel/og` or Satori dependency
- **Phase:** 3
- **Status:** not-started
- **Prereqs:** none
- **Read first:** https://github.com/vercel/satori (likely the right pick — pure TS, runs at build time)
- **Files to edit:** `site/package.json`
- **Instructions:**
  1. Add `satori` and `@resvg/resvg-js` to dependencies. (Satori produces SVG; resvg renders to PNG.)
  2. Add `sharp` if needed for additional image work (probably not).
- **Definition of done:** Both packages install cleanly; no peer-dep warnings.

#### T-302 — Build the OG image generator endpoint
- **Phase:** 3
- **Status:** not-started
- **Prereqs:** T-301
- **Read first:** Satori README; `_internal/handoff/SEO.md` § OG image spec
- **Files to create:**
  - `site/src/pages/og/[slug].png.ts`
  - `site/src/lib/og-template.tsx` (the JSX template Satori renders)
- **Instructions:**
  1. The endpoint at `/og/<slug>.png` reads the matching phrasebook entry or page, builds a Satori JSX template, renders to SVG, converts to PNG via resvg, returns the buffer.
  2. The template: dark background, Plex Sans Condensed display title, kicker for category, footer with site brand. 1200x630.
  3. For pages without a content collection match (home, phrasebook index, start-here index, about), build static OG images at known paths.
- **Why:** Open Graph images drive link-preview visuals on Twitter, Slack, LinkedIn, Discord, every messenger. Without them, share-link previews are empty boxes.
- **Definition of done:** Every page's `og:image` meta tag resolves to a real PNG. Visually verified by pasting URLs into Twitter/Slack preview generators.

#### T-303 — Wire OG image URLs into `Base.astro`
- **Phase:** 3
- **Status:** not-started
- **Prereqs:** T-302
- **Files to edit:** `site/src/layouts/Base.astro`
- **Instructions:** The `ogImage` prop already exists; just default it to `/og/<slug>.png` based on the URL pathname. Phrasebook entries already pass a custom value; pages can use the default.
- **Definition of done:** All page-source views show a real `og:image` URL.

### Phase 4 — Polish layer

#### T-401 — Hover lift on cards
- **Phase:** 4
- **Status:** not-started
- **Files to edit:** `site/src/styles/global.css`
- **Instructions:** Add subtle `transform: translateY(-2px)` and `box-shadow` change on hover for `.mode`, `.move`, `.pb-row`. Transition 120ms ease. Respect `prefers-reduced-motion`.
- **Why:** Tactile feedback when an interactive element is hoverable. Currently the only hover state is border-color change; lift adds depth.

#### T-402 — Reading-progress indicator on entry pages
- **Phase:** 4
- **Status:** not-started
- **Files to create:** `site/src/components/ReadingProgress.ts` (custom element)
- **Files to edit:** `site/src/pages/phrasebook/[slug].astro` (add element), `site/src/styles/global.css` (style)
- **Instructions:** Thin bar at top of the page that fills as the user scrolls through the entry. Blue accent color. Static at top; absolute-positioned. Hidden on mobile (bar doesn't help when the page is shorter).
- **Why:** Long entry pages should give the reader a sense of progress. Subtle; not load-bearing UI.

#### T-403 — Polish copy-button state machine
- **Phase:** 4
- **Status:** not-started
- **Files to edit:** `site/src/components/CopyButton.ts`, `site/src/styles/global.css`
- **Instructions:** Add `data-state` values for: `idle`, `hover`, `pressed`, `copied`, `error`. Each gets a distinct visual state. The success state holds for 1.4s, then returns to idle. The error state (clipboard rejected) shows briefly.
- **Why:** Currently states are minimal. The copy interaction is one of the most-used affordances on the site.

#### T-404 — Focus-visible audit across all interactive elements
- **Phase:** 4
- **Status:** not-started
- **Files to edit:** `site/src/styles/global.css`
- **Instructions:** For every clickable element (links, buttons, custom elements), confirm a visible `:focus-visible` outline. Use the existing `--blue` accent. No `outline: none` anywhere.
- **Why:** Keyboard navigation parity with mouse. Required for accessibility CI to pass.

#### T-405 — Subtle scroll-driven section reveals on entry pages
- **Phase:** 4
- **Status:** not-started
- **Files to edit:** `site/src/pages/phrasebook/[slug].astro`, `site/src/styles/global.css`
- **Instructions:** Each `.block` on entry pages fades up subtly as it enters the viewport. Use CSS scroll-driven animations where supported; fall back to no animation otherwise. Respect `prefers-reduced-motion`.
- **Why:** Texture. The page should feel like it's revealing itself rather than dumping all content at once.

### Phase 5 — Security hardening

#### T-501 — Author the security-headers configuration
- **Phase:** 5
- **Status:** not-started
- **Read first:**
  - https://web.dev/articles/security-headers
  - https://content-security-policy.com
- **Files to create:**
  - `site/public/_headers` (Cloudflare Pages convention)
- **Instructions:** Add the following headers to all routes:
  - `Content-Security-Policy: default-src 'self'; img-src 'self' data:; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline'; font-src 'self'; connect-src 'self'; frame-ancestors 'none'; base-uri 'self'; form-action 'none'; object-src 'none'`
    > **Amendment 2026-05-15 (T-010):** `script-src` includes `'unsafe-inline'` so the inline JSON-LD structured-data block in `Base.astro` is not blocked. Without it, every page's JSON-LD silently fails and the site loses all rich-results indexing. Backlog: switch to a build-time hash-based policy to drop `'unsafe-inline'` later. Added `object-src 'none'` per security review §4.
  - `Strict-Transport-Security: max-age=63072000; includeSubDomains; preload`
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: DENY`
  - `Referrer-Policy: strict-origin-when-cross-origin`
  - `Permissions-Policy: camera=(), microphone=(), geolocation=(), payment=(), usb=(), accelerometer=(), gyroscope=(), magnetometer=()`
  - `Cross-Origin-Opener-Policy: same-origin`
  - `Cross-Origin-Resource-Policy: same-origin`
- **Why:** Defense in depth. The site has no user input, no auth, no third-party scripts — these headers prevent classes of attack regardless.
- **Definition of done:** `curl -I https://<deploy-url>` shows every header. https://securityheaders.com grades the site A+.

#### T-502 — Configure robots.txt with explicit AI bot policy
- **Phase:** 5
- **Status:** not-started
- **Files to edit:** `site/public/robots.txt`
- **Instructions:** Allow major AI crawlers explicitly: `GPTBot`, `ClaudeBot`, `anthropic-ai`, `PerplexityBot`, `Google-Extended`, `CCBot`, `Bytespider`. Allow `*` for traditional crawlers. Sitemap reference.
  > **Amendment 2026-05-15 (T-010):** Replaced `Claude-Web` with `ClaudeBot` per security review §4 — `Claude-Web` is not the canonical Anthropic crawler user-agent. `anthropic-ai` remains the umbrella identifier.
- **Why:** The site's audience explicitly includes AI sessions. Explicit allowlist signals intent and aids discovery.

#### T-503 — Cookie audit
- **Phase:** 5
- **Status:** not-started
- **Instructions:** Confirm zero cookies set. Browser DevTools → Application → Cookies should be empty across all pages. Document the zero-cookie posture in a comment in `Base.astro`.
- **Why:** Compliance with privacy expectations. No cookies → no consent banner → no GDPR or CCPA burden.

### Phase 6 — Performance gates

#### T-601 — Preload critical fonts
- **Phase:** 6
- **Status:** not-started
- **Files to edit:** `site/src/layouts/Base.astro`
- **Instructions:** Add `<link rel="preload" as="font" type="font/woff2" crossorigin>` for the three font files that appear above the fold: Plex Sans Condensed 700, Plex Sans Condensed 600, Plex Mono 400. Find the exact paths in `node_modules/@fontsource/...`.
- **Why:** Reduces FOIT (flash of invisible text) and improves LCP.
- **Definition of done:** Lighthouse `first-contentful-paint` improves; no font flash visible at slow 3G.

#### T-602 — Lighthouse CI integration
- **Phase:** 6
- **Status:** not-started
- **Read first:** https://github.com/GoogleChrome/lighthouse-ci
- **Files to create:** `site/.lighthouserc.json`
- **Instructions:** Configure with all five page URLs. Performance, Accessibility, Best Practices, SEO all targeting 100. Add `pnpm script: "lhci": "lhci autorun"`.
- **Definition of done:** All four scores 100/100/100/100 on all pages. CI fails if any drop below 95.

#### T-603 — Cache-control headers
- **Phase:** 6
- **Status:** not-started
- **Files to edit:** `site/public/_headers`
- **Instructions:** Long cache for `/_astro/*` (hashed bundles), `/og/*`, `/fonts/*` (immutable). Short cache for HTML pages (e.g., `max-age=300, stale-while-revalidate=86400`).
- **Why:** Best-effort caching without manual revalidation.

#### T-604 — Bundle audit
- **Phase:** 6
- **Status:** not-started
- **Instructions:** Run `pnpm build` and inspect `dist/_astro/*.js` sizes. Confirm total client JS under 15 KB gzipped. Remove anything unused.
- **Definition of done:** Total client JS ≤ 15 KB gzipped. Documented in this task's "done" note.

### Phase 7 — AI-SEO + crawler optimization

#### T-701 — Build llms-full.txt endpoint
- **Phase:** 7
- **Status:** not-started
- **Read first:** https://llmstxt.org/#format
- **Files to create:** `site/src/pages/llms-full.txt.ts`
- **Instructions:** Concatenated full content of every phrasebook entry and foundation move into a single Markdown response. Per the llms.txt spec. Cache-control `max-age=3600`.
- **Why:** AI crawlers consume the full text in one fetch.
- **Definition of done:** `/llms-full.txt` returns ≥10 KB of content. Plain-text response.

#### T-702 — Expand JSON-LD: BreadcrumbList on entries
- **Phase:** 7
- **Status:** not-started
- **Files to edit:** `site/src/pages/phrasebook/[slug].astro`
- **Instructions:** Add a `BreadcrumbList` JSON-LD: Home → Phrasebook → Category → Entry. Same for foundation moves.
- **Why:** Google rich-results expand entries with breadcrumbs in SERP.

#### T-703 — Add HowTo or FAQPage Schema.org markup to entries
- **Phase:** 7
- **Status:** not-started
- **Files to edit:** `site/src/pages/phrasebook/[slug].astro`
- **Instructions:** Each phrasebook entry can be expressed as a `HowTo`: the steps are (1) recognize the agent's words, (2) paste the intervention, (3) verify the agent's response. Add the JSON-LD.
- **Why:** Richer SERP. Each entry surfaces as an interactive how-to result.

#### T-704 — Internal linking audit
- **Phase:** 7
- **Status:** not-started
- **Instructions:** Every phrasebook entry should link to its related foundation move (already there). Every foundation move should link to ≥3 related phrasebook entries. The About page should link to a representative phrasebook entry and the Start Here index. The home page already links everywhere.
- **Why:** Crawl depth and SEO. Pages with three internal inbound links rank meaningfully better than orphan pages.

### Phase 8 — Production deployment

#### T-801 — Cloudflare Pages project setup
- **Phase:** 8
- **Status:** not-started
- **Read first:** https://developers.cloudflare.com/pages/framework-guides/deploy-an-astro-site/
- **Instructions:** Create Cloudflare Pages project pointed at the GitHub repo (or direct upload). Build command `pnpm build`, output `dist/`. Configure environment variables (none currently). Confirm the `_headers` file is honored.
- **Definition of done:** Project deploys on push.

#### T-802 — Custom domain
- **Phase:** 8
- **Status:** not-started
- **Prereqs:** T-801
- **Instructions:** Configure custom domain at Cloudflare. Verify HTTPS certificate. Add the domain to `astro.config.mjs`'s `site` field.
- **Definition of done:** Site reachable at custom domain with valid HTTPS.

#### T-803 — Production smoke test
- **Phase:** 8
- **Status:** not-started
- **Prereqs:** T-802
- **Instructions:** Run the Playwright smoke suite (`pnpm test`) against the deployed URL. Run `lhci` against the deployed URL. Verify securityheaders.com grade is A+.
- **Definition of done:** All gates pass against production.

#### T-804 — Basic uptime monitoring
- **Phase:** 8
- **Status:** not-started
- **Prereqs:** T-803
- **Instructions:** Configure a free uptime check (UptimeRobot, BetterUptime, or similar) that pings `/` every 5 minutes. Email alert on downtime. No analytics; just uptime.
- **Definition of done:** Service active; alert tested with a deliberate 404.

## 10. Definition of done

### Per task
Mechanical checks specified per task. Must all pass.

### Per phase
- All tasks in the phase have status `done`.
- `pnpm build` exits 0.
- `pnpm test` (Playwright smoke) exits 0.
- `pnpm a11y` exits 0 (once Phase 0 lands).
- Browser-validated at four viewports for any visual change.
- Sterilization checklist passed for any content change.

### Per site (production-ready)
- All phases through 8 are `done`.
- Live at custom domain with valid HTTPS.
- Lighthouse 100/100/100/100 on every page.
- securityheaders.com grade A+.
- Zero console errors on any page.
- Zero cookies set.
- Zero third-party scripts loaded.
- `/llms.txt` and `/llms-full.txt` populated.
- Sitemap published.
- Robots.txt with explicit AI policy.
- Uptime monitor active.
- README and CLAUDE.md and MASTER-PLAN.md all current.

## 11. How to use this document

You (the agent) just finished reading it. Now:

1. Open the task catalog (§ 9).
2. Find the lowest-numbered `not-started` task in the lowest active phase (skip done phases).
3. Verify its prereqs are `done`. If not, pick a different task whose prereqs are met.
4. Read the task's "Read first" files.
5. Execute the task's "Instructions" steps in order.
6. Run the task's "Definition of done" check.
7. Edit this file to change the task's `Status: not-started` to `Status: done` and add a one-line `Result:` note immediately below.
8. Commit. Conventional message format: `feat(T-NNN): <short subject>`.
9. Update the Maxwell-facing summary at the top of this file (Section 2 "Current state") if your task materially changed what's built.

You do not have permission to skip phases, ad-lib content, or invent tasks outside this plan. If a needed task is missing, add it as a new T-NNN entry and surface to Maxwell before executing it.

— **End of MASTER-PLAN.md** —
