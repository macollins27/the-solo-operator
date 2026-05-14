# Appendix D — Glossary

Every technical term in this course, defined in plain English. Use this when a chapter references something you don't remember.

---

**Agent** — A program that uses AI plus tools to take actions in your environment. Different from a chat: a chat produces text; an agent reads files, runs commands, writes code. Claude Code is an agent.

**ast-grep** — A tool for matching patterns in source code based on its abstract syntax tree (the structural representation of code, not just text). Used to enforce code-shape rules mechanically (e.g., "no `as any` type assertions allowed").

**Audit log** — A database table that records every state-changing action with actor, action, target, before/after snapshots, and timestamp. Append-only; can never be edited or deleted by application code. Chapter 31.

**Authority hierarchy** — The ordering of sources of truth in your project. Top: your typed instructions. Bottom: AI-authored intermediate documents. Chapter 17.

**Better Auth** — An open-source authentication library used in MembershipKit. Handles sign-up, sign-in, sessions. Self-hosted (you run it on your own server).

**bigint** — A database column type for storing whole numbers up to ~9.2 quintillion. Used for money (as integer cents) because it avoids floating-point rounding errors.

**Branch (Git)** — A separate line of development in a Git repo. You usually work on `main`; some teams use feature branches. This course's flow keeps you on `main` for simplicity.

**Capacity (event)** — The maximum number of yes-RSVPs an event allows. Enforced concurrency-safely via `SELECT FOR UPDATE` in a transaction. Chapter 28.

**cd** — Change directory. The shell command for walking to a different folder. `cd ~` walks to your home folder; `cd ..` walks one up. Chapter 2.

**Channel auth** — The security check that decides whether a client can subscribe to a real-time WebSocket channel. Same principles as API auth. Chapter 29.

**Claude API** — Anthropic's HTTP API for calling Claude programmatically. Used inside your app when you want AI features (e.g., AI member-directory search). Different from Claude Code, which is a developer tool.

**Claude Code** — Anthropic's CLI agent tool. Runs in your terminal. Reads files, runs commands, writes code. The subject of this course.

**CLAUDE.md** — The rulebook for your project that Claude Code reads at session start. One per project (or per directory). Chapter 19.

**Commit (Git)** — A snapshot of your project state at a moment in time. Saved with a message describing what changed. Chapter 3.

**Compaction** — When a Claude Code session's context window fills up, older parts of the conversation get summarized to make room. Lossy: some details disappear. Chapter 6.

**Context window** — The amount of conversation history (plus system prompt) Claude can "see" at any moment. Finite — typically 200,000 to 1,000,000 tokens. Chapter 6.

**Critique-able artifact** — Any work product you can audit by reading it: a Git diff, a command output, a screenshot. The opposite of a claim. Chapter 12.

**CSRF (Cross-Site Request Forgery)** — A class of web vulnerability where a malicious site causes a user's browser to submit unwanted requests to your app. Better Auth handles CSRF protection by default.

**Cron / cron job** — A scheduled task that runs at fixed intervals (e.g., every 15 minutes). Used for renewal reminders, daily summaries, etc.

**Drizzle (ORM)** — A TypeScript ORM (Object-Relational Mapper). Lets you write database queries as TypeScript code. Used in MembershipKit.

**Edit (Claude tool)** — The Claude Code tool that makes a targeted change to a file (find string, replace string). Preferred over Write for modifying existing files. Chapter 7.

**Enum (database)** — A column type that only allows a specific set of values (e.g., status: 'yes' | 'no' | 'maybe'). Enforced by the database, not just the application. Chapter 28.

**Feedback file** — A short markdown file documenting one AI failure incident and the rule you authored from it. Format: What happened / Mechanism / Rule / Evidence. Chapter 16.

**Fork (Git)** — A personal copy of a repo, hosted on GitHub. Each student forks the course repo to make their own copy. Chapter 3, and the install README.

