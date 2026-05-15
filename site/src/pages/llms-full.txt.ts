import type { APIRoute } from 'astro';
import { getCollection, type CollectionEntry } from 'astro:content';
import { CATEGORIES, type CategoryKey } from '../lib/categories';

export const GET: APIRoute = async ({ site }) => {
  const base = site?.toString().replace(/\/$/, '') ?? '';
  const phrasebook: CollectionEntry<'phrasebook'>[] = await getCollection('phrasebook');
  const foundations: CollectionEntry<'foundations'>[] = await getCollection('foundations');

  const lines: string[] = [];
  lines.push("# The Solo Operator's Manual — full text");
  lines.push('');
  lines.push(
    '> A phrasebook for non-technical operators who build real software with AI agents. Every entry below is the full, sterilized body of one phrasebook entry or foundation move.',
  );
  lines.push('');
  lines.push(
    'Provenance: distilled from 1,073 working sessions across 46 projects. Aggregate counts only — no client, project, or session identifiers are retained. Refreshed monthly.',
  );
  lines.push('');
  lines.push('---');
  lines.push('');

  lines.push('## Foundation moves');
  lines.push('');
  for (const move of foundations.sort((a, b) => a.data.n.localeCompare(b.data.n))) {
    lines.push(`### ${move.data.n} — ${move.data.title}`);
    lines.push('');
    lines.push(`URL: ${base}/start-here/${move.id}`);
    lines.push('');
    lines.push(`Summary: ${move.data.summary}`);
    lines.push('');
    lines.push(`Body:`);
    lines.push('');
    lines.push(move.body ?? '');
    lines.push('');
    lines.push('Paste-ready phrasings:');
    for (const ex of move.data.pasteExamples) {
      lines.push(`- _${ex.label}:_`);
      lines.push('');
      for (const line of ex.text.trim().split('\n')) {
        lines.push(`  > ${line}`);
      }
      lines.push('');
    }
    lines.push('---');
    lines.push('');
  }

  lines.push('## Phrasebook entries');
  lines.push('');
  for (const entry of phrasebook) {
    const cat = CATEGORIES[entry.data.category as CategoryKey];
    lines.push(`### ${entry.data.title}`);
    lines.push('');
    lines.push(`URL: ${base}/phrasebook/${entry.id}`);
    lines.push(`Category: ${cat.number} — ${cat.label}`);
    lines.push(`Appears in: ${entry.data.appears} (category total: ${entry.data.categoryTotal})`);
    lines.push('');
    lines.push(`Subtitle: ${entry.data.subtitle}`);
    lines.push('');
    lines.push("What you're hearing:");
    for (const h of entry.data.hearing) lines.push(`- "${h}"`);
    lines.push('');
    lines.push('What to say back:');
    lines.push('');
    for (const line of entry.data.pasteText.trim().split('\n')) lines.push(`  > ${line}`);
    lines.push('');
    if (entry.data.afterPaste) {
      lines.push('After paste:');
      lines.push(`> ${entry.data.afterPaste.trim().replace(/\n/g, ' ')}`);
      lines.push('');
    }
    lines.push('Why this works:');
    for (const p of entry.data.whyThisWorks) {
      lines.push(`- ${p}`);
      lines.push('');
    }
    lines.push('Where this came from:');
    for (const p of entry.data.whereThisCameFrom) {
      lines.push(`- ${p}`);
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
