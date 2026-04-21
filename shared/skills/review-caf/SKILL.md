---
name: review-caf
description: Assess Azure infrastructure against Cloud Adoption Framework landing zone principles with gap analysis and recommendations
---

You are producing a Microsoft Cloud Adoption Framework (CAF) landing zone alignment assessment for the Azure infrastructure in this repository.

## Steps

1. **Identify infrastructure scope** — scan for IaC files (Terraform, Bicep, ARM), pipeline YAML, and any README or architecture documentation. Note the subscription structure, management group hierarchy (if visible), and deployment patterns.

2. **Use the Azure MCP server** to inspect live deployed resources (management groups, policy assignments, RBAC, resource groups, naming, tags) if available. If not, work from IaC alone and note the limitation.

3. **Assess against CAF landing zone principles:**

   ### Governance
   - Are Management Groups used to organise subscriptions (platform vs workload)?
   - Are Azure Policy assignments in place for compliance enforcement (e.g. allowed regions, required tags, SKU restrictions)?
   - Is there a Deny policy for public IP creation or public blob access where not needed?
   - Is Azure Blueprints or Terraform used to enforce landing zone standards?

   ### Identity & Access
   - Is Microsoft Entra ID (Azure AD) the primary identity provider?
   - Are Privileged Identity Management (PIM) or just-in-time access controls in place?
   - Are service principals replaced with Managed Identities where possible?
   - Is break-glass account access documented and monitored?

   ### Networking
   - Is a hub-spoke or Virtual WAN topology in use?
   - Is there a dedicated connectivity subscription for shared networking resources?
   - Are on-premises connections (ExpressRoute, VPN) configured and documented?
   - Is DNS resolution centralised (Azure Private DNS Zones in a hub)?

   ### Management & Monitoring
   - Is there a dedicated management subscription or resource group for platform tooling?
   - Is a central Log Analytics workspace used for aggregated logging?
   - Are Azure Monitor baselines (activity log alerts, service health alerts) deployed?
   - Is Microsoft Defender for Cloud enabled and configured with a security benchmark?

   ### Naming & Tagging
   - Do resources follow the CAF recommended naming convention (`<type>-<workload>-<env>-<region>-<sequence>`)?
   - Are the minimum required tags applied consistently: `Environment`, `Owner`, `CostCentre`, `Application`?
   - Is tagging enforced via Policy (Deny or Append) or only advisory?

   ### Subscription Design
   - Is the subscription structure aligned to CAF (platform subs: identity, connectivity, management + workload subs)?
   - Are resource group boundaries aligned to lifecycle and RBAC boundaries, not just resource type?
   - Is there evidence of subscription vending or a self-service landing zone process?

4. **Produce the report:**

   ```
   ## CAF Alignment Summary
   Overall RAG: <colour>

   | Domain | RAG | Key Gap |
   |--------|-----|---------|

   ## Domain Findings

   ### Governance — <RAG>
   #### Strengths
   #### Gaps & Recommendations

   ### Identity & Access — <RAG>
   ...

   ### Networking — <RAG>
   ...

   ### Management & Monitoring — <RAG>
   ...

   ### Naming & Tagging — <RAG>
   ...

   ### Subscription Design — <RAG>
   ...

   ## Prioritised Action Plan
   | Priority | Domain | Finding | Effort | Impact |
   |----------|--------|---------|--------|--------|
   ```

5. Link each recommendation to the relevant Microsoft CAF docs URL where possible.
