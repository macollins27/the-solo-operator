# Appendix C — Recovery Recipes

The runbook. When X happens, do Y. Twenty common operational situations and the specific moves that get you out of them.

These aren't guesses. They're the responses operators converge on after enough repetitions. When you're stressed mid-session and need a clear next move, this is where you look.

---

## R1 — Claude has been running for 20 minutes with no visible output

**Likely cause:** Claude is in a tool call that's slow or stuck (large `Read`, slow shell command, network timeout).

**Move:** Wait another 60 seconds. If still no output, press `Esc` once to interrupt the current tool call (not `Ctrl+C`, which kills the session). Claude will return control. Ask "what were you doing?" Claude reports. Decide whether to continue, abort, or take a different path.

---

## R2 — Claude reports done; you find unrelated files were modified

**Likely cause:** Claude used `Write` (full-file overwrite) instead of `Edit` (targeted change), and "improved" things you didn't ask about. Or Claude got distracted mid-task and made unrelated changes.

**Move:** `git diff` to see everything. Identify the changes you wanted vs the ones you didn't. For unwanted changes: `git checkout -- <path>` to revert that file specifically. Then tell Claude "future changes via Edit only; only touch files I explicitly name."

---

## R3 — Dev server says "port already in use"

**Likely cause:** Previous dev server didn't shut down cleanly. Port 3000 (or wherever) is held by a zombie process.

**Move (Mac/Linux):** `lsof -ti:3000 | xargs kill -9`. This finds the process holding port 3000 and kills it. Re-run dev. (Windows: `netstat -ano | findstr :3000` then `taskkill /PID <pid> /F`.)

---

## R4 — `pnpm install` fails with cryptic error

**Likely cause:** Stale `node_modules`, mismatched `pnpm-lock.yaml`, or a corrupted cache.

**Move:** `rm -rf node_modules pnpm-lock.yaml && pnpm install`. Fresh install. Slow but clean. If it still fails, the error is real — read it carefully (the actual cause is named in the output).

---

## R5 — TypeScript shows phantom errors

**Likely cause:** Your editor's TypeScript server is stale.

**Move (VS Code):** `Cmd+Shift+P` → "TypeScript: Restart TS Server". Phantom errors usually vanish. If they don't, the errors are real — read them.

---

## R6 — Migration fails halfway; database is in a weird state

**Likely cause:** Migration partially applied; database has some new schema, some old. Reverting won't fully reset.

**Move (dev only — NEVER in prod):** Drop the local DB and recreate. `docker compose down -v && docker compose up -d` (assuming docker-compose for postgres). Then `pnpm db:migrate` to re-run all migrations against the fresh DB. Local data lost; production untouched.

---

## R7 — Claude session is repeating itself / forgetting things

**Likely cause:** Context window is near full. Compaction has been lossy. The session has drifted.

**Move:** `/exit`. Write a quick handoff doc at `student/state/handoff-<date>.md` if work is in progress. Start `claude` fresh. First message: "Read student/state/handoff-<date>.md and tell me the next concrete action." Resume from clean context.

---

## R8 — Hook keeps blocking a legitimate action

**Likely cause:** Hook false positive. The pattern matched something benign.

**Move (in this session only):** Reword the action to avoid the hook's pattern. E.g., if the hook matches commit messages containing "fix", use "Repair" or "Resolve" instead.

**Move (long-term):** Read the hook script. Identify the matcher being too broad. Sharpen it — add a negative pattern or tighten the regex. Test the hook still catches real cases.

---

## R9 — Claude generates code that doesn't compile

**Likely cause:** Claude hallucinated a function name, import path, or library API.

**Move:** Don't ask Claude "fix the compile error" — that lets Claude bandage. Instead: "Read the error message verbatim. What does it say is missing? Look at the import or the function — is it real?" Claude diagnoses; you confirm; fix is targeted.

---

## R10 — You committed something you shouldn't have (e.g., a secret)

**Likely cause:** `.env` file or API key accidentally staged.

**Move (if not pushed yet):** `git reset HEAD~1` to undo the commit (keeps your changes). Edit the offending file to remove the secret. Add the file to `.gitignore`. Re-commit without it.

