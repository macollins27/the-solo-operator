# The Solo Operator's Manual

> Authored by **Maxwell Collins**. Source repo: `https://github.com/macollins27/the-solo-operator`. MIT-licensed (see `LICENSE`). Free to fork, modify, and deploy for your own use.

A self-paced course that teaches you to operate AI as an engineering team. The result: you can produce software at acquisition-grade quality, with one operator (you) running 20-40 agents instead of hiring 20-40 engineers.

This is the **only** page in the course you'll read by yourself. Everything else is taught by an AI tutor that lives in this repo. You install some tools, fork this repo, type a few commands, and your tutor takes it from there. The tutor walks you through every concept, every exercise, and every line of code you'll write.

You do not need any prior computer experience. If you can use a web browser and send email, you can do this.

---

## What you'll need

**Hardware:** a Mac (any model from the last 5 years) or a Windows PC (Windows 10 or later, with at least 8 GB of RAM).

**Internet connection.** You'll be using AI services that talk to the internet.

**About 30 minutes for the one-time setup below.** After that, you can take the course at any pace.

**One free account:**
- An **Anthropic account** at https://console.anthropic.com — this is the company that makes Claude (the AI you'll be working with). The free tier gives you enough usage to do the first several chapters. Later you may want a paid plan.

**One free tool you'll install:**
- **Claude Code** — Anthropic's official AI engineering tool. It runs in your terminal (the black-screen text-input thing on your computer). You don't need to know what a terminal is yet; the setup below shows you exactly where to find it.

That's it. Nothing else to buy, sign up for, or learn before starting.

---

## Setup — Mac

Do each step in order. If a step doesn't work, scroll down to the Troubleshooting section.

### Step 1 — Open your Terminal

Press `⌘ + Space` to open Spotlight search. Type `Terminal` and press Return.

A window opens with a small prompt that looks something like `username@MacBook ~ %`. This is your **terminal**. It's how you talk to your computer using text instead of clicking.

Leave this window open. You'll use it for every step below.

### Step 2 — Install Homebrew

Homebrew is the standard tool for installing other tools on a Mac. You install it once and then use it to install everything else.

Copy this entire line, paste it into your terminal, and press Return:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

It will ask for your Mac password (the one you use to log in). Type it and press Return. (You won't see the characters as you type — that's normal.)

The install takes a few minutes. When it finishes, you'll see the prompt again. If the output mentions a "Next steps" section asking you to run two more commands, run those too.

### Step 3 — Install Python and Git

In the same terminal window, run:

```
brew install python@3.11 git
```

This installs Python 3.11 (used by the course's tutor backend) and Git (used to fork and clone the course). Wait for it to finish.

### Step 4 — Install Claude Code

In the same terminal window, run:

```
brew install anthropics/claude-code/claude-code
```

When it finishes, confirm it worked by running:

```
claude --version
```

You should see a version number. If you see "command not found," close your terminal, reopen it (⌘ + Space → Terminal), and try `claude --version` again.

### Step 5 — Sign in to Claude Code

Run:

```
claude
```

Claude Code will open and ask you to sign in. Follow the prompts — it'll open a browser to the Anthropic site, you sign in (or create an account), and the browser sends you back to your terminal.

When you see a chat prompt that says something like `>` waiting for your input, you're signed in. Type `/exit` and press Return to close it for now.

### Step 6 — Fork this course on GitHub

In your web browser, go to the URL of this course's repo (the same place you got this README). On the upper-right of the page, click the **Fork** button. This creates your own personal copy of the course on GitHub.

If you don't have a GitHub account yet, sign up at https://github.com — it's free. Then fork.

### Step 7 — Clone your fork

Back in your terminal, run:

```
cd ~
git clone https://github.com/YOUR-USERNAME/the-solo-operator.git
cd the-solo-operator
```

Replace `YOUR-USERNAME` with your actual GitHub username. After this, your terminal is "inside" the course repo on your computer.

### Step 8 — Install the course's MCP server

The course has a small backend service that tracks your progress. Install it:

```
cd mcp-servers/course-curriculum
python3 -m venv .venv
source .venv/bin/activate
pip install -e .
cd ../..
```

You should see no errors. If you do, skip to Troubleshooting.

### Step 9 — Start your first session

Run:

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

---

## Setup — Windows

Do each step in order. If you get stuck, scroll down to Troubleshooting.

### Step 1 — Open PowerShell

Press the Windows key. Type `PowerShell`. Right-click "Windows PowerShell" and choose "Run as administrator."

A blue window opens with a prompt. This is your **terminal** on Windows.

### Step 2 — Install Git and Python

In the PowerShell window, run:

```
winget install --id Git.Git -e
winget install --id Python.Python.3.11 -e
```

Close the PowerShell window and reopen it (so the new tools are available).

### Step 3 — Install Claude Code

In the new PowerShell window:

```
winget install --id Anthropic.ClaudeCode -e
```

When it finishes, confirm with:

```
claude --version
```

### Step 4 — Sign in to Claude Code

Run `claude`. Sign in via the browser prompt. Then `/exit` to close.

### Step 5 — Fork the course on GitHub

Same as the Mac instructions, Step 6. Use your web browser. Click "Fork" on the GitHub page.

### Step 6 — Clone your fork

In PowerShell:

```
cd $HOME
git clone https://github.com/YOUR-USERNAME/the-solo-operator.git
cd the-solo-operator
```

Replace `YOUR-USERNAME`.

### Step 7 — Install the MCP server

```
cd mcp-servers\course-curriculum
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -e .
cd ..\..
```

If PowerShell complains about script execution policy, run this first and then re-try:

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Step 8 — Start your first session

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

**"command not found: claude" after installing.** Close your terminal completely, reopen it, and try again. If it still says that, the install probably failed; re-run the install command and watch for error messages.

**"command not found: brew" on Mac.** The Homebrew installer printed "Next steps" you didn't run. Look back in your terminal for those lines (they start with `echo` and `eval`) and run them.

**Python install issues on Mac.** Run `brew doctor` to diagnose. If it suggests `xcode-select --install`, run that.

**"could not authenticate" when signing in to Claude Code.** Visit https://console.anthropic.com directly, sign in successfully there first, then re-run `claude`.

**Forgot your GitHub username.** Log in at https://github.com and look at the top-right corner.

**Git asks for credentials when cloning.** If it's a public repo, you shouldn't need any. If git asks anyway, press Return to skip — it should still work.

**The MCP install fails with `pip: command not found`.** On Mac, try `pip3` instead. On Windows, make sure you've activated the virtual environment with the activation script in Step 7.

**You typed "teach me" and nothing useful happened.** Check that Claude said something like "Welcome back" or asked you about prompting vs. operating. If Claude is talking about something unrelated, type "I'm taking the Solo Operator's Manual course; please load the pedagogy SKILL and the course-curriculum MCP." If that still doesn't work, exit (`/exit`), re-open in the repo directory, and try again.

**Something else broke.** Type a description of the problem into Claude — it can usually diagnose. If it can't, open an issue on the original course repo (the one you forked from).

---

## After you finish

You'll have a working piece of software (a community membership manager you can deploy for any group you're in), a personal copy of the course with all your work committed, and — most importantly — the operating skills that let you build the next thing on your own.

The course is yours to fork, modify, share with others, or use as a starting point for your own teaching projects.

Welcome to the Solo Operator's Manual. Open your terminal and let's get started.
