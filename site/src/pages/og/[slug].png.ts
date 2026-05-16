import type { APIRoute, GetStaticPaths } from 'astro';
import { getCollection, type CollectionEntry } from 'astro:content';
import { renderOg } from '../../lib/og-template';
import { CHAPTERS_BY_N } from '../../lib/chapters';

interface OgPathProps {
  kicker: string;
  title: string;
  footer?: string;
}

export const getStaticPaths: GetStaticPaths = async () => {
  const chapters = await getCollection('chapters');

  const chapterPaths = chapters
    .filter((entry: CollectionEntry<'chapters'>) => entry.data.n !== '00')
    .map((entry: CollectionEntry<'chapters'>) => {
      const meta = CHAPTERS_BY_N[entry.data.n];
      return {
        params: { slug: meta.slug },
        props: {
          kicker: `§ ${entry.data.n} · ${meta.label}`,
          title: entry.data.title,
          footer: entry.data.description,
        } satisfies OgPathProps,
      };
    });

  const specialPaths: { params: { slug: string }; props: OgPathProps }[] = [
    {
      params: { slug: 'default' },
      props: {
        kicker: 'How to Use Claude Code',
        title: 'A guide for non-technical operators.',
      },
    },
    {
      params: { slug: 'home' },
      props: {
        kicker: 'How to Use Claude Code',
        title: 'A guide for non-technical operators.',
        footer: 'Pattern recognition, response vocabulary, system-building practice.',
      },
    },
    {
      params: { slug: '404' },
      props: {
        kicker: '404',
        title: "That page isn't here.",
        footer: 'Try the home page or Chapter 01.',
      },
    },
  ];

  return [...chapterPaths, ...specialPaths];
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
