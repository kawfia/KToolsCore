#!/bin/bash
DIR="${CLAUDE_PROJECT_DIR:-.}"
PATCH_DIR="$DIR/.claude/patch"

cat "$DIR/.claude/MEMORIES.md" 2>/dev/null

# Последний handoff
if [ -f "$DIR/.claude/HANDOFFS.md" ]; then
  awk '/^### /{n++} n==1{print} n==2{exit}' "$DIR/.claude/HANDOFFS.md"
fi

# Следующий номер патча
LAST_NUM=$(ls "$PATCH_DIR"/*.patch 2>/dev/null | sort | tail -1 | xargs basename 2>/dev/null | grep -o '^[0-9]*')
if [ -n "$LAST_NUM" ]; then
  printf "Следующий патч: %04d.patch\n" $((10#$LAST_NUM + 1))
else
  echo "Следующий патч: 0001.patch"
fi