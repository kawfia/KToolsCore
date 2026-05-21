#!/bin/bash
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
git fetch origin --quiet 2>/dev/null
git checkout origin/master -- .claude/ 2>/dev/null || true
