import type { APIRoute, GetStaticPaths } from 'astro';
import { getCollection, type CollectionEntry } from 'astro:content';
import { renderOg } from '../../lib/og-template';
import { CATEGORIES, type CategoryKey } from '../../lib/categories';

interface OgPathProps {
  kicker: string;
  title: string;
  footer?: string;
}

export const getStaticPaths: GetStaticPaths = async () => {
  const [phrasebook, foundations] = await Promise.all([
    getCollection('phrasebook'),
    getCollection('foundations'),
  ]);

  const phrasebookPaths = phrasebook.map((entry: CollectionEntry<'phrasebook'>) => {
    const cat = CATEGORIES[entry.data.category as CategoryKey];
    return {
      params: { slug: entry.id },
      props: {
        kicker: `Phrasebook · ${cat.label}`,
        title: `"${entry.data.quote}"`,
        footer: entry.data.subtitle,
      } satisfies OgPathProps,
    };
  });

  const foundationPaths = foundations.map((entry: CollectionEntry<'foundations'>) => ({
    params: { slug: entry.id },
    props: {
      kicker: entry.data.n,
      title: entry.data.title,
      footer: entry.data.summary,
    } satisfies OgPathProps,
  }));

  const specialPaths: { params: { slug: string }; props: OgPathProps }[] = [
    {
      params: { slug: 'default' },
      props: {
        kicker: 'The Solo Operator’s Manual',
        title: 'How to talk to your AI agent when it gets stubborn.',
      },
    },
    {
      params: { slug: 'home' },
      props: {
        kicker: 'The Solo Operator’s Manual',
        title: 'How to talk to your AI agent when it gets stubborn.',
      },
    },
    {
      params: { slug: 'phrasebook-index' },
      props: {
        kicker: 'The Phrasebook',
        title: '13 patterns. The exact words to say back.',
        footer: 'Recognize the agent’s phrase. Paste the intervention. Verify the result.',
      },
    },
    {
      params: { slug: 'start-here-index' },
      props: {
        kicker: 'Start Here',
        title: 'Five foundation moves before any phrase works.',
        footer: 'The mental model the phrasebook leans on.',
      },
    },
    {
      params: { slug: 'about' },
      props: {
        kicker: 'About',
        title: 'Where this came from.',
        footer: 'A thousand sessions. A notebook of patterns. The manual is the receipt.',
      },
    },
    {
      params: { slug: '404' },
      props: {
        kicker: '404',
        title: 'That page doesn’t exist.',
        footer: 'Try the phrasebook or the start-here index.',
      },
    },
  ];

  return [...phrasebookPaths, ...foundationPaths, ...specialPaths];
};

export const GET: APIRoute<OgPathProps> = async ({ props }) => {
  const png = await renderOg({
    kicker: props.kicker,
    title: props.title,
    footer: props.footer,
  });
  return new Response(png as unknown as BodyInit, {
    headers: {
      'Content-Type': 'image/png',
      'Cache-Control': 'public, max-age=31536000, immutable',
    },
  });
};
