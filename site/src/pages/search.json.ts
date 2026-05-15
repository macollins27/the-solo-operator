import type { APIRoute } from 'astro';
import { getCollection, type CollectionEntry } from 'astro:content';
import { CATEGORIES, type CategoryKey } from '../lib/categories';

interface SearchItem {
  section: 'phrasebook' | 'foundations' | 'pages';
  label: string;
  url: string;
  kicker: string;
  description: string;
}

export const GET: APIRoute = async () => {
  const phrasebook: CollectionEntry<'phrasebook'>[] = await getCollection('phrasebook');
  const foundations: CollectionEntry<'foundations'>[] = await getCollection('foundations');

  const items: SearchItem[] = [];

  for (const entry of phrasebook) {
    const cat = CATEGORIES[entry.data.category as CategoryKey];
    items.push({
      section: 'phrasebook',
      label: entry.data.quote,
      url: `/phrasebook/${entry.id}`,
      kicker: cat.number,
      description: cat.label,
    });
  }

  for (const move of foundations.sort((a, b) => a.data.n.localeCompare(b.data.n))) {
    items.push({
      section: 'foundations',
      label: move.data.title,
      url: `/start-here/${move.id}`,
      kicker: move.data.n.replace('MOVE / ', ''),
      description: move.data.summary,
    });
  }

  const pages: SearchItem[] = [
    {
      section: 'pages',
      label: 'Home',
      url: '/',
      kicker: 'PAGE',
      description: 'When your agent misbehaves, say this.',
    },
    {
      section: 'pages',
      label: 'The Phrasebook',
      url: '/phrasebook',
      kicker: 'PAGE',
      description: 'What is your agent doing right now?',
    },
    {
      section: 'pages',
      label: 'Start Here',
      url: '/start-here',
      kicker: 'PAGE',
      description: 'Five foundational moves before you need the phrasebook.',
    },
    {
      section: 'pages',
      label: 'About',
      url: '/about',
      kicker: 'PAGE',
      description: 'Where this came from.',
    },
  ];

  items.push(...pages);

  return new Response(JSON.stringify(items), {
    status: 200,
    headers: { 'Content-Type': 'application/json; charset=utf-8' },
  });
};
