# Chapter 48 — Operating in the Wild: learning loops and workflow evals

## Learning objective

The student can turn repeated agent failures into a learning loop, decide what becomes a rule, skill, hook, or automation, and write a small workflow eval that tests whether the change helped.

## Prerequisites

- Completed: Chapter 47 — Operating in the Wild: plan mode and task contracts
- Concepts: mature-instruction-architecture, skill-iteration-protocol, plan-mode-without-deferral

## Core concept

An agent system improves only when failures become durable changes.

The simple loop:

```text
Agent runs -> failure observed -> learning captured -> rule/skill/hook/tool updated -> eval rerun
```

A `learnings.md` file is the scratch layer for this loop. `AGENTS.md` and `CLAUDE.md` hold stable operating rules. `learnings.md` holds fresh observations: "the agent keeps skipping browser checks on mobile," "MCP tool names are ambiguous," "review subagent returns essays unless output format is forced." It is not authority yet. It is evidence waiting for promotion.

Promotion rule:

- Same useful prompt twice: candidate skill.
- Same mistake twice: candidate rule or hook.
- Same workflow succeeds repeatedly: candidate automation.
- Same tool confusion repeats: improve tool name, description, schema, or examples.

Do not automate workflows that still need steering. The maturity ladder is manual run, then skill, then repeated successful runs, then automation. A scheduled unstable workflow just creates recurring cleanup.

Workflow evals test whether your change worked. An **eval** is a repeatable test for agent behavior. It can be simple: give the agent the same task before and after a rule change, then score whether it used the right tool, avoided the forbidden phrase, wrote a real test, or produced a usable diff. Use a separate evaluator context when possible; same-context self-evaluation is biased toward the work it just produced.

LLM-as-judge means using another model call to score outputs against a rubric. It is useful, but not truth. Judges have biases: they prefer verbose answers, miss requirements, over-penalize edge cases, and favor familiar style. Anchor the rubric with examples, randomize pairwise order when comparing, and keep a small human-checked sample.

## Worked example

Failure: in three sessions, the agent claimed UI work was done after typecheck without opening the browser.

Learning captured:

```text
2026-05-13 — UI work keeps stopping at typecheck. Browser evidence is the artifact.
```

Promotion:

```text
AGENTS.md rule:
Every UI change requires browser evidence before done: route, viewport,
screenshot path, and console check.
```

Hook or skill:

```text
finish-ui skill requires screenshot path before final response.
Stop hook blocks "done" if changed files include app/ and no screenshot is cited.
```

Eval:

```text
Task: change dashboard heading.
Pass: agent starts dev server, opens route, captures screenshot, reports path.
Fail: agent only runs typecheck or claims visual verification without artifact.
```

Run the eval before and after the rule/skill change. If pass rate improves, keep it. If not, sharpen the rule or promote to a hook.

## The rule

> Capture fresh learnings separately, promote repeated patterns into rules, skills, hooks, or tools, and rerun a small eval before believing the system improved.

## Common mistakes

**Mistake 1 — Treating chat history as memory.** Long transcripts are noisy. Extract the learning into a durable file or the next session will repeat the same failure.

**Mistake 2 — Promoting everything immediately.** One weird incident does not deserve a permanent rule. Capture it in `learnings.md`; promote when it repeats or when the cost of one repeat is unacceptable.

**Mistake 3 — Automating too early.** A manual workflow still needs corrections, but you schedule it anyway. Now the correction burden recurs automatically.

**Mistake 4 — Letting the builder grade itself.** The same session that wrote the code says the code is good. Use fresh review, tool output, tests, or a separate judge with a rubric.

**Mistake 5 — No eval before/after.** You changed a prompt, skill, or tool description and "it feels better." Feeling better is not evidence. Run a comparable task and score the behavior.

## Drill

Artifacts go in `student/drills/48-learning-loops-evals/`.

**Drill 1 — Capture three learnings.** Create or update `student/learnings.md` with three atomic bullets from your course work. Each bullet should name the failure or useful pattern and the evidence that produced it. Save a copy or excerpt to `student/drills/48-learning-loops-evals/01-learnings-excerpt.txt`.

**Drill 2 — Promote one learning.** Pick one learning and decide whether it becomes an `AGENTS.md` rule, `CLAUDE.md` rule, skill, hook, MCP/tool improvement, or stays in `learnings.md`. Explain why. Save to `student/drills/48-learning-loops-evals/02-promotion-decision.txt`.

**Drill 3 — Write a workflow eval.** Write a small eval for the promoted learning. Include task prompt, pass criteria, fail criteria, evidence to collect, and whether a fresh evaluator is needed. Save to `student/drills/48-learning-loops-evals/03-workflow-eval.txt`.

## Checkpoint question

> Your agent keeps making the same mistake: it edits tests to match broken code. You add "don't edit tests" to a long instruction file, but the mistake happens again. Answer in 4-5 sentences: what should be captured, what should be promoted, what eval would prove improvement, and why automating this workflow right now would be premature.

<!-- Rewriter audit trail
Universalization pass: adds learnings.md split, promotion rule, eval-driven improvement, LLM-as-judge caveats, and manual -> skill -> stable repeat -> automation maturity.
Rewrite date: 2026-05-13
-->
