# Chapter 3 — Git in plain English

## Learning objective

The student can initialize a Git repository, save their work in three commits, view their commit history, and explain why an operator treats Git as the memory layer of their work.

## Prerequisites

- Completed: Chapter 2 — The terminal — text commands as a tool
- Concepts: basic-shell-commands, what-is-a-file

## Core concept

**Git is your work's memory.** Every time you save a snapshot (called a **commit**), Git remembers the full state of your folder at that moment. Later, you can look back at any snapshot, compare snapshots to each other, or rewind to any past state. The folder you're working in plus its full history of commits together make a **repository** (a **repo** for short).

For an operator, Git is non-negotiable. AI agents write a lot of code very fast. Most of it is fine. Some of it isn't. The difference between "I lost an hour because the AI did something weird" and "no problem, I can see exactly what changed and undo it" is whether your work is in Git. Without Git, every change is permanent until you notice it broke. With Git, every change is a labeled snapshot you can compare and undo.

Three commands cover 90% of daily Git use.

```
git status        # what's changed since my last commit?
git add <file>    # mark this file to go into my next commit
git commit -m "<message>"   # take a snapshot, with a short note
```

A typical flow looks like this:

1. You change some files (write some code, edit some text).
2. `git status` shows which files changed.
3. You decide which changes belong together in this snapshot.
4. `git add <files>` stages them.
5. `git commit -m "what I just did"` takes the snapshot.
6. `git log` shows your commit history — every snapshot you've taken, with its message and timestamp.

The commit message matters. "Fixed bug" is useless. "Fix login redirect when user has no active session" tells you exactly what changed. Future-you (or future-anyone) reading the log can scan it and understand the project's evolution. Operators write their commit messages like they're writing notes to a colleague who will read them in six months.

A small but load-bearing detail: until you `git add` something, Git doesn't know about it. The folder it ignores by default is called **untracked**. The folder it tracks but you haven't staged for the next commit is **modified**. The set of files staged for the next commit is the **staging area**. `git status` shows all three categories clearly. Read it carefully — operators read `git status` 50 times a day.

The reverse of `git add` is `git restore --staged <file>` (unstage). The reverse of a committed change is more complicated and you don't need it yet. For now: take many small commits with descriptive messages. The smaller your commits, the easier it is to find and undo a bad one later.

## Worked example

Open your terminal. Walk through this:

```
cd ~
mkdir my-first-repo
cd my-first-repo
git init                              # create a new repo here
ls -la                                # see the hidden .git/ folder Git just created
echo "Hello, Git." > hello.txt        # create a file
git status                            # hello.txt shows as untracked
git add hello.txt                     # stage it
git status                            # now staged for next commit
git commit -m "Add initial hello file"
git log                               # see your first commit
```

`git init` creates a hidden folder called `.git/` inside your folder. That folder is the entire repo — it holds every snapshot, every commit message, every change ever made. Don't touch it directly; let Git manage it. Move or copy `.git/` along with your project folder and you keep your full history. Delete it and you lose all history (the current files stay).

Each commit gets a unique identifier called a **hash** — a long string of letters and numbers like `a3f8c2d4...`. You'll see the first 7 characters of recent commits in `git log` output. That hash is how you refer to a specific snapshot when you want to inspect or revert it.

## The rule

> Commit early, commit often, write messages that future-you will thank you for. Your work isn't safe until it's in a commit. AI changes aren't reviewable until they're a diff against a prior commit.

## Common mistakes

**Mistake 1 — Treating Git as a backup.** Git is a history, not a remote backup. Your `.git/` folder is on your laptop. If your laptop dies, your commits die with it unless you've pushed your repo to a remote service (like GitHub). For this course, GitHub is where you push your fork; that's your backup. Push regularly.

**Mistake 2 — Huge "WIP" commits.** A commit message like "stuff" or "WIP" or "fixes" tells you nothing six weeks later. You'll be debugging a regression, scrolling through `git log`, and 40 of your last 50 commits will say "WIP" and you won't be able to find when the bug entered. Small commits with clear messages cost no extra time and save hours later.

**Mistake 3 — Not reading `git status` before committing.** `git status` shows exactly what's about to go into your next commit. If you don't read it, you commit things you didn't mean to (secret files, debug print statements, half-finished work). Reading `git status` before every `git commit` is non-negotiable. Two seconds; saves real damage.

## Drill

You'll create a small standalone Git repo to practice on. It lives at `student/drills/03-git-in-plain-english/myrepo/`. The course's `verify.sh` will check it.

**Drill 1 — Initialize.** In your terminal, navigate to your course fork and run:

```
mkdir -p student/drills/03-git-in-plain-english/myrepo
cd student/drills/03-git-in-plain-english/myrepo
git init
ls -la
```

Confirm you see a `.git/` folder. You just created a new repo.

**Drill 2 — First commit.** Still in `myrepo`, create a file and commit it:

```
echo "I am taking the Solo Operator course." > about.txt
git add about.txt
git commit -m "Add about.txt"
git log
```

You should see one commit in the log, with your message.

**Drill 3 — Second commit.** Change the file and commit again:

```
echo "I just learned how Git works." >> about.txt
git status
git add about.txt
git commit -m "Add a line about learning Git"
git log
```

You should now see two commits in `git log`. The `>>` operator appends to a file (vs `>` which overwrites). Run `git status` between every step and read what it tells you.

After this, run the chapter's `verify.sh` to confirm the repo has at least two commits.

## Checkpoint question

> The AI just pushed a 30-line change to your codebase, told you "this fixes the bug," and the tests it ran came back green. Why might you still want to read the actual diff against the prior commit before trusting the change, and what specifically would you look for in that diff?

<!-- Rewriter audit trail
Lightly touches P4/P5 (the checkpoint question seeds the verify-the-artifact discipline — trust git diff over text claim — that Chapter 12 develops). Mechanical foundation otherwise (git init, add, commit, log). Core untouched in this rewrite pass.
Rewrite date: 2026-05-13
-->
