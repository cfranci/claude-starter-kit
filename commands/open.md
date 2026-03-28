---
description: Smart project opener. Give it a folder path, repo name, GitHub URL, project name, or nothing to see all your labeled sessions.
arguments:
  - name: target
    description: "A folder path, GitHub URL, owner/repo, project name, or empty to browse"
    required: false
---

You are opening a project for the user. Always ask to label when opening a project.

The user's GitHub username is **cfranci**. Local project dirs: `/Users/cf/projects/`, `/Users/cf/Desktop/Projects/`, `/Applications/`, `/Users/cf/`, `/Users/cf/moms projects/`

## Route `$ARGUMENTS`

**Empty** → SESSION BROWSER (below)
**Local path** (`/`, `~`, `./`) → LOCAL PROJECT (below)
**GitHub URL or owner/repo** → if owner is `cfranci`, treat as OWN REPO. Otherwise read `~/.claude/commands/open-flows/external-repo.md` and follow it.
**Just a name** → OWN PROJECT SEARCH (below)

---

## SESSION BROWSER

Run a Python script that scans `~/.claude/projects/` for JSONL session files modified in last 14 days. For each: get mod time, extract first user prompt, grep for last `echo '<text>' > /tmp/claude-label-` (label name) and `echo '<R;G;B>' > /tmp/claude-label-color-` (color). Group by label, show numbered list with age and message count. Wait for user to pick a number, label name, "all", or "new".

- **Number** → `claude --resume <sessionId>`
- **Label name** → resume that session (if multiple, show and ask)
- **"all"** → Read `~/.claude/commands/open-flows/tiling.md` and follow it
- **"new"** → ask what project, then OWN PROJECT SEARCH

---

## LOCAL PROJECT

1. Discover structure in parallel: `ls -la`, read README.md/CLAUDE.md/package.json/HANDOFF.md/whats-next.md if they exist, list src dirs
2. Read key files (first 150-200 lines for large files)
3. If handoff exists, show "Welcome back" summary with last session status
4. Check for recent sessions in this project (scan JSONLs matching this path)
5. If starting fresh, present concise briefing: what it is, tech stack, file map, how to run
6. Label: check presets, auto-apply if found, otherwise suggest name + color

---

## OWN PROJECT SEARCH

1. Search local dirs: `find` across all project dirs with `-iname "*<name>*"` (maxdepth 3)
2. If found locally → LOCAL PROJECT
3. If not found → check GitHub: `gh repo list cfranci --limit 100 --json name,description | grep -i "<name>"`
4. If on GitHub → offer to clone to `/Users/cf/projects/<name>`, then LOCAL PROJECT
5. Not found anywhere → ask for clarification

---

## OWN REPO

1. Extract repo name from URL
2. Search locally (same as OWN PROJECT SEARCH step 1)
3. If found → LOCAL PROJECT
4. If not → offer to clone to `/Users/cf/projects/<name>`, then LOCAL PROJECT
