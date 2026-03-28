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

**macOS / Linux:**

```bash
curl -fsSL https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/install.sh | bash
```

**Windows (PowerShell):**

```powershell
foreach ($skill in @('alpha','beta','gamma','delta','polish')) { New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills\$skill" | Out-Null; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/skills/$skill/SKILL.md" -OutFile "$env:USERPROFILE\.claude\skills\$skill\SKILL.md" }
```

Skills are installed to `~/.claude/skills/` — available globally in all projects, nothing to commit per-repo. The install script cleans up any older installations automatically.

### Upgrade

Re-run the same install command. It detects the existing installation and overwrites the skill files.

### Alternative: Plugin install

If you prefer managed installs through Claude Code's plugin system:

```bash
/plugin marketplace add alphonso77/claude-orchestration
/plugin install orch@claude-orchestration
```

This gives you namespaced commands (`/orch:alpha`, `/orch:beta`, etc.).

### Use

1. Open a terminal and start Claude Code
2. Type `/alpha`
3. Describe what you're building
4. Alpha designs the session plan and writes prompts into the coordination file
5. Open new terminals, rename them (right-click > Rename), and run `/beta`, `/gamma`, etc.
6. When sessions finish, come back to Alpha for code review
7. Run `/polish` in each session to address review feedback
8. Run `/delta` to verify everything
9. Tell Alpha "let's wrap this up" — updates `CLAUDE.md` and resets the coordination file

## Skills

| Skill | Role | Description |
|-------|------|-------------|
| `/alpha` | Brain | Plans the effort, writes coordination file, does design reviews |
| `/beta` | Session B | Reads its task from the coordination file |
| `/gamma` | Session C | Reads its task from the coordination file |
| `/delta` | Test gate | Mechanical verification (typecheck, lint, tests) |
| `/polish` | Cleanup | Reads polish items from the session's own coordination section |

Skills are generic and static — never edit them. Alpha writes effort-specific prompts into the coordination file, not into the skill files.

## Session Lifecycle

```
/alpha (plan)
    ├── /beta (build) ──> Alpha reviews ──> /polish (fix)
    ├── /gamma (build) ──> Alpha reviews ──> /polish (fix)
    ├── /delta (verify)
    └── "let's wrap this up" ──> CLAUDE.md update ──> coordination reset
```

1. **Alpha plans** -> writes coordination file with session prompts and API contracts
2. **Sessions build** -> `/beta` and `/gamma` run in parallel terminals, each reading their prompt
3. **Alpha reviews** -> design review, writes polish items into coordination file
4. **Sessions polish** -> `/polish` in each session to address feedback
5. **Delta verifies** -> typecheck, lint, tests, feature smoke test
6. **Wrap up** -> tell Alpha "let's wrap this up" — Alpha updates `CLAUDE.md` with what the effort changed, then resets the coordination file for the next effort

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

The coordination file is project-scoped — Claude's memory is keyed by project path, so efforts in different repos never interfere with each other.

### Why Manual Sessions (Not Agents)

Sessions are human-launched Claude Code instances in separate terminals, not spawned sub-agents. We tried the agent approach and moved away from it for two reasons:

- **Interruptions** — sub-agents running as Beta/Gamma would interrupt Alpha mid-conversation with permission prompts and status updates, breaking the user's focus
- **Permission blockers** — agents frequently needed approvals that caused cascading context switches, stalling the effort instead of parallelizing it

Manual sessions keep the human in the loop for each work stream. This turns out to be a feature: you stay close to the effort and maintain visibility into the build, even when vibe coding. Each session is a fully authenticated Claude Code instance that just works — no auth errors, no worktree confusion, no fallback to sequential execution.

## Tips

- **Rename your VS Code terminals** to match session names (Alpha, Beta, etc.)
- **Don't over-session** — if a task takes 20 minutes, just do it in Alpha
- **Date your decisions** — use absolute dates in the coordination file
- **Good splits**: by layer (backend/frontend), by concern (code/tests), by independence (different files)
- **Bad splits**: two sessions editing the same files, tightly coupled work

## Privacy

This plugin runs entirely within your local Claude Code environment. It does not collect, transmit, or store any user data. No analytics, no telemetry, no external network calls. The coordination file is stored in Claude's local project-scoped memory on your machine.

## License

MIT
