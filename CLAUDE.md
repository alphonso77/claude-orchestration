# Claude Orchestration

Multi-session orchestration framework for Claude Code, distributed as installable skills.

## Repository structure

```
skills/          — source-of-truth skill files (SKILL.md in each subfolder)
install.sh       — curl-pipe installer that copies skills to ~/.claude/skills/
uninstall.sh     — removes installed skills
README.md        — user-facing docs
PROPOSAL.md      — design proposal
MARKETPLACE.md   — marketplace submission details
```

## Critical: this repo is a distribution source, not the install target

The skill files in `skills/` are the **source of truth**. Users install them to `~/.claude/skills/` via `install.sh` or the plugin system.

**Never edit files in `~/.claude/skills/` directly.** Always edit the files in this repo under `skills/`. Changes to `~/.claude/skills/` are not version-controlled and will be overwritten on next install/upgrade.

When testing changes locally, edit in the repo first, then copy to `~/.claude/skills/` to test:
```bash
for skill in alpha beta gamma delta polish; do cp skills/$skill/SKILL.md ~/.claude/skills/$skill/SKILL.md; done
```

## Skill files

- Filenames are `SKILL.md` (uppercase) — this is required by the Claude Code skill system
- Each skill lives in `skills/<name>/SKILL.md`
- Skills are generic and static — effort-specific prompts go in the coordination file, not in skill files

## Session lifecycle (flow order)

1. Alpha plans and writes coordination file
2. Coding sessions (Beta, Gamma) build in parallel
3. Delta verifies mechanically (typecheck, lint, tests)
4. Alpha does design review on passing code
5. Sessions polish based on Alpha's feedback
6. Delta re-verifies after polish
