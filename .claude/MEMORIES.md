[2026-05-22] KToolsAutoLoot engine.lua v0.2.3: fix гонки UnregisterEvent/CloseLoot. UnregisterEvent("LOOT_OPENED") перенесён первой строкой OnLootOpened, до CloseLoot(). Убран явный CloseLoot() после лут-цикла — WoW закрывает окно сам.
[2026-05-22] common-mistakes.md: добавлена запись — CloseLoot() внутри LOOT_OPENED вызывает LOOT_CLOSED синхронно, уничтожает RegisterEvent следующего контейнера.
[2026-05-22] KToolsAutoLoot engine.lua v0.2.1: авто-открытие контейнеров — опция autoOpen, LOOT_CLOSED→ScanAndOpenContainer (lootable=6й, UseContainerItem, InCombatLockdown). Флаг lootingContainer → лут всего без ShouldLoot.
[2026-05-22] KToolsAutoLoot ui/custom.lua: имена предметов окрашены в цвет редкости, неизвестные серым.
[2026-05-22] KToolsAutoLoot core/engine.lua v0.1.9: полный движок лута, LOOT_READY→LOOT_OPENED, ShouldLoot OR-логика, tooltip-scan Artifact Power, skinning, BoP.
[2026-05-22] KToolsAutoLoot core/options.lua: четыре toggle-опции (bop, skinning, emptyLoot, autoOpen), AceConfig под KTools.
[2026-05-22] KTools/core/ui.lua v0.2.0: RegisterModule поддерживает opts.label.