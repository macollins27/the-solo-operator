import type { APIRoute } from 'astro';
import { getCollection, type CollectionEntry } from 'astro:content';
import { CHAPTERS } from '../lib/chapters';

export const GET: APIRoute = async ({ site }) => {
  const base = site?.toString().replace(/\/$/, '') ?? '';
  const chapters: CollectionEntry<'chapters'>[] = await getCollection('chapters');
  const byN: Record<string, CollectionEntry<'chapters'>> = Object.fromEntries(
    chapters.map((c) => [c.data.n, c]),
  );

  const lines: string[] = [];
  lines.push('# How to Use Claude Code — full text');
  lines.push('');
  lines.push(
    '> A user-friendly guide for non-technical operators mastering Claude Code through pattern recognition, response vocabulary, and system-building practice. Paste this URL into any AI session for single-pass ingestion of the entire guide.',
  );
  lines.push('');
  lines.push('---');
  lines.push('');

  for (const meta of CHAPTERS) {
    if (meta.n === '00') continue;
    const entry = byN[meta.n];
    if (!entry) continue;

    const url = `${base}/${meta.slug}`;
    lines.push(`## ${meta.n}. ${entry.data.title}`);
    lines.push('');
    lines.push(`URL: ${url}`);
    lines.push('');
    lines.push(`Kicker: ${entry.data.kicker}`);
    lines.push('');
    lines.push(`Lede: ${entry.data.deck}`);
    lines.push('');
    if (entry.body) {
      lines.push('Body:');
      lines.push('');
      // Strip MDX-specific component imports and JSX-only lines for clean
      // ingestion. Keep markdown prose and inline tags. Lossy by design —
      // the canonical view of body content is the rendered chapter page.
      const cleaned = entry.body
        .replace(/^---[\s\S]*?---\n/, '')
        .replace(/^import\s+.*from\s+['"][^'"]+['"];?\s*$/gm, '')
        .replace(/<[A-Z][^>]*\/>/g, '')
        .replace(/<\/?[A-Z][^>]*>/g, '')
        .replace(/^\s*\n\s*\n+/gm, '\n\n')
        .trim();
      lines.push(cleaned);
      lines.push('');
    }
    lines.push('---');
    lines.push('');
  }

  return new Response(lines.join('\n'), {
    status: 200,
    headers: { 'Content-Type': 'text/plain; charset=utf-8' },
  });
};
