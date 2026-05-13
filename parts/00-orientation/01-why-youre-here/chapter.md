# Chapter 0 — Why You're Here

## Learning objective

The student can explain in their own words the difference between "prompting an AI" and "operating an AI engineering system," and why the second is what this course teaches.

## Prerequisites

None. This is the orientation chapter.

- Completed: (none)
- Concepts: (none)

## Core concept

Most people who use AI to write code are PROMPTING. They open a chat, describe what they want, take the output, paste it somewhere, and hope. When it works, great. When it doesn't, they prompt again. The relationship is request-and-receive, like ordering at a counter.

OPERATING an AI engineering system is different. You're not a customer; you're a manager. You set up the rules the AI works by. You decide what tools it can use. You catch its failures before they ship. You build deterministic guardrails around its non-deterministic output. You read its work, not just its claims. Over time you build a SYSTEM — a set of rules, hooks, skills, and indexes that make YOUR AI produce work nobody else's AI can produce.

The difference matters because PROMPTING plateaus. After a few weeks you've extracted most of what a chat interface can give you. You're better than you started but you're stuck near the average. OPERATING compounds. Every rule you write makes every future session better. Every hook you add catches a class of failure forever. Every skill you author becomes a workflow you can run with one word. The system you build is yours — non-portable, non-replicable, an actual moat.

This course teaches operating, not prompting. You'll learn the principles (how to think about AI as a teammate), the mechanics (how to configure Claude Code, write skills, write hooks, run subagents, query your own data), and the meta-skill (how to author your own rules when you get bitten by something new). By the end you'll have built a working piece of software AND a system that produces software, both yours, both compounding.

## Worked example

Imagine two people building the same small app — a to-do list with sharing between friends.

PERSON A prompts. They open Claude, say "make me a to-do app," get HTML, JavaScript, and a database file. It mostly works. They prompt for tweaks. After two weeks they have a working app and a chat history full of half-remembered solutions. If they want to add a new feature, they prompt from scratch. The Claude they used yesterday and the Claude they're using today don't know each other.

PERSON B operates. Day one they write a one-page `CLAUDE.md` describing their app's goals and rules ("every database column has a created_at, no money fields are floats, every form has CSRF protection"). Day two they add a hook that runs the linter on every file Claude writes. Day three they add a skill called `/add-feature` that walks Claude through their preferred feature pattern. Day five they've added an MCP server that lets Claude query their database schema directly. After two weeks Person B has the same working to-do app — but also a SYSTEM. Their CLAUDE.md is law. Their hooks block the failures they've seen. Their skill makes new features cheap. Their MCP makes the AI smarter than yesterday.

By month two, Person A's progress is linear. Person B's is exponential. Person B is becoming a solo operator.

## The rule

> You are not a customer; you are a manager. The AI is your team. Build the system that makes the team produce excellent work, not the prompt that asks the AI to please be good.

## Common mistakes

**Mistake 1 — Thinking the AI is the product.** Beginners optimize the prompt. Operators optimize the SYSTEM around the AI: rules, hooks, skills, indexes. The prompt matters but it's the smallest lever. Reach for it last.

**Mistake 2 — Treating each session as fresh.** Without a system, you re-explain your project every session. With a system, the AI re-orients itself in seconds because your `CLAUDE.md`, your skills, and your MCP servers tell it what it needs to know. Sessions compound; conversations don't.

**Mistake 3 — Trusting AI summaries.** "I fixed the bug." "The tests pass." "The build is clean." These are claims, not facts. Operators verify by reading the actual diff, log, or screenshot. Prompters take the summary at face value and ship.

## Drill

This chapter has no machine-checkable drill. The orientation chapter's drill is to do the next three things in order, on your own machine, while I (Claude) walk you through them in the next chapter:

**Drill 1 — Install Claude Code.** Follow the README at the root of this course repo. After this drill, `claude` runs in your terminal.

**Drill 2 — Open this repo in Claude Code.** Navigate to the repo directory in your terminal, run `claude`, and confirm you see a welcome message.

**Drill 3 — Type "teach me."** I will read your state (none yet — you're a new student), call this orientation chapter, and start your real first chapter.

You complete these by reaching Chapter 1 in the AI tutor. There is no verify.sh for this orientation chapter; the proof of completion is that you're talking to Claude inside the repo and you've reached the next chapter.

## Checkpoint question

> In your own words, what is the difference between PROMPTING an AI and OPERATING an AI engineering system, and which one does this course teach? Give one specific example of something an "operator" would do that a "prompter" wouldn't.
