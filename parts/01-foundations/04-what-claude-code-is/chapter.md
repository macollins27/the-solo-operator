# Chapter 4 — What Claude Code is, what it isn't

## Learning objective

The student can explain in their own words the difference between a chat interface (like claude.ai) and an agent (like Claude Code), and name three things Claude Code can do that a chat cannot.

## Prerequisites

- Completed: Chapter 3 — Git in plain English
- Concepts: what-is-a-file, what-is-a-process, git-as-memory-for-ai-work

## Core concept

There are two ways most people interact with Claude. One is a **chat** — you open a webpage, type a question, get text back. The other is an **agent** — Claude Code, running in your terminal, with access to your computer.

The difference between them is **tools**.

In a chat, Claude can only do one thing: produce text. You read what it produced, you decide what to do with it, you copy and paste, you run things yourself. The chat is a smart conversation partner with no hands.

In Claude Code, Claude has **tools**. Tools are specific actions the AI can take in your environment: read a file, write a file, run a command, search the web, query a database, send a network request. When you give Claude Code a task, it doesn't just describe what to do — it does it, by calling tools. Each tool call is recorded. You see what it ran. You can stop it. You can ask it why.

This is the difference between a consultant who tells you what to do and an employee who does it. The employee is more useful, more dangerous, and requires different management. Most of this course is about how to manage the employee.

A typical Claude Code session looks like this: you tell Claude what you want. It reads some files to understand the context. It writes some new files. It runs a test. The test fails. It reads the failure message, edits a file, re-runs the test. It passes. Claude reports what it did. You decide whether to keep the work. Each step was a tool call — readable, reversible, auditable. None of that is possible in a chat.

Three things Claude Code can do that chat cannot:

**One — modify files in your project.** Claude Code reads and writes the actual files on your disk, not copies in some sandbox. When it edits `chapter.md`, your `chapter.md` changes. This is why Git matters (Chapter 3): every change is reversible only if it's committed.

**Two — run commands.** Claude Code can run shell commands — `ls`, `git status`, `npm test`, anything you can run in your terminal. It can also be **denied** from running specific commands via the permissions system or hooks (more in Part 3).

**Three — extend itself.** Claude Code can be configured to know about your project (via `CLAUDE.md`), to perform specific workflows (via skills), to enforce rules deterministically (via hooks), and to query external systems (via MCP servers). The default Claude Code is generic. Your Claude Code is specific to you, after a few weeks of operating it.

What Claude Code is NOT:

It is not a magic code-writer. The code it produces is only as good as the instructions, rules, and verification you wrap around it. Without `CLAUDE.md`, without tests, without you reading the diffs — it will produce confident plausible-looking work that doesn't actually do what you wanted. With them, it produces excellent work consistently.

It is not a chat trying to be helpful in your terminal. It's an agent. The mental model is different. Chat agents try to satisfy. Agents take action. Action has consequences.

It is not a sandbox. The files it touches are real. The commands it runs really execute. Treat its access with the same seriousness as you would handing someone an SSH key to your laptop.

## Worked example

Imagine you have a folder with three text files. You ask both interfaces the same thing: "Combine the contents of these three files into one file called combined.txt."

In a **chat**, you'd open the three files, copy their contents, paste them into the chat, ask Claude to combine them, get the combined text back, paste it into a new file you create. Four context-switches. You did most of the work.

In **Claude Code**, you'd type the request. Claude calls a `Read` tool on each of the three files. Claude calls a `Write` tool to create `combined.txt` with the merged content. Claude reports done. You can verify by running `cat combined.txt`. One step. Claude did the work.

The leverage compounds. In the chat path, every task is 4-5 context-switches you do manually. In Claude Code, every task is "describe what you want, verify what Claude did." Hours per day become minutes.

## The rule

> A chat is a consultant — talks well, hands you the work to execute. An agent is an employee — takes action with consequences. Your job as the operator is to give the employee good instructions, watch what it does, and verify its results. Not all chat advice transfers — the employee mental model is different.

## Common mistakes

**Mistake 1 — Treating Claude Code like a smarter chat.** You ask vague questions and accept vague work. The chat mental model rewards this because vague output is harmless — you just don't paste it. Claude Code's vague output is files that got written, commands that got run, real changes you have to undo. Be specific.

**Mistake 2 — Skipping the verification step.** The agent reports "I made the changes you asked for." You believe it. Maybe true; maybe it ran into something and improvised. Read the actual diff (`git diff`). Run the actual test. Open the actual file. Trust nothing unverified.

**Mistake 3 — Forgetting about access.** Claude Code can run any command you can run. If you're logged into a production database in this terminal, so is Claude Code. If your `.env` file has credentials, Claude Code can read them. Operators are deliberate about what's accessible from the terminal Claude Code runs in.

## Drill

You'll explore Claude Code's surface from the outside, before you actually start using it for chapter work. All three drills produce files in `student/drills/04-what-claude-code-is/`.

**Drill 1 — Run `claude --help`.** In your terminal, run `claude --help` and save the entire output to `student/drills/04-what-claude-code-is/01-claude-help.txt` (use `claude --help > path` redirect). Look through the output briefly — you don't need to understand every line. You're just confirming Claude Code is installed and looking at what it offers.

**Drill 2 — Find one feature you didn't know about.** Visit https://docs.claude.com/claude-code in your web browser. Skim the table of contents. Pick ONE feature you didn't know existed (hooks, MCP servers, skills, headless mode, etc.). Write a single sentence about it to `student/drills/04-what-claude-code-is/02-one-feature.txt`. Format: `<feature name>: <one-sentence description>`.

**Drill 3 — Name three agent-vs-chat differences.** Open a plain text file at `student/drills/04-what-claude-code-is/03-agent-vs-chat.txt`. Write 3 lines, each one a single concrete thing Claude Code does that a chat cannot. Use your own words, not the chapter's phrasing.

After all three exist, your tutor runs `verify.sh`.

## Checkpoint question

> Your friend tells you they're frustrated because Claude (the chat) keeps giving them code that "doesn't work in their app." You're about to recommend Claude Code instead. In one sentence, what is the actual difference that's going to make their experience better — and what is the single new responsibility they're taking on by switching from chat to agent?
