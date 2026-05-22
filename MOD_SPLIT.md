# Mod Split

Goal: publish small understandable mods instead of one mixed development pack.

## Attribution Rules

- Public releases must say this is an unofficial fork/continuation of
  `parkers0405/lucid-blocks-coop`, originally by Parker Settle / Mr_Settle.
- Do not present the upstream co-op mod, Lucid Blocks, bundled tools, or bundled
  assets as our original work.
- Keep [CREDITS.md](CREDITS.md), third-party README files, license files, and
  asset attribution files in release archives.
- Test/fan avatar assets are private/testing-only until rights are cleared.

## Public Packages

### Lucid Blocks Multiplayer

Package name:

```text
lucid-blocks-multiplayer.pck
```

Scope:

- dedicated/server-based multiplayer;
- server browser and named server cards;
- integration with the chat pack for connected players;
- player list;
- safe default remote player avatar;
- server-only world protection;
- Linux/Windows dedicated setup docs.

Out of scope:

- cheat/debug commands;
- `/gamemode`, `/give`, `/spawn`, `/time`, `/weather`, `/kill`, `/fly`;
- questionable/fan avatar packs;
- camera/zoom hotkeys such as `V` and `C`;
- public docs that expose private server endpoints.

### Lucid Blocks Chat

Package name:

```text
lucid-blocks-chat.pck
```

Scope:

- in-game chat UI;
- chat history;
- input focus/cursor handling;
- command-style text entry;
- autocomplete UI shell;
- local display fallback when no multiplayer/console handler is installed.

Rules:

- Chat must not depend on `coop_manager`.
- Chat must not execute cheats by itself.
- Chat can call optional providers if they exist:
  - multiplayer provider for network messages;
  - console provider for slash commands/autocomplete.

### Lucid Blocks Console

Package name:

```text
lucid-blocks-console.pck
```

Scope:

- singleplayer commands on top of the chat pack;
- LAN-host admin/debug commands;
- command autocomplete provider;
- optional creative/testing tools.

Target commands:

- `/help`
- `/give [amount] <item_id>`
- `/tp <target>`
- `/time <set|query> ...`
- `/weather <clear|rain|thunder>`
- `/spawn <mob_id>`
- `/spawnlist`
- `/spawnmenu`
- `/gamemode <creative|survival>` after it is fixed
- `/fly` after menu/inventory regressions are fixed

Rules:

- Console commands must work without `coop_manager`.
- Console should depend on/reuse the chat pack instead of duplicating chat UI.
- Singleplayer must remain safe: no server-only save guards, no backup prompt regression.
- LAN host commands can exist, but public dedicated servers should not expose cheats by default.

## Current Source Layout

Current development state:

- `mod/overrides` is the historical mixed pack: multiplayer, chat, debug commands, avatar work, and game overrides.
- `mod/chat_overrides` is the base chat UI shell. It can display local chat, but command execution/autocomplete currently depends on optional handlers.

Target layout:

- `mod/multiplayer_overrides` for the release multiplayer pack.
- `mod/chat_overrides` for the standalone chat pack.
- `mod/console_overrides` for the standalone console pack.
- shared code should move only after it has a clear owner and tests.

## Split Plan

1. Keep the current mixed pack as the development source until the current dirty multiplayer fixes are stabilized.
2. Build release pack names from the existing projects:
   - `mod/overrides` -> `dist/lucid-blocks-multiplayer.pck`
   - `mod/chat_overrides` -> `dist/lucid-blocks-chat.pck`
3. Create `mod/console_overrides` with a standalone command executor and build it as `dist/lucid-blocks-console.pck`.
4. Add provider hooks so chat can use multiplayer/console without hard dependencies.
5. Remove debug commands from multiplayer core or gate them behind an explicit debug-pack config.
6. Move risky avatar assets into an optional addon/fork pack.
7. Move camera/zoom hotkeys into a client visual addon or disable by default.
8. Only after this is stable, physically split `mod/overrides` into `mod/multiplayer_overrides`.

## Release Rule

If a feature can break singleplayer, expose cheats, or raise licensing questions, it does not ship in the core multiplayer package.
