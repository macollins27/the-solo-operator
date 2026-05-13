# Chapter 6 — The conversation loop and context window

## Learning objective

The student can describe a Claude Code session as a conversation of alternating turns, explain what a context window is and why it's finite, and recognize when context size is the constraint behind a session's behavior.

## Prerequisites

- Completed: Chapter 5 — Your first Claude Code session
- Concepts: tool-call-rendering, session-state-is-not-persistent-yet

## Core concept

Every Claude Code session is a **conversation** built from **turns**.

A turn is one exchange: you say something, Claude responds. Claude's response is a mix of text and tool calls. The conversation is the list of all turns in order, plus the **system prompt** at the start (a hidden instruction Claude reads first, set by Claude Code and your `CLAUDE.md`).

What Claude can "see" right now is everything in the conversation up to this point. Not before this session. Not in some external memory. Just this conversation. That visible region is called the **context window**.

The context window is **finite**. Modern Claude models can hold somewhere between 200,000 and 1,000,000 tokens of context, depending on the model. A token is roughly one short word or three characters — about 0.75 of an English word on average. A page of plain prose is ~500 tokens. A medium-sized source file is 5,000–20,000 tokens. The whole text of Pride and Prejudice is ~180,000 tokens.

This number sounds huge, and for short tasks it is. But Claude's context fills with everything: the system prompt, your `CLAUDE.md`, every message in the conversation, every file Claude reads (the full contents — Claude doesn't just look at a "summary"), every command's output. A session that reads three large files and runs five commands and has 20 turns of conversation can spend 100,000+ tokens easily.

When the context window fills, Claude Code does **compaction** — it summarizes older parts of the conversation to make room. You'll see a message like "Compacting conversation..." Compaction is helpful, but lossy: details get dropped. A fact established 50 turns ago that wasn't in the most recent 10 turns might quietly disappear.

This is why operators care about context. Three reasons:

**One — the bigger the conversation, the slower it gets.** Each turn, Claude re-reads everything in the window. Token by token. A 200k-token conversation costs more per turn than a 5k-token one. You feel the slowdown.

**Two — important details can fall out.** Stuff you mentioned 80 turns ago, before the most recent edit, might not survive compaction. If the detail matters, restate it or commit it to a file Claude can re-read.

**Three — a fresh session is sometimes the right move.** When a conversation has drifted, when you've packed it with files Claude didn't really need, when compaction has muddied the early framing — `/exit` and restart. You'll lose the conversation but gain a clean window.

A few discipline points operators use:

- Don't paste a giant file into the conversation if Claude can just `Read` it from disk. The Read tool's output enters context too, but only when needed.
- Don't `Read` files Claude doesn't need for the current task. Each read is tokens you can't get back.
- Use `CLAUDE.md` to put load-bearing project rules in the system prompt instead of repeating them every session.
- Save important state to files (session-state docs, decisions logs) so a fresh session can pick up where the last one left off by re-reading them.

The conversation loop itself is the unit of work. Within a turn: you describe what you want, Claude plans, Claude calls tools, Claude reports. Across turns: you direct, verify, redirect. Most operator skill is in this loop — being deliberate about what enters the context and being honest about what to do when the loop drifts.

## Worked example

Open Claude Code in your course repo. Try this short conversation:

```
Turn 1: "Read README.md and tell me what this course is about in 2 sentences."

(Claude reads README.md, replies in 2 sentences. README is now in your context.)

Turn 2: "What was the second sentence you just wrote?"

(Claude answers from memory — no new tool calls. The conversation now includes both your messages and Claude's reply.)

Turn 3: "Read CHAPTER_SCHEMA.md and compare it to what's in CLAUDE.md. Where do they overlap?"

(Claude reads two more files. Now your context contains: README.md, Claude's summary, your follow-up, Claude's reply, CHAPTER_SCHEMA.md, CLAUDE.md, and Claude's comparison.)

Turn 4: "Forget all that. Tell me a joke."

(Claude tells a joke. The earlier files are still in context — you can't actually "forget all that" — but Claude shifts to a different task.)
```

Now `/exit` and restart `claude`. Try Turn 2 again: "What was the second sentence you just wrote?" Claude has no idea. New session, new context, no memory of the prior conversation.

That's the conversation loop. That's the context window. Everything else in the course is built on top of these two ideas.

## The rule

> Treat the context window as a finite shared workspace. Put what's load-bearing into it deliberately; keep what isn't out. When the session drifts, restart — a fresh context is faster, cleaner, and easier to direct than a polluted one.

## Common mistakes

**Mistake 1 — Pasting huge files into chat.** Someone asks you to share a 2,000-line config file with Claude. You paste it. The whole thing enters context — 8,000+ tokens — even if Claude only needed to look at one section. Better: save the file in the project, ask Claude to `Read` it. Claude controls what part it pulls in.

**Mistake 2 — Re-asking the same thing instead of restarting.** A session has been going for two hours and Claude is starting to get confused — answering an earlier question instead of your latest one, or repeating things. You re-explain harder. You add more clarifications. Each new turn makes the context worse. The right move is `/exit` and start fresh with a tight first prompt that gets to the point.

**Mistake 3 — Assuming Claude remembers between sessions.** You have a great session, solve a hard problem, exit. The next day you start `claude` and reference the prior solution. Claude has no idea what you mean. Sessions are independent. If something needs to persist, write it down — in a file, in `CLAUDE.md`, in a session-state doc Claude can re-read.

## Drill

You'll experiment with the conversation loop and capture observations. Artifacts go in `student/drills/06-conversation-loop-and-context/`.

**Drill 1 — Count the turns.** Open Claude Code in your course repo. Have a short conversation (4–6 turns) about anything you want. Don't worry about the topic. After exiting, write a single text file at `student/drills/06-conversation-loop-and-context/01-my-conversation.txt` with: (a) the number of turns you had, (b) how many of those turns triggered tool calls (Claude doing something, not just talking).

**Drill 2 — Test the memory boundary.** Start a fresh session. Tell Claude: "Remember the number 7,341. I'll ask you about it later." Have 2-3 more turns about anything else. Then ask: "What number did I ask you to remember?" Save Claude's response to `student/drills/06-conversation-loop-and-context/02-memory-test.txt`. (It should remember; it's still in the window.)

**Drill 3 — Test the session boundary.** `/exit` the session you just had. Run `claude` again. In the FIRST message, ask: "What number did I ask you to remember earlier?" Save Claude's response to `student/drills/06-conversation-loop-and-context/03-session-boundary.txt`. (It should not remember — new session, new context.)

After all three exist, run the chapter's `verify.sh`.

## Checkpoint question

> You've been in a Claude Code session for 90 minutes. You've read 12 files, run 8 commands, and Claude has just started giving slightly off answers — like it's missed a detail you established earlier. Why is this happening, and what's the cheaper move: explaining more, or restarting?
