# Claude Home Directory Setup

## Overview

`~/.claude` is a real directory containing both runtime data (local only) and
tracked configuration (symlinked/junctioned from this repo). This lets
`ops-developer-config` version-control settings, skills, hooks, and docs without
polluting git with session data.

## Directory Structure

```
~/.claude/
├── docs/          → Junction  → ops-developer-config/docs/
├── skills/        → Junction  → ops-developer-config/skills/
├── CLAUDE.md      → Symlink   → ops-developer-config/CLAUDE.md
├── settings.json  → Symlink   → ops-developer-config/claude/settings.json
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

Only items inside `ops-developer-config/` are versioned:

| Item              | Type           | Purpose                              |
| ----------------- | -------------- | ------------------------------------ |
| `docs/`           | Directory      | Reference documentation (this file) |
| `skills/`         | Directory      | Shared slash-command skills (Claude + Codex) |
| `claude/`         | Directory      | Claude-specific config files         |
| `CLAUDE.md`       | File           | Global Claude system instructions   |
| `claude/settings.json` | File      | Claude Code settings                 |
| `.gitignore`      | File           | Excludes all runtime data from git   |
| `README.md`       | File           | Repo overview                        |

## How Junctions and Symlinks Work

- **Junctions** (directories): Created with `mklink /J`. Claude Code resolves
  them transparently — reads and writes go to the repo copy.
- **Symlinks** (files): Created with `mklink`. Require Developer Mode or admin
  privileges on Windows.

To recreate the links on a new machine, run from an elevated or Developer Mode
shell:

```powershell
$repo  = "C:\Local Files\Repositories\Sky Haven\ops-developer-config"
$claude = "$env:USERPROFILE\.claude"

# Junctions for directories
cmd /c mklink /J "$claude\docs"   "$repo\docs"
cmd /c mklink /J "$claude\skills" "$repo\skills"

# Symlinks for files
cmd /c mklink "$claude\CLAUDE.md"     "$repo\CLAUDE.md"
cmd /c mklink "$claude\settings.json" "$repo\claude\settings.json"
```

## Migration History

| Date       | Action                                                                 |
| ---------- | ---------------------------------------------------------------------- |
| 2026-04-19 | `~/.claude` was a junction pointing directly to `ops-developer-config`    |
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
