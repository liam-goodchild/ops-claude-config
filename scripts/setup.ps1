<#
.SYNOPSIS
    Wires up all tool config symlinks/junctions from ops-developer-config.

.DESCRIPTION
    Creates junctions (directories) and symlinks (files) from each tool's
    expected config location into this repository. Run once on each new machine.
    Requires Developer Mode enabled (Settings → For Developers → Developer Mode)
    or an Administrator shell.

.PARAMETER Repo
    Absolute path to the ops-developer-config repository root.
    Defaults to the parent directory of this script.

.EXAMPLE
    .\setup.ps1
    .\setup.ps1 -Repo "C:\Local Files\Repositories\ops-developer-config"
#>

param (
    [string]$Repo = (Resolve-Path "$PSScriptRoot\..").Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Helpers ────────────────────────────────────────────────────────────────────

function New-Junction {
    param([string]$Link, [string]$Target)
    if (Test-Path $Link) {
        Write-Host "  [skip] $Link already exists" -ForegroundColor DarkGray
        return
    }
    New-Item -ItemType Directory -Path (Split-Path $Link) -Force | Out-Null
    cmd /c mklink /J `"$Link`" `"$Target`" | Out-Null
    Write-Host "  [junction] $Link -> $Target" -ForegroundColor Green
}

function New-Symlink {
    param([string]$Link, [string]$Target)
    if (Test-Path $Link) {
        Write-Host "  [skip] $Link already exists" -ForegroundColor DarkGray
        return
    }
    New-Item -ItemType Directory -Path (Split-Path $Link) -Force | Out-Null
    cmd /c mklink `"$Link`" `"$Target`" | Out-Null
    Write-Host "  [symlink] $Link -> $Target" -ForegroundColor Green
}

# ── Skills (shared: Claude + Codex) ────────────────────────────────────────────

Write-Host "`nSkills" -ForegroundColor Cyan
New-Junction "$env:USERPROFILE\.claude\skills" "$Repo\skills"
New-Junction "$env:USERPROFILE\.agents\skills"  "$Repo\skills"

# ── Claude ─────────────────────────────────────────────────────────────────────

Write-Host "`nClaude" -ForegroundColor Cyan
$claude = "$env:USERPROFILE\.claude"
New-Junction  "$claude\docs"   "$Repo\docs"
New-Symlink   "$claude\CLAUDE.md"     "$Repo\CLAUDE.md"
New-Symlink   "$claude\settings.json" "$Repo\claude\settings.json"

# ── Codex ──────────────────────────────────────────────────────────────────────

Write-Host "`nCodex" -ForegroundColor Cyan
$codex = "$env:USERPROFILE\.codex"
New-Symlink "$codex\instructions.md" "$Repo\codex\instructions.md"
New-Symlink "$codex\config.toml"     "$Repo\codex\config.toml"

# ── VS Code ────────────────────────────────────────────────────────────────────

Write-Host "`nVS Code" -ForegroundColor Cyan
$vscodeUser = "$env:APPDATA\Code\User"
New-Symlink "$vscodeUser\settings.json"    "$Repo\vscode\settings.json"
New-Symlink "$vscodeUser\keybindings.json" "$Repo\vscode\keybindings.json"

# ── Git ────────────────────────────────────────────────────────────────────────

Write-Host "`nGit" -ForegroundColor Cyan
$gitignorePath = "$env:USERPROFILE\.gitignore_global"
New-Symlink $gitignorePath "$Repo\git\gitignore_global"

# Wire the global gitignore if not already set
$currentExcludesFile = git config --global core.excludesfile 2>$null
if (-not $currentExcludesFile) {
    git config --global core.excludesfile $gitignorePath
    Write-Host "  [config] core.excludesfile = $gitignorePath" -ForegroundColor Green
} else {
    Write-Host "  [skip] core.excludesfile already set to $currentExcludesFile" -ForegroundColor DarkGray
}

# Wire global git hooks
$hooksPath = "$Repo\git\hooks"
$currentHooksPath = git config --global core.hooksPath 2>$null
if (-not $currentHooksPath) {
    git config --global core.hooksPath $hooksPath
    Write-Host "  [config] core.hooksPath = $hooksPath" -ForegroundColor Green
} else {
    Write-Host "  [skip] core.hooksPath already set to $currentHooksPath" -ForegroundColor DarkGray
}

# Remind about the shared git config include
$configShared = "$Repo\git\config.shared"
Write-Host @"

  To enable shared git aliases and settings, add this to ~/.gitconfig:

      [include]
          path = $configShared

"@ -ForegroundColor Yellow

# ── Done ───────────────────────────────────────────────────────────────────────

Write-Host "Done. All links created.`n" -ForegroundColor Green
