# Roadmap

This is the short public roadmap. Detailed day-by-day implementation notes should
live in issues, commits, or private notes instead of the repository root.

## MVP Gate

- Keep singleplayer working with old and new saves.
- Keep public multiplayer free of debug/cheat commands by default.
- Keep `CO-OP -> server card -> join world` stable.
- Keep server-only saves protected from normal singleplayer editing.
- Keep real screenshots and friend install docs current.

## Multiplayer

- Stabilize server-authoritative block, item, water, fire and storage actions.
- Improve reconnect and leaving-server cleanup.
- Keep client/server compatibility based on protocol version and feature gates,
  not exact build hashes.
- Continue reducing duplicate item/block edge cases with request IDs and cached
  server acknowledgements.

## Dedicated Server

- Reduce Linux/Proton rendering cost until a true no-render or native headless
  path exists.
- Keep UDP status useful for TPS, RAM, player count, packet backlog, dirty
  journal backlog and chunk ticket counts.
- Keep deploy scripts synchronized across both known Lucid Blocks mod folders.
- Document safe registry/master-server setup without publishing private
  endpoints.

## World Loading

- Continue using player/action chunk tickets for the MVP.
- Expand native multi-region support when the hook is reliable.
- Future major step: rewrite the native `LucidBlocksWorld` loader around a union
  of active region centers instead of one `center_chunk`.

## Persistence

- Keep chunk journal replay working for block, water, fire and storage changes.
- Add better compaction/snapshot tooling for long-running servers.
- Add clearer corruption recovery docs before a public release.

## Packaging

- Keep three package targets:
  - `lucid-blocks-multiplayer.pck`
  - `lucid-blocks-chat.pck`
  - `lucid-blocks-console.pck`
- Keep questionable/test avatar assets out of the public core release unless
  rights are clear.
- Decide the final project license before a broad release.
