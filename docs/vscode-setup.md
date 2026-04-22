# VS Code Setup

## Overview

VS Code's `User/` directory is owned by the application and contains extension
data, compiled snippets, and runtime state. Only the user-editable files are
symlinked from this repo.

## Files Tracked

| Repo path               | Symlink target                          | Purpose                   |
| ----------------------- | --------------------------------------- | ------------------------- |
| `vscode/settings.json`  | `%APPDATA%\Code\User\settings.json`     | Editor and extension settings |
| `vscode/keybindings.json` | `%APPDATA%\Code\User\keybindings.json` | Custom keyboard shortcuts |

## Setup

Run `scripts/setup.ps1` (see [machine-setup.md](machine-setup.md)), or manually:

```powershell
$repo      = "C:\Local Files\Repositories\Sky Haven\ops-developer-config"
$vscodeUser = "$env:APPDATA\Code\User"

cmd /c mklink "$vscodeUser\settings.json"    "$repo\vscode\settings.json"
cmd /c mklink "$vscodeUser\keybindings.json" "$repo\vscode\keybindings.json"
```

> **Note:** VS Code must be closed when creating these symlinks, otherwise it
> may overwrite the target with its in-memory state on exit.

## Machine-Specific Settings

`vscode/settings.json` contains some Windows-specific paths (terminal profiles,
Git Bash path). On Linux/macOS, override these in VS Code's user settings after
symlinking — VS Code merges settings from multiple sources, so machine-local
overrides can go in a `settings.local.json` shim if needed.

For terminal profiles on Linux, the relevant block is:

```json
"terminal.integrated.defaultProfile.linux": "bash",
"terminal.integrated.profiles.linux": {
    "Claude (bash)": {
        "path": "/bin/bash",
        "args": ["-c", "claude; exec bash"],
        "icon": "sparkle"
    }
}
```

## Claude Terminal Profile

The shared `settings.json` includes a **Claude (Git Bash)** terminal profile
that launches `claude` on open and drops back to bash on exit. This is
available in the VS Code terminal dropdown.
