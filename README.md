# ops-developer-config

Portable developer configuration repository for Claude Code, Codex CLI, VS Code, and Git.

This repo is the source of truth for shared skills and tool configuration. The setup script links each tool's expected config location back into this repo so a `git pull` updates the machine. Codex skills are exposed under `~/.codex/skills`; the legacy `~/.agents/skills` path is not used for Codex and is cleaned up when it is only the old junction to this repo.

On domain-joined machines where Group Policy blocks file symlinks, `scripts/setup.ps1` falls back to file copies for file targets. Re-run the setup script after each pull to refresh copied files. Directory junctions are still used for skills and docs.