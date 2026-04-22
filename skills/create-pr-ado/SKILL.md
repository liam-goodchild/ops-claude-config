---
name: create-pr-ado
description: Create an Azure DevOps pull request for the current branch
disable-model-invocation: true
---

1. `git branch --show-current` + `az repos show --query defaultBranch -o tsv | sed 's|refs/heads/||'`. If on default branch, STOP.

2. Check existing PR: `az repos pr list --source-branch $(git branch --show-current) --status active`. If exists → output URL, STOP.

3. Push if needed: if `git log origin/{branch}..HEAD` shows unpushed commits → `git push origin HEAD`.

4. Title prefix from branch name: `feature/` → `[FEATURE]`, `hotfix/`|`patch/`|`fix/` → `[PATCH]`, `major/`|`breaking/` → `[MAJOR]`. If unclear, ask. If branch has work item number (e.g. `feature/12345-thing`) → `--work-items 12345`.

5. `git diff {default}...HEAD` → derive brief title (<60 chars after prefix).

6. Create PR:

```
az repos pr create --target-branch {default} --title "<PREFIX> - <title>" --description "## Changes
- <bullet list from diff>"
```

7. Extract `pullRequestId`, `repository.name`, `repository.project.name` from response. Output URL: `https://dev.azure.com/CloudAandE/{project}/_git/{repo}/pullrequest/{id}`
