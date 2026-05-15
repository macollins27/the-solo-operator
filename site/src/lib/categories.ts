// Single source of truth for phrasebook category metadata.
// The Zod schema in src/content/config.ts enforces that frontmatter `category`
// is one of these keys; the lookup here supplies the display label and number.
// Updating CATEGORIES requires updating the Zod enum in config.ts.

export const CATEGORIES = {
  'giving-up': { number: '01', label: "It's giving up before trying" },
  'done-before-done': { number: '02', label: "It's saying done before it's done" },
  'handing-back': { number: '03', label: "It's handing decisions back to you" },
  'making-up': { number: '04', label: "It's quietly making things up" },
} as const;

export type CategoryKey = keyof typeof CATEGORIES;
export const CATEGORY_KEYS = Object.keys(CATEGORIES) as CategoryKey[];

export const FOUNDATION_MOVE_SLUGS = [
  'ai-is-the-engineer',
  'refuse-the-menu',
  'verify-the-artifact',
  'push-back-on-i-cant',
  'make-recurring-mistakes-mechanical',
] as const;
export type FoundationMoveSlug = (typeof FOUNDATION_MOVE_SLUGS)[number];
