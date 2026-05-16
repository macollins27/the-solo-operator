import type { APIRoute } from 'astro';
import { getCollection, type CollectionEntry } from 'astro:content';
import { CHAPTERS } from '../lib/chapters';

interface SearchItem {
  section: 'chapters' | 'pages';
  label: string;
  url: string;
  kicker: string;
  description: string;
}

export const GET: APIRoute = async () => {
  const chapters: CollectionEntry<'chapters'>[] = await getCollection('chapters');
  const byN: Record<string, CollectionEntry<'chapters'>> = Object.fromEntries(
    chapters.map((c) => [c.data.n, c]),
  );

  const items: SearchItem[] = [];

  for (const meta of CHAPTERS) {
    if (meta.n === '00') continue;
    const entry = byN[meta.n];
    if (!entry) continue;
    items.push({
      section: 'chapters',
      label: entry.data.title,
      url: `/${meta.slug}`,
      kicker: `Ch ${meta.n}`,
      description: entry.data.description,
    });
  }

  const pages: SearchItem[] = [
    {
      section: 'pages',
      label: 'Home',
      url: '/',
      kicker: 'PAGE',
      description: 'Overview, contents, how to use the guide.',
    },
    {
      section: 'pages',
      label: 'llms-full.txt',
      url: '/llms-full.txt',
      kicker: 'PAGE',
      description: 'Single-paste ingestion of the entire guide for AI sessions.',
    },
  ];

  items.push(...pages);

  return new Response(JSON.stringify(items), {
    status: 200,
    headers: { 'Content-Type': 'application/json; charset=utf-8' },
  });
};
