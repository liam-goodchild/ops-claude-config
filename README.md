# ops-claude-config

Portable Claude Code configuration — clone to `~/.claude` on any device for consistent settings and custom skills.

## Setup

Clone to the `.claude` directory:

```bash
git clone https://github.com/liam-goodchild/ops-claude-config.git ~/.claude
```

Pull updates on existing devices:

```bash
cd ~/.claude && git pull
```

## What's Tracked

Only two things are version-controlled (everything else in `~/.claude` is gitignored):

| Path | Purpose |
|------|---------|
| `settings.json` | Global tool permissions and configuration |
| `skills/` | Custom slash command definitions |

## Skills

Each skill lives in `skills/<name>/SKILL.md` and is invoked via `/<name>` in Claude Code.

### Review

| Skill | Description |
|-------|-------------|
| `review-terraform` | Terraform code and CI/CD pipeline (minimalist lens) |
| `review-gha-pipelines` | GitHub Actions workflow quality, security, reliability |
| `review-ado-pipelines` | Azure DevOps YAML pipeline quality, security, reliability |
| `review-pull-request` | Pull request review (GitHub and ADO) |
| `review-security` | App security review and CI security gates |
| `review-waf` | Azure Well-Architected Framework pillar assessment |
| `review-caf` | Cloud Adoption Framework landing zone alignment |

### Compare / Generate

| Skill | Description |
|-------|-------------|
| `compare-environments` | Diff IaC parameters across dev/uat/prod |
| `generate-diagram` | Mermaid architecture diagrams from IaC and code |
| `generate-cost-estimate` | Azure cost estimate from deployed infrastructure |

### Create

| Skill | Description |
|-------|-------------|
| `create-pr-ado` | Create an Azure DevOps pull request |
| `create-pr-gh` | Create a GitHub pull request |

### Config

| Skill | Description |
|-------|-------------|
| `config-repo-ado` | Standard Azure DevOps repository configuration |
| `config-repo-gh` | Standard GitHub repository configuration |

### Git

| Skill | Description |
|-------|-------------|
| `git-cleanup` | Delete merged branches, prune remotes |
| `git-commit-push` | Stage, commit, and push with safety checks |

### Other

| Skill | Description |
|-------|-------------|
| `learn` | Quiz on recent code changes to reinforce understanding |

## Adding a Skill

Create `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`) and a prompt body, then commit and push. The skill is immediately available after `git pull`.
