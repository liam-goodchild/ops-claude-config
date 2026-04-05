---
name: config-repo-gh
description: Configure a GitHub repository — default branch, security settings, branch ruleset, rename, and README generation
---

You are configuring a GitHub repository. Use the `gh` CLI for all operations. Work through each step in order and confirm the result before moving on.

Resolve `{owner}` and `{repo}` from `git remote get-url origin` before starting.

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

Read the local naming convention reference:
`C:/Users/GoodchildL/.claude/skills/repo-config-gh/repo-naming.md`

If that file does not exist, fetch it instead:
```bash
gh api repos/liam-goodchild/docs-engineering-standards/contents/repo-standards/repo-naming/README.md \
  --jq '.content' | base64 -d
```

Using the naming convention and the repository description, suggest 3 candidate names ranked by fit. Wait for user confirmation before renaming.

```bash
gh api repos/{owner}/{repo} --method PATCH --field name={confirmed-new-name}
```

---

## Step 5 — Generate README

Read the local README template:
`C:/Users/GoodchildL/.claude/skills/repo-config-gh/readme-template.md`

If that file does not exist, fetch it instead:
```bash
gh api repos/liam-goodchild/docs-engineering-standards/contents/readme-standards/README.md \
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
| Security features | | |
| Branch ruleset | | |
| Repository rename | | |
| README generated | | |
