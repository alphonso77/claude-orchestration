#!/bin/bash
set -e

# Claude Orchestration — install or upgrade
# Usage: curl -fsSL https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/install.sh | bash

REPO="https://raw.githubusercontent.com/alphonso77/claude-orchestration/main"
TARGET="$HOME/.claude/skills"
SKILLS="alpha beta gamma delta polish"

# Detect install vs upgrade
if [ -f "$TARGET/alpha/SKILL.md" ]; then
  echo "Upgrading Claude Orchestration..."
  UPGRADE=true
else
  echo "Installing Claude Orchestration..."
  UPGRADE=false
fi

# Download skills
for skill in $SKILLS; do
  mkdir -p "$TARGET/$skill"
  curl -fsSL "$REPO/skills/$skill/SKILL.md" -o "$TARGET/$skill/SKILL.md"
  echo "  + $TARGET/$skill/SKILL.md"
done

# Clean up deprecated locations
if [ -d ".claude/commands" ]; then
  for cmd in $SKILLS; do
    rm -f ".claude/commands/$cmd.md"
  done
  rmdir ".claude/commands" 2>/dev/null || true
  echo "  ~ removed deprecated .claude/commands/ files"
fi

if [ -f "$HOME/.claude/commands/alpha.md" ]; then
  for cmd in $SKILLS; do
    rm -f "$HOME/.claude/commands/$cmd.md"
  done
  echo "  ~ removed deprecated ~/.claude/commands/ files"
fi

if [ -d "orchestration" ]; then
  rm -rf orchestration
  echo "  ~ removed deprecated orchestration/ directory"
fi

echo ""
if [ "$UPGRADE" = true ]; then
  echo "Upgraded! Skills updated in $TARGET."
else
  echo "Installed! Skills available globally."
  echo "Start Claude Code in any project and type /alpha to begin."
fi

echo ""
echo "Tip: Alpha/Beta/Gamma play a completion sound on macOS via afplay."
echo "To skip the one-time permission prompt, add \"Bash(afplay:*)\" to the"
echo "permissions.allow array in ~/.claude/settings.json."