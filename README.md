# Claude Orchestration

A multi-session orchestration framework for [Claude Code](https://claude.ai/code). Coordinate parallel AI coding sessions using slash commands.

## The Problem

Complex features often need parallel work streams — backend, frontend, tests. Running these in a single Claude Code session means sequential execution and context overload. Running them in separate sessions means manually copy-pasting prompts and tracking state across terminals.

## The Solution

Run `/alpha` and describe what you're building. Alpha designs the work plan and writes session prompts into a shared coordination file. You launch sessions in separate terminals — each one reads its task automatically.

- **Plan** with `/alpha` — design the effort, define API contracts, assign sessions
- **Build** with `/beta`, `/gamma`, etc. — each session reads its task from the coordination file
- **Verify** with `/delta` — dedicated test gate: typecheck, lint, tests, build
- **Review & polish** — Alpha design-reviews the *passing* code, writes polish items, session runs `/polish`

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

### Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/uninstall.sh | bash
```

**How it decides what to delete.** The script looks at exactly ten paths — `~/.claude/skills/<name>/` and `~/.claude/commands/<name>.md`, for each of `alpha`, `beta`, `gamma`, `delta`, and `polish`. For each one it greps the markdown for the literal string `coordination`. On a match it removes the file or directory; otherwise it leaves it alone and lists it under "Left in place" so you can see what it skipped.

That marker is used because all five skills reference the coordination file. The more specific phrase "orchestrated effort" would miss `polish.md`, which has never contained it.

**The edge case.** You read it right: matching the marker is a heuristic for authorship, not proof of it. Two ways that can bite:

- **A skill of your own at one of those five names.** `delta` and `polish` are generic, and "coordination" is an ordinary word — a personal `~/.claude/skills/delta/SKILL.md` that happens to mention coordinating anything looks identical to ours from the script's point of view, and gets deleted.
- **Supporting files inside one of our skill directories.** The match is decided by reading `SKILL.md`, but the removal is `rm -rf` on the whole directory. If you added your own `references/` or scripts alongside one of our skills, they go too.

Neither is recoverable, so preview first if either might apply to you:

```bash
for s in alpha beta gamma delta polish; do
  f=~/.claude/skills/$s/SKILL.md
  [ -f "$f" ] && grep -qF coordination "$f" && echo "would remove: ~/.claude/skills/$s/"
done
```

For comparison, `install.sh` deletes nothing at all. When it finds files from an older layout it prints the `rm` command and lets you run it.

### Alternative: Plugin install

If you prefer managed installs through Claude Code's plugin system:

```bash
/plugin marketplace add alphonso77/claude-orchestration
/plugin install orch@claude-orchestration
```

This gives you namespaced commands (`/orch:alpha`, `/orch:beta`, etc.). To get short commands instead, copy the skills after installing:

**macOS / Linux:**

```bash
for skill in alpha beta gamma delta polish; do mkdir -p ~/.claude/skills/$skill && cp ~/.claude/plugins/marketplaces/claude-orchestration/skills/$skill/SKILL.md ~/.claude/skills/$skill/SKILL.md; done
```

**Windows (PowerShell):**

```powershell
foreach ($skill in @('alpha','beta','gamma','delta','polish')) { New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills\$skill" | Out-Null; Copy-Item "$env:USERPROFILE\.claude\plugins\marketplaces\claude-orchestration\skills\$skill\SKILL.md" "$env:USERPROFILE\.claude\skills\$skill\SKILL.md" }
```

**Note:** Uninstalling the plugin does not remove copied skills. To fully uninstall, also remove them:

```bash
rm -rf ~/.claude/skills/{alpha,beta,gamma,delta,polish}
```

That command has no content check at all — unlike `uninstall.sh`, it removes those five directories whatever is in them. See [Uninstall](#uninstall) for the preview loop if you might have a skill of your own at one of those names.

### Use

1. Open a terminal and start Claude Code
2. Type `/alpha`
3. Describe what you're building
4. Alpha designs the session plan and writes prompts into the coordination file
5. Open new terminals, rename them (right-click > Rename), and run `/beta`, `/gamma`, etc.
6. When sessions finish, run `/delta` to verify — typecheck, lint, tests, build
7. Come back to Alpha for design review of the passing code
8. Run `/polish` in each session to address review feedback, then re-run `/delta` to confirm nothing broke
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
    ├── /beta (build) ──┐
    ├── /gamma (build) ─┤
    │                   ▼
    │            /delta (verify) ──> Alpha design review
    │                   ▲                    │
    │                   └── /polish (fix) <──┘
    │
    └── "let's wrap this up" ──> CLAUDE.md update ──> coordination reset
```

1. **Alpha plans** -> writes coordination file with session prompts and API contracts
2. **Sessions build** -> `/beta` and `/gamma` run in parallel terminals, each reading their prompt
3. **Delta verifies** -> typecheck, lint, tests, build, feature smoke test. Failures go back to the owning session until clean
4. **Alpha reviews** -> design review of the passing code, writes polish items into the coordination file
5. **Sessions polish** -> `/polish` in each session, then a quick `/delta` re-run to confirm the polish didn't break anything
6. **Wrap up** -> tell Alpha "let's wrap this up" — Alpha updates `CLAUDE.md` with what the effort changed, then resets the coordination file for the next effort

**Why Delta first:** design review is worth more on code that already compiles and passes. Reviewing broken code spends Alpha's attention on noise that a typechecker catches for free.

## How It Works

### Two gates, two jobs

The framework has two review gates with distinct responsibilities:

| | Delta (mechanical verification) | Alpha (design review) |
|---|---|---|
| **Checks** | Typecheck, lint, tests, build | Contract adherence, architectural fit, naming, structure, cross-session consistency |
| **Output** | Pass/fail report | Polish items for sessions to fix |
| **Edits code?** | No | No |
| **When** | After coding sessions complete, and again after polish | After Delta passes |

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

Sessions are human-launched Claude Code instances in separate terminals, not spawned sub-agents. This is a deliberate choice about **where the human sits in the loop**, not a workaround — Claude Code can spawn background agents with worktree isolation, and this framework still doesn't.

The reason is the gate. Every transition in the lifecycle — build to verify, verify to review, review to polish — is a point where you decide whether the work so far is good enough to build on. Launching the next session by hand is what makes that decision explicit:

- **You read the coordination file at each hand-off.** Alpha's plan, Beta's reported decisions, Delta's failures — you see them because you have to open the terminal to move forward. Automatic hand-offs skip the reading.
- **A bad plan gets caught at session one, not session four.** If Alpha's split is wrong or a contract is underspecified, you find out when you launch Beta and it starts down the wrong path — with the whole effort still cheap to redirect.
- **Each session's context stays legible.** One terminal, one work stream, one transcript you can scroll. When something goes sideways you know which session did it and can steer that one without unwinding the rest.
- **Parallelism you can actually watch.** Beta and Gamma run at the same time in separate windows. You keep visibility into both, even when vibe coding.

The cost is real — you launch each session yourself, and the effort moves at the speed you attend to it. That's the trade being made. If you want fire-and-forget fan-out, use subagents directly; this framework is for efforts where you want to approve each step.

## Tips

- **Turn on auto-accept (`Shift+Tab`) before stepping away from a session** — Beta, Gamma, and Delta will stall waiting for edit permissions if it's off
- **Rename your VS Code terminals** to match session names (Alpha, Beta, etc.)
- **Don't over-session** — if a task takes 20 minutes, just do it in Alpha
- **Date your decisions** — use absolute dates in the coordination file
- **Good splits**: by layer (backend/frontend), by concern (code/tests), by independence (different files)
- **Bad splits**: two sessions editing the same files, tightly coupled work

## Privacy

This plugin runs entirely within your local Claude Code environment. It does not collect, transmit, or store any user data. No analytics, no telemetry, no external network calls. The coordination file is stored in Claude's local project-scoped memory on your machine.

## License

MIT
