# Lucid Blocks Multiplayer

Неофициальный форк/продолжение community co-op мода для Lucid Blocks с упором на выделенный сервер, список публичных QUALIA-серверов, чат и админские инструменты.

Проект не является официальной частью Lucid Blocks. Для игры нужна легальная Steam-копия.

![Главное меню с вкладкой CO-OP](docs/assets/screenshots/main-menu-qualia.png)

## Что внутри

- `lucid-blocks-multiplayer.pck` - основной multiplayer-пакет: серверный мир, подключение к выделенному серверу, список серверов, чат, список игроков, роли админов.
- `lucid-blocks-chat.pck` - отдельный чат без чит-команд.
- `lucid-blocks-console.pck` - отдельный console/debug/admin-пакет для singleplayer/LAN и строительства тестовых миров.

Сейчас главный MVP - `lucid-blocks-multiplayer.pck`.

## Как это работает

Подробно: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

- Игровая сессия сейчас работает через Godot high-level multiplayer RPC поверх ENet/UDP.
- QUIC в текущем MVP не реализован.
- Dedicated-сервер владеет миром и применяет изменения блоков, предметов, воды, огня, хранилищ и мобов.
- Клиент не должен напрямую менять серверный мир: он отправляет request, сервер валидирует действие, применяет его и присылает ack/resync.
- Server browser берет список QUALIA из локального `user://lucid_blocks_server_registry.json` и/или удаленного registry/master-server.
- Status/health endpoint отвечает JSON по UDP и показывает `players`, `tps`, `ram_mb`, `packet_backlog`, `dirty_journal_backlog`, `chunk_ticket_count`.
- Мир грузится через player/action chunk tickets: вокруг игроков и важных действий сервер временно держит активные области.
- Полная native-перепись `LucidBlocksWorld` под несколько центров загрузки пока остается следующим крупным этапом.

## Безопасность

- Debug/cheat команды выключены по умолчанию.
- Builder-команды выполняются только сервером и только для админов.
- Серверные сейвы помечаются как server-only, чтобы их не открывали и не меняли через singleplayer.
- Клиент ограничивает размеры входящих snapshots, количество entities/drops, длину текста, координаты, урон и knockback.
- Сервер не должен заставлять клиент выполнять произвольный код.
- Секрет/печать server save - это защита от случайного локального редактирования, а не DRM.

## Установка для игрока

1. Закрой Lucid Blocks.
2. Открой папку игры в Steam: `Library -> Lucid Blocks -> Manage -> Browse local files`.
3. Создай папку `mods`, если ее нет.
4. Удали старые тестовые co-op/multiplayer `.pck`, если они лежат рядом.
5. Скопируй `dist/lucid-blocks-multiplayer.pck` в `mods`.
6. Запусти игру и нажми `CO-OP`.
7. Нажми на карточку сервера в списке `AVAILABLE QUALIA`.

Подробная инструкция для друга: [docs/FRIEND_INSTALL_RU.md](docs/FRIEND_INSTALL_RU.md).

![Выбор сервера](docs/assets/screenshots/server-browser-qualia.png)

## Свой сервер

Свой выделенный сервер поднимается на Linux и публикуется через registry/master-server, чтобы игрокам не приходилось вручную вводить IP и порт.

- Инструкция RU: [docs/LINUX_SERVER_RU.md](docs/LINUX_SERVER_RU.md)
- Instruction EN: [docs/LINUX_SERVER_EN.md](docs/LINUX_SERVER_EN.md)
- Логи и health-check: [docs/SERVER_LOGS.md](docs/SERVER_LOGS.md)
- Registry/master-server: [docs/SERVER_REGISTRY.md](docs/SERVER_REGISTRY.md)

Технические адреса, порты, пароли и deploy-файлы не должны попадать в публичный README, скриншоты или release archive.

## Скриншоты

Реальные скриншоты лежат в `docs/assets/screenshots`.

![Добавление direct server](docs/assets/screenshots/add-server-direct.png)

![Console help](docs/assets/screenshots/console-help-command.png)

![Console give](docs/assets/screenshots/console-give-command.png)

## Сборка

PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\scripts\build_release_packs.ps1
```

Проверка перед публикацией:

```powershell
.\scripts\check_release_hygiene.ps1
git diff --check
```

## Публикация

Перед первым push/release:

1. Не публикуй `deploy.txt`, `.env`, пароли, токены, приватные IP/порты и локальные логи.
2. Оставь атрибуцию в [CREDITS.md](CREDITS.md).
3. Не выдавай оригинальный co-op mod за свой: upstream - `parkers0405/lucid-blocks-coop`, автор Parker Settle / Mr_Settle.
4. Запусти `scripts/check_release_hygiene.ps1` и `git diff --check`.

## Статус

MVP еще экспериментальный. Singleplayer должен оставаться рабочим, а серверные миры должны открываться только через multiplayer-подключение.
