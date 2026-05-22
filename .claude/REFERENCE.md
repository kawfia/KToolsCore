# KToolsCore — Навигация

Модульный WoW-аддон Legion 7.3.5. github.com/kawfia/KToolsCore

---

## Правила и ограничения

| Файл | Описание |
|---|---|
| `.claude/rules/red-lines.md` | Абсолютные запреты — читать обязательно |
| `.claude/rules/architecture.md` | Архитектура, структура проекта, библиотеки |
| `.claude/rules/common-mistakes.md` | Частые ошибки которые были при генерации кода |
| `.claude/rules/code-style.md` | Стиль кода, структура файлов |

---

## Документация модулей

| Файл | Модуль | Команда | Статус |
|---|---|---|---|
| `.claude/tasks/KTools.md` | Ядро | `/ktools` | Ожидает options.lua |
| `.claude/tasks/KToolsAutoLoot.md` | Авто-лут | `/ktloot` | В разработке |
| `.claude/tasks/KToolsTPH.md` | Трекер фарма | `/ktph` | Идея |

---

## Реализованные паттерны (примеры для повторного использования)

| Файл | Паттерн |
|---|---|
| `KTools/init.lua` | AceAddon:NewAddon, AceDB:New, slash-команды, defaults inline |
| `KTools/core/ui.lua` | RegisterModule, SafeCall, AceGUI Frame+TabGroup, LibWindow позиция |
| `KTools/core/minimap.lua` | LDB:NewDataObject, LibDBIcon:Register, Show/Hide через KTools-метод |
| `KTools/core/options.lua` | AceConfig-3.0 options table, RegisterOptionsTable, AddToBlizOptions |

---

## Reference-материалы

| Файл | Описание |
|---|---|
| `.claude/reference/autoloot_filter.html` | Макет окна фильтрации (категории, качество) |
| `.claude/reference/autoloot_customlist.html` | Макет пользовательского списка предметов |
| `.claude/reference/core.h` | ItemClass, ItemBonding, InventoryType (Legion 7.3.5) |
| `.claude/reference/lib/` | Библиотеки (не коммитятся, копировать вручную) |
| `.claude/reference/addons/` | Референсные аддоны |
```

---