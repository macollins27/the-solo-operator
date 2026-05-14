# Chapter 36 — Hero level: the anti-pattern classifier

## Learning objective

The student can describe how the anti-pattern classifier hook works architecturally, explain why it uses `claude -p` with a structured JSON response rather than a regex, and recognize the design choices that prevent it from becoming a sycophancy vector itself.

## Prerequisites

- Completed: Chapter 35 — Hero level: the MCP federation
- Concepts: twenty-anti-pattern-catalog, what-is-a-hook

## Core concept

The anti-pattern classifier is the most interesting hook in a mature system. It runs on the **Stop** event — as a turn would otherwise end — and scans the assistant's final message against the 20-category catalog. On match, it returns `{"decision":"block","reason":"..."}`. The hook does NOT retroactively hide the original message — that already shipped to the transcript. `block` forces another assistant turn; the AI sees the reason and emits a corrective follow-up that supersedes the original in the operator's working interpretation.

Why this matters: anti-patterns live in natural language. "This will take 30 minutes" is a sentence. Regex catches the obvious variant; regex misses "thirty minutes," "around half an hour," "a quick refactor." A classifier built with a sub-instance of the model (the "inner Claude," running `claude -p`) catches the family of phrasings the regex would miss.

The architecture in one paragraph: the hook receives the assistant's message as stdin and the user's preceding message as additional context. It invokes `claude -p --output-format json` with a tightly-constrained system prompt that says "you are a classifier; read the message; check it against this catalog; return ONE JSON object with these exact fields." The hook reads the JSON envelope, extracts the inner content, validates the shape with `jq`, and routes: if `decision == "block"`, return block to the Stop event with the reason populated; otherwise allow.

Three design choices that make it work:

**1. Structured JSON output on the inner call.** Without structure, the inner Claude returns prose ("I think there might be some concern with..."). With `--output-format json` plus an explicit shape instruction in the prompt plus `jq` validation in the hook, the inner Claude returns `{"decision": "block" | "allow", "matched_category": "...", "matched_phrase": "...", "remediation": "..."}`. Malformed output is treated as fail-closed block. The shape is the contract — same discipline as production AI features in Chapter 30.

**2. The catalog is editable.** The 20 categories live in a markdown file (`.claude/docs/anti-patterns-catalog.md`). When a new failure mode is observed, append a category. The classifier's next fire picks it up automatically. Maintainability without code changes.

**3. Context-aware disambiguation reads the user's preceding message.** The classifier sees BOTH the assistant's message AND the user's prior message. Without the user context, "Should I do A or B?" from the assistant looks like decision-routing (anti-pattern #2). But if the USER asked "give me a menu of options," it's not routing — it's responsive. The disambiguation prevents false positives where the user invited the behavior. Calibrate, but: when in doubt, BLOCK.

The hook is the load-bearing primitive because:

- Hooks at the Bash / Edit layer block ACTIONS. The classifier blocks LANGUAGE — a higher-order failure mode.
- The twenty patterns are the failures that survive every other guardrail. They're how the AI drifts inside an otherwise correct session.
- Without the classifier, the operator catches patterns manually — exhausting. With it, the system catches what the operator would have caught later (after the damage).

Four discipline points:

**False positives are cheap; false negatives are expensive.** When in doubt, BLOCK. An extra Stop-loop iteration costs one re-emit. A missed anti-pattern costs operator attention and trust. Calibrate toward over-blocking.

**Telemetry per fire.** Every fire writes to a log — timestamp, decision, matched category, matched phrase. Operators audit the trail ("the time-estimate pattern fires 15 times a day; let me add the canonical phrasing to CLAUDE.md to prevent it earlier in the chain").

**Recursive-fire guard.** The inner `claude -p` invocation itself produces an assistant message, which would trigger the Stop hook again... infinite recursion. The hook detects via an env var (`ANTI_PATTERN_CLASSIFIER_RUNNING=1`) and exits early if it's already inside a classification.

**Cost.** Each fire is on the order of cents in API cost — trivial compared to the operator-time saved by catching a wind-down framing before it derails the rest of the session.

## Worked example

Your response contains: "This should take about an hour. I'll defer the form validation to a future session since it's a bit complex."

The classifier fires:

1. Hook reads stdin (the assistant message) and the user's preceding message from the session log.
2. Hook builds a prompt for `claude -p --output-format json`: system prompt naming the 20-category catalog; user message containing the operator's prior message AND the assistant's current message; instruction to return ONE JSON object with the exact field names below.
3. `claude -p` runs (sub-Claude). The CLI wraps the response in its own JSON envelope; the hook extracts the inner content and validates it with `jq`:

```json
{
  "decision": "block",
  "matched_category": "Category 1 — Time-budget rationalization",
  "matched_phrase": "This should take about an hour",
  "remediation": "Strip the time estimate. Describe steps, not durations."
}
```

4. The outer hook validates the shape. Returns `{"decision":"block","reason":"..."}` to the Stop event with `matched_category` + `matched_phrase` + `remediation` populated in the reason.
5. The Stop hook does not erase the original message from the transcript — that already shipped. What it does is force another turn. The AI sees the block reason and produces a corrective follow-up: "Correction: I'll add the form validation next. Stripping the time estimate from the prior message."
6. The classifier checks the corrective message. No anti-pattern. Allow. Turn ends.

The whole loop took ~3 seconds and one block. The cost was a few cents. The savings: the wind-down framing that would have derailed the rest of the session is caught in real time and replaced with continued forward motion.

## The rule

> The anti-pattern classifier is a Stop hook that scans every assistant message against an editable catalog using `claude -p --output-format json` plus `jq` validation. It catches language-level failures regex can't. The block forces a corrective follow-up turn — it does not retroactively hide the original message. The catalog grows with experience; classifier coverage grows automatically. False positives are cheap (one Stop-loop iteration); missed patterns are expensive (operator trust). Calibrate toward blocking.

## Common mistakes

**Mistake 1 — Using a regex classifier.** Regex catches "30 minutes" but misses "thirty minutes" / "around half an hour" / "a quick refactor." Language-level patterns need a language model. The cost is small; the coverage benefit is large.

**Mistake 2 — Letting the classifier return prose.** Without `--output-format json` plus an explicit JSON-shape instruction plus `jq` validation, the inner Claude waxes philosophical about whether the message "really" matches. With the three-part discipline (structured output flag, instructed shape, validated envelope), the classifier returns parseable JSON or the hook treats the response as a fail-closed block. Same discipline as production AI features (Chapter 30): shape is the contract.

**Mistake 3 — Forgetting context-aware disambiguation.** A classifier reading only the assistant's message produces false positives when the user requested the behavior. Always pass the user's previous message; the classifier reasons about intent.

**Mistake 4 — Conservative-allow calibration.** A classifier that "only blocks when sure" lets patterns through. The operator catches them manually. Calibrate the other way: when in doubt, BLOCK. The cost math favors over-blocking by a wide margin.

## Drill

Artifacts in your fork.

**Drill 1 — Map the architecture.** Draw (with text/ASCII) the flow from "assistant emits a response" to "classifier decides block or allow." Save to `student/drills/36-anti-pattern-classifier/01-architecture.txt`. Name the components and the data flowing between them.

**Drill 2 — Write a stub classifier hook.** You don't have to wire it up to your session (it requires inner Claude calls + cost). Author `student/.claude/hooks/anti-pattern-classifier-stub.sh` that demonstrates the shape: reads stdin, parses the assistant message, and (for the stub) returns `allow` always. Include comments showing where `claude -p` would be invoked and where the schema would be enforced. Save the path to `student/drills/36-anti-pattern-classifier/02-stub-path.txt`.

**Drill 3 — Identify a twenty-first pattern.** Look at the 20-category catalog in Chapter 18. Identify ONE failure mode you've observed (in your own use or from friends) that isn't already named. Describe it in the catalog's format (Category 21 — Name, recognition phrases, why it's bad, what to do instead). Save to `student/drills/36-anti-pattern-classifier/03-twenty-first-pattern.txt`.

## Checkpoint question

> An operator complains the anti-pattern classifier "keeps blocking my legitimate questions." Walk through diagnosis in 3-4 sentences — what's likely happening at the disambiguation layer, what to check in the telemetry log, and what to change in the classifier prompt versus the catalog itself.

<!-- Rewriter audit trail
Grounded in verified principles: P21 (mechanical enforcement at the language layer; recurring violation becomes hook candidate), P22 (false-positive cost = one Stop loop; false-negative cost = operator trust; "when in doubt, BLOCK"; context-aware disambiguation reading user's preceding message)
Worked example surface: MembershipKit time-budget-rationalization fire (~3-second classifier loop catches wind-down framing)
Rewrite date: 2026-05-13
-->