**Fork (subagent)** — A subagent that inherits the orchestrator's full conversation context. Different from a fresh subagent. Chapter 23.

**Fresh subagent** — A subagent that starts with zero context; needs full briefing in the dispatch prompt. Chapter 23.

**Git** — A version-control system. Records snapshots of your work over time. Chapter 3.

**GitHub** — A website that hosts Git repos. Used in this course for distribution: each student forks the course repo on GitHub.

**Glob (Claude tool)** — The Claude Code tool that finds files whose paths match a pattern (e.g., `**/*.tsx`). Chapter 7.

**Grep (Claude tool)** — The Claude Code tool that searches for a string pattern across files. Chapter 7.

**Hook** — A script that runs automatically on a Claude Code event (before/after tool use, on session stop, etc.). Deterministic enforcement. Chapter 21.

**Idempotent** — An operation that produces the same result whether it runs once or many times. E.g., "create user if not exists" is idempotent; "increment user count" is not.

**Integer cents** — How money should be stored. $1.50 is stored as `150`, not `1.50`. Avoids floating-point rounding. Chapter 26.

**JSON Schema** — A specification for the shape of a JSON object. Used in MCP and the anti-pattern classifier to enforce structured output from Claude. Chapter 36.

**Localhost** — Your own computer, treated as a "host" on the network. `http://localhost:3000` means "the web server running on my own machine on port 3000."

**MCP (Model Context Protocol)** — Anthropic's protocol for connecting AI agents to data sources via small servers. Each MCP server exposes tools the agent can call. Chapter 22.

**meta.yml** — The metadata file for each chapter in this course. Machine-readable. Contains prerequisites, concepts taught, complexity level. Chapter schema in `CHAPTER_SCHEMA.md`.

**Migration (database)** — A versioned change to your database schema (creating tables, adding columns, etc.). Stored as code in your repo so it can be applied consistently across environments.

**Next.js** — A React-based web framework used by MembershipKit. Handles routing, server-side rendering, dev server.

**Node.js** — A JavaScript runtime. Lets you run JavaScript outside a browser. Required to run Next.js apps.

**ORM (Object-Relational Mapper)** — A library that translates between database rows and code objects (Drizzle, Prisma, etc.).

**Orchestrator** — The main Claude Code session that dispatches subagents but doesn't do heavy work itself. Chapter 37.

**Package manager** — A tool for installing and managing third-party code libraries. pnpm, npm, yarn. This course uses pnpm.

**Permission prompt** — A pop-up in Claude Code asking whether to allow a specific action (running a command, writing a file). Chapter 5.

**Playwright** — A library for browser automation. Used in this course (via Playwright MCP) to verify UI changes from the AI's perspective. Chapter 12.

**pnpm** — A fast, disk-efficient package manager for JavaScript projects. Used by MembershipKit.

**Postgres / PostgreSQL** — An open-source relational database. Used by MembershipKit.

**Process** — A running program. When you "open an app," the OS creates a process. Chapter 1.

**RAM** — Random Access Memory. Fast, temporary storage. The "counter" in the kitchen analogy. Chapter 1.

**Read (Claude tool)** — The Claude Code tool that reads a file's contents into the conversation. Costs tokens equal to the file's text length. Chapter 7.

**Real-time** — Updates that appear in a browser without page refresh. Common transports: WebSocket (bidirectional), Server-Sent Events / SSE (server → client only, over HTTP), and long-polling (HTTP request held open until data arrives). Chapter 29.

**Recursive (in this course)** — The course teaches you Claude Code by being taught BY Claude Code. The medium and the subject are the same.

**Repository (repo)** — A Git project. Contains your files + their full history. Chapter 3.

**RSVP** — A response to an event invitation: yes / no / maybe. Stored as an enum in MembershipKit. Chapter 28.

