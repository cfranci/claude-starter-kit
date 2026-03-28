---
description: "Set a colored status line label with matching prompt border. /label alone for picker, /label <name> for quick set, /label reset to clear."
arguments:
  - name: label
    description: "Label text, 'reset' to clear, or empty for picker"
    required: false
---

## Route `$ARGUMENTS`

**"reset" / "default" / "clear"** → Remove `/tmp/claude-label-$PPID` and color file. Reset tweakcc to `rgb(136,136,136)` / shimmer `rgb(166,166,166)`. Run `npx tweakcc --apply`. Open new iTerm window. Say "Label cleared."

**Non-empty name** → Check `~/.claude/label-presets.json` for match:
- Found → use saved RGB, apply color (see below), done.
- Not found → read `~/.claude/data/colors.json`, suggest a color based on the name's vibe, show suggestion. If accepted, apply. Otherwise let user pick.

**Empty** → Read `~/.claude/commands/label-flows/picker.md` and follow it.

## Apply color

1. Write: `echo 'LabelText' > /tmp/claude-label-$PPID` and `echo 'R;G;B' > /tmp/claude-label-color-$PPID`
2. Save/update preset in `~/.claude/label-presets.json`
3. Update tweakcc: `jq '.settings.themes[0].colors.promptBorder = "rgb(R,G,B)" | .settings.themes[0].colors.promptBorderShimmer = "rgb(R+30,G+30,B+30)"' ~/.tweakcc/config.json > /tmp/tweakcc-tmp.json && mv /tmp/tweakcc-tmp.json ~/.tweakcc/config.json`
4. Run `npx tweakcc --apply 2>&1` — if output shows `✗ Themes`, warn tweakcc patch is broken on this version.
5. Open new window: `osascript -e 'tell application "iTerm2" to create window with default profile'`
6. If on a remote machine (SSH/mac2), prefix display text with `// ` (don't save prefix to preset).

Confirm: `⚑ LabelName · ■ colorname`
