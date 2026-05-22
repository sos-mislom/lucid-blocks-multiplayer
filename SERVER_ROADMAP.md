# Lucid Blocks Coop Dedicated Server Roadmap

Attribution note for public publishing: this repo is an unofficial
fork/continuation of `parkers0405/lucid-blocks-coop`, originally by Parker
Settle / Mr_Settle. Public releases must keep `CREDITS.md` and must not present
upstream work, Lucid Blocks, third-party tools, or third-party assets as our
original work.

Живой план доработки dedicated/multiplayer-мода. Этот файл - единая точка правды:
что строим, зачем, какие механики берем из Minecraft-подхода, какие этапы считаются
MVP, а какие относятся к хорошему релизу.

Последнее обновление: 2026-05-23.

## Цель

### MVP Night Build

Dedicated-сервер Lucid Blocks для 2-4 игроков, который можно открыть во вкладке серверов,
нажать на сервер и сразу подключиться к миру.

Критерии MVP:

- 2 игрока играют 60 минут без ручного мерджа сейвов.
- Сервер держит 50-60 TPS в обычной игре.
- Блоки ломаются и ставятся у подключенного игрока.
- Инвентарь, дропы, уровни/награды и смерть не расходятся между клиентами.
- Серверный мир нельзя нормально открыть локально в singleplayer и испортить сейв.
- Singleplayer без мода-сессии работает как раньше.
- Есть понятные логи, status-запрос и инструкция для друга.
- Релизный пакет не тащит debug/cheat-команды, спорные аватары и экспериментальные camera hotkeys.
- Singleplayer old/new saves не получают backup-warning, рассинхрон или server-only ограничения из-за установленного мода.

### Good Release

Dedicated-сервер для 6-8 игроков, с chunk journal, region/ticket loading,
interest management, приоритетной сетью и soak-тестами.

Критерии хорошего релиза:

- 6-8 игроков могут расходиться по миру без заморозки дальних зон.
- Сервер не рассылает всем игрокам все сущности/дропы/патчи.
- Dirty chunks сохраняются пакетно, без постоянного полного save.
- После краша можно восстановить последние block patches.
- TPS degradation graceful: блоки и инвентарь остаются приоритетными.
- Админ видит TPS, RAM, players, packet/backlog, dirty chunk count.

## Release Hygiene / Mod Split

Цель: отделить играбельный кооп от debug/fork-фич, чтобы MVP можно было дать друзьям без риска сломать singleplayer или случайно включить читы.

## Git / Release Discipline

Goal: every playable/deployed state must be reproducible from Git.

- Keep work split into small commits by concern: docs, build tooling, gameplay fix, deploy script, release metadata.
- Do not commit unrelated dirty worktree changes when continuing a roadmap item.
- Never push secrets, deployment passwords, private IPs, Steam credentials, private relay tokens, or private endpoint maps.
- Every GitHub prerelease must point at the commit that produced its PCK/zip assets.
- Every deployed VPS PCK must have its SHA256 recorded in this roadmap decision log.
- After deploying to VPS, verify service state, relay state, opened UDP sockets, and deployed PCK hash.
- If a release is rebuilt, create a new tag instead of silently replacing old release assets.
- Keep upstream attribution in `README.md` and `CREDITS.md`; do not present upstream work or third-party assets as ours.
- Before each public/friend release, run the release hygiene checks:
  - no private endpoints in README/docs/PCK strings;
  - no debug/fan avatar assets in public PCK;
  - build exits cleanly without `SCRIPT ERROR`;
  - server starts from systemd after restart.

Обязательные правила для релизного coop-пака:

