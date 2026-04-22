---
name: format-terraform
description: Enforce Terraform file structure, naming, tagging, pinning, and formatting standards — objective pass/fail checks
---

Terraform linter. Hard requirements — every deviation is a finding. Scan all `.tf` and `.tfvars` files in the repo. Report all violations, then offer to auto-fix.

## Rules

### 1. Directory Layout

- All `.tf` files under `infra/`. Flag any `.tf` outside `infra/`.
- All `.tfvars` under `infra/vars/`.
- Required: `infra/vars/globals.tfvars` + one per environment (e.g. `dev.tfvars`, `prd.tfvars`).
- `globals.tfvars` = shared values (workload, location). Environment files = values that differ per env (SKUs, counts, flags).

### 2. Block-Type Files

Each block type in its own underscore-prefixed file. No block of these types in any other `.tf` file.

| Block type | File |
|------------|------|
| `terraform {}` | `infra/_terraform.tf` |
| `provider` | `infra/_providers.tf` |
| `variable` | `infra/_variables.tf` |
| `output` | `infra/_outputs.tf` |
| `locals` | `infra/_locals.tf` |
| `data` | `infra/_data.tf` |

### 3. Resource Files

Group resources by **functional purpose**, not resource type. File names: lowercase, hyphen-separated, reflecting purpose.

Examples: `networking.tf` (VNet, subnets, NSGs, route tables), `dns.tf` (zones, records), `key-vault.tf` (KV + diagnostics).

- **Resource groups** go in their own file: `infra/resource-groups.tf`. Sole exception to "group by purpose".
- No one-file-per-type (over-splitting). No catch-all dump file (under-splitting).
- Test: "would a reader expect these together?" If yes, same file.

### 4. Block Spacing

Exactly one blank line between top-level blocks. No missing separators. No double blank lines.

### 5. Dead Code

Grep before marking anything as used. Remove anything unused.

- **Variables**: every `variable` must be referenced as `var.<name>` in `.tf` files.
- **Outputs**: every `output` must be consumed externally (pipeline, script, parent module). Search entire repo (YAML, shell, JSON, HCL).
- **Data sources**: every `data` must be referenced as `data.<type>.<name>`.
- **Locals**: every `local.<name>` must be referenced. **Exception:** `resource_suffix_flat` is exempt (scaffolding per Rule 7).
- No commented-out blocks.

### 6. Version Pinning

**Terraform CLI** — pessimistic constraint in `terraform {}`:

```hcl
required_version = "~> 1.9.0"
```

**Providers** — `~>` at minor level. No `>=` (too loose). No `=` exact pins (blocks patches):

```hcl
azurerm = {
  source  = "hashicorp/azurerm"
  version = "~> 4.27"
}
```

Lock file (`terraform.lock.hcl`) must be committed.

### 7. Required Locals

`_locals.tf` must contain:

```hcl
locals {
  resource_suffix      = "${var.workload}-${var.environment}-${var.location_short}-${var.instance}"
  resource_suffix_flat = "${var.workload}${var.environment}${var.location_short}${var.instance}"

  tags = {
    managed-by = "<deployer>"   # e.g. "terraform", "github-actions", "azure-devops"
  }
}
```

Flag if any of these three missing or `tags` lacks `managed-by`.

### 8. Resource Naming

Every resource `name` must reference locals — no inline variable interpolation.

**Standard pattern:** `{type}-${local.resource_suffix}`
**With qualifier:** `{type}-{qualifier}-${local.resource_suffix}` (qualifier = short literal like `netw`, `dns`, `mgmt`)

#### Type Prefixes

| Prefix | Resource |
|--------|----------|
| `rg` | Resource group |
| `vnet` | Virtual network |
| `snet` | Subnet |
| `nsg` | Network security group |
| `rt` | Route table |
| `nw` | Network watcher |
| `mg` | Management group |
| `pip` | Public IP |
| `kv` | Key Vault |
| `law` | Log Analytics workspace |
| `cosmos` | Cosmos DB |
| `stapp` | Static web app |
| `app` | App Service |
| `func` | Function App |
| `st` | Storage account |
| `acr` | Container registry |
| `aks` | Kubernetes service |

Unlisted type → infer short prefix, flag for user confirmation.

#### Examples

| Resource | Expression | Resolved |
|----------|-----------|----------|
| Hub VNet | `"vnet-${local.resource_suffix}"` | `vnet-platform-prd-uks-01` |
| Networking RG | `"rg-netw-${local.resource_suffix}"` | `rg-netw-platform-prd-uks-01` |
| Subnet | `"snet-${each.key}-${local.resource_suffix}"` | `snet-default-platform-prd-uks-01` |
| Storage account | `"st${local.resource_suffix_flat}"` | `stplatformprduks01` |

#### Special Cases

- **Storage accounts & container registries** — use `resource_suffix_flat`. Storage accounts: verify ≤24 chars.
- **Management groups** — tenant-scoped singletons: `mg-{name}`. No env/region/index required.
- **Consumption budgets** — `"budget-${local.resource_suffix}"` or derived from subscription name.

#### Exempt from Naming

DNS zones, management group subscription associations, subnet/NSG/route table associations, routes, external provider resources.

#### Environment Tokens

`prd` = Production, `dvt` = Dev/Test, `dev` = Development, `uat` = UAT

#### Region Tokens

`uks` = UK South, `ukw` = UK West

### 9. Resource Tagging

Every taggable resource must have `tags = local.tags`. No inline tag maps. For extra tags use merge:

```hcl
tags = merge(local.tags, { purpose = "diagnostics" })
```

Flag: missing `tags` argument on taggable resource, or inline map instead of `local.tags`.

### 10. for_each Over count

Use `for_each` for multiples. `count` only for conditionals (`count = var.enabled ? 1 : 0`). Flag any non-conditional `count`.

### 11. Unsupplied Variables

Every `variable` without `default` must receive a value from: `.tfvars` files, pipeline `-var` flags, or `TF_VAR_` env vars. Flag unsupplied variables — they cause plan-time errors in CI.

Do **not** flag variables with `default` (even `default = null`).

---

## Output

List each violation:

- **Rule:** number (1–11)
- **File:** path
- **Finding:** what's wrong
- **Fix:** what to do

Summary count per rule. Offer to auto-fix all. When fixing: move blocks, create missing files, delete empty files, fix spacing in all touched files.
