// Top-nav interactions: command-palette trigger and mobile menu toggle.
// Loaded via Base.astro's bundled <script>.

document.addEventListener('click', (e: MouseEvent) => {
  const target = e.target;
  if (!(target instanceof Element)) return;
  if (target.closest('[data-cmd-open]')) {
    document.dispatchEvent(new CustomEvent('cmd-palette-open'));
  }
});

document.addEventListener('click', (e: MouseEvent) => {
  const target = e.target;
  if (!(target instanceof Element)) return;
  const button = target.closest('[data-mobile-toggle]');
  if (!button) return;
  const menu = document.getElementById('mobile-menu');
  if (!menu) return;
  const open = menu.getAttribute('data-open') === 'true';
  menu.setAttribute('data-open', open ? 'false' : 'true');
  button.setAttribute('aria-expanded', open ? 'false' : 'true');
});

document.addEventListener('astro:before-preparation', () => {
  const menu = document.getElementById('mobile-menu');
  if (menu) menu.setAttribute('data-open', 'false');
});
