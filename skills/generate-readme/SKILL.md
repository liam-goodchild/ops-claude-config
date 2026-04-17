---
name: generate-readme
description: Generate a brief project README from repo code and engineering standards template
---

Generate a `README.md` for the current repository.

## Steps

1. Fetch template:

```bash
gh api repos/liam-goodchild/docs-engineering-standards/contents/standards/readme-format.md --jq '.content' | base64 -d
```

If fetch fails, generate a minimal README without template.

2. Read repo code to understand purpose and what it deploys/does.

3. Generate `README.md` following template structure. Rules:
- Brief project overview only — a few sentences on what it does.
- No local development instructions, prerequisites, or setup steps.
- No Terraform details, API references, or tech stack breakdowns.
- No directory structures, tree output, or file listings.
- No content that changes with development (module lists, resource counts, feature inventories).
- No badges unless requested.
- Don't fabricate Terraform docs — leave `<!-- BEGIN_TF_DOCS -->` as placeholder if present in template.

4. Show the generated README and wait for user confirmation before writing.
