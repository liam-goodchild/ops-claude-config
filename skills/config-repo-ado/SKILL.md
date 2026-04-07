---
name: config-repo-ado
description: Configure an Azure DevOps repository — default branch, branch policies, Advanced Security, rename, and README generation
---

You are configuring an Azure DevOps repository. Use the `az` CLI (Azure DevOps extension) for all operations. Work through each step in order and confirm the result before moving on.

Resolve `{org}`, `{project}`, and `{repo}` from `git remote get-url origin` before starting. The org URL format is `https://dev.azure.com/{org}`.

---

## Step 1 — Set Default Branch to `main`

```bash
az repos update \
  --org "https://dev.azure.com/{org}" \
  --project "{project}" \
  --repository "{repo}" \
  --default-branch main
```

If `main` does not exist, tell the user and stop.

---

## Step 2 — Enable Azure DevOps Advanced Security

Enable GHAzDo (GitHub Advanced Security for Azure DevOps) — dependency scanning, code scanning, and secret scanning:

```bash
# Enable Advanced Security on the repository
az rest --method PATCH \
  --url "https://advsec.dev.azure.com/{org}/{project}/_apis/management/repositories/{repoId}/enablement?api-version=7.2-preview.1" \
  --body '{"isEnabled": true}'
```

To get `{repoId}`:
```bash
az repos show --org "https://dev.azure.com/{org}" --project "{project}" --repository "{repo}" --query id -o tsv
```

Note: Advanced Security requires the GHAzDo licence to be enabled on the organisation. If unavailable, report this to the user.

---

## Step 3 — Configure Branch Policies on `main`

Apply the following policies via the ADO REST API. Get the project ID first:

```bash
az devops project show --org "https://dev.azure.com/{org}" --project "{project}" --query id -o tsv
```

### 3a — Require a minimum number of reviewers (set to 0 for no mandatory reviewers, adjust as needed)

```bash
az rest --method POST \
  --url "https://dev.azure.com/{org}/{project}/_apis/policy/configurations?api-version=7.1" \
  --body '{
    "isEnabled": true,
    "isBlocking": true,
    "type": { "id": "fa4e907d-c16b-452d-8106-7efa0cb84489" },
    "settings": {
      "minimumApproverCount": 1,
      "creatorVoteCounts": false,
      "allowDownvotes": false,
      "resetOnSourcePush": false,
      "scope": [{ "repositoryId": "{repoId}", "refName": "refs/heads/main", "matchKind": "exact" }]
    }
  }'
```

### 3b — Block direct pushes (require PRs)

```bash
az rest --method POST \
  --url "https://dev.azure.com/{org}/{project}/_apis/policy/configurations?api-version=7.1" \
  --body '{
    "isEnabled": true,
    "isBlocking": true,
    "type": { "id": "17c08c16-8094-4537-824c-4a6a9cfd0cb9" },
    "settings": {
      "allowAdminsBypass": false,
      "scope": [{ "repositoryId": "{repoId}", "refName": "refs/heads/main", "matchKind": "exact" }]
    }
  }'
```

### 3c — Require a linked work item (optional — ask the user)

### 3d — Require a successful build (optional — ask the user for the build definition ID)

---

## Step 4 — Suggest a Repository Name

Ask the user: "What will this repository contain?" if not already clear from context.

Fetch the naming convention:
```bash
gh api repos/liam-goodchild/docs-engineering-standards/contents/standards/repo-naming.md \
  --jq '.content' | base64 -d
```

Using the naming convention and the repository description, suggest 3 candidate names ranked by fit. Wait for user confirmation before renaming.

```bash
az repos update \
  --org "https://dev.azure.com/{org}" \
  --project "{project}" \
  --repository "{repo}" \
  --name "{confirmed-new-name}"
```

---

## Step 5 — Generate README

Fetch the readme template:
```bash
gh api repos/liam-goodchild/docs-engineering-standards/contents/standards/readme-format.md \
  --jq '.content' | base64 -d
```

Parse the repository code to understand its purpose, tech stack, and structure. Generate a `README.md` following the template exactly.

- Do **not** fabricate Terraform documentation — leave any `<!-- BEGIN_TF_DOCS -->` block as a placeholder.
- Only proceed once the user confirms the code is in a working state.

---

## Summary

| Step | Status | Notes |
|------|--------|-------|
| Default branch | | |
| Advanced Security | | |
| Branch policies | | |
| Repository rename | | |
| README generated | | |