- Core coop pack содержит только multiplayer/dedicated, server browser, chat, player list и минимальный avatar marker.
- Console/debug pack выносится в отдельный `.pck`: `/give`, `/gamemode`, `/spawn`, `/spawnlist`, `/spawnmenu`, `/time`, `/weather`, `/kill`, `/fly` и любые cheat/test команды.
- `/gamemode` не входит в релизный core pack, пока не станет server-authoritative и не перестанет ломать inventory/Escape/game menu.
- Avatar/character UI оставляем в одном виде: предпочтительно `/char-select` как пользовательский экран, а `/avatar <id>` либо alias, либо только debug command.
- Для публичного релиза оставить только безопасный дефолтный blocky humanoid avatar с корректной атрибуцией. `pim`, `charlie`, `mr_frog` и любые спорные/фановые ассеты - только optional fork/addon pack.
- Camera hotkeys `V`/`C`, third-person/zoom overhaul и подобные client visuals оформить отдельным client-side visual mod pack или отключаемым config-флагом. Core coop не должен менять управление singleplayer.
- Chat autocomplete должен быть context-aware: после `/give 1 s` предлагать item id, а не вставлять весь `/give 1 /give 1 ...`; `/host` не должен автодополняться в `/join`.
- Server browser показывает публичные серверы по именам, без раскрытия адресов/портов в UI, README и friend-инструкции. Технические адреса остаются только в private admin docs/config.
- Auto server discovery должен грузить список серверов из remote manifest/registry, чтобы добавлять серверы без пересборки клиента.
- Save & Exit в multiplayer должен сразу показывать понятный overlay выхода из мира, отправлять leave/disconnect и не подвешивать игрока на скрытой загрузке.
- Любая server-only защита сейва должна срабатывать только для серверного мира/сессии и не трогать обычные singleplayer saves.

## Что уже есть

- Dedicated mode через `--lb-dedicated`.
- UDP status endpoint.
- Серверная вкладка в меню с публичным сервером.
- Server-only world marker.
- Chat, Tab/player list, базовые player markers.
- Server-authoritative направление для block actions.
- Dedicated-lite оптимизация:
  - не генерировать item icons;
  - не preload-ить все item scenes;
  - не preload-ить fusion vectors/table;
  - не готовить avatar visuals/sounds на dedicated;
  - default dedicated streaming radius `80/80`.
- Локальный Windows-тест:
  - status: `good/r80/b80/tps60`;
  - пик примерно `2.6 GB RAM`;
  - watchdog limit: `3200 MB`.

## Главная архитектурная идея из Minecraft

Minecraft-сервер не пытается держать весь бесконечный мир активным одинаково.
Он делит мир на чанки, отдельно решает:

- какие чанки загружены;
- какие чанки тикают/симулируются;
- какие чанки только видимы клиенту;
- какие сущности отслеживает каждый игрок;
- какие изменения надо сохранить на диск;
- какие сетевые пакеты важнее.

Для Lucid Blocks нам нужен такой же принцип, но адаптированный под текущую игру:
сервер не “второй игрок-хост”, а authoritative world coordinator.

## Minecraft-подходи, которые переносим

### 1. View Distance vs Simulation Distance

Идея:

- View radius: что клиенту нужно видеть/получить как данные.
- Simulation radius: что сервер реально тикает.

Для Lucid Blocks:

- Клиент может видеть/получать блок-патчи и remote entities в радиусе.
- Сервер тикает только активные области вокруг игроков и временных tickets.
- Дальние зоны не должны держать water/fire/mobs на полной частоте.

Практический план:

- Ввести `server_view_radius`.
- Ввести `server_simulation_radius`.
- В status payload добавить оба значения.
- Для dedicated не использовать пользовательский render distance как серверный budget.

### 2. Chunk Tickets

Идея:

Чанк загружается не “навсегда”, а потому что есть причина:

- player ticket;
- block action ticket;
- entity ticket;
- portal/dimension ticket;
- short-lived save/load ticket.

Для Lucid Blocks:

- Player ticket: область вокруг каждого активного игрока.
- Action ticket: игрок ломает/ставит блок, сервер временно грузит этот чанк.
- Drop/entity ticket: короткое удержание зоны, если там только что был важный дроп/моб.
- Dimension ticket: временная загрузка перехода/respawn/pocket dimension.

Практический план:

- Создать `ChunkTicket` модель на стороне `coop_manager.gd`.
- Хранить tickets по ключу `dimension_instance_key + chunk_pos`.
- Каждый ticket имеет:
  - `kind`;
  - `owner_peer_id`;
  - `priority`;
  - `expires_at_msec`;
  - `simulation_enabled`.
