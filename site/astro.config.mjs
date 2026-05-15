import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import fontPreload from './src/integrations/font-preload.ts';

export default defineConfig({
  site: 'https://solo-operator.example',
  output: 'static',
  trailingSlash: 'never',
  build: { format: 'file' },
  integrations: [
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
