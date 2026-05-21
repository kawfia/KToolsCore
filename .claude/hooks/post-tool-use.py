#!/usr/bin/env python3
import sys, json, os

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

tool_name = data.get("tool_name", "")
tool_input = data.get("tool_input", {})

if tool_name == "Write":
    file_path = tool_input.get("file_path", "")
    if file_path.endswith(".patch"):
        patch_name = os.path.basename(file_path)
        print(
            f"[АВТО-РЕВЬЮ] Записан патч: {patch_name}\n"
            f"Немедленно вызови Agent (слепой ревью) — без описания задачи:\n"
            f"  • содержимое {file_path}\n"
            f"  • .claude/rules/red-lines.md\n"
            f"  • .claude/rules/architecture.md\n"
            f"  • .claude/REFERENCE.md\n"
            f"Ожидаемый ответ: LGTM или список нарушений."
        )