- Сначала реализовать tickets на GDScript-уровне как load focus scheduler.
- Потом перенести в native multi-region patch.

### 3. Region/Chunk Journal

Идея:

Minecraft хранит чанки отдельно, а сервер сохраняет изменившиеся chunks, а не
переписывает весь мир после каждого действия.

Для Lucid Blocks:

- Не мерджить целые сейвы игроков.
- Сервер - единственный источник block changes.
- Изменения пишутся в chunk journal:
  - `dimension_instance_key`;
  - `chunk_pos`;
  - `block_pos`;
  - `old_block_id`;
  - `new_block_id`;
  - `sequence`;
  - `timestamp`;
  - `source_peer_id`.

Практический план:

- Ввести append-only `chunk_journal`.
- В памяти держать `dirty_chunks`.
- Flush каждые N секунд или N изменений.
- При подключении игрока:
  - отправить save snapshot;
  - затем отправить missing journal patches по нужным chunks.
- При краше:
  - replay журнала поверх последнего save.

### 4. Interest Management / Entity Tracking

Идея:

Игрок получает обновления только тех сущностей, которые ему интересны.
Minecraft/Paper имеют tracking ranges для разных типов сущностей.

Для Lucid Blocks:

- Player state: всем в той же dimension/instance, но с rate limit.
- Mobs: только игрокам рядом.
- Drops: только игрокам рядом.
- Projectiles/attacks: высокий приоритет, короткая жизнь.
- Visual effects: низкий приоритет.

Практический план:

- Ввести AOI-сетку по chunks/cells.
- Для каждого клиента строить `interest_set`:
  - nearby players;
  - nearby mobs;
  - nearby drops;
  - nearby block patches;
  - critical global events.
- Дальние entities:
  - не слать каждый tick;
  - слать heartbeat;
  - либо freeze, если рядом нет игроков.

### 5. Priority Network Pipeline

Идея:

Когда сервер проседает, нельзя одинаково резать все пакеты.

Приоритеты:

- P0 critical:
  - connect/disconnect;
  - block break/place result;
  - inventory transaction;
  - death/respawn;
  - level/reward grant.
- P1 gameplay:
  - player position/action;
  - entity hit/death;
  - pickup/drop state.
- P2 world ambience:
  - water/fire updates;
  - weather/time;
  - far mob states.
- P3 cosmetic:
  - particles;
  - transient projectiles if already expired;
  - emotes/voice/visual-only events.

Практический план:

- Вынести интервалы sync в budget manager.
- При `tps < 50`:
  - уменьшить water/fire frequency;
  - уменьшить far entity frequency;
  - не трогать P0.
- При `tps < 42`:
  - включить hard backpressure;
  - временно freeze far mobs;
  - ограничить drops per area.

### 6. Server-Authoritative Transactions

Идея:

Клиент не “делает мир”, а отправляет намерение.
Сервер проверяет и подтверждает результат.

Для Lucid Blocks:

- Клиент: `request_break_block`.
- Сервер:
  - проверяет world authority;
  - проверяет distance/tool/dimension;
  - загружает нужный chunk/ticket;
  - применяет block change;
  - пишет journal;
  - отправляет result + patch заинтересованным игрокам.

То же для:

- place block;
- pickup;
- drop item;
- inventory move;
- mob damage;
- reward/level grant.

### 7. Autosave Strategy

Идея:

Не сохранять весь мир слишком часто, но и не терять действия.

Для Lucid Blocks:

- Journal пишет часто и дешево.
- Full save пишет редко.
- Dirty chunk flush пишет пакетно.

Практический план:

- `journal_append`: сразу или micro-batch до 250 ms.
- `dirty_chunk_flush`: каждые 5-15 секунд.
- `full_save`: каждые 5-15 минут или clean shutdown.
- `shutdown_save`: блокирует выход до flush.

### 8. Watchdog / Health Model

Сервер считается здоровым, если:

- status UDP отвечает;
- `tps_health=good` или `ok`;
- RAM ниже лимита;
- `dirty_journal_backlog` ниже лимита;
- `packet_backlog` ниже лимита;
- save flush не завис.

Практический план:

