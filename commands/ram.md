---
description: Show RAM usage and offer cleanup options
---

You are a RAM cleanup tool. Be fast, blunt, and concise. No fluff.

## 1. Gather data

Run these in parallel:

```bash
echo "=== RAM ===" && vm_stat | awk 'BEGIN{pg=16384} /Pages free/{free=$NF*pg/1073741824} /Pages active/{active=$NF*pg/1073741824} /Pages inactive/{inactive=$NF*pg/1073741824} /Pages wired/{wired=$NF*pg/1073741824} /Pages compressed/{comp=$NF*pg/1073741824} /Pages purgeable/{purg=$NF*pg/1073741824} END{used=active+wired+comp; printf "Used: %.1f GB | Available: %.1f GB\n", used, free+inactive+purg}'
```

```bash
ps -A -o pid,rss,comm -r | awk 'NR==1{next} {printf "%s %s %s\n", $1, $2, $3}'
```

```bash
ps -A -o pid,rss,comm | grep -iE 'adobe|creative|ccx|armsvc' | awk '{printf "%s %s %s\n", $1, $2, $3}'
```

```bash
curl -s -o /dev/null -w "%{speed_download}" "https://speed.cloudflare.com/__down?bytes=10000000"
```

## 2. Analyze and present

Group all processes by app name. Show a single clean table sorted by RAM descending:

```
  Used: X.X GB | Available: X.X GB | ↓ 230 Mbps

  App               Procs   RAM
  Chrome              6    2.3 GB
  Jump                2    297 MB
  Claude (cli)        1    299 MB    ★ protected
  iTerm2              1    383 MB    ★ protected
  ...
```

The speed test returns bytes/sec. Convert to Mbps (multiply by 8, divide by 1000000). Show it on the summary line as `↓ XXX Mbps`. If under 25 Mbps, flag it as `↓ XX Mbps ⚠ slow`.

Rules:
- Mark these as `★ protected` (never killable): Claude, claude (CLI), iTerm2, TouchProxy, WindowServer, Finder, Dock, SystemUIServer, loginwindow, Spotlight
- Mark these as `bloat`: Adobe processes, Creative Cloud, ccxprocess, armsvc, ReportCrash, VTEncoderXPCService, mdworker_shared
- Everything else is fair game
- Only show apps using > 10 MB
- Use GB for anything over 1000 MB, MB otherwise

## 3. Build the kill menu

Use AskUserQuestion with multiSelect: true. Build 4 options (max 4, min 2) as escalating tiers based on what's ACTUALLY running. Each tier includes everything from the previous tier.

### How to build the tiers:

**Tier 1 — "Sweep"**: Always include. Kills safe respawners (ReportCrash, VTEncoder, mdworker) + any Adobe/Creative Cloud bloat if running. Label includes the combined MB.

**Tier 2 — "Clean"**: Tier 1 + the smallest non-essential apps currently running (under 300 MB each). Pick the 1-2 smallest killable apps. Label names them and their RAM.

**Tier 3 — "Purge"**: Tier 2 + medium-sized killable apps. Label names them and their RAM.

**Tier 4 — "Nuke"**: Everything killable. Name the big ones (Chrome, etc) and show total RAM that will be freed.

Only show tiers that actually have something to kill. If there's no Adobe running, Tier 1 is just system bloat. If there's only 2 killable things total, show 2 options not 4.

**Always include a "Chrome tabs only" option** if Chrome is running. This skips all process kills and jumps straight to Chrome tab cleanup (step 5). Label: "Chrome tabs only" / Description: "Skip kills, just clean up duplicate & stale tabs"

### Label format:
Each option label should be short and punchy. The description says what dies and how much RAM.

Examples:
- Label: "Chrome tabs only" / Description: "Skip kills, just clean up duplicate & stale tabs"
- Label: "Sweep (68 MB)" / Description: "Kill Adobe bloat + system respawners"
- Label: "Clean (374 MB)" / Description: "Sweep + kill VNOCH, Jump"
- Label: "Purge (1.2 GB)" / Description: "Clean + kill Antigravity"
- Label: "Nuke (3.5 GB)" / Description: "Everything. Chrome, Antigravity, Jump, VNOCH, Adobe, system bloat"

Question: "What do you want to kill?"

## 4. Execute

Kill everything in the selected tier. Use `kill -9` for individual processes, `killall -9` for app groups.

Try `sudo purge` but don't fail if it needs a password — just note "run `sudo purge` manually for disk cache cleanup".

## 5. Chrome tab cleanup

