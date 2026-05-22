# Server Registry

The multiplayer client can load server cards from a private registry instead of hardcoding endpoints in the public PCK.

## Local Registry

Create this file in the game user data folder:

```text
lucid_blocks_server_registry.json
```

Example:

```json
{
  "servers": [
    {
      "name": "QUALIA",
      "world_title": "QUALIA",
      "region": "private",
      "address": "example.invalid",
      "port": 24667,
      "status_port": 24668
    }
  ]
}
```

The UI uses `name`, `world_title`, `region`, status, player count and TPS. It does not display `address`, `port`, or `status_port` on server cards.

## Remote Registry

Set `server_registry_url` in `lucid_blocks_coop_config.json`:

```json
{
  "server_registry_url": "https://example.invalid/lucid-blocks/servers.json"
}
```

The remote JSON uses the same format as the local registry.

## Notes

- Do not commit a real private registry with live endpoints.
- Do not put private registry URLs, relay tokens, passwords, or server IPs in public docs.
- If a server is moved, update the registry; players do not need a rebuilt PCK.

## RU

Клиент может загружать список серверов из приватного registry/manifest, чтобы не вшивать endpoint в публичный `.pck`.

- Локальный файл: `lucid_blocks_server_registry.json` в user data папке игры.
- Удаленный файл: `server_registry_url` в `lucid_blocks_coop_config.json`.
- В UI показываются только имя, мир, регион, статус, игроки и TPS.
- `address`, `port`, `status_port` используются только внутри клиента для подключения и status-запроса.
- Реальные приватные endpoint-ы не коммитим в GitHub.
