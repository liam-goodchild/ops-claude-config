# Claude Home Directory Setup

## Overview

`~/.claude` is a real directory containing both runtime data (local only) and
tracked configuration (symlinked/junctioned from this repo). This lets
`ops-claude-config` version-control settings, skills, hooks, and docs without
polluting git with session data.

## Directory Structure

```
~/.claude/
├── docs/          → Junction  → ops-claude-config/docs/
├── hooks/         → Junction  → ops-claude-config/hooks/
├── skills/        → Junction  → ops-claude-config/shared/skills/
├── CLAUDE.md      → Symlink   → ops-claude-config/CLAUDE.md
├── settings.json  → Symlink   → ops-claude-config/settings.json
│
├── backups/           (runtime, local only)
├── cache/             (runtime, local only)
├── debug/             (runtime, local only)
├── downloads/         (runtime, local only)
├── file-history/      (runtime, local only)
├── ide/               (runtime, local only)
├── memory/            (runtime, local only)
├── paste-cache/       (runtime, local only)
├── plans/             (runtime, local only)
├── plugins/           (runtime, local only)
├── projects/          (runtime, local only)
├── session-env/       (runtime, local only)
├── sessions/          (runtime, local only)
├── shell-snapshots/   (runtime, local only)
├── statsig/           (runtime, local only)
├── tasks/             (runtime, local only)
├── telemetry/         (runtime, local only)
├── todos/             (runtime, local only)
├── .caveman-active    (runtime, local only)
├── .credentials.json  (runtime, local only)
├── history.jsonl      (runtime, local only)
├── keybindings.json   (runtime, local only)
├── mcp-needs-auth-cache.json  (runtime, local only)
├── settings.local.json        (runtime, local only)
└── stats-cache.json           (runtime, local only)
```

## What Is Tracked in Git

Only items inside `ops-claude-config/` are versioned:

| Item            | Type           | Purpose                              |
| --------------- | -------------- | ------------------------------------ |
| `docs/`         | Directory      | Reference documentation (this file) |
| `hooks/`        | Directory      | Claude Code event hooks              |
| `shared/skills/` | Directory     | Shared slash-command skills (Claude + Codex) |
| `CLAUDE.md`     | File           | Global Claude system instructions   |
| `settings.json` | File           | Claude Code settings                 |
| `.gitignore`    | File           | Excludes all runtime data from git   |
| `README.md`     | File           | Repo overview                        |

## How Junctions and Symlinks Work

- **Junctions** (directories): Created with `mklink /J`. Claude Code resolves
  them transparently — reads and writes go to the repo copy.
- **Symlinks** (files): Created with `mklink`. Require Developer Mode or admin
  privileges on Windows.

To recreate the links on a new machine, run from an elevated or Developer Mode
shell:

```powershell
$repo  = "C:\Local Files\Repositories\Sky Haven\ops-claude-config"
$claude = "$env:USERPROFILE\.claude"

# Junctions for directories
cmd /c mklink /J "$claude\docs"   "$repo\docs"
cmd /c mklink /J "$claude\hooks"  "$repo\hooks"
cmd /c mklink /J "$claude\skills" "$repo\shared\skills"

# Symlinks for files
cmd /c mklink "$claude\CLAUDE.md"     "$repo\CLAUDE.md"
cmd /c mklink "$claude\settings.json" "$repo\settings.json"
```

## Migration History

| Date       | Action                                                                 |
| ---------- | ---------------------------------------------------------------------- |
| 2026-04-19 | `~/.claude` was a junction pointing directly to `ops-claude-config`    |
| 2026-04-19 | Junction removed; real `~/.claude` created                             |
| 2026-04-19 | Runtime dirs/files moved from repo → `~/.claude`                      |
| 2026-04-19 | Junctions created for `docs/`, `hooks/`, `skills/`                    |
| 2026-04-21 | `skills/` moved to `shared/skills/`; Codex skills junction added       |
| 2026-04-19 | Symlinks created for `CLAUDE.md`, `settings.json`                     |
| 2026-04-19 | Remaining runtime data merged from `~/.claude-backup` → `~/.claude`  |

## Backup

A snapshot of the original junction-based setup is preserved at:

```
C:\Users\LiamG\.claude-backup
```

This directory retains the `.git` history of the old layout and can be
referenced if any files need to be recovered.
