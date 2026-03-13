#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
JOURNAL_PATH="$(${SCRIPT_DIR}/generate-journal-path.sh)"
JOURNAL_DIR="$(dirname "$JOURNAL_PATH")"
TMP_FILE="${JOURNAL_PATH}.tmp.$$"

mkdir -p "$JOURNAL_DIR"
cat > "$TMP_FILE"

if ! grep -q '^content_complete: true$' "$TMP_FILE"; then
  rm -f "$TMP_FILE"
  echo "Refusing to save incomplete journal: missing 'content_complete: true' in frontmatter" >&2
  exit 1
fi

mv "$TMP_FILE" "$JOURNAL_PATH"
"${SCRIPT_DIR}/update-knowledge-graph.sh" "$JOURNAL_PATH" >/dev/null 2>&1 || true
printf '%s\n' "$JOURNAL_PATH"
