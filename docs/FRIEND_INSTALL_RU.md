# Как дать мод другу

Это MVP-сборка Lucid Blocks Multiplayer. Ставьте ее только поверх легальной Steam-версии игры и не смешивайте со старыми debug/co-op `.pck`.

## Что отправить

Отправь другу файл:

```text
lucid-blocks-multiplayer.pck
```

Если отправляешь архив релиза, внутри нужен именно этот `.pck`.

## Установка

1. Закрыть Lucid Blocks.
2. Открыть папку игры в Steam: `Library -> Lucid Blocks -> Manage -> Browse local files`.
3. Найти или создать папку `mods`.
4. Удалить старые multiplayer/co-op тестовые пакеты, если они там есть:

```text
lucid-blocks-coop-test.pck
lucid-blocks-coop-next.pck
lucid-blocks-coop-dedicated.pck
zz-lucid-blocks-coop*.pck
zzz-lucid-blocks-command-chat*.pck
```

5. Положить `lucid-blocks-multiplayer.pck` в `mods`.
6. Запустить игру.

## Подключение

1. Открыть вкладку multiplayer/server browser.
2. Выбрать сервер по имени `QUALIA`.
3. Нажать на плашку сервера. Она должна сразу начать подключение к миру.

![QUALIA multiplayer entry](assets/screenshots/main-menu-qualia.png)
![QUALIA server browser](assets/screenshots/server-browser-qualia.png)
![Direct add server screen](assets/screenshots/add-server-direct.png)

Публичный порт и технический адрес специально не показываются в инструкции и UI.

## Если не подключает

- Проверьте, что у обоих игроков одинаковая версия Lucid Blocks.
- Проверьте, что в `mods` лежит только свежий `lucid-blocks-multiplayer.pck`, без старых co-op/debug пакетов.
- Перезапустите игру после замены `.pck`.
- Если один игрок заходит, а второй нет, пришлите серверное имя, время попытки и скрин текста ошибки.

## Важно

Мир сервера считается серверным миром. Не надо пытаться играть в этот же сейв локально в singleplayer и потом мерджить прогресс вручную.
