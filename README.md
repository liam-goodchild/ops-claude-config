# ops-claude-config

## Purpose

This repository contains the system-level configuration for Claude Code, including skills and settings files for the `.claude` directory.
The goal is to provide a consistent, version-controlled Claude Code experience across all devices.

This repository:

- Centralises Claude Code settings and permissions in a single source of truth
- Provides reusable skills that extend Claude Code with custom slash commands
- Enables fast onboarding of Claude Code on new devices by cloning this repository

---

## Repository Structure

```
.claude/
├── settings.json          # Global Claude Code permissions and configuration
├── .gitignore             # Tracks only skills/ and settings.json
└── skills/                # Custom slash command skills
    ├── architecture-diagram/
    ├── branch-cleanup/
    ├── caf-waf-alignment/
    ├── commit-and-push/
    ├── cost-estimate/
    ├── devops-engineer/
    ├── environment-diff/
    ├── learn/
    ├── pr-review/
    ├── pull-request-ado/
    ├── pull-request-gh/
    ├── repo-config-ado/
    ├── repo-config-gh/
    └── security-engineer/
```

---

## Configuration

### settings.json

Controls which Claude Code tools are permitted globally. The current configuration allows standard tools including `Bash`, `Read`, `Write`, `Edit`, `Glob`, `Grep`, `Agent`, `WebFetch`, `WebSearch`, and task management tools.

### .gitignore

Only `skills/` and `settings.json` are tracked. All other `.claude` directory contents (sessions, history, cache, credentials, etc.) are excluded.

---

## Skills

Each subdirectory under `skills/` contains a `SKILL.md` file that defines a custom Claude Code slash command.

| Skill | Description |
| ----- | ----------- |
| `architecture-diagram` | Generate Mermaid architecture diagrams from IaC and code structure |
| `branch-cleanup` | Clean up stale local and remote branches |
| `caf-waf-alignment` | Generate CAF/WAF alignment report against deployed Azure infrastructure |
| `commit-and-push` | Commit staged changes and push to remote |
| `cost-estimate` | Generate Azure cost estimates for deployed infrastructure |
| `devops-engineer` | Review IaC and CI/CD pipelines from a senior DevOps perspective |
| `environment-diff` | Compare IaC parameters across environments and flag discrepancies |
| `learn` | Quiz the user on recent code changes to reinforce understanding |
| `pr-review` | Review an open pull request for quality, security, and IaC best practices |
| `pull-request-ado` | Create a pull request in Azure DevOps |
| `pull-request-gh` | Create a pull request in GitHub |
| `repo-config-ado` | Configure an Azure DevOps repository with standard settings |
| `repo-config-gh` | Configure a GitHub repository with standard settings |
| `security-engineer` | Review code from a security perspective and implement security tests |

---

## Usage

### New Device Setup

Clone this repository into the `.claude` directory on the new device:

```bash
git clone https://github.com/liam-goodchild/ops-claude-config.git ~/.claude
```

Claude Code will automatically pick up `settings.json` and the `skills/` directory on next launch.

### Keeping Up to Date

Pull the latest changes from any device:

```bash
cd ~/.claude && git pull
```

---

## Summary

This repository is the single source of truth for Claude Code configuration. Clone it to `~/.claude` on any device to immediately have consistent settings and all custom skills available.
