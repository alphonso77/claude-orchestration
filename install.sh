#!/bin/bash
set -e

# Claude Orchestration — install into current project
# Usage: curl -fsSL https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/install.sh | bash

REPO="https://raw.githubusercontent.com/alphonso77/claude-orchestration/main"

echo "Installing Claude Orchestration..."

# Create directories
mkdir -p .claude/commands orchestration

# Download slash commands
for cmd in alpha beta gamma delta polish; do
  curl -fsSL "$REPO/.claude/commands/$cmd.md" -o ".claude/commands/$cmd.md"
  echo "  ✓ .claude/commands/$cmd.md"
done

# Download orchestration files
curl -fsSL "$REPO/orchestration/README.md" -o "orchestration/README.md"
echo "  ✓ orchestration/README.md"

curl -fsSL "$REPO/orchestration/session-orchestration.md" -o "orchestration/session-orchestration.md"
echo "  ✓ orchestration/session-orchestration.md"

echo ""
echo "Done! Start Claude Code and type /alpha to begin."
