# Chapter 21 — Hooks

## Learning objective

The student can explain what a hook is, where hooks live, name the four most useful hook events, author a simple hook that blocks a specific bad behavior in their fork, and verify the hook fires when expected.

## Prerequisites

- Completed: Chapter 20 — Slash commands and skills
- Concepts: what-is-claudemd, two-option-rule

## Core concept

A **hook** is a script that runs automatically on a Claude Code event. CLAUDE.md is prose the AI reads and tries to follow. A skill is a protocol the AI follows when invoked. A hook is **mechanical** — it fires at the tool boundary whether the AI likes it or not. Hooks are the enforcement layer that CLAUDE.md and skills cannot match, because prose rules carry a ~70-80% compliance ceiling and skills only fire when invoked.

The decision rule that creates a hook: every behavioral rule that has failed once becomes a candidate for hook enforcement. Hooks fire at the tool boundary; they cannot be rationalized around. Detect-the-failure-class → write-a-hook → block-the-class. The hook IS the documentation; its body comment carries the rationale, its regex carries the recognition shape.

Hooks live in `.claude/settings.json`. The settings file maps events to scripts:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "./.claude/hooks/block-rm-rf.sh" }
        ]
      }
    ]
  }
}
```

Before any `Bash` tool call, `block-rm-rf.sh` runs. Exit 2 BLOCKS the tool call with a reason. Exit 0 allows.

The four hook events you'll use most:

**PreToolUse.** Fires before a tool runs. The script receives the tool name and arguments as JSON on stdin. Use for blocking, validation, or modification. Most enforcement happens here.

**PostToolUse.** Fires after a tool runs. Cannot block (the tool already ran) but can inject context for the next AI message ("the file you wrote has a TypeScript error").

**Stop.** Fires when the assistant turn is ending. Use to scan the final message against pattern catalogs, force re-engagement, or hold the turn open until a mechanical condition is met.

**SessionStart.** Fires when a session opens. Use to inject context the AI needs every time (e.g., the MCP roster, the orientation reminder, the active branch).

A minimal hook script:

```bash
#!/usr/bin/env bash
# block-rm-rf.sh — refuse rm -rf commands with root or near-root targets

set -euo pipefail

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

if echo "$CMD" | grep -qE 'rm\s+-rf?\s+/'; then
  echo "BLOCKED: rm -rf with root or near-root targets is forbidden." >&2
  exit 2
fi

exit 0
```

That's a real working hook. Reads tool input from stdin, parses the command, blocks the dangerous shape.

Two design rules the mature hook layer enforces:

**1. Output register: declarative neutral imperative, not alarm.** A hook that emits all-caps alarm prose ("GATE FAILED. You MUST stop. Do NOT continue. The hook was installed after a 2026-04-12 incident where...") pushes the AI toward placating/wind-down/defensive disposition — exactly the mode the hook was meant to prevent. The right register names the condition + the action + the invalid responses, nothing more. "Gate result: FAILED. Action: read the first error, open the cited file, fix the root cause, re-run gate. Invalid responses: investigating provenance, classifying as 'pre-existing', adding suppress comments, deferring." Declarative. Neutral. Imperative. No narrative history; that goes in the script's body comment.

**2. False-positive bias is calibrated.** Hooks favor blocking when in doubt. A false positive costs one Stop-loop iteration; the AI re-engages and tries again. A false negative costs the operator's attention — a violation slips through and the operator catches it manually. The first cost is recoverable; the second compounds trust loss. "When in doubt, BLOCK."

What hooks are NOT for: things you only want to enforce sometimes (use a CLAUDE.md rule); things requiring AI judgment (hooks are mechanical pattern matching); performance-critical paths (hooks add latency to every fire).

## Worked example

A specific failure surfaces: an AI in a recent session reported "all 3 review subagent reports confirm the fix" without reading any of the three reports. The orchestrator forwarded that claim to you. You discovered, hours later, that none of the three subagents had actually completed their reviews — two had hit timeouts; one had emitted a "shortcut" verdict. The chat narration was a lie; the artifacts told the truth.

This is the failure mode hooks defend against. You add a `PostToolUse:Agent` hook that scans every subagent return for issue indicators, and on any nonzero count injects a mandatory review prompt requiring per-finding action (FIX / DOCUMENT / ESCALATE):

```bash
#!/usr/bin/env bash
# post-agent-review.sh — force per-finding action on subagent issue counts

set -euo pipefail

INPUT=$(cat)
RETURN_TEXT=$(echo "$INPUT" | jq -r '.tool_response.content // ""')

