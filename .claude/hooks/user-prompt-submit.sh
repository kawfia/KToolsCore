#!/bin/bash
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
git fetch origin --quiet 2>/dev/null
git reset --hard origin/master --quiet 2>/dev/null || true