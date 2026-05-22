# Частые ошибки

## Хардкод имени аддона в Lua-файлах
**Ошибка:** `GetAddon("KTools")`, `GetLocale("KTools")`, `SetTitle("KTools")`
**Правильно:** первой строкой кода объявить `local ADDON = ...` и использовать переменную везде.
`...` в WoW-файле содержит имя аддона, переданное загрузчиком из .toc.

## Отсутствие встроенных инструментов
**Ошибка:** Asked-agent задаёт вопросы текстом, без использования встроенной возможности создания Asked-form.
**Правильно:** использовать интерактивную asked-форму для уточнения вопросов.

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