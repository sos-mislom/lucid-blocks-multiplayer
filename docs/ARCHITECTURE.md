# Architecture

This document describes the current multiplayer MVP as implemented in
`mod/overrides/coop_mod/coop_manager.gd`. It is intentionally practical rather
than aspirational.

## Current Scope

The mod turns the original community co-op experiment into a server-authoritative
multiplayer flow:

- clients join a named QUALIA server from the in-game browser;
- the dedicated host owns the world save and applies block/item/entity changes;
- clients render local prediction where possible, then reconcile to server state;
- server worlds are marked as server-only so players do not open and edit them
  through singleplayer by accident.

This is a Godot mod layered over the existing game. The repository keeps the
implemented multiplayer hooks, server authority, chunk tickets and persistence
path in the mod layer.

## Network Transports

### Game Session

Gameplay uses Godot high-level multiplayer RPCs over ENet/UDP. The active
protocol identity is:

```text
COOP_PROTOCOL_NAME = lucid-blocks-coop
COOP_PROTOCOL_VERSION = 1
COOP_PROTOCOL_MIN_COMPATIBLE = 1
```

Compatibility should be handled through protocol/min-compatible checks and
feature gates, not by requiring every client build hash to match exactly.

Steam lobbies are treated as a discovery/invite path for legacy co-op flows.
Dedicated server play should use named server entries from the server browser.

### Status Endpoint

Dedicated servers expose a lightweight UDP status endpoint. It accepts simple
status requests such as:

```text
status
ping
health
{"type":"status"}
```

The response is JSON and includes fields such as `ready`, `boot_phase`, `players`,
`tps`, `ram_mb`, `packet_backlog`, `dirty_journal_backlog`,
`loaded_region_count`, and `chunk_ticket_count`.

### Server Registry

The server list is loaded from:

1. built-in defaults, which should stay empty in public builds;
2. local `user://lucid_blocks_server_registry.json`;
3. optional remote `server_registry_url`.

The registry is JSON over HTTP/HTTPS. Linux servers can publish heartbeat data to
a small master registry service in `scripts/linux/lucid_blocks_master_server.py`.

Player-facing UI shows server names, world names, status, players and TPS. Raw
addresses and ports are not shown on cards or in public docs.

## Server Authority

The dedicated host is the source of truth for:

- world save ownership;
- block place/break/foliage actions;
- water, fire and storage cell changes;
- dropped item pickup results;
- entity/player damage and rewards;
- admin/builder commands.

Clients send requests such as `request_place_block`, `request_break_block`,
`request_foliage_break`, `request_water_cells`, `request_fire_cell`,
`request_storage_inventory`, `request_entity_attack`, and item pickup requests.
The server validates the request, applies it if allowed, records world changes,
and sends acknowledgements or resync data back to the client.

Duplicate block and item requests are cached for a short time so repeated RPCs do
not duplicate inventory or world mutations.

## Security Model

This is a mod-level safety model, not a hardened anti-cheat system.

Current protections:

- server-side command policy defaults deny debug/cheat commands;
- admin-only builder commands require server-side role validation by `player_key`;
- clients do not directly execute arbitrary server-provided code;
- incoming snapshots and payloads are capped by size and count;
- client-side scene spawning is restricted to allowed resource prefixes;
- text, UUIDs, coordinates, damage and knockback values are clamped;
- server-only saves are sealed with metadata so they are hidden/blocked from
  normal singleplayer flows;
- player-facing UI and public docs hide raw endpoints.

The server save secret/seal is an ownership guard, not DRM. It reduces accidental
or casual local editing of a server world, but the server process still needs
normal filesystem and host security.

## World Streaming And Chunk Tickets

The base game world loader was designed around one loaded center. Multiplayer
needs several active areas: one per player plus short-lived action zones.

The current MVP uses a layered approach:

- player positions define active load centers;
- server chunk tickets hold chunks around recent actions such as block place,
  block break, foliage, water, fire, storage, item pickup and resync;
- tickets have owners, priorities and TTLs;
- if the native multi-region hook is available, active centers are pushed into
  the native patch;
- if the native hook is unavailable, the server falls back to the best single
  load focus to preserve compatibility.

This keeps far-apart players and delayed block actions more playable while
preserving compatibility with the current game build.

## Interest Management

The server does not try to send every entity and drop update to every client.
Current filtering is distance/instance based:

- peer snapshots are per active same-instance peer;
- entity visual snapshots are throttled per peer/entity;
- dropped item spawn RPCs are sent only to nearby interested peers;
- clients keep short grace windows for recently seen entities and drops to avoid
  flicker while snapshots catch up;
- far entities can be represented as low-frequency dummy state instead of fully
  simulated visuals.

The default MVP is tuned for small servers. Bigger player counts need more work
on AOI grids, entity ownership and native no-render dedicated mode.

## Persistence

The server tracks dirty world state by chunk/instance and records authoritative
cell changes in a chunk journal:

- block changes;
- water cells;
- fire cells;
- storage inventories.

On dedicated startup the server replays the journal before publishing ready
status. Dirty chunks are periodically flushed/compacted through dedicated
autosave logic. Status metrics expose `dirty_chunk_count`,
`dirty_journal_backlog`, and `chunk_journal_sequence`.

This is intended to avoid manual merging of player saves. The server save is the
world; clients should not edit that same save locally.

## Observability

Dedicated status and logs are part of the architecture, not debug leftovers.
Admins should watch:

- `tps`, `min_tps`, `tps_health`;
- `ram_mb`, `ram_peak_mb`;
- `players`, `max_players`;
- `packet_backlog`;
- `dirty_journal_backlog`;
- `loaded_region_count`, `chunk_ticket_count`;
- entity/drop counts and interest counters.

See [SERVER_LOGS.md](SERVER_LOGS.md) for commands and warning signs.

## Operational Limits

- Gameplay transport is ENet/UDP.
- Linux/Proton dedicated hosting can still pay rendering cost because the game
  was not built as a true headless server.
