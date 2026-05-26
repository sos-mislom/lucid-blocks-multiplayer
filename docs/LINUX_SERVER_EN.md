# Lucid Blocks Multiplayer: Linux Dedicated Server

This document describes how to run your own dedicated server on Linux. Public docs should not expose private addresses or ports: players should see a server name, while technical endpoints stay in private admin config.

## Status

Lucid Blocks does not currently ship a true headless server binary. The MVP dedicated server runs the game through Proton/Wine and Xvfb, while the mod switches it into server mode.

This is usable for a test VPS, but it needs more resources than a real headless server.

## Requirements

Recommended:

- Linux VPS x86_64.
- 4 vCPU or more.
- 6-8 GB RAM for a comfortable MVP.
- 20+ GB disk.
- systemd.
- Steam account with a Lucid Blocks license.

Debian/Ubuntu packages:

```bash
sudo apt update
sudo apt install -y steamcmd xvfb xauth curl unzip ca-certificates \
  wine winbind cabextract p7zip-full
```

## 1. Create A User

```bash
sudo useradd -m -s /bin/bash lucid
sudo mkdir -p /opt/lucid-blocks-server
sudo chown -R lucid:lucid /opt/lucid-blocks-server
```

Run the next commands as `lucid`:

```bash
sudo -iu lucid
```

## 2. Install The Game With SteamCMD

```bash
mkdir -p /opt/lucid-blocks-server/steam
steamcmd +force_install_dir /opt/lucid-blocks-server/game +login YOUR_STEAM_LOGIN +app_update 3495730 validate +quit
```

If Steam requires Steam Guard, do one interactive login first:

```bash
steamcmd +login YOUR_STEAM_LOGIN
```

## 3. Install The Mod

Copy the multiplayer release PCK into the game mods folder:

```bash
mkdir -p /opt/lucid-blocks-server/game/mods
cp lucid-blocks-multiplayer.pck /opt/lucid-blocks-server/game/mods/
```

Do not install the console/debug pack on a public dedicated server unless you intentionally want cheat/admin commands available.

## 4. Create Private Config

Create a config file that is not committed to GitHub:

```bash
mkdir -p "$HOME/.config/lucid-blocks-coop"
nano "$HOME/.config/lucid-blocks-coop/server.env"
```

Example:

```bash
LB_SERVER_NAME="MyLucidServer"
LB_WORLD_NAME="DedicatedWorld"
LB_GAME_PORT="CHANGE_ME"
LB_STATUS_PORT="CHANGE_ME"
LB_MAX_PLAYERS="4"
```

Open the private ports in your firewall, but do not publish them in player-facing README files.

## 5. systemd Service

First create a wrapper at `/opt/lucid-blocks-server/run_dedicated.sh`:

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

Then create `/etc/systemd/system/lucid-blocks-dedicated.service`:

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

The executable path can differ between installs. Check it with:

```bash
find /opt/lucid-blocks-server/game -iname "lucid-blocks*.exe" -o -iname "lucid-blocks*.x86_64"
```

## 6. Firewall

Open only the ports you actually expose:

```bash
# Game UDP (dedicated). Default 24667.
sudo ufw allow 24667/udp comment 'lucid-blocks game UDP'
# Status UDP for ping/admin tools. Default 24668.
sudo ufw allow 24668/udp comment 'lucid-blocks status UDP'
# Master registry HTTP. Only if you run the master on the same host.
# When you do, prefer binding it behind a reverse proxy / TLS terminator.
sudo ufw allow 8088/tcp comment 'lucid-blocks master registry'
```

If the master registry runs on the same VPS, restrict the heartbeat token
file (`/opt/lucid-blocks-master/registry.token`) to mode 600 and never
publish `master.env` / `heartbeat.env` publicly.

## 7. Start The Server

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now lucid-blocks-dedicated.service
sudo systemctl status lucid-blocks-dedicated.service --no-pager
```

systemd logs:

```bash
journalctl -u lucid-blocks-dedicated.service -f
```

Godot logs usually live inside the Proton/Wine profile. Find them with:

```bash
find /opt/lucid-blocks-server -path "*lucid blocks/logs/godot.log" -print
```

For status fields, common log markers, and troubleshooting notes, see
[SERVER_LOGS.md](SERVER_LOGS.md).

## 7. Server Registry

Players should not have to type IP/port manually. The public client should load a server list from a manifest/registry:

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

The technical endpoint should stay in private/admin config.

## Checklist

- Server starts after reboot.
- Status check returns server name, TPS and player count.
- Client connects by server name from the server browser.
- Console/debug pack is not installed on public dedicated.
- Singleplayer client still opens old and new saves without backup prompt regression.
