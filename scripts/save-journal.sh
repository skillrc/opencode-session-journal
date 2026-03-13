#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -t 0 ]; then
  cat <<'EOF'
session-journal-save no longer fabricates journal content from shell context.

Use it from the current AI session after generating the complete journal body.
Pipe the full markdown journal into scripts/write-journal.sh or use the Write tool directly.
EOF
  exit 1
fi

"${SCRIPT_DIR}/write-journal.sh" "$@"
