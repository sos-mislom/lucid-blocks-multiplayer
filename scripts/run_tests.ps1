param(
    [string]$GodotExe = "",
    [string]$RootDir = "",
    [string]$Filter = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RootDir)) {
    $RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

if ([string]::IsNullOrWhiteSpace($GodotExe)) {
    $candidate = Join-Path $RootDir "..\..\tools\godot-4.6\Godot_v4.6-stable_win64_console.exe"
    if (Test-Path $candidate) {
        $GodotExe = (Resolve-Path $candidate).Path
    } else {
        # Sibling-of-repo console binary: matches the
        # Godot_v4.X.Y-stable_win64_console.exe drop pattern many
        # contributors use locally (e.g. D:\imp\work\Godot_v4.6.3...).
        # Sorted descending by name so the newest version wins when
        # multiple are present.
        $siblingMatches = @(Get-ChildItem -Path (Join-Path $RootDir "..") -Filter "Godot_*_console.exe" -ErrorAction SilentlyContinue -File)
        if ($siblingMatches.Count -gt 0) {
            $GodotExe = ($siblingMatches | Sort-Object -Property Name -Descending | Select-Object -First 1).FullName
        } elseif ($env:GODOT_EXPORT_BIN) {
            $GodotExe = $env:GODOT_EXPORT_BIN
        } elseif ($env:GODOT_TEST_BIN) {
            $GodotExe = $env:GODOT_TEST_BIN
        } else {
            throw "Godot binary not found. Pass -GodotExe, set GODOT_EXPORT_BIN, or set GODOT_TEST_BIN."
        }
    }
}

if (-not (Test-Path $GodotExe)) {
    throw "Godot binary not found: $GodotExe"
}

$projectDir = Join-Path $RootDir "mod\overrides"
if (-not (Test-Path $projectDir)) {
    throw "Test project dir not found: $projectDir"
}

# Discover godot project first run a quick parse so missing scripts surface
# clearly. The runner itself prints a summary line and exits 0/1.
$baseArgs = @("--headless", "--path", $projectDir, "--script", "res://tests/runner.gd")
if (-not [string]::IsNullOrWhiteSpace($Filter)) {
    $baseArgs += @("--", "--filter", $Filter)
}

Write-Host "Running coop unit tests via $GodotExe"
Write-Host "  project: $projectDir"
if (-not [string]::IsNullOrWhiteSpace($Filter)) {
    Write-Host "  filter: $Filter"
}

$process = Start-Process `
    -FilePath $GodotExe `
    -ArgumentList $baseArgs `
    -NoNewWindow `
    -Wait `
    -PassThru

exit $process.ExitCode
