# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a portable developer configuration repository. Junctions and symlinks
connect each tool's expected config location into this repo, so a single
`git pull` updates all tools on a machine simultaneously.

Tracked in version control (enforced by `.gitignore`):

| Path | Tool | Purpose |
|------|------|---------|
| `skills/` | Claude Code + Codex | Shared slash command definitions |
| `claude/settings.json` | Claude Code | Global tool permissions and model config |
| `CLAUDE.md` | Claude Code | Global Claude system instructions |
| `git/hooks/` | Git | Global git hooks (pre-commit, etc.) |
| `codex/instructions.md` | Codex CLI | System prompt / custom instructions |
| `codex/config.toml` | Codex CLI | Model, reasoning effort, options |
| `vscode/settings.json` | VS Code | Editor and extension settings |
| `vscode/keybindings.json` | VS Code | Custom keyboard shortcuts |
| `git/config.shared` | Git | Shared aliases and core settings (via `[include]`) |
| `git/gitignore_global` | Git | Global gitignore patterns |
| `scripts/setup.ps1` | All | One-shot link creation for a new Windows machine |
| `docs/` | — | Per-tool setup documentation |

Everything else in each tool's config directory (sessions, history, cache,
credentials, etc.) is excluded.

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

### Setting up a new device

Clone the repo and run the setup script (Windows, Administrator shell):

```powershell
git clone https://github.com/liam-goodchild/ops-developer-config.git "C:\Local Files\Repositories\Sky Haven\ops-developer-config"
cd "C:\Local Files\Repositories\Sky Haven\ops-developer-config"
.\scripts\setup.ps1
```

See `docs/machine-setup.md` for full prerequisites and the manual equivalent
on Linux/macOS.

### Pulling updates on an existing device

```powershell
cd "C:\Local Files\Repositories\Sky Haven\ops-developer-config"
git pull
```

Because all config locations point into the repo via junctions/symlinks, the
pull is immediately live — no re-running the setup script needed.

### gh CLI path (Windows)

The `gh` CLI is not on the bash `PATH` by default. Use the full path:

```bash
/c/Program Files/GitHub CLI/gh.exe
```

## claude/settings.json

Defines globally allowed tools. When adding new MCP tool permissions, add them to the `allow` array. The `deny` array is currently empty — prefer allowlist-only control.

Plugins (marketplace and official) are configured under `enabledPlugins` — these are not synced via git and must be installed per-device.

## git/hooks/

Global git hooks wired via `git config --global core.hooksPath`. Applied to every repo on the machine. Currently contains `pre-commit` for auto-formatting staged files.
