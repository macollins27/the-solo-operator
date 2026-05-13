# Chapter 7 — Reading Claude's tool calls

## Learning objective

The student can identify the six tools Claude Code uses most often (Read, Write, Edit, Bash, Grep, Glob), explain what each one does in their own words, and predict which tool Claude will use given a plain-English task.

## Prerequisites

- Completed: Chapter 6 — The conversation loop and context window
- Concepts: tool-call-rendering, what-is-a-tool-call

## Core concept

Every Claude Code session is mostly a sequence of tool calls. Once you can read them fluently, you can read any session — not just yours, anyone's. Six tools cover the overwhelming majority of what you'll see.

**Read.** Claude opens a file and brings its contents into the conversation. The tool call shows the file path and (optionally) a line range. Used for: looking at code, reading config, reviewing docs, inspecting test results saved to a file. Every Read pulls the file's text into your context window — so a Read on a 5,000-line file costs you a lot of tokens. Claude is usually careful to read only what it needs, but you can ask it to be more careful if context is tight.

**Write.** Claude creates a new file or overwrites an existing one entirely. The tool call shows the file path and the full new content. Used for: creating new files, replacing a file wholesale. A Write on an existing file LOSES the old content; if you wanted a targeted change, Claude should have used Edit instead.

**Edit.** Claude changes part of an existing file. The tool call shows the file path, an `old_string` (the exact text to find), and a `new_string` (what to replace it with). Used for: surgical changes — fix a typo, rename a variable, add a line to an existing function. Edit doesn't touch lines you didn't tell it to touch, so it's safer than Write for modifying real files.

**Bash.** Claude runs a shell command in your terminal. The tool call shows the command and the output. Used for: running tests, installing packages, listing files, anything you'd normally do at the prompt. Permissions matter most here — `ls` is safe, `rm -rf /` is not, and Claude Code asks before running things that could be destructive.

**Grep.** Claude searches for a pattern across files. The tool call shows the pattern, the file set, and the matching lines. Used for: "where is this function defined?", "who calls this method?", "find all TODO comments." Grep is cheaper than Read for "is this string anywhere in my codebase?" — it returns matches, not whole files.

**Glob.** Claude finds files whose paths match a pattern (like `**/*.tsx` for "every .tsx file under any folder"). The tool call shows the pattern and the matching paths. Used for: "what TypeScript files exist?", "which folders have test files?" Glob lists paths only, no contents.

A few more tools you'll see less often but should recognize when they appear:

**WebFetch** — Claude fetches a URL. Used for reading docs from the web.
**Task / Agent** — Claude spawns a subagent (a separate Claude instance) to handle a piece of work. Used when one task is too big or context-bloating for the main session.
**TodoWrite** — Claude tracks a list of tasks it's working on. You see them appear as a checklist.

Reading a session fluently means watching the sequence of tool calls. If you asked Claude to "fix the failing test in `auth-flow.test.ts`," a fluent operator scans the tool calls and notes: did Claude `Read` the test file? Did it `Read` the source file the test is testing? Did it `Edit` something? Did it run the test via `Bash`? Did the test pass? You can answer each question by scanning the tool-call sequence in seconds. You don't have to trust Claude's text summary — the tool calls are the truth.

## Worked example

You ask Claude: "There's a typo in README.md — the word 'tutoring' appears twice and one should be 'turoring'." (Yes, you typed it wrong on purpose to see what Claude does.)

A capable session looks like this:

