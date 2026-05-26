param(
    [string]$PckPath = "",
    [string]$DeployFile = "",
    [string]$HostName = "",
    [string]$UserName = "",
    [string]$Password = "",
    # Path to a PuTTY .ppk private key. Strongly preferred over -Password
    # because plink/pscp's -pw flag exposes the password on the local
    # process command-line and in any error logs.
    [string]$PrivateKeyPath = "",
    [string]$RemoteRoot = "/opt/lucid-blocks-server",
    [string]$ServiceName = "lucid-blocks-dedicated.service",
    [int]$ReadinessTimeoutSec = 180,
    [string]$PlinkPath = "",
    [string]$PscpPath = "",
    [switch]$SkipRestart
)

$ErrorActionPreference = "Stop"

# Returns a single-quoted Bash literal for `value`. Inside the heredoc we
# embed remote-side variables with `var='...'`; any single quote in the
# original value would otherwise close the literal early and let the
# attacker / accidental user input inject shell commands.
function ConvertTo-BashSingleQuoted([string]$value) {
    if ($null -eq $value) { return "''" }
    return "'" + ($value -replace "'", "'\''") + "'"
}

# Build the auth argument list once. -i is preferred; -pw is only used as
# fallback and emits a warning so operators see they should rotate to keys.
function Get-PuttyAuthArgs() {
    if (-not [string]::IsNullOrWhiteSpace($script:PrivateKeyPath)) {
        if (-not (Test-Path $script:PrivateKeyPath)) {
            throw "PrivateKeyPath not found: $script:PrivateKeyPath"
        }
        return @("-batch", "-i", $script:PrivateKeyPath)
    }
    if ([string]::IsNullOrWhiteSpace($script:Password)) {
        throw "Either -PrivateKeyPath or -Password (deploy.txt) must be provided."
    }
    Write-Warning "Using -pw for plink/pscp leaks the password to local process list. Pass -PrivateKeyPath <ppk> instead."
    return @("-batch", "-pw", $script:Password)
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
if ([string]::IsNullOrWhiteSpace($PckPath)) {
    $PckPath = Join-Path $repoRoot "dist\lucid-blocks-multiplayer.pck"
}
$PckPath = (Resolve-Path $PckPath).Path

if ([string]::IsNullOrWhiteSpace($PlinkPath)) {
    $PlinkPath = Join-Path $env:USERPROFILE ".codex-tools\putty\plink.exe"
}
if ([string]::IsNullOrWhiteSpace($PscpPath)) {
    $PscpPath = Join-Path $env:USERPROFILE ".codex-tools\putty\pscp.exe"
}
if (-not (Test-Path $PlinkPath)) {
    throw "plink.exe not found: $PlinkPath"
}
if (-not (Test-Path $PscpPath)) {
    throw "pscp.exe not found: $PscpPath"
}

if (-not [string]::IsNullOrWhiteSpace($DeployFile)) {
    $tokens = (Get-Content -Raw -LiteralPath $DeployFile).Trim() -split "\s+"
    if ([string]::IsNullOrWhiteSpace($HostName)) {
        $HostName = ($tokens | Where-Object { $_ -match "^[0-9]{1,3}(\.[0-9]{1,3}){3}$" } | Select-Object -First 1)
    }
    if ([string]::IsNullOrWhiteSpace($UserName)) {
        $UserName = ($tokens | Where-Object { $_ -ne $HostName -and $_ -match "^[A-Za-z_][A-Za-z0-9_-]*$" } | Select-Object -Last 1)
    }
    if ([string]::IsNullOrWhiteSpace($Password)) {
        $Password = ($tokens | Where-Object { $_ -ne $HostName -and $_ -ne $UserName } | Select-Object -First 1)
    }
}

foreach ($required in @("HostName", "UserName")) {
    if ([string]::IsNullOrWhiteSpace((Get-Variable $required).Value)) {
        throw "$required is required. Pass it explicitly or use -DeployFile."
    }
}

$authArgs = Get-PuttyAuthArgs

$remotePrimary = "$RemoteRoot/game/mods/lucid-blocks-multiplayer.pck"
$target = "${UserName}@${HostName}:$remotePrimary"

Write-Host "Uploading multiplayer PCK to primary mod directory..."
& $PscpPath @authArgs $PckPath $target | Out-Host
if ($LASTEXITCODE -ne 0) {
    throw "pscp failed with exit code $LASTEXITCODE"
}

$remoteRootQuoted = ConvertTo-BashSingleQuoted $RemoteRoot
$serviceNameQuoted = ConvertTo-BashSingleQuoted $ServiceName
$restartLine = if ($SkipRestart) { "echo SKIP_RESTART" } else { "systemctl restart $serviceNameQuoted" }
$readinessTimeout = [Math]::Max(15, $ReadinessTimeoutSec)

$remoteScript = @"
set -e
remote_root=$remoteRootQuoted
service_name=$serviceNameQuoted
primary_mod_dir="`$remote_root/game/mods"
nested_mod_dir="`$remote_root/game/lucid-blocks/mods"
mkdir -p "`$primary_mod_dir" "`$nested_mod_dir"

if find "`$nested_mod_dir" -maxdepth 1 -type f -name '*.pck' | grep -q .; then
  backup_dir="`$nested_mod_dir/backup-before-deploy-`$(date +%Y%m%d-%H%M%S)"
  mkdir -p "`$backup_dir"
  find "`$nested_mod_dir" -maxdepth 1 -type f -name '*.pck' -exec mv -t "`$backup_dir" {} +
fi

cp -f "`$primary_mod_dir/lucid-blocks-multiplayer.pck" "`$nested_mod_dir/lucid-blocks-multiplayer.pck"
echo PRIMARY_HASH=`$(sha256sum "`$primary_mod_dir/lucid-blocks-multiplayer.pck" | cut -d' ' -f1)
echo NESTED_HASH=`$(sha256sum "`$nested_mod_dir/lucid-blocks-multiplayer.pck" | cut -d' ' -f1)

$restartLine

python3 - <<'PY'
import json
import re
import socket
import subprocess
import sys
import time

deadline = time.time() + $readinessTimeout
last_payload = None
last_error = "no UDP socket"

def game_udp_ports():
    try:
        text = subprocess.check_output(["ss", "-H", "-lunp"], text=True, stderr=subprocess.DEVNULL)
    except Exception:
        return []
    ports = []
    for line in text.splitlines():
        if "lucid-blocks" not in line:
            continue
        match = re.search(r"[:*]([0-9]+)\s+", line)
        if match:
            ports.append(int(match.group(1)))
    return sorted(set(ports))

while time.time() < deadline:
    for port in game_udp_ports():
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.settimeout(1.0)
        try:
            sock.sendto(b'{"type":"status"}', ("127.0.0.1", port))
            data, _ = sock.recvfrom(8192)
            payload = json.loads(data.decode("utf-8", "replace"))
            last_payload = payload
            if payload.get("ok") is True:
                safe = {key: payload.get(key) for key in ["ok", "status", "ready", "boot_phase", "players", "tps", "tps_health", "load_radius", "buffer_radius"] if key in payload}
                print("STATUS_READY=" + json.dumps(safe, sort_keys=True))
                sys.exit(0)
            last_error = "not ready: " + str(payload.get("status", payload.get("boot_phase", "unknown")))
        except Exception as exc:
            last_error = exc.__class__.__name__
        finally:
            sock.close()
    time.sleep(2.0)

if last_payload is not None:
    safe = {key: last_payload.get(key) for key in ["ok", "status", "ready", "boot_phase", "players", "tps", "tps_health", "load_radius", "buffer_radius"] if key in last_payload}
    print("STATUS_NOT_READY=" + json.dumps(safe, sort_keys=True))
else:
    print("STATUS_TIMEOUT=" + last_error)
sys.exit(2)
PY

systemctl is-active "`$service_name"
"@

Write-Host "Synchronizing nested mod directory and checking readiness..."
$tempScript = New-TemporaryFile
$remoteScriptPath = "/tmp/lucid-blocks-deploy-$([Guid]::NewGuid().ToString("N")).sh"
try {
    $remoteScriptLf = $remoteScript -replace "`r`n", "`n"
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($tempScript.FullName, $remoteScriptLf, $utf8NoBom)
    & $PscpPath @authArgs $tempScript.FullName "${UserName}@${HostName}:$remoteScriptPath" | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "remote script upload failed with exit code $LASTEXITCODE"
    }

    $remoteScriptPathQuoted = ConvertTo-BashSingleQuoted $remoteScriptPath
    & $PlinkPath @authArgs -ssh "${UserName}@${HostName}" "bash $remoteScriptPathQuoted; rc=`$?; rm -f $remoteScriptPathQuoted; exit `$rc" | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "remote deploy/readiness failed with exit code $LASTEXITCODE"
    }
} finally {
    if (Test-Path $tempScript.FullName) {
        Remove-Item -Force -LiteralPath $tempScript.FullName
    }
}
