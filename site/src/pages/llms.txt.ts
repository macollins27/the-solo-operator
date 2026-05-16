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
  lines.push('# How to Use Claude Code');
  lines.push('');
  lines.push(
    '> A user-friendly guide for non-technical operators mastering Claude Code through pattern recognition, response vocabulary, and system-building practice.',
  );
  lines.push('');
  lines.push('## Reading modes');
  lines.push('');
  lines.push(`- [Home](${base}/): table of contents and how to use the guide`);
  lines.push(`- Full concatenated text for AI ingestion: ${base}/llms-full.txt`);
  lines.push('');
  lines.push('## Chapters');
  lines.push('');
  for (const meta of CHAPTERS) {
    if (meta.n === '00') continue;
    const entry = byN[meta.n];
    if (!entry) continue;
    lines.push(`- [§ ${meta.n} · ${entry.data.title}](${base}/${meta.slug}): ${entry.data.description}`);
  }

  return new Response(lines.join('\n'), {
    status: 200,
    headers: { 'Content-Type': 'text/plain; charset=utf-8' },
  });
};
