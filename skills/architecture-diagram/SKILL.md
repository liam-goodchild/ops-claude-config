---
name: architecture-diagram
description: Generate Mermaid architecture diagrams from IaC files and code structure in this repository
---

You are generating architecture diagrams for this repository using Mermaid syntax.

## Steps

1. **Scan the repo** for IaC files (Bicep, Terraform, ARM), application code entry points, Dockerfiles, and pipeline definitions. Identify all Azure resources, their relationships, and data flows.

2. **Produce diagrams** as fenced Mermaid code blocks. Generate whichever of these are relevant:

   - **Infrastructure diagram** — Azure resources and their connections (VNets, subnets, private endpoints, service bus topics/queues, storage, Key Vault references). Use `graph LR` or `graph TD`.
   - **Data flow diagram** — how data moves through the system (HTTP triggers → Functions → queues → downstream services). Use `flowchart`.
   - **CI/CD pipeline diagram** — stages, gates, and deployment targets. Use `flowchart LR`.

3. **Keep diagrams readable** — limit to ~15-20 nodes per diagram. If the system is larger, split into subsystem diagrams. Use subgraphs to group related resources (e.g. by resource group or logical tier).

4. **Label edges** with the relationship type (e.g. "reads from", "publishes to", "triggers", "authenticates via").

5. Ask the user if they want the diagrams written to a file (e.g. `docs/architecture.md`) or just output to the conversation.
