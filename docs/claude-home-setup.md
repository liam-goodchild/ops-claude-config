# Claude Home Directory Setup

## Overview

`~/.claude` is a real directory containing Claude runtime data plus tracked configuration linked from this repo. This lets `ops-developer-config` version-control settings, skills, hooks, and docs without committing session data, credentials, caches, or other local runtime files.

## Directory Structure

```text
~/.claude/
|-- docs/          -> Junction -> ops-developer-config/docs/
|-- skills/        -> Junction -> ops-developer-config/skills/
|-- CLAUDE.md      -> Symlink  -> ops-developer-config/CLAUDE.md
|-- settings.json  -> Symlink  -> ops-developer-config/claude/settings.json
|
|-- backups/           (runtime, local only)
|-- cache/             (runtime, local only)
|-- debug/             (runtime, local only)
|-- downloads/         (runtime, local only)
|-- file-history/      (runtime, local only)
|-- ide/               (runtime, local only)
|-- memory/            (runtime, local only)
|-- paste-cache/       (runtime, local only)
|-- plans/             (runtime, local only)
|-- plugins/           (runtime, local only)
|-- projects/          (runtime, local only)
|-- sessions/          (runtime, local only)
`-- telemetry/         (runtime, local only)
```

## What Is Tracked in Git

Only items inside `ops-developer-config/` are versioned:

| Item | Type | Purpose |
| ---- | ---- | ------- |
| `docs/` | Directory | Reference documentation |
| `skills/` | Directory | Shared skill source for Claude and Codex |
| `claude/` | Directory | Claude-specific config files |
| `CLAUDE.md` | File | Global Claude system instructions |
| `claude/settings.json` | File | Claude Code settings |
| `.gitignore` | File | Excludes all runtime data from git |
| `README.md` | File | Repo overview |

## Skill Linking Model

Claude uses a single whole-directory junction:

```text
~/.claude/skills -> ops-developer-config/skills
```

Codex uses the same repo skill source, but links each top-level skill individually under `~/.codex/skills/<name>` to preserve Codex system skills in `~/.codex/skills/.system`.

`~/.agents/skills` is legacy compatibility only and should not be used for Codex.

## Manual Link Creation

To recreate Claude links manually on Windows:

```powershell
$repo = "C:\Local Files\Repositories\Sky Haven\ops-developer-config"
$claude = "$env:USERPROFILE\.claude"

New-Item -ItemType Directory -Path $claude -Force

cmd /c mklink /J "$claude\docs"   "$repo\docs"
cmd /c mklink /J "$claude\skills" "$repo\skills"

cmd /c mklink "$claude\CLAUDE.md"     "$repo\CLAUDE.md"
cmd /c mklink "$claude\settings.json" "$repo\claude\settings.json"
```

Prefer running `scripts/setup.ps1`; it handles Codex, VS Code, and Git as well.

## Migration History

| Date | Action |
| ---- | ------ |
| 2026-04-19 | `~/.claude` was a junction pointing directly to `ops-developer-config` |
| 2026-04-19 | Junction removed; real `~/.claude` created |
| 2026-04-19 | Runtime dirs/files moved from repo to `~/.claude` |
| 2026-04-19 | Junctions created for `docs/`, `hooks/`, and `skills/` |
| 2026-04-19 | Symlinks created for `CLAUDE.md` and `settings.json` |
| 2026-04-21 | Shared skills moved into repo `skills/`; legacy `~/.agents/skills` was used for Codex temporarily |
| 2026-04-23 | Codex standardized on `~/.codex/skills/<name>` per-skill junctions; legacy `~/.agents/skills` cleanup added |

## Backup

If present, old machine-specific backups are local-only and should not be committed.