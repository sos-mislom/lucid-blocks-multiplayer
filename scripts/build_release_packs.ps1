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

if (-not $SkipMultiplayer) {
    Export-Pack `
        -Label "Lucid Blocks Multiplayer" `
        -ProjectDir (Join-Path $RootDir "mod\overrides") `
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
