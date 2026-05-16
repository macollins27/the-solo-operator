import { test, expect } from '@playwright/test';

const ROUTES = [
  { path: '/', expectedH1: /How to Use/ },
  { path: '/01-mindset', expectedH1: /The Mindset/ },
  { path: '/02-install', expectedH1: /What to Install/ },
  { path: '/03-escape-moves', expectedH1: /How Claude Tries to Escape/ },
  { path: '/04-counter-moves', expectedH1: /What You Say Back/ },
  { path: '/05-working-loop', expectedH1: /The Working Loop/ },
  { path: '/06-system-that-holds', expectedH1: /The System That Holds/ },
  { path: '/07-multi-claude', expectedH1: /Running Multiple Claudes/ },
  { path: '/08-browser-validation', expectedH1: /Browser Validation/ },
  { path: '/09-quick-reference', expectedH1: /Quick Reference/ },
  { path: '/404', expectedH1: /That page isn't here/ },
];

for (const route of ROUTES) {
  test.describe(`route: ${route.path}`, () => {
    test('renders cleanly with one h1, valid title, no horizontal scroll, no console errors', async ({
      page,
    }) => {
      const errors: string[] = [];
      const isPath404 = route.path === '/404';
      page.on('pageerror', (err) => errors.push(err.message));
      page.on('console', (msg) => {
        if (msg.type() !== 'error') return;
        if (isPath404 && /Failed to load resource.*404/i.test(msg.text())) return;
        errors.push(msg.text());
      });
      page.on('response', (resp) => {
        if (resp.status() >= 400 && resp.url() !== page.url()) {
          errors.push(`${resp.status()} on subresource ${resp.url()}`);
        }
      });

      const response = await page.goto(route.path, { waitUntil: 'networkidle' });
      const status = response?.status() ?? 0;
      expect(status === 200 || status === 404).toBeTruthy();

      const title = await page.title();
      expect(title.length).toBeGreaterThan(0);

      const h1s = await page.locator('main h1').all();
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
