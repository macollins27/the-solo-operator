class CopyButton extends HTMLElement {
  private originalText: string | null = null;
  private revertTimer: number | null = null;

  connectedCallback() {
    this.setAttribute('role', 'button');
    this.setAttribute('tabindex', '0');
    if (!this.hasAttribute('aria-label')) {
      this.setAttribute('aria-label', 'Copy paste text to clipboard');
    }
    this.setAttribute('aria-live', 'polite');
    this.dataset.state ||= 'idle';
    this.originalText = this.textContent;
    this.addEventListener('click', () => this.copy());
    this.addEventListener('keydown', (e: KeyboardEvent) => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        this.copy();
      }
    });
  }

  async copy() {
    const target = this.closest('.paste-block')?.querySelector('pre');
    const text = target?.textContent?.trim();
    if (!text) return;
    if (this.revertTimer !== null) {
      window.clearTimeout(this.revertTimer);
      this.revertTimer = null;
    }
    try {
      await navigator.clipboard.writeText(text);
      this.dataset.state = 'copied';
      this.textContent = 'Copied';
    } catch {
      this.dataset.state = 'error';
      this.textContent = 'Press Ctrl+C';
    }
    this.revertTimer = window.setTimeout(() => {
      this.dataset.state = 'idle';
      this.textContent = this.originalText ?? 'Copy';
      this.revertTimer = null;
    }, 1400);
  }
}

if (!customElements.get('copy-button')) {
  customElements.define('copy-button', CopyButton);
}
