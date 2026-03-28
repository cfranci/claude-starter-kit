#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd // empty')
if [ -n "$cwd" ]; then
  git_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
  echo "${git_root:-$cwd}" > "/tmp/claude-cwd-$PPID"
fi