**Schema (database)** — The structure of your database: tables, columns, types, constraints. Defined in Drizzle code in MembershipKit.

**Session (Claude Code)** — A single run of `claude`. Has its own conversation, context, and state. Ends with `/exit`. Chapter 24.

**Session-state doc** — A handoff file you write at the end of a session describing where you left off, so the next session can pick up. Chapter 24.

**SKILL.md** — The markdown file defining a skill. YAML frontmatter (name, description) + numbered body. Chapter 20.

**Soketi** — An open-source WebSocket server (Pusher-protocol compatible). Used by MembershipKit for real-time check-ins. Runs in Docker locally. Chapter 29.

**Spec (specification)** — Your written intent. Authoritative against AI output. Lives in `docs/specs/` or similar. Chapter 11.

**Storage (disk)** — Permanent file storage. The "pantry" in the kitchen analogy. Chapter 1.

**Stripe** — A payment-processing service. Used by MembershipKit for dues subscriptions. Test mode = real API, fake cards. Chapter 26.

**Subagent** — A Claude instance dispatched from another Claude Code session. Two kinds: fork (inherits context) and fresh (starts clean). Chapter 23.

**Stop hook** — A hook that fires after Claude produces a response, before the user sees it. Used for the anti-pattern classifier. Chapter 36.

**Stash (Git) — BANNED** — A Git feature for temporarily setting changes aside. Banned in Maxwell's discipline (it lost 20+ commits in one incident). Use commit + revert instead.

**Terminal** — A text-based interface to your computer. Where you type commands. Chapter 2.

**timestamptz** — Postgres column type for timestamps with timezone info. The right type for ANY time-related column. Chapter 28.

**Token (AI context)** — The basic unit Claude reads and produces. Roughly 0.75 of an English word. Context windows are measured in tokens.

**Tool call** — When Claude invokes a tool (Read, Write, Bash, etc.). Visible in your session as a small expandable box. Chapter 7.

**TOCTOU (Time-of-check-to-time-of-use)** — A race-condition class. "First check if X, then do Y" can fail when something changes between the check and the use. Fix: do it atomically. Chapter 28.

**Trust calibration** — The arc of how much autonomy you grant your AI agent over time. Stage 1 (every action reviewed) → Stage 4 (background operation, sampled supervision). Chapter 38.

**Two-Option Rule** — When stuck, fix it or stop and present. Silent continuation does not exist. Chapter 10.

**TypeScript** — A typed superset of JavaScript. Used by MembershipKit. The strict mode catches many bugs at compile time.

**UUIDv7** — A version of UUID that includes a timestamp at the start, making them naturally sortable by creation order. Used for primary keys in MembershipKit. Standardized in RFC 9562 (May 2024); library support is uneven — Node's built-in `crypto.randomUUID()` returns v4, not v7, so you need the `uuid` npm package or a Postgres extension like `uuid_generate_v7()`.

**Verify.sh** — A small bash script per chapter that mechanically checks the student's drill is complete. Chapter schema in `CHAPTER_SCHEMA.md`.

**Walk test** — The operational metric of trust calibration: how long can you step away from your laptop during a dispatch without anxiety? Chapter 38.

**Webhook** — An HTTP request a third-party service makes to your app to notify you of an event (Stripe payment succeeded, etc.). Chapter 26.

**WebSocket** — A persistent connection between browser and server, used for real-time updates. Chapter 29.

**Working directory** — The folder a process is "in." The shell's working directory is where commands run by default. The Claude Code session's working directory is where Claude reads/writes by default. Chapter 5.

**Write (Claude tool)** — The Claude Code tool that creates or overwrites a file. Used for new files. Prefer Edit for modifying existing ones. Chapter 7.

**Zod** — A TypeScript library for declaring and validating data shapes. Used by MembershipKit for input validation. Chapter 26.

---

Missing a term? Add it. Same format: one paragraph, plain English, no jargon-explained-with-jargon.
