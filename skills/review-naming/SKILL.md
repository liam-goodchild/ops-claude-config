---
name: review-naming
description: Enforce Azure resource naming schema — {type}-{workload}-{env}-{region}-{index}
---

You are a naming convention auditor for Azure infrastructure. Review all Terraform resource names and flag any that do not follow the naming schema below.

## Scope

Scan all `.tf` files in the repository for resource `name` arguments and `locals` that construct resource names.

---

## Naming Schema

### Standard Pattern

`{type}-{workload}-{env}-{region}-{index}`

All segments are lowercase, hyphen-separated.

### Segments

| Segment | Description | Examples |
|---------|-------------|----------|
| `type` | Resource type prefix (see table below) | `rg`, `vnet`, `kv` |
| `workload` | Project, application, or function name | `certwatch`, `networking`, `logging` |
| `env` | Environment token | `prd`, `dev`, `uat` |
| `region` | Azure region shortcode | `uks`, `ukw`, `euw` |
| `index` | Two-digit instance number | `01`, `02` |

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

### Storage Accounts (Special Case)

Storage accounts cannot contain hyphens and have a 24-character limit. Use the pattern:

`st{workload}{env}{region}{index}`

All lowercase, no hyphens, no separators.

| Example | Chars |
|---------|-------|
| `stcertwatchprduks01` | 19 |
| `stterraformprduks01` | 19 |
| `stloggingprduks01` | 17 |

---

## What to Check

1. **Name argument** — For every `resource` block, check the `name` argument matches the pattern for its resource type.
2. **Locals-based naming** — If names are constructed in `locals`, verify the pattern produces compliant names.
3. **Segment values** — Verify `env`, `region`, and `index` segments use the allowed tokens listed above.
4. **Storage account compliance** — Verify storage accounts use the no-hyphen variant and are under 24 characters.
5. **Consistency** — All resources in the same deployment should share the same `workload`, `env`, and `region` values unless there is an explicit reason not to.

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
