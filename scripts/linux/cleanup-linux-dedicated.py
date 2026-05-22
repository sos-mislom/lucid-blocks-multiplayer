#!/usr/bin/env python3
import os
import signal
import time

SERVICE_CGROUP = "/system.slice/lucid-blocks-linux-dedicated.service"
SERVER_PREFIX = "/opt/lucid-blocks-server/proton-prefix-linux-dedicated"
PROTON_DIR = "/opt/steam-tools/proton-ge/GE-Proton10-34"

WINE_PROCESS_NAMES = {
    "services.exe",
    "steam.exe",
    "svchost.exe",
    "plugplay.exe",
    "winedevice.exe",
    "explorer.exe",
    "rpcss.exe",
    "tabtip.exe",
    "wineserver",
    "wine64",
}


def read_text(path):
    try:
        with open(path, "rb") as handle:
            return handle.read().replace(b"\0", b" ").decode("utf-8", "replace")
    except Exception:
        return ""


def read_comm(pid):
    try:
        with open(f"/proc/{pid}/comm", "r", encoding="utf-8", errors="replace") as handle:
            return handle.read().strip()
    except Exception:
        return ""


def read_env(pid):
    raw = read_text(f"/proc/{pid}/environ")
    env = {}
    for part in raw.split(" "):
        if "=" not in part:
            continue
        key, value = part.split("=", 1)
        env[key] = value
    return env


def is_target(pid):
    comm = read_comm(pid)
    cmd = read_text(f"/proc/{pid}/cmdline")
    cgroup = read_text(f"/proc/{pid}/cgroup")
    env = read_env(pid)

    if "lucid-blocks.exe" in cmd and "--lb-dedicated" in cmd:
        return True
    if "xvfb-run" in comm and "lucid-blocks.exe" in cmd and "--lb-dedicated" in cmd:
        return True
    if "Xvfb" in comm and "/tmp/xvfb-run." in cmd:
        return True
    if PROTON_DIR in cmd and ("lucid-blocks.exe" in cmd or "proton" in cmd):
        return True

    wine_prefix = env.get("WINEPREFIX", "")
    steam_compat = env.get("STEAM_COMPAT_DATA_PATH", "")
    if (wine_prefix.startswith(SERVER_PREFIX) or steam_compat == SERVER_PREFIX) and comm in WINE_PROCESS_NAMES:
        return True

    if SERVICE_CGROUP in cgroup and comm in WINE_PROCESS_NAMES:
        return True

    return False


def collect():
    current_pid = os.getpid()
    pids = []
    for name in os.listdir("/proc"):
        if not name.isdigit():
            continue
        pid = int(name)
        if pid == current_pid:
            continue
        if is_target(pid):
            pids.append(pid)
    return sorted(set(pids), reverse=True)


for sig in (signal.SIGTERM, signal.SIGKILL):
    targets = collect()
    if not targets:
        break
    for target_pid in targets:
        try:
            os.kill(target_pid, sig)
        except ProcessLookupError:
            pass
        except PermissionError:
            pass
    time.sleep(2)
