# MEMORIES

- [2026-05-21] Утверждён рабочий процесс: после каждого патча — слепой ревью через Agent (без контекста задачи) + доставка через SendUserFile.
- [2026-05-21] Контейнер read-only для push; git push даёт 403 — патчи доставляются только через SendUserFile.
- [2026-05-21] Хук синхронизации: UserPromptSubmit тянет .claude/ из origin/master (не git pull своей ветки).
- [2026-05-21] Структура .toc: Notes на англ. + ruRU. Библиотеки через lib/load.xml. Патч включает MEMORIES.md.
- [2026-05-21] Патч 0003: session-start.sh делает git reset --hard origin/master при старте; .gitignore исключает .claude/patch/. Следующий патч: 0004.
- [2026-05-21] Патч 0004: settings.json — добавлен permissions.allow: ["Agent"] — исправлен баг блокировки слепого ревью в веб-режиме.
- [2026-05-21] Хук UserPromptSubmit: git reset --hard origin/master + вывод REPO_SYNC/MEMORIES/следующего патча — видимый в контексте Claude на каждое сообщение.
