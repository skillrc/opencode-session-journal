#!/bin/bash
# Minimal test framework for bash scripts
# Provides assert functions and test runner

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
CURRENT_TEST=""

# Test results array
declare -a FAILED_TESTS

# Assert functions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Assertion failed}"
    
    if [ "$expected" = "$actual" ]; then
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}: $CURRENT_TEST"
        echo "  Expected: '$expected'"
        echo "  Actual:   '$actual'"
        echo "  Message:  $message"
        return 1
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local message="${3:-String not found}"
    
    if [[ "$haystack" == *"$needle"* ]]; then
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}: $CURRENT_TEST"
        echo "  Expected to contain: '$needle'"
        echo "  Actual string: '$haystack'"
        echo "  Message: $message"
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    local message="${2:-File does not exist}"
    
    if [ -f "$file" ]; then
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}: $CURRENT_TEST"
        echo "  File not found: $file"
        echo "  Message: $message"
        return 1
    fi
}

assert_dir_exists() {
    local dir="$1"
    local message="${2:-Directory does not exist}"
    
    if [ -d "$dir" ]; then
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}: $CURRENT_TEST"
        echo "  Directory not found: $dir"
        echo "  Message: $message"
        return 1
    fi
}

assert_not_empty() {
    local value="$1"
    local message="${2:-Value is empty}"
    
    if [ -n "$value" ]; then
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}: $CURRENT_TEST"
        echo "  Value is empty"
        echo "  Message: $message"
        return 1
    fi
}

assert_exit_code() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Exit code mismatch}"
    
    if [ "$expected" -eq "$actual" ]; then
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}: $CURRENT_TEST"
        echo "  Expected exit code: $expected"
        echo "  Actual exit code: $actual"
        echo "  Message: $message"
        return 1
    fi
}

# Test runner
run_test() {
    local test_name="$1"
    local test_function="$2"
    
    CURRENT_TEST="$test_name"
    TESTS_RUN=$((TESTS_RUN + 1))
    
    # Run test in subshell to isolate environment
    if (set -e; $test_function); then
        echo -e "${GREEN}✓ PASS${NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        FAILED_TESTS+=("$test_name")
    fi
}

# Test suite summary
print_summary() {
    echo ""
    echo "================================"
    echo "Test Summary"
    echo "================================"
    echo "Total:  $TESTS_RUN"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    
    if [ $TESTS_FAILED -gt 0 ]; then
        echo ""
        echo "Failed tests:"
        for test in "${FAILED_TESTS[@]}"; do
            echo -e "  ${RED}✗${NC} $test"
        done
    fi
    
    echo ""
    
    # Calculate coverage percentage
    if [ $TESTS_RUN -gt 0 ]; then
        local coverage=$((TESTS_PASSED * 100 / TESTS_RUN))
        echo "Coverage: ${coverage}%"
        
        if [ $coverage -ge 80 ]; then
            echo -e "${GREEN}✓ Coverage goal met (80%+)${NC}"
        else
            echo -e "${YELLOW}⚠ Coverage below goal (${coverage}% < 80%)${NC}"
        fi
    fi
    
    echo "================================"
    
    # Exit with failure if any tests failed
    if [ $TESTS_FAILED -gt 0 ]; then
        exit 1
    fi
}

# Setup and teardown helpers
setup_test_env() {
    # Create temporary test directory
    TEST_DIR=$(mktemp -d)
    export TEST_DIR
    export TEST_JOURNAL_DIR="$TEST_DIR/.opencode/session-journals"
}

teardown_test_env() {
    # Clean up test directory
    if [ -n "$TEST_DIR" ] && [ -d "$TEST_DIR" ]; then
        rm -rf "$TEST_DIR"
    fi
}
