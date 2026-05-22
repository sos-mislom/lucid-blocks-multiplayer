# Linux Dedicated Deploy Helper

Use `scripts/deploy_linux_dedicated_pck.ps1` to deploy the current multiplayer
PCK to a Linux/Proton dedicated server.

The helper intentionally does three things that are easy to forget by hand:

- uploads `dist/lucid-blocks-multiplayer.pck`;
- copies the same PCK into both known Lucid Blocks mod directories:
  `/game/mods` and `/game/lucid-blocks/mods`;
- backs up old nested `.pck` files before replacing them, restarts the service,
  and waits for a sanitized status response.

It does not print player-facing endpoints. Readiness output is limited to safe
health fields such as `ok`, `boot_phase`, `players`, `tps`, and radius settings.

## Usage

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\scripts\deploy_linux_dedicated_pck.ps1 `
  -DeployFile "path\to\private\deploy.txt" `
  -ReadinessTimeoutSec 180
```

You can also pass connection parameters explicitly:

```powershell
.\scripts\deploy_linux_dedicated_pck.ps1 `
  -HostName "<server>" `
  -UserName "<ssh-user>" `
  -Password "<ssh-password>"
```

Expected success markers:

```text
PRIMARY_HASH=<sha256>
NESTED_HASH=<sha256>
STATUS_READY={"boot_phase":"ready", ... "tps_health":"good"}
active
```

## Russian Notes

Скрипт нужен, чтобы не забыть второй путь модов `lucid-blocks/mods`. На VPS
старые `.pck` в этом nested-каталоге уже ломали диагностику и могли конфликтовать
с текущим релизным паком.

Для обычного деплоя: сначала собери PCK через `scripts/build_release_packs.ps1`,
потом запусти `scripts/deploy_linux_dedicated_pck.ps1`. Если `STATUS_READY` не
появился, сервер не считается готовым для теста с другом.
