# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a portable Claude Code configuration repository. It is cloned to `~/.claude` on each device to provide consistent settings and custom skills across machines.

Tracked in version control (enforced by `.gitignore`):
- `settings.json` — global tool permissions and model config
- `skills/` — custom slash command definitions
- `hooks/` — shell scripts wired to Claude Code hook events
- `docs/` — supporting documentation
- `README.md`, `CLAUDE.md`

Everything else in `~/.claude` (sessions, history, cache, credentials, memory, plugins, etc.) is excluded.

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

Naming schema: `{verb}-{subject}[-{qualifier}]`

**Review**

| Skill | Purpose |
|-------|---------|
| `review-terraform` | Terraform code and CI/CD pipeline (minimalist lens) |
| `review-gha-pipelines` | GitHub Actions workflow quality, security, reliability |
| `review-ado-pipelines` | Azure DevOps YAML pipeline quality, security, reliability |
| `review-pull-request` | Pull request review (GitHub and ADO) |
| `review-security` | App security review (OWASP, Azure) and CI security gates |
| `review-waf` | Azure Well-Architected Framework pillar assessment (RAG) |
| `review-caf` | Cloud Adoption Framework landing zone alignment |

**Format**

| Skill | Purpose |
|-------|---------|
| `format-terraform` | Terraform file structure, naming, tagging, pinning, and formatting standards |
| `format-ado-pipelines` | Azure DevOps pipeline file structure, layout, and formatting standards |
| `format-gha-pipelines` | GitHub Actions workflow file structure, layout, and formatting standards |

**Compare / Generate**

| Skill | Purpose |
|-------|---------|
| `compare-environments` | Diff IaC params across dev/uat/prod |
| `generate-diagram` | Mermaid architecture diagrams from IaC/code |
| `generate-cost-estimate` | Azure cost estimate from IaC |
| `generate-readme` | Brief project README from code and standards template |

**Create**

| Skill | Purpose |
|-------|---------|
| `create-pr-ado` | Create an Azure DevOps pull request |
| `create-pr-gh` | Create a GitHub pull request |

**Config**

| Skill | Purpose |
|-------|---------|
| `config-repo-ado` | Standard ADO repo configuration |
| `config-repo-gh` | Standard GitHub repo configuration |

**Git**

| Skill | Purpose |
|-------|---------|
| `git-cleanup` | Delete merged branches, prune remotes |
| `git-commit-push` | Stage, commit, and push with safety checks |

**Other**

| Skill | Purpose |
|-------|---------|
| `learn` | Quiz on recent code changes to reinforce understanding |

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

Plugins (marketplace and official) are configured under `enabledPlugins` — these are not synced via git and must be installed per-device.

## hooks/

Hook scripts fire on Claude Code events (e.g. pre-commit). They are tracked in version control and apply globally across all projects on the machine.
