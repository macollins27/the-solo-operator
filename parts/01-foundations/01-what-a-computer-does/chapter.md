# Chapter 1 — What a computer actually does

## Learning objective

The student can name the four parts of a working computer (CPU, RAM, storage, operating system), explain what each one does in their own words using an everyday analogy, and predict where their data goes when they save a file or quit a program.

## Prerequisites

- Completed: Chapter 0 — Why You're Here
- Concepts: prompting-vs-operating

## Core concept

A computer, no matter how shiny, is four things working together. Once you can name them, every command you ever type starts making sense — because every command moves data between these four parts.

Think of a kitchen.

**The CPU is the cook.** It's the part that actually does the work. When you open an app, it's the cook reading instructions and acting on them. When the cook is slow or overwhelmed, your computer feels slow. The cook can only think about one or two things at a time, but it can switch between them very fast.

**RAM is the counter.** Whatever the cook is actively working on right now sits on the counter. Recipes mid-flip, ingredients being chopped, the timer on the burner. The counter is fast to reach but small. When you close a program, you're clearing the counter — anything not put away is gone.

**Storage is the pantry.** Everything you've saved lives in the pantry — your photos, your documents, your installed programs. The pantry is huge and the contents survive when the cook goes to sleep (when you shut down your computer). But it's slower to reach than the counter. Each time the cook needs an ingredient, they walk to the pantry, grab it, bring it to the counter.

**The operating system is the kitchen manager.** It decides which cook can use which burner, schedules who gets the counter when, opens and closes the pantry, and keeps the whole kitchen from descending into chaos. macOS, Windows, and Linux are all kitchen managers. They look different but they do the same job.

A **file** is a named thing in the pantry. A folder is just a labeled shelf — it groups files but is itself stored in the pantry. A **process** is what's actively happening on the counter right now: a recipe being executed, an app running. When you "open an app," the manager copies its instructions from the pantry to the counter and the cook starts following them. When you "quit," the manager clears that recipe from the counter. The recipe is still in the pantry; it's just not being cooked right now.

This is everything you need to know about computers as a mental model for the rest of the course. Every command you'll ever type moves data between these four parts. Save a file? Counter to pantry. Open a file? Pantry to counter. Quit a program? Clear it from the counter. Install something? Add a new recipe to the pantry. Crash? The cook lost their place on the counter and the manager intervened.

## Worked example

Open your MembershipKit course repo on your computer. (You cloned it during setup — it lives somewhere like `~/the-solo-operator/`.)

That folder is **on disk** — in the pantry. The files inside it are recipes the kitchen has on hand but is not currently cooking. You can shut your computer down, and tomorrow those files will still be there.

Now imagine you run a command (you'll learn how next chapter). The kitchen manager finds the relevant recipe, copies its instructions from the pantry onto the counter, hands them to a cook, and the cook starts executing. While it runs, that copy of the recipe is **in memory** — on the counter. When it finishes, the counter is cleared. The original recipe stays untouched in the pantry.

If the program changes a file (say, writes new lines to it), here's what actually happens: the cook works on a copy on the counter, then when you "save" or the program writes to disk, the manager moves the new version back to the pantry, replacing the old one. Without that save step, the changes are only on the counter — and the counter gets wiped when the cook leaves.

That's why "did you save?" is the eternal question of computing. Save = your changes made it to the pantry. No save = your changes were only on the counter, and the counter is gone.

## The rule

> Your data lives in one of two places at any moment: on disk (the pantry — permanent) or in memory (the counter — temporary). Every save copies counter to pantry. Every load copies pantry to counter. The cook only ever works on what's on the counter.

## Common mistakes

**Mistake 1 — "The computer is one thing."** Treating a computer as a single magical box makes every problem mysterious. Once you can name the four parts, you can ask better questions. "Is the cook slow, or is the counter full?" is a real diagnostic question. "My computer is slow" is not.

**Mistake 2 — Confusing memory and storage.** People casually say "memory" for both, which makes no sense once you know the difference. RAM is the counter (small, fast, temporary). Storage is the pantry (large, slower, permanent). When a salesperson says "this computer has 16 GB of memory and 512 GB of storage" they mean 16 GB of counter and 512 GB of pantry. They are very different numbers measuring very different things.

**Mistake 3 — Assuming closed apps remember what you were doing.** A closed app is a recipe back in the pantry. The work-in-progress that was on the counter is gone unless the app explicitly saved it before closing. Modern apps mostly auto-save, but not always. Always assume closing = clearing the counter for that app.

## Drill

Open your course repo in your terminal (you'll learn the terminal properly next chapter — for this drill you just need to find the folder on your computer). All three drills produce a file in `student/drills/01-what-a-computer-does/` inside your fork of the repo. Create that folder first if it doesn't exist.

**Drill 1 — Visit the pantry.** Open Finder (Mac) or File Explorer (Windows). Navigate to your course repo folder. Take a screenshot of the folder's contents and save it to `student/drills/01-what-a-computer-does/01-repo-folder.png`. This is the pantry section of your computer that holds this course.

**Drill 2 — Inventory the pantry.** Look inside the `canonical-project/` folder of the course repo. Pick any 5 files you see. Create a plain text file at `student/drills/01-what-a-computer-does/02-my-files.txt` and write the 5 filenames inside, one per line. These are recipes in the pantry, currently not being cooked.

**Drill 3 — Observe a cook at work.** Open Activity Monitor (Mac, find it via Spotlight) or Task Manager (Windows, press `Ctrl + Shift + Esc`). Pick any running process — your web browser is a good one. Write its name to `student/drills/01-what-a-computer-does/03-one-process.txt` on a single line. That process is a recipe currently on the counter.

After all three files exist, your tutor will run `verify.sh` to confirm them mechanically.

## Checkpoint question

> You just typed in your favorite music app and saved a new playlist. Then you quit the app. Where did the playlist go — to the counter, to the pantry, or both? And how do you know it'll still be there when you reopen the app tomorrow?
