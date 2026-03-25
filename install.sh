#!/bin/bash
set -e

# Claude Orchestration — install into current project
# Usage: curl -fsSL https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/install.sh | bash

REPO="https://raw.githubusercontent.com/alphonso77/claude-orchestration/main"

echo "Installing Claude Orchestration..."

# Create directories
mkdir -p .claude/commands

# Download slash commands
for cmd in alpha beta gamma delta polish; do
  curl -fsSL "$REPO/.claude/commands/$cmd.md" -o ".claude/commands/$cmd.md"
  echo "  ✓ .claude/commands/$cmd.md"
done

# Clean up deprecated orchestration directory (from v1)
if [ -d "orchestration" ]; then
  rm -rf orchestration
  echo "  ✓ removed deprecated orchestration/ directory"
fi

echo ""
echo "Done! Start Claude Code and type /alpha to begin."
