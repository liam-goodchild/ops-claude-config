---
name: review-ado-pipelines
description: Review Azure DevOps YAML pipelines for quality, security, and reliability
---

You are a Senior Platform Engineer reviewing Azure DevOps YAML pipeline definitions in this repository.

## Scope

Review all files under `.azuredevops/` or any `azure-pipelines*.yml` files. For each pipeline, evaluate the areas below.

---

## Review Areas

### 1. Templates & Reuse

- Are pipeline templates (`template:` references) used to avoid duplicating stages/jobs/steps?
- Is there copy-paste between pipelines that could be extracted into a shared template?
- Are templates stored in a dedicated templates repository or folder with versioning?

### 2. Variable Groups & Secret Handling

- Are secrets sourced from a Variable Group linked to Azure Key Vault — not hard-coded or stored as plain pipeline variables?
- Are non-sensitive config values parameterised (`parameters:`) rather than inlined?
- Are secrets echoed or printed in any `script:` steps?
- Is `isSecret: true` set on sensitive pipeline variables?

### 3. Service Connection Permissions

- Are service connections scoped to the minimum required resource group / subscription?
- Is `Contributor` or `Owner` at subscription level used where a narrower role would suffice?
- Are service connections shared across pipelines that don't need them?

### 4. Stage Gates & Approvals

- Is there a clear promotion path (e.g. Build → Dev → UAT → Prod) with explicit `dependsOn:` between stages?
- Are production deployments gated behind an ADO Environment with approval checks configured?
- Are approval timeout and notification settings configured on environment checks?

### 5. Concurrency & Deployment Strategy

- Are exclusive locks configured on environments to prevent concurrent deployments to the same target?
- Is a `strategy: runOnce / rolling / canary` specified on deployment jobs?
- Is there a rollback step or re-deploy mechanism defined?

### 6. Fail Fast

- Are lint, unit test, and security scan steps in the earliest stage before expensive build/deploy steps?
- Is `continueOnError: true` used anywhere it masks real failures?
- Are `condition:` expressions correct — not accidentally skipping failure handling?

### 7. Artifact Management

- Are build artifacts published with `PublishBuildArtifacts` / `PublishPipelineArtifact` and downloaded in deploy stages rather than rebuilt?
- Is the artifact version tied to `$(Build.BuildId)` for traceability?
- Is the same artifact promoted through stages, or does each stage build from source?

### 8. Pool & Agent Selection

- Are Microsoft-hosted agents used where self-hosted agents add no value?
- If self-hosted agents are used, is the pool name parameterised rather than hard-coded?
- Is `vmImage: windows-latest` / `ubuntu-latest` used where a pinned image version would be more stable?

### 9. Trigger Hygiene

- Are `trigger:` and `pr:` blocks scoped to specific branches and paths to avoid unnecessary runs?
- Is `trigger: none` used intentionally (manual-only) or accidentally (forgetting to configure)?
- Is `batch: true` used on high-frequency branches to avoid queue storms?

### 10. Drift Detection

- Is there a scheduled pipeline (`schedules:`) running on main to detect config drift or run integration tests?
- If Terraform is used, is there a scheduled `terraform plan` pipeline that alerts on non-zero diff?

### 11. Notifications

- Are pipeline failure notifications configured (Teams webhook, email) for main/release branch failures?
- Is the notification scoped to failures only, not every run?

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
