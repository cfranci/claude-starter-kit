#!/bin/bash
input=$(cat)

# Get project dir: prefer tracked cwd from hook, fall back to JSON
tracked_dir=$(cat "/tmp/claude-cwd-$PPID" 2>/dev/null)
if [ -n "$tracked_dir" ]; then
  dir="$tracked_dir"
  name=$(basename "$tracked_dir")
  branch=$(git -C "$tracked_dir" symbolic-ref --short HEAD 2>/dev/null)
else
  dir=$(echo "$input" | jq -r '.workspace.project_dir // .workspace.current_dir // empty')
  name=$(basename "${dir:-unknown}")
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
fi

# Check for custom label set by /label command
custom_label=$(cat "/tmp/claude-label-$PPID" 2>/dev/null)
custom_color=$(cat "/tmp/claude-label-color-$PPID" 2>/dev/null)

# ANSI color helpers
color_on=""
color_off=""
if [ -n "$custom_color" ]; then
  color_on="\033[38;2;${custom_color}m"
  color_off="\033[0m"
fi

# Tokens in K
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
in_k=$(awk "BEGIN {printf \"%.0f\", $total_in/1000}")
out_k=$(awk "BEGIN {printf \"%.0f\", $total_out/1000}")

# Context percentage
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx=""
[ -n "$used" ] && ctx="◉ ${used}%"

# Branch
branch_str=""
[ -n "$branch" ] && branch_str=" (${branch})"

if [ -n "$custom_label" ]; then
  # Custom label mode: ★ cf [label] with color
  line="★ cf [${custom_label}]${branch_str} | ◇ ${in_k}K↓ ${out_k}K↑ ${ctx}"
  echo -e "${color_on}${line}${color_off}"
else
  # Auto mode: ★ cf [folder]
  if [ "$dir" = "$HOME" ]; then
    folder_label="~"
  else
    folder_label="${name}"
  fi
  line="★ cf [${folder_label}]${branch_str} | ◇ ${in_k}K↓ ${out_k}K↑ ${ctx}"
  echo -e "${line}"
fi
