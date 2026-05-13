# Chapter Schema — locked

Every chapter in every Part of this course follows the same shape. Same section names, same order, same bounds. This consistency is what makes the course AI-extractable. Claude reads a chapter and extracts precise sections, not paraphrased prose. The student gets the same teaching experience whether the chapter is about installing a terminal or composing a 30-agent pipeline.

If you're authoring a chapter, do not invent new sections. Do not skip sections. Do not reorder. Every chapter is the same shape from outside; the substance varies inside the bounded sections.

## File layout per chapter

Every chapter ships THREE files in its own directory:

```
parts/{part_number}-{part_slug}/{chapter_number}-{chapter_slug}/
├── chapter.md       ← the content, schema-bound
├── verify.sh        ← the mechanical check
└── meta.yml         ← machine-readable metadata
```

## chapter.md — the schema

```markdown
# Chapter N — Title

## Learning objective

One sentence. What the student can do after this chapter that they
could not do before. No fluff. "The student can write a CLAUDE.md
that survives a session restart." Not "The student understands how
CLAUDE.md works."

## Prerequisites

A short list. Which prior chapters must be completed. Which concepts
must already be in student_state.concepts. The MCP server reads this
to enforce ordering.

- Completed: Chapter X — Title
- Completed: Chapter Y — Title
- Concepts: auth-loop, tRPC-procedure

## Core concept

The single idea this chapter teaches. 300–500 words MAX. Dense, not
prose. Define every technical term inline the first time it appears.
No "in this chapter we will explore..." — go straight to the idea.

If the concept needs more than 500 words to land, the chapter is too
big. Split it.

## Worked example

A concrete code/command/scenario demonstrating the concept. Verbatim
and copy-pasteable against the canonical project. If it references
files, the references are real paths in `canonical-project/`. If it
references a command, the command actually runs on the student's
machine.

Code blocks are syntax-highlighted. Inline output is shown where it
illustrates the lesson.

## The rule

The actionable takeaway in one or two sentences. Memorizable. The
student should be able to recite this. Format:

> When you {situation}, do {action}. Never {anti-action}.

## Common mistakes

3–5 specific failure modes. Each one is named (so the student can
recognize it later) and described with the exact phrases or shapes
the student will encounter. Not "students sometimes get confused" —
specific patterns.

**Mistake 1 — {short name}.** {What it looks like, in 1–3 sentences.
The recognition phrase or pattern.}

**Mistake 2 — {short name}.** ...

**Mistake 3 — {short name}.** ...

## Drill

What the student does on their own machine in their fork of the
course repo. Three micro-exercises, not one big one. Each:

- Starter state (file content / command to run / scenario to set up)
- The action the student takes
- The "done when" criterion the student can self-check
- Note the `verify.sh` is the authoritative check; the student's
  self-check is a coarser guide

**Drill 1 — {name}.** ...

**Drill 2 — {name}.** ...

**Drill 3 — {name}.** ...

After all three drills, the student runs `verify.sh` to confirm
mechanical completion, then answers the checkpoint question.

## Checkpoint question

ONE question Claude asks the student before marking the chapter
complete. Phrased so the answer requires the student to demonstrate
they understood the concept, not just executed the drill.

Format:

> {Question that probes the WHY of the rule, not the WHAT of the
> drill.}

Good: "If the AI gave you back a 50-line patch and said 'this fixes
the bug,' what would you do before believing it?"

Bad: "What does the two-option rule say?" (Recitation, not
understanding.)
```

## Hard bounds per section

| Section | Target | Hard max |
|---|---|---|
| Learning objective | 1 sentence | 2 sentences |
| Prerequisites | 1–5 items | 8 items |
| Core concept | 300 words | 500 words |
| Worked example | 100–300 words + code | 400 words + code |
| The rule | 1 sentence | 2 sentences |
| Common mistakes | 3 mistakes | 5 mistakes |
| Drill | 3 micro-exercises | 4 micro-exercises |
| Checkpoint question | 1 question | 1 question |
| **Total chapter** | **800–1,200 words** | **1,500 words** |

If a chapter is approaching the hard max, the chapter is too big. Split it.

## verify.sh — the schema

```bash
#!/usr/bin/env bash
# verify.sh — mechanical check for Chapter N — Title
#
# Run from the student's fork root. Exits 0 if the chapter's drill
# is complete; exits non-zero with a specific message otherwise.

set -euo pipefail

STUDENT_ROOT="${1:-./student}"

# Check 1 — file exists / command succeeds / pattern present
# ...

# Check 2 — ...

# Check 3 — ...

echo "Chapter N verified."
```

