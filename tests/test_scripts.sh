#!/bin/bash
# Test Suite for Session Journal Scripts

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

PASSED=0
FAILED=0

test_calculate_zodiac() {
    local year=$1
    local expected=$2
    local result
    
    result=$("$PROJECT_ROOT/scripts/calculate-zodiac.sh" "$year")
    
    if [ "$result" = "$expected" ]; then
        echo "✓ calculate-zodiac $year = $expected"
        PASSED=$((PASSED + 1))
    else
        echo "✗ calculate-zodiac $year: expected '$expected', got '$result'"
        FAILED=$((FAILED + 1))
    fi
}

test_generate_path_format() {
    local result
    
    result=$("$PROJECT_ROOT/scripts/generate-journal-path.sh")
    
    if [[ "$result" =~ ^/.*/.opencode/session-journals/year-[0-9]{4}-[A-Za-z]+/month-[0-9]{2}-[A-Za-z]+/day-[0-9]{2}-[A-Za-z]+/journal-[0-9]+-[0-9]{2}:[0-9]{2}:[0-9]{2}\.md$ ]]; then
        echo "✓ generate-journal-path format valid"
        PASSED=$((PASSED + 1))
    else
        echo "✗ generate-journal-path format invalid: $result"
        FAILED=$((FAILED + 1))
    fi
}

test_generate_path_contains_correct_zodiac() {
    local result
    local year
    
    year=$(date +%Y)
    result=$("$PROJECT_ROOT/scripts/generate-journal-path.sh")
    
    case $year in
        2024) expected_zodiac="Dragon" ;;
        2025) expected_zodiac="Snake" ;;
        2026) expected_zodiac="Horse" ;;
        2027) expected_zodiac="Goat" ;;
        *) expected_zodiac="Unknown" ;;
    esac
    
    if [[ "$result" =~ year-$year-$expected_zodiac ]]; then
        echo "✓ generate-journal-path contains correct zodiac for $year"
        PASSED=$((PASSED + 1))
    else
        echo "✗ generate-journal-path missing zodiac: expected '$expected_zodiac' in $result"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== Testing Session Journal Scripts ==="
echo ""

echo "Testing calculate-zodiac.sh..."
test_calculate_zodiac 1900 "Rat"
test_calculate_zodiac 2024 "Dragon"
test_calculate_zodiac 2025 "Snake"
test_calculate_zodiac 2026 "Horse"
test_calculate_zodiac 2027 "Goat"
test_calculate_zodiac 2028 "Monkey"
test_calculate_zodiac 2029 "Rooster"
test_calculate_zodiac 2030 "Dog"
test_calculate_zodiac 2031 "Pig"
test_calculate_zodiac 2032 "Rat"

echo ""
echo "Testing generate-journal-path.sh..."
test_generate_path_format
test_generate_path_contains_correct_zodiac

echo ""
echo "=== Test Results ==="
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ $FAILED -eq 0 ]; then
    echo "✓ All tests passed!"
    exit 0
else
    echo "✗ Some tests failed"
    exit 1
fi
