#!/bin/bash
set -e

# Claude Orchestration — uninstall (script-installed skills only)
# Usage: curl -fsSL https://raw.githubusercontent.com/alphonso77/claude-orchestration/main/uninstall.sh | bash

SKILLS="alpha beta gamma delta polish"

# These names are generic enough that a user may have their own skill or command
# at the same path. Only remove a file whose content is ours.
MARKER="coordination"

is_ours() {
  [ -f "$1" ] && grep -qF "$MARKER" "$1" 2>/dev/null
}

echo "Uninstalling Claude Orchestration..."

SKIPPED=""

for skill in $SKILLS; do
  dir="$HOME/.claude/skills/$skill"
  [ -d "$dir" ] || continue
  if is_ours "$dir/SKILL.md"; then
    rm -rf "$dir"
    echo "  - $dir"
  else
    SKIPPED="$SKIPPED $dir"
  fi
done

# Legacy v1/v2 command files. Not cwd-relative: this runs via curl | bash from an
# arbitrary directory, and a project's .claude/commands/ is not ours to touch.
for cmd in $SKILLS; do
  f="$HOME/.claude/commands/$cmd.md"
  if is_ours "$f"; then
    rm -f "$f"
    echo "  - $f"
  elif [ -f "$f" ]; then
    SKIPPED="$SKIPPED $f"
  fi
done

if [ -n "$SKIPPED" ]; then
  echo ""
  echo "Left in place — these don't look like ours:"
  for f in $SKIPPED; do
    echo "    $f"
  done
fi

echo ""
echo "Uninstalled! Script-installed skills removed."
echo "Note: This does not affect plugin installs. Use /plugin uninstall orch for that."