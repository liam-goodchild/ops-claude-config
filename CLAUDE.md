# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a portable Claude Code configuration repository. It is cloned to `~/.claude` on each device to provide consistent settings and custom skills across machines.

Only two things are tracked in version control (enforced by `.gitignore`):
- `settings.json` — global tool permissions
- `skills/` — custom slash command definitions

Everything else in `~/.claude` (sessions, history, cache, credentials, memory, etc.) is excluded.

## Skills

Each skill lives in `skills/<name>/SKILL.md` and is a markdown file with YAML frontmatter. The frontmatter fields are:

```yaml
---
name: skill-name
description: shown in the skill picker
disable-model-invocation: true   # optional — runs without a model call (pure bash)
---
```

The body is the prompt given to Claude when the skill is invoked via `/<name>`. Skills may reference CLI tools (`gh`, `az`, `git`) and are expected to be self-contained instructions.

### Available Skills

| Skill | Purpose |
|-------|---------|
| `architecture-diagram` | Mermaid diagrams from IaC/code |
| `branch-cleanup` | Delete merged branches, prune remotes |
| `caf-waf-alignment` | CAF/WAF gap report for Azure infrastructure |
| `commit-and-push` | Stage, commit, and push with safety checks |
| `cost-estimate` | Azure cost estimate from IaC |
| `devops-engineer` | IaC and CI/CD pipeline review |
| `environment-diff` | Compare IaC params across dev/uat/prod |
| `learn` | Quiz the user on recent changes |
| `pr-review` | Pull request review (GitHub and ADO) |
| `pull-request-ado` | Create an ADO pull request |
| `pull-request-gh` | Create a GitHub pull request |
| `repo-config-ado` | Standard ADO repo configuration |
| `repo-config-gh` | Standard GitHub repo configuration |
| `security-engineer` | Security review and CI test implementation |

## Common Tasks

### Adding a new skill

Create `skills/<name>/SKILL.md` with the frontmatter and prompt body, then commit and push. The skill is immediately available on any device after a `git pull`.

### Syncing to a new device

```bash
git clone https://github.com/liam-goodchild/ops-claude-config.git ~/.claude
```

### Pulling updates on an existing device

```bash
cd ~/.claude && git pull
```

### gh CLI path (Windows)

The `gh` CLI is not on the bash `PATH` by default. Use the full path:

```bash
/c/Program Files/GitHub CLI/gh.exe
```

## settings.json

Defines globally allowed tools. When adding new MCP tool permissions, add them to the `allow` array. The `deny` array is currently empty — prefer allowlist-only control.
