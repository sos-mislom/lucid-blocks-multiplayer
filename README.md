# Lucid Blocks Multiplayer / Chat / Console Mods

Experimental mods for Lucid Blocks.

Russian overview: [README_RU.md](README_RU.md)

![Lucid Blocks multiplayer main menu with QUALIA server entry](docs/assets/screenshots/main-menu-qualia.png)

The project is being split into three packages:

- `lucid-blocks-multiplayer.pck` - server-based multiplayer and dedicated server work.
- `lucid-blocks-chat.pck` - standalone in-game chat UI.
- `lucid-blocks-console.pck` - singleplayer/LAN command console work on top of chat.

The current source still contains some historical overlap. See [MOD_SPLIT.md](MOD_SPLIT.md) for the split plan and release boundaries.

## Attribution

This is an unofficial fork/continuation of the community co-op mod originally
published at https://github.com/parkers0405/lucid-blocks-coop by Parker Settle /
Mr_Settle. We do not claim authorship of the original co-op mod, Lucid Blocks, or
bundled third-party tools/assets.

Full credits and release attribution rules are in [CREDITS.md](CREDITS.md).

## Screenshots

Player-facing screenshots are kept in `docs/assets/screenshots`. Release notes
and friend packages should use those PNGs first, not diagrams.

![QUALIA multiplayer entry](docs/assets/screenshots/main-menu-qualia.png)

![QUALIA server browser connect screen](docs/assets/screenshots/server-browser-qualia.png)

![Direct add server screen](docs/assets/screenshots/add-server-direct.png)

Console/debug pack screenshots:

![Console help command](docs/assets/screenshots/console-help-command.png)

![Console give command](docs/assets/screenshots/console-give-command.png)

## Status

This is an experimental MVP, not a polished public release yet.

Current priorities:

- keep singleplayer safe;
- keep debug/cheat commands out of the public multiplayer core package unless
  server-side admin roles explicitly allow them;
- keep chat standalone and reusable;
- keep the console pack standalone without the multiplayer manager;
- make Linux dedicated setup reproducible;
- document public releases without exposing private server endpoints.

## Packages

### Multiplayer

Target file:

```text
dist/lucid-blocks-multiplayer.pck
```

Includes:

- multiplayer/dedicated connection flow;
- server browser;
- player list;
- multiplayer integration with the chat pack;
- safe default remote avatar;
- server-world protection;
- server-side admin roles for controlled builder/world-edit commands.

Does not include, for release:

- public access to `/give`, `/gamemode`, `/spawn`, `/time`, `/weather`, `/kill`, `/fly`;
- questionable/fan avatar packs;
- camera/zoom hotkeys;
- private server endpoints in docs/UI.

Admin-only multiplayer commands:

- `/whoami` shows the server-side role and `player_key` for the current player.
- Add admin keys to the dedicated server with `LB_ADMIN_KEYS="steam_...__suffix,mock_..."`
  or launch args `--lb-admin-keys="key1,key2"`.
- Admins can use `/wand`, `/pos1`, `/pos2`, `/sel`, `/fill`, `/clear`,
  `/floor`, `/flat`, `/border`, `/peaceful`, `/daylock`, `/builder_setup`.
- Builder commands are executed by the server after role validation. Clients do
  not directly edit the authoritative world.

### Chat

Target file:

```text
dist/lucid-blocks-chat.pck
```

Goal:

- in-game chat UI;
- chat history;
- input handling;
- command-style text entry shell;
- autocomplete UI shell.

Chat should not execute cheats by itself. It should call optional multiplayer/console providers when those packs are installed.

### Console

Target file:

```text
dist/lucid-blocks-console.pck
```

Goal:

- singleplayer commands on top of chat;
- LAN host admin/debug commands;
- command autocomplete provider.

The console pack is now a standalone optional debug/admin pack in
`mod/console_overrides`. It reuses the chat UI and provides its own command
provider instead of relying on `coop_manager`.

Builder/admin commands:

- `/wand`, `/pos1`, `/pos2`, `/sel`
- `/fill <block>`, `/clear [water]`, `/floor <block> [y]`
- `/flat [radius_chunks] [block] [y]`
- `/border [radius_chunks] [block] [height]`
- `/peaceful [on|off]`, `/daylock [on|off]`
- `/builder_setup [radius_chunks] [block] [y]`

`/builder_setup` prepares a spawn-building area: creative/fly, day lock,
peaceful mode, a flat loaded chunk area, and a physical border wall.

Screenshots:

![Console help command](docs/assets/screenshots/console-help-command.png)

![Console give command](docs/assets/screenshots/console-give-command.png)

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

## Install

Copy the `.pck` file into one of the Lucid Blocks mod directories, depending on your install:

```text
SteamLibrary/steamapps/common/lucid-blocks/mods
SteamLibrary/steamapps/common/lucid-blocks/lucid-blocks/mods
```

Do not install old mixed/debug packages together with release packages unless you are intentionally testing conflicts.

Friend install guide:

- Russian: [docs/FRIEND_INSTALL_RU.md](docs/FRIEND_INSTALL_RU.md)

## Dedicated Server Docs

- Russian: [docs/LINUX_SERVER_RU.md](docs/LINUX_SERVER_RU.md)
- English: [docs/LINUX_SERVER_EN.md](docs/LINUX_SERVER_EN.md)
- Server registry: [docs/SERVER_REGISTRY.md](docs/SERVER_REGISTRY.md)
- Logs and health checks: [docs/SERVER_LOGS.md](docs/SERVER_LOGS.md)

## Roadmap

The living roadmap is [SERVER_ROADMAP.md](SERVER_ROADMAP.md).

## GitHub Publishing

Before publishing, read [docs/GITHUB_PUBLISHING.md](docs/GITHUB_PUBLISHING.md).

Do not publish private deployment files, passwords, IPs, ports, Steam credentials, or server config.

Generated folders such as `.godot/`, `logs/`, `backups/`, `__pycache__/`,
native build caches, and temporary `dist/.tmp-*` files should stay out of Git.

## License / Assets

License is still TODO.

Do not ship assets with unclear rights in the main public package. The default blocky avatar has attribution in `avatar_assets/rigged_default/ATTRIBUTION.md`; other test/fan avatars should move to optional forks/addon packs before public release.
