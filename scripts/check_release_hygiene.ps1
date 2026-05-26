param(
    [string]$RootDir = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RootDir)) {
    $RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

$failures = New-Object System.Collections.Generic.List[string]

foreach ($sensitivePattern in @("deploy.txt", "deploy*.txt", ".env", ".env.*")) {
    $matches = & git -C $RootDir ls-files -- $sensitivePattern 2>$null
    foreach ($match in $matches) {
        if (-not [string]::IsNullOrWhiteSpace($match)) {
            $failures.Add("Sensitive file is tracked by git and must not be uploaded: $match")
        }
    }
}

$distDir = Join-Path $RootDir "dist"
if (Test-Path -LiteralPath $distDir) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    Get-ChildItem -LiteralPath $distDir -File -Filter "*.zip" -ErrorAction SilentlyContinue | ForEach-Object {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($_.FullName)
        try {
            foreach ($entry in $zip.Entries) {
                $entryName = $entry.FullName.Replace("\", "/")
                $leaf = [IO.Path]::GetFileName($entryName)
                if ($leaf -like "deploy*.txt" -or $leaf -like ".env*") {
                    $failures.Add("Sensitive file is present in release archive $($_.Name): $entryName")
                }
            }
        } finally {
            $zip.Dispose()
        }
    }
}

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
$coopStatusModule = Read-RepoText "mod\overrides\coop_mod\coop_status.gd"
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

$dedicatedStatusSurface = $coopManager + "`n" + $coopStatusModule
foreach ($requiredMetric in @(
    '"packet_backlog"',
    '"dirty_journal_backlog"',
    '"loaded_region_count"',
    '"native_active_region_centers"',
    '"ram_mb"'
)) {
    if (-not $dedicatedStatusSurface.Contains($requiredMetric)) {
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

# --- Version single-source-of-truth check ---
# `VERSION` (repo root) is the canonical version. Everything that bakes a
# version into shipped artefacts must agree with it.
$versionFile = Join-Path $RootDir "VERSION"
if (-not (Test-Path -LiteralPath $versionFile)) {
    $failures.Add("Missing VERSION file at repo root")
} else {
    $canonicalVersion = (Get-Content -LiteralPath $versionFile -Raw).Trim()
    if ([string]::IsNullOrWhiteSpace($canonicalVersion)) {
        $failures.Add("VERSION file is empty")
    } else {
        $expectedCoopTag = 'const COOP_BUILD_TAG: String = "' + $canonicalVersion + '"'
        if (-not $coopManager.Contains($expectedCoopTag)) {
            $failures.Add("COOP_BUILD_TAG in coop_manager.gd does not match VERSION ($canonicalVersion)")
        }

        foreach ($projectGodotRel in @(
            "mod\overrides\project.godot",
            "mod\chat_overrides\project.godot",
            "mod\console_overrides\project.godot"
        )) {
            $projectPath = Join-Path $RootDir $projectGodotRel
            if (-not (Test-Path -LiteralPath $projectPath)) {
                $failures.Add("Missing $projectGodotRel")
                continue
            }
            $projectText = Get-Content -LiteralPath $projectPath -Raw
            $expectedConfigVersion = 'config/version="' + $canonicalVersion + '"'
            if (-not $projectText.Contains($expectedConfigVersion)) {
                $failures.Add("$projectGodotRel application/config/version does not match VERSION ($canonicalVersion)")
            }
        }
    }
}

# --- God-class decomposition forwarder check ---
# Phases 2 / 3 / 4 / 5 / 6 / 7 / 8 / 9 / 10 / 11 / 12d / 12e / 13a / 13b / 13c / 14a / 14b / 15a / 15b / 15c / 16a / 16b / 16c / 16d / 17 / 18 / 19 / 20 / 22 / 23 / 24 / 25 of the coop_manager.gd
# split keep every public function name in coop_manager.gd as a thin
# forwarder around CoopJournal / CoopIO / CoopAuthorityValidator /
# CoopStatus / CoopAdmin / CoopBuilder / CoopBuilderRuntime /
# CoopCommandPolicyRPC / CoopTeleport / CoopDimensionTravel /
# CoopRevive. The ~80 internal callers depend on those names;
# accidental re-inlining or renaming would break compilation silently.
# CoopStatus also leaves engine-bound bodies
# (Thread / Mutex / PacketPeerUDP / HTTPRequest) in coop_manager.gd,
# so we additionally require those wrappers to remain wired up.
# CoopBuilder funnels Ref.world.* through the `_make_world_ops()`
# Callable bag; the world-edit forwarders below must keep delegating
# to CoopBuilder so the cap (WORLD_EDIT_MAX_BLOCK_OPS) and the
# dirty-chunk collapse stay in one place. CoopBuilderRuntime owns the
# admin builder tick decisions and the entity-despawn filter; its
# three forwarders below must keep delegating so `_process(delta)`
# -> tick math stays in one module and the canonical day-time /
# sweep-interval / chat-response constants stay there too.
# CoopCommandPolicyRPC owns the four server-side policy decisions
# (effective-policy choice, single-toggle apply, broadcast gate,
# rejection message); the `@rpc` handler sync_server_command_policy
# and the config / multiplayer.* / _save_config / status_message
# wiring stay in coop_manager.gd as forwarders. CoopTeleport owns
# the pure `/tp` decisions (dimension-instance key format/parse,
# /tp arg parsing, peer-alias matching, autocomplete entry building,
# safe-offset iteration); engine teleport application
# (`_teleport_local_player_*`) stays on coop_manager.gd.
# CoopDimensionTravel owns the pure dimension-travel decisions
# (private-dimension predicate, open-path / group-travel if-elif
# trees, active-peer-in-instance lookup, closest-respawn-anchor scan,
# anchor-vs-safe-search gate); the engine orchestration
# (`await Ref.main.teleport_to_dimension`, `@rpc` handlers,
# `Ref.save_file_manager.loaded_file_register` mutations,
# `_send_persistent_state_to_host`/`_broadcast_local_state_now`,
# status_message pipeline) stays on coop_manager.gd. CoopRevive owns
# the pure downed/revive/respawn decisions (same-instance peer scans,
# revive target selection, revive request validation, remote respawn
# anchor selection, void-Y + block-centering math, grace-window
# predicate, fake-death union); the @rpc handlers
# (`request_revive_peer`, `force_peer_revive`, `receive_revive_feedback`,
# `sync_host_respawn_state`) and the engine-bound side effects
# (`Ref.player` mutation, overlay updates, status_message pipeline,
# `_resolve_respawn_position` async + `Ref.world.spawn_tester`,
# `_is_safe_respawn_position`, `_find_safe_respawn_position_near`)
# stay on coop_manager.gd.
$forwarderRequirements = @(
    @{ Module = "CoopIO";                  Function = "_atomic_write_file" },
    @{ Module = "CoopIO";                  Function = "_atomic_append_line" },
    @{ Module = "CoopIO";                  Function = "_bounded_dict_set" },
    @{ Module = "CoopIO";                  Function = "_is_valid_client_request_id" },
    @{ Module = "CoopJournal";             Function = "_server_journal_array_to_vector3i" },
    @{ Module = "CoopJournal";             Function = "_server_journal_vector3i_to_array" },
    @{ Module = "CoopJournal";             Function = "_server_journal_storage_items_to_json" },
    @{ Module = "CoopJournal";             Function = "_server_journal_storage_items_from_json" },
    @{ Module = "CoopJournal";             Function = "_server_chunk_journal_path" },
    @{ Module = "CoopJournal";             Function = "_server_chunk_journal_applied_seq_path" },
    @{ Module = "CoopJournal";             Function = "_load_journal_applied_seq" },
    @{ Module = "CoopJournal";             Function = "_persist_journal_applied_seq" },
    @{ Module = "CoopJournal";             Function = "_compact_server_chunk_journal_after_save" },
    @{ Module = "CoopJournal";             Function = "_record_server_world_cell_journal" },
    @{ Module = "CoopAuthorityValidator";  Function = "_is_safe_vector3" },
    @{ Module = "CoopAuthorityValidator";  Function = "_is_safe_vector3i" },
    @{ Module = "CoopAuthorityValidator";  Function = "_is_safe_float" },
    @{ Module = "CoopAuthorityValidator";  Function = "_is_safe_block_id" },
    @{ Module = "CoopAuthorityValidator";  Function = "_is_safe_item_data" },
    @{ Module = "CoopAuthorityValidator";  Function = "_is_safe_resource_path" },
    @{ Module = "CoopAuthorityValidator";  Function = "_clamp_safe_vector3" },
    @{ Module = "CoopAuthorityValidator";  Function = "_server_peer_within_reach" },
    @{ Module = "CoopAuthorityValidator";  Function = "_server_peer_within_block_reach" },
    @{ Module = "CoopAuthorityValidator";  Function = "_is_peer_admin" },
    @{ Module = "CoopStatus";              Function = "_resolve_server_registry_heartbeat_url" },
    @{ Module = "CoopStatus";              Function = "_get_dedicated_status_thread_payload" },
    @{ Module = "CoopStatus";              Function = "_get_dedicated_status_payload" },
    @{ Module = "CoopStatus";              Function = "_send_dedicated_registry_heartbeat" },
    @{ Module = "CoopStatus";              Function = "_start_dedicated_status_udp" },
    @{ Module = "CoopStatus";              Function = "_stop_dedicated_status_thread" },
    @{ Module = "CoopStatus";              Function = "_dedicated_status_thread_main" },
    @{ Module = "CoopStatus";              Function = "_publish_dedicated_status_snapshot" },
    @{ Module = "CoopStatus";              Function = "_read_dedicated_status_snapshot_bytes" },
    @{ Module = "CoopStatus";              Function = "_poll_dedicated_status_udp" },
    @{ Module = "CoopStatus";              Function = "_tick_dedicated_registry_heartbeat" },
    @{ Module = "CoopAdmin";               Function = "_parse_server_admin_keys" },
    @{ Module = "CoopAdmin";               Function = "_normalize_server_command_name" },
    @{ Module = "CoopAdmin";               Function = "_normalize_server_command_policy" },
    @{ Module = "CoopAdmin";               Function = "_is_server_command_policy_controlled" },
    @{ Module = "CoopAdmin";               Function = "_is_command_allowed_by_server_policy" },
    @{ Module = "CoopAdmin";               Function = "_is_admin_builder_command" },
    @{ Module = "CoopAdmin";               Function = "_is_core_debug_command" },
    @{ Module = "CoopAdmin";               Function = "_is_core_debug_autocomplete_command" },
    @{ Module = "CoopAdmin";               Function = "_parse_builder_vector3i_parts" },
    @{ Module = "CoopAdmin";               Function = "_parse_builder_on_off" },
    @{ Module = "CoopAdmin";               Function = "_format_builder_vector3i" },
    @{ Module = "CoopAdmin";               Function = "_slugify_string" },
    @{ Module = "CoopAdmin";               Function = "_get_item_aliases" },
    @{ Module = "CoopAdmin";               Function = "_has_builder_selection" },
    @{ Module = "CoopAdmin";               Function = "_get_builder_selection_bounds" },
    @{ Module = "CoopAdmin";               Function = "_get_builder_chunk_square_around_position" },
    @{ Module = "CoopAdmin";               Function = "_builder_count_box_blocks" },
    @{ Module = "CoopBuilder";             Function = "_builder_set_world_block" },
    @{ Module = "CoopBuilder";             Function = "_builder_fill_box" },
    @{ Module = "CoopBuilder";             Function = "_builder_make_flat_area" },
    @{ Module = "CoopBuilder";             Function = "_builder_build_border" },
    @{ Module = "CoopBuilder";             Function = "_remember_builder_changed_chunk" },
    @{ Module = "CoopBuilderRuntime";      Function = "_tick_builder_admin_runtime" },
    @{ Module = "CoopBuilderRuntime";      Function = "_apply_builder_peaceful_runtime" },
    @{ Module = "CoopBuilderRuntime";      Function = "_set_builder_day_time" },
    @{ Module = "CoopCommandPolicyRPC";    Function = "_get_effective_server_command_policy" },
    @{ Module = "CoopCommandPolicyRPC";    Function = "_set_server_command_policy_value" },
    @{ Module = "CoopCommandPolicyRPC";    Function = "_broadcast_server_command_policy" },
    @{ Module = "CoopCommandPolicyRPC";    Function = "_reject_command_by_server_policy" },
    @{ Module = "CoopTeleport";            Function = "get_dimension_instance_key" },
    @{ Module = "CoopTeleport";            Function = "_parse_dimension_instance_key" },
    @{ Module = "CoopTeleport";            Function = "_resolve_dimension_namespace" },
    @{ Module = "CoopTeleport";            Function = "_execute_tp_command" },
    @{ Module = "CoopTeleport";            Function = "_get_tp_command_autocomplete_entries" },
    @{ Module = "CoopTeleport";            Function = "get_teleport_target_entries" },
    @{ Module = "CoopTeleport";            Function = "_sort_peer_autocomplete_entries" },
    @{ Module = "CoopTeleport";            Function = "_find_safe_respawn_position_near" },
    @{ Module = "CoopDimensionTravel";     Function = "_is_private_instance_dimension" },
    @{ Module = "CoopDimensionTravel";     Function = "_find_active_peer_position_in_instance" },
    @{ Module = "CoopDimensionTravel";     Function = "_resolve_default_respawn_fallback_position" },
    @{ Module = "CoopDimensionTravel";     Function = "_open_dimension_instance_async" },
    @{ Module = "CoopDimensionTravel";     Function = "_travel_group_to_dimension_async" },
    @{ Module = "CoopRevive";              Function = "_has_same_instance_reviver_available" },
    @{ Module = "CoopRevive";              Function = "_has_same_instance_downed_partner" },
    @{ Module = "CoopRevive";              Function = "_all_same_instance_partners_downed" },
    @{ Module = "CoopRevive";              Function = "_can_offer_manual_partner_respawn" },
    @{ Module = "CoopRevive";              Function = "_get_revivable_peer_state" },
    @{ Module = "CoopRevive";              Function = "_host_attempt_revive" },
    @{ Module = "CoopRevive";              Function = "_has_remote_respawn_anchor" },
    @{ Module = "CoopRevive";              Function = "_get_remote_respawn_anchor" },
    @{ Module = "CoopRevive";              Function = "_resolve_local_downed_position" },
    @{ Module = "CoopRevive";              Function = "is_local_player_fake_dead" },
    @{ Module = "CoopWorldJournal";        Function = "_server_chunk_key" },
    @{ Module = "CoopWorldJournal";        Function = "_server_chunk_ticket_key" },
    @{ Module = "CoopWorldJournal";        Function = "_remember_server_dirty_chunk" },
    @{ Module = "CoopWorldJournal";        Function = "_mark_server_dirty_chunks_for_world_positions" },
    @{ Module = "CoopWorldJournal";        Function = "_compact_server_chunk_journal_after_save" },
    @{ Module = "CoopChunkTickets";        Function = "_snap_world_stream_position" },
    @{ Module = "CoopChunkTickets";        Function = "_cleanup_server_chunk_tickets" },
    @{ Module = "CoopChunkTickets";        Function = "_get_active_server_chunk_ticket_positions" },
    @{ Module = "CoopChunkTickets";        Function = "_tick_dedicated_world_load_focus" },
    @{ Module = "CoopChunkTickets";        Function = "_get_dedicated_world_load_center" },
    @{ Module = "CoopWorldPredict";        Function = "_next_client_block_action_id" },
    @{ Module = "CoopWorldPredict";        Function = "_next_client_item_action_id" },
    @{ Module = "CoopWorldPredict";        Function = "_remember_client_block_action" },
    @{ Module = "CoopWorldPredict";        Function = "_get_pending_block_place_reservations" },
    @{ Module = "CoopWorldPredict";        Function = "_does_inventory_item_place_block_id" },
    @{ Module = "CoopWorldPredict";        Function = "_server_block_action_key" },
    @{ Module = "CoopWorldPredict";        Function = "_remember_server_block_action_result" },
    @{ Module = "CoopWorldPredict";        Function = "_cleanup_server_block_action_results" },
    @{ Module = "CoopWorldPredict";        Function = "_purge_recent_action_results_for_peer" },
    @{ Module = "CoopWorldPatch";          Function = "_should_use_canonical_guest_block_patch" },
    @{ Module = "CoopWorldPatch";          Function = "_get_unique_chunk_positions_for_world_positions" },
    @{ Module = "CoopWorldPatch";          Function = "_filter_world_data_to_chunk_positions" },
    @{ Module = "CoopWorldPatch";          Function = "_merge_patch_dictionary" },
    @{ Module = "CoopWorldPatch";          Function = "_clamp_chunk_byte_value" },
    @{ Module = "CoopWorldSnapshot";       Function = "_should_force_dedicated_snapshot_spawn" },
    @{ Module = "CoopWorldSnapshot";       Function = "_apply_peer_persistent_player_to_snapshot" },
    @{ Module = "CoopEntitySync";          Function = "_get_sync_scene_path" },
    @{ Module = "CoopEntitySync";          Function = "_is_syncable_entity_node" },
    @{ Module = "CoopEntitySync";          Function = "_host_entity_snapshot_key" },
    @{ Module = "CoopEntitySync";          Function = "_host_entity_visual_key" },
    @{ Module = "CoopEntitySync";          Function = "_get_host_entity_snapshot_interval" },
    @{ Module = "CoopEntitySync";          Function = "_host_entity_yaw_delta_abs" },
    @{ Module = "CoopEntitySync";          Function = "_build_host_entity_snapshot_state" },
    @{ Module = "CoopEntitySync";          Function = "_is_host_entity_snapshot_state_changed" },
    @{ Module = "CoopEntitySync";          Function = "_is_peer_interested_in_position" },
    @{ Module = "CoopEntitySync";          Function = "_client_entity_block_position" },
    @{ Module = "CoopEntitySync";          Function = "_should_full_render_client_entity" },
    @{ Module = "CoopEntityVisuals";       Function = "_quantize_float" },
    @{ Module = "CoopEntityVisuals";       Function = "_quantize_vector3" },
    @{ Module = "CoopEntityVisuals";       Function = "_consume_client_entity_visual_update_delta" },
    @{ Module = "CoopEntityVisuals";       Function = "_is_segmented_worm_entity" },
    @{ Module = "CoopCombatSync";          Function = "calculate_attack_knockback_velocity" },
    @{ Module = "CoopCombatSync";          Function = "get_attack_impulse_velocity" },
    @{ Module = "CoopDropSync";            Function = "_host_drop_snapshot_key" },
    @{ Module = "CoopDropSync";            Function = "_get_host_drop_snapshot_interval" },
    @{ Module = "CoopDropSync";            Function = "_build_host_drop_snapshot_state" },
    @{ Module = "CoopDropSync";            Function = "_is_host_drop_snapshot_state_changed" },
    @{ Module = "CoopDropSync";            Function = "_is_host_recent_drop_visible_to_peer" },
    @{ Module = "CoopDropSync";            Function = "_item_data_signature" },
    @{ Module = "CoopDropPredict";         Function = "_predict_client_break_drops_for_block" },
    @{ Module = "CoopDropPredict";         Function = "_find_matching_predicted_drop" },
    @{ Module = "CoopDropPredict";         Function = "_is_client_drop_within_pickup_radius" },
    @{ Module = "CoopDropPredict";         Function = "_attempt_client_auto_pickup_drop" },
    @{ Module = "CoopDropPredict";         Function = "_is_client_drop_sync_grace_active" },
    @{ Module = "CoopDropPredict";         Function = "_is_client_drop_snapshot_grace_active" },
    @{ Module = "CoopServerBrowserUI";     Function = "_format_server_browser_status_line" },
    @{ Module = "CoopServerBrowserUI";     Function = "_format_server_browser_presence_text" },
    @{ Module = "CoopServerBrowserUI";     Function = "_format_server_browser_detail_line" },
    @{ Module = "CoopServerBrowserUI";     Function = "_format_server_browser_region_line" },
    @{ Module = "CoopServerBrowserUI";     Function = "_format_server_browser_meta_line" },
    @{ Module = "CoopServerBrowserUI";     Function = "_format_server_browser_card_parts" },
    @{ Module = "CoopServerBrowserUI";     Function = "_format_server_browser_entry" },
    @{ Module = "CoopServerBrowserUI";     Function = "_make_server_browser_entry_key" },
    @{ Module = "CoopServerBrowserUI";     Function = "_normalize_server_browser_entry" },
    @{ Module = "CoopServerBrowserUI";     Function = "_merge_server_browser_registry" },
    @{ Module = "CoopServerBrowserUI";     Function = "_find_server_browser_entry_index" },
    @{ Module = "CoopServerBrowserUI";     Function = "_apply_server_browser_status" },
    @{ Module = "CoopPauseMenuUI";         Function = "_get_peer_display_name" },
    @{ Module = "CoopPauseMenuUI";         Function = "_format_session_player_label" },
    @{ Module = "CoopPauseMenuUI";         Function = "_is_dedicated_peer_state" },
    @{ Module = "CoopPauseMenuUI";         Function = "_get_session_player_signature" },
    @{ Module = "CoopPauseMenuUI";         Function = "_build_player_detail_lines" },
    @{ Module = "CoopMainMenuUI";          Function = "_refresh_main_menu_server_detail" },
    @{ Module = "CoopMainMenuUI";          Function = "_refresh_main_menu_player_actions" },
    @{ Module = "CoopJoinProtocol";        Function = "_get_coop_protocol_info" },
    @{ Module = "CoopJoinProtocol";        Function = "_get_coop_protocol_info_from_status" },
    @{ Module = "CoopJoinProtocol";        Function = "_protocol_feature_list" },
    @{ Module = "CoopJoinProtocol";        Function = "_has_protocol_features" },
    @{ Module = "CoopJoinProtocol";        Function = "_format_protocol_features" },
    @{ Module = "CoopJoinProtocol";        Function = "_is_coop_protocol_compatible" },
    @{ Module = "CoopJoinProtocol";        Function = "_format_coop_protocol_info" },
    @{ Module = "CoopTransportLAN";        Function = "_parse_address_port" },
    @{ Module = "CoopTransportSteam";      Function = "_extract_lobby_id_from_connect_string" },
    @{ Module = "CoopReconnect";           Function = "_tick_reconnect_timer" },
    @{ Module = "CoopReconnect";           Function = "_format_reconnect_subtitle" },
    @{ Module = "CoopReconnect";           Function = "_format_reconnect_attempting_now_subtitle" },
    @{ Module = "CoopReconnect";           Function = "_compute_next_reconnect_attempt_kind" },
    @{ Module = "CoopReconnect";           Function = "_resolve_lan_reconnect_target" },
    @{ Module = "CoopDedicatedBootstrap";  Function = "_get_coop_cmdline_args" },
    @{ Module = "CoopDedicatedBootstrap";  Function = "_cmdline_has_flag" },
    @{ Module = "CoopDedicatedBootstrap";  Function = "_read_cmdline_value" },
    @{ Module = "CoopDedicatedBootstrap";  Function = "_read_cmdline_bool" },
    @{ Module = "CoopDedicatedBootstrap";  Function = "_compute_server_world_seal_for_register" },
    @{ Module = "CoopServerRegistry";      Function = "_extract_servers_list_from_registry_data" },
    @{ Module = "CoopServerRegistry";      Function = "_is_server_registry_url_valid" },
    @{ Module = "CoopServerRegistry";      Function = "_is_server_registry_response_ok" },
    @{ Module = "CoopServerRegistry";      Function = "_build_server_registry_cache_payload" },
    @{ Module = "CoopServerRegistry";      Function = "_is_server_registry_cache_payload_fresh" },
    @{ Module = "CoopAvatarRegistry";      Function = "_normalize_avatar_id" },
    @{ Module = "CoopAvatarRegistry";      Function = "_get_local_skin_color" },
    @{ Module = "CoopPlayerSync";          Function = "_hash_client_state" },
    @{ Module = "CoopPlayerSync";          Function = "_serialize_peer_states" },
    @{ Module = "CoopPlayerSync";          Function = "_serialize_peer_state_entry" },
    @{ Module = "CoopConfig";              Function = "_build_default_coop_config" },
    @{ Module = "CoopHud";                 Function = "toggle_panel" },
    @{ Module = "CoopHud";                 Function = "_should_close_pause_menu_coop_panel_for_sync" },
    @{ Module = "CoopHud";                 Function = "_should_close_main_menu_coop_panel_for_sync" },
    @{ Module = "CoopHud";                 Function = "_score_ipv4" },
    @{ Module = "CoopHud";                 Function = "_refresh_local_ip_label" },
    @{ Module = "CoopHud";                 Function = "_refresh_player_list_overlay" },
    @{ Module = "CoopMarkers";             Function = "_refresh_markers" }
)
foreach ($req in $forwarderRequirements) {
    if ($coopManager -notmatch ('func\s+' + [regex]::Escape($req.Function) + '\s*\(')) {
        $failures.Add("Forwarder $($req.Function) is missing from coop_manager.gd (expected to wrap $($req.Module).*)")
    }
}

foreach ($modulePath in @(
    "mod\overrides\coop_mod\coop_io.gd",
    "mod\overrides\coop_mod\coop_journal.gd",
    "mod\overrides\coop_mod\coop_authority_validator.gd",
    "mod\overrides\coop_mod\coop_status.gd",
    "mod\overrides\coop_mod\coop_admin.gd",
    "mod\overrides\coop_mod\coop_builder.gd",
    "mod\overrides\coop_mod\coop_builder_runtime.gd",
    "mod\overrides\coop_mod\coop_command_policy_rpc.gd",
    "mod\overrides\coop_mod\coop_teleport.gd",
    "mod\overrides\coop_mod\coop_dimension_travel.gd",
    "mod\overrides\coop_mod\coop_revive.gd",
    "mod\overrides\coop_mod\coop_world_journal.gd",
    "mod\overrides\coop_mod\coop_chunk_tickets.gd",
    "mod\overrides\coop_mod\coop_world_predict.gd",
    "mod\overrides\coop_mod\coop_world_patch.gd",
    "mod\overrides\coop_mod\coop_world_snapshot.gd",
    "mod\overrides\coop_mod\coop_entity_sync.gd",
    "mod\overrides\coop_mod\coop_entity_visuals.gd",
    "mod\overrides\coop_mod\coop_combat_sync.gd",
    "mod\overrides\coop_mod\coop_drop_sync.gd",
    "mod\overrides\coop_mod\coop_drop_predict.gd",
    "mod\overrides\coop_mod\coop_server_browser_ui.gd",
    "mod\overrides\coop_mod\coop_pause_menu_ui.gd",
    "mod\overrides\coop_mod\coop_main_menu_ui.gd",
    "mod\overrides\coop_mod\coop_join_protocol.gd",
    "mod\overrides\coop_mod\coop_transport_lan.gd",
    "mod\overrides\coop_mod\coop_transport_steam.gd",
    "mod\overrides\coop_mod\coop_reconnect.gd",
    "mod\overrides\coop_mod\coop_dedicated_bootstrap.gd",
    "mod\overrides\coop_mod\coop_server_registry.gd",
    "mod\overrides\coop_mod\coop_avatar_registry.gd",
    "mod\overrides\coop_mod\coop_player_sync.gd",
    "mod\overrides\coop_mod\coop_config.gd",
    "mod\overrides\coop_mod\coop_hud.gd",
    "mod\overrides\coop_mod\coop_markers.gd"
)) {
    if (-not (Test-Path -LiteralPath (Join-Path $RootDir $modulePath))) {
        $failures.Add("Required extracted module is missing: $modulePath")
    }
}

foreach ($testDir in @(
    "mod\overrides\tests\runner.gd",
    "mod\overrides\tests\test_helpers.gd"
)) {
    if (-not (Test-Path -LiteralPath (Join-Path $RootDir $testDir))) {
        $failures.Add("Required test scaffolding is missing: $testDir")
    }
}

# --- Optional: run the unit-test suite when a Godot binary is reachable ---
# We skip the run silently when no binary is configured so the existing
# release-hygiene workflow (which does not assume a Godot install) still
# passes. CI is expected to set GODOT_EXPORT_BIN or GODOT_TEST_BIN.
if ($failures.Count -eq 0) {
    $godotBin = ""
    $localCandidate = Join-Path $RootDir "..\..\tools\godot-4.6\Godot_v4.6-stable_win64_console.exe"
    if (Test-Path $localCandidate) {
        $godotBin = (Resolve-Path $localCandidate).Path
    } else {
        # Sibling-of-repo console binary - same discovery rule as
        # scripts/run_tests.ps1. Sorted descending by name so the
        # newest version wins when multiple drops coexist.
        $siblingMatches = @(Get-ChildItem -Path (Join-Path $RootDir "..") -Filter "Godot_*_console.exe" -ErrorAction SilentlyContinue -File)
        if ($siblingMatches.Count -gt 0) {
            $godotBin = ($siblingMatches | Sort-Object -Property Name -Descending | Select-Object -First 1).FullName
        } elseif ($env:GODOT_EXPORT_BIN -and (Test-Path $env:GODOT_EXPORT_BIN)) {
            $godotBin = $env:GODOT_EXPORT_BIN
        } elseif ($env:GODOT_TEST_BIN -and (Test-Path $env:GODOT_TEST_BIN)) {
            $godotBin = $env:GODOT_TEST_BIN
        }
    }
    if ($godotBin -ne "") {
        Write-Host "Release hygiene: running coop unit tests via $godotBin"
        & (Join-Path $PSScriptRoot "run_tests.ps1") -GodotExe $godotBin -RootDir $RootDir
        if ($LASTEXITCODE -ne 0) {
            $failures.Add("coop unit tests failed (run_tests.ps1 exit $LASTEXITCODE)")
        }
    } else {
        Write-Host "Release hygiene: skipping unit test run (no Godot binary found; set GODOT_TEST_BIN to enable)"
    }
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Error $failure
    }
    exit 1
}

Write-Host "Release hygiene checks passed"
