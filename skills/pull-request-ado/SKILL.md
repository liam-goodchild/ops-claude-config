---
name: pull-request-ado
description: Create an Azure DevOps pull request for the current branch
disable-model-invocation: true
---

1. Run `git branch --show-current` and resolve the default branch with `az repos show --query defaultBranch -o tsv | sed 's|refs/heads/||'`. If on the default branch, STOP.

2. Check for an existing PR: `az repos pr list --source-branch $(git branch --show-current) --status active`. If one exists, output its URL and STOP.

3. Ensure local commits are pushed: if `git log origin/{branch}..HEAD` shows unpushed commits, run `git push origin HEAD` first.

4. Determine the title prefix from the branch name:
   - `feature/` → `[FEATURE]`  |  `hotfix/`, `patch/`, `fix/` → `[PATCH]`  |  `major/`, `breaking/` → `[MAJOR]`
   - If unclear, ask the user. If branch contains a work item number (e.g. `feature/12345-thing`), pass `--work-items 12345`.

5. Run `git diff {default}...HEAD` to summarise changes. Derive a brief title (under 60 chars after prefix).

6. Create the PR with:
```
az repos pr create --target-branch {default} --title "<PREFIX> - <title>" --description "## Changes
- <bullet list of changes derived from the diff>"
```

7. Extract `pullRequestId`, `repository.name`, and `repository.project.name` from the PR response using jq. Construct the URL as:
   `https://dev.azure.com/CloudAandE/{project}/_git/{repo}/pullrequest/{id}`
   
   Output the PR URL in this format.
