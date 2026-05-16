// Single source of truth for chapter metadata.
// The Zod schema in src/content/config.ts enforces frontmatter `n` against
// CHAPTER_SLUGS; the lookup here supplies the display label, short label
// for the nav, and order.
//
// Chapter 00 (Overview) is the home page at "/" and is not authored as a
// chapter MDX file; chapters 01–09 are. Changes here must be mirrored in
// the chapter MDX frontmatter and the navigation lookups.

export interface Chapter {
  n: string;
  short: string;
  label: string;
  slug: string;
}

export const CHAPTERS: readonly Chapter[] = [
  { n: '00', short: 'Overview', label: 'Overview', slug: '' },
  { n: '01', short: 'Mindset', label: 'The Mindset', slug: '01-mindset' },
  { n: '02', short: 'Install', label: 'What to Install', slug: '02-install' },
  { n: '03', short: 'Escape', label: 'How Claude Tries to Escape', slug: '03-escape-moves' },
  { n: '04', short: 'Counter', label: 'What You Say Back', slug: '04-counter-moves' },
  { n: '05', short: 'Loop', label: 'The Working Loop', slug: '05-working-loop' },
  { n: '06', short: 'System', label: 'The System That Holds', slug: '06-system-that-holds' },
  { n: '07', short: 'Multi', label: 'Running Multiple Claudes', slug: '07-multi-claude' },
  { n: '08', short: 'Browser', label: 'Browser Validation', slug: '08-browser-validation' },
  { n: '09', short: 'QRC', label: 'Quick Reference', slug: '09-quick-reference' },
] as const;

export const CHAPTER_SLUGS = CHAPTERS.map((c) => c.n);

export const CHAPTERS_BY_N: Record<string, Chapter> = Object.fromEntries(
  CHAPTERS.map((c) => [c.n, c]),
);

export function chapterByN(n: string): Chapter | undefined {
  return CHAPTERS_BY_N[n];
}

export function previousChapter(n: string): Chapter | undefined {
  const i = CHAPTERS.findIndex((c) => c.n === n);
  return i > 0 ? CHAPTERS[i - 1] : undefined;
}

export function nextChapter(n: string): Chapter | undefined {
  const i = CHAPTERS.findIndex((c) => c.n === n);
  return i >= 0 && i < CHAPTERS.length - 1 ? CHAPTERS[i + 1] : undefined;
}
