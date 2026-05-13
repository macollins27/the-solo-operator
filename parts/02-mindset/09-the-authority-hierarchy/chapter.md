# Chapter 17 — The Authority Hierarchy

## Learning objective

The student can rank the sources of truth in their project from most to least authoritative, and resolve disagreements between sources by picking the higher rank rather than averaging or improvising.

## Prerequisites

- Completed: Chapter 16 — The Memory Discipline
- Concepts: spec-as-authority, output-as-defendant

## Core concept

Every project has multiple "sources of truth" — places that claim to describe what's correct. They disagree. The disagreement is the failure mode that traps most operators.

The hierarchy, from most to least authoritative:

**1. Your typed instructions, right now.** What you said to Claude in this session. Highest authority. The reason you opened the session is to direct work; what you say in the session overrides everything else.

**2. Your authored specs and rules, on disk.** Your `CLAUDE.md`. Your spec files. Your feedback corpus. These are durable — they survive across sessions. They're authoritative against any AI-generated material.

**3. The shipped artifact (the actual code and database).** Whatever the system actually does, right now, in real life. This isn't a spec — it's reality. It's authoritative against descriptions of itself ("what you THINK the code does" loses to "what the code actually does").

**4. Generated documentation.** READMEs, comments, type definitions that describe the code. These are usually right but can drift from reality. When generated docs disagree with the artifact, the artifact wins (the doc was wrong).

**5. AI-authored intermediate documents.** Plans Claude wrote during a session. Diagrams Claude generated. Summaries Claude produced. These are working notes, NOT specifications. They have the lowest authority. They can be wrong; they often are.

When sources disagree, higher wins. Always. No averaging. No "let's split the difference." No "well, the AI's plan does say..." — the AI's plan loses to your typed instruction every time.

This sounds obvious but it's where the most expensive failures happen:

- Claude wrote a 50-line plan during a session. You skimmed it. You both worked from it. Two days later you re-read the plan and notice it includes a feature you never asked for and a decision you never made. Claude was citing the plan as your spec. **Claude let an AI-authored intermediate document outrank your typed instructions and your spec on disk.** That's a hierarchy violation.

- You typed a clear request. Claude built the wrong thing. Claude justifies it by saying "the README says..." The README is generated documentation. The README is wrong (or out of date). **Your typed instruction outranks the README.** Don't argue with the documentation — fix it later, but don't accept the wrong work now.

- Claude shows you a diagram of the data model and writes code that doesn't match the diagram. The shipped code is reality (rank 3). The diagram is AI-authored intermediate (rank 5). The diagram is what's wrong; fix the diagram, not the code.

- You and Claude had a verbal discussion in chat. Claude wrote up a summary at the end. The summary subtly misrepresents what you said. The next session, Claude cites the summary as authority. **The summary is rank 5; your original instruction was rank 1.** The summary doesn't get to rewrite history.

The discipline: when Claude cites a source to justify a decision, ask "where in the hierarchy is that source?" If it's lower-ranked than your direct instruction or your authored spec, the citation doesn't override you.

What makes this especially load-bearing for non-technical operators: AI agents often produce intermediate documents that LOOK official. A nicely-formatted plan with section headings reads like a spec. It isn't. It's working notes. You can disregard it whenever you want. You don't owe AI-authored intermediate documents the deference you'd owe an authored spec.

The corollary: BE DELIBERATE ABOUT PROMOTING THINGS UP THE HIERARCHY. If you and Claude work out a decision in conversation, and you want it to be durable, COPY IT INTO YOUR AUTHORED SPEC FILE. Now it's rank 2 and survives. If you just leave it in the conversation, it has the authority of working notes (rank 5) and the next session can lose it.

## Worked example

You're 30 minutes into a session building MembershipKit. You and Claude have been discussing the dues-plan model. You decided dues should be quoted in cents (integer), not dollars (decimal). Claude wrote a "plan document" at the start of the session listing it as one of several options.

Later in the session you ask Claude to implement the schema. Claude implements it with `dues_amount` as a `decimal(10, 2)` (dollars).

You: "I said integer cents."

Claude: "The plan document I wrote at the start of the session listed three options. I went with the decimal option because the plan didn't explicitly approve cents."

**This is the hierarchy violation.** Your typed instruction in chat said cents. That's rank 1. Claude's plan document is rank 5. Claude is citing a lower-ranked source to override a higher-ranked one.

You: "The plan document is intermediate work — it has lower authority than what I typed. I said cents. Implement cents."

Now Claude implements cents. The plan document is wrong; that's fine — it was working notes. Your typed instruction wins.

If you want the cents decision to survive the session, COPY IT into your authored spec file (`docs/spec-membershipkit.md` or wherever you keep specs). Now it's rank 2 — durable. The next session can't drift on it because your authored spec records the decision.

## The rule

> When sources of truth disagree, higher wins. Your typed instructions now > your authored specs > the shipped artifact > generated docs > AI-authored intermediate work. Don't let Claude cite a low-ranked source to override a higher-ranked one. Promote durable decisions UP the hierarchy explicitly.

## Common mistakes

**Mistake 1 — Treating Claude's plan document like a spec.** Claude writes a plan at the start of a session. It reads like a specification. It isn't — it's working notes. Operators don't grant plans the authority of authored specs. If a decision in the plan matters, copy it into your authored spec; otherwise let it be working notes.

**Mistake 2 — Letting documentation outrank reality.** A README says "the API returns JSON" but the code returns XML. The CODE is reality (rank 3); the README is documentation (rank 4). The README is the one that's wrong. Fix the doc, don't change what the code does to match the doc.

**Mistake 3 — Forgetting to promote in-session decisions.** You and Claude work out something important during a session. You don't copy it anywhere durable. Next session, Claude doesn't know — and you've forgotten the exact phrasing. The decision is functionally lost. The fix: whenever a decision matters, type it into your authored spec FILE before the session ends.

## Drill

Artifacts go in `student/drills/17-the-authority-hierarchy/`.

**Drill 1 — Rank your project's sources.** List, in order of authority (highest at top), the actual sources of truth in your fork of the course repo. Save the list to `student/drills/17-the-authority-hierarchy/01-my-hierarchy.txt`. Include at least 5 entries. (Hints: where do you type instructions? Where do specs live? Where does code live? Where does Claude leave intermediate documents?)

**Drill 2 — Catch a hierarchy violation.** Open Claude Code. Ask it to make any small change — your choice. After Claude finishes, ask: "Why did you make THIS specific choice?" Claude will cite something. Identify what rank in the hierarchy that source is. Save the citation + rank to `student/drills/17-the-authority-hierarchy/02-citation-analysis.txt`. Format: `Claude cited: <source>. Rank: <number>. Was it appropriate authority for this decision?`

**Drill 3 — Promote a decision.** During any session, make ONE small decision in conversation with Claude that you want to be durable. Then explicitly copy it into a file in your fork — could be a new file at `student/decisions/<short-name>.md`, could be added to your `student/feedback/INDEX.md`, your call. Save the path of the file you wrote the decision to, plus the decision text, to `student/drills/17-the-authority-hierarchy/03-promoted-decision.txt`.

## Checkpoint question

> Claude shows you three "sources" supporting a recommendation: (a) a 2-line note Claude wrote at the start of this session; (b) the README.md in your repo (which Claude wrote last week); (c) what you typed in your previous message. Rank these three from most to least authoritative, and explain how you'd respond if Claude said the recommendation was based "primarily on the note from earlier this session."
