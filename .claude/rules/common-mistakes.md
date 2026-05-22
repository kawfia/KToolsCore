# Частые ошибки

## Хардкод имени аддона в Lua-файлах
**Ошибка:** `GetAddon("KTools")`, `GetLocale("KTools")`, `SetTitle("KTools")`
**Правильно:** первой строкой кода объявить `local ADDON = ...` и использовать переменную везде.
`...` в WoW-файле содержит имя аддона, переданное загрузчиком из .toc.

## Отсутствие встроенных инструментов
**Ошибка:** Asked-agent задаёт вопросы текстом, без использования встроенной возможности создания Asked-form.
**Правильно:** использовать интерактивную asked-форму для уточнения вопросов.

## Модули не используют предоставленные фреймы ядром.
**Ошибка** Модули самостоятельно рисуют свое UI.
**Правильно** Ядро предоставляет фрейм, в котором модули отрисовывают свои настройки.

## LibStub внутри callback-функции
**Ошибка:** `LibStub("LibDBIcon-1.0")` вызывается внутри функции `set` или другого callback.
**Правильно:** объявить `local LibDBIcon = LibStub("LibDBIcon-1.0")` на уровне модуля — один раз при загрузке файла.
```lua
-- Неправильно
set = function(_, val)
    local LibDBIcon = LibStub("LibDBIcon-1.0")  -- вызов при каждом изменении
    LibDBIcon:Hide(ADDON)
end

-- Правильно
local LibDBIcon = LibStub("LibDBIcon-1.0")  -- один раз на уровне модуля
...
set = function(_, val)
    LibDBIcon:Hide(ADDON)
end
```

## Нарушение зон ответственности между файлами
**Ошибка:** `options.lua` напрямую вызывает `LibDBIcon:Show/Hide` — управляет иконкой миникарты.
**Правильно:** каждый файл реализует только свою зону ответственности. `options.lua` не знает о `LibDBIcon`. Управление иконкой — ответственность `minimap.lua`, который предоставляет метод KTools для вызова.
```lua
-- Неправильно (в options.lua)
set = function(_, val)
    LibStub("LibDBIcon-1.0"):Hide(ADDON)
end

-- Правильно: метод в minimap.lua
function KTools:SetMinimapVisible(visible) ... end

-- Вызов из options.lua
set = function(_, val)
    KTools:SetMinimapVisible(val)
end
```

## Кнопки UI часто съезжают на другую строку.
- Рассчет значений минимального размера окна - не помогает.
- Хардкод - не помогает.
- Динамиечкая длина кнопки - частично делает баг хуже.

## CloseLoot() внутри обработчика LOOT_OPENED вызывает LOOT_CLOSED синхронно
**Ошибка:** вызов `CloseLoot()` внутри обработчика события `LOOT_OPENED`.
**Почему ломается:** WoW немедленно стреляет `LOOT_CLOSED` синхронно. Если `OnLootClosed` вызывает `UseContainerItem` → `LOOT_READY` → `RegisterEvent("LOOT_OPENED")` — а затем `OnLootOpened` продолжает выполнение и делает `UnregisterEvent("LOOT_OPENED")`, следующий контейнер теряет обработчик. Окно остаётся открытым.
**Правильно:** `UnregisterEvent("LOOT_OPENED")` выносить **первой строкой** в обработчик, до любых вызовов `CloseLoot()`.