#!/bin/bash
# Claude Starter Kit — install commands, skills, and data into ~/.claude
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DST="$HOME/.claude"

echo ""
echo "  Claude Starter Kit"
echo "  ─────────────────────"
echo ""

# Commands
mkdir -p "$DST/commands"
for f in "$SCRIPT_DIR/commands/"*.md; do
  [ -f "$f" ] && cp "$f" "$DST/commands/"
done
# Subfolders
for dir in consider label-flows open-flows; do
  if [ -d "$SCRIPT_DIR/commands/$dir" ]; then
    mkdir -p "$DST/commands/$dir"
    cp -r "$SCRIPT_DIR/commands/$dir/"* "$DST/commands/$dir/"
  fi
done
CMD_COUNT=$(find "$SCRIPT_DIR/commands" -name "*.md" | wc -l | tr -d ' ')
echo "  ✓ $CMD_COUNT commands installed"

# Skills
if [ -d "$SCRIPT_DIR/skills" ]; then
  mkdir -p "$DST/skills"
  cp -r "$SCRIPT_DIR/skills/"* "$DST/skills/"
  echo "  ✓ Skills installed"
fi

# Data
if [ -d "$SCRIPT_DIR/data" ]; then
  mkdir -p "$DST/data"
  cp -r "$SCRIPT_DIR/data/"* "$DST/data/"
  echo "  ✓ Data (colors, vibes)"
fi

# Scripts
if [ -d "$SCRIPT_DIR/scripts" ]; then
  mkdir -p "$DST/scripts"
  cp "$SCRIPT_DIR/scripts/"* "$DST/scripts/"
  chmod +x "$DST/scripts/"* 2>/dev/null || true
  echo "  ✓ Scripts"
fi

echo ""
echo "  Installed! Restart Claude Code, then run /setup"
echo ""
