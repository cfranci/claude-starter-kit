# Multi-Session Tiling Flow

When resuming multiple sessions at once (e.g. "open all", "open my sessions"):

1. **Deduplicate by project** — if multiple sessions share a label, only resume the most recent one.

2. **Detect terminal**: Check `$TERM_PROGRAM` to determine the terminal app.

### If iTerm2 (`TERM_PROGRAM` = `iTerm.app`):

3. **Open as a tiled grid in one iTerm2 tab** using split panes:
   - **CRITICAL: Always use `profile "Glas"`** for every split and tab creation. This profile has the correct translucent appearance AND no `Initial Text`, preventing double-launch. Do NOT use `profile "Default"` or `profile "Claude"`.
   - Build the grid with horizontal and vertical splits:
     - 2-3 sessions: stack vertically or side by side
     - 4-5 sessions: top row 3, bottom row 2
     - 6 sessions: 2x3
     - 9 sessions: 3x3

4. **Set pane titles** to the label name: `tell item i of allSessions to set name to labelName`

5. **Send resume commands**: `claude --resume <sessionId>` to each pane

6. **Re-apply labels**: After a 3-second delay (to let Claude boot), send `/label <name>` to each pane via AppleScript `write text`.

7. **Ask to close the launcher window**.

8. **AppleScript template for 5 sessions (top 3, bottom 2)**:
```applescript
tell application "iTerm2"
    tell current window
        create tab with profile "Glas"
        set gridTab to current tab
        tell current session of gridTab
            split horizontally with profile "Glas"
        end tell
        set allSessions to sessions of gridTab
        tell item 1 of allSessions
            split vertically with profile "Glas"
        end tell
        set allSessions to sessions of gridTab
        tell item 1 of allSessions
            split vertically with profile "Glas"
        end tell
        set allSessions to sessions of gridTab
        tell item 4 of allSessions
            split vertically with profile "Glas"
        end tell
        set allSessions to sessions of gridTab
        repeat with i from 1 to (count of sessionIds)
            tell item i of allSessions
                set name to item i of labelNames
                write text "claude --resume " & item i of sessionIds
            end tell
        end repeat
        delay 3
        repeat with i from 1 to (count of labelNames)
            tell item i of allSessions
                write text "/label " & item i of labelNames
            end tell
        end repeat
    end tell
end tell
```

9. **3x3 grid template**:
```applescript
tell application "iTerm2"
    tell current window
        create tab with profile "Glas"
        set gridTab to current tab
        tell current session of gridTab
            split horizontally with profile "Glas"
        end tell
        tell current session of gridTab
            split horizontally with profile "Glas"
        end tell
        set allSessions to sessions of gridTab
        repeat with s in allSessions
            tell s
                split vertically with profile "Glas"
            end tell
        end repeat
        set allSessions to sessions of gridTab
        tell item 2 of allSessions
            split vertically with profile "Glas"
        end tell
        tell item 4 of allSessions
            split vertically with profile "Glas"
        end tell
        tell item 6 of allSessions
            split vertically with profile "Glas"
        end tell
        set allSessions to sessions of gridTab
        repeat with i from 1 to (count of sessionIds)
            tell item i of allSessions
                set name to item i of labelNames
                write text "claude --resume " & item i of sessionIds
            end tell
        end repeat
        delay 3
        repeat with i from 1 to (count of labelNames)
            tell item i of allSessions
                write text "/label " & item i of labelNames
            end tell
        end repeat
    end tell
end tell
```

### If NOT iTerm2:

Print resume commands for the user to copy:
```
Run these in separate terminals:
  claude --resume <id1>   # Label: MyStayVA
  claude --resume <id2>   # Label: The GuestBook
```
