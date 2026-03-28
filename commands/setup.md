---
description: One-time setup — pick your trust level, enable vibes, and configure Claude Code
---

First-time setup wizard. Run through these steps:

## Step 1: Trust level

Ask the user:

```
How much should Claude ask for permission?

1. Training wheels — Claude can read/edit files freely, asks before running commands
2. Power user    — Claude runs most things, asks for destructive operations only
3. Full send     — Claude does whatever it needs, zero interruptions
```

Based on their pick, update `~/.claude/settings.json`:

- **1**: Set `permissions.defaultMode` to `allowEdits`
- **2**: Set `permissions.defaultMode` to `bypassPermissions` and add to `permissions.allow`: `["Bash(curl:*)", "Bash(cd:*)", "Bash(python:*)", "Bash(npm:*)", "Bash(git:*)", "Bash(pbcopy:*)"]`
- **3**: Set `permissions.defaultMode` to `bypassPermissions`

## Step 2: Vibes

Ask: "Want fun spinner verbs instead of 'Thinking...'? (y/n)"

If yes, read `~/.claude/data/vibes/sfw.json` and set as `spinnerVerbs` in settings.

## Step 3: Status line

Ask: "Want a status line showing project, branch, and token count? (y/n)"

If yes, set in settings:
```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/scripts/statusline.sh"
}
```

Also set up the CWD tracking hook:
```json
"hooks": {
  "PostToolUse": [{"matcher": "Bash", "hooks": [{"type": "command", "command": "~/.claude/scripts/track-cwd.sh", "timeout": 5000}]}],
  "SessionEnd": [{"hooks": [{"type": "command", "command": "rm -f /tmp/claude-cwd-$PPID /tmp/claude-label-$PPID /tmp/claude-label-color-$PPID"}]}]
}
```

## Step 4: Confirm

Print a summary of what was configured and say: "You're set! Try `/autopilot`, `/design`, or `/label` to get started."
