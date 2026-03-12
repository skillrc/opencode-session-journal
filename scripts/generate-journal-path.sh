#!/bin/bash
# Generate Session Journal File Path
#
# Usage: generate-journal-path.sh
#
# Output: Full path to journal file
#   Format: $HOME/.opencode/session-journals/year-YYYY-Zodiac/month-MM-MonthName/day-DD-Weekday/journal-timestamp-HH:MM:SS.md
#
# Example output:
#   /home/user/.opencode/session-journals/year-2026-Horse/month-03-March/day-12-Thursday/journal-1773253205-02:20:05.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

YEAR=$(date +%Y)
MONTH=$(date +%m)
MONTH_NAME=$(date +%B)
DAY=$(date +%d)
WEEKDAY=$(date +%A)
TIMESTAMP=$(date +%s)
TIME=$(date +%H:%M:%S)

ZODIAC=$("$SCRIPT_DIR/calculate-zodiac.sh" "$YEAR")

JOURNAL_BASE="$HOME/.opencode/session-journals"
DIR="$JOURNAL_BASE/year-${YEAR}-${ZODIAC}/month-${MONTH}-${MONTH_NAME}/day-${DAY}-${WEEKDAY}"
FILE="journal-${TIMESTAMP}-${TIME}.md"

echo "$DIR/$FILE"