Every `verify.sh`:

- Takes the student fork root as `$1`, defaults to `./student`
- Exits 0 on success, non-zero on first failure
- Prints a specific message on each failure naming what's missing
- Does NOT depend on AI judgment — purely mechanical (grep / file
  exists / command exits 0)
- Is fast (< 5 seconds) so the student doesn't wait

The pedagogy SKILL calls `verify.sh` and reads the exit code. The
student does not have to read its source.

## meta.yml — the schema

```yaml
chapter:
  number: 12
  part: 2
  slug: two-option-rule
  title: "The Two-Option Rule"

learning_objective: >
  The student can recognize, in real-time, when their AI is silently
  continuing past an error instead of fixing or surfacing it, and
  intervene with the correct redirect.

prerequisites:
  chapters_completed:
    - 11  # AI is a Junior Dev
  concepts_required:
    - what-is-an-ai-agent
    - what-is-a-tool-call

concepts_taught:
  - two-option-rule
  - silent-continuation-failure-mode

complexity: medium    # low | medium | high
recall_chapters:      # spaced-repetition triggers
  - 14   # comes up when teaching "verify the artifact"

drill:
  artifact: parts/02-mindset/12-two-option-rule/verify.sh
  produces:
    - student/drills/12-two-option-rule/transcript-annotated.md
```

Fields:

- `chapter.{number, part, slug, title}` — identity
- `learning_objective` — same as in chapter.md, in one place the MCP can index
- `prerequisites.chapters_completed` — chapter numbers required before this one
- `prerequisites.concepts_required` — concept slugs that must be in `student_state.concepts`
- `concepts_taught` — concept slugs this chapter adds to student state
- `complexity` — low / medium / high. Used for adapting pace, NOT for time estimates. Never a clock value.
- `recall_chapters` — chapter numbers that should reference this one via spaced repetition
- `drill.artifact` — path to verify.sh
- `drill.produces` — files the student commits to their fork as proof-of-drill

## Why this schema specifically

**Same shape everywhere = AI-extractable.** Claude reads `Core concept` and gets a 300–500 word dense block, every time. Claude reads `The rule` and gets one sentence, every time. The MCP server can extract `learning_objective` for chapter 12 without scanning prose for the implicit objective. Consistency is the contract.

**Bounded sections = no chapter is too big.** When a chapter wants to exceed Core Concept's 500 words, that's the signal to split. The schema enforces atomic scope.

**Three artifacts per chapter (chapter.md + verify.sh + meta.yml) = mechanical advance.** Without verify.sh, Claude has to trust the student's claim of completion — which is sycophancy in disguise. With verify.sh, advance is determined by the exit code. The student can't fool the system; the system can't fool the student.

**Checkpoint question separate from drill = comprehension separate from execution.** A student can execute a drill by copying the worked example, never understanding why. The checkpoint question probes WHY. Both must pass before advancing.

## Common authoring mistakes

**Mistake — long prose.** A chapter that explains the concept in 1,500 words instead of 400 is teaching for a human reader, not for Claude to extract. Density beats length. Cut.

**Mistake — vague learning objective.** "The student understands X" is not testable. Replace with "The student can do X" — specific, testable, demonstrable.

**Mistake — drill that doesn't produce artifacts.** If the drill doesn't write a file the student commits, there's nothing for verify.sh to check. Every drill produces at least one concrete artifact.

**Mistake — checkpoint question that asks for recitation.** "What is the two-option rule?" tests memorization, not understanding. Phrase the question so the answer requires the student to APPLY the rule to a fresh scenario.

**Mistake — references to time.** "This chapter should take 20 minutes" is a time estimate, which is its own anti-pattern. Use `complexity: low/medium/high` in meta.yml instead. Never a clock.

## Authoring a chapter against this schema

When writing chapter N:

1. Open `meta.yml` first. Fill in identity, prerequisites, concepts_taught, complexity. This anchors the chapter's place in the course.
2. Write `chapter.md` against the schema sections in order. Do not skip. Do not invent.
3. Write `verify.sh` to mechanically check the drill's produced artifacts.
4. Smoke-test by running `verify.sh` against a freshly-completed drill in the reference `canonical-project/`.
5. Verify total chapter word count is within bounds (800–1,500).
6. Commit the triplet (chapter.md + verify.sh + meta.yml).

If you cannot fit a chapter within the bounds, split into two chapters. Never bend the schema to accommodate scope; bend the scope to accommodate the schema.
