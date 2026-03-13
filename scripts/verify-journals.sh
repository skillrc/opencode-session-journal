#!/bin/bash
set -euo pipefail

JOURNAL_DIR="${HOME}/.opencode/session-journals"
ERRORS=0
WARNINGS=0

if [ ! -d "$JOURNAL_DIR" ]; then
  echo "❌ Journal directory not found: $JOURNAL_DIR"
  exit 1
fi

echo "🔍 Validating session journals..."
echo ""

for journal in $(find "$JOURNAL_DIR" -name 'journal-*.md' -type f); do
  echo "Checking: $(basename "$journal")"
  
  if ! grep -q '^---$' "$journal"; then
    echo "  ❌ Missing frontmatter delimiter"
    ERRORS=$((ERRORS + 1))
    continue
  fi
  
  if ! grep -q '^content_complete: true$' "$journal"; then
    echo "  ⚠️  Missing or incorrect content_complete flag"
    WARNINGS=$((WARNINGS + 1))
  fi
  
  if ! grep -q '^session_id:' "$journal"; then
    echo "  ❌ Missing session_id"
    ERRORS=$((ERRORS + 1))
  fi
  
  if ! grep -q '^summary:' "$journal"; then
    echo "  ⚠️  Missing summary"
    WARNINGS=$((WARNINGS + 1))
  fi
  
  if ! grep -q '^# Session Journal' "$journal"; then
    echo "  ❌ Missing Session Journal header"
    ERRORS=$((ERRORS + 1))
  fi
  
  if ! grep -q '## Session Timeline' "$journal"; then
    echo "  ⚠️  Missing Session Timeline section"
    WARNINGS=$((WARNINGS + 1))
  fi
  
  if ! grep -q '## 📊 Session Summary' "$journal"; then
    echo "  ⚠️  Missing Session Summary section"
    WARNINGS=$((WARNINGS + 1))
  fi
  
  echo "  ✅ Basic structure valid"
done

echo ""
echo "📊 Validation Results:"
echo "  Errors: $ERRORS"
echo "  Warnings: $WARNINGS"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo "✅ All journals validated successfully!"
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo "⚠️  Validation passed with warnings"
  exit 0
else
  echo "❌ Validation failed with errors"
  exit 1
fi