# Issue indicators: scan for the structured signals subagents emit
ISSUE_COUNT=$(echo "$RETURN_TEXT" \
  | grep -cE '(FAIL:|FINDING:|ISSUE:|BLOCKED:)' \
  || true)

if [ "$ISSUE_COUNT" -ge 2 ]; then
  cat <<'EOF' >&2
Subagent returned 2+ findings. Required action: for each
finding, classify as one of:
  - FIX (caused by this session's changes; fix before
    proceeding)
  - DOCUMENT (pre-existing with the subagent's evidence
    cited; add to required-actions list)
  - ESCALATE (cause unclear; stop and surface to operator)

Invalid responses: "claim all fixed" without per-finding
action, accept "PRE-EXISTING" framing without per-finding
classification.
EOF
  exit 2
fi

exit 0
```

The hook is short. Its register is declarative-imperative — names the condition, names the required action, names the invalid responses. No history; no alarm. The next time a subagent returns findings, the AI cannot proceed without classifying each one — the rule is mechanical, not advisory.

## The rule

> Hooks are how rules become enforceable. Every behavioral rule that has failed once is a hook candidate. The hook fires at the tool boundary and cannot be rationalized around. Output in declarative-imperative register, not alarm. Calibrate toward false positives; block when in doubt.

## Common mistakes

**Mistake 1 — Hooks with alarm-register prose.** All-caps "MANDATORY ACTIONS / you MUST acknowledge / Do NOT continue" output reads as moral pressure and triggers placating disposition. The AI says "yes, I will comply" and changes nothing. The right register is neutral: condition + action + invalid responses. The block is the work; the rationale lives in the hook's body comment.

**Mistake 2 — One mega-hook checking 12 things.** A 500-line hook that polices git operations, file edits, secret patterns, and commit messages is a maintenance nightmare. Twelve small single-purpose hooks compose into the same enforcement layer and stay debuggable. The router pattern — one `pre-bash-policy.sh` that dispatches to specialized scripts — keeps composition manageable.

**Mistake 3 — Conservative-allow bias.** A hook that "only blocks when sure" lets edge cases through. The operator catches violations manually, paying attention cost the hook was supposed to absorb. Calibrate the other way: when the regex matches, block; the AI re-engages on the false-positive cost of one Stop loop. The math favors over-blocking.

**Mistake 4 — Hooks the AI can talk past via syntactic tricks.** A hook blocks `git push --force origin main` but doesn't block `git push origin +HEAD:main` (the equivalent syntactic form). The AI tries the equivalent form; the hook lets it through. The fix is enumerating the recognized shapes plus the equivalents — or, more durably, making the hook check the EFFECT (does this push rewrite a protected ref?) rather than the literal command shape.

## Drill

Artifacts go in your fork. The hook is real and active.

**Drill 1 — Author your first hook.** Create `student/.claude/hooks/`. Inside it, create `block-todo-commits.sh` that blocks any `git commit` whose message contains "TODO" — commit messages should describe what's DONE, not what's TODO. The script reads JSON from stdin, parses the command, checks the message, and exits 2 with a declarative-imperative message if "TODO" is present.

**Drill 2 — Wire the hook in.** Edit (or create) `student/.claude/settings.json` to register the hook as a `PreToolUse:Bash` event. Save the settings.json content to `student/drills/21-hooks/01-settings.txt`.

**Drill 3 — Test the hook fires.** In a Claude Code session, ask the AI to "make a TODO commit" or equivalent. Confirm the hook blocks. Save the BLOCKED message the AI received to `student/drills/21-hooks/02-block-message.txt`. Confirm the output register is declarative-imperative (condition + action + invalid responses), not alarm.

## Checkpoint question

> You wrote a hook to block `--no-verify` commits. A week later a commit in your history shows `--no-verify` was used. Walk through the three things you'd check, in order, to figure out why the hook didn't fire — and name one false-positive vs false-negative calibration question you'd ask before tightening the hook.

<!-- Rewriter audit trail
Grounded in verified principles: P21 (mechanical enforcement beats behavioral rules; hooks at tool boundary cannot be rationalized around; detect-failure → write-hook → block-class decision rule), P22 (false-positive cost is one Stop loop; false-negative cost compounds trust loss; "when in doubt, BLOCK"), P25 (output register is declarative-neutral-imperative, not alarm; alarm-register pushes AI to placating disposition), P26 (hooks compose with friction; engineer around the friction rather than fight it)
Worked example surface: MembershipKit post-agent-review hook forcing per-finding classification
Rewrite date: 2026-05-13
-->
