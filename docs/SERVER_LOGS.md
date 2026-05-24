# Server Logs And Health Checks

This page is safe to share. It does not contain private endpoints, ports,
passwords, Steam credentials, or deployment-specific paths.

## Quick Status

Ask the dedicated server status endpoint for a compact health payload:

```bash
printf status | nc -u -w1 <status-host> <status-port>
```

Important fields:

- `ok`, `ready`, `boot_phase`: whether the mod has reached a playable server state.
- `tps`, `min_tps`, `tps_health`: current and worst recent tick health.
- `ram_mb`, `ram_peak_mb`: Godot static memory counters.
- `players`, `max_players`: connected player count.
- `entity_count`, `drop_count`: active server-side gameplay load.
- `dirty_chunk_count`, `dirty_journal_backlog`, `chunk_journal_sequence`: world persistence backlog.
- `packet_backlog`: pending RPC/action/snapshot work waiting in the mod layer.
- `loaded_region_count`, `chunk_ticket_count`, `native_active_region_centers`: world streaming load centers.
- `autosave_in_progress`, `deferred_autosave`: save pressure.

## Windows Dedicated

If the dedicated server runs in a normal Windows user session, Godot logs are
usually under:

```text
%APPDATA%\Godot\app_userdata\lucid blocks\logs
```

Useful PowerShell commands:

```powershell
Get-Content "$env:APPDATA\Godot\app_userdata\lucid blocks\logs\godot.log" -Tail 200 -Wait
Select-String "$env:APPDATA\Godot\app_userdata\lucid blocks\logs\godot.log" -Pattern "lucid-blocks-coop|Dedicated|block_action|item_action|autosave|chunk_journal"
```

## Linux Systemd / Proton

Service logs:

```bash
journalctl -u lucid-blocks-dedicated.service -n 200 --no-pager
journalctl -u lucid-blocks-dedicated.service -f
```

Find Godot logs inside the server prefix:

```bash
find /opt/lucid-blocks-server -path "*lucid blocks/logs/godot.log" -print
```

Follow the newest Godot log:

```bash
tail -n 200 -f "$(find /opt/lucid-blocks-server -path '*lucid blocks/logs/godot.log' -print | tail -n 1)"
```

## What To Look For

- Server start: `Dedicated server requested`, `Dedicated ready`.
- Player connection: `Dedicated peer_connected`, `Peer ... joined host world`.
- Block pipeline: `Dedicated block_action action=... success=... reason=... latency_ms=...`.
- Item pipeline: `Dedicated item_action action=... success=... reason=... latency_ms=...`.
- Persistence: `Dedicated autosave start`, `Dedicated autosave done`, `chunk_journal replay`, `chunk_journal compacted`.
- Health: `Dedicated health phase=... tps=... mem=... pending=...`.

## Interpreting Problems

- `tps_health=bad`: server is overloaded; reduce players/radius or check entity counts.
- `packet_backlog` keeps growing: networking or action processing is falling behind.
- `dirty_journal_backlog` keeps growing for many minutes: save/compact is not keeping up.
- `loaded_region_count` or `chunk_ticket_count` is high: players/actions are spread across many regions.
- Repeated `chunk_not_loaded` or `load_timeout`: world streaming is not catching the action area fast enough.
- Repeated `drop_unavailable`: clients are trying to pick up drops the server already removed or never spawned.

