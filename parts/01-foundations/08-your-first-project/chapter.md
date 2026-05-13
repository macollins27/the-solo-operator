# Chapter 8 — Your first project: a working app on your machine

## Learning objective

The student can install Node.js and pnpm, scaffold a new Next.js application inside their course fork, run the development server, see the default page in their browser, and commit the initial state to Git.

## Prerequisites

- Completed: Chapter 7 — Reading Claude's tool calls
- Concepts: basic-shell-commands, git-status-add-commit-flow, tool-call-vs-text-summary-truth-hierarchy

## Core concept

Up to this point you've been learning concepts. This chapter is where you build something real. By the end of it, you'll have a working web application running on your laptop — visible in your browser, controllable from your terminal, version-tracked in Git. This is the starter for **MembershipKit**, the community-membership-manager app you'll build across the rest of the course. Right now it's just the empty shell. Over the next 40+ chapters you'll add every feature.

You'll do this with Claude Code's help. The point of this chapter is not to learn Next.js or Node.js — those are tools the course uses, not subjects it teaches. The point is to see what it feels like to set up a real project alongside an AI agent, then to verify the result. The drill IS the chapter.

A few terms you'll see and the operator-level definition of each:

**Node.js** is a JavaScript runtime. JavaScript is the language web apps are written in. Node is the program that runs JavaScript code outside a browser. You install Node once on your machine; everything else that's JavaScript-based uses it.

**pnpm** is a **package manager**. A web app is built from hundreds or thousands of small libraries (called **packages**). pnpm installs them, tracks them, and lets you run scripts the app defines. There are alternatives (`npm`, `yarn`); this course uses pnpm because it's fast and clean.

**Next.js** is a **web framework** — a curated stack of conventions for building a web app. It handles routing (which page renders for which URL), server-side rendering, the dev server, and a lot of other plumbing. The course's MembershipKit is built on Next.js because it's the industry default for modern web apps.

**A dev server** is a local web server that runs while you're working on the app. It rebuilds the app every time you save a file, so what's in your browser is always current. You start it with `pnpm dev` and stop it with `Ctrl + C`. It's not a production server; it's just a fast loop for you to iterate.

Once everything is installed and the dev server is running, visit `http://localhost:3000` in your browser. `localhost` is your own machine; `:3000` is the port (a numbered channel) the dev server listens on. Seeing the Next.js starter page means everything works.

## Worked example

Open Claude Code in your course repo. Ask:

> Install Node.js and pnpm on my machine (Mac via Homebrew or Windows via winget), then scaffold a Next.js app in `student/canonical-project/` using TypeScript and the App Router. Don't include Tailwind, ESLint, or examples — keep it minimal. Then walk me through starting the dev server and opening localhost:3000.

A capable session will:

1. **Bash** — Check if Node and pnpm are already installed (`node --version`, `pnpm --version`).
2. **Bash** — Install whichever is missing.
3. **Bash** — Run the Next.js scaffolder targeting `student/canonical-project/`. Permission prompt: read the command before approving.
4. **Read / Glob** — Look at what files were created.
5. (Tell you how to start the dev server.)
6. You run `cd student/canonical-project && pnpm dev`.
7. You open `http://localhost:3000` in your browser.
8. You see the Next.js welcome page.
9. You `Ctrl + C` to stop the dev server.
10. You `git status` to see what's new.
11. You commit the scaffold.

Pay attention to the tool calls. If Claude runs `pnpm install` without telling you, that's fine — but you should see the Bash call and the output. If Claude claims it scaffolded the app but you don't see a Bash call doing it, something's off — the file system is the truth.

## The rule

> Building real things is how the course earns its weight. Watch Claude scaffold; verify the files exist; commit the state. Every chapter from here forward assumes you have a working app in `student/canonical-project/` and a Git history that proves it.

## Common mistakes

**Mistake 1 — Accepting "done" without seeing the dev server work.** Claude reports the app is scaffolded and ready. You move on. Later chapters break because the install didn't actually finish. The real check: did `pnpm dev` start cleanly? Did `localhost:3000` show the welcome page? If either failed, the chapter isn't done.

**Mistake 2 — Forgetting to commit the scaffold.** A scaffolded app is hundreds of files. If you don't commit it now, any future change is mixed in with the initial state — you can't easily see what YOU changed vs what the scaffolder generated. Commit once, immediately, with a message like "Initial Next.js scaffold for MembershipKit."

**Mistake 3 — Mixing the reference and your fork.** The course's `canonical-project/` is the REFERENCE. Your work goes in `student/canonical-project/`. If you scaffold over the reference by mistake, you've polluted the answer key. Always check `pwd` and verify you're in the student/ subtree before running scaffolders.

## Drill

This whole drill is your first real piece of work. Artifacts live where they naturally land — in your `student/canonical-project/` folder and your Git history.

**Drill 1 — Install Node.js and pnpm.** Use Claude Code or the official installers. After installing, run `node --version` and `pnpm --version` and confirm both print version numbers. Save those two version strings (one per line) to `student/drills/08-your-first-project/01-versions.txt`.

**Drill 2 — Scaffold the Next.js app.** Inside your fork, create `student/canonical-project/` if it doesn't exist. Have Claude scaffold a Next.js app there (TypeScript, App Router, no Tailwind/ESLint/examples). After scaffolding, the folder should contain `package.json`, `app/`, and a few config files. Don't touch the reference `canonical-project/` at the repo root.

**Drill 3 — Run, see, commit.** Run `cd student/canonical-project && pnpm dev`. Open `http://localhost:3000` in your browser. Take a screenshot of the welcome page. Save it to `student/drills/08-your-first-project/02-localhost-screenshot.png`. Then `Ctrl + C` to stop the dev server, run `git add student/canonical-project/`, run `git commit -m "Initial Next.js scaffold for MembershipKit"`, and run `git log -1 --oneline > student/drills/08-your-first-project/03-first-commit.txt` to capture proof of the commit.

When all three drills are done, run the chapter's `verify.sh`.

## Checkpoint question

> The dev server is running, `localhost:3000` shows the welcome page, but you forgot to commit. You quit the dev server and open a new Claude Code session to start Chapter 9. Claude reads your `student/canonical-project/` and "improves" some of the scaffolded files without asking. You now have uncommitted changes mixed with the original scaffold. How do you figure out exactly what Claude changed, and how do you get back to the original scaffold without losing the things Claude did that you might want to keep?
