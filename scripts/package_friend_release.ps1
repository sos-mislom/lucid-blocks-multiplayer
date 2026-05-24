param(
    [string]$RootDir = "",
    [string]$OutFile = "",
    [string]$PckPath = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RootDir)) {
    $RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}
if ([string]::IsNullOrWhiteSpace($OutFile)) {
    $OutFile = Join-Path $RootDir "dist\lucid-blocks-multiplayer-mvp.zip"
}
if ([string]::IsNullOrWhiteSpace($PckPath)) {
    $PckPath = Join-Path $RootDir "dist\lucid-blocks-multiplayer.pck"
}

$OutFile = Join-Path (Split-Path -Parent $OutFile) (Split-Path -Leaf $OutFile)
$PckPath = (Resolve-Path $PckPath).Path
$outDir = Split-Path -Parent $OutFile
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

& (Join-Path $PSScriptRoot "check_release_hygiene.ps1") -RootDir $RootDir

$tempZip = Join-Path $outDir (".tmp-" + [IO.Path]::GetFileNameWithoutExtension($OutFile) + "." + [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds() + [IO.Path]::GetExtension($OutFile))
if (Test-Path $tempZip) {
    try {
        Remove-Item -Force -LiteralPath $tempZip
    } catch {
    }
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::Open($tempZip, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    function Add-ZipEntry {
        param(
            [string]$Source,
            [string]$EntryName
        )
        if (-not (Test-Path $Source)) {
            throw "Release input not found: $Source"
        }
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, (Resolve-Path $Source).Path, $EntryName, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }

    Add-ZipEntry -Source $PckPath -EntryName "lucid-blocks-multiplayer.pck"
    Add-ZipEntry -Source (Join-Path $RootDir "docs\FRIEND_INSTALL_RU.md") -EntryName "README_RU.md"
    Add-ZipEntry -Source (Join-Path $RootDir "docs\LINUX_SERVER_RU.md") -EntryName "LINUX_SERVER_RU.md"
    Add-ZipEntry -Source (Join-Path $RootDir "docs\LINUX_SERVER_EN.md") -EntryName "LINUX_SERVER_EN.md"
    Add-ZipEntry -Source (Join-Path $RootDir "docs\SERVER_REGISTRY.md") -EntryName "SERVER_REGISTRY.md"
    Add-ZipEntry -Source (Join-Path $RootDir "docs\DEPLOY_LINUX_DEDICATED.md") -EntryName "DEPLOY_LINUX_DEDICATED.md"
    Add-ZipEntry -Source (Join-Path $RootDir "docs\assets\chat-overlay.svg") -EntryName "images\chat-overlay.svg"
    Add-ZipEntry -Source (Join-Path $RootDir "docs\assets\dedicated-flow.svg") -EntryName "images\dedicated-flow.svg"
    Add-ZipEntry -Source (Join-Path $RootDir "docs\assets\server-browser.svg") -EntryName "images\server-browser.svg"

    $screenshotsDir = Join-Path $RootDir "docs\assets\screenshots"
    if (Test-Path $screenshotsDir) {
        Get-ChildItem -LiteralPath $screenshotsDir -File | Where-Object { $_.Extension -in ".png", ".jpg", ".jpeg", ".webp" } | ForEach-Object {
            Add-ZipEntry -Source $_.FullName -EntryName ("screenshots\" + $_.Name)
        }
    }
} finally {
    $zip.Dispose()
}

if (Test-Path $OutFile) {
    try {
        (Get-Item -LiteralPath $OutFile).Attributes = [System.IO.FileAttributes]::Normal
    } catch {
    }
}
Copy-Item -Force -LiteralPath $tempZip -Destination $OutFile
try {
    Remove-Item -Force -LiteralPath $tempZip
} catch {
}
Write-Host "Wrote $OutFile"
Get-FileHash $OutFile -Algorithm SHA256
