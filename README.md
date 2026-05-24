# Lucid Blocks Multiplayer

Unofficial Lucid Blocks multiplayer mod focused on dedicated servers, named
QUALIA server discovery, server-owned worlds, chat, and admin/builder tooling.

Current public version: **v0.1.0-mvp**

Russian overview: [README_RU.md](README_RU.md)

![Lucid Blocks main menu with CO-OP entry](docs/assets/screenshots/main-menu-qualia.jpg)

This is an unofficial fork/continuation of the community co-op mod. It requires
a legal copy of Lucid Blocks and is not affiliated with the game developers or
publisher.

## Packages

- `lucid-blocks-multiplayer.pck` - dedicated/server-based multiplayer.
- `lucid-blocks-chat.pck` - standalone in-game chat UI.
- `lucid-blocks-console.pck` - optional singleplayer/LAN command console and builder tools.

The current repository keeps multiplayer, chat, and console sources in separate
export projects under `mod/overrides`, `mod/chat_overrides`, and
`mod/console_overrides`.

## What Works In v0.1.0-mvp

- In-game `CO-OP` entry and QUALIA-styled server browser.
- Click a server card to connect to a dedicated world.
- Dedicated host owns the world save.
- Server-authoritative block, item, water, fire, storage, entity and player action requests.
- Basic player persistence and repeat-join protection.
- Chat and command input.
- Remote player avatars with a safe default blocky character.
- Server status with TPS, player count, RAM, packet backlog, dirty journal and chunk ticket metrics.
- Server-only save protection so dedicated worlds are not meant to be edited through singleplayer.

![QUALIA server browser](docs/assets/screenshots/server-browser-qualia.jpg)

## Current Limits

This is an experimental MVP, not a polished official multiplayer release.

- The dedicated server still runs through the game/Proton stack, so it is not a true no-render headless server.
- Time/weather authority, entity behavior and mob/drop reconciliation still need more multiplayer testing.
- Large public servers are not the target yet. The current tuning is for small private servers.
- The native world loader is still fundamentally a single-center system; the mod adds player/action chunk tickets and an optional native hook as a compatibility layer.
- Debug/fan avatar assets in the source tree are not cleared as public core-release content unless their attribution says otherwise.

## Screenshots

![Console connection status](docs/assets/screenshots/console-connect-status.jpg)

![Console coords and fly command](docs/assets/screenshots/console-coords-fly.jpg)

![Two default remote avatars in world](docs/assets/screenshots/multiplayer-default-avatars.jpg)

![Avatar skin example](docs/assets/screenshots/avatar-skin-example.jpg)

## Install For Players

1. Close Lucid Blocks.
2. Open the game folder in Steam: `Library -> Lucid Blocks -> Manage -> Browse local files`.
3. Create a `mods` folder if it does not exist.
4. Remove older test co-op/multiplayer `.pck` files from that folder.
5. Copy `dist/lucid-blocks-multiplayer.pck` into `mods`.
6. Launch the game.
7. Click `CO-OP`.
8. Click a server card in `AVAILABLE QUALIA`.

Detailed Russian friend install guide:
[docs/FRIEND_INSTALL_RU.md](docs/FRIEND_INSTALL_RU.md)

## Dedicated Server Docs

- Russian Linux server guide: [docs/LINUX_SERVER_RU.md](docs/LINUX_SERVER_RU.md)
- English Linux server guide: [docs/LINUX_SERVER_EN.md](docs/LINUX_SERVER_EN.md)
- Server registry: [docs/SERVER_REGISTRY.md](docs/SERVER_REGISTRY.md)
- Logs and health checks: [docs/SERVER_LOGS.md](docs/SERVER_LOGS.md)

Do not publish private deployment files, passwords, tokens, live IPs, raw ports,
Steam credentials, or local server logs.

## Architecture

Full notes: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)

### Network Protocols

- Game session: Godot high-level multiplayer RPC over ENet/UDP.
- Protocol identity: `lucid-blocks-coop`.
- Protocol version: `1`.
- Minimum compatible protocol: `1`.
- Compatibility is based on protocol/min-compatible values and feature gates,
  not exact PCK hashes or cosmetic client build tags.
- Dedicated health/status: lightweight UDP JSON endpoint.
- Server browser registry: local JSON plus optional HTTP/HTTPS remote registry.
- Steam lobbies: legacy invite/discovery path, not the dedicated server model.

Redeploy the VPS package when server authority, RPC payloads, persistence, or
required protocol features change. Client-only UI, screenshots, README changes,
and other cosmetic edits should not require a dedicated server deploy.

### Server Authority And Security

The dedicated server is the source of truth for world mutation and persistence.
Clients request actions; the server validates, applies, journals and
acknowledges them.

Current safety model:

- Debug/cheat commands are denied by default.
- Builder commands require server-side admin role validation.
- Clients do not intentionally execute arbitrary server-provided code.
- Incoming snapshots, text, entity/drop counts, coordinates, damage and knockback are capped.
- Client-side scene spawning is restricted to allowed resource prefixes.
- Server-only saves are hidden/blocked from normal singleplayer flows.

Server save sealing is an ownership guard, not DRM. Real server security still
depends on filesystem permissions, host security and private config hygiene.

### Chunk Loading And Interest Management

Lucid Blocks was designed around one loaded world center. Multiplayer needs
several active areas, so the mod adds:

- player tickets around connected players;
- short-lived action tickets for block, foliage, water, fire, storage, item and resync work;
- ticket priorities and TTL cleanup;
- optional native multi-region hook;
- single-center fallback when the hook is unavailable.

Entity and drop snapshots are filtered by active instance and distance so small
servers do not broadcast every object to every player.

### Persistence

Dedicated servers track dirty chunks and append authoritative cell changes to a
chunk journal. Journal replay runs during startup before the server advertises
ready status. Dirty chunks are flushed/compacted by dedicated autosave logic.

Tracked journal state currently covers block cells, water, fire and storage
inventories.

## Console Pack

The console pack is optional and separate from the public multiplayer core.
It provides chat-backed commands for singleplayer/LAN/admin testing.

Common builder commands:

- `/wand`, `/pos1`, `/pos2`, `/sel`
- `/fill <block>`, `/clear [water]`, `/floor <block> [y]`
- `/flat [radius_chunks] [block] [y]`
- `/border [radius_chunks] [block] [height]`
- `/peaceful [on|off]`, `/daylock [on|off]`
- `/builder_setup [radius_chunks] [block] [y]`

## Build

Windows PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\scripts\build_release_packs.ps1
```

Windows cmd:

```bat
scripts\build_release_packs.cmd
```

Linux/macOS shell:

```bash
GODOT_EXPORT_BIN=/path/to/Godot_v4.6-stable_linux.x86_64 ./scripts/build_release_packs.sh
```

## Before Making The Repository Public

Run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\scripts\check_release_hygiene.ps1
git diff --check
git status --short
```

Public checklist:

- No `deploy.txt`, `.env`, passwords, tokens, private IPs/ports or local logs.
- Keep [CREDITS.md](CREDITS.md).
- Do not claim the original co-op mod as original work.
- Do not ship fan/test avatars in release archives unless rights are cleared.
- Use real screenshots from `docs/assets/screenshots`, not mockups.

## Attribution

Original community co-op mod:
https://github.com/parkers0405/lucid-blocks-coop by Parker Settle / Mr_Settle.

Full credits and asset notes are in [CREDITS.md](CREDITS.md).

## Roadmap

See [ROADMAP.md](ROADMAP.md).
