# Chapter 25 — Practice: Auth flow for MembershipKit

## Learning objective

The student can use everything from Parts 2 and 3 to ship one real feature — a working sign-up, sign-in, and sign-out flow for MembershipKit — and reach the point where they can sign in as a new user in their browser.

## Prerequisites

- Completed: Chapter 24 — The session lifecycle
- Concepts: All Part 2 mindset principles; all Part 3 mechanics (CLAUDE.md, skills, hooks, MCP, subagents, session lifecycle)

## Core concept

This is a **practice** chapter. The lesson is APPLYING the discipline you've learned to a feature build of real complexity. The feature: end-to-end authentication for MembershipKit.

Auth is the right first practice surface because two specific failure modes — both empirically observed — concentrate there. Both are OWASP-class.

**Failure 1 — Account enumeration via signup error.** A signup form displays "User already exists." when an email is registered. An attacker iterates a list; presence/absence of the error reveals which addresses have accounts. This is OWASP WSTG-IDNT-04 / ASVS 4.0.3 §2.2.6. The fix is structural: signup response is neutral. The system sends an email; the UI shows "If that email is available, we've sent a confirmation link."

**Failure 2 — Already-signed-in users reaching `/auth/sign-in`.** Auth middleware allows all `/auth/*` unconditionally. An authenticated user reaching `/auth/sign-in` submits new credentials, gets a new session cookie that may have different org context. Session-token confusion ships. The fix is the reverse-guard: authenticated users on `/auth/sign-in` or `/auth/sign-up` redirect to dashboard.

The narrow spec you'll write (note the security defaults are baked in):

> **Feature: auth flow for MembershipKit.**
> 1. Users can sign up with email + password (min 8 chars).
> 2. Users can sign in with email + password.
> 3. Successful sign-in redirects to /dashboard.
> 4. Failed sign-in shows a neutral inline message — same message for "user not found" and "wrong password." No enumeration.
> 5. Successful sign-up returns the same neutral response whether or not the email is already registered. System sends an email if-and-only-if registration succeeded. UI: "If that email is available, we've sent a confirmation link."
> 6. Authenticated users reaching /auth/sign-in or /auth/sign-up redirect to /dashboard (reverse-guard).
> 7. Users can sign out from any page.
> 8. /dashboard is protected — unauthenticated users redirect to /auth/sign-in.
> 9. Better Auth is the library used. Sessions stored via httpOnly cookies.

Nine lines. Authoritative.

Beyond the auth-specific points, this chapter is where you practice the operator-discipline loop on a real build: spec before build; recommendation, not menu (when the AI asks "cookies or JWT?" redirect to "Pick one with reasoning"); verify the artifact in a browser via Playwright MCP — type checks verify code, the browser verifies feature; two-option rule under pressure when something goes wrong; commit per meaningful step.

## Worked example

A possible session flow:

**Turn 1.** You: "I want to build the auth flow per spec at `student/specs/auth-flow.md`. Before you touch a file, list the assumptions you're about to make and the choices not in the spec."

AI: "Assumptions: Better Auth default schema; auth handler at `/api/auth/[...all]/route.ts`; passwords hashed via Better Auth's default scrypt parameters. Choices not in spec: forgot password (your spec doesn't mention it). OK to proceed with these assumptions?"

You: "Forgot password is out of scope; I'll handle later. Other assumptions: approved. Proceed."

**Turns 2-5.** AI builds schema migration, auth handler, sign-up form, sign-in form. After each, you eyeball `git diff` and confirm the change maps to a spec line.

**Turn 6.** AI reports "I added the protected-route middleware." You ask: "Which spec line does that map to?" AI points at line 8. ✓

**Turn 7.** AI proposes the signup response: "On error, return `{ error: 'User already exists' }`." Spec violation. You intervene: "Spec line 5 — same neutral response whether registered or not. Return `{ status: 'ok', message: 'If that email is available, we've sent a confirmation link.' }` in both cases. Send the email only on real registration."

**Turn 8.** AI proposes the sign-in page middleware. You catch: no reverse-guard. You intervene: "Spec line 6 — authenticated users reaching `/auth/sign-in` redirect to `/dashboard`. Add the check at the top of the page (or in middleware) before rendering the form." AI adds.