- Добавить в status:
  - `ram_mb` если доступно;
  - `dirty_chunks`;
  - `journal_backlog`;
  - `packet_backlog`;
  - `loaded_regions`;
  - `entity_count`;
  - `drop_count`.
- Watchdog:
  - soft restart при runaway RAM;
  - graceful save before restart;
  - hard kill только если graceful timeout.

## Roadmap

### Phase 0 - Stabilize Current MVP

Цель: 2 игрока, 60 минут, без поломки singleplayer.

- Срочно проверить singleplayer regression:
  - old save не должен предлагать backup только из-за мода;
  - new save создается и синхронизирует обычные игровые данные;
  - server-only world guard не включается вне dedicated/active coop session;
  - backup prompt, inventory, Escape menu и save flow работают как в ваниле.
- Проверить fresh install + public zip.
- Проверить кнопку server browser: QUALIA server -> immediate connect.
- Проверить block break/place за гостя.
- Проверить inventory pickup/drop.
- Проверить level/reward для всех игроков.
- Проверить death/respawn/reconnect.
- Проверить server-only world guard.
- Проверить singleplayer после всех overrides.
- Убрать из core релизного пака debug/cheat-команды или полностью закрыть их config-флагом.
- Исправить autocomplete:
  - `/give 1 s` -> item suggestions only;
  - не дублировать command prefix;
  - `/host` не должен предлагать `/join`;
  - подсказки должны соответствовать реально доступным core/debug командам.
- Отключить/вынести `/gamemode` до исправления поломки inventory/Escape.
- Сделать `Save and Exit` multiplayer overlay: "Leaving server..." + немедленный leave session + возврат в меню после cleanup.

Definition of done:

- 2 игрока играют 60 минут.
- Нет дюпа инвентаря.
- Нет потери block patches.
- `tps_health=good/ok`.
- Singleplayer old/new saves проходят smoke-test без backup-warning/regression.

### Phase 1 - Dedicated Observability

Цель: понимать, хватает ли сервера.

- Расширить status payload:
  - RAM;
  - TPS;
  - players;
  - entity/drop count;
  - dirty chunks;
  - packet/send rates;
  - loaded radius/regions.
- Добавить readable log markers:
  - server start;
  - world loaded;
  - peer joined;
  - peer ready;
  - chunk patch flush;
  - autosave;
  - watchdog restart reason.
- Сделать `logs/README.md` с командами просмотра.

Definition of done:

- По одному status-запросу понятно, сервер живой или нет.
- По логам понятно, почему сервер перезапустился.

### Phase 2 - Authoritative Block/Inventory Pipeline

Цель: убрать “клиент сделал, сервер потерял”.

- Перевести block break/place на transaction ids.
- Сервер подтверждает success/fail.
- Клиент откатывает predicted action, если fail.
- Добавить server->client reconciliation для chunk/block divergence:
  - серверный chunk/block hash по активной области;
  - клиентский mismatch report;
  - authoritative resync конкретных позиций/чанков;
  - опционально ghost/translucent preview для predicted blocks до подтверждения сервера.
- Pickup/drop/inventory сделать транзакциями.
- Rewards/levels только от сервера.

Definition of done:

- Нет ситуации “у одного блок сломан, у другого нет”.
- При рассинхроне клиент сам ресинхронизируется, а не продолжает играть в другом состоянии мира.
- Нет дропа, который подняли два игрока.
- Нет расхождения уровней/tiamana/hate.

### Phase 3 - Chunk Journal

Цель: прогресс мира хранится по chunks, а не через ручной merge.

- Добавить journal file format.
- Добавить dirty chunk map.
- Добавить flush scheduler.
- Добавить replay on startup.
- Добавить compact/snapshot after full save.

Definition of done:

- После crash/restart последние block changes восстанавливаются.
- Save не блокирует игру слишком часто.

### Phase 4 - Interest Management

Цель: 4+ игроков без сетевого шума.

- AOI grid/cell index.
- Per-client entity interest sets. [started: world-state snapshots are now per active same-instance peer]
- Drop sync radius. [started: drop spawn RPC is now sent only to nearby interested peers]
- Far entity low frequency heartbeat.
- Water/fire throttling by area.
- Metrics: `interest_peers`, `interest_drops`, `interest_entities`, `interest_spawn_drop_sends`.

