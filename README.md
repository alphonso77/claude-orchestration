# Claude Orchestration

A multi-session orchestration framework for [Claude Code](https://claude.ai/code). Coordinate parallel AI coding sessions using slash commands.

## The Problem

Complex features often need parallel work streams — backend, frontend, tests. Running these in a single Claude Code session means sequential execution and context overload. Running them in separate sessions means manually copy-pasting prompts and tracking state across terminals.

## The Solution

Run `/alpha` and describe what you're building. Alpha designs the work plan and writes session prompts into a shared coordination file. You launch sessions in separate terminals — each one reads its task automatically.

- **Plan** with `/alpha` — design the effort, define API contracts, assign sessions
- **Build** with `/beta`, `/gamma`, etc. — each session reads its task from the coordination file
- **Review & polish** — Alpha reviews each session's output, writes polish items, session runs `/polish`
- **Verify** with `/delta` — dedicated test gate session

Sessions coordinate through a single file:
- **`coordination.md` in Claude memory** — the effort plan, session prompts, API contracts, progress tracking

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

# Clean up
rm -rf /tmp/claude-orchestration
```

### Use

1. Open a terminal and start Claude Code
2. Type `/alpha`
3. Describe what you're building
4. Alpha designs the session plan and writes prompts into the coordination file
5. Open new terminals, rename them (right-click > Rename), and run `/beta`, `/gamma`, etc.
6. When sessions finish, come back to Alpha for code review
7. Run `/polish` in each session to address review feedback
8. Run `/delta` to verify everything

### Upgrading

Re-run the install script:

```bash
curl -fsSL https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/install.sh | bash
```

The script detects an existing installation and upgrades the command files. Safe to run mid-effort.

## Slash Commands

| Command | Role | Description |
|---------|------|-------------|
| `/alpha` | Brain | Plans the effort, writes coordination file, does design reviews |
| `/beta` | Session B | Reads its task from the coordination file |
| `/gamma` | Session C | Reads its task from the coordination file |
| `/delta` | Test gate | Mechanical verification (typecheck, lint, tests) |
| `/polish` | Cleanup | Reads polish items from the session's own coordination section |

Commands are generic and static — never edit them. Alpha writes effort-specific prompts into the coordination file, not into the command files.

## Session Lifecycle

```
/alpha (plan)
    ├── /beta (build) ──> Alpha reviews ──> /polish (fix)
    ├── /gamma (build) ──> Alpha reviews ──> /polish (fix)
    └── /delta (verify)
```

1. **Alpha plans** -> writes coordination file with session prompts and API contracts
2. **Sessions build** -> `/beta` and `/gamma` run in parallel terminals, each reading their prompt
3. **Alpha reviews** -> design review, writes polish items into coordination file
4. **Sessions polish** -> `/polish` in each session to address feedback
5. **Delta verifies** -> typecheck, lint, tests, feature smoke test

## How It Works

### Two gates, two jobs

The framework has two review gates with distinct responsibilities:

| | Alpha (design review) | Delta (mechanical verification) |
|---|---|---|
| **Checks** | Contract adherence, architectural fit, naming, structure, cross-session consistency | Typecheck, lint, tests, build |
| **Output** | Polish items for sessions to fix | Pass/fail report |
| **Edits code?** | No | No |
| **When** | After each session completes | After all polish is done |

Alpha never runs tests. Delta never gives design opinions. Clean separation.

### The Coordination File

Alpha writes `coordination.md` in Claude's memory for each effort. It contains:

- **Session table** — who's doing what
- **Session prompts** — detailed task descriptions (under `## Beta Prompt`, `## Gamma Prompt`, etc.)
- **API contracts** — interfaces that sessions must agree on
- **Decisions log** — dated decisions made during the effort
- **Per-session sections** — progress, files changed, polish items

Each session reads its prompt from this file and updates its own section. Alpha resolves conflicts.

### Why Manual Sessions for Code Writing

Code-writing sessions are always launched manually by the user in separate terminals. All sessions can spawn read-only agents (research, code exploration, analysis), but code-writing agents hit persistent issues:

- **Auth errors** — spawned agents lose their API session
- **Worktree confusion** — uncommitted changes aren't visible to worktree agents
- **Fallback to sequential** — Alpha ends up doing the work itself, defeating the purpose

Manual sessions are fully authenticated Claude Code instances that just work.

## Tips

- **Rename your VS Code terminals** to match session names (Alpha, Beta, etc.)
- **Don't over-session** — if a task takes 20 minutes, just do it in Alpha
- **Date your decisions** — use absolute dates in the coordination file
- **Good splits**: by layer (backend/frontend), by concern (code/tests), by independence (different files)
- **Bad splits**: two sessions editing the same files, tightly coupled work

## License

MIT
