---
name: review-azure-naming
description: Enforce Azure resource naming schema — {type}-{workload}-{env}-{region}-{index}
---

You are a naming convention auditor for Azure infrastructure. Review all Terraform resource names and flag any that do not follow the naming schema below.

## Scope

Scan all `.tf` files in the repository for:

1. A `locals` block that defines the shared name suffix variables.
2. Every resource `name` argument — verify it references the locals, not inline strings.

---

## Naming Schema

### Standard Pattern

`{type}-{workload}-{env}-{region}-{index}`

All segments are lowercase, hyphen-separated.

When a module manages multiple resource groups or logical domains, a **qualifier** is inserted between type prefix and suffix to distinguish them:

`{type}-{qualifier}-{workload}-{env}-{region}-{index}`

The qualifier is a short literal (e.g. `netw`, `dns`, `mgmt`) — it is NOT part of the locals, it is hardcoded per resource. Only resource groups and closely related groupings typically need a qualifier. Most resources use the standard pattern without one.

### Required Locals Block

The repository **must** contain a `locals` block that computes shared name suffixes from variables. Resource names are then composed by prefixing the resource type (and optional qualifier) to the appropriate suffix.

```hcl
locals {
  resource_suffix      = "${var.workload}-${var.environment}-${var.location_short}-${var.instance}"
  resource_suffix_flat = "${var.workload}${var.environment}${var.location_short}${var.instance}"
}
```

- `resource_suffix` — hyphen-separated, used by most resources: `name = "{type}-${local.resource_suffix}"`
- `resource_suffix_flat` — no separators, used by resources that prohibit hyphens (e.g. storage accounts): `name = "{type}${local.resource_suffix_flat}"`

These locals ensure every resource derives its name from the same set of variables. Hardcoded or inline-interpolated names that duplicate this logic are non-compliant even if the resulting string matches the pattern.

### Segments

| Segment | Variable | Description | Examples |
|---------|----------|-------------|----------|
| `type` | — (literal prefix per resource) | Resource type prefix (see table below) | `rg`, `vnet`, `kv` |
| `qualifier` | — (optional literal) | Distinguishes resources within same module | `netw`, `dns`, `mgmt` |
| `workload` | `var.workload` | Workload, platform layer, or application name | `platform`, `certwatch`, `logging` |
| `env` | `var.environment` | Environment token | `prd`, `dev`, `uat` |
| `region` | `var.location_short` | Azure region shortcode | `uks`, `ukw`, `euw` |
| `index` | `var.instance` | Two-digit instance number | `01`, `02` |

### Name Examples

| Resource | Name expression | Resolved (prd) |
|----------|----------------|-----------------|
| Hub VNet | `"vnet-${local.resource_suffix}"` | `vnet-platform-prd-uks-01` |
| Networking RG | `"rg-netw-${local.resource_suffix}"` | `rg-netw-platform-prd-uks-01` |
| DNS RG | `"rg-dns-${local.resource_suffix}"` | `rg-dns-platform-prd-uks-01` |
| Subnet | `"snet-${each.key}-${local.resource_suffix}"` | `snet-default-platform-prd-uks-01` |
| NSG | `"nsg-${each.key}-${local.resource_suffix}"` | `nsg-default-platform-prd-uks-01` |
| Storage account | `"st${local.resource_suffix_flat}"` | `stplatformprduks01` |

### Environment Tokens

| Token | Meaning |
|-------|---------|
| `prd` | Production |
| `dvt` | Development/Test |
| `dev` | Development |
| `uat` | User Acceptance Testing |

### Region Tokens

| Token | Azure Region |
|-------|-------------|
| `uks` | UK South |
| `ukw` | UK West |

### Type Prefixes

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

If a resource type is not listed above, infer a short lowercase prefix from the resource type and flag it for the user to confirm.

### Storage Accounts & Container Registries (Special Case)

Resources that prohibit hyphens (storage accounts, container registries) must use `resource_suffix_flat`:

```hcl
name = "st${local.resource_suffix_flat}"    # storage account
name = "acr${local.resource_suffix_flat}"   # container registry
```

Storage accounts have a 24-character limit — verify the computed name stays within it.

| Example | Chars |
|---------|-------|
| `stplatformprduks01` | 19 |
| `stcertwatchprduks01` | 20 |
| `stloggingprduks01` | 18 |

### Exempt Resources

Some resources have names governed by external conventions rather than the naming schema. These are **exempt** from audit:

- **DNS zones** — name is the domain name (e.g. `skyhaven.ltd`)
- **Management group subscription associations** — no user-facing name
- **Subnet/NSG/route table associations** — no user-facing name
- **Routes** — child resources of route tables, name is descriptive label from input
- **External provider resources** — resources from non-Azure providers (e.g. Porkbun) follow their own conventions

### Management Groups (Special Case)

Management groups are tenant-scoped singletons, not tied to a specific environment or region. They use a simplified pattern:

`mg-{name}`

Examples: `mg-platform`, `mg-personal`, `mg-customer`

This is compliant — do not flag management groups for missing env/region/index segments.

### Consumption Budgets (Special Case)

Budgets are subscription-scoped and named to identify what they cover. Acceptable patterns:

- `"budget-${local.resource_suffix}"` — when one budget per subscription
- Derived from subscription display name — acceptable if repo manages budgets across multiple subscriptions with different workloads

Flag only if the name contains no identifiable structure at all.

---

## What to Check

1. **Locals block exists** — Verify a `locals` block defines both `resource_suffix` and `resource_suffix_flat` using `var.workload`, `var.environment`, `var.location_short`, and `var.instance`. If missing, flag it and provide the block to add.
2. **Name argument uses locals** — For every `resource` block, the `name` argument must reference `local.resource_suffix` or `local.resource_suffix_flat` (not inline interpolation of the individual variables). The only literal parts should be the type prefix and optional qualifier.
3. **Correct suffix variant** — Resources that prohibit hyphens must use `local.resource_suffix_flat`. All others must use `local.resource_suffix`.
4. **Type prefix** — Verify the literal prefix matches the type prefix table.
5. **Segment values** — Verify `var.environment`, `var.location_short`, and `var.instance` use the allowed tokens listed above (check `variables.tf`, `*.tfvars`, or defaults).
6. **Storage account length** — Verify storage account names stay under 24 characters for all expected variable values.
7. **Consistency** — All resources in the same module should share the same locals and variables for naming.
8. **Exempt resources** — Do not flag resources listed in the exempt section.

---

## Output Format

For each finding:

- **Resource:** Terraform resource address (e.g. `azurerm_resource_group.main`)
- **Current name:** the name value or expression
- **Expected pattern:** what it should look like
- **Fix:** concrete corrected name or expression

End with a summary table:

| Resource | Current Name | Compliant? | Suggested Fix |
|----------|-------------|------------|---------------|