Definition of done:

- 4 игрока не получают все entities всего мира.
- Packet/send rate растет медленнее, чем `players * all_entities`.

### Phase 5 - Multi-Region Native Loader

Цель: игроки могут расходиться далеко.

- Изучить предоставленный `world.cpp/world.h`.
- Найти single-center ограничения:
  - `center_chunk`;
  - `is_chunk_in_radius`;
  - chunk unload policy;
  - dynamic simulation region.
- Ввести active region centers/tickets.
- Hook/patch:
  - chunk loaded if inside union of regions;
  - unload only if outside all regions;
  - simulate only ticketed/active regions.
- Сохранить singleplayer code path без изменений.

Definition of done:

- 2 игрока далеко друг от друга оба могут ломать блоки.
- Мобы рядом с каждым игроком не freeze из-за другого центра.
- Singleplayer render distance работает как раньше.

### Phase 6 - Release Polish

Цель: MVP можно дать друзьям.

- Каноничный/safe blocky humanoid avatar.
- `/char-select` оставить как единственный user-facing выбор персонажа; `/avatar` оставить alias только если не путает UI.
- Вынести спорные аватары (`pim`, `charlie`, `mr_frog`) в optional fork/addon pack или убрать из public zip.
- Вынести console/debug commands в отдельный debug `.pck`.
- Вынести `V`/`C` camera/zoom hotkeys в отдельный client visual `.pck` или config-disabled by default.
- Server browser:
  - показывает friendly server names;
  - не показывает IP/port обычному игроку;
  - грузит registry/manifest для автоматического добавления серверов;
  - при клике сразу подключает к выбранному миру.
- Public/private release zips.
- Friend install guide.
- Server admin guide.
- Known issues.
- GitHub release notes.

## Не ломать singleplayer

Правило:

- Любая dedicated-оптимизация должна быть gated через:
  - `dedicated_server_enabled`;
  - `is_dedicated_server_mode()`;
  - active multiplayer session checks.
- Любой override ванильного `main/` скрипта должен иметь явный singleplayer smoke-test или быть вынесен из core pack.
- Client-only visual changes, camera modes, zoom hotkeys and avatar extras must be opt-in, not forced into the core coop install.
- Singleplayer не должен получать:
  - dedicated radius override;
  - lazy-load пропуски, если они меняют обычную игру;
  - server-only restrictions для обычных saves.
- Если игра показывает backup prompt после установки core coop pack, это считается blocker до MVP.

Перед релизом:

- Запустить singleplayer old save.
- Создать new save.
- Проверить базовые механики:
  - break/place;
  - inventory;
  - mobs;
  - level/rewards;
  - dimensions/pocket/challenges, если доступны.
- Проверить Escape, inventory menu, save and exit, backup prompt.

## Метрики успеха

MVP target:

- Players: 2-4.
- TPS: 50-60.
- RAM Windows dedicated: <= 3.2 GB steady.
- Join time: < 60 seconds after server ready.
- Block action round-trip: subjectively instant, target < 150 ms on LAN/VPS.
- No inventory dupes in 60-minute test.

Good release target:

- Players: 6-8.
- TPS: 45-60 under normal load.
- RAM: predictable, no unbounded climb.
- Far-apart players supported via multi-region loader.
- Crash recovery loses at most a few seconds of block actions.

## Research Notes: Minecraft/Paper

Переносимые механики:

- Разделять видимость и симуляцию.
- Использовать chunk tickets вместо одного центра мира.
- Хранить и сохранять chunks/regions инкрементально.
- Отслеживать entities per-player/per-area, а не глобально.
- Иметь priority network pipeline.
- Иметь backpressure при TPS просадке.
- Иметь health/status endpoint для watchdog/admin.

Непереносимое напрямую:

- Lucid Blocks native world loader сейчас single-center.
- Нет готового headless server binary.
- Сейв-формат и симуляции игры не проектировались как серверные.
- Linux Proton зависает до нашего dedicated-кода; для MVP нужен Windows host/VPS.

## Sources

