# Codex CLI Setup

## Overview

`~/.codex/` is created by Codex on first run and contains runtime data plus user configuration. This repo tracks only the Codex config files and shared skill source.

Custom/team skills for Codex should be available under:

```text
~/.codex/skills/<skill-name>/SKILL.md
```

This repo remains the source of truth at `ops-developer-config/skills`. The setup script creates one junction per top-level skill under `~/.codex/skills` so Codex-managed system skills under `~/.codex/skills/.system` are preserved.

`~/.agents/skills` is legacy compatibility only. Codex should not rely on it.

## Files Tracked

| Repo path               | Tool location                         | Purpose |
| ----------------------- | ------------------------------------- | ------- |
| `codex/instructions.md` | `~/.codex/instructions.md`            | Codex custom instructions |
| `codex/config.toml`     | `~/.codex/config.toml`                | Model, reasoning effort, permissions, and options |
| `skills/<name>/`        | `~/.codex/skills/<name>/` (junction)  | Shared custom/team skills |

## Setup

Run `scripts/setup.ps1` from this repo. Manual equivalent:

```powershell
$repo = "C:\Local Files\Repositories\Sky Haven\ops-developer-config"
$codex = "$env:USERPROFILE\.codex"

New-Item -ItemType Directory -Path $codex -Force
New-Item -ItemType Directory -Path "$codex\skills" -Force

cmd /c mklink "$codex\instructions.md" "$repo\codex\instructions.md"
cmd /c mklink "$codex\config.toml"     "$repo\codex\config.toml"

Get-ChildItem -LiteralPath "$repo\skills" -Directory | ForEach-Object {
    cmd /c mklink /J "$codex\skills\$($_.Name)" $_.FullName
}
```

## Existing Machines With `~/.agents/skills`

Older setup versions created:

```text
~/.agents/skills -> ops-developer-config/skills
```

Run the current `scripts/setup.ps1` to remove that legacy junction when it points at this repo. The script leaves `~/.agents/skills` alone if it is a real directory or points somewhere else.

## Adding or Updating Skills

- Edit existing skills in `skills/<name>/SKILL.md`; changes are live through the junction after `git pull`.
- When adding a new top-level skill folder, re-run `scripts/setup.ps1` so the new `~/.codex/skills/<name>` junction is created.

## Important Paths

| Path | Meaning |
| ---- | ------- |
| `~/.codex/skills/.system` | Codex/system-installed skills; do not replace with a repo junction |
| `~/.codex/skills/<name>` | Repo-backed custom/team skill junctions |
| `~/.agents/skills` | Legacy path; not used for Codex in this repo |