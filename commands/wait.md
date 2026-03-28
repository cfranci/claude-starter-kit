---
description: Queue a prompt to run later — at a specific time or when usage renews
---

Queue a prompt to run later. Do NOT ask questions unless asking WHEN (see rules below).

## Check for active wait (message buffering)

FIRST, check if `/tmp/claude-wait` already exists by running: `cat /tmp/claude-wait 2>/dev/null`

If the file exists and has content (format: `WAKE_TIME|PROMPT_TEXT`):
1. Parse `$ARGUMENTS` to get the new message (same parsing as below, but only extract the prompt — ignore any time prefix since the timer is already running).
2. If `$ARGUMENTS` is empty, recover the prompt from the last user message in this conversation.
3. Append the new message as a new line to `/tmp/claude-wait-buffer`:
   ```bash
   echo "NEW_MESSAGE" >> /tmp/claude-wait-buffer
   ```
4. Read the WAKE_TIME from the first field of `/tmp/claude-wait`.
5. Print exactly this and stop:
   ```
   📎 Added to queue (fires at WAKE_TIME): MESSAGE_FIRST_80_CHARS
   ```
6. Do NOT say anything else. Do NOT continue the conversation.

If `/tmp/claude-wait` does NOT exist, proceed with normal scheduling below.

## Parse `$ARGUMENTS`

**Case 1: Time + prompt** (e.g. `/wait 2h run tests`, `/wait 3am push to prod`, `/wait tonight do X`)
Split on time prefix. Time patterns: `\d+[hm]`, `\d{1,2}(am|pm)`, `\d+h\d+m`, `tomorrow`, `tonight`, `night`.
- "tonight" or "night" = **NIGHT SHIFT MODE** (see below)
- Rest is the prompt.

**Case 2: Prompt only, no time** (e.g. `/wait run tests`)
No time pattern found. Prompt is the full arguments. Time = usage renewal (see below).

**Case 3: Empty** (`/wait` alone)
No arguments at all. Recover the prompt from the last user message in this conversation (the one right before `/wait` — that's what the user was trying to run and got rate-limited on). Time = usage renewal (see below).

## Smart time selection

**If a specific time was given**: resolve it and calculate seconds from now.

**If "tonight" or "night"**: schedule for 1:00 AM next occurrence. The night shift window is 1 AM - 6 AM. Always use `--dangerously-skip-permissions` for night runs since the user will be asleep.

**If NO time was given AND it's before 2:00 PM**: ASK the user when to run by showing the next 3 usage reset windows. Fetch usage resets (see below) and show:

```
⏳ When should this run?

Usage resets:
  1. 3:00 PM today (52m from now)
  2. 8:00 PM today (5h 52m)
  3. 1:00 AM tomorrow (night shift)

[1/2/3] or type a time:
```

Wait for their response, then schedule accordingly.

**If NO time was given AND it's 2:00 PM or later**: auto-schedule for the next usage reset (don't ask).

## Fetch usage reset time

```bash
TOKEN=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null | python3 -c "import sys,json; print(json.loads(sys.stdin.read()).get('claudeAiOauth',{}).get('accessToken',''))" 2>/dev/null)
if [ -n "$TOKEN" ]; then
  curl -s "https://api.anthropic.com/api/oauth/usage" \
    -H "Authorization: Bearer $TOKEN" \
    -H "anthropic-beta: oauth-2025-04-20" \
    -H "User-Agent: claude-code/2.1.86" | python3 -c "
import sys,json
from datetime import datetime, timezone, timedelta
d=json.loads(sys.stdin.read())
r=d.get('five_hour',{}).get('resets_at','')
if r:
    reset=datetime.fromisoformat(r.replace('Z','+00:00'))
    now=datetime.now(timezone.utc)
    secs=max(int((reset-now).total_seconds()),60)
    local=reset.astimezone().strftime('%l:%M %p %Z').strip()
    r2=reset+timedelta(hours=5)
    r3=reset+timedelta(hours=10)
    l2=r2.astimezone().strftime('%l:%M %p %Z').strip()
    l3=r3.astimezone().strftime('%l:%M %p %Z').strip()
    s2=max(int((r2-now).total_seconds()),60)
    s3=max(int((r3-now).total_seconds()),60)
    print(f'{secs}|{local}|{s2}|{l2}|{s3}|{l3}')
else:
    print('FALLBACK')
"
fi
```

