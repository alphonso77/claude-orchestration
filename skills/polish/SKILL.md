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
5. **Build your todo list before you fix anything.** One item per polish item, and make the last item `Mark the polish items complete in coordination.md`. This matters: the skill file you are reading now enters the conversation once and is never re-read. Your todo list is the only place the write-back step reliably survives to the end of the run.

## Finish

Run these steps once the listed items are addressed, *before* you tell the user you are done. Alpha decides whether another review round is needed by reading the coordination file, so an unmarked item reads as an unfixed one.

1. Mark each polish item complete in your section of `coordination.md` in your project memory directory.
2. For any item you skipped or could not finish, leave it unmarked and note why underneath it.
3. In your final message, state the coordination file path you wrote to. If you did not write to it, say so explicitly and say why.

## Rules

- **Never edit plugin skill files.** Those are framework files — static and shared across efforts.
- Keep changes minimal. Fix what's listed, don't refactor anything else.
- Don't add features, comments, or tests unless explicitly asked.
- **You never create `coordination.md`, but you always write your completed items back into it.** Only Alpha creates the file. If it is missing, stop and ask the user. If it exists, marking your items is part of finishing the polish, not an optional extra.
- If a fix turns out to be more complex than expected, note it and move on — don't rabbit-hole.
- You may spawn sub-agents to work independent polish items in parallel. They stay inside your session's file ownership and the same "only what's listed" rule — a sub-agent is not a licence to refactor.
- Alpha may run multiple review rounds. If you are invoked again after a second review, re-read the coordination file — new polish items may have been added.
