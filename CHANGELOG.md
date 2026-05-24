# Changelog

## v0.1.0-mvp - 2026-05-24

First public-facing MVP packaging pass.

### Added

- QUALIA-styled server browser screenshots and in-world multiplayer screenshots.
- Public README and Russian README with installation, protocol, security,
  chunk-loading and persistence notes.
- Dedicated server audit document: `docs/MVP_AUDIT_2026-05-24.md`.
- Standalone version marker: `VERSION`.

### Multiplayer MVP

- Dedicated server owns the world save.
- Clients join through `CO-OP -> AVAILABLE QUALIA`.
- Server-authoritative block, item, water, fire, storage and entity requests.
- Client/server compatibility is based on protocol version and feature gates,
  not exact cosmetic build hash.
- Client gameplay actions remain locked until the server confirms active peer
  state registration.
- Server-only save protection for dedicated worlds.

### Packaging

- Release pack targets:
  - `dist/lucid-blocks-multiplayer.pck`
  - `dist/lucid-blocks-chat.pck`
  - `dist/lucid-blocks-console.pck`
- Multiplayer pack no longer logs an error when the optional console pack is not installed.

### Known Limits

- Dedicated server still uses the game/Proton runtime and is not a true
  no-render headless server.
- Time/weather authority and mob/drop reconciliation need more multiplayer testing.
- Public release archives should not include fan/test avatar assets unless their
  rights are cleared.
