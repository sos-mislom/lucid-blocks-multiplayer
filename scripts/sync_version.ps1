param(
    [string]$RootDir = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RootDir)) {
    $RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

$versionFile = Join-Path $RootDir "VERSION"
if (-not (Test-Path -LiteralPath $versionFile)) {
    throw "VERSION file not found at $versionFile"
}
$version = (Get-Content -LiteralPath $versionFile -Raw).Trim()
if ([string]::IsNullOrWhiteSpace($version)) {
    throw "VERSION file is empty"
}

Write-Host "Syncing all version artefacts to: $version"

function Update-File {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Replacement,
        [string]$Description
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        Write-Warning "Skipping $Description (file not found): $Path"
        return
    }
    $text = Get-Content -LiteralPath $Path -Raw
    $newText = [regex]::Replace($text, $Pattern, [System.Text.RegularExpressions.Regex]::Escape($Replacement).Replace("\\", "\"))
    # Above produced an escaped literal; rebuild with the literal value the
    # caller intended. Use a simpler unescaped replacement.
    $newText = [regex]::Replace($text, $Pattern, { param($m) $Replacement })
    if ($newText -eq $text) {
        Write-Host "  - already up to date: $Description"
        return
    }
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $newText, $utf8NoBom)
    Write-Host "  - updated $Description"
}

# 1. COOP_BUILD_TAG in coop_manager.gd
Update-File `
    -Path (Join-Path $RootDir "mod\overrides\coop_mod\coop_manager.gd") `
    -Pattern 'const COOP_BUILD_TAG: String = "[^"]*"' `
    -Replacement ('const COOP_BUILD_TAG: String = "' + $version + '"') `
    -Description "COOP_BUILD_TAG"

# 2. application/config/version in each project.godot
foreach ($projectRel in @(
    "mod\overrides\project.godot",
    "mod\chat_overrides\project.godot",
    "mod\console_overrides\project.godot"
)) {
    $projectPath = Join-Path $RootDir $projectRel
    if (-not (Test-Path -LiteralPath $projectPath)) {
        Write-Warning "Skipping (missing): $projectRel"
        continue
    }
    $text = Get-Content -LiteralPath $projectPath -Raw
    if ($text -match 'config/version="[^"]*"') {
        $newText = [regex]::Replace($text, 'config/version="[^"]*"', { param($m) 'config/version="' + $version + '"' })
    } else {
        # Insert below config/name= if absent
        $newText = [regex]::Replace($text, '(config/name="[^"]*")', { param($m) $m.Groups[1].Value + "`n" + 'config/version="' + $version + '"' })
    }
    if ($newText -ne $text) {
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($projectPath, $newText, $utf8NoBom)
        Write-Host "  - updated $projectRel"
    } else {
        Write-Host "  - already up to date: $projectRel"
    }
}

Write-Host "Done. Run scripts/check_release_hygiene.ps1 to verify."
