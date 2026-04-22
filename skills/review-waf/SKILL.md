---
name: review-waf
description: Assess Azure infrastructure against the 5 Well-Architected Framework pillars with RAG status and prioritised recommendations
---

You are producing a Microsoft Well-Architected Framework (WAF) assessment for the Azure infrastructure in this repository.

## Steps

1. **Identify infrastructure scope** — scan for IaC files (Terraform, Bicep, ARM), pipeline YAML, and any README files. Note every Azure resource type, networking topology, identity model, and deployment pattern.

2. **Use the Azure MCP server** to inspect live deployed resources (resource groups, diagnostic settings, RBAC assignments, network configs) if available. If not, work from IaC alone and note the limitation.

3. **Assess each WAF pillar** — produce a RAG status (Green / Amber / Red) and list specific findings:

   ### Reliability
   - Availability zones and redundancy configuration
   - Retry policies, circuit-breaker patterns in application code
   - Health check and readiness probe endpoints
   - Backup and disaster recovery strategy
   - SLA targets vs actual configuration

   ### Security
   - Managed Identity used in place of credentials
   - Key Vault for all secrets and certificates
   - Network isolation: VNet integration, Private Endpoints, NSG rules
   - RBAC least-privilege (no broad Contributor/Owner assignments)
   - Diagnostic logging and audit trails enabled on all resources
   - Secret scanning and IaC scanning in CI pipelines

   ### Cost Optimisation
   - Consumption vs provisioned tiers — right-sizing evidence
   - Idle or over-provisioned resources
   - Cost alerts and budgets configured
   - Tagging strategy for cost allocation per team/environment
   - Reserved instances or savings plans where appropriate

   ### Operational Excellence
   - IaC coverage — is all infrastructure defined as code?
   - CI/CD maturity: automated promotion gates, approval workflows
   - Environment parity between non-prod and prod
   - Monitoring and alerting coverage (Application Insights, Log Analytics)
   - Runbooks or operational playbooks for common failure scenarios

   ### Performance Efficiency
   - Auto-scaling configuration (scale-out rules, min/max instances)
   - Caching layers (CDN, Redis) where appropriate
   - Async patterns and queue-based load levelling
   - Database indexing and query performance considerations

4. **Produce the report:**

   ```
   ## WAF Assessment Summary
   Overall RAG: <colour>

   | Pillar | RAG | Critical Findings |
   |--------|-----|-------------------|

   ## Pillar Findings

   ### Reliability — <RAG>
   #### Strengths
   #### Gaps & Recommendations

   ### Security — <RAG>
   #### Strengths
   #### Gaps & Recommendations

   ### Cost Optimisation — <RAG>
   #### Strengths
   #### Gaps & Recommendations

   ### Operational Excellence — <RAG>
   #### Strengths
   #### Gaps & Recommendations

   ### Performance Efficiency — <RAG>
   #### Strengths
   #### Gaps & Recommendations

   ## Prioritised Action Plan
   | Priority | Pillar | Finding | Effort | Impact |
   |----------|--------|---------|--------|--------|
   ```

5. Link each recommendation to the relevant Microsoft docs URL where possible.
