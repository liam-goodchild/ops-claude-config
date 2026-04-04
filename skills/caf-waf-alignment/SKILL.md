---
name: caf-waf-alignment
description: Generate a CAF/WAF alignment report against the deployed Azure infrastructure, highlighting gaps and recommendations
---

You are producing a Microsoft Cloud Adoption Framework (CAF) and Well-Architected Framework (WAF) alignment report for the Azure infrastructure in this repository.

## Steps

1. **Identify infrastructure scope** — scan the repo for IaC files (Bicep, Terraform, ARM templates), `pipelines/` YAML, and `README.md` files. Note every Azure resource type, networking topology, identity model, and deployment pattern.

2. **Use the Azure MCP server** to inspect the live deployed resources (resource groups, diagnostic settings, RBAC assignments, network configs, etc.) if available. If not, work from IaC definitions alone and note the limitation.

3. **Assess against WAF pillars** — for each pillar produce a RAG status (Green / Amber / Red) and list findings:

   ### Reliability
   - Availability zones usage, redundancy, retry/circuit-breaker patterns, health checks, DR strategy.

   ### Security
   - Managed Identity usage, Key Vault for secrets, network isolation (VNet, Private Endpoints), RBAC least-privilege, diagnostic logging, secret scanning in pipelines.

   ### Cost Optimisation
   - Consumption vs provisioned tiers, right-sizing, idle resources, cost alerts, tagging for cost allocation.

   ### Operational Excellence
   - IaC coverage, CI/CD maturity, environment promotion gates, monitoring/alerting, runbooks.

   ### Performance Efficiency
   - Scaling configuration, caching, async patterns, queue-based load levelling.

4. **Assess against CAF landing zone principles** — governance, management groups, policy assignments, tagging strategy, naming conventions.

5. **Produce the report** in this structure:

   ```
   ## Executive Summary
   Overall RAG: <colour>

   ## WAF Pillar Findings
   ### Reliability — <RAG>
   #### Strengths
   #### Gaps & Recommendations

   ### Security — <RAG>
   ...

   ## CAF Alignment
   ### Strengths
   ### Gaps & Recommendations

   ## Prioritised Action Plan
   | Priority | Finding | Effort | Impact |
   |----------|---------|--------|--------|
   ```

6. Link each recommendation to the relevant Microsoft docs URL where possible.
