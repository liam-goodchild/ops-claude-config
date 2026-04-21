#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Wires up all tool config symlinks/junctions from ops-claude-config.

.DESCRIPTION
    Creates junctions (directories) and symlinks (files) from each tool's
    expected config location into this repository. Run once on each new machine.
    Requires Administrator or Developer Mode on Windows.

.PARAMETER Repo
    Absolute path to the ops-claude-config repository root.
    Defaults to the parent directory of this script.

.EXAMPLE
    .\setup.ps1
    .\setup.ps1 -Repo "C:\Local Files\Repositories\ops-claude-config"
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

# ── Shared ─────────────────────────────────────────────────────────────────────

Write-Host "`nShared" -ForegroundColor Cyan
New-Junction "$env:USERPROFILE\.claude\skills" "$Repo\shared\skills"
New-Junction "$env:USERPROFILE\.codex\skills"  "$Repo\shared\skills"

# ── Claude ─────────────────────────────────────────────────────────────────────

Write-Host "`nClaude" -ForegroundColor Cyan
$claude = "$env:USERPROFILE\.claude"
New-Junction  "$claude\docs"   "$Repo\docs"
New-Junction  "$claude\hooks"  "$Repo\hooks"
New-Symlink   "$claude\CLAUDE.md"     "$Repo\CLAUDE.md"
New-Symlink   "$claude\settings.json" "$Repo\settings.json"

# ── Codex ──────────────────────────────────────────────────────────────────────

Write-Host "`nCodex" -ForegroundColor Cyan
$codex = "$env:USERPROFILE\.codex"
New-Symlink "$codex\instructions.md" "$Repo\codex\instructions.md"
New-Symlink "$codex\config.yaml"     "$Repo\codex\config.yaml"

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

# Remind about the shared git config include
$configShared = "$Repo\git\config.shared"
Write-Host @"

  To enable shared git aliases and settings, add this to ~/.gitconfig:

      [include]
          path = $configShared

"@ -ForegroundColor Yellow

# ── Done ───────────────────────────────────────────────────────────────────────

Write-Host "Done. All links created.`n" -ForegroundColor Green
