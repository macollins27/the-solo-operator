interface SearchItem {
  section: 'phrasebook' | 'foundations' | 'pages';
  label: string;
  url: string;
  kicker: string;
  description: string;
}

const SECTION_LABEL: Record<SearchItem['section'], string> = {
  phrasebook: 'Phrasebook',
  foundations: 'Foundations',
  pages: 'Pages',
};
const SECTION_ORDER: SearchItem['section'][] = ['phrasebook', 'foundations', 'pages'];

class CommandPalette extends HTMLElement {
  private items: SearchItem[] = [];
  private filtered: SearchItem[] = [];
  private activeIndex = 0;
  private query = '';
  private fetched = false;
  private onKeydownGlobal = (e: KeyboardEvent) => this.handleGlobalKey(e);
  private onClickOutside = (e: MouseEvent) => this.handleClickOutside(e);
  private onNavigation = () => this.close();

  connectedCallback() {
    this.setAttribute('role', 'dialog');
    this.setAttribute('aria-modal', 'true');
    this.setAttribute('aria-label', 'Search the manual');
    this.hidden = true;
    this.innerHTML = this.template();
    this.bindLocal();
    document.addEventListener('keydown', this.onKeydownGlobal);
    document.addEventListener('astro:before-preparation', this.onNavigation);
    document.addEventListener('cmd-palette-open', () => this.open());
  }

  disconnectedCallback() {
    document.removeEventListener('keydown', this.onKeydownGlobal);
    document.removeEventListener('astro:before-preparation', this.onNavigation);
  }

  private template() {
    return `
      <div class="cmd-backdrop"></div>
      <div class="cmd-modal" role="document">
        <div class="cmd-search">
          <span class="cmd-leader">&gt;</span>
          <input
            type="text"
            class="cmd-input"
            placeholder="Search the manual..."
            aria-label="Search query"
            autocomplete="off"
            spellcheck="false"
          />
          <button class="cmd-cancel" type="button" aria-label="Close search">Esc</button>
        </div>
        <div class="cmd-results" role="listbox"></div>
        <div class="cmd-hint">
          <span><kbd>&uarr;&darr;</kbd> navigate</span>
          <span><kbd>&crarr;</kbd> open</span>
          <span><kbd>Esc</kbd> close</span>
        </div>
      </div>
    `;
  }

  private bindLocal() {
    const input = this.querySelector<HTMLInputElement>('.cmd-input');
    const backdrop = this.querySelector<HTMLDivElement>('.cmd-backdrop');
    const cancel = this.querySelector<HTMLButtonElement>('.cmd-cancel');
    if (!input || !backdrop || !cancel) return;
    input.addEventListener('input', () => {
      this.query = input.value;
      this.filter();
      this.activeIndex = 0;
      this.renderResults();
    });
    input.addEventListener('keydown', (e: KeyboardEvent) => this.handleInputKey(e));
    backdrop.addEventListener('click', this.onClickOutside);
    cancel.addEventListener('click', () => this.close());
  }

  private async ensureItems() {
    if (this.fetched) return;
    try {
      const res = await fetch('/search.json');
      this.items = (await res.json()) as SearchItem[];
      this.fetched = true;
    } catch {
      this.items = [];
    }
  }

  private filter() {
    const q = this.query.trim().toLowerCase();
    if (!q) {
      this.filtered = this.items;
      return;
    }
    this.filtered = this.items.filter((it: SearchItem) => {
      const hay = (it.label + ' ' + it.description + ' ' + it.kicker).toLowerCase();
      return hay.includes(q);
    });
  }

