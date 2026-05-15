import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';
import { CATEGORY_KEYS, FOUNDATION_MOVE_SLUGS } from '../lib/categories';

// Reject any string that looks like it contains a raw HTML tag opener,
// except for the markdown `*italic*` shorthand which uses no angle brackets.
// See security review F-03.
const noRawHtml = (s: string) => !/<[a-zA-Z]/.test(s);

// Reject strings that look like prompt-injection payloads. The site's
// `llms-full.txt` will be ingested by AI sessions; entry bodies must not
// contain instructions that a downstream Claude could mistake for a system
// prompt. See security review §6.
const noPromptInjection = (s: string) =>
  !/^\s*(ignore|forget|disregard|you are now|your new role|new instructions:|system:|assistant:|human:)/i.test(
    s,
  );

const phrasebook = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/phrasebook' }),
  schema: z.object({
    title: z.string().max(120),
    quote: z.string().max(120),
    subtitle: z.string().max(180),
    description: z.string().max(180),
    category: z.enum(CATEGORY_KEYS as [string, ...string[]]),
    appears: z.string().regex(/^~?\d[\d,]* sessions$/),
    categoryTotal: z.string().regex(/^~?\d[\d,]* sessions$/),
    successRate: z
      .string()
      .regex(/^~?\d{1,3}%$/)
      .optional(),
    relatedMove: z
      .object({
        slug: z.enum(FOUNDATION_MOVE_SLUGS as unknown as [string, ...string[]]),
        label: z.string().max(80),
      })
      .optional(),
    hearing: z
      .array(z.string().max(220).refine(noRawHtml, 'No raw HTML tags allowed'))
      .min(2)
      .max(6),
    pasteText: z
      .string()
      .max(800)
      .refine(noRawHtml, 'No raw HTML tags allowed')
      .refine(noPromptInjection, 'Looks like a prompt-injection prefix; rephrase'),
    afterPaste: z
      .string()
      .max(400)
      .refine(noRawHtml, 'No raw HTML tags allowed')
      .refine(noPromptInjection, 'Looks like a prompt-injection prefix; rephrase')
      .optional(),
    whyThisWorks: z
      .array(
        z
          .string()
          .refine(noRawHtml, 'No raw HTML tags allowed')
          .refine(noPromptInjection, 'Looks like a prompt-injection prefix; rephrase'),
      )
      .min(1),
    whereThisCameFrom: z
      .array(
        z
          .string()
          .refine(noRawHtml, 'No raw HTML tags allowed')
          .refine(noPromptInjection, 'Looks like a prompt-injection prefix; rephrase'),
      )
      .min(1),
    pubDate: z.coerce.date(),
    updated: z.coerce.date().optional(),
  }),
});

const foundations = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/foundations' }),
  schema: z.object({
    n: z.string().regex(/^MOVE \/ 0[1-9]$/),
    title: z.string().max(120),
    summary: z.string().max(180),
    description: z.string().max(180),
    pasteExamples: z
      .array(
        z.object({
          label: z.string().max(80),
          text: z
            .string()
            .max(600)
            .refine(noRawHtml, 'No raw HTML tags allowed')
            .refine(noPromptInjection, 'Looks like a prompt-injection prefix; rephrase'),
        }),
      )
      .min(1)
      .max(4),
    relatedPhrasebook: z.array(z.string()).min(1).max(8),
    pubDate: z.coerce.date(),
    updated: z.coerce.date().optional(),
  }),
});

export const collections = { phrasebook, foundations };
