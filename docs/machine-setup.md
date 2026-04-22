# Machine Setup

## Overview

Run `scripts/setup.ps1` once on each new Windows machine to create all
junctions and symlinks. On Linux/macOS, use the manual commands in the
per-tool docs.

## Prerequisites

- Windows: Administrator shell **or** Developer Mode enabled (Settings →
  For Developers → Developer Mode)
- Git for Windows installed at `C:\Program Files\Git\`
- VS Code installed (so `%APPDATA%\Code\User\` exists)
- Codex CLI installed (creates `~/.codex/` on first run — run it once first)

## Quick Start (Windows)

```powershell
# 1. Clone the repo
git clone https://github.com/liam-goodchild/ops-developer-config.git "C:\Local Files\Repositories\Sky Haven\ops-developer-config"

# 2. Run setup script (as Administrator)
cd "C:\Local Files\Repositories\Sky Haven\ops-developer-config"
.\scripts\setup.ps1

# 3. Add the git include manually (see docs/git-setup.md)
```

The script is idempotent — it skips links that already exist, so it's safe to
re-run after pulling updates.

## What the Script Creates

| Link type | From (tool location)                       | To (repo)                   |
| --------- | ------------------------------------------ | --------------------------- |
| Junction  | `~\.claude\skills`                         | `skills\`                   |
| Junction  | `~\.agents\skills`                         | `skills\`                   |
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

Because the tool config locations point into the repo via junctions/symlinks,
changes are live immediately after `git pull` — no re-running the setup script
needed.

## Per-Tool Docs

- [Claude setup](claude-home-setup.md)
- [Codex setup](codex-setup.md)
- [VS Code setup](vscode-setup.md)
- [Git setup](git-setup.md)
