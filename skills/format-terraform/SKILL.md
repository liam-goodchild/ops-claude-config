---
name: format-terraform
description: Enforce Terraform file structure, naming, tagging, pinning, and formatting standards — objective pass/fail checks
---

You are a Terraform linter enforcing structure, naming, and formatting standards. These are **hard requirements** — every deviation is a finding. Check the repo and report all violations, then offer to auto-fix them.

## Scope

Scan for all `.tf` and `.tfvars` files in the repository.

---

## Rules

### 1. Directory Layout

- All `.tf` files must live under `infra/` at the repository root. Flag any `.tf` file outside `infra/`.
- All `.tfvars` files must be stored under `infra/vars/`.
- Required tfvars files: `infra/vars/globals.tfvars`, plus one per environment — e.g. `infra/vars/dev.tfvars`, `infra/vars/prd.tfvars`. Flag if `globals.tfvars` or any expected environment file is missing.
- `globals.tfvars` holds values shared across all environments (e.g. workload name, location). Environment files hold only values that differ per environment (e.g. SKUs, instance counts, feature flags).

### 2. Block-Type Files

Each Terraform block type must be in its own dedicated file with an underscore prefix. No block of these types should appear in any other `.tf` file.

| Block type | File |
|------------|------|
| `terraform {}` | `infra/_terraform.tf` |
| `provider` | `infra/_providers.tf` |
| `variable` | `infra/_variables.tf` |
| `output` | `infra/_outputs.tf` |
| `locals` | `infra/_locals.tf` |
| `data` | `infra/_data.tf` |

### 3. Resource Files

Resources must be grouped by **functional purpose** into named `.tf` files under `infra/`. All resources that belong to the same concern live in the same file. File names are lowercase, hyphen-separated, and reflect the purpose — not the resource type.

Examples:
- `infra/networking.tf` — VNet, subnets, NSGs, route tables, associations, network watcher, networking resource group
- `infra/dns.tf` — DNS zones, nameserver records, DNS resource group
- `infra/management-groups.tf` — management groups and subscription associations
- `infra/key-vault.tf` — Key Vault and any diagnostic settings scoped to it
- `infra/storage.tf` — storage accounts (all purposes unless clearly distinct, e.g. `storage-logs.tf`)

Rules:
- **Resource groups** must live in their own file: `infra/resource-groups.tf`. Do not co-locate resource groups with the resources they contain.
- Do not create one file per resource type — that is over-splitting. (Resource groups are the sole exception.)
- Do not dump unrelated resources into a single catch-all file — that is under-splitting.
- When in doubt, ask: "would a reader expect to find these resources together?" If yes, same file.

### 4. Block Spacing

All `.tf` files must have exactly one blank line between top-level blocks. No consecutive blocks without a separating blank line. No multiple blank lines between blocks.

```hcl
variable "location" {
  description = "Resource location for Azure resources."
  type        = string
}

variable "environment" {
  description = "Name of Azure environment (dev/prd)."
  type        = string
}
```

### 5. Dead Code

- Every declared `variable` must be referenced (`var.<name>`) somewhere in the `.tf` configuration. Grep for each variable before marking it as used. Remove unused variables.
- Every declared `output` must be consumed by something external — a pipeline, script, parent module, or other caller. Search the entire repository (YAML, shell, JSON, HCL) for references before marking an output as used. An output that exists only in `_outputs.tf` with no external consumer is dead code. Remove unused outputs.
- Every `data` source must be referenced (`data.<type>.<name>`) somewhere in the configuration. Grep for each data source before marking it as used. Remove unused data sources.
- Every `locals` entry must be referenced (`local.<name>`) somewhere in the configuration. Grep for each local before marking it as used. Remove unused locals. **Exception:** `resource_suffix_flat` is exempt — it is scaffolding required by Rule 7 and may not have a consumer yet.
- No commented-out blocks or resources.

### 6. Version Pinning

Both the Terraform CLI and all providers must have pinned versions.

**Terraform CLI** — `required_version` must be set inside the `terraform {}` block with a pessimistic constraint:

```hcl
terraform {
  required_version = "~> 1.9.0"
}
```

