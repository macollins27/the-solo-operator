# Chapter 25 — Practice: Auth flow for MembershipKit

## Learning objective

The student can use everything from Parts 2 and 3 to ship one real feature — a working sign-up, sign-in, and sign-out flow for MembershipKit — and reach the point where they can sign in as a new user in their browser.

## Prerequisites

- Completed: Chapter 24 — The session lifecycle
- Concepts: All Part 2 mindset principles; all Part 3 mechanics (CLAUDE.md, skills, hooks, MCP, subagents, session lifecycle)

## Core concept

This chapter is a **practice** chapter. There's less new content; the lesson is APPLYING the discipline you've learned to a feature build of real complexity. The feature: end-to-end authentication for MembershipKit.

You're going to use Better Auth (the auth library MembershipKit was designed around) to add: a sign-up page, a sign-in page, a sign-out action, and protected routes that only authenticated users can reach. By the end you'll have a working browser experience: register a new account → see the dashboard → sign out → sign back in.

The technical content of auth is incidental. The lesson is the OPERATOR DISCIPLINE that ships this feature reliably. Specifically you'll practice:

- **Spec before build.** Write a short spec for what "auth flow" means in MembershipKit before you let Claude touch a file.
- **Recommendation, not menu.** When Claude asks "cookies or JWT?" you redirect: "Pick one with reasoning." Claude responds with a single recommendation; you approve.
- **Verify the artifact.** Don't ship until you've signed in IN A BROWSER. Code that compiles but doesn't work is not done.
- **Two-option rule under pressure.** Something will go wrong during the build — a config mismatch, a TypeScript error, a 500 response. When Claude tries to bandage it, intervene: fix it or surface it, no silent continuation.
- **Commit cadence.** Commit after every meaningful step. The first sign-up form working = commit. The protected route working = commit. Don't accumulate uncommitted state.

The feature is small enough to ship in one focused session. It's complex enough that you'll hit at least one anti-pattern in the wild. That's the point.

The narrow spec you'll write:

> **Feature: auth flow for MembershipKit.**
> 1. Users can sign up with email + password (min 8 chars).
> 2. Users can sign in with email + password.
> 3. Successful sign-in redirects to /dashboard.
> 4. Failed sign-in shows an inline error (no enumeration leak — same message for "user not found" and "wrong password").
> 5. Users can sign out from any page.
> 6. /dashboard is protected — unauthenticated users redirect to /signin.
> 7. Better Auth is the library used. Sessions stored via httpOnly cookies.

Seven lines. That's the spec. It's authoritative for the rest of the build.

## Worked example

A possible session flow (your real session will differ):

**Turn 1.** You: "I want to build the auth flow per my spec. Before you touch a file, list the assumptions you're about to make and the choices that aren't in the spec."

Claude: "Assumptions: I'll use the default Better Auth schema; I'll add the auth handler at /api/auth/[...all]/route.ts; passwords stored via bcrypt at default cost; session cookie name 'better-auth.session-token'. Choices not in spec: should I add 'forgot password' now or later (your spec doesn't mention it)? OK to proceed with these assumptions?"

You: "Forgot password is out of scope; I'll handle later. Other assumptions: approved. Proceed."

**Turns 2-5.** Claude builds the schema migration, the auth handler, the sign-up form, the sign-in form. After each, you eyeball the diff (`git diff`), confirm the change matches the spec line.

**Turn 6.** Claude reports "I added the protected route middleware." You ask: "Show me which spec line that maps to." Claude points at line 6. Good — every change traceable to spec.

**Turn 7.** You run the dev server. The sign-up page renders. You fill it out. You click submit. Browser shows a 500.

**Turn 8.** Claude: "I'll add a try/catch around the auth handler to handle errors gracefully." Anti-pattern #11 (defensive slop). You intervene: "Don't bandaid. What's the actual error?"

Claude reads the server log, finds the issue (a missing env var: `BETTER_AUTH_SECRET`). Real cause named. Fix is one line in `.env.local`. You restart the dev server. Sign-up works.

**Turn 9.** You verify in browser: sign up succeeds, dashboard renders, sign-out clears the session, sign-in works on the existing account. All seven spec lines confirmed by behavior.

**Turn 10.** `git status`, `git add`, `git commit -m "Complete auth flow: signup, signin, signout, protected dashboard"`.

That's the shape. Real sessions have more turns, more side-quests, more anti-patterns to catch. The discipline is the same: spec, propose, verify, intervene, commit.

## The rule

> Real features ship under operator discipline, not under AI improvisation. Write the spec. Demand recommendations not menus. Verify every change against a spec line. Intervene on every anti-pattern in real time. Commit after every meaningful step. The auth flow is your first practice run; every future feature uses the same loop.

## Common mistakes

**Mistake 1 — Skipping the spec.** "It's just auth, Claude knows how to do this." Claude does — but Claude's defaults aren't yours. Without a 7-line spec, Claude picks defaults that may not match what you want. Spec first. Always.

**Mistake 2 — Believing "it works" without browser verification.** Type checks pass. Tests pass. The dev server doesn't crash. But you didn't actually sign up in a browser. Don't ship until you've completed the user journey YOURSELF. The browser is the only place auth can really be verified.

**Mistake 3 — One mega-commit at the end.** You build the entire feature, get it working, then commit "Add auth flow" with 30 files changed. If something breaks tomorrow, you can't bisect to find what. Commit per meaningful step: schema migration, handler, sign-up form, sign-in form, protected route. Five small commits beat one big one.

## Drill

Artifacts go in your fork. The work is real — by the end you'll have a working auth flow.

**Drill 1 — Author the spec.** Create `student/specs/auth-flow.md` with at least 7 specific spec lines (your version of the 7 above; you can change details as long as each is specific and testable). Save the path to `student/drills/25-auth-flow/01-spec-path.txt`.

**Drill 2 — Ship the feature.** In a Claude Code session, build the feature against your spec. Follow the discipline: assumption-listing first, then build, verifying after each change. By the end, you should be able to sign up in your browser. Take a screenshot of yourself signed in (showing the dashboard or a "Welcome, <your name>" message), save to `student/drills/25-auth-flow/02-signed-in.png`.

**Drill 3 — Document one intervention.** Somewhere during the build, you'll catch an anti-pattern (Claude bandaging, drifting, deferring, etc.). Save the specific phrase Claude used + the anti-pattern number + your intervention to `student/drills/25-auth-flow/03-intervention.txt`. Format:

```
Claude said: "<exact phrase>"
Anti-pattern: #<N> (<name>)
My intervention: "<what I said>"
Result: <what changed>
```

## Checkpoint question

> You shipped the auth flow. A week later, a community admin reports that they're seeing intermittent "session expired" errors. You suspect something in your auth setup but you can't reproduce it. Walk through the order in which you'd investigate — your typed instruction, your spec, your CLAUDE.md, your feedback corpus, the shipped code, generated docs — naming what you'd check at each level and why.
