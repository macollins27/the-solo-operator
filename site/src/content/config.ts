import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';
import { CHAPTER_SLUGS } from '../lib/chapters';

// Reject any string that looks like it contains a raw HTML tag opener,
// except for the markdown `*italic*` shorthand which uses no angle brackets.
// Carried over from the previous schema's security review F-03.
const noRawHtml = (s: string): boolean => !/<[a-zA-Z]/.test(s);

// Reject strings that look like prompt-injection payloads. The site's
// `llms-full.txt` is ingested by AI sessions; entry bodies must not
// contain instructions a downstream Claude could mistake for a system
// prompt. Carried over from the previous schema's security review §6.
const noPromptInjection = (s: string): boolean =>
  !/^\s*(ignore|forget|disregard|you are now|your new role|new instructions:|system:|assistant:|human:)/i.test(
    s,
  );

const chapters = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/chapters' }),
  schema: z.object({
    n: z.enum(CHAPTER_SLUGS as unknown as [string, ...string[]]),
    title: z
      .string()
      .max(120)
      .refine(noRawHtml, 'No raw HTML tags allowed')
      .refine(noPromptInjection, 'Looks like a prompt-injection prefix; rephrase'),
    short: z.string().max(24),
    kicker: z
      .string()
      .max(80)
      .refine(noRawHtml, 'No raw HTML tags allowed')
      .refine(noPromptInjection, 'Looks like a prompt-injection prefix; rephrase'),
    description: z
      .string()
      .max(200)
      .refine(noRawHtml, 'No raw HTML tags allowed')
      .refine(noPromptInjection, 'Looks like a prompt-injection prefix; rephrase'),
    deck: z
      .string()
      .max(600)
      .refine(noRawHtml, 'No raw HTML tags allowed')
      .refine(noPromptInjection, 'Looks like a prompt-injection prefix; rephrase'),
    pubDate: z.coerce.date(),
    updated: z.coerce.date().optional(),
  }),
});

export const collections = { chapters };
