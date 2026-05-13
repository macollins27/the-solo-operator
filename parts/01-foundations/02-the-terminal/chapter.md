# Chapter 2 — The terminal — text commands as a tool

## Learning objective

The student can open a terminal on their computer, run four basic commands (`pwd`, `ls`, `cd`, `mkdir`), and explain why text commands give an operator more leverage than mouse clicks.

## Prerequisites

- Completed: Chapter 1 — What a computer actually does
- Concepts: what-is-a-file, what-is-an-os

## Core concept

A terminal is a text-based way to give your computer instructions. Instead of clicking through windows, you type a command and press Return. The kitchen manager reads what you typed, finds the right cook, hands them the instructions, and shows you the result. Same kitchen as the one you've been using all along — different interface.

Why bother? Three reasons matter for an operator.

**One — atomicity.** A command is a single, named, repeatable action. "Open Finder, click Documents, click MyProject, double-click chapter.md" is a sequence of clicks with no name and no record. `cat ~/Documents/MyProject/chapter.md` is one command with a name, copyable, share-able, repeatable. When something goes wrong, you can describe exactly what you ran.

**Two — composability.** Commands can feed each other. The OS treats every text command as a small program that reads input and writes output, and you can pipe one program's output into another's input. Mouse clicks can't compose; commands can. This is where most of the leverage comes from.

**Three — scriptability.** A sequence of commands can be saved as a file and run again later. That file is called a **shell script**. Anything you do twice, you can save as a script and never type again. Operators end up with collections of scripts that automate everything they used to do by hand.

The terminal speaks to a program called a **shell**. The shell reads what you type, runs it, shows you the result, and waits for the next command. On macOS the default shell is **zsh**. On Windows the default is **PowerShell**. On Linux it's usually **bash**. They look different but they all do the same job — read text commands, run them, show results.

When you open a terminal you see a **prompt** — some text ending in a symbol like `%` or `$` or `>`. The prompt tells you where you are (your current folder, often called the working directory) and is waiting for input. After every command, the prompt comes back, ready for the next one.

The four commands you need to know first do the things you do with a mouse all the time: see where you are, look at what's around, walk somewhere else, create a new folder.

```
pwd              # print working directory — "where am I?"
ls               # list — "what's in this folder?"
cd <folder>      # change directory — "walk to <folder>"
mkdir <name>     # make directory — "create a folder called <name>"
```

`cd ~` walks to your home folder. `cd ..` walks one folder up. `ls -la` lists with details (file sizes, modification times, hidden files). The conventions repeat themselves; once you know a few you can guess the rest.

## Worked example

Open your terminal. (Mac: ⌘ + Space, type Terminal, press Return. Windows: Win key, type PowerShell, press Enter.)

You'll see a prompt. Try this sequence:

```
pwd
ls
cd ~
pwd
mkdir my-first-folder
ls
cd my-first-folder
pwd
```

After each command, read what the terminal shows. `pwd` prints the full path of where you are. `ls` lists what's in the current folder. `cd ~` walks you to your home folder. `mkdir` creates a new folder. The second `ls` should show your new folder listed alongside the others.

You just did with text what you'd do with about 8–12 mouse clicks. And you can hit the up arrow to recall any of those commands, edit them, and run them again. Or save the whole sequence as a script and run all of it with one command.

The terminal isn't intimidating — it's a faster, more precise way to ask your computer to do the same things you already know how to do.

## The rule

> When you do something with the mouse for the second time, learn the terminal command for it. Anything you can type, you can save, share, repeat, and automate. Anything you can only click, you have to remember.

## Common mistakes

**Mistake 1 — "The terminal is for programmers."** The terminal is for anyone who wants to do work faster and more reliably. Operators live in it because text is leverage. You don't need to be a programmer to use it; you need about 8 commands to handle 80% of daily computer work.

**Mistake 2 — Memorizing instead of looking up.** Every command has a help page. `ls --help` shows what `ls` does and every flag it accepts. `man ls` (on Mac/Linux) shows the full manual. Don't memorize options; know that the help is one keystroke away.

**Mistake 3 — Treating mistakes as scary.** You will type wrong commands. The terminal will say `command not found` or `No such file or directory`. These messages are information, not failure. Read them. They name exactly what went wrong. Fix the typo and re-run.

## Drill

You'll commit text files showing terminal output to `student/drills/02-the-terminal/`. Create that folder first with `mkdir`.

**Drill 1 — Where are you?** Open your terminal. Run `pwd`. Copy the output (the full path it prints) into a file at `student/drills/02-the-terminal/01-my-home.txt`. The file should have one line: the path you saw.

**Drill 2 — What's around you?** Run `ls` (or `ls -la` for more detail). Pipe the output into a file with `ls > student/drills/02-the-terminal/02-around-me.txt`. The `>` means "send the output to this file instead of the screen." Open the file and confirm it lists the contents of wherever `pwd` said you were.

**Drill 3 — Create and verify.** Run `mkdir student/drills/02-the-terminal/scratch` to create a new folder. Then run `ls student/drills/02-the-terminal/` and confirm `scratch` appears in the listing. Save that output to `student/drills/02-the-terminal/03-scratch-exists.txt`.

After all three exist, run the chapter's `verify.sh` to confirm.

## Checkpoint question

> You ran a sequence of 5 commands to set up a project folder last week. Now you want to do it again. With a mouse, you'd click your way through it from memory (and hope you remember). What can you do in the terminal that you can't do with a mouse, that makes "set up the same way I did last week" a one-command operation?
