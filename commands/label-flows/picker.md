# Label Picker (no argument given)

## Step 1: Smart suggestion

Generate a context-aware label suggestion (max 3 words):
1. Current directory basename (if in `~/Projects/`, use its name; if `~/moms projects/`, suggest "Mom"; if `~`, suggest "Home Base")
2. Git repo name or descriptive branch
3. Check if suggestion matches a saved preset (show its color if so)

Show: `💡 Suggestion: «Name» — press Enter to accept, or pick from below:`

## Step 2: Full picker

Read presets from `~/.claude/label-presets.json`. Read colors from `~/.claude/data/colors.json`. List projects from `ls -1d /Users/cf/Projects/*/`.

Show in ONE shot:
```
⚑ LABEL
═══════════════════════════════════

SAVED                          PROJECTS
─────                          ────────
 s1  Name  ■ color              1  ProjectName
 s2  ...                        2  ...

COLORS (read from ~/.claude/data/colors.json)
──────
 c1-c12  classic colors
 c13-c24 animal colors

Type: [s#] preset · [#] project · [name] custom
Color: [c#] or color name · included with presets
Combine: [# color] or [name color] e.g. "22 lavender"
```

## Step 3: Handle input

- `s#` → load preset, apply
- `# c#` or `# colorname` → project + color, save preset, apply
- `#` alone → project, ask for color
- `name color` → custom + color, save preset, apply
- `name` alone → custom, ask for color
