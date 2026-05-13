# Appendix E — Reading List

External references that complement this course. Read these AFTER the relevant chapters — not before. They'll make more sense once you have operating experience to anchor them.

---

## Anthropic's own documentation

**Claude Code documentation** — `https://docs.claude.com/en/docs/claude-code`. The official reference for the tool itself. Skim sections you've already learned from this course; deep-read sections this course didn't cover (release notes, advanced features, IDE integrations).

**Claude API documentation** — `https://docs.claude.com/en/api`. Read AFTER Chapter 30 (AI member-directory search). Specifically useful: tool use, structured outputs, prompt caching, batch processing. Relevant if you build features that call Claude from your own app.

**Anthropic's prompt engineering guides** — `https://docs.claude.com/en/docs/build-with-claude/prompt-engineering`. Read AFTER Part 2 (the mindset). The guides assume some mental model; you've built that mental model now. Sections on agentic tool use, chain-of-thought, and few-shot prompting are relevant; XML tagging conventions are relevant for Chapter 30 (input sanitization against prompt injection).

**Model context protocol (MCP) docs** — `https://modelcontextprotocol.io/`. Read AFTER Chapter 22 (MCP servers). The spec, examples in Python and TypeScript, server templates. When you're ready to author your own MCP server, start here.

---

## Open-source projects with strong CLAUDE.md / operator discipline

Reading other operators' CLAUDE.md files is the fastest way to see what mature operating looks like. Look for projects in active development with public repos. You're studying the *shape* of their rules, not copying them.

Specific repos to study (look for `CLAUDE.md` at the root):

- **next-forge** (`https://github.com/haydenbleasel/next-forge`) — the Next.js starter MembershipKit is based on. Strong example of standing rules for a typed-TS / Drizzle stack.
- **shadcn/ui** (`https://github.com/shadcn-ui/ui`) — component library that uses AI-assisted development. Look at how their CLAUDE.md (if present) handles component-authoring conventions.
- **Various community templates** searching `claude.md` on GitHub returns many examples. Read 5-10 to see the range of shapes. Note what you'd steal, what you'd reject.

---

## Books — engineering discipline

**"A Philosophy of Software Design" by John Ousterhout.** Read AFTER Part 3 (the mechanics). Particularly Chapter 6 ("General-purpose modules are deeper") and Chapter 12 ("Why write comments?"). The principles apply directly to skill and CLAUDE.md authoring.

**"The Pragmatic Programmer" by Dave Thomas and Andy Hunt (20th anniversary edition).** Read AFTER Part 2 (the mindset). The "broken windows" principle, the value of small recurring rules, treating warnings as errors — these all map to what an operator learns.

**"Clean Architecture" by Robert Martin.** Skim AFTER Part 5 (hero level). You don't need to adopt Clean Architecture wholesale, but the boundary-discipline ideas inform how mature skill families compose.

---

## Books — AI engineering specifically

**Anthropic's published research papers.** `https://www.anthropic.com/research`. Of particular relevance: the Constitutional AI paper, the Claude 4 technical report, the various agent papers. Not required reading, but useful background once you've operated for a few weeks.

**"Building LLM Applications for Production" articles** (Eugene Yan's blog, Chip Huyen's writing). Practical, code-adjacent, often updated. Read AFTER Chapter 30.

---

## Community resources

**Claude Code discord / forums.** Operators sharing what's working, what's broken, what they've discovered. Lurk first; ask later, with specific reproductions. Don't ask "is X possible?"; show what you tried and what happened.

**Twitter / X — search "@AnthropicAI" + "Claude Code"** — Anthropic engineers post updates, examples, and answers to common questions. Useful when you hit something not in the docs yet.

---

## Productivity / discipline (adjacent but load-bearing)

**"Deep Work" by Cal Newport.** The operating arc this course describes (Stage 1 → Stage 4 trust calibration) needs the ability to focus for multi-hour stretches. Newport's framework supports it.

**"Getting Things Done" by David Allen.** Particularly the "next action" framing — which is exactly the persistence-discipline of Chapter 14 (tasks are made of edits; the next edit is always available). Read AFTER Chapter 14.

---

## What NOT to read (yet)

Don't read these until you have ~3 months of operating experience:

- Generic "AI for everyone" books. They oversimplify in a way that's actively confusing if you've already built mental models.
- Productivity hacks involving AI ("use AI to write your emails 10x faster"). Wrong altitude. The course operates at the engineering layer, not the daily-tasks layer.
- Vendor-specific AI tutorials for tools that aren't Claude Code. Generic knowledge transfers, but specific patterns don't, and learning two specific patterns slows you down.

---

## How to keep the list growing

When you find something genuinely useful — add it here. Same format: title, one-sentence what-it-is, when in the arc to read it. Over months this becomes your personal reading list, calibrated to where you actually are in the journey.

The list doesn't need to be long. It needs to be RIGHT — every entry earned its place by helping you operate better.
