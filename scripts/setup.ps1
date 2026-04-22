<#
.SYNOPSIS
    Wires up all tool config symlinks/junctions from ops-developer-config.

.DESCRIPTION
    Creates junctions (directories) and symlinks (files) from each tool's
    expected config location into this repository. Run once on each new machine.
    Requires Developer Mode enabled (Settings → For Developers → Developer Mode)
    or an Administrator shell for file symlinks.

    On machines where symlinks are blocked (e.g. by Group Policy), the script
    falls back to copying files and prints a reminder to re-run setup after
    each git pull.

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
$script:copyFallback = 0

# ── Preflight: can we create file symlinks? ─────────────────────────────────────

$canSymlink = $false
$testTarget = [System.IO.Path]::GetTempFileName()
$testLink   = $testTarget + ".lnk"
try {
    New-Item -ItemType SymbolicLink -Path $testLink -Value $testTarget -ErrorAction Stop | Out-Null
    Remove-Item $testLink -Force -ErrorAction SilentlyContinue
    $canSymlink = $true
} catch { }
finally {
    Remove-Item $testTarget -Force -ErrorAction SilentlyContinue
}

if (-not $canSymlink) {
    Write-Host @"

  WARNING: File symlinks are not available on this machine.
  Cause:   Group Policy likely overrides Developer Mode (common on domain-joined
           corporate machines). Admin shells are unaffected.

  Falling back to file copies for all symlink targets.
  After each 'git pull', re-run this script to refresh the copies.

  To get true symlinks: re-run from an Administrator shell.

"@ -ForegroundColor Yellow
}

# ── Helpers ────────────────────────────────────────────────────────────────────

function Remove-IfReal {
    param([string]$Path)
    $item = Get-Item $Path -ErrorAction SilentlyContinue
    if (-not $item) { return }
    $isReparse = $item.Attributes -band [System.IO.FileAttributes]::ReparsePoint
    if ($isReparse) { return }  # already a junction/symlink, let callers decide
    Write-Host "  [remove] $Path (real item - repo is source of truth)" -ForegroundColor Yellow
    Remove-Item $Path -Recurse -Force
}

function New-Junction {
    param([string]$Link, [string]$Target)
    $item = Get-Item $Link -ErrorAction SilentlyContinue
    if ($item -and ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
        Write-Host "  [skip] $Link already linked" -ForegroundColor DarkGray
        return
    }
    Remove-IfReal $Link
    New-Item -ItemType Directory -Path (Split-Path $Link) -Force | Out-Null
    cmd /c mklink /J `"$Link`" `"$Target`" | Out-Null
    Write-Host "  [junction] $Link -> $Target" -ForegroundColor Green
}

function New-Symlink {
    param([string]$Link, [string]$Target)
    $item = Get-Item $Link -ErrorAction SilentlyContinue
    if ($item -and ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
        Write-Host "  [skip] $Link already linked" -ForegroundColor DarkGray
        return
    }
    Remove-IfReal $Link
    New-Item -ItemType Directory -Path (Split-Path $Link) -Force | Out-Null

    if ($canSymlink) {
        try {
            New-Item -ItemType SymbolicLink -Path $Link -Value $Target -ErrorAction Stop | Out-Null
            Write-Host "  [symlink] $Link -> $Target" -ForegroundColor Green
            return
        } catch {
            Write-Host "  [warn] Symlink failed ($($_.Exception.Message)), falling back to copy" -ForegroundColor Yellow
        }
    }

    # Copy fallback
    Copy-Item -Path $Target -Destination $Link -Force
    Write-Host "  [copy]    $Link <- $Target" -ForegroundColor Cyan
    $script:copyFallback++
}

# ── Skills (shared: Claude + Codex) ────────────────────────────────────────────

Write-Host "`nSkills" -ForegroundColor Cyan
New-Junction "$env:USERPROFILE\.claude\skills" "$Repo\skills"
New-Junction "$env:USERPROFILE\.agents\skills"  "$Repo\skills"

# ── Claude ─────────────────────────────────────────────────────────────────────

Write-Host "`nClaude" -ForegroundColor Cyan
$claude = "$env:USERPROFILE\.claude"
New-Junction  "$claude\docs"          "$Repo\docs"
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

if ($script:copyFallback -gt 0) {
    Write-Host "Done. $($script:copyFallback) file(s) copied (not linked) -- re-run setup after git pull.`n" -ForegroundColor Cyan
} else {
    Write-Host "Done. All links created.`n" -ForegroundColor Green
}
