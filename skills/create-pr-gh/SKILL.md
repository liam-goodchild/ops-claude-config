---
name: create-pr-gh
description: Create a GitHub pull request for the current branch
disable-model-invocation: true
---

1. `git branch --show-current` + `gh api repos/{owner}/{repo} --jq .default_branch`. If on default branch, STOP.

2. Check existing PR: `gh pr list --head $(git branch --show-current) --state open`. If exists → output URL, STOP.

3. Push if needed: if `git log origin/{branch}..HEAD` shows unpushed commits → `git push origin HEAD`.

4. Title prefix from branch name: `feature/` → `[FEATURE]`, `hotfix/`|`patch/`|`fix/` → `[PATCH]`, `major/`|`breaking/` → `[MAJOR]`. If unclear, ask.

5. `git diff {default}...HEAD` → derive brief title (<60 chars after prefix).

6. Create PR:

```
gh pr create --base {default} --title "<PREFIX> - <title>" --body "## Changes
- <bullet list from diff>"
```

7. Output PR URL.
