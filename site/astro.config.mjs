import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import mdx from '@astrojs/mdx';
import fontPreload from './src/integrations/font-preload.ts';

export default defineConfig({
  site: 'https://how-to-use-claude-code.example',
  output: 'static',
  trailingSlash: 'never',
  build: { format: 'file' },
  integrations: [
    mdx(),
    sitemap({
      changefreq: 'monthly',
      priority: 0.8,
      lastmod: new Date(),
    }),
    fontPreload(),
  ],
  vite: {
    css: { devSourcemap: false },
  },
  prefetch: { defaultStrategy: 'viewport' },
});
