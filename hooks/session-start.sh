#!/bin/bash
# SessionStart hook - Auto-load user profile

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

"${SKILL_ROOT}/scripts/load-profile.sh"
