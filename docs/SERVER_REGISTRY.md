# Server Registry

The multiplayer client can load server cards from a private registry instead of
hardcoding live endpoints in the public PCK. Player-facing UI should show
friendly names only.

## Local Registry

Create this file in one of these locations:

```text
lucid_blocks_server_registry.json
```

The client checks, in order:

- bundled `res://coop_mod/lucid_blocks_server_registry.json`, if a private build includes one;
- the game folder;
- the game `mods` folder;
- the game user data folder.

Template:

```json
{
  "servers": [
    {
      "name": "QUALIA",
      "world_title": "QUALIA",
      "region": "private",
      "address": "<server-hostname>",
      "port": "<game-port>",
      "status_port": "<status-port>"
    }
  ]
}
```

Use real values only in your private local config or private hosted registry.
Do not paste live server addresses or ports into public docs, screenshots,
README files, release notes, or GitHub issues.

The UI uses `name`, `world_title`, `region`, status, player count, and TPS. It
does not display `address`, `port`, or `status_port` on server cards.

## Remote Registry

Set `server_registry_url` in `lucid_blocks_coop_config.json`:

```json
{
  "server_registry_url": "https://example.invalid/lucid-blocks/servers.json"
}
```

The remote JSON uses the same shape as the local registry. Keep the remote file
private unless you intentionally want to publish those endpoints.

## RU

Клиент может загружать список серверов из приватного registry/manifest, чтобы
не вшивать endpoint в публичный `.pck`.

- Локальный файл: `lucid_blocks_server_registry.json` в user data папке игры.
- Удаленный файл: `server_registry_url` в `lucid_blocks_coop_config.json`.
- В UI показываются только имя, мир, регион, статус, игроки и TPS.
- `address`, `port`, `status_port` используются только внутри клиента для
  подключения и status-запроса.
- Реальные приватные endpoint-ы не коммитим в GitHub и не кладем во friend zip.
