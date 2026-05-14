# Chapter 6 — The conversation loop and context window

## Learning objective

The student can describe a Claude Code session as a conversation of alternating turns, explain what a context window is and why it's finite, and recognize when context size is the constraint behind a session's behavior.

## Prerequisites

- Completed: Chapter 5 — Your first Claude Code session
- Concepts: tool-call-rendering, session-state-is-not-persistent-yet

## Core concept

Every Claude Code session is a **conversation** built from **turns**.

A turn is one exchange: you say something, Claude responds. Claude's response is text plus tool calls. The conversation is the list of turns plus the hidden system prompt and project instructions.

What Claude can "see" right now is everything in the conversation up to this point. Not before this session. Not in some external memory. Just this conversation. That visible region is called the **context window**.

The context window is **finite**. A token is roughly one short word or a few characters. A page of prose is hundreds of tokens; a source file can be thousands.

For short tasks, this feels huge. But context fills with everything: instructions, messages, file reads, and command output.

When context fills, the agent may **compact** older conversation into a summary. Compaction is helpful but lossy: details get dropped. You can also trigger compaction yourself at any point with the `/compact` slash command — useful when you can feel the session is getting long but you're not ready to `/exit`.

Managing that visible region is **context engineering**: choosing what enters working memory, what stays on disk, what gets summarized, and what gets isolated elsewhere.

Four operations matter (the framing here follows Anthropic's engineering writing on context engineering):

**Offload.** Move state out of chat and into files, specs, databases, MCP servers, or decision logs.

**Reduce.** Compress old work into short handoffs or summaries without losing authority.

**Retrieve.** Pull in only the relevant file, command output, or query result when needed.

**Isolate.** Put separate work in fresh sessions, subagents, or worktrees so one thread's assumptions do not pollute another.

This is why operators care about context. Three reasons:

**One — bigger conversations are slower.** Each turn reprocesses the window.

**Two — important details can fall out.** If a detail matters, write it to a file the agent can re-read.

**Three — a fresh session is sometimes right.** If the conversation drifts or compaction muddles framing, restart with a clean handoff.

A few discipline points operators use:

- Don't paste giant files if the agent can read the relevant slice.
- Don't `Read` files Claude doesn't need for the current task. Each read is tokens you can't get back.
- Use instruction files for load-bearing project rules instead of repeating them every session.
- Save important state to files (session-state docs, decisions logs) so a fresh session can pick up where the last one left off by re-reading them.

The failure vocabulary (a taxonomy adapted from Drew Breunig's writing on how context goes wrong):

- **Context poisoning:** a wrong assumption enters the thread and becomes treated like memory.
- **Context distraction:** irrelevant files or logs pull attention away from the actual task.
- **Context confusion:** stale notes or abandoned plans influence the answer.
- **Context clash:** two sources disagree and the agent averages them instead of resolving authority.

The conversation loop is the unit of work. Across turns: you direct, verify, redirect, and manage what enters context.

## Worked example

Open Claude Code in your course repo. Try this short conversation:

```
Turn 1: "Read README.md and tell me what this course is about in 2 sentences."

(Claude reads README.md, replies in 2 sentences. README is now in your context.)

Turn 2: "What was the second sentence you just wrote?"

(Claude answers from memory — no new tool calls. The conversation now includes both your messages and Claude's reply.)

Turn 3: "Read CHAPTER_SCHEMA.md and compare it to CLAUDE.md. Where do they overlap?"

(Claude reads two more files. They are now in context.)

Turn 4: "Forget all that. Tell me a joke."

(Claude tells a joke. The earlier files are still in context — you can't actually "forget all that" — but Claude shifts to a different task.)
```

Now `/exit` and restart `claude`. Try Turn 2 again: "What was the second sentence you just wrote?" Claude has no idea. New session, new context, no memory of the prior conversation.

That's the conversation loop. That's the context window.

## The rule

> Treat the context window as a finite shared workspace. Put what's load-bearing into it deliberately; keep what isn't out. When the session drifts, restart — a fresh context is faster, cleaner, and easier to direct than a polluted one.

## Common mistakes

**Mistake 1 — Pasting huge files into chat.** Someone asks you to share a 2,000-line config file with Claude. You paste it. The whole thing enters context — 8,000+ tokens — even if Claude only needed to look at one section. Better: save the file in the project, ask Claude to `Read` it. Claude controls what part it pulls in.

**Mistake 2 — Re-asking the same thing instead of restarting.** A session has been going for two hours and Claude is starting to get confused — answering an earlier question instead of your latest one, or repeating things. You re-explain harder. You add more clarifications. Each new turn makes the context worse. The right move is `/exit` and start fresh with a tight first prompt that gets to the point.

**Mistake 3 — Assuming Claude remembers between sessions.** You have a great session, solve a hard problem, exit. The next day you start `claude` and reference the prior solution. Claude has no idea what you mean. Sessions are independent. If something needs to persist, write it down — in a file, in `CLAUDE.md`, in a session-state doc Claude can re-read.

**Mistake 4 — Calling more context "better context."** You tag every file in the repo because you want the agent to be informed. Now relevant code, stale comments, old plans, and irrelevant logs all compete. Good context is the smallest high-signal set that lets the agent act correctly.

## Drill

You'll experiment with the conversation loop and capture observations. Artifacts go in `student/drills/06-conversation-loop-and-context/`.

**Drill 1 — Count the turns.** Open Claude Code in your course repo. Have a short conversation (4–6 turns) about anything you want. Don't worry about the topic. After exiting, write a single text file at `student/drills/06-conversation-loop-and-context/01-my-conversation.txt` with: (a) the number of turns you had, (b) how many of those turns triggered tool calls (Claude doing something, not just talking).

**Drill 2 — Test the memory boundary.** Start a fresh session. Tell Claude: "Remember the number 7,341. I'll ask you about it later." Have 2-3 more turns about anything else. Then ask: "What number did I ask you to remember?" Save Claude's response to `student/drills/06-conversation-loop-and-context/02-memory-test.txt`. (It should remember; it's still in the window.)

**Drill 3 — Test the session boundary.** `/exit` the session you just had. Run `claude` again. In the FIRST message, ask: "What number did I ask you to remember earlier?" Save Claude's response to `student/drills/06-conversation-loop-and-context/03-session-boundary.txt`. (It should not remember — new session, new context.)

After all three exist, run the chapter's `verify.sh`.

## Checkpoint question

> You've been in a Claude Code session for 90 minutes. You've read 12 files, run 8 commands, and Claude has just started giving slightly off answers — like it's missed a detail you established earlier. Why is this happening, which context-engineering failure might be present, and what's the cheaper move: explaining more, or restarting?

<!-- Rewriter audit trail
Mechanical chapter — turns, context window, compaction, fresh-session-as-tool. Sets up P57 (memory before compaction) which Chapter 16 develops. Core untouched in this rewrite pass.
Rewrite date: 2026-05-13
-->
