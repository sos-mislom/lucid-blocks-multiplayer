# Lucid Blocks Multiplayer: Linux Dedicated Server

Этот документ описывает свой dedicated-сервер на Linux. Публичные инструкции не должны раскрывать приватные адреса или порты: игрокам показываем имя сервера, а технические значения держим в private config/admin docs.

## Статус

Lucid Blocks сейчас не имеет настоящего headless server binary. MVP dedicated запускает обычную игру через Proton/Wine и Xvfb, а мод переводит ее в server mode.

Это рабочий путь для тестового VPS, но требования выше, чем у нормального headless-сервера.

## Требования

Рекомендовано:

- Linux VPS x86_64.
- 4 vCPU или больше.
- 6-8 GB RAM для комфортного MVP.
- 20+ GB disk.
- systemd.
- Steam account with Lucid Blocks license.

Пакеты Debian/Ubuntu:

```bash
sudo apt update
sudo apt install -y steamcmd xvfb xauth curl unzip ca-certificates \
  wine winbind cabextract p7zip-full
```

## 1. Создать пользователя

```bash
sudo useradd -m -s /bin/bash lucid
sudo mkdir -p /opt/lucid-blocks-server
sudo chown -R lucid:lucid /opt/lucid-blocks-server
```

Дальше команды можно выполнять от `lucid`:

```bash
sudo -iu lucid
```

## 2. Установить игру через SteamCMD

```bash
mkdir -p /opt/lucid-blocks-server/steam
steamcmd +force_install_dir /opt/lucid-blocks-server/game +login YOUR_STEAM_LOGIN +app_update 3495730 validate +quit
```

Если Steam требует Steam Guard, сначала пройди интерактивный логин:

```bash
steamcmd +login YOUR_STEAM_LOGIN
```

## 3. Установить мод

Скопируй релизный multiplayer PCK в папку модов игры:

```bash
mkdir -p /opt/lucid-blocks-server/game/mods
cp lucid-blocks-multiplayer.pck /opt/lucid-blocks-server/game/mods/
```

Не ставь console/debug pack на публичный dedicated, если не хочешь выдавать cheat/admin commands игрокам.

## 4. Создать private config

Создай конфиг, который не коммитится в GitHub:

```bash
mkdir -p "$HOME/.config/lucid-blocks-coop"
nano "$HOME/.config/lucid-blocks-coop/server.env"
```

Пример:

```bash
LB_SERVER_NAME="MyLucidServer"
LB_WORLD_NAME="DedicatedWorld"
LB_GAME_PORT="CHANGE_ME"
LB_STATUS_PORT="CHANGE_ME"
LB_MAX_PLAYERS="4"
```

Порты из private config открываются в firewall, но не пишутся в README для игроков.

## 5. systemd service

Сначала создай wrapper `/opt/lucid-blocks-server/run_dedicated.sh`:

```bash
cat >/opt/lucid-blocks-server/run_dedicated.sh <<'SH'
#!/usr/bin/env bash
set -euo pipefail

cd /opt/lucid-blocks-server/game

args=(
  "--lb-dedicated"
  "--lb-world=${LB_WORLD_NAME}"
  "--lb-port=${LB_GAME_PORT}"
  "--lb-status-port=${LB_STATUS_PORT}"
)

native_exe="$(find . -maxdepth 4 -type f \( -iname 'lucid-blocks*.x86_64' -o -iname 'lucid-blocks*.sh' \) | head -n 1 || true)"
windows_exe="$(find . -maxdepth 4 -type f -iname 'lucid-blocks*.exe' | head -n 1 || true)"

if [[ -n "$native_exe" ]]; then
  chmod +x "$native_exe"
  exec "$native_exe" "${args[@]}"
fi

if [[ -n "$windows_exe" ]]; then
  exec wine "$windows_exe" "${args[@]}"
fi

echo "Lucid Blocks executable not found" >&2
exit 1
SH

chmod +x /opt/lucid-blocks-server/run_dedicated.sh
sudo chown lucid:lucid /opt/lucid-blocks-server/run_dedicated.sh
```

Затем создай `/etc/systemd/system/lucid-blocks-dedicated.service`:

```ini
[Unit]
Description=Lucid Blocks dedicated multiplayer server
After=network-online.target
Wants=network-online.target

[Service]
User=lucid
WorkingDirectory=/opt/lucid-blocks-server/game
EnvironmentFile=/home/lucid/.config/lucid-blocks-coop/server.env
Environment=DISPLAY=:99
ExecStartPre=/usr/bin/pkill -u lucid -f "lucid-blocks.exe|wine|proton" || true
ExecStart=/usr/bin/xvfb-run -a -s "-screen 0 1280x720x24" /opt/lucid-blocks-server/run_dedicated.sh
Restart=always
RestartSec=10
TimeoutStopSec=60

[Install]
WantedBy=multi-user.target
```

В некоторых установках путь к executable отличается. Проверь:

```bash
find /opt/lucid-blocks-server/game -iname "lucid-blocks*.exe" -o -iname "lucid-blocks*.x86_64"
```

## 6. Запуск

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now lucid-blocks-dedicated.service
sudo systemctl status lucid-blocks-dedicated.service --no-pager
```

Логи systemd:

```bash
journalctl -u lucid-blocks-dedicated.service -f
```

Логи Godot обычно лежат в Proton/Wine profile. Найти:

```bash
find /opt/lucid-blocks-server -path "*lucid blocks/logs/godot.log" -print
```

## 7. Server Registry

Для игроков лучше не раздавать IP/port вручную. Публичный клиент должен получать список серверов из manifest/registry:

```json
{
  "servers": [
    {
      "name": "MyLucidServer",
      "region": "EU",
      "hidden_endpoint_key": "my-lucid-server"
    }
  ]
}
```

Технический endpoint держится отдельно на стороне private/admin config.

## Checklist

- Server starts after reboot.
- Status check returns server name, TPS and player count.
- Client connects by server name from server browser.
- Console/debug pack is not installed on public dedicated.
- Singleplayer client still opens old and new saves without backup prompt regression.
