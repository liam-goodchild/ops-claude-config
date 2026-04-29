---
name: raise-feature
description: Raise a feature request issue on a GitHub repository using the standard feature template
---

Raise a GitHub feature request issue on a repository. Follow this process exactly.

## Step 1 — Gather information

Ask the user for any missing details:

- **Repository**: which GitHub repo (e.g. `liam-goodchild/my-repo`)? If the working directory is a git repo, infer from `git remote get-url origin`.
- **Title**: a short description of the feature (will be prefixed with `[FEATURE] - `)
- **Problem**: what problem does this feature solve? (e.g. "I'm always frustrated when...")
- **Solution**: what should happen?

Do not proceed until you have enough to fill both body sections meaningfully. If the user provides a terse description, expand it into the template structure — do not ask for every field individually if context makes them inferable.

## Step 2 — Confirm before creating

Show the user the full issue title and body for review before creating. Wait for explicit approval.

## Step 3 — Create the issue

Use the `gh` CLI. On Windows the binary is at `/c/Program Files/GitHub CLI/gh.exe`.

```bash
"/c/Program Files/GitHub CLI/gh.exe" issue create \
  --repo "<owner>/<repo>" \
  --title "[FEATURE] - <title>" \
  --label "feature" \
  --assignee "liam-goodchild" \
  --body "$(cat <<'EOF'
**Is your feature request related to a problem? Please describe.**
<problem>

**Describe the solution you'd like**
<solution>
EOF
)"
```

## Step 4 — Report back

Print the URL of the created issue.
