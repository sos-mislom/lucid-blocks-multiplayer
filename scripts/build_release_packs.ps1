param(
    [string]$GodotExe = "",
    [string]$RootDir = "",
    [switch]$SkipMultiplayer,
    [switch]$SkipChat,
    [switch]$SkipConsole
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RootDir)) {
    $RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

if ([string]::IsNullOrWhiteSpace($GodotExe)) {
    $candidate = Join-Path $RootDir "..\..\tools\godot-4.6\Godot_v4.6-stable_win64_console.exe"
    if (Test-Path $candidate) {
        $GodotExe = (Resolve-Path $candidate).Path
    } elseif ($env:GODOT_EXPORT_BIN) {
        $GodotExe = $env:GODOT_EXPORT_BIN
    } else {
        throw "Godot export binary not found. Pass -GodotExe or set GODOT_EXPORT_BIN."
    }
}

if (-not (Test-Path $GodotExe)) {
    throw "Godot export binary not found: $GodotExe"
}

$distDir = Join-Path $RootDir "dist"
New-Item -ItemType Directory -Force -Path $distDir | Out-Null

function Export-Pack {
    param(
        [string]$Label,
        [string]$ProjectDir,
        [string]$OutFile
    )

    if (-not (Test-Path $ProjectDir)) {
        throw "$Label project dir not found: $ProjectDir"
    }

    if (Test-Path $OutFile) {
        Remove-Item -Force $OutFile
    }

    Write-Host "Building $Label -> $OutFile"
    & $GodotExe --headless --path $ProjectDir --export-pack "Linux/X11" $OutFile
    if ($LASTEXITCODE -ne 0) {
        throw "$Label export failed with exit code $LASTEXITCODE"
    }
}

function New-SanitizedMultiplayerProject {
    param(
        [string]$SourceDir
    )

    $workRoot = Join-Path $RootDir "work"
    $stageDir = Join-Path $workRoot "export\multiplayer_core"
    $resolvedWorkRoot = (Resolve-Path $workRoot -ErrorAction SilentlyContinue)
    if ($null -eq $resolvedWorkRoot) {
        New-Item -ItemType Directory -Force -Path $workRoot | Out-Null
        $resolvedWorkRoot = Resolve-Path $workRoot
    }

    if (Test-Path $stageDir) {
        $resolvedStageDir = Resolve-Path $stageDir
        if (-not $resolvedStageDir.Path.StartsWith($resolvedWorkRoot.Path, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to remove staged export outside work dir: $resolvedStageDir"
        }
        Remove-Item -Recurse -Force -LiteralPath $resolvedStageDir.Path
    }

    New-Item -ItemType Directory -Force -Path $stageDir | Out-Null

    $excludeDirs = @(
        ".godot",
        "pim",
        "charlie",
        "mr_frog",
        "pim_anims",
        "pim_base",
        "charlie_anims",
        "charlie_base",
        "mr_frog_anims",
        "mr_frog_base",
        "generated"
    )
    $excludeFiles = @(
        "pim_rest_probe.gd",
        "pim_rest_probe.gd.uid",
        "probe_*.gd",
        "probe_*.gd.uid",
        "configure_mixamo_pipeline.gd",
        "configure_mixamo_pipeline.gd.uid",
        "avatar_normalizer.gd",
        "avatar_normalizer.gd.uid",
        "locomotion_library.res",
        "mixamo_bone_map.tres",
        "open_animation_libraries_README.md"
    )

    $robocopyExe = Join-Path $env:SystemRoot "System32\robocopy.exe"
    if (-not (Test-Path $robocopyExe)) {
        throw "robocopy not found: $robocopyExe"
    }

    Write-Host "Preparing sanitized multiplayer export project -> $stageDir"
    & $robocopyExe $SourceDir $stageDir /MIR /XD $excludeDirs /XF $excludeFiles /NFL /NDL /NJH /NJS /NP | Out-Host
    if ($LASTEXITCODE -gt 7) {
        throw "robocopy failed with exit code $LASTEXITCODE"
    }
    $global:LASTEXITCODE = 0

    return $stageDir
}

if (-not $SkipMultiplayer) {
    $multiplayerProjectDir = New-SanitizedMultiplayerProject -SourceDir (Join-Path $RootDir "mod\overrides")
    Export-Pack `
        -Label "Lucid Blocks Multiplayer" `
        -ProjectDir $multiplayerProjectDir `
        -OutFile (Join-Path $distDir "lucid-blocks-multiplayer.pck")
}

if (-not $SkipChat) {
    Export-Pack `
        -Label "Lucid Blocks Chat" `
        -ProjectDir (Join-Path $RootDir "mod\chat_overrides") `
        -OutFile (Join-Path $distDir "lucid-blocks-chat.pck")
}

if (-not $SkipConsole) {
    $consoleProjectDir = Join-Path $RootDir "mod\console_overrides"
    if (Test-Path $consoleProjectDir) {
        Export-Pack `
            -Label "Lucid Blocks Console" `
            -ProjectDir $consoleProjectDir `
            -OutFile (Join-Path $distDir "lucid-blocks-console.pck")
    } else {
        Write-Warning "Skipping console pack: mod\console_overrides does not exist yet. Chat is built separately as lucid-blocks-chat.pck."
    }
}

Write-Host "Done."
