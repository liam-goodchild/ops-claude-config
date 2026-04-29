---
name: raise-bug
description: Raise a bug report issue on a GitHub repository using the standard bug template
---

Raise a GitHub bug report issue on a repository. Follow this process exactly.

## Step 1 — Gather information

Ask the user for any missing details:

- **Repository**: which GitHub repo (e.g. `liam-goodchild/my-repo`)? If the working directory is a git repo, infer from `git remote get-url origin`.
- **Title**: a short description of the bug (will be prefixed with `[BUG] - `)
- **Describe the bug**: what is happening?
- **Steps to reproduce**: numbered steps to trigger the bug
- **Expected behavior**: what should happen instead?

Do not proceed until you have enough to fill all three body sections meaningfully. If the user provides a terse description, expand it into the template structure — do not ask for every field individually if context makes them inferable.

## Step 2 — Confirm before creating

Show the user the full issue title and body for review before creating. Wait for explicit approval.

## Step 3 — Create the issue

Use the `gh` CLI. On Windows the binary is at `/c/Program Files/GitHub CLI/gh.exe`.

Body follows the bug report template from `liam-goodchild/.github` at `.github/ISSUE_TEMPLATE/bug_report.md`.

```bash
"/c/Program Files/GitHub CLI/gh.exe" issue create \
  --repo "<owner>/<repo>" \
  --title "[BUG] - <title>" \
  --label "bug" \
  --assignee "liam-goodchild" \
  --body "$(cat <<'EOF'
**Describe the bug**
<description>

**To Reproduce**
Steps to reproduce the behavior:

<steps>

**Expected behavior**
<expected>
EOF
)"
```

## Step 4 — Report back

Print the URL of the created issue.
