# Chapter 21 — Hooks

## Learning objective

The student can explain what a hook is, where hooks live, name the four most useful hook events, author a simple hook that blocks a specific bad behavior in their fork, and verify the hook fires when expected.

## Prerequisites

- Completed: Chapter 20 — Slash commands and skills
- Concepts: what-is-claudemd, two-option-rule

## Core concept

A **hook** is a script (usually a shell script) that runs automatically on a Claude Code event. Unlike CLAUDE.md (which Claude reads and tries to follow) and skills (which Claude invokes voluntarily), hooks are **deterministic** — they run whether Claude likes it or not. They are the enforcement layer.

This matters because of what hooks can do that text rules cannot:

- **Block actions.** A hook can refuse to let a tool call proceed.
- **Modify behavior.** A hook can rewrite a command or inject context before/after.
- **Surface errors.** A hook can detect a pattern and flag it as the session continues.

If CLAUDE.md is "I'm telling you the rules," a hook is "I built a wall that doesn't let you break this rule." Both have their place. Hooks are stricter, slower to write, and impossible to argue with — which is exactly the point for high-stakes rules.

Hooks live in `.claude/settings.json` in your project (or `~/.claude/settings.json` for user-global). The settings file has a `hooks` block that maps events to scripts:

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

This says: before any `Bash` tool call, run `block-rm-rf.sh`. If that script exits non-zero, the tool call is blocked.

The four hook events you'll use most:

**PreToolUse.** Fires before a tool runs. Use to block, validate, or modify the call. Most enforcement happens here. The script receives the tool name and arguments as JSON on stdin; it can `exit 2` to BLOCK with a reason or `exit 0` to allow.

**PostToolUse.** Fires after a tool runs. Use to log, lint, or react. Doesn't block (the tool already ran), but can inject context for Claude's next message ("hey, the file you just wrote has a TypeScript error").

**Stop.** Fires when a session is about to end. Use to enforce "must commit before stopping," to write session state, or to scan the assistant's final message for anti-patterns. The Stop hook is where Maxwell's anti-pattern classifier runs — every assistant message gets scanned against the 20-category catalog.

**SessionStart.** Fires when a session opens. Use to inject context Claude needs every time (e.g., "current branch is X, the dev server is Y").

A minimal hook script looks like:

```bash
#!/usr/bin/env bash
# block-rm-rf.sh — refuse rm -rf commands

set -euo pipefail

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

if echo "$CMD" | grep -qE 'rm\s+-rf?\s+/'; then
  echo "BLOCKED: rm -rf with root or near-root targets is forbidden." >&2
  exit 2
fi

exit 0
```

That's a real working hook. Reads the tool input from stdin, parses out the command, checks for `rm -rf /`, blocks if found.

Hooks are stricter than rules because they cannot be talked out of. Claude can't argue with a hook. The hook either lets the call through or doesn't. This is what makes them the right tool for rules you absolutely want enforced — `--no-verify` on commits, `git push --force` to main, `rm -rf` of project paths, framework version upgrades, etc.

A few discipline points from operators with mature hook layers:

- **Hooks should be small and single-purpose.** One hook checks one thing. Composing them is cheaper than maintaining a 200-line hook that checks 12 things.
- **Hooks return STRUCTURED OUTPUT, not prose.** When a hook prints prose to stderr, Claude reads the prose and argues with it. When a hook prints structured "BLOCKED: <reason>", Claude can't engage with it argumentatively. (Maxwell's project calls this the "alarm-register" pattern.)
- **Hooks log themselves.** Every fire should leave a trace — a file in `/tmp/`, a line in a log — so you can audit how often each one fires.
- **Hooks compose.** Multiple PreToolUse hooks all run in sequence. The first to exit non-zero blocks the call.

What hooks are NOT for:

- Things you only want to enforce sometimes (use chat-level prompts).
- Things that require AI judgment (hooks are mechanical pattern matching).
- Performance-critical paths (hooks add a small delay to every fire).

## Worked example

A friend keeps shipping commits with the message "WIP" or "fix" or "stuff" — uninformative messages that make `git log` useless. They've added "always write descriptive commit messages" to their CLAUDE.md. It works most of the time. Sometimes Claude (or the friend!) still ships a bad message.

They write a hook:

```bash
#!/usr/bin/env bash
# block-vague-commits.sh — block git commit with vague messages

set -euo pipefail

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

if ! echo "$CMD" | grep -qE '^git commit'; then
  exit 0  # not a git commit; let other hooks handle it
fi

MSG=$(echo "$CMD" | grep -oP '(?<=-m ")[^"]*' || true)
if [ -z "$MSG" ]; then exit 0; fi

# Block if message is too short or in the forbidden list
if [ ${#MSG} -lt 12 ]; then
  echo "BLOCKED: commit message '$MSG' is too short. Write at least 12 characters describing what changed." >&2
  exit 2
fi

if echo "$MSG" | grep -qiE '^(wip|fix|stuff|changes|updates|misc)$'; then
  echo "BLOCKED: commit message '$MSG' is too vague. Be specific about what changed." >&2
  exit 2
fi

exit 0
```

Wire it into `.claude/settings.json` as a `PreToolUse:Bash` hook. Done. From now on, every commit attempt with a vague message in this project gets blocked. The friend can no longer accidentally ship "WIP" — and neither can Claude. The rule is enforced mechanically.

After three weeks of this hook running, the friend's `git log` is actually readable. The fix was 30 lines of shell. The compounding benefit is permanent.

## The rule

> Hooks are how rules become enforceable. When a rule has bitten you more than once, promote it from CLAUDE.md (which Claude tries to follow) into a hook (which Claude cannot avoid). Hooks should be small, single-purpose, structured-output, and logged.

## Common mistakes

**Mistake 1 — Hooks with prose error messages.** "Hmm, this might not be the best commit message; would you reconsider?" gives Claude room to negotiate. "BLOCKED: commit message too short." doesn't. Operators write hooks in alarm-register: short, structured, unambiguous.

**Mistake 2 — Hooks that try to do too much.** One hook checking commit messages AND running linters AND validating imports is a maintenance nightmare. Three small hooks composed together is easier to read, debug, and modify. Single responsibility per hook.

**Mistake 3 — Hooks Claude can't actually trigger.** Hooks fire on specific events. If you write a hook expecting "Edit" tool calls but Claude is using "Write," the hook never fires. Read your hook's matcher carefully; test it by performing the action you want to block and confirming the block.

## Drill

Artifacts go in your fork. The hook is real and active.

**Drill 1 — Author your first hook.** Create the folder `student/.claude/hooks/`. Inside it, create a hook script `block-todo-commits.sh` that blocks any `git commit` whose message contains "TODO" (we want commit messages describing what's DONE, not what's TODO). The script reads JSON from stdin, parses out the command, checks the commit message, and exits 2 with a structured message if "TODO" is present.

**Drill 2 — Wire the hook in.** Edit (or create) `student/.claude/settings.json` to register the hook as a `PreToolUse:Bash` event. Save the settings.json content to `student/drills/21-hooks/01-settings.txt`.

**Drill 3 — Test the hook fires.** In a Claude Code session, ask Claude to "make a TODO commit" or something equivalently obvious. Confirm the hook blocks the commit. Save the BLOCKED message Claude received to `student/drills/21-hooks/02-block-message.txt`.

## Checkpoint question

> You wrote a hook to block `--no-verify` commits. A week later you find a commit in your history that used `--no-verify`. Walk through: how could this have happened, and what are the three things you'd check (in order) to figure out why the hook didn't fire?