1. **Grep** — Claude searches `README.md` for the word "tutoring". Output: two matches at lines 12 and 47.
2. **Read** — Claude reads `README.md` lines 1–60 to see the surrounding context.
3. (Claude decides which "tutoring" to leave alone and which to change to "turoring." Or — better — Claude pushes back and tells you you've confused yourself and that "tutoring" is actually correct. A good agent does this.)
4. **Edit** — Claude changes the agreed-upon line. The Edit tool call shows the exact line before and after.

A poor session looks like this:

1. **Read** — Claude reads the entire `README.md` (the whole 270 lines).
2. **Write** — Claude writes a "fixed" README.md, replacing the whole file.
3. You don't notice that Claude changed five other things you didn't ask about, because Write doesn't show diffs — it shows the full new content.

Same task, two patterns, very different operator experience. The first is auditable; the second is "trust me." Operators ask Claude to prefer Edit over Write for changes, and Grep over Read for "is X anywhere."

## The rule

> Tool output is truth. Chat narration is hint. The tool calls show the work that actually happened; the text reply is a summary that may or may not match. When Claude reports "I made the change," look at the Edit (or Write) tool call to see exactly what it did — and look at the Bash output to see exactly what ran. Don't read the summary as if it were the truth.

## Common mistakes

**Mistake 1 — Letting Claude Write when Edit would do.** Write overwrites a whole file. Edit changes a specific part. A Write on a complex existing file gives Claude implicit permission to "improve" things you didn't ask about. Prefer Edit unless the file is being created fresh.

**Mistake 2 — Not reading the Bash command before approving it.** When Claude calls Bash and permission prompts you, the prompt shows the exact command. `git commit -m "Fix"` is fine. `git push --force origin main` is a different conversation. Read the command, not just the prompt's vibe.

**Mistake 3 — Ignoring the tool-call output.** Bash tool calls show both the command and its output. The output is information. "Tests passed" is different from "Tests passed, 14 skipped, 3 warnings." Skim the output before moving on.

**Mistake 4 — Believing a "done" claim with no tool calls behind it.** Claude reports "I made the change," but no Edit or Write tool call appears in the session. Either Claude didn't actually do the work, or it did the work via a path you can't see. Either way the right response is: "I see your message but no Edit tool call. Show me where the change was written, or run it again." Chapter 12 turns this into a discipline; Chapter 7 introduces the muscle.

## Drill

You'll observe a real session and document what you saw. Artifacts go in `student/drills/07-reading-tool-calls/`.

**Drill 1 — Map a session to tool calls.** Open Claude Code in your course repo. Ask Claude: "Look at the meta.yml files in parts/01-foundations/ and tell me the title of each chapter." Watch the tool calls. In `student/drills/07-reading-tool-calls/01-session-map.txt`, write a list of every tool call you saw in order: tool name → what it operated on. Example:
```
Glob — parts/01-foundations/**/meta.yml
Read — parts/01-foundations/01-what-a-computer-does/meta.yml
Read — parts/01-foundations/02-the-terminal/meta.yml
...
```

**Drill 2 — Predict the tools before asking.** Without opening Claude Code, write to `student/drills/07-reading-tool-calls/02-prediction.txt`: for each of these tasks, which tool(s) would Claude use? Just list the tools you'd expect; one task per line.
- "Find every TODO comment in the codebase"
- "Create a new file called notes.txt with my favorite quote"
- "Fix the typo on line 47 of README.md"
- "Run the test suite and tell me if it passes"

**Drill 3 — Test your prediction.** Open Claude Code. Pick ONE of the four tasks from Drill 2 (the simplest is "Find every TODO comment in the codebase"). Run it. Compare the tools Claude actually used to your prediction. Write the comparison to `student/drills/07-reading-tool-calls/03-prediction-vs-reality.txt`: "I predicted X; Claude used Y; the difference was..."

## Checkpoint question

> Claude reports: "I fixed the bug — the function was calling the wrong helper and I corrected it." You scroll back through the session. You see a `Read` of the buggy file, no `Edit` and no `Write`, then Claude's text summary. What happened, and what would you say to Claude next?

<!-- Rewriter audit trail
Grounded in verified principles: P4 (false-yes / false-no symmetry — introductory framing), P5 (tool output is truth; chat narration is hint), P7 (verify against artifacts not summaries — beginner-level introduction)
Worked example surface: README typo Edit vs Write comparison (no live MembershipKit yet — that comes Ch 8)
Rewrite date: 2026-05-13
-->
