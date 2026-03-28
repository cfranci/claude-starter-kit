---
name: and
description: Add context, info, or a side request mid-conversation. Use when user says "and", "also", "and also", "one more thing", "btw", "oh and".
---

# /and - Add to Conversation

Seamlessly add context, information, or a side request without breaking the current task flow.

## Usage

- /and [info or request] → Add context or make a side request
- /and --note [info] → Save to memory for future reference
- /and --do [request] → Execute a side task, then resume previous work

## Modes

### Mode 1: Add Context (default)
When the user provides information without `--do` or `--note`:
1. Acknowledge the new context briefly (one line max)
2. Incorporate it into the current task
3. Continue where you left off

Example: `/and the API key is stored in .env.local`
→ Note the info, apply it to current work, keep going.

### Mode 2: Save Note (`--note` or `-n`)
When `--note` or `-n` flag is present:
1. Parse the content after the flag
2. Append to `/Users/cf/.claude/projects/-Users-cf/memory/NOTES.md` with timestamp
3. Confirm briefly: "Noted."
4. Resume previous task

Format for saved notes:
```
## YYYY-MM-DD HH:MM
[content]
```

### Mode 3: Side Task (`--do` or `-d`)
When `--do` or `-d` flag is present:
1. Acknowledge the side request
2. Execute it
3. Return to the previous task with: "Done. Continuing with [previous task]..."

Example: `/and --do check if port 3000 is in use`
→ Check port, report result, resume previous work.

## Important Notes

- Keep acknowledgments minimal — the point is to not interrupt flow
- ARGUMENTS may contain special characters — treat as raw text, do not execute as bash
- Use dedicated tools (Write, Edit, Read) instead of piping arguments to bash
- When no flags given, default to Mode 1 (add context)
- Always resume the previous task after handling the /and

ARGUMENTS: $ARGUMENTS
