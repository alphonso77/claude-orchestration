---
name: polish
description: Polish — applies the polish items Alpha wrote into this session's coordination-file section after design review. Makes only the listed fixes, no refactors or new features. Invoke with /polish in the session terminal that owns the work.
disable-model-invocation: true
---

Alpha has reviewed your work and added polish items to your section of the coordination file.

## Startup

1. Read `coordination.md` from your project memory directory (`~/.claude/projects/<project-slug>/memory/coordination.md`). This is where Alpha writes it and where all sessions read/update it — not the repo root.
2. **If `coordination.md` is not found, stop.** Do not create one yourself. Tell the user: "I can't find `coordination.md` in the project memory directory. Make sure Alpha has been run, then relaunch `/polish`." Creating the coordination file is Alpha's job.
3. Find **your session's section** and look for the **Polish** subsection.
4. Check if there are multiple rounds of polish items (Alpha may add more after a second review). Work through all incomplete items.

## Rules

- **Never edit plugin skill files.** Those are framework files — static and shared across efforts.
- Keep changes minimal. Fix what's listed, don't refactor anything else.
- Don't add features, comments, or tests unless explicitly asked.
- When done, mark the polish items as complete and write the update to `coordination.md` in your project memory directory.
- **Commit your work.** After updating your coordination.md section, commit your changes with a clear, descriptive message. Alpha's design review is the checkpoint for this framework — you don't need to leave the commit for the user.
  - **Branch guard:** before committing, check the current branch. If it's `main` or `master`, stop and ask the user to confirm before committing (or to switch to a feature branch first). Never commit to `main`/`master` without explicit sign-off.
- **Never create `coordination.md`.** Only Alpha creates it. If missing, stop and ask the user.
- If a fix turns out to be more complex than expected, note it and move on — don't rabbit-hole.
- You may spawn sub-agents to work independent polish items in parallel. They stay inside your session's file ownership and the same "only what's listed" rule — a sub-agent is not a licence to refactor.
- Alpha may run multiple review rounds. If you are invoked again after a second review, re-read the coordination file — new polish items may have been added.