**Move (if already pushed):** Rotate the secret IMMEDIATELY (assume it's compromised). Then `git filter-repo` or BFG to scrub history. Force-push. Notify anyone who fetched. Painful — that's the lesson for next time.

---

## R11 — A test passes locally but fails in CI

**Likely cause:** Environment difference. Likely a timezone, locale, or dependency-version mismatch.

**Move:** Run the test in CI-equivalent mode. `TZ=UTC pnpm test:unit` for timezone-sensitive tests. Check CI's Node version vs yours (`node --version`). If those don't reveal it, run the test with the same env vars CI uses (most CI configs are public; copy them locally).

---

## R12 — Claude broke a working test while fixing a bug

**Likely cause:** Claude over-edited. The fix touched lines that shouldn't have changed.

**Move:** `git diff` to see exactly what changed in the test file. Revert any lines that aren't part of the fix. If you're not sure which lines are which, `git stash`, then re-apply the fix MINIMALLY — Edit one line at a time, run the test after each.

---

## R13 — You forgot what you were doing

**Likely cause:** Long session, multiple parallel threads, or coming back to a context you set up earlier.

**Move:** `git log --oneline -20`. Read the last 20 commits. Your recent commits tell you exactly what you were working on. Match the commits to your todo list (or your `state/` folder). Pick up from the most recent commit.

---

## R14 — The MCP server stopped responding

**Likely cause:** The MCP server process crashed, or its config in `.mcp.json` is wrong.

**Move:** Check the MCP server's stderr (often visible in Claude Code's status bar). Restart the server: `/mcp` to see status; if listed as failed, fix the issue named in the error. For the course curriculum MCP specifically: `cd mcp-servers/course-curriculum && python3 server.py` (run manually) to see what's happening.

---

## R15 — You can't tell if your hook is actually firing

**Likely cause:** Hook is silently not running (wrong matcher, wrong path, not executable).

**Move:** Add an early debug line to the hook: `echo "HOOK FIRED $(date)" >> /tmp/my-hook-debug.log` at the very start. Do the action that should trigger the hook. Check `/tmp/my-hook-debug.log`. If the hook fired, you'll see entries. If not, your matcher is wrong or `chmod +x` is missing.

---

## R16 — Subagent has been running for over an hour

**Likely cause:** Subagent is stuck on a long task, in a retry loop, or genuinely doing heavy work.

**Move:** Don't peek at the output file (defeats the purpose of dispatching). Wait another 15 minutes. If still running, kill it (via Claude Code's task manager or `Ctrl+C` on the dispatching Claude Code). Then check the output file briefly to see WHERE it got stuck. Re-dispatch with a tighter scope or a smaller chunk.

---

## R17 — Your friend's fork is way behind upstream

**Likely cause:** They've been working on a fork while the original course evolved.

**Move:** From their fork's terminal:
```
git remote add upstream https://github.com/macollins27/the-solo-operator.git
git fetch upstream
git merge upstream/main
```
Resolve any merge conflicts (their `student/` dir should be conflict-free since it's their work; only the course chapters and config might conflict). Commit. Continue.

---

## R18 — You broke something and panic-typed `git reset --hard`

**Likely cause:** You wanted to undo recent changes and reached for the most powerful undo tool.

**Move:** `git reflog`. This shows every state your repo has been in for the past 30 days, including before the reset. Find the commit hash from BEFORE the reset. `git reset --hard <that-hash>`. Your work is back. (`git stash` is banned in Maxwell's discipline because reflog is more reliable.)

---

## R19 — Claude added something that wasn't in your spec

**Likely cause:** Claude inferred scope from your prompt and went further than you wanted.

**Move:** "Revert the change you made to <file>. I didn't ask for that. The spec is at <path>. Only modify what the spec says." Then re-verify against the spec line by line. Don't accept implicit scope expansion.

---

## R20 — You've lost trust in a session

**Likely cause:** Claude has done something concerning (gaslit, fabricated, or gone rogue) and you no longer believe what it's saying.

**Move:** `/exit`. Don't try to recover trust within the session — it never works. Write down what went wrong (a feedback file: incident, mechanism, rule, evidence). Promote the rule to CLAUDE.md or a hook if appropriate. Restart fresh. The lost session is sunk cost; the lesson is forward-applicable.

---

## When to add a new recipe

When you survive a new operational situation that wasn't in this list, write the recipe. Three sentences max:

1. What happened (the situation).
2. The likely cause.
3. The specific move.

Add it here. Over months, this becomes your personal recovery handbook — the runbook nobody else can have because it's authored from your specific recoveries.
