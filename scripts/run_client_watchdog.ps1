param(
    [string]$GamePath = "D:\Fallout\Steam\steamapps\common\lucid-blocks\lucid-blocks.exe",
    [switch]$Launch,
    [string[]]$GameArgs = @(),
    [int]$LimitMb = 3072,
    [int]$WarnMb = 2300,
    [int]$SampleSeconds = 2,
    [int]$MaxMinutes = 30,
    [string]$LogDir = "",
    [switch]$NoKill
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($LogDir)) {
    $repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
    $LogDir = Join-Path $repoRoot "logs\client-watchdog"
}
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$csvPath = Join-Path $LogDir "lucid-client-memory-$stamp.csv"
$txtPath = Join-Path $LogDir "lucid-client-watchdog-$stamp.log"

function Write-WatchdogLog {
    param([string]$Message)
    $line = "{0} {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    Write-Host $line
    Add-Content -LiteralPath $txtPath -Value $line
}

function Get-LucidProcesses {
    $processes = Get-Process -ErrorAction SilentlyContinue |
        Where-Object {
            $_.ProcessName -ieq "lucid-blocks" -or
            $_.ProcessName -like "lucid-blocks*" -or
            ($_.Path -and $_.Path -like "*lucid-blocks*")
        }
    return @($processes | Sort-Object Id)
}

function Get-CommandLineByPid {
    param([int]$Pid)
    try {
        $cim = Get-CimInstance Win32_Process -Filter "ProcessId=$Pid" -ErrorAction Stop
        return [string]$cim.CommandLine
    } catch {
        return ""
    }
}

if (-not (Test-Path -LiteralPath $GamePath)) {
    throw "Game executable not found: $GamePath"
}

if ($SampleSeconds -lt 1) {
    $SampleSeconds = 1
}
if ($LimitMb -lt 512) {
    $LimitMb = 512
}
if ($WarnMb -lt 256) {
    $WarnMb = [Math]::Max(256, [int]($LimitMb * 0.75))
}

Write-WatchdogLog "log_csv=$csvPath"
Write-WatchdogLog "limit_mb=$LimitMb warn_mb=$WarnMb sample_seconds=$SampleSeconds max_minutes=$MaxMinutes kill_on_limit=$(-not $NoKill)"

if ($Launch) {
    Write-WatchdogLog "launching=$GamePath args=$($GameArgs -join ' ')"
    Start-Process -FilePath $GamePath -ArgumentList $GameArgs -WorkingDirectory (Split-Path -Parent $GamePath) | Out-Null
} else {
    Write-WatchdogLog "attach mode: start Lucid Blocks normally if it is not already running"
}

$deadline = (Get-Date).AddMinutes($MaxMinutes)
$headerWritten = $false
$warned = @{}
$lastSeenAny = $false

while ((Get-Date) -lt $deadline) {
    $processes = Get-LucidProcesses
    if ($processes.Count -eq 0) {
        if ($lastSeenAny) {
            Write-WatchdogLog "no lucid-blocks process remains; stopping watchdog"
            break
        }
        Start-Sleep -Seconds $SampleSeconds
        continue
    }

    $lastSeenAny = $true
    foreach ($process in $processes) {
        try {
            $process.Refresh()
            $workingMb = [Math]::Round($process.WorkingSet64 / 1MB, 1)
            $privateMb = [Math]::Round($process.PrivateMemorySize64 / 1MB, 1)
            $cpu = if ($null -ne $process.CPU) { [Math]::Round($process.CPU, 2) } else { 0 }
            $responding = $true
            try { $responding = [bool]$process.Responding } catch { $responding = $true }
            $commandLine = Get-CommandLineByPid -Pid $process.Id

            $row = [pscustomobject]@{
                timestamp = (Get-Date).ToString("o")
                pid = $process.Id
                process = $process.ProcessName
                working_set_mb = $workingMb
                private_mb = $privateMb
                cpu_seconds = $cpu
                threads = $process.Threads.Count
                handles = $process.HandleCount
                responding = $responding
                path = [string]$process.Path
                command_line = $commandLine
            }
            if (-not $headerWritten) {
                $row | Export-Csv -LiteralPath $csvPath -NoTypeInformation -Encoding UTF8
                $headerWritten = $true
            } else {
                $row | Export-Csv -LiteralPath $csvPath -NoTypeInformation -Encoding UTF8 -Append
            }

            if ($workingMb -ge $WarnMb -and -not $warned.ContainsKey($process.Id)) {
                $warned[$process.Id] = $true
                Write-WatchdogLog "WARN pid=$($process.Id) working_set_mb=$workingMb private_mb=$privateMb"
            }

            if ($workingMb -ge $LimitMb) {
                Write-WatchdogLog "LIMIT pid=$($process.Id) working_set_mb=$workingMb private_mb=$privateMb"
                if (-not $NoKill) {
                    Write-WatchdogLog "stopping pid=$($process.Id)"
                    Stop-Process -Id $process.Id -Force
                    Write-WatchdogLog "stopped; watchdog log preserved"
                    exit 2
                }
            }
        } catch {
            Write-WatchdogLog "sample_error pid=$($process.Id) $($_.Exception.Message)"
        }
    }

    Start-Sleep -Seconds $SampleSeconds
}

Write-WatchdogLog "watchdog finished"
