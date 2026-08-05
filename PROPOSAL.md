# Proposal: Distribution Channels for Claude Orchestration

**Date:** 2026-03-24
**Updated:** 2026-08-04
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

### Where sub-agents fit

Early versions attempted spawned sub-agents *as* Beta/Gamma/Delta. The framework settled on manual human-launched sessions instead, and stays there by design — not because agents can't do the work, but because automating the hand-offs removes the thing that makes the framework useful.

Every transition — build to verify, verify to review, review to polish — is a decision about whether the work so far is worth building on. Requiring the user to launch the next session makes that decision explicit: they read the coordination file to move forward, so a bad plan or an underspecified contract surfaces at session one rather than session four. Each session also keeps its own legible terminal and transcript, so a work stream that goes sideways can be steered without unwinding the others.

Sub-agents *within* a session are a separate question, and the answer is yes. The invariant that makes the framework work is the swim lane — Alpha never writes code, Beta and Gamma touch only their own files, Delta verifies and never fixes — and a sub-agent inherits the lane of the session that spawned it. Fan-out inside a session therefore crosses no boundary the user was relying on, while cutting the serial cost of each step. The one prohibition is spawning an agent to do another session's job, which would consume the hand-off gate.

The trade is throughput at the session level: the effort advances at the speed the user attends to it. That is accepted. This framework targets efforts where the user wants to approve each step, not fire-and-forget fan-out across the whole effort.

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
- Claude Code now supports direct session-to-session messaging and background subagents. Is there a hand-off where automating the transition would *not* cost the user the gate — for example Delta re-running itself after polish, where the outcome is pass/fail rather than a judgment call?
- Should the skills declare `hooks` in frontmatter to enforce the file-ownership boundaries that are currently stated as rules in the skill body?

## Next Steps

- [ ] Submit to the official Anthropic marketplace
- [ ] Add examples directory with sample coordination files from real efforts
- [ ] Write a blog post / tutorial walking through a real multi-session effort
- [ ] Prototype VS Code extension with terminal naming + session sidebar
