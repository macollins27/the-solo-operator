# The Solo Operator's Manual

> Authored by **Maxwell Collins**. Source repo: `https://github.com/macollins27/the-solo-operator`. MIT-licensed (see `LICENSE`). Free to fork, modify, and deploy for your own use.

A self-paced course that teaches you to operate AI as an engineering team. The result: you can produce software at acquisition-grade quality, with one operator (you) running 20-40 agents instead of hiring 20-40 engineers.

This is the **only** page in the course you'll read by yourself. Everything else is taught by an AI tutor that lives in this repo. You install some tools, fork this repo, type a few commands, and your tutor takes it from there. The tutor walks you through every concept, every exercise, and every line of code you'll write.

You do not need any prior computer experience. If you can use a web browser and send email, you can do this.

---

## What you'll need

**Hardware:** a Mac (macOS 13 or later, any Mac from the last 5 years) or a Windows PC (Windows 10 1809+, with at least 4 GB of RAM).

**Internet connection.** You'll be using AI services that talk to the internet.

**Accounts you'll need (both free to create):**

- **A Claude account with a paid plan.** Claude Code requires a Pro, Max, Team, or Enterprise subscription — the free Claude.ai tier does NOT work for Claude Code. Sign up at `https://claude.com/`. The cheapest plan that includes Claude Code is Pro.
- **A GitHub account** at `https://github.com/`. Free. Used to fork this course repo to your own copy.

**About 30 minutes** for the one-time setup. After that you can take the course at any pace.

---

## Setup — macOS

Do each step in order. After every step there's a verification command — run it; you should see the output it describes. If you don't, scroll down to Troubleshooting.

### Step 1 — Open your Terminal

Press `⌘ + Space` to open Spotlight search. Type `Terminal` and press Return. A window opens with a small prompt that looks something like `username@MacBook ~ %`. This is your **terminal**. Leave it open; you'll use it for every step below.

### Step 2 — Install Claude Code

Copy this command, paste it into your terminal, and press Return:

```
curl -fsSL https://claude.ai/install.sh | bash
```

The installer downloads Claude Code and puts it in `~/.local/bin/`. When it finishes, **close your terminal completely and reopen it** (so the new PATH takes effect).

**Verify:** in the new terminal, run:

```
claude --version
```

You should see a version number like `2.x.x`. If you see "command not found," see Troubleshooting.

### Step 3 — Install Python and Git

Claude Code is installed. Now we install two more tools the course needs.

If you don't already have Homebrew (most beginners won't), install it first:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

It will ask for your Mac login password. Type it (the characters won't appear — that's normal) and press Return. When it finishes, look for a "Next steps" section in the output. On Apple Silicon Macs (M1/M2/M3/M4 — any Mac from 2020 onward), it will tell you to run two commands that look like:

```
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Run them exactly as printed. This step is load-bearing on Apple Silicon — without it, `brew` won't be on your PATH.

**Verify:**

```
brew --version
```

You should see a version number. Then install Python 3.11+ and Git:

```
brew install python git
```

**Verify:**

```
python3 --version
git --version
```

Both should print version numbers (Python 3.11.x or later; any git version).

### Step 4 — Sign in to Claude Code

```
claude
```

Claude Code opens and asks you to sign in. It opens a browser to claude.com — sign in with your Claude account. The browser sends you back to your terminal.

When you see a small prompt that says `>` waiting for your input, you're signed in. Type `/exit` and press Return to close it for now.

### Step 5 — Fork this course on GitHub

In your web browser, visit `https://github.com/macollins27/the-solo-operator`. On the upper-right of the page, click the **Fork** button. This creates your own personal copy of the course on GitHub at `https://github.com/YOUR-USERNAME/the-solo-operator`.

If you don't have a GitHub account yet, sign up first at `https://github.com/` — it's free.

### Step 6 — Clone your fork

In your terminal, run (replace `YOUR-USERNAME` with your actual GitHub username):

```
cd ~
git clone https://github.com/YOUR-USERNAME/the-solo-operator.git
cd the-solo-operator
```

**Verify:**

```
ls
```

You should see folders including `appendices/`, `canonical-project/`, `parts/`, `mcp-servers/`, and files including `README.md`, `CLAUDE.md`, `LICENSE`.

### Step 7 — Install the course's MCP server

The course has a small backend service that tracks your progress. Install it inside a virtual environment so it doesn't affect any other Python on your machine:

```
cd mcp-servers/course-curriculum
python3 -m venv .venv
.venv/bin/pip install -e .
cd ../..
```

**Verify:**

```
ls mcp-servers/course-curriculum/.venv/bin/python3
```

Should print the path (no "no such file" error). The course's `.mcp.json` is pre-configured to use this Python interpreter, so Claude Code will find the MCP server automatically when you next run `claude` from the repo root.

### Step 8 — Start your first session

```
claude
```

You're now in Claude Code, inside the course repo. The course's tutor protocol auto-loads.

Type:

```
teach me
```

And press Return.

