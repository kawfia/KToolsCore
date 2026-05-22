## KToolsAutoloot — Авто-лут

**Модуль для KTools. Автоматически подбирает лут по настраиваемым правилам.**

## Назначение
Заменяет ручной выбор лута. Два уровня настройки: быстрые категории (золото, реагенты, качество) и ручной список по itemID.

## Команда
`/ktloot` — открывает окно KTools с выбранным модулем AutoLoot.

## Опции (ESC → Интерфейс → KTools → AutoLoot)
Опции размещены в подменю KTools, не верхнем уровне.

| Опция | Описание |
|---|---|
| Без подтверждения BoP | Автоподтверждение диалога привязки при подборе BoP |
| Закрыть лут при скиннинге | Закрыть окно лута при касте снятия шкур |
| Мгновенное закрытие пустого лута | Закрыть окно лута сразу если оно пустое |

## Интерфейс
Модуль рендерит UI внутри фрейма-контейнера KTools (передаётся через `KTools:RegisterModule`). Собственного окна нет.
Две вкладки: «Быстрые настройки» и «Пользовательский список».
Диаграммы: `.claude/reference/autoloot_filter.html`, `.claude/reference/autoloot_customlist.html`

## Описание кнопок интерфейса

### Общая шапка (обе вкладки)
| Элемент | Тип | Описание |
|---|---|---|
| Включить | checkbox | Включить / выключить модуль |
| Профиль | dropdown | Выбор активного профиля |
| Создать | button | Новый профиль |
| Удалить | dropdown | Выбор и удаление профиля |
| Импорт | button | Импорт профиля из строки |
| Экспорт | button | Экспорт профиля в строку |

> Шапка реализована в `ui/main.lua`. Логика сериализации импорта/экспорта — в `core/engine.lua`, UI только вызывает метод модуля.

### Вкладка: Быстрые настройки

#### Быстрые категории
| Кнопка | Описание |
|---|---|
| Золото | Монеты с лута |
| Реагенты | TradeGoods + Reagent |
| Рецепты | Все рецепты |
| Маунты | Предметы-маунты |
| Питомцы | Боевые питомцы |
| Квестовые предметы | Тип Quest и квестовый bindType |
| Валюта | Жетоны и валюты |
| Сила артефакта | Предметы силы артефакта (tooltip-scan) |

#### Фильтр по качеству и ilvl
Заголовки столбцов — отдельный ряд над данными: **Включение | ilvl >= | BoE | BoP**

| Качество | BoE | BoP | ilvl >= |
|---|---|---|---|
| Poor | + | + | поле |
| Common | + | + | поле |
| Uncommon | + | + | поле |
| Rare | + | + | поле |
| Epic | + | + | поле |
| Legendary | + | + | поле |

Каждая строка: checkbox (включение) + название качества + поле `ilvl >=` + два чекбокса.
BoE — BoE (bindType=2), не привязан (bindType=0). BoP — только привязывается при подборе (bindType=1).
В БД: ключ `boe` хранит оба состояния. Ключ `nob` удалён.
> Значения bindType: `.claude/reference/core.h` → `enum ItemBondingType`

### Вкладка: Пользовательский список
| Колонка | Тип | Описание |
|---|---|---|
| checkbox | checkbox | Включить/выключить запись |
| ID | input | Поле ввода itemID |
| Название предмета | text | Автозаполняется по ID |
| Тип | text | Эквип / Валюта / Рецепты / Реагенты (автозаполнение) |
| ilvl >= | input | Минимальный ilvl (опционально) |
| (удалить) | button (x) | Удалить запись |

## Файловая структура аддона
```
KToolsAutoloot/
  KToolsAutoLoot.toc       — точка входа, зависимость на KTools
  init.lua                 — инициализация, регистрация в KTools (прямая ссылка из .toc)
  core/
    load.xml               — список core-файлов
    engine.lua             — движок лута: события, фильтрация, LootSlot, tooltip-scan, импорт/экспорт
    settings.lua           — схема SavedVariables
    options.lua            — AceConfig-подменю (ESC → KTools → AutoLoot)
  ui/
    load.xml               — список UI-файлов
    main.lua               — шапка: включить, профиль, кнопки управления
    quick.lua              — вкладка «Быстрые настройки»
    custom.lua             — вкладка «Пользовательский список»
  locale/
    load.xml
    enUS.lua
    ruRU.lua
```

> Порядок загрузки в `.toc`: `init.lua` напрямую, затем `locale/load.xml`, `core/load.xml`, `ui/load.xml`.
> Локаль загружается первой — строки доступны при инициализации core и ui.

## SavedVariables
Хранятся в профилях AceDB под ключом `KToolsAutolootDB`.

Каждый профиль содержит:
- `enabled` — включён ли модуль
- `categories` — быстрые категории (золото, реагенты и т.д.)
- `quality` — матрица качество × привязка × ilvl
- `customList` — список предметов пользователя (id → {enabled, ilvl})
- `options` — особые опции (bop, skinning, emptyLoot)

