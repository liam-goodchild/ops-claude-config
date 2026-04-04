---
name: pull-request-gh
description: Create a GitHub pull request for the current branch
disable-model-invocation: true
---

1. Run `git branch --show-current` and resolve the default branch with `gh api repos/{owner}/{repo} --jq .default_branch`. If on the default branch, STOP.

2. Check for an existing PR: `gh pr list --head $(git branch --show-current) --state open`. If one exists, output its URL and STOP.

3. Ensure local commits are pushed: if `git log origin/{branch}..HEAD` shows unpushed commits, run `git push origin HEAD` first.

4. Determine the title prefix from the branch name:
   - `feature/` → `[FEATURE]`  |  `hotfix/`, `patch/`, `fix/` → `[PATCH]`  |  `major/`, `breaking/` → `[MAJOR]`
   - If unclear, ask the user.

5. Run `git diff {default}...HEAD` to summarise changes. Derive a brief title (under 60 chars after prefix).

6. Create the PR with:
```
gh pr create --base {default} --title "<PREFIX> - <title>" --body "## Changes
- <bullet list of changes derived from the diff>"
```

7. Output the PR URL.
