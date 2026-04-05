---
name: generate-cost-estimate
description: Generate an Azure cost estimate for deployed infrastructure including serverless components
---

You are producing a cost estimate for the Azure infrastructure in this repository.

## Steps

1. **Identify infrastructure scope** — scan the repo for IaC files (Bicep, Terraform, ARM templates, `pipelines/` YAML) and list every Azure resource type found (Function Apps, Storage Accounts, Service Bus, Key Vault, App Service Plans, etc.).

2. **Use the Azure MCP server** to query the deployed resources in the relevant subscription/resource group. If no MCP connection is available, derive estimates from the IaC definitions alone and note the limitation.

3. **Estimate costs per resource:**
   - For consumption/serverless resources (Function Apps, Logic Apps, Service Bus), ask the user for expected usage figures if not inferable from code (e.g. monthly executions, message volume, GB processed). Use Azure public pricing for the region identified in the IaC.
   - For provisioned resources (App Service Plans, Storage, SQL), read the SKU from the IaC and price accordingly.
   - Apply any reserved instance or dev/test discounts only if there is clear evidence they are in use.

4. **Produce a cost summary table:**

   | Resource | Type/SKU | Quantity | Est. Monthly Cost (GBP) | Notes |
   |----------|----------|----------|------------------------|-------|
   | ...      | ...      | ...      | ...                    | ...   |
   | **TOTAL** | | | **£X.XX** | |

5. **Highlight the top 3 cost drivers** and suggest any obvious optimisation opportunities (right-sizing, reserved instances, lifecycle policies).

6. **Caveats** — state clearly that this is an estimate, exchange rates and pricing can change, and a formal quote should be obtained from the Azure Pricing Calculator or Azure Cost Management.
