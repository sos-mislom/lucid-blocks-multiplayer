#!/usr/bin/env python3
import json
import os
import socket
import time
import urllib.request


MASTER_URL = os.environ.get("LB_MASTER_HEARTBEAT_URL", "").strip()
TOKEN = os.environ.get("LB_MASTER_TOKEN", "").strip()
STATUS_HOST = os.environ.get("LB_STATUS_HOST", "127.0.0.1")
STATUS_PORT = int(os.environ.get("LB_STATUS_PORT", "24668"))
PUBLIC_ADDRESS = os.environ.get("LB_PUBLIC_ADDRESS", "").strip()
PUBLIC_NAME = os.environ.get("LB_PUBLIC_NAME", "").strip()
PUBLIC_REGION = os.environ.get("LB_PUBLIC_REGION", "public").strip()
INTERVAL = float(os.environ.get("LB_HEARTBEAT_INTERVAL", "30"))


def query_status() -> dict:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(3.0)
    try:
        sock.sendto(b'{"type":"status"}', (STATUS_HOST, STATUS_PORT))
        data, _ = sock.recvfrom(65535)
        payload = json.loads(data.decode("utf-8", "replace"))
        return payload if isinstance(payload, dict) else {}
    finally:
        sock.close()


def post_heartbeat(payload: dict) -> None:
    if PUBLIC_ADDRESS:
        payload["address"] = PUBLIC_ADDRESS
    if PUBLIC_NAME:
        payload["name"] = PUBLIC_NAME
        payload["world_title"] = PUBLIC_NAME
    if PUBLIC_REGION:
        payload["region"] = PUBLIC_REGION
    payload["endpoint_key"] = payload.get("endpoint_key") or "%s:%s" % (payload.get("address", STATUS_HOST), payload.get("game_port", ""))

    body = json.dumps(payload).encode("utf-8")
    request = urllib.request.Request(MASTER_URL, data=body, method="POST")
    request.add_header("Content-Type", "application/json")
    if TOKEN:
        request.add_header("Authorization", "Bearer " + TOKEN)
    with urllib.request.urlopen(request, timeout=6) as response:
        response.read()


def main() -> None:
    if not MASTER_URL:
        raise SystemExit("LB_MASTER_HEARTBEAT_URL is required")
    while True:
        try:
            post_heartbeat(query_status())
            print("heartbeat ok", flush=True)
        except Exception as exc:
            print("heartbeat failed: %s" % exc, flush=True)
        time.sleep(max(5.0, INTERVAL))


if __name__ == "__main__":
    main()
