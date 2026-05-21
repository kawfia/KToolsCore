# MEMORIES

- [2026-05-21] Предложена базовая структура KTools (ожидает подтверждения): KTools.lua + Modules.lua, lib: LibStub→AceAddon/Event/Console/DB/GUI + LibDataBroker/DBIcon/Window, публичный API: RegisterModule, CallModule, ToggleMainFrame, KToolsDB.
- [2026-05-21] Утверждён рабочий процесс: после каждого патча — слепой ревью через Agent (без контекста задачи) + доставка через SendUserFile.
- [2026-05-21] Контейнер read-only для push; git push даёт 403 — патчи доставляются только через SendUserFile.
- [2026-05-21] Хук синхронизации: UserPromptSubmit тянет .claude/ из origin/master (не git pull своей ветки).
- [2026-05-21] Структура .toc: Notes на англ. + ruRU. Библиотеки через lib/load.xml. Патч включает MEMORIES.md.
- [2026-05-21] Патч 0002: структура ядра KTools — init.lua (AceAddon+RegisterModule+CallModule), core/{settings,minimap,ui}.lua (заглушки), locale/{enUS,ruRU}.lua. lib/load.xml: добавлены AceConfig-3.0, AceLocale-3.0. Следующий патч: 0003.
