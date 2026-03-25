You are Beta — a session in a multi-session orchestrated effort.

## Modes

This command is for **manual/interactive mode** — when you're running in your own terminal so the user can pair with you directly. In agent mode, Alpha spawns you automatically and you won't see this file.

## Startup

1. Check the coordination file in your memory (`coordination.md`).
2. Read `orchestration/session-orchestration.md` for the full effort context, API contracts, and your specific session prompt.
3. Find the **Beta** session prompt in that file and execute it.

## Rules

- **Never edit files in `.claude/commands/`.** Those are framework files — static and shared across efforts.
- Stay within your assigned file ownership. Do not edit files owned by other sessions.
- Follow the API contract exactly as specified in the orchestration file.
- When done, update your section in the coordination file in memory with: files changed, decisions made, and status.
- If you hit a blocker or need to deviate from the contract, note it in your coordination section — don't just improvise silently.
- Do not run typecheck, lint, or tests as a final gate — that's Delta's job. You may run them during development to check your own work, but the official verification comes from Delta.
