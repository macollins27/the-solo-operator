class ReadingProgress extends HTMLElement {
  private bar: HTMLElement | null = null;
  private ticking = false;
  private onScroll = () => this.requestTick();
  private onResize = () => this.requestTick();

  connectedCallback() {
    this.setAttribute('role', 'progressbar');
    if (!this.hasAttribute('aria-label')) {
      this.setAttribute('aria-label', 'Reading progress');
    }
    this.setAttribute('aria-valuemin', '0');
    this.setAttribute('aria-valuemax', '100');
    this.innerHTML = '<div class="reading-progress-bar"></div>';
    this.bar = this.querySelector('.reading-progress-bar');
    window.addEventListener('scroll', this.onScroll, { passive: true });
    window.addEventListener('resize', this.onResize);
    this.update();
  }

  disconnectedCallback() {
    window.removeEventListener('scroll', this.onScroll);
    window.removeEventListener('resize', this.onResize);
  }

  private requestTick() {
    if (this.ticking) return;
    this.ticking = true;
    requestAnimationFrame(() => {
      this.update();
      this.ticking = false;
    });
  }

  private update() {
    if (!this.bar) return;
    const doc = document.documentElement;
    const scrolled = doc.scrollTop;
    const total = doc.scrollHeight - doc.clientHeight;
    const pct = total > 0 ? Math.min(100, Math.max(0, (scrolled / total) * 100)) : 0;
    this.bar.style.transform = `scaleX(${pct / 100})`;
    this.setAttribute('aria-valuenow', String(Math.round(pct)));
  }
}

if (!customElements.get('reading-progress')) {
  customElements.define('reading-progress', ReadingProgress);
}
