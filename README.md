# Claude Orchestration

A multi-session orchestration framework for [Claude Code](https://claude.ai/code). Coordinate parallel AI coding sessions using a single command.

## The Problem

Complex features often need parallel work streams — backend, frontend, tests. Running these in a single Claude Code session means sequential execution and context overload. Running them in separate sessions means manually copy-pasting prompts and tracking state across terminals.

## The Solution

Run `/alpha` and describe what you're building. Alpha designs the work plan, spawns background agents in isolated git worktrees, and reviews their output — while you keep chatting with it about architecture, asking questions, or brainstorming. One terminal, one conversation.

```
You <-> Alpha (interactive, persistent conversation)
          |-- spawns Beta agent  (background, worktree)
          |-- spawns Gamma agent (background, worktree)
          |
          |   <- you keep chatting with Alpha here ->
          |
          |-- Beta completes -> Alpha reviews -> polish if needed
          |-- Gamma completes -> Alpha reviews -> polish if needed
          '-- spawns Delta agent (haiku, mechanical verification)
```

When you need to interactively pair with a session — talk through a problem, guide decisions — you can run `/beta`, `/gamma`, etc. in a separate terminal instead.

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

1. Open a terminal and start Claude Code
2. Type `/alpha`
3. Describe what you're building
4. Alpha designs the session plan, writes the orchestration file, and spawns agents
5. Keep chatting with Alpha while agents work in the background
6. Alpha reviews each agent's output when it completes
7. Alpha dispatches Delta to run mechanical verification

That's it. One terminal, one conversation.

### Interactive pairing (optional)

If you need to work through something with a session directly:

1. Open a new terminal
2. Run `/beta`, `/gamma`, or `/delta`
3. The session reads its task from the orchestration file and you can pair with it

## Upgrading

Re-run the install script:

```bash
curl -fsSL https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/install.sh | bash
```

The script detects an existing installation and upgrades the command files. Your `orchestration/session-orchestration.md` is preserved if you have an active effort — it won't be overwritten.

Safe to run mid-effort. The updated commands are backwards-compatible with existing orchestration and coordination files.

## How It Works

### Two gates, two jobs

The framework has two review gates with distinct responsibilities:

| | Alpha (design review) | Delta (mechanical verification) |
|---|---|---|
| **Checks** | Contract adherence, architectural fit, naming, structure, cross-session consistency | Typecheck, lint, tests, build |
| **Output** | Polish items for sessions to fix | Pass/fail report |
| **Edits code?** | No | No |
| **Model** | Opus/Sonnet (needs judgment) | Haiku (runs commands, reports output) |
| **When** | After each session completes | After all polish is done |

Alpha never runs tests. Delta never gives design opinions. Clean separation.

### Agent mode vs manual mode

**Agent mode (primary):** Alpha spawns sessions as background agents in isolated git worktrees. You stay in one terminal, one conversation. Agents run in parallel without file conflicts.

**Manual mode (fallback):** You open separate terminals and run `/beta`, `/gamma`, etc. Use this when you want to interactively pair with a session — talk through problems, guide decisions in real-time.

You can mix modes in the same effort. Start Beta as an agent, but if it hits a blocker, pick it up manually in a new terminal.

### The orchestration file

Alpha writes `orchestration/session-orchestration.md` for each effort. It contains:

- **Session table** — who's doing what
- **Session prompts** — detailed task descriptions for each session
- **API contracts** — interfaces that sessions must agree on

### The coordination file

A markdown file in Claude's memory (`coordination.md`) that all sessions read and write. It contains:

- **API contracts** — shared interfaces
- **Decisions log** — dated decisions made during the effort
- **Per-session sections** — progress, files changed, polish items

Each session owns its section. Alpha resolves conflicts.

## Slash Commands

| Command | Role | Description |
|---------|------|-------------|
| `/alpha` | Brain | Plans the effort, spawns agents, does design reviews |
| `/beta` | Session B | Manual/interactive mode for pairing |
| `/gamma` | Session C | Manual/interactive mode for pairing |
| `/delta` | Test gate | Mechanical verification (typecheck, lint, tests) |
| `/polish` | Cleanup | Fixes polish items from Alpha's review |

Commands are generic and static — never edit them. Alpha writes effort-specific prompts into the orchestration file, not into the command files.

## Session Lifecycle

```
/alpha (plan + dispatch)
    |-- Beta agent (background, worktree)
    |-- Gamma agent (background, worktree)
    |
    |   Alpha reviews each on completion
    |   Alpha dispatches polish agents if needed
    |
    '-- Delta agent (haiku, mechanical verification)
```

## Tips

- **Don't over-session** — if a task takes 20 minutes, just do it in Alpha
- **Date your decisions** — use absolute dates in the coordination file
- **Good splits**: by layer (backend/frontend), by concern (code/tests), by independence (different files)
- **Bad splits**: two sessions editing the same files, tightly coupled work
- **Use haiku for Delta** — it's running commands and reporting output, not making judgment calls
- **Switch to manual mode** when you need to pair — agent mode is for autonomous work

## License

MIT
