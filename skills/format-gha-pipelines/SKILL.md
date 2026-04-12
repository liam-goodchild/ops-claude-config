---
name: format-gha-pipelines
description: Enforce GitHub Actions workflow file structure, layout, and formatting standards — objective pass/fail checks
---

You are a pipeline linter enforcing GitHub Actions workflow formatting standards. These are **hard requirements** — every deviation is a finding. Check the repo and report all violations, then offer to auto-fix them.

## Scope

Scan for all workflow files under `.github/workflows/` in the repository.

---

## Rules

### 1. File Naming

- Workflow files must follow the pattern `{purpose}-{workload}.yaml` — lowercase, hyphen-separated.
  - `ci-terraform.yaml`, `cd-terraform.yaml`, `destroy-terraform.yaml`
  - `ci-app.yaml`, `cd-swa.yaml`, `scheduled-drift.yaml`
- The purpose prefix must describe the workflow's role: `ci-`, `cd-`, `destroy-`, `dev-`, `scheduled-`, `reusable-`, etc.
- Use `.yaml` not `.yml`.

### 2. Top-Level Section Order

Root-level keys must appear in this canonical order. Omitted sections are fine, but present sections must not be reordered:

1. `name`
2. `on`
3. `permissions`
4. `concurrency`
5. `env`
6. `jobs`

Flag any file where present sections appear out of this order.

### 3. Workflow Name

- Every workflow must have a `name:` key. Flag workflows that omit it.
- The name must be title case and describe the workflow's purpose: `'CI - Terraform'`, `'CD - Terraform'`, `'Destroy - Terraform'`.

### 4. Trigger Block Formatting

- The `on:` block must use the expanded mapping form, not the shorthand:

```yaml
# Good
on:
  pull_request:
    branches: [main]

# Bad
on: [push, pull_request]
```

- Branch lists should use flow sequence style when short: `branches: [main]`.
- Path filters should use block sequence style with single-quoted globs:

```yaml
paths-ignore:
  - '**/README.md'
```

### 5. Permissions Block

- Every workflow must declare a top-level `permissions:` block. Flag workflows that omit it.
- Permissions should be scoped to least-privilege. Flag `permissions: write-all` or empty `permissions:` (which inherits repo defaults).

### 6. Indentation & Spacing

- 2-space indentation throughout. No tabs.
- Exactly one blank line between top-level sections (`name`, `on`, `permissions`, `concurrency`, `env`, `jobs`).
- Exactly one blank line between jobs within the `jobs:` block.
- No multiple consecutive blank lines anywhere.
- No trailing whitespace on any line.
- File must end with a single newline.

### 7. Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Job identifier | kebab-case | `terraform-plan`, `build-app`, `deploy-dev` |
| Job `name` | Title case, single-quoted | `'Terraform Plan'` |
| Step `name` | Title case, single-quoted | `'Setup Terraform'` |
| Environment names | lowercase | `dev`, `prod`, `staging` |

### 8. Job Comments

Each job must be preceded by a comment indicating its purpose:

```yaml
jobs:
  # Lint and validate code
  lint:
    name: 'Lint & Validate'

  # Plan infrastructure changes
  terraform-plan:
    name: 'Terraform Plan'
```

### 9. Job Completeness

Every job must declare:
- `name` — a human-readable display name (single-quoted, title case)
- `runs-on` — the runner to use

Flag jobs missing `name`.

### 10. Step Formatting

- Every step must have a `name:` — flag unnamed steps.
- Step `name` values must be single-quoted and title case.
- `uses:` steps and `run:` steps should both have a `name:`.
- Multi-line `run:` blocks must use the `|` literal block scalar:

```yaml
- name: 'Run Tests'
  run: |
    npm ci
    npm test
```

### 11. Quoting Consistency

- `name` values (workflow, job, step) must be single-quoted.
- Expression strings `${{ }}` are unquoted.
- Path values in trigger blocks must be single-quoted.
- Bare values (`true`, `false`, numbers) must not be quoted.
- Environment variable values that are plain strings should be unquoted unless they contain special characters.

### 12. Action References

- Third-party actions should be pinned to a full commit SHA with a version comment:

```yaml
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4
```

- First-party `actions/*` actions must be pinned to at least a major version tag: `actions/checkout@v4`.

---

## Output Format

List each violation as:

- **Rule:** which rule number above (1-12)
- **File:** current file path
- **Finding:** what is wrong
- **Fix:** what to do

After listing all violations, present a summary count per rule and offer to apply all fixes automatically.

When auto-fixing, reorder sections, rename files, add missing declarations, fix spacing, correct naming conventions, and add job comments in all touched files.
