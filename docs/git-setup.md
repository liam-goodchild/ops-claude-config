# Git Setup

## Overview

`~/.gitconfig` is intentionally NOT tracked in this repo — it contains
per-machine identity (`[user]`), credentials, and local paths. Instead:

- **Shared settings** (aliases, core options, push/pull behaviour) live in
  `git/config.shared` and are included via Git's `[include]` directive.
- **Global gitignore** (`git/gitignore_global`) is symlinked and wired via
  `core.excludesfile`.

## Files Tracked

| Repo path              | Target / mechanism                     | Purpose                        |
| ---------------------- | -------------------------------------- | ------------------------------ |
| `git/config.shared`    | Included by `~/.gitconfig` via `[include]` | Aliases, core, push, merge settings |
| `git/gitignore_global` | Symlinked to `~/.gitignore_global`     | Global gitignore patterns      |
| `git/hooks/`           | `core.hooksPath` points here           | Global git hooks (pre-commit, etc.) |

## Setup

Run `scripts/setup.ps1` (see [machine-setup.md](machine-setup.md)), or manually:

```powershell
$repo = "C:\Local Files\Repositories\Sky Haven\ops-developer-config"

# Symlink global gitignore
cmd /c mklink "$env:USERPROFILE\.gitignore_global" "$repo\git\gitignore_global"
git config --global core.excludesfile "$env:USERPROFILE\.gitignore_global"

# Wire global git hooks
git config --global core.hooksPath "$repo\git\hooks"

# Add the shared config include to ~/.gitconfig
Add-Content "$env:USERPROFILE\.gitconfig" "`n[include]`n    path = $repo/git/config.shared"
```

Or add the `[include]` block manually to `~/.gitconfig`:

```ini
[include]
    path = C:/Local Files/Repositories/Sky Haven/ops-developer-config/git/config.shared
```

## What Goes in `~/.gitconfig` (Not Tracked)

```ini
[user]
    name  = Liam Goodchild
    email = your@email.com

[credential]
    helper = manager

[include]
    path = C:/Local Files/Repositories/Sky Haven/ops-developer-config/git/config.shared
```

## Aliases Reference

| Alias  | Expands to                                        |
| ------ | ------------------------------------------------- |
| `st`   | `status -sb`                                      |
| `co`   | `checkout`                                        |
| `br`   | `branch`                                          |
| `lg`   | `log --oneline --graph --decorate --all`           |
| `lp`   | Pretty one-line log with author and relative date |
| `undo` | `reset --soft HEAD~1`                             |
| `wip`  | Stage all and commit as `wip [skip ci]`           |
| `sync` | `fetch --all --prune && pull`                     |
| `root` | Print repo root path                              |
