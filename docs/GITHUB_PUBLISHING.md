# GitHub Publishing Checklist

The repository should be published gradually. Do not publish private deployment files, passwords, IPs, ports, or server credentials.

## Attribution

- Keep `CREDITS.md` in the repository and in release archives.
- Release notes must say the project is an unofficial fork/continuation of
  `parkers0405/lucid-blocks-coop`, originally by Parker Settle / Mr_Settle.
- Do not claim the upstream co-op mod, Lucid Blocks, bundled tools, or bundled
  assets as original work.
- Preserve attribution files for third-party assets, including the default
  Sketchfab avatar attribution.
- Do not ship fan/test avatars in the public core package unless rights are
  cleared.

## Repository Shape

Recommended public structure:

```text
README.md
CREDITS.md
MOD_SPLIT.md
SERVER_ROADMAP.md
docs/
  LINUX_SERVER_RU.md
  LINUX_SERVER_EN.md
scripts/
  build_release_packs.ps1
  build_release_packs.sh
mod/
  overrides/
  chat_overrides/
native_patch/
```

Current source is still mixed. The first public release should make this clear:

- multiplayer pack is the main target;
- console pack is experimental until standalone command execution is finished;
- questionable avatar assets are not part of the public release package;
- server endpoints are private.

## Before First Push

- Remove private deployment files from the repo root.
- Check `.gitignore` for:
  - Godot `.godot/`;
  - build outputs;
  - server env files;
  - credentials.
- Search for secrets/endpoints:

```bash
rg -n "password|token|secret|deploy|[0-9]{1,3}(\\.[0-9]{1,3}){3}|port" .
```

- Check that public attribution is present:

```bash
rg -n "CREDITS|parkers0405|Mr_Settle|Sketchfab|CC BY|Mixamo" README.md CREDITS.md MOD_SPLIT.md docs
```

- Decide license. Do not publish assets with unclear rights as part of the main release.
- Build packages locally.
- Smoke-test singleplayer old save and new save.

## Release Artifacts

Recommended artifacts:

```text
lucid-blocks-multiplayer.pck
lucid-blocks-chat.pck
lucid-blocks-console.pck
README_RU.md
README_EN.md
```

Private/admin server configs should not be included in public release assets.