  private renderResults() {
    const wrap = this.querySelector<HTMLDivElement>('.cmd-results');
    if (!wrap) return;
    if (this.filtered.length === 0) {
      wrap.innerHTML = `
        <div class="cmd-empty">
          <p>No matches.</p>
          <a href="/phrasebook">Browse the phrasebook &rarr;</a>
        </div>
      `;
      return;
    }
    const grouped: Record<SearchItem['section'], SearchItem[]> = {
      phrasebook: [],
      foundations: [],
      pages: [],
    };
    for (const it of this.filtered) grouped[it.section].push(it);

    let html = '';
    let index = 0;
    for (const section of SECTION_ORDER) {
      const list = grouped[section];
      if (list.length === 0) continue;
      html += `<div class="cmd-section-head">${SECTION_LABEL[section]}</div>`;
      for (const it of list) {
        const active = index === this.activeIndex;
        html += `
          <a href="${it.url}" class="cmd-row${active ? ' is-active' : ''}" data-i="${index}" role="option" aria-selected="${active}">
            <span class="cmd-kicker">${this.escape(it.kicker)}</span>
            <span class="cmd-body">
              <span class="cmd-label">${this.escape(it.label)}</span>
              <span class="cmd-desc">${this.escape(it.description)}</span>
            </span>
            <span class="cmd-hint-inline">&crarr;</span>
          </a>
        `;
        index += 1;
      }
    }
    wrap.innerHTML = html;
    wrap.querySelectorAll<HTMLAnchorElement>('.cmd-row').forEach((row) => {
      row.addEventListener('mouseenter', () => {
        const i = Number(row.dataset.i);
        if (!Number.isNaN(i)) {
          this.activeIndex = i;
          this.updateActiveState();
        }
      });
      row.addEventListener('click', (e: MouseEvent) => {
        e.preventDefault();
        const i = Number(row.dataset.i);
        if (!Number.isNaN(i)) {
          this.activeIndex = i;
          this.activate();
        }
      });
    });
  }

  private updateActiveState() {
    this.querySelectorAll<HTMLAnchorElement>('.cmd-row').forEach((row) => {
      const i = Number(row.dataset.i);
      const active = i === this.activeIndex;
      row.classList.toggle('is-active', active);
      row.setAttribute('aria-selected', String(active));
    });
    const activeRow = this.querySelector<HTMLAnchorElement>('.cmd-row.is-active');
    activeRow?.scrollIntoView({ block: 'nearest' });
  }

  private handleGlobalKey(e: KeyboardEvent) {
    const cmdK = (e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k';
    const slash =
      e.key === '/' &&
      !(e.target instanceof HTMLInputElement) &&
      !(e.target instanceof HTMLTextAreaElement);
    if (cmdK || slash) {
      e.preventDefault();
      this.open();
    } else if (e.key === 'Escape' && !this.hidden) {
      e.preventDefault();
      this.close();
    }
  }

  private handleInputKey(e: KeyboardEvent) {
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      if (this.filtered.length === 0) return;
      this.activeIndex = (this.activeIndex + 1) % this.filtered.length;
      this.updateActiveState();
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      if (this.filtered.length === 0) return;
      this.activeIndex = (this.activeIndex - 1 + this.filtered.length) % this.filtered.length;
      this.updateActiveState();
    } else if (e.key === 'Enter') {
      e.preventDefault();
      this.activate();
    }
  }

  private handleClickOutside(e: MouseEvent) {
    if (e.target === this.querySelector('.cmd-backdrop')) {
      this.close();
    }
  }

  private activate() {
    const item = this.filtered[this.activeIndex];
    if (!item) return;
    this.close();
    window.location.href = item.url;
  }

  async open() {
    await this.ensureItems();
    this.query = '';
    this.activeIndex = 0;
    this.filter();
    this.hidden = false;
    document.body.style.overflow = 'hidden';
    this.renderResults();
    const input = this.querySelector<HTMLInputElement>('.cmd-input');
    if (input) {
      input.value = '';
      requestAnimationFrame(() => input.focus());
    }
  }

  close() {
    this.hidden = true;
    document.body.style.overflow = '';
  }

  private escape(s: string) {
    return s.replace(/[&<>"']/g, (c) => {
      switch (c) {
        case '&':
          return '&amp;';
        case '<':
          return '&lt;';
        case '>':
          return '&gt;';
        case '"':
          return '&quot;';
        case "'":
          return '&#39;';
        default:
          return c;
      }
    });
  }
}

if (!customElements.get('command-palette')) {
  customElements.define('command-palette', CommandPalette);
}
