# Proposal: Distribution Channels for Claude Orchestration

**Date:** 2026-03-24
**Status:** Draft

---

## Current State

Claude Orchestration is a set of markdown files (slash commands + orchestration templates) that enable multi-session coordination in Claude Code. Distribution today is via GitHub repo — users clone or curl the files into their project.

## Distribution Options

### 1. GitHub Template Repo (current)
- Users clone or run `install.sh`
- Lowest friction to ship, highest friction to adopt
- No auto-updates

### 2. npm Package
- `npx claude-orchestration init` copies files into the project
- Could support `--update` to pull latest command versions
- Familiar pattern for JS/TS developers, but this framework is language-agnostic

### 3. Claude Code Extension / Plugin (preferred)
- **This is the ideal distribution channel** once Claude Code supports it
- Install once, available in all projects — no per-repo file copying
- Could provide:
  - Slash commands registered globally (not per-project)
  - A UI panel for session status (replacing manual terminal renaming)
  - Visual orchestration — see which sessions are active, their status, files owned
  - Auto-create terminals with correct names when launching sessions
  - Coordination file management built into the extension
  - One-click session launch from a sidebar
- **Blocked on:** Claude Code extension API / plugin system (does not exist as of 2026-03-24)
- **Action:** Monitor Claude Code releases for extension support. Prototype when available.

### 4. VS Code Extension (interim)
- Could ship as a standalone VS Code extension today
- Manages the terminal naming problem (auto-name terminals to session names)
- Provides a sidebar panel showing session status
- Installs the slash command files into the project on activation
- **Limitation:** Only helps with the VS Code side — the actual Claude Code behavior still comes from the markdown files
- **Effort:** Medium — VS Code extension API is well-documented, but maintaining two distribution channels adds overhead

## Recommendation

**Short term (now):** Ship as GitHub template repo + install script. Get users and feedback.

**Medium term:** Build a VS Code extension that auto-installs the slash commands and adds a session management sidebar. This solves the biggest UX pain point (terminal management) without waiting for Claude Code plugin support.

**Long term:** Claude Code extension/plugin. This is the right home for this — orchestration is a Claude Code workflow, not a VS Code workflow. The extension would own the full experience: session lifecycle, coordination, status, and terminal management.

## Open Questions

- Should the coordination file live in Claude memory (current) or in the repo (more portable but clutters the project)?
- Should we support more than 4 concurrent sessions (epsilon, zeta, etc.)? Current limit is practical, not technical.
- How should session-to-session communication work if Claude Code ever supports it natively?
- Could this integrate with Claude Code's upcoming multi-agent features?

## Next Steps

- [ ] Add examples directory with sample orchestration files from real efforts
- [ ] Write a blog post / tutorial walking through a real multi-session effort
- [ ] Prototype VS Code extension with terminal naming + session sidebar
- [ ] Monitor Claude Code releases for extension/plugin API
