# Lua Conventions — WoW Addon

## WoW Lua — чего НЕТ в стандартной библиотеке
Нельзя использовать: `io`, `os`, `package`, `require`, `dofile`, `loadfile`.
Нельзя: создавать файлы, читать файл-систему, HTTP-запросы.
Можно: `math`, `string`, `table`, `tonumber`, `tostring`, `pairs`, `ipairs`, `select`.
Для хранения данных — только `SavedVariables` через `.toc`.

---

## Namespace

```lua
-- Каждый модуль начинается так:
KTools = KTools or {}
KTools.ModuleName = KTools.ModuleName or {}
local M = KTools.ModuleName

-- Локальные переменные — всегда local
local function privateHelper() end

-- Публичный API через namespace
function M.DoSomething() end
```

Никакого загрязнения глобалей. Новые глобали только через `KTools.*`.

---

## Структура аддона (файлы)

```
KTools/
├── KTools.toc          ← (или отдельные .toc для каждой версии)
├── KTools.xml          ← регистрирует lua-файлы и фреймы
├── Core.lua            ← инициализация, namespace
├── Modules/
│   └── НазваниеМодуля.lua
└── Libs/               ← только если явно решено использовать
```

---

## Мульти-версионный TOC

Для поддержки нескольких версий WoW — отдельные `.toc` файлы:

```
KTools.toc           ← Retail
KTools_Classic.toc   ← Classic Era
KTools_Cataclysm.toc ← Cata
```

Разные `## Interface:` версии. Общий код — в `Core.lua` и модулях.
Версиоспецифичный код — в `Compat/Retail.lua`, `Compat/Classic.lua` и т.д.

---

## Совместимость API

Перед использованием функции — проверяй в каком WoW она доступна.
Обёртки для несовместимых API:

```lua
-- Пример: GetAddOnMetadata vs C_AddOns.GetAddOnMetadata
local GetAddonMeta = C_AddOns and C_AddOns.GetAddOnMetadata
    or GetAddOnMetadata

-- Проверка версии
local isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local isClassicEra = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
local isCata = WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC
```

---

## Events

```lua
-- Регистрация через выделенный фрейм, не через случайные фреймы
local eventFrame = CreateFrame("Frame", "KTools_EventFrame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "KTools" then
            M.Initialize()
        end
    end
end)
```

---

## Именование

| Тип | Стиль | Пример |
|-----|-------|--------|
| Глобальный namespace | PascalCase | `KTools` |
| Публичные функции | PascalCase | `M.GetPlayerInfo()` |
| Локальные функции | camelCase | `local function buildFrame()` |
| Локальные переменные | camelCase | `local playerName` |
| Константы | UPPER_SNAKE | `local MAX_ITEMS = 20` |
| Фреймы | PascalCase + суффикс | `KTools_MainFrame` |

---

## Производительность (WoW-специфика)

- Не делай поиск по таблице в `OnUpdate` — кешируй локально
- `string.format` дороже конкатенации для коротких строк
- Не создавай таблицы в hot path — переиспользуй
- Используй `C_Timer.After` вместо `OnUpdate` для отложенных действий
