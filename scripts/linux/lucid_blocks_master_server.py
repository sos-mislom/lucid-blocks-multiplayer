#!/usr/bin/env python3
import json
import os
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


HOST = os.environ.get("LB_MASTER_HOST", "0.0.0.0")
PORT = int(os.environ.get("LB_MASTER_PORT", "8088"))
TOKEN = os.environ.get("LB_MASTER_TOKEN", "").strip()
DATA_PATH = os.environ.get("LB_MASTER_DATA", "/opt/lucid-blocks-master/servers.json")
TTL_SECONDS = int(os.environ.get("LB_MASTER_TTL", "90"))
MAX_BODY_BYTES = 64 * 1024

LOCK = threading.Lock()


def _now() -> int:
    return int(time.time())


def _safe_text(value, default="", limit=80) -> str:
    text = str(value if value is not None else default).strip()
    text = "".join(ch for ch in text if ch.isprintable())
    return text[:limit] if text else default


def _safe_int(value, default=0, min_value=0, max_value=65535) -> int:
    try:
        number = int(value)
    except Exception:
        number = default
    return max(min_value, min(max_value, number))


def _load_state() -> dict:
    try:
        with open(DATA_PATH, "r", encoding="utf-8") as handle:
            data = json.load(handle)
        return data if isinstance(data, dict) else {"servers": []}
    except FileNotFoundError:
        return {"servers": []}
    except Exception:
        return {"servers": []}


def _write_state(data: dict) -> None:
    os.makedirs(os.path.dirname(DATA_PATH), exist_ok=True)
    tmp_path = DATA_PATH + ".tmp"
    with open(tmp_path, "w", encoding="utf-8") as handle:
        json.dump(data, handle, ensure_ascii=False, sort_keys=True, indent=2)
    os.replace(tmp_path, DATA_PATH)


def _server_key(entry: dict) -> str:
    endpoint_key = _safe_text(entry.get("endpoint_key"), "", 128)
    if endpoint_key:
        return endpoint_key
    return "%s:%s" % (_safe_text(entry.get("address"), ""), _safe_int(entry.get("port"), 0))


def _public_servers() -> list:
    cutoff = _now() - TTL_SECONDS
    state = _load_state()
    output = []
    changed = False
    for raw in state.get("servers", []):
        if not isinstance(raw, dict):
            changed = True
            continue
        if int(raw.get("last_seen", 0)) < cutoff:
            changed = True
            continue
        entry = dict(raw)
        entry.pop("last_seen", None)
        entry.pop("token", None)
        output.append(entry)
    if changed:
        _write_state({"servers": output})
    return output


def _upsert_server(entry: dict) -> None:
    key = _server_key(entry)
    state = _load_state()
    servers = []
    replaced = False
    for raw in state.get("servers", []):
        if not isinstance(raw, dict):
            continue
        if _server_key(raw) == key:
            servers.append(entry)
            replaced = True
        else:
            servers.append(raw)
    if not replaced:
        servers.append(entry)
    _write_state({"servers": servers})


class Handler(BaseHTTPRequestHandler):
    server_version = "LucidBlocksMaster/1"

    def _json(self, status: int, payload: dict) -> None:
        body = json.dumps(payload, ensure_ascii=False, sort_keys=True).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Cache-Control", "no-store")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _authorized(self) -> bool:
        if not TOKEN:
            return True
        header = self.headers.get("Authorization", "")
        return header == "Bearer " + TOKEN

    def do_GET(self):
        if self.path.split("?", 1)[0] in ["/", "/servers.json"]:
            with LOCK:
                servers = _public_servers()
            self._json(200, {"servers": servers, "ttl": TTL_SECONDS, "updated_unix": _now()})
            return
        if self.path.split("?", 1)[0] == "/health":
            self._json(200, {"ok": True, "status": "ready"})
            return
        self._json(404, {"ok": False, "error": "not_found"})

    def do_POST(self):
        if self.path.split("?", 1)[0] != "/heartbeat":
            self._json(404, {"ok": False, "error": "not_found"})
            return
        if not self._authorized():
            self._json(401, {"ok": False, "error": "unauthorized"})
            return

        length = _safe_int(self.headers.get("Content-Length"), 0, 0, MAX_BODY_BYTES)
        try:
            payload = json.loads(self.rfile.read(length).decode("utf-8", "replace"))
        except Exception:
            self._json(400, {"ok": False, "error": "bad_json"})
            return
        if not isinstance(payload, dict):
            self._json(400, {"ok": False, "error": "bad_payload"})
            return

        address = _safe_text(payload.get("address"), self.client_address[0], 128)
        port = _safe_int(payload.get("game_port", payload.get("port", 0)), 0, 1, 65535)
        status_port = _safe_int(payload.get("status_port", port + 1), 0, 1, 65535)
        if port <= 0:
            self._json(400, {"ok": False, "error": "missing_game_port"})
            return

        name = _safe_text(payload.get("name"), payload.get("world_title", "QUALIA"), 40)
        entry = {
            "name": name,
            "world_title": _safe_text(payload.get("world_title"), name, 48),
            "address": address,
            "port": port,
            "status_port": status_port,
            "region": _safe_text(payload.get("region"), "public", 32),
            "status": "online" if bool(payload.get("ok", False)) else _safe_text(payload.get("status"), "checking", 32),
            "players": _safe_int(payload.get("players"), 0, 0, 256),
            "max_players": _safe_int(payload.get("max_players"), 4, 1, 256),
            "tps": float(payload.get("tps", 0.0) or 0.0),
            "tps_health": _safe_text(payload.get("tps_health"), "", 32),
            "message": _safe_text(payload.get("message"), "", 120),
            "endpoint_key": _safe_text(payload.get("endpoint_key"), "%s:%s" % (address, port), 128),
            "last_seen": _now(),
        }
        with LOCK:
            _upsert_server(entry)
        self._json(200, {"ok": True, "registered": True})

    def log_message(self, fmt, *args):
        print("%s - %s" % (self.address_string(), fmt % args), flush=True)


def main() -> None:
    os.makedirs(os.path.dirname(DATA_PATH), exist_ok=True)
    server = ThreadingHTTPServer((HOST, PORT), Handler)
    print("Lucid Blocks master registry listening on %s:%s" % (HOST, PORT), flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
