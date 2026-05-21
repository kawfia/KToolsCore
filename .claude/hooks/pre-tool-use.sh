#!/usr/bin/env python3
import sys, json, re

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

command = data.get("tool_input", {}).get("command", "")

if re.search(r'(?:^|\s|;|&&|\|\|)rm\s+(?:-[a-zA-Z]*\s+)*[^\s]', command, re.MULTILINE):
    print(json.dumps({"decision": "block", "reason": "RED LINE: rm заблокирован. Удаление файлов — только по явному «удали» от пользователя."}))
    sys.exit(0)

if re.search(r'git\s+(?:push\s+.*--force|push\s+.*-f\b|reset\s+--hard|clean\s+-[a-zA-Z]*f)', command, re.MULTILINE):
    print(json.dumps({"decision": "block", "reason": "RED LINE: опасная git-операция заблокирована. Скажи явно что нужно сделать."}))
    sys.exit(0)

sys.exit(0)