- Minecraft protocol notes, chunk data and packets: https://wiki.vg/Protocol
- Minecraft region/chunk storage background: https://minecraft.wiki/w/Region_file_format
- Minecraft chunk loading/tickets overview: https://minecraft.wiki/w/Chunk
- Paper documentation: https://docs.papermc.io/paper/
- Paper world/default configuration reference: https://docs.papermc.io/paper/reference/world-configuration
- Paper global configuration reference: https://docs.papermc.io/paper/reference/global-configuration

## Decision Log

### 2026-05-23

- Release direction changed: core coop must be clean and friend-safe; debug/cheat/visual experiments move to separate packs or opt-in config.
- Repository publishing direction:
  - public repo exposes three packages: `lucid-blocks-multiplayer.pck`, `lucid-blocks-chat.pck` and `lucid-blocks-console.pck`;
  - current mixed source remains the development source until the dirty multiplayer fixes are stabilized;
  - `mod/chat_overrides` becomes the standalone chat pack;
  - `mod/console_overrides` must become the console pack, with standalone command execution;
  - Linux dedicated server docs must exist in Russian and English.
- Chat direction:
  - chat UI/history/input/autocomplete shell should be reusable without multiplayer;
  - multiplayer should use chat as a provider/client UI, not own debug commands;
  - console should provide slash command execution/autocomplete on top of chat.
- Console/debug commands are not part of core MVP until they are split:
  - `/give`, `/gamemode`, `/spawn`, `/time`, `/weather`, `/kill`, `/fly` belong in a debug/fork pack.
  - `/gamemode` is a blocker because it currently breaks inventory/Escape/menu behavior.
- Character customization should expose one user-facing path, preferably `/char-select`; `/avatar` should be alias/debug only.
- Public package should avoid questionable avatar assets. Keep safe default avatar; put `pim`, `charlie`, `mr_frog` into optional fork/addon or remove them from public zip.
- `V`/`C` camera/zoom behavior should be treated as a separate client visual mod, not mandatory coop behavior.
- Server UI must hide technical endpoint details from normal players. Use server names; keep addresses/ports in private admin docs/config.
- Server list should become remotely discoverable via manifest/registry so servers can be added without rebuilding the mod.
- Server browser card details should never show player-facing IP/port; cards show friendly name, region, status, players and TPS only.
- Server registry support started: client can merge built-in entries, local `user://lucid_blocks_server_registry.json`, and optional remote `server_registry_url`.
- Core multiplayer now gates console/debug commands by default with `enable_debug_console_commands=false`; `/give`, `/gamemode`, `/spawn`, `/spawnlist`, `/spawnmenu`, `/time`, `/weather`, `/kill` and `/fly` are hidden from autocomplete/help and rejected unless explicitly enabled for a dev/debug build.
- Chat autocomplete now treats full-command suggestions as replacements, fixing the `/give 1 /give 1 ...` duplicated insertion class of bugs.
- Player inventory drops now use a reliable same-instance direct spawn event plus a short client-side grace window, so a drop thrown by the second connected player should not disappear before the observer receives the next filtered world-state snapshot.
- Dedicated status now binds early and reports `ok=false/status=<boot_phase>` before the ENet host is ready, so deploy checks can distinguish "mod booted and world is loading" from "game process is alive but the mod never reached `_ready()`".
- Dedicated status now polls UDP from a small status thread, so health checks can respond even while the main thread is busy in world/bootstrap work.
- Chunk divergence is now a tracked gameplay blocker. Plan is authoritative hash/reconcile/resync, with optional ghost/translucent predicted blocks as UX.
- Singleplayer backup prompt/regression is highest priority before further release packaging.

### 2026-05-22

- MVP target is 2-4 players, not public Discord release.
- Dedicated baseline uses `load_radius=80`, `buffer_radius=80`.
- `48` and `64` dedicated radii can crash during world bootstrap on some seeds.
- Linux VPS Proton dedicated is now technically booting and hosting, but still creates visual chunk renderer load through llvmpipe.
- Windows/Windows VPS remains the safer MVP hosting target until dedicated no-render/native visual chunk suppression is done.
- Next work should prioritize authoritative block/inventory pipeline and observability before native multi-region.
- Relay backhaul migrated to an optional QUIC path:
  - public clients still use Godot ENet UDP through the named public entry;
  - the Windows dedicated host can connect to the VPS relay over the private QUIC path;
  - old TCP relay remains available as `-UseTcpRelay` fallback;
  - QUIC is intentionally outside the in-game `MultiplayerPeer` for now to avoid rewriting all Godot RPC paths before MVP stability.
