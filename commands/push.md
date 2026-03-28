---
description: Smart git commit, push, and README update with optional screenshots
argument-hint: [screenshot paths...] (optional - drag/drop or paste paths to include in README)
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Push to Git

## Context

- Current timestamp: !`date "+%Y-%m-%d %H:%M"`
- Current directory: !`pwd`
- Git status: !`git remote -v 2>/dev/null | head -2; echo "---"; git branch --show-current 2>/dev/null; echo "---"; git log --oneline -1 2>/dev/null`

## Instructions

### 1. Detect Repository

Check if the current directory (or project directory from conversation context) is a git repo with a remote:

```bash
git remote -v 2>/dev/null
git branch --show-current 2>/dev/null
```

- If no git repo: ask user if they want to initialize one
- If no remote: ask user for the remote URL
- If repo + remote exist: proceed silently (don't ask for confirmation)

### 2. Review Changes

```bash
git status -s
git diff --stat
git log --oneline -5
```

- Identify all modified, added, and untracked files
- Read key changed files to understand what was done this session
- Check package.json (or equivalent) for current version

### 3. Bump Version

- Read the current version from package.json (or equivalent manifest)
- Determine version bump based on scope of changes:
  - **Patch** (0.0.X): bug fixes, small tweaks
  - **Minor** (0.X.0): new features, significant enhancements
  - **Major** (X.0.0): breaking changes, major rewrites
- Update the version in the manifest file

### 4. Update README

- Read the existing README.md
- Update the features list to reflect current functionality
- Keep the structure/format consistent with what's already there
- Don't remove existing sections — update them if needed, add new ones for new features
- If screenshots were provided via $ARGUMENTS:
  - Create a `screenshots/` directory if it doesn't exist
  - Copy the screenshot files into `screenshots/`
  - Add a Screenshots section near the top of README with markdown image tags:
    ```markdown
    ## Screenshots
    ![Screenshot](screenshots/filename.png)
    ```
  - If screenshots already exist in README, update/replace them

### 5. Commit

- Stage all relevant files (modified + new, skip .env/credentials/node_modules)
- Write a clear commit message summarizing the changes:
  - Start with version tag: `vX.Y.Z: Brief summary`
  - List key changes in the body
  - End with `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>`

### 6. Push

```bash
git push origin <current-branch>
```

- If push fails due to upstream changes, inform the user and suggest `git pull --rebase`
- Report the final commit hash and remote URL when done

### 7. Summary

Output a brief confirmation:
- Version: old -> new
- Files changed count
- Commit hash
- Remote URL
