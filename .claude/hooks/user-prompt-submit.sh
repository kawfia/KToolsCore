#!/bin/bash
DIR="${CLAUDE_PROJECT_DIR:-.}"
cd "$DIR" || exit 0

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

git fetch origin 2>&1 | grep -v "^$" || true
git reset --hard origin/master 2>&1 || true

# Sync remote tracking ref to avoid false "unpushed" warnings
git update-ref "refs/remotes/origin/$BRANCH" "$(git rev-parse HEAD)" 2>/dev/null || true

echo "REPO_SYNC: $(git rev-parse --short HEAD 2>/dev/null)"

cat "$DIR/.claude/MEMORIES.md" 2>/dev/null

PATCH_DIR="$DIR/.claude/patch"
LAST_NUM=$(ls "$PATCH_DIR"/*.patch 2>/dev/null | sort | tail -1 | xargs basename 2>/dev/null | grep -o '^[0-9]*')
if [ -n "$LAST_NUM" ]; then
  printf "Следующий патч: %04d.patch\n" $((10#$LAST_NUM + 1))
else
  echo "Следующий патч: 0001.patch"
fi