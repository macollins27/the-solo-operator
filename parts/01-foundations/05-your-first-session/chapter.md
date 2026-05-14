# Chapter 5 — Your first Claude Code session

## Learning objective

The student can start a Claude Code session in their terminal, ask Claude to perform a read-only task, observe the tool calls Claude makes, respond to a permission prompt, and exit the session cleanly.

## Prerequisites

- Completed: Chapter 4 — What Claude Code is, what it isn't
- Concepts: chat-vs-agent, what-is-a-tool-call

## Core concept

You start a Claude Code session by typing `claude` in your terminal. The session opens inside whatever folder you were in when you typed the command. That folder is Claude's **working directory** — Claude will read and write files in this folder by default, not anywhere else.

This is important. If you start `claude` in your home folder, Claude works against your home folder. If you start it inside the course repo, Claude works against the course repo. Operators are deliberate about where they start their sessions. The first thing you do is `cd` to the right folder. The second thing you do is `claude`.

Once the session opens, you see a chat-like prompt. You type a request. Claude reads it, decides what tools to use, calls them, and reports what it did. Each tool call appears in your terminal as a small box showing the tool name and a summary of what it did.

Three things to notice in your first session:

**The conversation has TWO speakers, but THREE kinds of output.** Your input (text). Claude's text replies (also text). And Claude's TOOL CALLS — which look different from text. Tool calls are Claude *doing* things in your environment. They get rendered as compact boxes you can expand.

**Permission prompts appear before risky actions.** Reading a file is usually allowed without asking. Editing a file might be allowed automatically (in some modes) or might prompt you. Running a shell command often prompts. Each prompt shows you exactly what Claude wants to do; you say yes or no. Skim them. Saying yes-to-everything reflexively is a class of beginner mistake we'll address in Part 2.

**The session has state.** Claude remembers what was discussed earlier in this session — files it already read, things you told it. When you `/exit` and restart, that state is gone (for now; later we'll show you how to persist state across sessions).

Three commands matter inside a session:

```
/help        # see all the slash-commands available
/clear       # clear conversation history (keeps the session running)
/exit        # close the session
```

You don't have to know the others yet. We'll introduce them as they become relevant.

A session has a few interaction patterns worth knowing now:

- **You type a plain question or request.** Claude responds in text.
- **You ask Claude to do something with files.** Claude calls Read/Write/Edit tools to make it happen.
- **You ask Claude to run a command.** Claude calls a Bash tool; you may be prompted to approve.
- **Claude asks you a question.** Answer. The conversation continues.
- **Claude reports done.** You verify (Git diff, read the file, run the test). Decide what's next.

## Worked example

In your terminal:

```
cd ~/the-solo-operator                 # or wherever your fork lives
claude
```

A session opens. You see a prompt waiting for input.

Try this request first (a read-only task, low-risk):

```
List the files in the canonical-project folder and tell me what each one is for.
```

Watch what happens. Claude probably calls a `Read` or `Bash` tool to list the folder, then a `Read` tool on individual files to see their contents. You see each tool call render as a small box. Claude then writes a text reply explaining each file.

Next, exit:

```
/exit
```

Reopen the session:

```
claude
```

Ask the same question again. Claude will redo the work — it doesn't remember the prior session. (Later you'll learn how to give Claude persistent memory via `CLAUDE.md` and MCP servers; for now, fresh session = fresh start.)

## The rule

> Start every Claude Code session by `cd`-ing to the right folder, then typing `claude`. Read every tool call Claude makes — the boxes are not noise, they're the work being done. Permission prompts are not interruptions to dismiss; they're checkpoints to think.

## Common mistakes

**Mistake 1 — Starting `claude` in the wrong folder.** You type `claude` from your home folder and ask it to "fix the auth bug." Claude has no idea what app you mean — your home folder has 200 things in it. Claude either guesses (badly) or starts asking you 20 questions. Move to the project folder first, then start.

**Mistake 2 — Approving permissions without reading.** A permission prompt is showing you exactly what Claude wants to do. "Run `rm -rf /tmp/foo`" and "Run `rm -rf /`" are one character apart and one is fine while the other is catastrophic. The whole point of the prompt is to make you look. Look.

**Mistake 3 — Treating exit and `Ctrl + C` as the same.** `/exit` cleanly closes the session and writes any pending state. A single `Ctrl + C` interrupts whatever Claude is currently doing (the tool call in flight) without ending the session — useful when you want to stop a bad path mid-action and redirect. A double `Ctrl + C` (press it twice in quick succession) actually exits the session. Use `/exit` for clean shutdowns; reserve single `Ctrl + C` for "stop what you're doing, I want to redirect," and double `Ctrl + C` for "get me out now."

## Drill

You'll capture three artifacts from your first sessions. They go in `student/drills/05-your-first-session/`.

**Drill 1 — Capture a session transcript.** Run a Claude Code session in your course repo. Ask Claude: "Read the README.md in this repo and tell me in three sentences what the course is about." When it finishes, save its text reply (copy-paste from your terminal) to `student/drills/05-your-first-session/01-readme-summary.txt`. Exit cleanly with `/exit`.

**Drill 2 — Watch a permission prompt fire.** Start a new session. Ask: "List the files in this folder using the `ls -la` shell command." Claude will probably prompt for permission to run `ls`. Note: did you get a prompt, or was `ls` already allowed? Either way, write your observation as one or two sentences to `student/drills/05-your-first-session/02-permission-observation.txt`. Mention whether you said yes, what happened next, and how you felt about being asked.

**Drill 3 — Name three tool calls you saw.** Run another short session — ask Claude anything that requires it to read or write or run something. Watch the tool-call boxes. Write the names of three different tools you saw Claude use to `student/drills/05-your-first-session/03-tools-i-saw.txt`, one per line. (Common ones: Read, Write, Edit, Bash, Grep, Glob, Task, WebFetch.)

## Checkpoint question

> You just ran a Claude Code session. Claude told you "I read the file and made the change you asked for." You did NOT see a tool-call box appear during the session. What does this tell you, and what's the next thing you'd say to Claude?

<!-- Rewriter audit trail
Mechanical chapter — starting/ending a session, permission prompts, slash commands. Checkpoint seeds the false-yes intuition (P4) that Chapter 12 develops. Core untouched in this rewrite pass.
Rewrite date: 2026-05-13
-->
