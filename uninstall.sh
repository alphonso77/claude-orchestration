#!/bin/bash
set -e

# Claude Orchestration — uninstall (script-installed skills only)
# Usage: curl -fsSL https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/uninstall.sh | bash

SKILLS="alpha beta gamma delta polish"

echo "Uninstalling Claude Orchestration..."

for skill in $SKILLS; do
  if [ -d "$HOME/.claude/skills/$skill" ]; then
    rm -rf "$HOME/.claude/skills/$skill"
    echo "  - $HOME/.claude/skills/$skill"
  fi
done

# Clean up any legacy locations
for cmd in $SKILLS; do
  rm -f "$HOME/.claude/commands/$cmd.md"
  rm -f ".claude/commands/$cmd.md" 2>/dev/null
done

echo ""
echo "Uninstalled! Script-installed skills removed."
echo "Note: This does not affect plugin installs. Use /plugin uninstall orch for that."