Output format: `SECS1|TIME1|SECS2|TIME2|SECS3|TIME3`

If it outputs `FALLBACK` or fails, fall back to 1 hour from now.

## Night Shift Mode

Triggered by "tonight", "night", or `/wait tonight`. The night shift runs while the user sleeps (roughly midnight - 6 AM).

When night shift is triggered:

1. **Calculate the schedule**: Fetch usage reset times (same API call as below). Find the first reset that falls between 11 PM and 6 AM. If no reset falls in that window exactly, pick the one closest to midnight or later. Show the user which reset you're targeting:
   ```
   Usage resets: 3:00 PM → 8:00 PM → 1:00 AM ← night shift
   ```

2. **Start caffeinate** to keep the Mac awake all night:
   ```bash
   # Kill any existing caffeinate, then start fresh
   pkill caffeinate 2>/dev/null
   nohup caffeinate -dims > /dev/null 2>&1 &
   echo $! > /tmp/claude-caffeinate-pid
   ```

3. **Trigger /dark** to black out the screen (so it's not glowing all night). Run the dark skill.

4. **Schedule the prompt** for 1:00 AM with `--dangerously-skip-permissions` (user is asleep, can't approve anything).

5. **Confirm with**:
   ```
   🌙 Night shift scheduled for 1:00 AM (Xh Ym from now)
   → PROMPT_FIRST_80_CHARS
   ☕ Caffeinate active — Mac will stay awake
   🖥️ Screen dark — hold spacebar 7s to wake
   Cancel: rm /tmp/claude-wait && kill $(cat /tmp/claude-caffeinate-pid)
   ```

6. **Post-run cleanup**: After the scheduled prompt finishes, the command should also:
   ```bash
   # Light RAM cleanup — cached files only, nothing aggressive
   sudo purge 2>/dev/null
   # Clear user caches (safe stuff only — no app data)
   rm -rf ~/Library/Caches/com.apple.Safari/WebKitCache 2>/dev/null
   rm -rf ~/Library/Caches/Google/Chrome/*/Cache 2>/dev/null
   rm -rf ~/Library/Caches/com.spotify.client/Data 2>/dev/null
   rm -rf /tmp/*.png /tmp/*.jpg /tmp/claude-ext* /tmp/arcade* /tmp/td-* 2>/dev/null

   # Put Mac to max sleep (display + disk sleep, system stays alive for wake)
   pmset displaysleepnow 2>/dev/null

   # Kill caffeinate — no longer needed
   kill $(cat /tmp/claude-caffeinate-pid 2>/dev/null) 2>/dev/null
   rm -f /tmp/claude-caffeinate-pid
   ```

   Append these cleanup commands to the end of the nohup bash -c chain so they run after claude exits.

## Schedule

ALWAYS use `--dangerously-skip-permissions` in the scheduled command so it runs fully autonomous without blocking on prompts (especially important for night runs when user is asleep).

Run this single bash command — substitute the actual values:

```bash
nohup bash -c 'sleep SECONDS && PROMPT=$(cat /tmp/claude-wait | cut -d"|" -f2-); if [ -f /tmp/claude-wait-buffer ]; then BUFFER=$(cat /tmp/claude-wait-buffer); PROMPT="$PROMPT Also do these queued tasks: $BUFFER"; fi; osascript -e "tell application \"iTerm2\" to tell current session of (create window with profile \"Default\") to write text \"cd CWD && claude --dangerously-skip-permissions -p \\\"$PROMPT\\\"\"" && rm -f /tmp/claude-wait /tmp/claude-wait-buffer' > /dev/null 2>&1 & echo "WAKE_TIME|PROMPT_TEXT" > /tmp/claude-wait
```

Replace SECONDS, CWD (pwd), PROMPT (shell-escaped), WAKE_TIME, PROMPT_TEXT.

## Confirm

Print exactly this and stop:

```
⏳ Queued for WAKE_TIME (Xh Ym from now)
→ PROMPT_FIRST_80_CHARS
Cancel: rm /tmp/claude-wait && kill %1
```

Do NOT say anything else. Do NOT continue the conversation.