The tutor reads your state (you're a new student), opens the orientation chapter, and starts your first lesson. From here on, the tutor takes over. You'll have a conversation. The tutor will explain, ask questions, give you small exercises, and verify your work. You progress one chapter at a time. The course remembers where you left off between sessions.

**What success looks like:** after typing `teach me`, you should see Claude respond with a welcome question — not a dump of chapter content. Something like "Welcome. Before we get into anything, a question: have you ever asked an AI to write code and gotten something that looked right but didn't actually work?" If you see that, the tutor is loaded. If Claude responds generically (like a normal chat), see Troubleshooting.

---

## Setup — Windows

Do each step in order.

### Step 1 — Open PowerShell

Press the Windows key. Type `PowerShell`. Right-click "Windows PowerShell" and choose "Run as administrator." A blue window opens with a prompt that starts with `PS C:\`.

### Step 2 — Allow PowerShell to run scripts (one-time setup)

By default, Windows blocks PowerShell from running scripts. Run this once to allow it:

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Press `Y` and Return when prompted. This affects only your user, only locally — it's the standard developer setup.

### Step 3 — Install Claude Code

```
irm https://claude.ai/install.ps1 | iex
```

The installer downloads Claude Code. When it finishes, **close PowerShell and reopen it** (so the new PATH takes effect).

**Verify:** in the new PowerShell window:

```
claude --version
```

You should see a version number.

### Step 4 — Install Git and Python

```
winget install --id Git.Git -e
winget install --id Python.Python.3.12 -e
```

Close PowerShell and reopen it.

**Verify:**

```
git --version
python --version
```

Both should print version numbers.

### Step 5 — Sign in to Claude Code

```
claude
```

Sign in via the browser prompt. Then `/exit`.

### Step 6 — Fork the course on GitHub

Same as the Mac instructions, Step 5. Visit `https://github.com/macollins27/the-solo-operator` and click **Fork**.

### Step 7 — Clone your fork

```
cd $HOME
git clone https://github.com/YOUR-USERNAME/the-solo-operator.git
cd the-solo-operator
```

Replace `YOUR-USERNAME` with your actual GitHub username.

### Step 8 — Install the MCP server

```
cd mcp-servers\course-curriculum
python -m venv .venv
.\.venv\Scripts\pip install -e .
cd ..\..
```

**Verify** the venv Python exists:

```
dir mcp-servers\course-curriculum\.venv\Scripts\python.exe
```

If the path printed, you're good. (On Windows the venv puts `python.exe` under `Scripts/` instead of `bin/`. The course's `.mcp.json` assumes the Mac/Linux `bin/python3` path — if Claude Code can't find the MCP server on Windows, open `.mcp.json` in any text editor and change the command line from `mcp-servers/course-curriculum/.venv/bin/python3` to `mcp-servers\course-curriculum\.venv\Scripts\python.exe` and save.)

### Step 9 — Start your first session

```
claude
```

Type `teach me` and press Enter.

---

## What happens after "teach me"

Your tutor (Claude) reads where you left off, opens the active chapter, and walks you through it in conversation. You will:

- Have a back-and-forth chat about a single concept
- Get a small exercise (3 mini-tasks, not one big one) to do on your machine
- Run a verification command at the end (`bash parts/.../verify.sh ./student`) that confirms your work
- Answer a checkpoint question that proves you understood the concept, not just executed the steps
- Advance to the next chapter when both checks pass

You can stop at any time. The next time you run `claude` and type "teach me," you pick up exactly where you left off.

There are 44 chapters across 6 parts (plus a Part 0 orientation). You don't have to finish them all. Each chapter you complete makes you a better operator than you were before.

---

## Troubleshooting

**"command not found: claude" after installing.** Close your terminal completely, reopen it, and try again. If still missing, the installer's PATH update didn't take effect — on Mac add `export PATH="$HOME/.local/bin:$PATH"` to `~/.zshrc` and reopen; on Windows reboot.

**"command not found: brew" on Mac.** The Homebrew installer printed "Next steps" with `eval` lines you didn't run. Look back in your terminal for them; they need to run before `brew` works.

**Python install issues on Mac.** Run `brew doctor`. If it suggests `xcode-select --install`, run that.

**"could not authenticate" when signing in to Claude Code.** Visit `https://claude.com/` directly, sign in successfully there (with a Pro/Max/Team account), then re-run `claude`. The free tier doesn't include Claude Code.

**The MCP server fails to start (you see "MCP server failed" or no tutor response).** From the repo root, run `mcp-servers/course-curriculum/.venv/bin/python3 mcp-servers/course-curriculum/server.py` manually and read the error. Most likely the venv install in Step 7 didn't complete — re-run it.

**Forgot your GitHub username.** Log in at `https://github.com/` and look at the top-right corner.

**You typed "teach me" and got a generic Claude reply instead of the tutor.** The pedagogy SKILL isn't loading. Confirm: (a) you're inside the cloned repo (`pwd`), (b) the file `.claude/skills/pedagogy/SKILL.md` exists (`ls .claude/skills/pedagogy/`), (c) the file `.mcp.json` exists at the repo root, (d) the MCP venv from Step 7 was installed. If all four are present and it still doesn't work, type this in your session: "Read .claude/skills/pedagogy/SKILL.md and follow it. The student_id is 'default-student'." That force-bootstraps the tutor.

**Windows PowerShell vs CMD.** If you see `'irm' is not recognized as an internal or external command`, you're in CMD, not PowerShell. Your prompt shows `PS C:\` when you're in PowerShell. If you're in CMD, switch to PowerShell (Windows key → type "PowerShell" → right-click → Run as administrator).

**Something else broke.** Type a description of the problem into Claude — it can usually diagnose. If it can't, open an issue on the source repo at `https://github.com/macollins27/the-solo-operator/issues`.

---

## After you finish

You'll have a working piece of software (a community membership manager you can deploy for any group you're in), a personal copy of the course with all your work committed, and — most importantly — the operating skills that let you build the next thing on your own.

The course is yours to fork, modify, share with others, or use as a starting point for your own teaching projects.

Welcome to the Solo Operator's Manual. Open your terminal and let's get started.
