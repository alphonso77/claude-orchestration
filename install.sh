#!/bin/bash
set -e

# Claude Orchestration — install or upgrade
# Usage: curl -fsSL https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/install.sh | bash

REPO="https://raw.githubusercontent.com/alphonso77/claude-orchestration/main"

# Detect install vs upgrade
if [ -f ".claude/commands/alpha.md" ]; then
  echo "Upgrading Claude Orchestration..."
  UPGRADE=true
else
  echo "Installing Claude Orchestration..."
  UPGRADE=false
fi

# Create directories
mkdir -p .claude/commands orchestration

# Download slash commands (always overwritten — these are the framework, not user config)
for cmd in alpha beta gamma delta polish; do
  curl -fsSL "$REPO/.claude/commands/$cmd.md" -o ".claude/commands/$cmd.md"
  echo "  + .claude/commands/$cmd.md"
done

# Download orchestration README (always overwritten)
curl -fsSL "$REPO/orchestration/README.md" -o "orchestration/README.md"
echo "  + orchestration/README.md"

# Only create session-orchestration.md on fresh install — don't overwrite an active effort
if [ ! -f "orchestration/session-orchestration.md" ]; then
  curl -fsSL "$REPO/orchestration/session-orchestration.md" -o "orchestration/session-orchestration.md"
  echo "  + orchestration/session-orchestration.md"
else
  echo "  ~ orchestration/session-orchestration.md (kept existing)"
fi

echo ""
if [ "$UPGRADE" = true ]; then
  echo "Upgraded! Commands updated. Your orchestration file was preserved."
else
  echo "Installed! Start Claude Code and type /alpha to begin."
fi
