---
name: git-cleanup
description: Checkout default branch, delete merged local branches, prune remotes, and pull latest
disable-model-invocation: true
---

Run these commands in sequence:

```
DEFAULT=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@') || DEFAULT="main"
git checkout "$DEFAULT"
git fetch --prune
git branch --merged | grep -Ev '^\*|^\s+(main|master)$' | xargs -r git branch -d
git pull
```

List deleted branches. Then list any unmerged feature branches (`git branch --no-merged`) and ask the user before force-deleting any of those.
