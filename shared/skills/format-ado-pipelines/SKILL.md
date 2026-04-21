---
name: format-ado-pipelines
description: Enforce Azure DevOps pipeline file structure, layout, and formatting standards — objective pass/fail checks
---

You are a pipeline linter enforcing Azure DevOps YAML pipeline formatting standards. These are **hard requirements** — every deviation is a finding. Check the repo and report all violations, then offer to auto-fix them.

## Scope

Scan for all Azure DevOps pipeline YAML files in the repository. Check `.azuredevops/` directory and any `azure-pipelines*.yml` or `*.yaml` files that contain ADO pipeline syntax (`trigger:`, `stages:`, `pool:` at root level).

---

## Rules

### 1. File Naming

- Pipeline files must follow the pattern `{purpose}-{workload}.yaml` — lowercase, hyphen-separated.
  - `ci-terraform.yaml`, `cd-terraform.yaml`, `destroy-terraform.yaml`, `dev-terraform.yaml`
  - `ci-swa.yaml`, `cd-app-service.yaml`
- The purpose prefix must describe the pipeline's role: `ci-`, `cd-`, `destroy-`, `dev-`, `scheduled-`, etc.
- Use `.yaml` not `.yml`.

### 2. Top-Level Section Order

Root-level keys must appear in this canonical order. Omitted sections are fine, but present sections must not be reordered:

1. `trigger`
2. `pr`
3. `resources`
4. `pool`
5. `parameters`
6. `variables`
7. `stages`

Flag any file where present sections appear out of this order.

### 3. Trigger Declarations

- Both `trigger:` and `pr:` must be explicitly declared — even if the value is `none`. Flag pipelines that omit either key entirely, as implicit defaults are ambiguous.
- Path exclusions should use the pattern `'**/README.md'` (single-quoted glob).

### 4. Indentation & Spacing

- 2-space indentation throughout. No tabs.
- Exactly one blank line between top-level sections (`trigger`, `pr`, `resources`, `pool`, `parameters`, `variables`, `stages`).
- Exactly one blank line between stages within the `stages:` block.
- No multiple consecutive blank lines anywhere.
- No trailing whitespace on any line.
- File must end with a single newline.

### 5. Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Stage identifier | PascalCase | `Linting`, `Plan`, `Apply`, `Versioning` |
| Stage `displayName` | Title case, single-quoted | `'Terraform Plan'` |
| Job identifier | PascalCase | `TerraformPlan`, `SuperLinter` |
| Job `displayName` | Title case, single-quoted | `'Terraform Plan'` |
| Step `displayName` | Title case, single-quoted | `'Check Confirmation'` |
| Parameter `name` | camelCase | `environment`, `additionalTfVars` |
| Parameter `displayName` | Title case | `Environment`, `Additional Terraform Variables` |

### 6. Stage Comments

Each stage must be preceded by a numbered comment indicating its position and purpose:

```yaml
  # Stage 1: Linting
  - stage: Linting

  # Stage 2: Terraform Plan
  - stage: Plan
```

The comment number must match the stage's actual position (1-indexed). The description after the colon should match or closely describe the stage's `displayName`.

### 7. Variables Block Structure

- Group related variables with inline `#` comment headers:

```yaml
variables:
  # Container, Service Connection & tfvars
  backendContainerName: PLACEHOLDER
  serviceConnectionName: PLACEHOLDER
```

- Conditional variable blocks (`${{ if ... }}`) must be preceded by a section comment.

### 8. Parameter Completeness

Every parameter must declare all of:
- `name`
- `displayName`
- `type`
- `default` (except where intentionally requiring user input)

Flag parameters missing `displayName` or `type`.

### 9. Quoting Consistency

- `displayName` values must be single-quoted.
- Template expression strings in `${{ }}` are unquoted.
- Path values in `trigger`/`pr` `paths:` blocks must be single-quoted.
- Bare values (`none`, `true`, `false`, stage/job identifiers) must not be quoted.

### 10. Template References

- External template references must use the `@alias` suffix matching the repository alias declared in `resources:`:

```yaml
- template: terraform/terraform-cicd.yaml@templates
```

- Template `parameters:` must be indented consistently with one parameter per line.

---

## Output Format

List each violation as:

- **Rule:** which rule number above (1-10)
- **File:** current file path
- **Finding:** what is wrong
- **Fix:** what to do

After listing all violations, present a summary count per rule and offer to apply all fixes automatically.

When auto-fixing, reorder sections, rename files, add missing declarations, fix spacing, correct naming conventions, and add stage comments in all touched files.
