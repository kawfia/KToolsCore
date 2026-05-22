[2026-05-21] core/ui.lua реализован: ADDON=..., RegisterModule, SafeCall, ShowMainFrame/Hide/Toggle, LibWindow-1.1 для позиции, AceGUI Frame+TabGroup.
[2026-05-21] lib/load.xml: добавлен LibWindow-1.1. KTools.toc: версия → 0.1.2.
[2026-05-21] init.lua реализован: AceAddon:NewAddon, AceDB:New("KToolsDB"), slash /ktools /ktl → ToggleMainFrame.
[2026-05-21] core/settings.lua реализован: defaults profile.window{width=600,height=450,point,x,y,scale}, minimap{hide}.
[2026-05-21] core/minimap.lua реализован: LDB:NewDataObject + LibDBIcon:Register, db=profile.minimap, OnClick→ToggleMainFrame. locale: MINIMAP_HINT. Версия → 0.1.4.
[2026-05-21] settings.lua оставлен (DB-схема). Будущий AceConfig-панель → options.lua. Модулям разрешён прямой доступ к KTools.db.
[2026-05-22] KToolsAutoLoot.md пересобрана: удалён раздел «План разработки», содержание без изменений.