Импорт/Экспорт профиля — паттерн ElvUI:
`AceSerializer:Serialize` → `LibDeflate:CompressDeflate` → base64-строка.
> Reference: `.claude/reference/addons/ElvUI_Config/profiles.lua`

## WoW API (Legion 7.3.5)

### События
| Событие | Назначение |
|---|---|
| `LOOT_READY` | Лут готов — список слотов может быть ещё неполным |
| `LOOT_OPENED` | Окно лута открыто — список слотов гарантирован, выполнять LootSlot |
| `CONFIRM_LOOT_SLOT` | Требуется подтверждение BoP |
| `UNIT_SPELLCAST_START` | Начало каста (фильтровать: unit == "player") |

### Функции
| Функция | Назначение |
|---|---|
| `GetNumLootItems()` | Кол-во слотов в окне лута |
| `GetLootSlotType(i)` | Тип слота: 1=предмет, 2=валюта, 3=деньги |
| `GetLootSlotInfo(i)` | icon, name, quantity, currencyID, quality, locked, ... |
| `GetLootSlotLink(i)` | ItemLink для слота |
| `LootSlot(i)` | Подобрать предмет из слота |
| `ConfirmLootSlot(i)` | Подтвердить BoP-подбор |
| `CloseLoot()` | Закрыть окно лута |
| `GetItemInfo(link)` | name, _, quality, ilvl, _, _, _, _, _, _, _, classID, subclassID, bindType |
| `GetTime()` | Метка времени |

> Числовые значения classID, subclassID, bindType: `.claude/reference/core.h` → `enum ItemClass`, `enum ItemBondingType`

### Типы слотов (объявлять локально в engine.lua)
```lua
LOOT_SLOT_ITEM     = 1
LOOT_SLOT_CURRENCY = 2
LOOT_SLOT_MONEY    = 3
```

## Логика движка лута

### Поток событий
```
LOOT_READY:
  (список слотов в этот момент может быть неполным)
  подписаться на LOOT_OPENED (один раз)

LOOT_OPENED:
  n = GetNumLootItems()
  если n == 0 и опция emptyLoot включена: CloseLoot(); выйти
  для i = n .. 1:        -- обратный порядок: LootSlot сдвигает индексы
    если ShouldLoot(i): LootSlot(i)
  отписаться от LOOT_OPENED
```

> Reference паттерн: `.claude/reference/addons/ExRT/LootLink.lua`

### Фильтр ShouldLoot(i)
Предмет подбирается если выполняется хотя бы одно из условий (OR-логика):
1. **Быстрые категории** — тип предмета попадает под включённую категорию.
2. **Фильтр качества** — quality + bindType попадают под включённую ячейку матрицы, AND ilvl >= порога.
3. **Пользовательский список** — itemID найден, запись включена, AND ilvl >= порога записи.

Деньги (`LOOT_SLOT_MONEY`) — при включённой категории «Золото», вне матрицы качества.

## Обнаружение «Силы артефакта» через tooltip-scan

Создаётся скрытый GameTooltip-фрейм при загрузке `engine.lua`. Для каждого предмета вызывается `SetHyperlink`, затем построчно ищется совпадение с `ARTIFACT_POWER` через `string.find` (не строгое `==` — в Legion тултип содержит форматированную строку с числом).

> Сканирование выполняется только если категория «Сила артефакта» включена в профиле.
> Reference паттерн: `.claude/reference/addons/XLoot/helpers.lua`

## Скиннинг: определение события
`UNIT_SPELLCAST_START` фильтруется по `unit == "player"`. Скиннинг определяется по имени спелла:
сравнить с именем профессии через `GetSpellInfo(8613)` (базовый spellID скиннинга в Legion).
> Проверить spellID при тестировании на Legion 7.3.5.

## Быстрые категории — соответствие ItemClass
> Числовые значения классов: `.claude/reference/core.h` → `enum ItemClass`, `enum ItemSubclassMiscellaneous`

| Категория | Условие |
|---|---|
| Золото | GetLootSlotType(i) == 3 |
| Реагенты | classID == 7 ИЛИ classID == 5 |
| Рецепты | classID == 9 |
| Маунты | classID == 15, subclassID == 5 |
| Питомцы | classID == 17 ИЛИ (classID == 15, subclassID == 2) |
| Квестовые | classID == 12 ИЛИ bindType == 4 |
| Валюта | GetLootSlotType(i) == 2 |
| Сила артефакта | tooltip-scan: string.find(line, ARTIFACT_POWER) |

## План разработки

### В порядке очереди
| Этап | Файлы |
|---|---|
| Скелет | toc, init.lua, locale/*, load.xml |
| UI | ui/main.lua, quick.lua, custom.lua |
| Движок лута | core/engine.lua |
| Опции AceConfig | core/options.lua |
| Импорт/Экспорт | core/engine.lua (Serialize/Deserialize) |

### Параллельно наполняя
| Этап | Файлы |
|---|---|
| SavedVariables | core/settings.lua |
| Локализация (финал) | locale/enUS.lua, ruRU.lua |
