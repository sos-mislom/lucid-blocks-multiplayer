param(
    [string]$RootDir = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RootDir)) {
    $RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

$failures = New-Object System.Collections.Generic.List[string]

function Read-RepoText {
    param([string]$RelativePath)
    $path = Join-Path $RootDir $RelativePath
    if (-not (Test-Path -LiteralPath $path)) {
        $failures.Add("Missing required file: $RelativePath")
        return ""
    }
    return Get-Content -LiteralPath $path -Raw
}

$coopManager = Read-RepoText "mod\overrides\coop_mod\coop_manager.gd"
$chatManager = Read-RepoText "mod\chat_overrides\chat_mod\command_chat_manager.gd"
$playerScript = Read-RepoText "mod\overrides\main\entity\player\player.gd"
$entityScript = Read-RepoText "mod\overrides\main\entity\entity.gd"
$chickenScript = Read-RepoText "mod\overrides\main\entity\chicken\chicken.gd"
$fruitGirlScript = Read-RepoText "mod\overrides\main\entity\fruit_girl\fruit_girl.gd"
$bubblebearScript = Read-RepoText "mod\overrides\main\entity\bubblebear\bubblebear.gd"
$sheepScript = Read-RepoText "mod\overrides\main\entity\sheep\sheep.gd"
$fusionScript = Read-RepoText "mod\overrides\main\items\fusion\fuser.gd"
$cutsceneBlockScript = Read-RepoText "mod\overrides\main\world\living_block\cutscene_block\cutscene_block.gd"

foreach ($command in @("/give", "/gamemode", "/gm", "/spawn", "/spawnlist", "/spawnmenu", "/mobs", "/time", "/weather", "/kill", "/fly")) {
    if ($chatManager -match [regex]::Escape('"' + $command + '"')) {
        $failures.Add("Standalone chat registry exposes debug command $command")
    }
}

foreach ($required in @(
    'const ENABLE_DEBUG_CONSOLE_COMMANDS_DEFAULT: bool = false',
    'const ENABLE_CLIENT_VISUAL_MOD_DEFAULT: bool = true',
    'const ENABLE_AVATAR_CUSTOMIZATION_DEFAULT: bool = false',
    'const ENABLE_AVATAR_ALIAS_COMMAND_DEFAULT: bool = false'
)) {
    if (-not $coopManager.Contains($required)) {
        $failures.Add("Core default is not release-safe: $required")
    }
}

if (-not $playerScript.Contains('func _is_client_visual_mod_enabled()')) {
    $failures.Add("Player visual mod gate is missing")
}
if ($playerScript -notmatch '_is_client_visual_mod_enabled\(\).*KEY_V') {
    $failures.Add("KEY_V camera hotkey is not gated by client visual mod flag")
}
if ($playerScript -notmatch '_is_client_visual_mod_enabled\(\).*KEY_C') {
    $failures.Add("KEY_C zoom hotkey is not gated by client visual mod flag")
}
if ($chatManager -match '\bKEY_T\b') {
    $failures.Add("Chat still opens on KEY_T; expected KEY_N or Enter")
}

if ($coopManager -match 'DEFAULT_PUBLIC_SERVERS:\s*Array\s*=\s*\[[^\]]+\]') {
    $failures.Add("DEFAULT_PUBLIC_SERVERS should stay empty in public core builds")
}
if ($coopManager -match 'status_message\s*=\s*"[^"]*(port %s|%s:%s)') {
    $failures.Add("Player-facing status_message exposes a raw endpoint or port")
}

$saveFileMenuOverridePath = Join-Path $RootDir "mod\overrides\main\ui\menu\save_file_menu\save_file_menu.gd"
if (Test-Path -LiteralPath $saveFileMenuOverridePath) {
    $failures.Add("SaveFileMenu override must stay absent; vanilla save/backup UI is required for singleplayer restore")
}

if (-not $coopManager.Contains('func _enforce_server_only_world_access()')) {
    $failures.Add("Server-only world access guard is missing")
} elseif ($coopManager -notmatch 'if dedicated_server_enabled or _has_live_peer\(\) or not _is_loaded_world_server_only\(\):\s*\r?\n\s*return') {
    $failures.Add("Server-only world guard is not gated to dedicated/active coop sessions")
}

foreach ($requiredMetric in @(
    '"packet_backlog"',
    '"dirty_journal_backlog"',
    '"loaded_region_count"',
    '"native_active_region_centers"',
    '"ram_mb"'
)) {
    if (-not $coopManager.Contains($requiredMetric)) {
        $failures.Add("Dedicated status metric is missing: $requiredMetric")
    }
}

if (-not $coopManager.Contains('func grant_tiamana_to_local_player')) {
    $failures.Add("Local tiamana reward helper is missing")
} elseif (-not $coopManager.Contains('_send_persistent_state_to_host(true)')) {
    $failures.Add("Local tiamana reward helper does not force guest persistent-state flush")
}
if (-not $coopManager.Contains('func grant_player_stat_to_local_player')) {
    $failures.Add("Local player stat reward helper is missing")
}
if (-not $entityScript.Contains('grant_tiamana_to_attacker')) {
    $failures.Add("Entity death rewards are not routed through coop reward helper")
}
if (-not $fusionScript.Contains('grant_tiamana_to_local_player')) {
    $failures.Add("Fusion rewards are not routed through coop reward helper")
}
if (-not $cutsceneBlockScript.Contains('grant_tiamana_to_local_player')) {
    $failures.Add("Cutscene block rewards are not routed through coop reward helper")
}
foreach ($entry in @(
    @{ Name = "Chicken"; Text = $chickenScript },
    @{ Name = "FruitGirl"; Text = $fruitGirlScript },
    @{ Name = "Bubblebear"; Text = $bubblebearScript },
    @{ Name = "Sheep"; Text = $sheepScript }
)) {
    if (-not $entry.Text.Contains('grant_player_stat_to_local_player')) {
        $failures.Add("$($entry.Name) local stat rewards are not routed through coop stat helper")
    }
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Error $failure
    }
    exit 1
}

Write-Host "Release hygiene checks passed"
