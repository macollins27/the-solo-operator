import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: process.env.CI ? 'github' : 'list',
  use: {
    baseURL: 'http://localhost:4321',
    trace: 'on-first-retry',
  },
  projects: [
    // All four viewports run on Chromium so a single browser install satisfies
    // local and CI. iPhone/iPad device profiles default to WebKit and add an
    // install/maintenance cost the smoke suite doesn't need.
    {
      name: 'mobile-375',
      use: { ...devices['Desktop Chrome'], viewport: { width: 375, height: 812 } },
    },
    {
      name: 'tablet-768',
      use: { ...devices['Desktop Chrome'], viewport: { width: 768, height: 1024 } },
    },
    {
      name: 'desktop-1024',
      use: { ...devices['Desktop Chrome'], viewport: { width: 1024, height: 768 } },
    },
    {
      name: 'desktop-1440',
      use: { ...devices['Desktop Chrome'], viewport: { width: 1440, height: 900 } },
    },
  ],
  // Smoke tests run against the production build so the sitemap, hashed
  // assets, font-preload tags, and OG generator output match what ships.
  // dev-only artifacts (missing sitemap-index.xml, source maps) would
  // otherwise pollute the console-error gate.
  // Smoke tests run against the production build served by `serve` (not
  // astro preview, which 404s on XML routes because of trailingSlash:never +
  // build:format:'file'). serve mirrors Cloudflare Pages static behavior.
  webServer: {
    command: 'pnpm build && pnpm exec serve dist -l 4321 --no-clipboard --no-request-logging',
    url: 'http://localhost:4321',
    reuseExistingServer: !process.env.CI,
    timeout: 180000,
  },
});
