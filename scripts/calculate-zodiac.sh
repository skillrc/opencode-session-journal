#!/bin/bash
# Calculate Chinese Zodiac Animal
#
# Usage: calculate-zodiac.sh [YEAR]
#   YEAR: Optional. Defaults to current year.
#
# Output: Zodiac animal name (e.g., "Horse")
#
# Examples:
#   calculate-zodiac.sh 2026  # Output: Horse
#   calculate-zodiac.sh       # Output: (current year's zodiac)
#
# Note: Bash arrays start at index 0 when using () syntax.
#       1900 is Rat (index 0), so we use (year - 1900) % 12 directly.

set -euo pipefail

# Get year from argument or use current year
YEAR="${1:-$(date +%Y)}"

# Validate year is a number
if ! [[ "$YEAR" =~ ^[0-9]{4}$ ]]; then
    echo "Error: Invalid year '$YEAR'. Must be a 4-digit number." >&2
    exit 1
fi

# Chinese zodiac animals (index 0 = Rat for year 1900)
# Bash arrays with () start at index 0
ZODIACS=(Rat Ox Tiger Rabbit Dragon Snake Horse Goat Monkey Rooster Dog Pig)

# Calculate zodiac index
ZODIAC_INDEX=$(( (YEAR - 1900) % 12 ))

# Get zodiac animal
ZODIAC="${ZODIACS[$ZODIAC_INDEX]}"

# Output result
echo "$ZODIAC"
