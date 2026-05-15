import type { AstroIntegration } from 'astro';
import { readdir, readFile, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';

const PRELOAD_PATTERNS = [
  /^ibm-plex-sans-condensed-latin-700-normal\..+\.woff2$/,
  /^ibm-plex-sans-condensed-latin-600-normal\..+\.woff2$/,
  /^ibm-plex-mono-latin-400-normal\..+\.woff2$/,
];

const PRELOAD_MARKER = '<!-- font-preload-injected -->';

async function walkHtmlFiles(dir: string): Promise<string[]> {
  const entries = await readdir(dir, { withFileTypes: true });
  const results: string[] = [];
  for (const entry of entries) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...(await walkHtmlFiles(full)));
    } else if (entry.isFile() && entry.name.endsWith('.html')) {
      results.push(full);
    }
  }
  return results;
}

export default function fontPreload(): AstroIntegration {
  return {
    name: 'font-preload',
    hooks: {
      'astro:build:done': async ({ dir, logger }) => {
        const distDir = fileURLToPath(dir);
        const astroDir = join(distDir, '_astro');

        let astroEntries: string[];
        try {
          astroEntries = await readdir(astroDir);
        } catch {
          logger.warn('no _astro directory; skipping font preload injection');
          return;
        }

        const preloadHrefs: string[] = [];
        for (const pattern of PRELOAD_PATTERNS) {
          const match = astroEntries.find((name) => pattern.test(name));
          if (!match) {
            logger.warn(`no built font matches ${pattern}; preload skipped for this weight`);
            continue;
          }
          preloadHrefs.push(`/_astro/${match}`);
        }

        if (preloadHrefs.length === 0) {
          logger.warn('no font assets found to preload');
          return;
        }

        const preloadTags =
          preloadHrefs
            .map(
              (href) =>
                `<link rel="preload" as="font" type="font/woff2" href="${href}" crossorigin="anonymous">`,
            )
            .join('') + PRELOAD_MARKER;

        const htmlFiles = await walkHtmlFiles(distDir);
        let injected = 0;
        for (const file of htmlFiles) {
          const html = await readFile(file, 'utf8');
          if (html.includes(PRELOAD_MARKER)) continue;
          const next = html.replace('</head>', `${preloadTags}</head>`);
          if (next === html) continue;
          await writeFile(file, next, 'utf8');
          injected += 1;
        }

        logger.info(
          `font-preload: injected ${preloadHrefs.length} preload tag(s) into ${injected} HTML file(s)`,
        );
      },
    },
  };
}
