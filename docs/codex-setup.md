# Codex CLI Setup

## Overview

`~/.codex/` is created by Codex on first run and contains both runtime data
and config. This repo tracks only the config files; individual symlinks are
used rather than junctioning the whole directory.

## Files Tracked

| Repo path              | Symlink/junction target       | Purpose                        |
| ---------------------- | ----------------------------- | ------------------------------ |
| `codex/instructions.md` | `~/.codex/instructions.md`  | System prompt / custom instructions |
| `codex/config.toml`    | `~/.codex/config.toml`       | Model, reasoning effort, options |
| `skills/`              | `~/.agents/skills/` (junction) | Shared slash-command skills (Claude + Codex) |

## Setup

Run `scripts/setup.ps1` (see [machine-setup.md](machine-setup.md)), or manually:

```powershell
$repo  = "C:\Local Files\Repositories\Sky Haven\ops-developer-config"
$codex = "$env:USERPROFILE\.codex"

New-Item -ItemType Directory -Path $codex -Force
cmd /c mklink "$codex\instructions.md" "$repo\codex\instructions.md"
cmd /c mklink "$codex\config.toml"     "$repo\codex\config.toml"
cmd /c mklink /J "$env:USERPROFILE\.agents\skills" "$repo\skills"
```

## config.yaml Options

| Key        | Values                              | Description                    |
| ---------- | ----------------------------------- | ------------------------------ |
| `model`    | `o4-mini`, `o3`, `codex-mini`, etc. | Default model                  |
| `approval` | `suggest`, `auto-edit`, `full-auto` | How much Codex acts without confirmation |
| `notify`   | `true` / `false`                    | Desktop notifications on completion |
