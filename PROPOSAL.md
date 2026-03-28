# Proposal: Distribution Channels for Claude Orchestration

**Date:** 2026-03-24
**Updated:** 2026-03-28
**Status:** Hybrid distribution (curl + plugin)

---

## Current State

Claude Orchestration ships as both a **`curl | bash` install** (primary) and a **Claude Code plugin** (alternative). The primary path copies skills to `~/.claude/skills/` for short commands (`/alpha`, `/beta`, etc.). The plugin path provides namespaced commands (`/orch:alpha`, `/orch:beta`, etc.) via the standard plugin system.

The coordination file lives in Claude's project-scoped memory, so per-project state is isolated without any per-repo files.

### Evolution

1. **v1** — Per-project `.claude/commands/` files, copied via `install.sh`
2. **v2** — Global install to `~/.claude/skills/`, still via `install.sh`
3. **v3** — Claude Code plugin with standard manifest and skill auto-discovery
4. **v4 (current)** — Hybrid: `curl | bash` as primary (short commands), plugin as alternative (managed installs)

### Agent approach (abandoned)

Early versions attempted to use spawned sub-agents for Beta/Gamma/Delta sessions. This failed in practice:
- Sub-agents interrupted Alpha mid-conversation with permission prompts and status updates
- Frequent permission blockers caused cascading context switches, stalling the effort
- The human lost visibility into what each session was doing

Manual human-steered sessions are the model. Each session is a separate Claude Code instance launched by the user in a new terminal. This keeps the human close to the effort.

## Distribution Options

### 1. Claude Code Plugin (current)
- Standard plugin manifest with skill auto-discovery
- Install via `/plugin install` or marketplace
- Namespaced skills prevent conflicts with other plugins
- No per-repo files, nothing to commit

### 2. Official Anthropic Marketplace
- Submit to the official marketplace for community distribution
- Users discover and install through Claude Code's plugin UI
- **Action:** Submit when plugin is stable and documented

### 3. Custom Marketplace
- Host a marketplace repo with `.claude-plugin/marketplace.json`
- Useful for teams that want to bundle this with other internal plugins
- Lower friction than official submission

### 4. VS Code Extension (complementary)
- Could ship alongside the plugin for terminal management UX
- Auto-name terminals to session names, sidebar panel showing session status
- **Limitation:** Only helps with the VS Code side — the actual behavior comes from the plugin skills
- **Effort:** Medium — adds maintenance overhead for a UX convenience

## Recommendation

**Now:** Ship as a Claude Code plugin. The structure is in place.

**Next:** Submit to the official Anthropic marketplace for broader distribution.

**Later:** VS Code extension for terminal management UX, if demand warrants it.

## Open Questions

- Should we support more than 4 concurrent sessions (epsilon, zeta, etc.)? Current limit is practical, not technical.
- How should session-to-session communication work if Claude Code ever supports it natively?
- Could this integrate with Claude Code's multi-agent features if the interruption/permission problems are solved at the platform level?

## Next Steps

- [ ] Submit to the official Anthropic marketplace
- [ ] Add examples directory with sample coordination files from real efforts
- [ ] Write a blog post / tutorial walking through a real multi-session effort
- [ ] Prototype VS Code extension with terminal naming + session sidebar
