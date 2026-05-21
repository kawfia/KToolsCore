#!/bin/bash
DIR="${CLAUDE_PROJECT_DIR:-.}"

cd "$DIR" || exit 0

git fetch origin --quiet 2>/dev/null
git reset --hard origin/master --quiet 2>/dev/null || true

echo "REPO_SYNC: $(git rev-parse --short HEAD 2>/dev/null)"

cat "$DIR/.claude/MEMORIES.md" 2>/dev/null
