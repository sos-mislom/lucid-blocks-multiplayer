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

$tempZip = Join-Path $outDir (".tmp-" + [IO.Path]::GetFileName($OutFile))
if (Test-Path $tempZip) {
    Remove-Item -Force -LiteralPath $tempZip
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
} finally {
    $zip.Dispose()
}

Move-Item -Force -LiteralPath $tempZip -Destination $OutFile
Write-Host "Wrote $OutFile"
Get-FileHash $OutFile -Algorithm SHA256
