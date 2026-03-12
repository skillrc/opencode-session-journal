#!/bin/bash
# Test Suite for OpenCode Session Journal
# TDD-style testing for save/load commands

# Don't exit on error - we want to run all tests
set +e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test results array
declare -a FAILED_TESTS

# Helper functions
pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((TESTS_PASSED++))
    ((TESTS_RUN++))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    FAILED_TESTS+=("$1")
    ((TESTS_FAILED++))
    ((TESTS_RUN++))
}

test_header() {
    echo ""
    echo -e "${YELLOW}=== $1 ===${NC}"
}

# Setup
JOURNAL_DIR="$HOME/.opencode/session-journals"
TEST_TIMESTAMP=$(date +%s)

# Test 1: Global directory exists
test_header "Test 1: Global journal directory"
if [ -d "$JOURNAL_DIR" ]; then
    pass "Global directory exists: $JOURNAL_DIR"
else
    fail "Global directory does not exist: $JOURNAL_DIR"
fi

# Test 2: Commands are installed
test_header "Test 2: Command files installed"
if [ -f "$HOME/.config/opencode/commands/session-journal-save.md" ]; then
    pass "Save command installed"
else
    fail "Save command not found"
fi

if [ -f "$HOME/.config/opencode/commands/session-journal-load.md" ]; then
    pass "Load command installed"
else
    fail "Load command not found"
fi

# Test 3: Commands use script-based path generation
test_header "Test 3: Commands use script-based path generation"
if grep -q 'generate-journal-path.sh' "$HOME/.config/opencode/commands/session-journal-save.md"; then
    pass "Save command uses script-based path generation"
else
    fail "Save command does not use script-based path generation"
fi

if grep -q '\$HOME/.opencode/session-journals' "$HOME/.config/opencode/commands/session-journal-load.md"; then
    pass "Load command uses global path"
else
    fail "Load command uses relative path"
fi

# Test 4: Find journals
test_header "Test 4: Find existing journals"
JOURNAL_COUNT=$(find "$JOURNAL_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
if [ "$JOURNAL_COUNT" -gt 0 ]; then
    pass "Found $JOURNAL_COUNT journal(s)"
else
    fail "No journals found"
fi

# Test 5: Most recent journal
test_header "Test 5: Find most recent journal"
LATEST=$(find "$JOURNAL_DIR" -name "*.md" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
if [ -n "$LATEST" ]; then
    pass "Most recent journal: $(basename "$LATEST")"
else
    fail "Could not find most recent journal"
fi

# Test 6: Journal file format
test_header "Test 6: Journal file format validation"
if [ -n "$LATEST" ] && [ -f "$LATEST" ]; then
    # Check for required sections
    if grep -q "# Session Journal" "$LATEST"; then
        pass "Journal has header"
    else
        fail "Journal missing header"
    fi
    
    if grep -q "## 📊 Session Summary" "$LATEST"; then
        pass "Journal has summary section"
    else
        fail "Journal missing summary section"
    fi
    
    if grep -q "### Completed Work" "$LATEST"; then
        pass "Journal has completed work section"
    else
        fail "Journal missing completed work section"
    fi
fi

# Test 7: Directory structure
test_header "Test 7: Org-roam directory structure"
if find "$JOURNAL_DIR" -type d -name "year-*" | grep -q .; then
    pass "Year directory exists (org-roam format)"
else
    fail "Year directory not found"
fi

if find "$JOURNAL_DIR" -type d -name "month-*" | grep -q .; then
    pass "Month directory exists (org-roam format)"
else
    fail "Month directory not found"
fi

if find "$JOURNAL_DIR" -type d -name "day-*" | grep -q .; then
    pass "Day directory exists (org-roam format)"
else
    fail "Day directory not found"
fi

# Test 8: Zodiac calculation
test_header "Test 8: Zodiac calculation"
YEAR=$(date +%Y)
ZODIAC_INDEX=$(( ($YEAR - 1900) % 12 ))
ZODIACS=("Rat" "Ox" "Tiger" "Rabbit" "Dragon" "Snake" "Horse" "Goat" "Monkey" "Rooster" "Dog" "Pig")
EXPECTED_ZODIAC=${ZODIACS[$ZODIAC_INDEX]}

if find "$JOURNAL_DIR" -type d -name "year-$YEAR-*" | grep -q "$EXPECTED_ZODIAC"; then
    pass "Zodiac calculation correct: $EXPECTED_ZODIAC"
else
    ACTUAL_ZODIAC=$(find "$JOURNAL_DIR" -type d -name "year-$YEAR-*" | head -1 | sed 's/.*year-[0-9]*-//')
    fail "Zodiac mismatch: expected $EXPECTED_ZODIAC, found $ACTUAL_ZODIAC"
fi

# Test 9: Cross-directory access
test_header "Test 9: Cross-directory access"
cd /tmp
if find "$JOURNAL_DIR" -name "*.md" -type f 2>/dev/null | grep -q .; then
    pass "Can access journals from /tmp"
else
    fail "Cannot access journals from /tmp"
fi

cd /home/lotus
if find "$JOURNAL_DIR" -name "*.md" -type f 2>/dev/null | grep -q .; then
    pass "Can access journals from /home/lotus"
else
    fail "Cannot access journals from /home/lotus"
fi

# Test 10: Journal file naming
test_header "Test 10: Journal file naming convention"
if find "$JOURNAL_DIR" -name "journal-*-*.md" -type f | grep -q .; then
    pass "Journal files follow naming convention: journal-{timestamp}-{time}.md"
else
    fail "Journal files do not follow naming convention"
fi

# Summary
echo ""
echo "======================================"
echo "Test Summary"
echo "======================================"
echo "Total tests run: $TESTS_RUN"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"

if [ $TESTS_FAILED -gt 0 ]; then
    echo ""
    echo "Failed tests:"
    for test in "${FAILED_TESTS[@]}"; do
        echo -e "  ${RED}✗${NC} $test"
    done
    exit 1
else
    echo ""
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
fi
