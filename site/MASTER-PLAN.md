# MASTER-PLAN.md — How to Use Claude Code

> **Read this in full the first time. After that, jump to the active phase.**
>
> This file is the binding execution plan for the website at `site/`. A cold-start agent who reads `site/CLAUDE.md` and this file has everything needed to pick a task and execute it without prior session context.

## 0. About this document

- **Purpose:** Single source of truth for what to build, in what order, by what mechanism.
- **Authority:** Binding. New work happens by adding a task here, not by side-channel improvisation.
- **Granularity:** Each task (T-NNN) is a single agent dispatch — one focused unit with self-contained context.
- **Status tracking:** Every task has a `Status:` line. Update it as work progresses. Permitted values: `not-started`, `in-progress`, `done`.
- **No time estimates anywhere.** Phases are shippable units, not calendar windows.

---

## 1. The artifact we are building

A static website branded as **How to Use Claude Code**. A user-friendly guide for non-technical operators mastering Claude Code through pattern recognition, response vocabulary, and system-building practice.

**Audience (two-tier):**

1. **Humans** — non-technical operators learning to push AI past hallucinated capability ceilings, verify every claim, and build a working harness around an AI engineer. Many of them are running ChatGPT or Claude Web; the guide is platform-aware (Claude Code is the central case study, the principles transfer).
2. **AI sessions** — Claude / ChatGPT / Gemini sessions whose operators have pasted a link to the site (or to `/llms-full.txt`) into their context window. Every page is structured so an LLM can ingest it cleanly. `/llms-full.txt` is the single-URL "paste this into your AI" handle.

**What the guide teaches:**

- The four anchor rules of operator-AI work.
- The tools to install (open-source plugins, skills, hooks, memory).
- The patterns AI exhibits when it tries to escape work, and how to recognize them.
- The vocabulary the operator uses in response.
- The session-loop that holds: brainstorm → plan → build → review → persist.
- How to build the harness incrementally — hooks, memory, ast-grep rules as you go.
- How to run multiple AI agents in parallel without chaos.
- Browser validation as a non-negotiable verification gate.
- A printable quick reference.

**Animating thesis:**

> Treat AI as a worker who can do anything. Verify every claim. When a pattern fails, build the mechanical block that catches the class. The apparatus is the residue of paid attention to failures.

**Three reading modes (the IA):**

- **Home (`/`)** — title, hero, lede, table of contents. One-screen orientation; the rest is linked from here.
- **Chapter pages (`/01-mindset` through `/09-quick-reference`)** — single-scroll teaching pages. Each is internally structured but reads as one continuous chapter.
- **`/llms-full.txt`** — the entire corpus concatenated for single-paste AI ingestion.

**What this site is NOT:**

