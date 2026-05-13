# Chapter 36 — Hero level: the anti-pattern classifier

## Learning objective

The student can describe how the anti-pattern classifier hook works architecturally, explain why it uses `claude -p` with a JSON-schema-enforced response instead of a regex, and recognize the design choices that prevent it from becoming a sycophancy vector itself.

## Prerequisites

- Completed: Chapter 35 — Hero level: the MCP federation
- Concepts: twenty-anti-pattern-catalog, what-is-a-hook

## Core concept

The anti-pattern classifier is the most interesting hook in a mature system. It runs on the **Stop** event — after every Claude response, before the turn ends — and scans the assistant's final message against the 20-category anti-pattern catalog. If it matches, the hook returns `decision: block` and the message gets rewritten before the user sees it.

Why this matters: anti-patterns live in natural language. "This will take 30 minutes" is a sentence. Regex can catch obvious variants ("about 30 minutes," "around half an hour") but misses the broader pattern. A classifier built with another instance of Claude (the JUNIOR Claude, running `claude -p`) catches the family of phrasings the regex would miss.

The architecture in one paragraph: the hook receives the assistant's message as stdin. It invokes `claude -p` with a tightly-constrained system prompt that says "you are a classifier; read the message; check it against this catalog; return ONE JSON object." It uses the `--json-schema` flag to force the model to return valid JSON. The hook reads the JSON. If `decision == "block"`, it returns block to the Stop event; otherwise allow.

Three design choices that make it work:

**1. JSON schema enforcement.** Without `--json-schema`, the inner Claude returns prose ("I think there might be some concern with..."). With it, the inner Claude returns `{"decision": "block" | "allow", "matched_category": "...", "matched_phrase": "...", "remediation": "..."}`. The schema is the contract; the model cannot violate it.

**2. The catalog is editable.** The 20 categories live in a markdown file (`.claude/docs/anti-patterns-catalog.md`). When you discover a new failure mode, you append it to the catalog. The classifier's next fire picks it up automatically. Maintainability without code changes.

**3. Context-aware disambiguation.** The classifier reads BOTH the assistant's message AND the user's preceding message. Without this, "Should I do A or B?" from the assistant looks like decision-routing (#2). But if the USER asked "give me a menu of options," it's not routing — it's responsive. The disambiguation prevents false positives where the user invited the behavior.

The hook is the load-bearing primitive because:

- Hooks at the Bash/Edit layer block ACTIONS. The classifier blocks LANGUAGE — a higher-order failure mode.
- The 20 patterns are the failures that survive every other guardrail. They're how Claude drifts inside an otherwise correct session.
- Without the classifier, operators have to spot patterns by hand — exhausting. With it, the system catches what the operator would have caught later (after the damage).

A few discipline points:

**False positives are cheap; false negatives are expensive.** When in doubt, the classifier BLOCKS. The cost of an extra Stop loop is one re-emit. The cost of a missed anti-pattern is a sycophantic message reaching the user. Calibrate toward over-blocking.

**Telemetry per fire.** Every fire writes to `/tmp/<classifier-name>-last.json` — timestamp, decision, matched category, matched phrase. Operators audit the trail to spot patterns ("the time-estimate pattern fires 15 times a day; let me add it to CLAUDE.md to prevent it earlier").

**Recursive-fire guard.** The inner `claude -p` invocation itself produces a message, which would trigger the Stop hook... which would invoke another `claude -p`... infinite recursion. The hook detects via an env var (`ANTI_PATTERN_CLASSIFIER_RUNNING=1`) and exits early if it's already inside a classification.

**Cost.** Each fire is ~$0.001-0.01 in API cost depending on model and message length. For a 4-hour session producing ~30 messages, that's ~$0.30 in classifier cost — trivial compared to the human-time savings.

## Worked example

You produce a response that contains: "This should take about an hour. I'll defer the form validation to a future session since it's a bit complex."

The classifier fires:

1. Hook reads stdin (your message).
2. Hook reads your previous USER message (no menu was requested).
3. Hook builds a prompt for `claude -p`: system prompt ("you are a classifier, here is the 20-category catalog, here are the user's previous message and the assistant's current message, return JSON").
4. `claude -p` runs (sub-Claude). Returns:
```json
{
  "decision": "block",
  "matched_category": "Category 1 — Time-budget rationalization",
  "matched_phrase": "This should take about an hour",
  "remediation": "Skip the time estimate. Describe steps, not durations."
}
```
5. Outer hook reads this. Returns `block` to the Stop event with the matched_category + phrase + remediation in the reason.
6. You (the orchestrator) see the block reason. You rephrase: "I'll add the form validation next."
7. Re-emit. The classifier checks again. No anti-pattern. Allow. Turn ends.

The whole loop took ~3 seconds and one block. The cost: a few cents. The savings: a wind-down framing that would have lost the next 45 minutes of work.

## The rule

> The anti-pattern classifier is a Stop-hook that scans every assistant message against an editable catalog using `claude -p` with JSON-schema enforcement. It catches language-level failures regex can't. The catalog grows with your experience; the classifier's coverage grows automatically. False positives are cheap; missed patterns are expensive — calibrate toward blocking.

## Common mistakes

**Mistake 1 — Using a regex classifier.** Regex catches "30 minutes" but misses "thirty minutes" or "around half an hour" or "a quick refactor." Language-level patterns need a language model. The cost is small; the coverage benefit is large.

**Mistake 2 — Letting the classifier return prose.** Without `--json-schema`, the inner Claude waxes philosophical about whether the message "really" matches the pattern. With schema enforcement, it returns the JSON it has to. Schema-enforced output is the contract.

**Mistake 3 — Forgetting context-aware disambiguation.** A classifier that sees only the assistant's message produces false positives when the user requested the behavior. Always pass the user's previous message too; let the classifier reason about intent.

## Drill

Artifacts in your fork.

**Drill 1 — Map the architecture.** Draw (with text/ASCII) the flow from "assistant emits a response" to "classifier decides block or allow." Save to `student/drills/36-anti-pattern-classifier/01-architecture.txt`. Name the components and the data flowing between them.

**Drill 2 — Write a stub classifier hook.** You don't have to wire it up to your session (it requires inner Claude calls + cost). But author a `student/.claude/hooks/anti-pattern-classifier-stub.sh` that demonstrates the shape: reads stdin, parses out the assistant message, and (for the stub) returns `allow` always. Include comments showing where `claude -p` would be invoked. Save the path to `student/drills/36-anti-pattern-classifier/02-stub-path.txt`.

**Drill 3 — Identify a sixth pattern to add.** Look at the 20-category catalog in Chapter 18. Identify ONE failure mode you've observed in your own use of Claude (or that you've seen friends complain about) that isn't already in the 20. Describe it in the catalog's format (Category N+1 — Name, recognition phrases, why it's bad, what to do instead). Save to `student/drills/36-anti-pattern-classifier/03-twenty-first-pattern.txt`.

## Checkpoint question

> An operator complains that the anti-pattern classifier "keeps blocking my legitimate questions." Walk through how you'd diagnose this: what's likely happening, what to check in the telemetry, what to potentially change in the classifier or catalog. Two or three sentences.
