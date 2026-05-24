param(
    [string]$DeployFile = "",
    [string]$HostName = "",
    [string]$UserName = "",
    [string]$Password = "",
    [string]$RemoteRoot = "/opt/lucid-blocks-master",
    [string]$MasterServiceName = "lucid-blocks-master-registry.service",
    [string]$HeartbeatServiceName = "lucid-blocks-server-heartbeat.service",
    [int]$MasterPort = 8088,
    [int]$StatusPort = 24668,
    [string]$PublicName = "QUALIA",
    [string]$PublicRegion = "public",
    [string]$PlinkPath = "",
    [string]$PscpPath = ""
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
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

foreach ($required in @("HostName", "UserName", "Password")) {
    if ([string]::IsNullOrWhiteSpace((Get-Variable $required).Value)) {
        throw "$required is required. Pass it explicitly or use -DeployFile."
    }
}

$masterScript = Join-Path $repoRoot "scripts\linux\lucid_blocks_master_server.py"
$heartbeatScript = Join-Path $repoRoot "scripts\linux\lucid_blocks_server_heartbeat.py"

Write-Host "Installing master registry scripts..."
& $PlinkPath -batch -ssh -pw $Password "${UserName}@${HostName}" "mkdir -p '$RemoteRoot'" | Out-Host
if ($LASTEXITCODE -ne 0) { throw "remote mkdir failed" }
& $PscpPath -batch -pw $Password $masterScript "${UserName}@${HostName}:$RemoteRoot/lucid_blocks_master_server.py" | Out-Host
if ($LASTEXITCODE -ne 0) { throw "master upload failed" }
& $PscpPath -batch -pw $Password $heartbeatScript "${UserName}@${HostName}:$RemoteRoot/lucid_blocks_server_heartbeat.py" | Out-Host
if ($LASTEXITCODE -ne 0) { throw "heartbeat upload failed" }

$remoteScript = @"
set -e
remote_root='$RemoteRoot'
master_service='$MasterServiceName'
heartbeat_service='$HeartbeatServiceName'
master_port='$MasterPort'
status_port='$StatusPort'
public_name='$PublicName'
public_region='$PublicRegion'
public_address='$HostName'

mkdir -p "`$remote_root"
chmod 755 "`$remote_root/lucid_blocks_master_server.py" "`$remote_root/lucid_blocks_server_heartbeat.py"
if [ ! -s "`$remote_root/registry.token" ]; then
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 32 > "`$remote_root/registry.token"
  else
    python3 - <<'PY' > "`$remote_root/registry.token"
import secrets
print(secrets.token_hex(32))
PY
  fi
  chmod 600 "`$remote_root/registry.token"
fi

cat > "`$remote_root/master.env" <<EOF
LB_MASTER_HOST=0.0.0.0
LB_MASTER_PORT=`$master_port
LB_MASTER_TOKEN=`$(cat "`$remote_root/registry.token")
LB_MASTER_DATA=`$remote_root/servers.json
LB_MASTER_TTL=90
EOF
chmod 600 "`$remote_root/master.env"

cat > "`$remote_root/heartbeat.env" <<EOF
LB_MASTER_HEARTBEAT_URL=http://127.0.0.1:`$master_port/heartbeat
LB_MASTER_TOKEN=`$(cat "`$remote_root/registry.token")
LB_STATUS_HOST=127.0.0.1
LB_STATUS_PORT=`$status_port
LB_PUBLIC_ADDRESS=`$public_address
LB_PUBLIC_NAME=`$public_name
LB_PUBLIC_REGION=`$public_region
LB_HEARTBEAT_INTERVAL=30
EOF
chmod 600 "`$remote_root/heartbeat.env"

cat > "/etc/systemd/system/`$master_service" <<EOF
[Unit]
Description=Lucid Blocks master server registry
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=`$remote_root
EnvironmentFile=`$remote_root/master.env
ExecStart=/usr/bin/python3 `$remote_root/lucid_blocks_master_server.py
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

cat > "/etc/systemd/system/`$heartbeat_service" <<EOF
[Unit]
Description=Lucid Blocks dedicated server heartbeat
After=network-online.target `$master_service lucid-blocks-linux-dedicated.service
Wants=`$master_service

[Service]
Type=simple
WorkingDirectory=`$remote_root
EnvironmentFile=`$remote_root/heartbeat.env
ExecStart=/usr/bin/python3 `$remote_root/lucid_blocks_server_heartbeat.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now "`$master_service" "`$heartbeat_service"
systemctl restart "`$master_service" "`$heartbeat_service"
sleep 2
systemctl is-active "`$master_service"
systemctl is-active "`$heartbeat_service"
python3 - <<PY
import json, urllib.request
url = "http://127.0.0.1:$MasterPort/servers.json"
with urllib.request.urlopen(url, timeout=5) as response:
    payload = json.loads(response.read().decode("utf-8"))
print("REGISTRY_READY=" + json.dumps({"servers": len(payload.get("servers", [])), "ttl": payload.get("ttl")}, sort_keys=True))
PY
"@

$tempScript = New-TemporaryFile
$remoteScriptPath = "/tmp/lucid-blocks-master-$([Guid]::NewGuid().ToString("N")).sh"
try {
    $remoteScriptLf = $remoteScript -replace "`r`n", "`n"
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($tempScript.FullName, $remoteScriptLf, $utf8NoBom)
    & $PscpPath -batch -pw $Password $tempScript.FullName "${UserName}@${HostName}:$remoteScriptPath" | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "remote script upload failed"
    }
    & $PlinkPath -batch -ssh -pw $Password "${UserName}@${HostName}" "bash '$remoteScriptPath'; rc=`$?; rm -f '$remoteScriptPath'; exit `$rc" | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "remote master deploy failed"
    }
} finally {
    if (Test-Path $tempScript.FullName) {
        Remove-Item -Force -LiteralPath $tempScript.FullName
    }
}

Write-Host "Master registry deployed."