**Providers** — every provider in `required_providers` must have a pessimistic version constraint (`~>`). Constraints that are too loose (`>= 3.0`) risk breaking upgrades. Exact pins (`= 3.114.0`) block patches. Use `~>` at the minor level:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.27"
    }
  }
}
```

The provider lock file (`terraform.lock.hcl`) must be committed to source control.

### 7. Required Locals Block

The `_locals.tf` file **must** contain the following computed values:

```hcl
locals {
  resource_suffix      = "${var.workload}-${var.environment}-${var.location_short}-${var.instance}"
  resource_suffix_flat = "${var.workload}${var.environment}${var.location_short}${var.instance}"

  tags = {
    managed-by = "<deployer>"
  }
}
```

- `resource_suffix` — hyphen-separated, used by most resources.
- `resource_suffix_flat` — no separators, used by resources that prohibit hyphens (storage accounts, container registries).
- `tags` — must include at least `managed-by` with the value set to whatever is deploying the infrastructure (e.g. `"terraform"`, `"github-actions"`, `"azure-devops"`). Additional tags (environment, workload, etc.) may be added alongside.

Flag if any of these three locals are missing or if `tags` lacks the `managed-by` key.

### 8. Resource Naming Schema

Every resource `name` argument must follow the naming schema and reference the locals — not inline interpolation of individual variables.

#### Standard Pattern

`{type}-{workload}-{env}-{region}-{index}`

All segments are lowercase, hyphen-separated. The name expression must be:

```hcl
name = "{type}-${local.resource_suffix}"
```

When a module manages multiple resource groups or logical domains, a **qualifier** is inserted:

```hcl
name = "{type}-{qualifier}-${local.resource_suffix}"
```

The qualifier is a short literal (e.g. `netw`, `dns`, `mgmt`) — hardcoded per resource, not part of the locals.

#### Segments

| Segment | Source | Description | Examples |
|---------|--------|-------------|----------|
| `type` | literal prefix | Resource type prefix (see table) | `rg`, `vnet`, `kv` |
| `qualifier` | optional literal | Distinguishes resources within same module | `netw`, `dns`, `mgmt` |
| `workload` | `var.workload` | Workload or application name | `platform`, `certwatch` |
| `env` | `var.environment` | Environment token | `prd`, `dev`, `uat` |
| `region` | `var.location_short` | Azure region shortcode | `uks`, `ukw` |
| `index` | `var.instance` | Two-digit instance number | `01`, `02` |

#### Type Prefixes

| Prefix | Resource type |
|--------|--------------|
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

If a resource type is not listed, infer a short lowercase prefix and flag it for the user to confirm.

#### Name Examples

| Resource | Name expression | Resolved (prd) |
|----------|----------------|-----------------|
| Hub VNet | `"vnet-${local.resource_suffix}"` | `vnet-platform-prd-uks-01` |
| Networking RG | `"rg-netw-${local.resource_suffix}"` | `rg-netw-platform-prd-uks-01` |
| Subnet | `"snet-${each.key}-${local.resource_suffix}"` | `snet-default-platform-prd-uks-01` |
| Storage account | `"st${local.resource_suffix_flat}"` | `stplatformprduks01` |

#### Special Cases

**Storage accounts & container registries** — must use `resource_suffix_flat` (no hyphens). Storage accounts have a 24-character limit — verify the computed name stays within it.

**Management groups** — tenant-scoped singletons, simplified pattern: `mg-{name}`. Do not flag for missing env/region/index.

**Consumption budgets** — `"budget-${local.resource_suffix}"` or derived from subscription display name. Flag only if no identifiable structure.

#### Exempt Resources

Do not flag names for:
- DNS zones (name is the domain name)
- Management group subscription associations
- Subnet/NSG/route table associations
- Routes (child resources, descriptive label from input)
- External provider resources (non-Azure providers follow their own conventions)

#### Environment Tokens

| Token | Meaning |
|-------|---------|
| `prd` | Production |
| `dvt` | Development/Test |
| `dev` | Development |
| `uat` | User Acceptance Testing |

#### Region Tokens

| Token | Azure Region |
|-------|-------------|
| `uks` | UK South |
| `ukw` | UK West |

### 9. Resource Tagging

Every resource that supports the `tags` argument must have:

```hcl
tags = local.tags
```

Do not allow inline tag maps on individual resources — all tags must flow from the shared `local.tags`. If a resource needs additional resource-specific tags, use `merge()`:

```hcl
tags = merge(local.tags, {
  purpose = "diagnostics"
})
```

Flag any resource that supports tags but is missing the `tags` argument entirely, or uses an inline map instead of `local.tags`.

### 10. for_each Over count

When deploying multiple resources of the same type, use `for_each` with a map or set — not `count`. `count` is only acceptable for conditional creation (`count = var.enabled ? 1 : 0`).

```hcl
# Good — for_each
resource "azurerm_subnet" "main" {
  for_each = var.subnets
  name     = "snet-${each.key}-${local.resource_suffix}"
  # ...
}

# Bad — count for multiple instances
resource "azurerm_subnet" "main" {
  count = length(var.subnet_names)
  name  = "snet-${var.subnet_names[count.index]}-${local.resource_suffix}"
  # ...
}
```

Flag any `count` usage where the value is not a conditional (ternary producing 0 or 1).

---

## What to Check (Summary)

1. **Directory layout** — all `.tf` under `infra/`, all `.tfvars` under `infra/vars/`, `globals.tfvars` exists.
2. **Block-type files** — each block type in its dedicated underscore-prefixed file.
3. **Resource file grouping** — grouped by purpose, not one-file-per-type.
4. **Block spacing** — exactly one blank line between top-level blocks.
5. **Dead code** — no unused variables, outputs, or commented-out blocks.
6. **Version pinning** — `required_version` set, all providers use `~>`, lock file committed.
7. **Locals block** — `resource_suffix`, `resource_suffix_flat`, and `tags` (with `managed-by`) all defined.
8. **Resource naming** — every `name` argument uses the locals with correct type prefix.
9. **Resource tagging** — every taggable resource has `tags = local.tags` (or merge).
10. **for_each over count** — `count` only for conditionals, `for_each` for multiples.

---

## Output Format

List each violation as:

- **Rule:** which rule number above (1–10)
- **File:** current file path
- **Finding:** what is wrong
- **Fix:** what to do (move to which file, delete, add blank line, etc.)

After listing all violations, present a summary count per rule and offer to apply all fixes automatically.

When auto-fixing, move blocks to their correct files, create missing files, delete files that become empty after moves, and ensure blank-line spacing is correct in all touched files.