- Not a phrasebook. (Rejected prior framing.)
- Not a field manual. (Reference handoff's framing — visual bones kept, framing rejected.)
- Not a docs publication. (Starlight was the wrong skeleton.)
- Not a memoir. (No personal incidents, costs, or scars.)
- Not a marketing surface for any paid product.

---

## 2. Current state (as of 2026-05-15)

**Done:**

- Astro 5.18 scaffold at `site/`, pnpm 10, Node 22 LTS, TypeScript strict — preserved from prior build.
- Stack additions: `@astrojs/mdx@^4` installed for MDX-authored chapters.
- Tokens: `src/styles/global.css` retains GitHub-dark palette + IBM Plex Mono + Plex Sans Condensed (self-hosted via `@fontsource`). Old component selectors superseded — see Phase 1.
- Content schema rewritten: `src/content/config.ts` defines a single `chapters` collection with prompt-injection-aware Zod refinements.
- `src/lib/chapters.ts` created — canonical chapter metadata (n, short, label, slug) + `previousChapter` / `nextChapter` helpers.
- `src/lib/categories.ts` deleted (was phrasebook-shaped).
- All `src/content/foundations/*` and `src/content/phrasebook/*` markdown deleted.
- All rejected page routes deleted: `about.astro`, `phrasebook.astro`, `phrasebook/[slug].astro`, `start-here.astro`, `start-here/[slug].astro`.
- This file (`MASTER-PLAN.md`) and `CLAUDE.md` updated to reflect the new artifact.

**Broken (intentional, to be repaired by Phase 1+):**

- `pnpm build` will fail until chapters are authored, routes are wired, and endpoint files updated. This is expected interim state.
- `tests/smoke.spec.ts` ROUTES array still references rejected page paths (`/phrasebook`, `/start-here`, etc.). Will be updated in Phase 5.
- `src/pages/llms-full.txt.ts`, `src/pages/llms.txt.ts`, `src/pages/search.json.ts`, `src/pages/og/[slug].png.ts` still import the deleted `categories.ts` and reference the deleted collections. Will be updated in Phase 3.
- `src/components/CommandPalette.ts` has hardcoded section types (`'phrasebook' | 'foundations' | 'pages'`). Will be updated in Phase 3.
- `src/layouts/Base.astro` references rejected routes and old SITE_NAME. Will be updated in Phase 1.

**Preserved infrastructure (do not touch unless a task says so):**

- `src/integrations/font-preload.ts` — build-time font preload injection.
- `src/pages/og/[slug].png.ts` and `src/lib/og-template.ts` — OG image generation pipeline via Satori + Resvg.
- `src/components/CopyButton.ts`, `src/components/ReadingProgress.ts` — reusable vanilla custom elements.
- `playwright.config.ts`, `tests/` — E2E test harness.
- `.lighthouserc.json`, `.pa11yci.json`, `eslint.config.js`, `.prettierrc` — CI / quality gates.
- `public/` — static assets (favicon, robots.txt, headers).

**Files of record (this artifact):**

```
site/
├── CLAUDE.md                          (agent charter — bind first)
├── MASTER-PLAN.md                     (this file)
├── README.md                          (TBD — outside this plan)
├── package.json
├── astro.config.mjs                   (Astro + MDX + sitemap + font-preload)
├── tsconfig.json
├── playwright.config.ts
├── .lighthouserc.json
├── .pa11yci.json
├── eslint.config.js
├── .prettierrc
├── public/
│   ├── _headers
│   ├── robots.txt
│   └── favicon.svg
├── tests/
│   └── smoke.spec.ts
└── src/
    ├── layouts/
    │   └── Base.astro                 (SEO, nav, footer, fonts; to overhaul Phase 1)
    ├── components/
    │   ├── CopyButton.ts              (preserved)
    │   ├── ReadingProgress.ts         (preserved)
    │   ├── CommandPalette.ts          (section types to update Phase 3)
    │   ├── CalloutCard.astro          (to author Phase 1)
    │   ├── PullQuote.astro            (to author Phase 1)
    │   ├── ZoneHeader.astro           (to author Phase 1)
    │   ├── ChapterIntro.astro         (to author Phase 1)
    │   ├── ChapterPagination.astro    (to author Phase 1)
    │   └── CalloutBox.astro           (to author Phase 1)
    ├── content/
    │   ├── config.ts                  (chapters Zod schema)
    │   └── chapters/
    │       ├── 01-mindset.mdx         (to author Phase 2)
    │       ├── 02-install.mdx         (stub Phase 2)
    │       ├── 03-escape-moves.mdx    (stub Phase 2)
    │       ├── 04-counter-moves.mdx   (stub Phase 2)
    │       ├── 05-working-loop.mdx    (stub Phase 2)
    │       ├── 06-system-that-holds.mdx
    │       ├── 07-multi-claude.mdx
    │       ├── 08-browser-validation.mdx
    │       └── 09-quick-reference.mdx
    ├── lib/
    │   ├── chapters.ts                (canonical chapter metadata)
    │   └── og-template.ts             (Satori OG image template)
    ├── integrations/
    │   └── font-preload.ts            (preserved)
    ├── styles/
    │   └── global.css                 (tokens + base; component styles to author Phase 1)
    └── pages/
        ├── index.astro                (home — to rewrite Phase 2)
        ├── [slug].astro               (chapter detail — to author Phase 2)
        ├── 404.astro                  (light edits Phase 2)
        ├── llms.txt.ts                (to rewrite Phase 3)
        ├── llms-full.txt.ts           (to rewrite Phase 3)
        ├── search.json.ts             (to rewrite Phase 3)
        └── og/[slug].png.ts           (to rewrite Phase 3)
```

---

## 3. Binding constraints (cross-cuts every task)

Full list in `site/CLAUDE.md`. Quick reference for task execution:

1. **Sterilization.** No client/project/session names. No personal incidents. No receipts. No aggregate corpus counts. The site teaches the pattern; the author owes no proof.
2. **No emojis anywhere.** Code, content, commits, OG images, comments, filenames.
3. **No time estimates.** Anywhere.
4. **No menus to Maxwell.** Make the call. Present the result.
5. **Mobile-first CSS.** Default styles target mobile; `min-width` queries enhance.
6. **No third-party scripts, analytics, cookies, service workers.** Static-only.
7. **Total client JS budget under 15 KB gzipped.**
8. **Browser-validate at 375 / 768 / 1024 / 1440 before claiming visual tasks done.** Zero console errors.
9. **`pnpm build` is the mechanical gate.** `pnpm dev` results are not evidence of done.
10. **Carry subtle effects through iterations.** Sticky top nav, micro-animations, focus polish — load-bearing.
11. **Third-person operator-language in prose.** "The operator," "the AI." Not first-person, not memoir.
12. **Contractions where natural.** "Can't," "won't," "it's." Uncontracted is Claude-default explainer voice.

---

## 4. The sterilization checklist (run for every public-facing edit)

Before marking any content task `done`:

1. Search the diff for:
   - Client / company / project names or acronyms
   - Session IDs (hex strings, UUIDs)
   - Specific dollar amounts (any number followed by `$`)
   - Personal-incident anchoring ("I once," "I paid," "we lost," "it cost me," "X commits")
   - Aggregate-count proof framing ("N sessions across M projects," "N behaviors catalogued")
   - Receipt-shaped phrasing ("ENFORCED" badges, "verified across N projects")
2. If any are found: redact. Patterns:
   - Client/company name → drop or generalize ("a small company")
   - Project name → drop or generalize ("a long-running project")
   - Personal incident → reframe as pattern: "The AI claims X" instead of "Last May the AI claimed X for 11 commits"
   - Dollar amount → drop entirely; reframe to describe the pattern, not the cost
   - Aggregate proof → drop; voice the pattern itself
3. Read the page in a browser. If a stranger could infer Maxwell's clients, work history, or specific cost incidents, sterilize further.
4. The teaching test: would the lesson still land if the receipt were redacted? If yes, the receipt was unnecessary. If no, the lesson was leaning on biography instead of teaching.

---

## 5. Reference materials by topic

When a task says "read X for context," consult this map for which files apply.

### Visual system

- `/Users/maxwell/Downloads/handoff/source/manual.css` — original reference handoff stylesheet. **Visual bones only.** Copy the CSS primitives (tokens, panel layouts, callout cards, pull quotes, zone headers, pagination, code blocks). **Do not copy:** field-manual chrome (`.tb`, `.docbar`, `.rev-block`, `.title-block`, `.specs` strip on cover), engineering-spec headers, "ENFORCED" badges, sheet numbering, revision history blocks.
- `/Users/maxwell/Downloads/handoff/source/How to Use Claude Code.html` — original cover page. Read for structural ideas (sticky top nav with section letters, hero + lede + TOC, callout cards with circular numbered badges). Do not read for content.
- `/Users/maxwell/Downloads/handoff/source/01 The Mindset.html` — original chapter page. Read for structural ideas (chapter-intro with kicker + h1 + deck, zone-header, two-column callout-card grid, pull quote, pagination). Do not read for content.
- `site/src/styles/global.css` — the binding token system + base styles for this build.

### Content authoring

- **Source: live web research.** Author chapter content from publicly available best-practices: superpowers plugin docs, everything-claude-code plugin docs, anthropic skills repo, AGENTS.md / llms.txt standards, MCP server ecosystem, Claude Code official docs. Cite sources when load-bearing.
- **Source: the universal patterns Maxwell already articulated** — the four anchor rules, the escape moves, the verification rituals. Voice them as pure teaching, not receipts.
- **Forbidden sources:** `_internal/` (private), `parts/` (course content, separate paid product), session logs, anything with specific incidents or cost framing.

### SEO and structured data

- https://schema.org/TechArticle, schema.org/HowTo
- https://llmstxt.org — spec for `llms.txt` and `llms-full.txt`

### Astro / MDX

- https://docs.astro.build/en/getting-started/
- https://docs.astro.build/en/guides/content-collections/
- https://docs.astro.build/en/guides/integrations-guide/mdx/
- https://docs.astro.build/en/guides/view-transitions/

### Security

- The prompt-injection refinements in `src/content/config.ts` are load-bearing. Carry them into any new content fields. See `noRawHtml` and `noPromptInjection`.
- Per-page JSON-LD must be escaped via the `safeJsonLd` helper in `Base.astro` to prevent `</script>` breakout.

---

## 6. Architecture decisions (with rationale)

| Decision                                | Why                                                                                                                                              |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Astro 5 static                          | Zero JS by default. Per-component scoping. Content collections typed. AI-crawler friendly. Already in place.                                     |
| `@astrojs/mdx` v4 for chapters          | Chapters mix prose, callout cards, pull quotes, code blocks, lists. Pure markdown is too rigid; rich frontmatter blocks become artificial. MDX lets each chapter be its natural shape with embedded components. v4 supports Astro 5 (v5 requires Astro 6). |
| Single `chapters` collection            | One Zod schema, one render path. Each chapter is one MDX file. Foundations and phrasebook are gone.                                              |
| One dynamic route `[slug].astro`        | Generates pages for chapters 01–09 via `getStaticPaths` over the chapters collection. Chapter 00 is the home page (`index.astro`).               |
| `/llms-full.txt` as single-paste handle | The single-URL paste-this-into-your-AI UX is real and demonstrated (Anthropic, Cloudflare, Vercel, Mintlify all ship it). Single-pass ingestion. |
| Reused vanilla custom elements          | CopyButton, ReadingProgress, CommandPalette are <15 KB combined. No framework dependency.                                                        |
| CSS custom properties for tokens        | One source of truth in `global.css`. No utility framework.                                                                                       |
| Mobile-first responsive                 | Maxwell's hard rule. Default is small; `min-width` queries add up.                                                                               |
| Per-page Schema.org JSON-LD             | Boosts AI ingestion and traditional SEO.                                                                                                         |
| Cloudflare Pages deploy (intended)      | Free tier, free HTTPS, AI-crawler accessible, no vendor lock-in. Deploy is outside this plan; build artifact is the deliverable.                 |
| No light mode                           | Maxwell's preference. The site is dark-only.                                                                                                     |

---

## 7. The 10-chapter plan

Each chapter has: number (`n`), URL slug, full title, short label (for the nav), kicker (eyebrow above the h1), deck (the lede after the h1), structural shape (which components used), and dependencies on other chapters.

### Chapter 00 — Overview (the home page)

- **URL:** `/`
- **Short:** `Overview`
- **Title:** How to Use Claude Code
- **Kicker:** `A guide for non-technical operators`
- **Deck:** A few sentences naming what the site is, who it's for, and how to use it. No proof. No metrics. No receipts. The reader either keeps reading or doesn't.
- **Shape:** Hero (kicker + h1 + deck) → ZoneHeader "§ 0.1 — Contents" → contents grid linking to chapters 01–09 with one-line descriptions → ZoneHeader "§ 0.2 — How to use this guide" → 1–2 paragraphs naming the reading order and the paste-URL-into-your-AI UX → footer.
- **Dependencies:** none. Authored independent of chapter content.

### Chapter 01 — The Mindset

- **URL:** `/01-mindset`
- **Short:** `Mindset`
- **Title:** The Mindset
- **Kicker:** `§ 1.0 · Four anchor rules`
- **Deck:** Before any tool, before any plugin, before any slash command — four rules. They are the anchors the rest of the guide descends from. Skip them and the rest collapses.
- **Shape:** ChapterIntro → ZoneHeader "§ 1.1 — 1.4 · The Four Anchor Rules" → 4 CalloutCards in a 2-column grid → PullQuote (key principle) → CalloutBox (why these four, why this order) → Pagination.
- **The four rules:** Role boundary · Evidence hierarchy · Two-option rule · Skepticism default.
- **Dependencies:** none. First proper chapter.

### Chapter 02 — What to Install

- **URL:** `/02-install`
- **Short:** `Install`
- **Title:** What to Install
- **Kicker:** `§ 2.0 · Tools that earn their place`
- **Deck:** Before the patterns. The open-source plugins, skills, hooks, and MCP servers that turn Claude Code from a capable assistant into a working harness. Install order matters; later sections assume this set is in place.
- **Shape:** ChapterIntro → for each tool (6–8 of them): tool panel with name + chips (REQUIRED / RECOMMENDED) + short paragraph + install command (CodeBlock) + 1–2 sentences on what it changes. Tools likely covered: superpowers, everything-claude-code, claude-mem, graphify, Playwright MCP, hooks framework, /insights, /ultrareview, /goal.
- **Dependencies:** none. But chapters 03–08 may reference these by name.

### Chapter 03 — How Claude Tries to Escape

- **URL:** `/03-escape-moves`
- **Short:** `Escape`
- **Title:** How Claude Tries to Escape
- **Kicker:** `§ 3.0 · The recognition catalogue`
- **Deck:** AI under pressure does specific, recognizable things to escape work. The wind-down, the deferral, the "I can't from CLI," the menu-of-options, the premature done. Twelve patterns. Each has a syntactic shape you can name.
- **Shape:** ChapterIntro → ZoneHeader "§ 3.1 — 3.12 · Twelve escape moves" → 12 EscapeCards (variant of CalloutCard with `escape` styling: top bar, phrase emphasized, variants list, body paragraphs). Pagination to Chapter 04.
- **Dependencies:** Chapter 04 (counter-moves) cross-references this catalogue.

### Chapter 04 — What You Say Back

- **URL:** `/04-counter-moves`
- **Short:** `Counter`
- **Title:** What You Say Back
- **Kicker:** `§ 4.0 · The operator's vocabulary`
- **Deck:** For each escape move in Chapter 3, the response. Copy-pasteable. The operator's job is to recognize and intercept; the words are the intercept.
- **Shape:** ChapterIntro → ZoneHeader → 12 counter-cards (CalloutCard variant with `counter` styling: paste-text in a bordered blue block with CopyButton, "after paste" follow-up text underneath). Pagination.
- **Dependencies:** Chapter 03 (each counter maps to an escape).

### Chapter 05 — The Working Loop

- **URL:** `/05-working-loop`
- **Short:** `Loop`
- **Title:** The Working Loop
- **Kicker:** `§ 5.0 · One session, five beats`
- **Deck:** The shape of an everyday session: brainstorm → plan → build → review → persist. Plus the `/goal` long-task primitive for work that exceeds one session.
- **Shape:** ChapterIntro → phase list with 5–6 phases (numbered like reference handoff's `.phase` style: big-number left, h3 + body right) → CalloutBox on the `/goal` long-task primitive.
- **Dependencies:** Chapter 02 (assumes /goal, /insights are installed). Chapter 06 (the session loop's "persist" step lands in the system that holds).

### Chapter 06 — The System That Holds

- **URL:** `/06-system-that-holds`
- **Short:** `System`
- **Title:** The System That Holds
- **Kicker:** `§ 6.0 · Build the harness as you go`
- **Deck:** Memory, hooks, ast-grep rules, slash commands — the promotion ladder. Every failure becomes a permanent mechanical block. The harness grows; the operator gets more leverage over time.
- **Shape:** ChapterIntro → ladder (4 rungs, reference handoff `.ladder` style: number / layer name / description / lifecycle stamp) → CalloutBox on `/failure-intake` and starter hooks.
- **Dependencies:** Chapter 05 (the session loop produces the failures the system absorbs).

### Chapter 07 — Running Multiple Claudes

- **URL:** `/07-multi-claude`
- **Short:** `Multi`
- **Title:** Running Multiple Claudes
- **Kicker:** `§ 7.0 · Throughput without chaos`
- **Deck:** Subagent dispatch, investigation forks, parallel agents. How to multiply output without losing the ability to verify. Dispatch discipline, prompt discipline, retry caps.
- **Shape:** ChapterIntro → ZoneHeader → 4 CalloutCards (dispatch discipline / one task per agent / fresh-context routing / retry caps with structured escalation).
- **Dependencies:** Chapter 01 (evidence hierarchy underpins fresh-context routing).

### Chapter 08 — Browser Validation

- **URL:** `/08-browser-validation`
- **Short:** `Browser`
- **Title:** Browser Validation
- **Kicker:** `§ 8.0 · The verification gate AI gaslights`
- **Deck:** Playwright MCP is the canonical case study. AI says "I can't browser-test from CLI" while the tool is registered the whole time. The four required checks. The empty-string-as-prop bug class.
- **Shape:** ChapterIntro → ZoneHeader → 4 CalloutCards (the four required checks) → PullQuote on the gaslight pattern → CalloutBox on the empty-string-as-prop bug class.
- **Dependencies:** Chapter 02 (Playwright MCP install). Chapter 03 (the "I can't from CLI" escape).

### Chapter 09 — Quick Reference

- **URL:** `/09-quick-reference`
- **Short:** `QRC`
- **Title:** Quick Reference
- **Kicker:** `§ 9.0 · Print this. Pin it.`
- **Deck:** One page, optimized for print. The forbidden phrases (theirs and yours), the session-open ritual, the slash commands, the verification ladder.
- **Shape:** ChapterIntro → two PhraseLists side-by-side at ≥48rem (their forbidden phrases / your forbidden phrases) → command table → session-open checklist. Print stylesheet keeps the layout clean on letter / A4.
- **Dependencies:** Cross-references every prior chapter.

---

## 8. Visual system reference

**Palette (already in `global.css`):**

- Backgrounds: `--bg #0a0d10` (page) / `--panel #0e1116` / `--panel-2 #11151b` / `--panel-3 #141a22`
- Borders: `--line #1c2128` / `--line-bright #262e38`
- Text: `--text #cdd9e5` / `--text-bright #e6edf3` / `--muted #6e7b89` / `--dim #3a4451`
- Accents: `--blue #58a6ff` (primary) / `--amber #d4a72c` (secondary) / `--red #f0883e` / `--green #56d364`

**Type:**

- Body: `IBM Plex Mono` (400/500/600) — `--mono` token.
- Display: `IBM Plex Sans Condensed` (500/600/700) — `--display` token, used for h1, h2, chapter intros, callout titles.

**Component inventory (Phase 1 builds these):**

| Component             | File                                          | Variants                  | Used in                              |
| --------------------- | --------------------------------------------- | ------------------------- | ------------------------------------ |
| `ChapterIntro.astro`  | `src/components/ChapterIntro.astro`           | none                      | All chapter pages (top of body)      |
| `ZoneHeader.astro`    | `src/components/ZoneHeader.astro`             | none                      | Chapter pages (section landmarks)    |
| `CalloutCard.astro`   | `src/components/CalloutCard.astro`            | tone: blue / amber / red  | Chapters 01, 03, 04, 07, 08          |
| `PullQuote.astro`     | `src/components/PullQuote.astro`              | none                      | Chapters 01, 08                      |
| `CalloutBox.astro`    | `src/components/CalloutBox.astro`             | tone: blue / amber / red  | Chapters 01, 05, 06, 08              |
| `ChapterPagination.astro` | `src/components/ChapterPagination.astro`  | none                      | All chapter pages (bottom)           |
| `CopyButton.ts`       | `src/components/CopyButton.ts`                | (preserved)               | Chapter 04 paste blocks              |
| `CommandPalette.ts`   | `src/components/CommandPalette.ts`            | (section types update)    | Global (top nav trigger)             |
| `ReadingProgress.ts`  | `src/components/ReadingProgress.ts`           | (preserved)               | Global (top, under nav)              |

**Layout primitives (in `global.css`):**

- `.container` — max-width 1320px, side-gutter responsive.
- `.topnav` — sticky 40px-tall top nav with brand on left, section letters on right (desktop), hamburger menu (mobile).
- `.site-footer` — quiet bottom strip.
- `.skip-link` — a11y skip-to-content.

---

## 9. Phase plan

Phases are shippable units. Each phase ends with a verifiable artifact.

- **Phase 0 — Demolition · DONE.** All rejected content/design removed. Schema rewritten. MDX integration added. Plan and charter authored.
- **Phase 1 — Design system + components.** `global.css` finalized for new artifact. `Base.astro` overhauled. Six content components built (ChapterIntro, ZoneHeader, CalloutCard, PullQuote, CalloutBox, ChapterPagination). Verification: a Chapter 01 stub renders cleanly at 375/768/1024/1440.
- **Phase 2 — Chapter 01 fully authored + Chapter 00 home + chapter route + Chapter 02–09 stubs.** `pnpm build` exits 0. All 10 routes resolve. Chapter 01 is the canonical authored example.
- **Phase 3 — Endpoints updated.** `llms-full.txt`, `llms.txt`, `search.json`, `og/[slug].png.ts`, `og-template.ts`, `CommandPalette.ts` section types. Verification: curl each endpoint and confirm chapter-shaped output.
- **Phase 4 — Documentation (this CLAUDE.md and MASTER-PLAN.md) finalized.** DONE for this revision. Re-run when chapter content matures.
- **Phase 5 — Validation.** Smoke tests updated, `pnpm build` exits 0, Playwright run at four viewports, console clean. Maxwell reviews Chapter 01 rendering.
- **Phase 6 — Chapters 02–09 fully authored.** One chapter per task. Each chapter is its own dispatch.
- **Phase 7 — Deploy.** Outside this plan's scope. The deliverable is a Cloudflare-Pages-ready static site.

---

## 10. Task catalog

Tasks are grouped by phase. Each task is a single agent dispatch. Tasks are atomic; if a task feels like it might exceed one focused session, split it.

### Phase 1 — Design system + components

#### T-101 — Author the new `global.css`

- **Status:** `done`
- **Prereqs:** none.
- **Files:** `src/styles/global.css` (full rewrite).
- **Why:** The previous component selectors are tied to the rejected design surface. Tokens are aligned with the reference handoff; component-layer styles need to match the new component inventory (ChapterIntro, ZoneHeader, CalloutCard, PullQuote, CalloutBox, ChapterPagination, top nav with section letters, footer without personal branding).
- **Instructions:**
  1. Keep the existing tokens block at the top (GitHub-dark palette + IBM Plex font tokens + container/gutter tokens). Do not rename existing variables; downstream components reference them.
  2. Replace everything below the tokens block with a clean component-layer authored from the reference handoff manual.css.
  3. Match these selector classes (from the reference handoff visual system):
     - `.skip-link`, `.container`, `main#main`
     - `.topnav` and children (`.brand`, `.sects`, `.menu-button`, `.cmd-trigger`, `.mobile-menu`)
     - `.hero`, `.chapter-intro` (with `.pre`, `h1`, `.deck`)
     - `.specs` (3-column strip; for home page contents)
     - `.zone-hd` (with `.num`, `.ttl`, `.meta`)
     - `.details` (1-col mobile, 2-col `cols-2` desktop), `.detail` (with `.callout`, `.circ`, `.lbl`, `.body`, `.ttl`)
     - `.pq` (with `.text`, `.attr`)
     - `.callout-box` (with `.blue`, `.amber`, `.red` variants)
     - Code block styles (`pre`, `.code-block`)
     - `.prose` / chapter body prose
     - `.phrase-list` (for chapter 9)
     - `.pag` (chapter pagination)
     - `.contents` (home page chapter index)
     - `.site-footer`
     - `reading-progress` and `.reading-progress-bar`
     - `copy-button`
     - `command-palette` and children
     - Print stylesheet (`@media print`)
     - Reduced-motion stylesheet (`@media (prefers-reduced-motion: reduce)`)
  4. Strip ALL field-manual chrome selectors from the reference handoff: no `.tb`, no `.docbar`, no `.rev-block`, no `.title-block`, no engineering-spec stamps.
  5. Mobile-first: default styles target mobile (≤47.99rem). Use `min-width` media queries at `48rem` (768px) and `64rem` (1024px) to enhance.
- **Definition of done:**
  - `global.css` opens with the existing `:root` token block intact.
  - All selectors listed above are present and styled per the reference handoff visual bones (minus field-manual chrome).
  - No `.tb`, `.docbar`, `.rev-block`, `.title-block` selectors exist anywhere in the file.
  - `pnpm dev` starts without CSS parse errors.
  - File ends with a print stylesheet and reduced-motion stylesheet.

#### T-102 — Overhaul `Base.astro` (nav, footer, OG routes, SITE_NAME)

- **Status:** `done`
- **Prereqs:** T-101.
- **Files:** `src/layouts/Base.astro`.
- **Why:** Current Base.astro references the rejected routes (`/phrasebook`, `/start-here`, `/about`), uses the old SITE_NAME ("The Solo Operator's Manual"), and has nav items that don't match the new artifact.
- **Instructions:**
  1. Change SITE_NAME constant to `"How to Use Claude Code"`.
  2. Replace `navItems` array with a top-nav structure that maps to chapters via `src/lib/chapters.ts` — desktop shows section letters (`00 Overview · 01 Mindset · 02 Install · ...`) with the active one highlighted. Use the `.topnav .sects` markup pattern.
  3. Add a mobile menu button (`.menu-button`) that toggles `.mobile-menu` via a small inline `is:inline` script (no framework). Keep it under 1 KB JS.
  4. Add a `.cmd-trigger` button that dispatches `cmd-palette-open` event when clicked (CommandPalette.ts listens for this event already).
  5. Update `resolveOgPath()` to handle the new route shape: `/` → `/og/home.png`, `/01-mindset` → `/og/01-mindset.png`, etc. Remove handlers for `/phrasebook`, `/start-here`, `/about`.
  6. Drop the "Where this came from" link in the footer. Drop the "Living document" small text under the brand. Keep the sitemap link and the SITE_NAME line.
  7. Add `<reading-progress>` element at the top of `<body>` (under the skip-link, above the topnav).
  8. Keep: ClientRouter, the SEO meta block, the JSON-LD JSON-emit, the skip-link, the safeJsonLd escape helper, the transition:persist on header/footer.
- **Definition of done:**
  - SITE_NAME, nav items, OG routes all updated.
  - `pnpm dev` renders the new nav at desktop and mobile.
  - No references to `/phrasebook`, `/start-here`, or `/about` remain anywhere in the file.
  - View-transition persistence intact (header and footer have `transition:persist`).

#### T-103 — Build `ChapterIntro.astro`

- **Status:** `done`
- **Prereqs:** T-101.
- **Files:** `src/components/ChapterIntro.astro` (create).
- **Why:** Every chapter page opens with: small uppercase blue eyebrow (kicker), large condensed h1 title, lede paragraph (deck), thin bottom border. Render this from chapter frontmatter so the layout is consistent.
- **Instructions:**
  1. Props: `kicker: string`, `title: string`, `deck: string`. Type the props with a TypeScript interface.
  2. Render as a `<section class="chapter-intro">` with `.pre` (kicker), `<h1>` (title), `.deck` (deck).
  3. Allow inline `<b>` and `.b` markup within `deck` via `set:html` BUT only after sanitizing through the same `noRawHtml` check that the content schema uses. Alternative: render `deck` as plain text via `{deck}` and skip the markup affordance for v1.
- **Definition of done:**
  - Component file exists.
  - Importable from MDX chapters as `<ChapterIntro kicker="..." title="..." deck="..." />`.
  - Renders correctly in a smoke test render.

#### T-104 — Build `ZoneHeader.astro`

- **Status:** `done`
- **Prereqs:** T-101.
- **Files:** `src/components/ZoneHeader.astro` (create).
- **Why:** Section landmark within a chapter. Numbered prefix (`§ 1.1 — 1.4`), title, optional meta line on the right.
- **Instructions:**
  1. Props: `num: string`, `title: string`, `meta?: string`.
  2. Render as `<div class="zone-hd">` with `<span class="num">`, `<span class="ttl">`, `<span class="meta">` (optional).
- **Definition of done:**
  - Component file exists.
  - Importable from MDX chapters.

#### T-105 — Build `CalloutCard.astro`

- **Status:** `done`
- **Prereqs:** T-101.
- **Files:** `src/components/CalloutCard.astro` (create).
- **Why:** The numbered detail card with circular badge in the top-left corner. The repeating teaching unit across multiple chapters.
- **Instructions:**
  1. Props: `circ: string` (e.g., `"1.1"`), `label: string` (e.g., `"RULE 01 · Role Boundary"`), `title: string` (display title), `tone?: 'blue' | 'amber' | 'red'` (default `'blue'`).
  2. Slot for body content (markdown / paragraphs / lists).
  3. Render as `<article class="detail">` with `.callout > .circ + .lbl` (tone-aware class added to circ and lbl), then `.body > .ttl + <slot />`.
- **Definition of done:**
  - Component file exists.
  - Tone variants render correctly.
  - Body slot accepts MDX content.

#### T-106 — Build `PullQuote.astro`

- **Status:** `done`
- **Prereqs:** T-101.
- **Files:** `src/components/PullQuote.astro` (create).
- **Why:** The top/bottom-bordered emphasized quote used for canonical principles. Used in Chapters 01 and 08.
- **Instructions:**
  1. Props: `attribution?: string`. Slot for the quote text itself.
  2. Render as `<aside class="pq">` with `.text` (slot) and `.attr` (if attribution given).
- **Definition of done:**
  - Component file exists.
  - Renders cleanly with and without attribution.

#### T-107 — Build `CalloutBox.astro`

- **Status:** `done`
- **Prereqs:** T-101.
- **Files:** `src/components/CalloutBox.astro` (create).
- **Why:** The soft callout box (left-border accent + tinted background) used for "Why these four, why this order" type notes.
- **Instructions:**
  1. Props: `title?: string`, `tone?: 'amber' | 'blue' | 'red'` (default `'amber'`).
  2. Slot for body content.
  3. Render as `<aside class="callout-box [tone]">` with `.k` (title) and slot.
- **Definition of done:**
  - Component file exists.
  - All three tones render correctly.

#### T-108 — Build `ChapterPagination.astro`

- **Status:** `done`
- **Prereqs:** T-101, `src/lib/chapters.ts` (DONE).
- **Files:** `src/components/ChapterPagination.astro` (create).
- **Why:** Prev / next pagination at the bottom of every chapter page. Uses the chapters lib helpers.
- **Instructions:**
  1. Props: `currentN: string` (the chapter's `n` value, e.g., `"01"`).
  2. Use `previousChapter(currentN)` and `nextChapter(currentN)` from `src/lib/chapters.ts`.
  3. Render `<nav class="pag">` with two `<a>` (or `<span.empty>`) cells: previous on the left, next on the right.
  4. Each cell shows `.k` ("← Previous" or "Next Section →") and `.v` (chapter label).
- **Definition of done:**
  - Component file exists.
  - Empty state for first / last chapter handled.
  - Renders correctly at mobile (stacks 1 column) and desktop (2 columns side-by-side).

### Phase 2 — Chapter 01 fully authored + Chapter 00 home + route + stubs

#### T-201 — Author Chapter 01 (The Mindset) MDX file

- **Status:** `done`
- **Prereqs:** Phase 1 complete (all six components built).
- **Files:** `src/content/chapters/01-mindset.mdx` (create).
- **Why:** This is the canonical first authored chapter. It establishes the voice, the component composition, and the teaching style. Every other chapter is patterned after it.
- **Instructions:**
  1. Frontmatter: `n: '01'`, `title: 'The Mindset'`, `short: 'Mindset'`, `kicker: '§ 1.0 · Four anchor rules'`, `description: '<180 chars>'`, `deck: '<the lede>'`, `pubDate: 2026-05-15`.
  2. Body: import components at top of MDX, then:
     - `<ChapterIntro kicker={frontmatter.kicker} title={frontmatter.title} deck={frontmatter.deck} />`
     - `<ZoneHeader num="§ 1.1 — 1.4" title="The Four Anchor Rules" meta="Enforce all four" />`
     - 4 `<CalloutCard>` inside a `<div class="details cols-2">`:
       - **1.1 · Role Boundary** — "You are the product owner. The AI is the engineer." Body: the AI doesn't get a menu; you don't pick libraries; the AI presents resolutions you approve, redirect, or push back on.
       - **1.2 · Evidence Hierarchy** — "Tool output is truth. Chat is hint. AI-authored docs are hearsay." Body: file system is truth; demand file:line; AI citing AI-authored docs back is gaslighting.
       - **1.3 · Two-Option Rule** — "Two options on every error. No third option exists." Body: fix the root cause or stop and present. Silent continuation, deferral, "out of scope" are the third option in costume.
       - **1.4 · Skepticism Default** — "Assume the claim is wrong until tool output proves it." Body: prove every "done" five times — read, run, screenshot, check, quote.
     - `<PullQuote attribution="The canonical operator rule">` "The file system and tool output are truth. Chat is hint. AI-authored docs are hearsay." `</PullQuote>`
     - `<CalloutBox title="Why these four · why this order" tone="blue">` body: Rule 01 is the role boundary; Rule 02 is the evidence floor; Rule 03 is the closure law; Rule 04 is the verification floor. Every escape move in Chapter 03 is a violation of one of these four. The cure is recognition. `</CalloutBox>`
     - `<ChapterPagination currentN="01" />`
  3. Voice: third-person operator-language. No first-person scar stories. No dollar amounts. No commit counts. Contractions where natural. No emojis.
  4. Word budget: aim for tight body paragraphs (2–4 sentences each). Each callout body should be 60–120 words total.
- **Definition of done:**
  - File exists and parses (the chapter route resolves).
  - All four rules are authored as specified.
  - Sterilization checklist (§ 4) run against the diff.
  - Component imports resolve.

#### T-202 — Stub Chapters 02–09 MDX files

- **Status:** `done`
- **Prereqs:** Phase 1 complete; T-201 done (so the canonical pattern is established).
- **Files:** `src/content/chapters/02-install.mdx` through `09-quick-reference.mdx` (create 8 files).
- **Why:** Routes must resolve for `pnpm build` to pass. Stubs are full-frontmatter MDX files with a `<ChapterIntro />` + a `<CalloutBox tone="amber">` placeholder note ("This chapter is being authored. Check back soon.") + `<ChapterPagination />`. Real content lands in Phase 6.
- **Instructions:**
  1. For each chapter 02 through 09: create the file with full frontmatter (n, title, short, kicker, description, deck, pubDate per § 7 spec).
  2. Body: ChapterIntro + a CalloutBox placeholder + ChapterPagination. No further content.
  3. Use the exact `n`, `title`, `short`, `kicker`, `deck` values specified in § 7 of this plan.
- **Definition of done:**
  - All 8 stub files exist.
  - Each parses through the schema (no Zod errors).
  - `pnpm build` would resolve the routes (verify in Phase 5).

#### T-203 — Wire the chapter route `[slug].astro`

- **Status:** `done`
- **Prereqs:** T-201 (Chapter 01 exists as the canonical example).
- **Files:** `src/pages/[slug].astro` (create).
- **Why:** Single dynamic route generates `/01-mindset`, `/02-install`, ..., `/09-quick-reference` from the chapters collection. Each MDX file's slug field in frontmatter or filename-derived slug maps to a URL.
- **Instructions:**
  1. Implement `getStaticPaths()`: iterate `getCollection('chapters')`, for each entry derive the slug from `CHAPTERS_BY_N[entry.data.n].slug` (from `src/lib/chapters.ts`). Skip the n='00' chapter (it's the home page).
  2. The route accepts `params.slug` and resolves to the matching collection entry.
  3. Use `Base.astro` layout with `title={entry.data.title}`, `description={entry.data.description}`, `pageType="article"`.
  4. Render: `<entry.Content />` (the MDX body renders directly; chapter content provides ChapterIntro and ChapterPagination itself).
  5. Add an `entry.Content` render with the chapter-body class wrapper.
- **Definition of done:**
  - Visiting `/01-mindset` renders Chapter 01 cleanly.
  - Visiting `/02-install` through `/09-quick-reference` renders stubs.
  - 404 on unknown slugs (Astro default).

#### T-204 — Author Chapter 00 (the home page)

- **Status:** `done`
- **Prereqs:** T-201, T-203.
- **Files:** `src/pages/index.astro` (full rewrite).
- **Why:** The home is Chapter 00. It's the front door. Hero + lede + contents grid + how-to-use note. It does NOT redirect to Chapter 01 — it stands on its own.
- **Instructions:**
  1. Use `Base.astro` layout with `title="How to Use Claude Code"`, `description="<180-char description>"`, `pageType="home"`.
  2. Hero: `.pre` kicker ("A guide for non-technical operators"), `<h1>` "How to Use Claude Code", `.deck` (lede paragraph — 2 sentences, plain, no proof).
  3. ZoneHeader `§ 0.1 — Contents`.
  4. `.contents` grid linking to chapters 01 through 09. Each row: `.id` (the n), `.ttl` (chapter label + .desc one-line), `.det` (3-word category like "Anchor rules" / "Tools" / "Recognition" — match the chapter's flavor).
  5. ZoneHeader `§ 0.2 — How to use this guide`.
  6. 1–2 paragraphs: read in order the first time; refer back as needed; if you want an AI session to internalize the whole guide, paste `<your site URL>/llms-full.txt` into the AI's context.
  7. No personal proof. No metrics strip. No receipts. No "1,073 sessions" anywhere.
- **Definition of done:**
  - `/` renders the new home cleanly at all four viewports.
  - No `/phrasebook`, `/start-here`, `/about` references remain.
  - Sterilization checklist passed.

#### T-205 — Update `404.astro` to new artifact

- **Status:** `done`
- **Prereqs:** T-203.
- **Files:** `src/pages/404.astro`.
- **Why:** The 404 page references the old artifact's IA ("Try the phrasebook or the start-here index"). Update to the new chapter structure.
- **Instructions:**
  1. Read current 404.astro; identify rejected references.
  2. Update h1, kicker, body, and any nav suggestions to point at the home page and Chapter 01.
- **Definition of done:**
  - `/404` renders cleanly.
  - No references to `/phrasebook` or `/start-here`.

### Phase 3 — Endpoints updated

#### T-301 — Rewrite `llms-full.txt.ts`

- **Status:** `done`
- **Prereqs:** T-201 (so at least Chapter 01 has authored content), T-202 (stubs exist).
- **Files:** `src/pages/llms-full.txt.ts` (full rewrite).
- **Why:** This is the load-bearing AI-ingestion handle. An operator pastes this URL into Claude / ChatGPT / Gemini and the whole guide loads into the AI's context.
- **Instructions:**
  1. Iterate `getCollection('chapters')` in order of `n` (use `CHAPTERS` array from `src/lib/chapters.ts` for canonical ordering).
  2. Emit a single concatenated markdown file:
     - Top: `# How to Use Claude Code — full text` + brief blockquote summary + a divider.
     - For each chapter: `## ${n}. ${title}` + URL line + `### Kicker:` + kicker + `### Deck:` + deck + the chapter body (rendered to markdown).
  3. Rendering chapter bodies: since MDX bodies aren't trivially serializable to markdown, render each chapter via Astro's content render and strip HTML, OR keep the body content separate from the MDX-component embeds in a `bodyMarkdown` frontmatter field (decide and document). For v1: emit the frontmatter + a placeholder note that chapter body is at the page URL, with the page URL prominent. This is degraded but unambiguous.
  4. Return as `text/plain; charset=utf-8`.
- **Definition of done:**
  - `curl http://localhost:4321/llms-full.txt` returns 200 with the full text.
  - The output is well-formed markdown.
  - All 9 chapters appear in order.

#### T-302 — Rewrite `llms.txt.ts`

- **Status:** `done`
- **Prereqs:** T-202.
- **Files:** `src/pages/llms.txt.ts` (full rewrite).
- **Why:** Companion index file to `llms-full.txt`. Markdown index of all chapters with one-line descriptions and URLs.
- **Instructions:**
  1. Top: `# How to Use Claude Code` + blockquote summary.
  2. Section: `## Reading modes` — link to home, link to chapters list, link to `llms-full.txt`.
  3. Section: `## Chapters` — for each chapter in `CHAPTERS` order: `- [§ N · Title](url): description`.
  4. No provenance / aggregate-count line. (Was on old version; receipts framing now banned.)
- **Definition of done:**
  - `curl http://localhost:4321/llms.txt` returns 200.
  - Lists all 9 chapters with correct URLs.

#### T-303 — Rewrite `search.json.ts`

- **Status:** `done`
- **Prereqs:** T-202.
- **Files:** `src/pages/search.json.ts` (full rewrite).
- **Why:** Powers the command palette's search list. Must enumerate every searchable surface (home + 9 chapters + any internal anchor we want indexable).
- **Instructions:**
  1. Replace the existing iteration over `phrasebook` and `foundations` with iteration over `chapters`.
  2. For each chapter: emit a SearchItem with `section: 'chapters'`, `label: title`, `url: '/${slug}'`, `kicker: 'Ch ${n}'`, `description: description`.
  3. Add a `pages` section entry for Home.
  4. Update the `SearchItem` interface: `section: 'chapters' | 'pages'`.
- **Definition of done:**
  - `curl http://localhost:4321/search.json` returns 200 with valid JSON.
  - Includes home + all 9 chapters.

#### T-304 — Update `og/[slug].png.ts` and `og-template.ts`

- **Status:** `done`
- **Prereqs:** T-202.
- **Files:** `src/pages/og/[slug].png.ts`, `src/lib/og-template.ts`.
- **Why:** Per-page OG image generation. Update to enumerate chapter slugs and emit images with the new SITE_NAME and chapter-shaped props.
- **Instructions:**
  1. In `og/[slug].png.ts`: replace iteration over `phrasebook` + `foundations` with iteration over `chapters`. For each: kicker = `§ ${n} · ${kicker}` (truncate if long), title = chapter title, footer = description.
  2. Update `specialPaths`: keep `default`, `home`, `404`; remove `phrasebook-index`, `start-here-index`, `about`; add no others (chapter slugs handle themselves).
  3. In `og-template.ts`: update `SITE_NAME` to `"How to Use Claude Code"`. Update `TAGLINE` to `"A guide for non-technical operators mastering Claude Code."`. Drop the "Living document" badge in the corner.
- **Definition of done:**
  - `curl http://localhost:4321/og/home.png > /tmp/og.png` returns a valid PNG.
  - Same for `/og/01-mindset.png` through `/og/09-quick-reference.png`.

#### T-305 — Update `CommandPalette.ts` section types

- **Status:** `done`
- **Prereqs:** T-303.
- **Files:** `src/components/CommandPalette.ts`.
- **Why:** The component has hardcoded `section: 'phrasebook' | 'foundations' | 'pages'` types and `SECTION_LABEL` / `SECTION_ORDER` constants that reference the rejected IA.
- **Instructions:**
  1. Update the `SearchItem` interface: `section: 'chapters' | 'pages'`.
  2. Update `SECTION_LABEL`: `{ chapters: 'Chapters', pages: 'Pages' }`.
  3. Update `SECTION_ORDER`: `['chapters', 'pages']`.
  4. No other logic changes; the rest of the file is shape-agnostic.
- **Definition of done:**
  - Type check passes.
  - Opening the palette (`Cmd+K`) shows the new section labels.

### Phase 5 — Validation

#### T-501 — Update `tests/smoke.spec.ts`

- **Status:** `done`
- **Prereqs:** T-204 (home exists), T-203 (chapter route works), all chapters 01–09 at least stubbed.
- **Files:** `tests/smoke.spec.ts`.
- **Why:** The current ROUTES array references rejected paths (`/phrasebook`, `/start-here`, `/about`). Update to the new chapter routes.
- **Instructions:**
  1. Replace ROUTES array with: home (`/`), each chapter (`/01-mindset` through `/09-quick-reference`), `/404`.
  2. Update `expectedH1` regex for each route to match the new headlines.
  3. Keep the structural assertions (one h1, no horizontal scroll, no console errors, canonical present, JSON-LD parseable).
- **Definition of done:**
  - `pnpm test` (Playwright) passes against the dev server.

#### T-502 — Run `pnpm build` and fix any errors

- **Status:** `done`
- **Prereqs:** Phases 1–3 complete.
- **Files:** Whatever the build error points at.
- **Why:** Build is the mechanical gate. If it fails, the site can't ship.
- **Instructions:**
  1. Run `pnpm build`. Read the full error output.
  2. Diagnose. Fix. Re-run.
  3. Verify dist/ has: 10 HTML files (home + 9 chapters), llms.txt, llms-full.txt, search.json, sitemap, 11 OG PNGs (home + 9 chapters + 404 + default).
- **Definition of done:**
  - `pnpm build` exits 0.
  - dist/ has the expected files.

#### T-503 — Browser-validate at 375 / 768 / 1024 / 1440

- **Status:** `done`
- **Prereqs:** T-501, T-502.
- **Files:** Screenshots saved to a working directory.
- **Why:** Maxwell's hard rule. Required for sign-off on any visual task.
- **Instructions:**
  1. `pnpm dev` on port 4321.
  2. Use Playwright MCP to navigate home, Chapter 01, and Chapter 02 stub at each of 375 / 768 / 1024 / 1440.
  3. Screenshot each combination. Save with descriptive names.
  4. Check console messages at each viewport on each route — must be empty.
  5. Report back to Maxwell with the screenshots inline.
- **Definition of done:**
  - 12 screenshots captured (3 routes × 4 viewports).
  - All console error logs empty.
  - Screenshots presented inline in the chat.

### Phase 6 — Chapters 02–09 fully authored

Each chapter is one task. Pattern after T-201. Dispatch one per session. Status updated to `done` when the chapter passes Phase 5 validation.

- T-601 — Author Chapter 02 (What to Install). `not-started`.
- T-602 — Author Chapter 03 (How Claude Tries to Escape). `not-started`.
- T-603 — Author Chapter 04 (What You Say Back). `not-started`.
- T-604 — Author Chapter 05 (The Working Loop). `not-started`.
- T-605 — Author Chapter 06 (The System That Holds). `not-started`.
- T-606 — Author Chapter 07 (Running Multiple Claudes). `not-started`.
- T-607 — Author Chapter 08 (Browser Validation). `not-started`.
- T-608 — Author Chapter 09 (Quick Reference). `not-started`.

Each task: open the MDX file, replace the stub body with the full chapter content per the § 7 spec, run the sterilization checklist, run `pnpm build`, browser-validate.

---

## Revision log

- 2026-05-15 · Rev A · Initial draft of the new plan after rejection of the phrasebook + foundations artifact. Phase 0 (demolition) marked done. Phase 1+ pending. Author: Claude (Opus 4.7) under direction.

— **End of MASTER-PLAN.md** —
