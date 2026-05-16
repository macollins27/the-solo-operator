import { readFile } from 'node:fs/promises';
import { createRequire } from 'node:module';
import { dirname, join } from 'node:path';
import satori from 'satori';
import { Resvg } from '@resvg/resvg-js';

const require = createRequire(import.meta.url);

function fontPath(pkg: string, filename: string): string {
  const pkgJson = require.resolve(`${pkg}/package.json`);
  return join(dirname(pkgJson), 'files', filename);
}

const FONT_PATHS = {
  condensed700: fontPath(
    '@fontsource/ibm-plex-sans-condensed',
    'ibm-plex-sans-condensed-latin-700-normal.woff',
  ),
  condensed600: fontPath(
    '@fontsource/ibm-plex-sans-condensed',
    'ibm-plex-sans-condensed-latin-600-normal.woff',
  ),
  mono500: fontPath('@fontsource/ibm-plex-mono', 'ibm-plex-mono-latin-500-normal.woff'),
  mono400: fontPath('@fontsource/ibm-plex-mono', 'ibm-plex-mono-latin-400-normal.woff'),
} as const;

let cachedFonts: Awaited<ReturnType<typeof loadFontsImpl>> | null = null;

async function loadFontsImpl() {
  const [condensed700, condensed600, mono500, mono400] = await Promise.all([
    readFile(FONT_PATHS.condensed700),
    readFile(FONT_PATHS.condensed600),
    readFile(FONT_PATHS.mono500),
    readFile(FONT_PATHS.mono400),
  ]);
  return { condensed700, condensed600, mono500, mono400 };
}

async function loadFonts() {
  if (!cachedFonts) cachedFonts = await loadFontsImpl();
  return cachedFonts;
}

export interface OgOptions {
  kicker: string;
  title: string;
  footer?: string;
}

const WIDTH = 1200;
const HEIGHT = 630;
const SITE_NAME = 'How to Use Claude Code';
const TAGLINE = 'A guide for non-technical operators mastering Claude Code.';

const COLOR_BG = '#0a0d10';
const COLOR_LINE = '#1b2027';
const COLOR_BLUE = '#4a8ce8';
const COLOR_FG = '#e7eef6';
const COLOR_MUTED = '#7a8693';

function pickTitleSize(title: string): number {
  const length = title.length;
  if (length <= 28) return 96;
  if (length <= 48) return 84;
  if (length <= 72) return 72;
  if (length <= 100) return 60;
  return 52;
}

export async function renderOg(opts: OgOptions): Promise<Uint8Array> {
  const fonts = await loadFonts();
  const titleSize = pickTitleSize(opts.title);

  const tree = {
    type: 'div',
    props: {
      style: {
        width: WIDTH,
        height: HEIGHT,
        display: 'flex',
        flexDirection: 'column',
        backgroundColor: COLOR_BG,
        backgroundImage: `linear-gradient(${COLOR_LINE} 1px, transparent 1px), linear-gradient(90deg, ${COLOR_LINE} 1px, transparent 1px)`,
        backgroundSize: '48px 48px, 48px 48px',
        backgroundPosition: '-1px -1px, -1px -1px',
        padding: '64px 80px',
        fontFamily: 'PlexCondensed, sans-serif',
        color: COLOR_FG,
        position: 'relative',
      },
      children: [
        {
          type: 'div',
          props: {
            style: {
              position: 'absolute',
              top: 0,
              left: 0,
              right: 0,
              height: 6,
              backgroundColor: COLOR_BLUE,
              display: 'flex',
            },
          },
        },
        {
          type: 'div',
          props: {
            style: {
              display: 'flex',
              flexDirection: 'row',
              alignItems: 'center',
              fontFamily: 'PlexMono, monospace',
              fontSize: 22,
              letterSpacing: 2,
              color: COLOR_BLUE,
              textTransform: 'uppercase',
            },
            children: opts.kicker,
          },
        },
        {
          type: 'div',
          props: {
            style: {
              marginTop: 32,
              display: 'flex',
              flexDirection: 'column',
              flexGrow: 1,
              justifyContent: 'center',
            },
            children: [
              {
                type: 'div',
                props: {
                  style: {
                    fontFamily: 'PlexCondensed, sans-serif',
                    fontWeight: 700,
                    fontSize: titleSize,
                    lineHeight: 1.05,
                    letterSpacing: -1,
                    color: COLOR_FG,
                    display: 'flex',
                  },
                  children: opts.title,
                },
              },
            ],
          },
        },
        {
          type: 'div',
          props: {
            style: {
              display: 'flex',
              flexDirection: 'row',
              alignItems: 'flex-end',
              justifyContent: 'space-between',
              borderTop: `1px solid ${COLOR_LINE}`,
              paddingTop: 24,
              fontFamily: 'PlexMono, monospace',
            },
            children: [
              {
                type: 'div',
                props: {
                  style: {
                    display: 'flex',
                    flexDirection: 'column',
                  },
                  children: [
                    {
                      type: 'div',
                      props: {
                        style: {
                          fontSize: 24,
                          fontWeight: 500,
                          color: COLOR_FG,
                          display: 'flex',
                        },
                        children: SITE_NAME,
                      },
                    },
                    {
                      type: 'div',
                      props: {
                        style: {
                          marginTop: 8,
                          fontSize: 16,
                          color: COLOR_MUTED,
                          display: 'flex',
                          maxWidth: 760,
                        },
                        children: opts.footer ?? TAGLINE,
                      },
                    },
                  ],
                },
              },
            ],
          },
        },
      ],
    },
  };

  const svg = await satori(tree as Parameters<typeof satori>[0], {
    width: WIDTH,
    height: HEIGHT,
    fonts: [
      { name: 'PlexCondensed', data: fonts.condensed700, weight: 700, style: 'normal' },
      { name: 'PlexCondensed', data: fonts.condensed600, weight: 600, style: 'normal' },
      { name: 'PlexMono', data: fonts.mono500, weight: 500, style: 'normal' },
      { name: 'PlexMono', data: fonts.mono400, weight: 400, style: 'normal' },
    ],
  });

  const png = new Resvg(svg, {
    fitTo: { mode: 'width', value: WIDTH },
    background: COLOR_BG,
  })
    .render()
    .asPng();

  return png;
}
