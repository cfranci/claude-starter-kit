---
description: Set fun spinner verbs — 50 custom verbs that replace "Thinking..."
---

Apply or remove custom spinner verbs. Two options:

1. **ON** — Read `~/.claude/data/vibes/sfw.json`, take its `verbs` array and `mode` field. Apply to `~/.claude/settings.json` as the `spinnerVerbs` key.
2. **OFF** — Set spinnerVerbs to `{"mode": "replace", "verbs": ["Thinking"]}` in settings.

If `$ARGUMENTS` contains "off" or "reset", do option 2. Otherwise do option 1.

Confirm which was applied and verb count. Do NOT list the verbs.