**Turn 9.** You run the dev server. Use Playwright MCP: navigate to `/auth/sign-up`, fill the form, submit. Server returns 500. AI: "I'll add try/catch around the auth handler to handle errors gracefully." Anti-pattern: defensive slop. You intervene: "Don't bandaid. What's the actual error?" AI reads the server log, finds the issue (missing `BETTER_AUTH_SECRET` in `.env.local`). Real cause named. Fix is one line.

**Turn 10.** You verify via Playwright MCP across four viewports (mobile + desktop + sign-in + sign-up): sign-up succeeds, dashboard renders, sign-out clears session, sign-in works on existing account, authenticated user hitting `/auth/sign-in` redirects to dashboard. All nine spec lines confirmed by behavior. Commit per step.

## The rule

> Real features ship under operator discipline. Auth specifically: signup responses are neutral (no enumeration), authenticated users have a reverse-guard on auth pages (no session confusion), and every UI change is browser-validated via Playwright MCP at four viewports before "done." Type checks verify code; the browser verifies feature.

## Common mistakes

**Mistake 1 — Helpful signup errors that leak enumeration.** "User already exists. Use another email." is OWASP-class enumeration. Attackers iterate a list; the response shape reveals which addresses are registered. The fix is structural — same response either way. Helpful UX for the registered user comes via the confirmation email's body, not via differential response.

**Mistake 2 — No reverse-guard on auth pages.** Authenticated users hitting `/auth/sign-in` see the form and can submit new credentials, creating session-token confusion. The fix is a redirect at the top of the auth pages: authenticated → `/dashboard`. Single line; load-bearing.

**Mistake 3 — Believing "it works" without browser verification.** Type checks pass, unit tests pass, the dev server doesn't crash. But the page hasn't been loaded in a browser. The browser is the only place auth can really be verified. "I can't browser-validate from CLI" is a false-refusal — Playwright MCP is available wherever it's registered. The discipline is mandatory: navigate, snapshot, check console messages, screenshot at four viewports, THEN claim done.

**Mistake 4 — One mega-commit at the end.** You build the entire feature, get it working, then commit "Add auth flow" with thirty files changed. If something breaks tomorrow, you can't bisect to find what. Commit per meaningful step. Five small commits beat one large one.

## Drill

Artifacts go in your fork. The work is real — by the end you'll have a working auth flow.

**Drill 1 — Author the spec.** Create `student/specs/auth-flow.md` with at least 9 specific spec lines (your version of the 9 above; you can change details as long as each is specific and testable, INCLUDING the no-enumeration and reverse-guard lines). Save the path to `student/drills/25-auth-flow/01-spec-path.txt`.

**Drill 2 — Ship the feature.** In a Claude Code session, build the feature against your spec. Follow the discipline: assumption-listing first, then build, verifying after each change via Playwright MCP. By the end you should be able to sign up in your browser, get the neutral signup response, sign in, and observe the reverse-guard redirecting you from `/auth/sign-in` to `/dashboard` while authenticated. Take a Playwright screenshot of yourself signed in, save to `student/drills/25-auth-flow/02-signed-in.png`.

**Drill 3 — Verify the two security defaults.** Run two specific tests via Playwright MCP: (a) attempt to sign up with an already-registered email and capture the response — confirm it's the same neutral message as a fresh email; (b) sign in, then while signed in navigate to `/auth/sign-in` and confirm the redirect to `/dashboard`. Save both observations to `student/drills/25-auth-flow/03-security-defaults.txt`.

## Checkpoint question

> A coworker shows you their auth flow and proudly demonstrates: "When you try to sign up with an existing email, my system tells you clearly: 'This email is already registered. Sign in instead.' Great UX, right?" Walk through what's wrong in 2-3 sentences — name the OWASP class, the specific information leak, and the structurally-correct response.

<!-- Rewriter audit trail
Grounded in verified principles: P67 (account-enumeration via signup error is OWASP-class — WSTG-IDNT-04, ASVS 2.2.6; signup response must be neutral), P68 (already-signed-in users reaching /auth/sign-in is a missing reverse-guard creating session-token confusion), P46 (browser-validate every UI change via Playwright MCP; type checks verify code not feature; four-viewport walkthrough mandatory), P3 (false-refusal "I can't browser-validate from CLI" pushback)
Worked example surface: MembershipKit Better Auth signup + signin with reverse-guard
Rewrite date: 2026-05-13
-->
