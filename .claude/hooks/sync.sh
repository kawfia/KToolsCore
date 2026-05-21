#!/bin/bash
DIR="${CLAUDE_PROJECT_DIR:-.}"
PATCH_DIR="$DIR/.claude/patch"

cd "$DIR" || exit 0

git fetch origin --quiet 2>/dev/null
git reset --hard origin/master --quiet 2>/dev/null || true

echo "REPO_SYNC: $(git rev-parse --short HEAD 2>/dev/null)"

cat "$DIR/.claude/MEMORIES.md" 2>/dev/null

LAST_NUM=$(ls "$PATCH_DIR"/*.patch 2>/dev/null | sort | tail -1 | xargs basename 2>/dev/null | grep -o '^[0-9]*')
if [ -n "$LAST_NUM" ]; then
  printf "Следующий патч: %04d.patch\n" $((10#$LAST_NUM + 1))
else
  echo "Следующий патч: 0001.patch"
fi