- Phase 1 observability started:
  - UDP status now exposes runtime metrics for entities, drops, pending patches, Godot memory, object/node/resource counts and autosave state.
  - Dedicated prints a health marker every 30 seconds.
  - Dedicated logs peer connect/disconnect and autosave start/finish markers.
  - Added `release_artifacts/lucid_blocks_dedicated/SERVER_LOGS.md`.
- Phase 2 authoritative block pipeline started:
  - Client block place/break/foliage actions now get local transaction ids.
  - Server sends block action success/fail acks.
  - Client clears successful pending actions and rolls back/resyncs failed or timed-out actions.
  - Dedicated logs block action result, reason and latency.
  - Status runtime includes block action counters and pending client action count.
- Phase 2 item/drop pipeline started:
  - Client drop/pickup requests now get local transaction ids.
  - Server sends item action success/fail acks.
  - Client clears successful pending item actions and requests resync on fail/timeout.
  - Dedicated logs item action result, reason and latency.
  - Status runtime includes item action counters and pending item action count.
  - Inventory rollback layer is now started:
    - Drop actions capture the local inventory before removing the dropped item.
    - Pickup actions capture primary/secondary pickup inventories before predicted accept.
    - Failed or timed-out drop/pickup actions restore captured inventory state and request a host snapshot.
    - Failed drop removes the predicted local drop; failed pickup clears pending pickup receipts and restores a local drop placeholder when possible.
  - Server-side duplicate protection is now active for block and item/drop transactions:
    - recent block action results are cached by peer/request/action and replayed for duplicate RPCs;
    - recent item action results are cached by peer/request/action and replayed for duplicate RPCs;
    - result caches expire automatically and are exposed in status/health metrics.
  - Phase 3 chunk journal started:
    - successful authoritative block actions append JSONL records under the server profile;
    - dirty chunks are tracked in memory and exposed through UDP status/health logs;
    - duplicate block RPCs replay cached results without appending duplicate journal entries.
    - dedicated startup replays journal records for the active world/instance before publishing status;
    - dedicated can temporarily focus world loading for journal replay even before players connect;
    - dirty chunks trigger a dedicated-only save/compact flush every 15 seconds.
  - Dedicated player anchor no longer keeps or collects inventory:
    - player inventories are purged in dedicated mode;
    - player behavior processing is disabled recursively;
    - stale dedicated player inventory save keys are erased on boot/safety pass.
  - Phase 4 interest-management guardrails started:
    - server world-state snapshots are sent per active same-instance peer;
    - entity visual-state throttling is tracked per peer/entity, not globally per entity;
    - drop spawn RPCs are sent only to nearby interested peers, with snapshots covering late/nearby visibility;
    - UDP status runtime exposes interest counters.
  - Client responsiveness hotfix:
    - block place now predicts locally immediately and is also applied on server ack;
    - failed place rolls back the predicted block and restores inventory;
    - block break now creates non-collectable predicted drops until the server drop arrives;
    - dedicated entity snapshot rate raised to 12.5 Hz and entity sync radius reduced to 112.
  - Dedicated mob simulation hotfix:
    - dedicated servers now force host entity runtime while players are connected, regardless of window focus;
    - status runtime exposes `host_entity_activity_override`.
  - Client mob render LOD started:
    - clients only instantiate full synced mob scenes when the mob position is inside the locally loaded world area;
    - out-of-loaded-area mob snapshots are represented by lightweight dummy boxes;
    - dummy/full mob nodes are pruned through the normal interest visibility path.
  - Server-authoritative pickup hotfix:
    - player pickup behavior now routes synced drops through the server instead of accepting them locally;
    - dedicated block-break drops are explicitly collectible and merge-disabled before broadcasting.
  - Water sync hotfix:
    - client-side queued dynamic refresh now actually runs for received water/fire cell updates;
    - server-applied water changes mark affected chunks dirty for dedicated flush/save.
  - Hitch reduction pass:
    - dedicated dirty chunk flush interval raised from 15s to 60s to reduce save stalls during play;
    - water/fire sync radius and rescan frequency reduced;
    - initial water/fire sync now sends nonzero cells only instead of flooding clients with empty cells.
  - Current deployed Windows dedicated test world: `ManualTest7` behind the named public test entry.
    - `ManualTest5` is preserved but currently reopens into a bad post-teleport/chunk-loading state.
  - Current deployed Linux dedicated test world: `LinuxLow` behind the named public test entry.
    - service: `lucid-blocks-linux-dedicated.service`;
    - permanent Linux launch now uses Godot `--headless` under tiny `xvfb-run` screen `64x64x24`;
    - idle status responds with `ok=true`, `tps=60.0`, `load_radius=16`, `buffer_radius=16`;
    - both string `status` and JSON `{"type":"status"}` UDP status requests are supported;
    - verified sockets are open for both game ENet and status checks;
    - dedicated host startup now requires a real live ENet peer before publishing status, so the browser cannot show a fake-ready server;
    - headless dedicated can host after world load even when `Ref.main.loaded` remains false under Proton;
    - systemd now has a dedicated cleanup script for orphaned Proton/Wine child processes on restart;
    - idle memory is still high, around `1.5 GB`, because the game still loads full world resources under Proton even in headless mode;
    - known log noise: Godot GLES3 shader instance buffer errors; next optimization target is true dedicated no-render/native visual chunk suppression;
    - Steamworks is bypassed only for `--lb-dedicated` boot so the Linux server no longer requires a running Steam client;
    - the experimental native no-render GDExtension is disabled on the Linux VPS for now: with it loaded under Proton, world boot crashes at `Loading world chunks...` with `Cannot find instance binding callbacks for class 'World'`.
  - Server browser now includes a second default public entry by friendly name only. Technical endpoints belong in private admin config/docs, not player-facing docs.
  - Latest local/deployed PCK hash: `D4F56302CE8ED678F6C66057EF14D1DC2DC933AA63508E8A04D68A2F300238A4`.
  - GitHub prerelease `v0.1.3-mvp` is published with the sanitized multiplayer PCK, friend-ready zip, and server registry docs.
  - Friend install guide added at `docs/FRIEND_INSTALL_RU.md`; player-facing docs keep private endpoint details hidden.
  - Multiplayer export script now writes to a temporary PCK first and replaces the release artifact only after a successful export.
  - Remote player proxy no longer inherits the full local `Player` script; export is clean without `RemotePlayerProxy/Player` parse errors.
  - Linux cleanup script now removes Proton/Wine child processes by dedicated cgroup and Proton prefix, preventing leftover `winedevice/rpcss/tabtip` after service restart.
  - Server registry MVP added: local `user://lucid_blocks_server_registry.json` plus optional remote `server_registry_url`; server cards hide raw endpoints.
  - Latest local debug-gated PCK hash: `3A3179BA4FCBC081720480E678AAB47B55544385AEA36D9373A066B53D4991E4`.
  - Latest local player-drop visibility PCK hash: `F058A1C4DED4F1827B0FAB51A2D4EBF12CF934B7EDF89DBE66476223C19C88D2`.
  - Latest local early-status diagnostic PCK hash: `5E1B35A74948BB4359A67042E1E69553F7A3C4A23B81838C1993785B5802A272`.
  - Latest local threaded-status diagnostic PCK hash: `FB56C7C02AE169DBC8FD72F19A3D4182776FCA3E2DB19EF85C6DDF96C8FFDE90`.
  - VPS deploy of the debug-gated PCK was attempted but not kept: local status readiness timed out after restart, so the VPS PCK was rolled back to `D4F56302CE8ED678F6C66057EF14D1DC2DC933AA63508E8A04D68A2F300238A4` while the launch/readiness issue is investigated.
  - Latest native DLL hash, currently kept disabled on Linux VPS: `90603A319475355D73A8661A5DFC948F3AAFFBBD453209CC7CD3C6E5DBA24164`.