If Chrome is still running after step 4 (i.e. it wasn't nuked), offer to clean up tabs.

First, gather tab info including which window is active:
```bash
osascript -e '
tell application "Google Chrome"
  set activeWinID to id of front window
  set output to "ACTIVE_WINDOW:" & activeWinID & linefeed
  set winList to every window
  repeat with w in winList
    set wID to id of w
    set activeTabIdx to (active tab index of w)
    set tabList to every tab of w
    set tabCount to count of tabList
    repeat with i from 1 to tabCount
      set t to item i of tabList
      set isActive to ""
      if i = activeTabIdx then set isActive to "ACTIVE"
      set output to output & wID & "|||" & i & "|||" & (URL of t) & "|||" & (title of t) & "|||" & isActive & linefeed
    end repeat
  end repeat
  return output
end tell'
```

Analyze the tabs and build a report:
- **Total tab count** across all windows
- **Duplicates**: tabs with the same URL (show URL + count)
- **Stale tabs**: common low-value pages (new tab pages, blank tabs, chrome:// internal pages)
- **Expired tabs**: one-time-use pages that are no longer useful — OAuth callbacks, login redirects, authorization codes, confirmation pages, "already responded" forms, expired signed URLs (S3/GCS with tokens), password reset links, email verification pages, checkout success/cancel pages. Identify these by URL patterns like `/callback`, `/auth`, `/oauth`, `/verify`, `/confirm`, `/reset`, `/alreadyresponded`, `X-Amz-Signature`, `token=`, `/checkout/success`, `/checkout/cancel`, etc.
- **Tab hogs**: group tabs by domain, show domains with 5+ tabs

Present a summary like:
```
  Chrome: 47 tabs across 3 windows

  Dupes (8 tabs):
    github.com/anthropics/claude-code/pull/123  ×3
    docs.google.com/document/d/abc123           ×2
    localhost:3000                               ×3

  Stale (4 tabs):
    chrome://newtab                             ×3
    about:blank                                 ×1

  Expired (3 tabs):
    OAuth callback — Claude Platform             ×1
    "You've already responded" — Google Form      ×1
    Signed S3 PDF (expired)                       ×1

  Heavy domains:
    github.com                                  12 tabs
    docs.google.com                              7 tabs
```

Then use AskUserQuestion with multiSelect: true offering cleanup options:

- **"Close dupes (X tabs)"** — Keep one of each duplicate URL, close the rest
- **"Close stale (X tabs)"** — Close new tab pages, blank tabs, chrome:// pages
- **"Close expired (X tabs)"** — Close one-time auth callbacks, confirmation pages, expired signed URLs
- **"Deep clean (X tabs)"** — Close dupes + stale + expired all at once
- **"Merge all into one window"** — Only show if there are 2+ windows. Tell the user to use Chrome's native **Window > Merge All Windows** menu item, which moves tabs without reloading them. Do NOT use AppleScript to recreate tabs — `make new tab with properties {URL:}` reloads every page, which causes login redirects, kills authenticated sessions, and loses state. Instead, trigger it via System Events menu click:

Only show options that have tabs to close (plus grouping/merge options when applicable). If there's nothing to clean, say "Chrome tabs look clean" and skip.

To close tabs, run:
```bash
osascript -e '
tell application "Google Chrome"
  -- close by window id and tab index, working backwards to preserve indices
  tell window id WINDOW_ID to close tab TAB_INDEX
end tell'
```

**Duplicate priority**: When choosing which duplicate to keep, use this priority order:
1. The active tab in the front window (highest priority — never close this one)
2. The active tab in any other window
3. A tab in the front window
4. A tab in any other window (lowest priority — close this one)

This ensures you never close a tab the user is actively looking at.

**Important**: Close tabs in reverse index order within each window so that closing one tab doesn't shift the indices of tabs you still need to close.

To merge all tabs into one window, use Chrome's native menu command via System Events. **NEVER use `make new tab with properties {URL:}` to move tabs** — it reloads every page, causes login redirects, kills authenticated sessions, and loses state.
```bash
osascript -e '
tell application "Google Chrome" to activate
delay 0.5
tell application "System Events"
  tell process "Google Chrome"
    click menu item "Merge All Windows" of menu "Window" of menu bar 1
  end tell
end tell'
```

After closing/merging, report how many tabs were closed and windows merged.

If Chrome was killed in step 4, skip this entirely — no point cleaning tabs on a dead browser.

## 6. Show results

Re-run the RAM stats one-liner and show before/after (include tab cleanup in the summary if it happened):

```
  Before: 15.0 GB used | 8.1 GB available
  After:  12.2 GB used | 10.9 GB available
  Freed:  2.8 GB
```

## Rules
- NEVER kill protected apps, even if the user asks
- No explanations of what RAM is or how memory works
- No "are you sure" — the user already picked what to kill
- Adobe is ALWAYS bloat if the user isn't actively using it. It's a serial respawner — kill it aggressively.
- Be fast. The whole thing should take one question and one action.
