---
description: Undo the last file change or revert the last commit
---
Check `git diff` and `git log -1`. If there are unstaged changes, offer to `git checkout` the modified files. If the last commit was recent (within this session), offer to `git reset --soft HEAD~1`. Show what will be undone before doing it. Ask for confirmation on destructive actions.
