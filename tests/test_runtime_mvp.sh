#!/bin/bash

source "$(dirname "$0")/test_framework.sh"

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

test_runtime_mvp_write_and_load() {
  setup_test_env
  local wrapper_save="$ROOT_DIR/opencode-session-journal/commands/session-journal-save.sh"
  local wrapper_load="$ROOT_DIR/opencode-session-journal/commands/session-journal-load.sh"
  local journal_input="Test MVP journaling"
  local path=$(echo "$journal_input" | "$wrapper_save")
  assert_not_empty "$path" "Save wrapper should return path to journal"
  assert_file_exists "$path" "Journal file should be created by MVP save"
  local loaded=$(echo "" | "$wrapper_load")
  assert_not_empty "$loaded" "Load wrapper should return a path for the latest journal"
  teardown_test_env
}

test_runtime_mvp_profile_wrapper() {
  setup_test_env
  local wrapper_profile="$ROOT_DIR/opencode-session-journal/commands/session-journal-profile.sh"
  if [ -x "$wrapper_profile" ]; then
    if "$wrapper_profile" >/dev/null 2>&1; then
      : # wrapper run succeeded
    else
      echo "Profile wrapper failed"; teardown_test_env; return 1
    fi
  else
    echo "Profile wrapper not executable"; teardown_test_env; return 1
  fi
  teardown_test_env
}

test_runtime_mvp_search_wrapper() {
  setup_test_env
  local wrapper_search="$ROOT_DIR/opencode-session-journal/commands/session-journal-search.sh"
  if [ -x "$wrapper_search" ]; then
    if "$wrapper_search" >/dev/null 2>&1; then
      : # wrapper run succeeded (even if MVP not implemented yet)
    else
      echo "Search wrapper failed"; teardown_test_env; return 1
    fi
  else
    echo "Search wrapper not executable"; teardown_test_env; return 1
  fi
  teardown_test_env
}

echo "Running MVP Runtime Tests..."
echo "================================"

run_test "MVP Runtime: Write" test_runtime_mvp_write_and_load

print_summary
