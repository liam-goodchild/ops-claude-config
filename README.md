# ops-developer-config

Shared developer configuration for Claude Code, Codex CLI, VS Code, Git, and reusable Codex/Claude skills. It keeps machine setup and day-to-day repository maintenance consistent by storing tool settings, hooks, skills, and helper scripts in one source-controlled place.

Skills are grouped by purpose under `skills/`. Any descendant folder that contains
`SKILL.md` is installed flat into both `~/.claude/skills` and `~/.codex/skills`
by `scripts/Install-DeveloperConfig.ps1`.
## Codex repository context

Use `scripts/Initialize-AgentsMd.ps1` to create or refresh `AGENTS.md` files across local repositories. By default it derives Codex context from each repo's existing `CLAUDE.md` and leaves existing `AGENTS.md` files untouched.

```powershell
.\scripts\Initialize-AgentsMd.ps1 -RepositoriesRoot "C:\Local Files\Repositories\Sky Haven"
```
