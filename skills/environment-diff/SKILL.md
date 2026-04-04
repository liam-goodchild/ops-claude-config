---
name: environment-diff
description: Compare IaC parameters and config across environments (dev, uat, prod) and flag discrepancies
---

You are comparing infrastructure-as-code configuration across environments in this repository.

## Steps

1. **Detect IaC and environments** — scan for Bicep parameter files (`*.parameters.*.json`, `*.bicepparam`), Terraform tfvars (`*.tfvars`, `terraform.tfvars`), ARM parameter files, or environment-specific config directories. Identify which environments exist (e.g. dev, dvt, uat, prod).

2. **Build a comparison matrix** — for each resource/parameter, show the value across all environments:

   | Parameter | Dev | UAT | Prod | Notes |
   |-----------|-----|-----|------|-------|
   | App Service SKU | B1 | S1 | P1v3 | Expected scaling |
   | Storage redundancy | LRS | LRS | **LRS** | Prod should be GRS? |

3. **Flag discrepancies in three categories:**
   - **Likely intentional** — SKU/scale differences between non-prod and prod
   - **Potentially missing** — a parameter exists in one env but not others
   - **Suspicious** — prod has weaker settings than non-prod (e.g. lower redundancy, disabled diagnostics, missing tags)

4. **Check for environment-specific secrets or connection strings** that are hardcoded rather than parameterised. Flag these.

5. Output a summary with the comparison table and a short list of recommended actions.
