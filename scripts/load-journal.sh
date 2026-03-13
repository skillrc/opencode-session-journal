#!/bin/bash
set -euo pipefail

JOURNAL_DIR="${HOME}/.opencode/session-journals"
TARGET="${1:-}"

if [ ! -d "$JOURNAL_DIR" ]; then
  echo "❌ No session journals found. Use /session-journal-save to create one."
  exit 1
fi

resolve_latest() {
  find "$JOURNAL_DIR" -name 'journal-*.md' -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-
}

resolve_list() {
  find "$JOURNAL_DIR" -name 'journal-*.md' -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | cut -d' ' -f2-
}

resolve_date() {
  local input="$1"
  local day_part
  day_part="$(printf '%s' "$input" | awk -F- '{print $3}')"
  find "$JOURNAL_DIR" -path "*/day-${day_part}-*/*.md" -type f 2>/dev/null | sort
}

resolve_session_id() {
  local input="$1"
  grep -R -l "^session_id: ${input}$" "$JOURNAL_DIR" 2>/dev/null || true
}

if [ "$TARGET" = "list" ]; then
  resolve_list
  exit 0
fi

if [ -z "$TARGET" ]; then
  FILES="$(resolve_latest)"
elif printf '%s' "$TARGET" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
  FILES="$(resolve_date "$TARGET")"
elif printf '%s' "$TARGET" | grep -Eq '^ses_'; then
  FILES="$(resolve_session_id "$TARGET")"
else
  FILES="$(resolve_latest)"
fi

if [ -z "$FILES" ]; then
  echo "❌ No matching session journals found."
  exit 1
fi

FIRST_FILE="$(printf '%s\n' "$FILES" | head -1)"

echo "📖 Journal file: $FIRST_FILE"
echo ""
cat "$FIRST_FILE"
