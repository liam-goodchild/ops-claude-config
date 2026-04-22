---
name: review-gha-pipelines
description: Review GitHub Actions workflows for quality, security, and reliability
---

You are a Senior Platform Engineer reviewing GitHub Actions workflow files in this repository.

## Scope

Review all files under `.github/workflows/`. For each workflow, evaluate the areas below.

---

## Review Areas

### 1. Reuse & DRY

- Are reusable workflows (`workflow_call`) used to avoid duplicating jobs across multiple workflows?
- Are composite actions used for repeated step sequences?
- Is there obvious copy-paste between workflows that could be consolidated?

### 2. Permissions

- Does each workflow/job declare `permissions:` explicitly, scoped to least-privilege?
- Is `permissions: write-all` or no `permissions:` block present (inherits repo default)?
- Are `GITHUB_TOKEN` permissions narrowed to only what each job needs (e.g. `contents: read`, `pull-requests: write`)?

### 3. Action Version Pinning

- Are third-party actions pinned to a full commit SHA rather than a mutable tag (e.g. `@v3`)?
- Are first-party (`actions/*`) actions on a pinned major version at minimum?
- Any actions using `@main` or `@master`?

### 4. Secret & Variable Handling

- Are secrets sourced from `secrets.*` or environment-level secrets — not hard-coded in YAML?
- Are non-sensitive config values using `vars.*` (environment variables) rather than being inlined?
- Are secrets printed or echoed anywhere (e.g. in `run:` steps)?

### 5. Stage Gates & Promotion

- Is there a clear promotion path (e.g. build → test → deploy-dev → deploy-prod)?
- Are production deployments gated behind a GitHub Environment with required reviewers?
- Are environment protection rules (`required_reviewers`, `wait_timer`) configured via IaC or documented?

### 6. Concurrency Controls

- Is a `concurrency:` group defined to prevent parallel runs on the same branch/environment?
- Is `cancel-in-progress: true` used appropriately (acceptable for feature branches, risky for deploys)?

### 7. Fail Fast & Job Dependencies

- Are `needs:` dependencies correct — no job runs before its prerequisites?
- Are expensive jobs (deploy, integration tests) skipped when fast checks (lint, unit tests) fail?
- Is `continue-on-error: true` used where it shouldn't be, masking failures?

### 8. Artifact Management

- Are build artifacts uploaded with `actions/upload-artifact` and consumed with `actions/download-artifact` rather than rebuilt in each job?
- Do artifacts have a retention period set (`retention-days:`)?
- Is the same artifact promoted through environments, or is each environment building from source?

### 9. Runner Selection

- Are self-hosted runners used where GitHub-hosted runners would suffice?
- If self-hosted runners are used, is there a label strategy to target the right pool?
- Is `ubuntu-latest` used where a pinned version (e.g. `ubuntu-22.04`) would be more stable?

### 10. Trigger Hygiene

- Are workflows triggered only on the events they need (`push`, `pull_request`, `workflow_dispatch`, etc.)?
- Are `push` triggers scoped to specific branches and paths to avoid unnecessary runs?
- Is `workflow_dispatch` available on deployment workflows for manual re-runs?

### 11. Notifications

- Are workflow failures surfaced to the team (Slack, Teams, email) on main/release branch failures?
- Is there a notify step that only runs `if: failure()`?

---

## Output Format

For each finding:

- **Area:** which category above
- **Severity:** High / Medium / Low / Suggestion
- **File & line:** exact location
- **Finding:** what the issue is
- **Recommendation:** what to change, with a concrete YAML snippet where helpful

End with a **Prioritised Improvements** table:

| Priority | Finding | Effort (S/M/L) | Impact |
|----------|---------|----------------|--------|
