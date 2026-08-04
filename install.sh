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

# Report deprecated v1/v2 locations — never delete them.
#
# This installer is run via curl | bash from an arbitrary working directory, so
# a path like ".claude/commands" or "orchestration" can belong to something that
# has nothing to do with this project. Leftovers are also harmless: a skill takes
# precedence over a same-named file in .claude/commands/, so an old alpha.md is
# inert once alpha/SKILL.md exists. We identify ours by content and print the
# removal command for the user to run.
# Every skill in every layout references the coordination file; "orchestrated
# effort" would miss polish.md, which never carried that phrase.
MARKER="coordination"
LEGACY=""

is_ours() {
  [ -f "$1" ] && grep -qF "$MARKER" "$1" 2>/dev/null
}

for dir in ".claude/commands" "$HOME/.claude/commands"; do
  [ -d "$dir" ] || continue
  # Skip the second pass when cwd is $HOME and both paths resolve the same
  if [ "$dir" = "$HOME/.claude/commands" ] && [ "$PWD" = "$HOME" ]; then
    continue
  fi
  for cmd in $SKILLS; do
    if is_ours "$dir/$cmd.md"; then
      LEGACY="$LEGACY $dir/$cmd.md"
    fi
  done
done

# v2 kept its docs here; require the known file so an unrelated dir is left alone
if [ -f "orchestration/session-orchestration.md" ]; then
  LEGACY="$LEGACY $PWD/orchestration/session-orchestration.md $PWD/orchestration/README.md"
fi

if [ -n "$LEGACY" ]; then
  echo ""
  echo "Found files from an older layout. They are inert — the new skills take"
  echo "precedence — but you can remove them:"
  for f in $LEGACY; do
    [ -e "$f" ] && echo "    $f"
  done
  echo ""
  echo "  rm$LEGACY"
fi

echo ""
if [ "$UPGRADE" = true ]; then
  echo "Upgraded! Skills updated in $TARGET."
else
  echo "Installed! Skills available globally."
  echo "Start Claude Code in any project and type /alpha to begin."
fi

echo ""
echo "Tip: Alpha/Beta/Gamma play a completion sound on macOS via afplay. The skills"
echo "pre-approve it in frontmatter, but that grant only covers the turn that invoked"
echo "the skill. For long sessions, add \"Bash(afplay:*)\" to the permissions.allow"
echo "array in ~/.claude/settings.json to silence the prompt for good."