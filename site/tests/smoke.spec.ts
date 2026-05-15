import { test, expect } from '@playwright/test';

const ROUTES = [
  { path: '/', expectedH1: /When your agent/ },
  { path: '/phrasebook', expectedH1: /What is your agent doing/ },
  { path: '/phrasebook/paid-service-claim', expectedH1: /Your agent says/ },
  { path: '/start-here', expectedH1: /Five moves before anything else/ },
  { path: '/about', expectedH1: /Where this came from/ },
  { path: '/404', expectedH1: /That page isn't here/ },
];

for (const route of ROUTES) {
  test.describe(`route: ${route.path}`, () => {
    test('renders cleanly with one h1, valid title, no horizontal scroll, no console errors', async ({
      page,
    }) => {
      const errors: string[] = [];
      page.on('pageerror', (err) => errors.push(err.message));
      page.on('console', (msg) => {
        if (msg.type() === 'error') errors.push(msg.text());
      });

      const response = await page.goto(route.path);
      // 404 page is rendered statically and returns 404 by Astro convention; accept both.
      const status = response?.status() ?? 0;
      expect(status === 200 || status === 404).toBeTruthy();

      const title = await page.title();
      expect(title.length).toBeGreaterThan(0);

      const h1s = await page.locator('h1').all();
      expect(h1s).toHaveLength(1);
      const h1Text = (await h1s[0].textContent()) ?? '';
      expect(h1Text).toMatch(route.expectedH1);

      const scrollWidth = await page.evaluate(() => document.documentElement.scrollWidth);
      const clientWidth = await page.evaluate(() => document.documentElement.clientWidth);
      expect(scrollWidth).toBeLessThanOrEqual(clientWidth + 1);

      expect(errors, `console errors on ${route.path}: ${errors.join('; ')}`).toHaveLength(0);
    });
  });
}

test('canonical URL is present on every page', async ({ page }) => {
  for (const route of ROUTES.filter((r) => r.path !== '/404')) {
    await page.goto(route.path);
    const canonical = await page.locator('link[rel="canonical"]').getAttribute('href');
    expect(canonical, `missing canonical on ${route.path}`).toBeTruthy();
  }
});

test('JSON-LD structured data is parseable on every page', async ({ page }) => {
  for (const route of ROUTES) {
    await page.goto(route.path);
    const jsonLd = await page.locator('script[type="application/ld+json"]').textContent();
    expect(jsonLd, `missing JSON-LD on ${route.path}`).toBeTruthy();
    expect(() => JSON.parse(jsonLd ?? '')).not.toThrow();
  }
});
