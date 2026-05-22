#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

GODOT_BIN="${GODOT_EXPORT_BIN:-$ROOT_DIR/work/tools/godot-4.6/editor/Godot_v4.6-stable_linux.x86_64}"
DIST_DIR="$ROOT_DIR/dist"

if [[ ! -x "$GODOT_BIN" ]]; then
  printf 'Godot export binary not found or not executable: %s\n' "$GODOT_BIN" >&2
  printf 'Set GODOT_EXPORT_BIN to a Godot 4.6 export/editor binary.\n' >&2
  exit 1
fi

mkdir -p "$DIST_DIR"

build_pack() {
  local label="$1"
  local project_dir="$2"
  local output_path="$3"

  if [[ ! -d "$project_dir" ]]; then
    printf '%s project dir not found: %s\n' "$label" "$project_dir" >&2
    exit 1
  fi

  rm -f "$output_path"
  printf 'Building %s -> %s\n' "$label" "$output_path"
  "$GODOT_BIN" --headless --path "$project_dir" --export-pack "Linux/X11" "$output_path"
}

if [[ "${SKIP_MULTIPLAYER:-0}" != "1" ]]; then
  build_pack "Lucid Blocks Multiplayer" "$ROOT_DIR/mod/overrides" "$DIST_DIR/lucid-blocks-multiplayer.pck"
fi

if [[ "${SKIP_CHAT:-0}" != "1" ]]; then
  build_pack "Lucid Blocks Chat" "$ROOT_DIR/mod/chat_overrides" "$DIST_DIR/lucid-blocks-chat.pck"
fi

if [[ "${SKIP_CONSOLE:-0}" != "1" ]]; then
  if [[ -d "$ROOT_DIR/mod/console_overrides" ]]; then
    build_pack "Lucid Blocks Console" "$ROOT_DIR/mod/console_overrides" "$DIST_DIR/lucid-blocks-console.pck"
  else
    printf 'Warning: skipping console pack: mod/console_overrides does not exist yet. Chat is built separately as lucid-blocks-chat.pck.\n' >&2
  fi
fi

printf 'Done.\n'
