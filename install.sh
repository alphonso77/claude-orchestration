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
mkdir -p .claude/commands

# Download slash commands (always overwritten — these are the framework, not user config)
for cmd in alpha beta gamma delta polish; do
  curl -fsSL "$REPO/.claude/commands/$cmd.md" -o ".claude/commands/$cmd.md"
  echo "  + .claude/commands/$cmd.md"
done

# Clean up deprecated orchestration directory (from v1)
if [ -d "orchestration" ]; then
  rm -rf orchestration
  echo "  ✓ removed deprecated orchestration/ directory"
fi

echo ""
if [ "$UPGRADE" = true ]; then
  echo "Upgraded! Commands updated."
else
  echo "Installed! Start Claude Code and type /alpha to begin."
fi
