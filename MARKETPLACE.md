# Publishing to the Claude Code Marketplace

## Current state

The repo includes a `marketplace.json` so users can install directly from GitHub without waiting for official marketplace acceptance.

### How users install today

```bash
# Add this repo as a marketplace
/plugin marketplace add alphonso77/claude-orchestration

# Install the plugin
/plugin install orch@claude-orchestration
```

## Submitting to the official Anthropic marketplace

Once accepted, users can install with just `/plugin install orch` — no marketplace setup needed.

### Prerequisites

- [ ] Plugin is stable and tested across multiple real efforts
- [ ] README is clear and complete
- [ ] `plugin.json` has all recommended fields (`name`, `version`, `description`, `author`, `homepage`, `repository`, `license`, `keywords`)
- [ ] Plugin name ("orch") is available — check [claude.com/plugins](https://claude.com/plugins)

### Submission steps

1. Go to one of:
   - [claude.ai/settings/plugins/submit](https://claude.ai/settings/plugins/submit)
   - [platform.claude.com/plugins/submit](https://platform.claude.com/plugins/submit)

2. Provide the GitHub repo URL: `https://github.com/alphonso77/claude-orchestration`

3. Wait for review and acceptance

### After acceptance

- Users install with: `/plugin install orch`
- Updates are picked up when you bump `version` in `plugin.json` and users run `/plugin update orch`
- The self-hosted marketplace in this repo still works as a fallback

### Naming rules for official marketplace

- Must be kebab-case (lowercase letters, digits, hyphens)
- Cannot impersonate official Anthropic names (e.g., "anthropic-tools", "claude-plugins-official")
- Must be unique within the official marketplace

### If "orch" is taken

Fallback names to consider:
- `claude-orchestration`
- `session-orchestration`
- `multi-session`
