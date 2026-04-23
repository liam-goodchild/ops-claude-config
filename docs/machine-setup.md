# Machine Setup

## Overview

Run `scripts/setup.ps1` once on each new Windows machine to create all junctions and symlinks. On Linux/macOS, use the manual commands in the per-tool docs.

## Prerequisites

- Windows: Administrator shell **or** Developer Mode enabled (Settings -> For Developers -> Developer Mode)
- Git for Windows installed at `C:\Program Files\Git\`
- VS Code installed so `%APPDATA%\Code\User\` exists
- Codex CLI installed; run it once first so `~/.codex/` exists

## Quick Start (Windows)

```powershell
# 1. Clone the repo
git clone https://github.com/liam-goodchild/ops-developer-config.git "C:\Local Files\Repositories\Sky Haven\ops-developer-config"

# 2. Run setup script
cd "C:\Local Files\Repositories\Sky Haven\ops-developer-config"
.\scripts\setup.ps1

# 3. Add the git include manually; see docs/git-setup.md
```

The script is idempotent. It skips links that already exist and is safe to re-run after pulling updates.

## What the Script Creates

| Link type | From (tool location)                       | To (repo)                   |
| --------- | ------------------------------------------ | --------------------------- |
| Junction  | `~\.claude\skills`                         | `skills\`                   |
| Junction  | `~\.codex\skills\<skill-name>`             | `skills\<skill-name>`       |
| Cleanup   | `~\.agents\skills`                         | Removed only when it is the legacy junction to `skills\` |
| Junction  | `~\.claude\docs`                           | `docs\`                     |
| Symlink   | `~\.claude\CLAUDE.md`                      | `CLAUDE.md`                 |
| Symlink   | `~\.claude\settings.json`                  | `claude\settings.json`      |
| Symlink   | `~\.codex\instructions.md`                 | `codex\instructions.md`     |
| Symlink   | `~\.codex\config.toml`                     | `codex\config.toml`         |
| Symlink   | `%APPDATA%\Code\User\settings.json`        | `vscode\settings.json`      |
| Symlink   | `%APPDATA%\Code\User\keybindings.json`     | `vscode\keybindings.json`   |
| Symlink   | `~\.gitignore_global`                      | `git\gitignore_global`      |
| Config    | `git config --global core.hooksPath`       | `git\hooks\`                |

## Pulling Updates on an Existing Machine

```powershell
cd "C:\Local Files\Repositories\Sky Haven\ops-developer-config"
git pull
```

Most changes are live immediately because the tool locations point into the repo through junctions or symlinks.

Re-run setup after pulling when either condition applies:

- Setup used file-copy fallback because symlinks were unavailable.
- A new top-level skill directory was added under `skills/`; Codex needs a new per-skill junction under `~/.codex/skills`.

```powershell
.\scripts\setup.ps1
```

## Per-Tool Docs

- [Claude setup](claude-home-setup.md)
- [Codex setup](codex-setup.md)
- [VS Code setup](vscode-setup.md)
- [Git setup](git-setup.md)