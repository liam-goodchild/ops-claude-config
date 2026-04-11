---
name: config-repo-gh
description: Configure a GitHub repository — default branch, security settings, branch ruleset, rename, and README generation. Can create the repo from scratch.
---

You are configuring a GitHub repository. Use the `gh` CLI for all operations. Work through each step in order and confirm the result before moving on.

---

## Step 0 — Prerequisites & Repository Initialisation

### 0a — Verify authentication

```bash
gh auth status
```

If the user is not authenticated, tell them to run `! gh auth login` and stop until they confirm success.

### 0b — Determine repository state

Check whether a git repo and remote already exist:

```bash
git remote get-url origin 2>/dev/null
```

**If a remote exists:** resolve `{owner}` and `{repo}` from the URL and skip to Step 1.

**If no remote exists:** continue with 0c–0f to create one.

### 0c — Initialise local repository (if needed)

If the current directory is not a git repository:

```bash
git init
```

### 0d — Ensure the branch is called `main`

The default branch after `git init` is often `master`. Rename it:

```bash
git branch -m main
```

(Safe to run even if already on `main`.)

### 0e — Create the remote repository

Ask the user whether the repo should be **public** or **private** (default: private). Then ask what org/owner to create it under, or default to the authenticated user.

```bash
gh repo create {owner}/{repo} --private --source=. --remote=origin
```

(Replace `--private` with `--public` if requested.)

Resolve `{owner}` and `{repo}` from `git remote get-url origin` after creation.

### 0f — Push an empty `main` branch

```bash
git commit --allow-empty -m "chore: initialise repository"
git push -u origin main
```

### 0g — Create a working branch

All file changes (including README generation, etc.) must be made on a new branch:

```bash
git checkout -b major/initial-design
```

> **Important:** From this point on, any file writes or commits happen on `major/initial-design`, not `main`.

---

## Step 1 — Set Default Branch to `main`

```bash
gh api repos/{owner}/{repo} --method PATCH --field default_branch=main
```

If `main` does not exist, tell the user and stop.

---

## Step 2 — Enable Security Features

```bash
# Private vulnerability reporting
gh api repos/{owner}/{repo}/private-vulnerability-reporting --method PUT

# Dependabot alerts
gh api repos/{owner}/{repo}/vulnerability-alerts --method PUT

# Dependabot security updates
gh api repos/{owner}/{repo}/automated-security-fixes --method PUT

# Secret scanning + push protection
gh api repos/{owner}/{repo} --method PATCH \
  --field 'security_and_analysis={"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}'
```

Note any features unavailable on the current plan and explain why.

---

## Step 3 — Import Branch Ruleset

Check for an existing `main-branch-protection` ruleset first:

```bash
gh api repos/{owner}/{repo}/rulesets --jq '.[] | select(.name=="main-branch-protection") | .id'
```

If it exists, `PATCH` to that ID. Otherwise `POST` a new one:

```bash
gh api repos/{owner}/{repo}/rulesets --method POST --input - <<'EOF'
{
  "name": "main-branch-protection",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": { "exclude": [], "include": ["~DEFAULT_BRANCH"] }
  },
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": false,
        "required_reviewers": [],
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": false,
        "allowed_merge_methods": ["merge", "squash", "rebase"]
      }
    }
  ],
  "bypass_actors": []
}
EOF
```

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
gh api repos/{owner}/{repo} --method PATCH --field name={confirmed-new-name}
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
| Auth & repo init | | |
| Default branch | | |
| Security features | | |
| Branch ruleset | | |
| Repository rename | | |
| README generated | | |
