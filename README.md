# Claude Orchestration

A multi-session orchestration framework for [Claude Code](https://claude.ai/code). Coordinate parallel AI coding sessions using slash commands.

## The Problem

Complex features often need parallel work streams — backend, frontend, tests. Running these in a single Claude Code session means sequential execution and context overload. Running them in separate sessions means manually copy-pasting prompts and tracking state across terminals.

## The Solution

Claude Orchestration gives you a set of reusable slash commands and a coordination pattern that lets you:

- **Plan** with `/alpha` — design the effort, define API contracts, assign sessions
- **Build** with `/beta`, `/gamma`, etc. — each session reads its task from a shared orchestration file
- **Review & polish** — Alpha reviews each session's output, writes polish items, session runs `/polish`
- **Verify** with `/delta` — dedicated test gate session

Sessions coordinate through two files:
1. **`orchestration/session-orchestration.md`** — the effort plan (prompts, contracts, status)
2. **`coordination.md` in Claude memory** — shared state that all sessions read and write

## Quick Start

### Install

Copy the files into your project:

```bash
# From your project root
curl -fsSL https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/install.sh | bash
```

Or manually copy:
```bash
# Clone this repo
git clone https://github.com/alphonso77/claude-orchestration.git /tmp/claude-orchestration

# Copy into your project
cp -r /tmp/claude-orchestration/.claude/commands/ .claude/commands/
cp -r /tmp/claude-orchestration/orchestration/ orchestration/

# Clean up
rm -rf /tmp/claude-orchestration
```

### Use

1. Open a terminal in VS Code and start Claude Code
2. Type `/alpha`
3. Describe what you're building
4. Alpha designs the session plan and tells you which sessions to launch
5. Open new terminals, rename them (right-click → Rename), and run `/beta`, `/gamma`, etc.
6. When sessions finish, come back to Alpha for code review
7. Run `/polish` in each session to address review feedback
8. Run `/delta` to verify everything

## Slash Commands

| Command | Role | Description |
|---------|------|-------------|
| `/alpha` | Brain | Plans the effort, writes orchestration file, does code reviews |
| `/beta` | Session B | Reads its task from the orchestration file |
| `/gamma` | Session C | Reads its task from the orchestration file |
| `/delta` | Test gate | Runs typecheck, lint, tests, and feature verification |
| `/polish` | Cleanup | Reads polish items from the session's own coordination section |

Commands are generic — they never need editing. Alpha writes the specific prompts into the orchestration file each effort.

## Session Lifecycle

```
/alpha (plan)
    ├── /beta (build) ──→ Alpha reviews ──→ /polish (fix)
    ├── /gamma (build) ──→ Alpha reviews ──→ /polish (fix)
    └── /delta (verify)
```

1. **Alpha plans** → writes orchestration file with prompts and API contracts
2. **Sessions build** → `/beta` and `/gamma` run in parallel, each reading their prompt
3. **Alpha reviews** → code review, writes polish items into coordination file
4. **Sessions polish** → `/polish` in each session to address feedback
5. **Delta verifies** → typecheck, lint, tests, feature smoke test

## How It Works

### The Orchestration File

Alpha writes `orchestration/session-orchestration.md` for each effort. It contains:

- **Session table** — who's doing what
- **Session prompts** — detailed task descriptions for each session
- **API contracts** — interfaces that sessions must agree on
- **Polish section** — cleanup items added after code review

### The Coordination File

A markdown file in Claude's memory (`coordination.md`) that all sessions read and write. It contains:

- **API contracts** — shared interfaces
- **Decisions log** — dated decisions made during the effort
- **Per-session sections** — progress, files changed, polish items

Each session owns its section. Alpha resolves conflicts.

### Why This Works

- **No context bleed** — each session has a focused task and limited file ownership
- **No copy-paste** — slash commands bootstrap themselves from the orchestration file
- **Built-in review** — Alpha reviews every session's output before it's considered done
- **Reusable** — the same commands work for any effort, any project

## Tips

- **Rename your VS Code terminals** to match session names (Alpha, Beta, etc.)
- **Don't over-session** — if a task takes 20 minutes, just do it in Alpha
- **Date your decisions** — use absolute dates in the coordination file
- **Good splits**: by layer (backend/frontend), by concern (code/tests), by independence (different files)
- **Bad splits**: two sessions editing the same files, tightly coupled work

## License

MIT
