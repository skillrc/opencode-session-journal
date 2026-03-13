#!/bin/bash
# search-journals.sh - Search journals by tags, topics, dates

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
JOURNAL_BASE_DIR="${HOME}/.opencode/session-journals"
KG_DIR="${HOME}/.opencode/knowledge-graph"

TAGS_INDEX="${KG_DIR}/tags.json"
TOPICS_INDEX="${KG_DIR}/topics.json"

SEARCH_TAGS=""
SEARCH_TOPIC=""
SEARCH_FROM=""
SEARCH_TO=""
SEARCH_TEXT=""
SEARCH_DOMAIN=""
SEARCH_TYPE=""
SEARCH_COMPLEXITY=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --tags)
      SEARCH_TAGS="$2"
      shift 2
      ;;
    --topic)
      SEARCH_TOPIC="$2"
      shift 2
      ;;
    --from)
      SEARCH_FROM="$2"
      shift 2
      ;;
    --to)
      SEARCH_TO="$2"
      shift 2
      ;;
    --text)
      SEARCH_TEXT="$2"
      shift 2
      ;;
    --domain)
      SEARCH_DOMAIN="$2"
      shift 2
      ;;
    --type)
      SEARCH_TYPE="$2"
      shift 2
      ;;
    --complexity)
      SEARCH_COMPLEXITY="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

if [ -z "$SEARCH_TAGS" ] && [ -z "$SEARCH_TOPIC" ] && [ -z "$SEARCH_FROM" ] && [ -z "$SEARCH_TEXT" ] && [ -z "$SEARCH_DOMAIN" ]; then
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  --tags TAG1,TAG2       Search by tags (AND logic)"
  echo "  --topic TOPIC          Search by topic"
  echo "  --from YYYY-MM-DD      Search from date"
  echo "  --to YYYY-MM-DD        Search to date"
  echo "  --text TEXT            Search by text content"
  echo "  --domain DOMAIN        Search by domain (backend/frontend/etc)"
  echo "  --type TYPE            Search by type (feature/bug-fix/etc)"
  echo "  --complexity LEVEL     Search by complexity (simple/medium/complex)"
  exit 1
fi

MATCHING_JOURNALS=""

if [ -n "$SEARCH_TAGS" ]; then
  if [ ! -f "$TAGS_INDEX" ]; then
    echo "⚠️  No tags index found. Run /session-journal-save first."
    exit 1
  fi
  
  IFS=',' read -ra TAG_ARRAY <<< "$SEARCH_TAGS"
  
  MATCHING_JOURNALS=$(python3 <<EOF
import json
from pathlib import Path

tags_index_file = Path('$TAGS_INDEX')
with open(tags_index_file, 'r') as f:
    tags_index = json.load(f)

search_tags = [tag.strip() for tag in '$SEARCH_TAGS'.split(',')]

matching_sets = []
for tag in search_tags:
    if tag in tags_index:
        matching_sets.append(set(tags_index[tag]))
    else:
        matching_sets.append(set())

if matching_sets:
    result = matching_sets[0]
    for s in matching_sets[1:]:
        result = result.intersection(s)
    
    for journal in sorted(result):
        print(journal)
EOF
)
fi

if [ -n "$SEARCH_TOPIC" ]; then
  if [ ! -f "$TOPICS_INDEX" ]; then
    echo "⚠️  No topics index found. Run /session-journal-save first."
    exit 1
  fi
  
  TOPIC_JOURNALS=$(python3 <<EOF
import json
from pathlib import Path

topics_index_file = Path('$TOPICS_INDEX')
with open(topics_index_file, 'r') as f:
    topics_index = json.load(f)

topic = '$SEARCH_TOPIC'
if topic in topics_index:
    for journal in sorted(topics_index[topic]):
        print(journal)
EOF
)
  
  if [ -z "$MATCHING_JOURNALS" ]; then
    MATCHING_JOURNALS="$TOPIC_JOURNALS"
  else
    MATCHING_JOURNALS=$(comm -12 <(echo "$MATCHING_JOURNALS" | sort) <(echo "$TOPIC_JOURNALS" | sort))
  fi
fi

if [ -z "$MATCHING_JOURNALS" ]; then
  MATCHING_JOURNALS=$(find "$JOURNAL_BASE_DIR" -name "journal-*.md" -type f | sort -r)
fi

if [ -n "$SEARCH_FROM" ] || [ -n "$SEARCH_TO" ] || [ -n "$SEARCH_TEXT" ] || [ -n "$SEARCH_DOMAIN" ] || [ -n "$SEARCH_TYPE" ] || [ -n "$SEARCH_COMPLEXITY" ]; then
  FILTERED_JOURNALS=""
  
  for journal in $MATCHING_JOURNALS; do
    if [ ! -f "$journal" ]; then
      continue
    fi
    
    JOURNAL_DATE=$(basename "$journal" | sed 's/journal-\([0-9]*\)-.*/\1/')
    JOURNAL_DATE_READABLE=$(date -d "@$JOURNAL_DATE" +%Y-%m-%d 2>/dev/null || echo "")
    
    if [ -n "$SEARCH_FROM" ] && [ "$JOURNAL_DATE_READABLE" \< "$SEARCH_FROM" ]; then
      continue
    fi
    
    if [ -n "$SEARCH_TO" ] && [ "$JOURNAL_DATE_READABLE" \> "$SEARCH_TO" ]; then
      continue
    fi
    
    if [ -n "$SEARCH_TEXT" ]; then
      if ! grep -q "$SEARCH_TEXT" "$journal"; then
        continue
      fi
    fi
    
    if [ -n "$SEARCH_DOMAIN" ] || [ -n "$SEARCH_TYPE" ] || [ -n "$SEARCH_COMPLEXITY" ]; then
      MATCH=true
      
      if [ -n "$SEARCH_DOMAIN" ]; then
        if ! grep -q "domain: $SEARCH_DOMAIN" "$journal"; then
          MATCH=false
        fi
      fi
      
      if [ -n "$SEARCH_TYPE" ]; then
        if ! grep -q "type: $SEARCH_TYPE" "$journal"; then
          MATCH=false
        fi
      fi
      
      if [ -n "$SEARCH_COMPLEXITY" ]; then
        if ! grep -q "complexity: $SEARCH_COMPLEXITY" "$journal"; then
          MATCH=false
        fi
      fi
      
      if [ "$MATCH" = false ]; then
        continue
      fi
    fi
    
    FILTERED_JOURNALS="${FILTERED_JOURNALS}${journal}\n"
  done
  
  MATCHING_JOURNALS=$(echo -e "$FILTERED_JOURNALS" | grep -v '^$')
fi

RESULT_COUNT=$(echo "$MATCHING_JOURNALS" | grep -c "journal-" || echo "0")

if [ "$RESULT_COUNT" -eq 0 ]; then
  echo "🔍 No journals found matching your criteria."
  exit 0
fi

echo "🔍 Found ${RESULT_COUNT} matching journal(s):"
echo ""

for journal in $MATCHING_JOURNALS; do
  if [ ! -f "$journal" ]; then
    continue
  fi
  
  JOURNAL_NAME=$(basename "$journal")
  JOURNAL_DATE=$(echo "$JOURNAL_NAME" | sed 's/journal-\([0-9]*\)-.*/\1/')
  JOURNAL_DATE_READABLE=$(date -d "@$JOURNAL_DATE" +"%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "")
  
  SUMMARY=$(grep -A 3 "^summary:" "$journal" | tail -2 | sed 's/^  //' || echo "")
  TAGS=$(grep "auto: \[" "$journal" | sed 's/.*auto: \[\(.*\)\]/\1/' || echo "")
  TOPIC=$(grep "primary:" "$journal" | sed 's/.*primary: //' || echo "")
  
  echo "📄 ${JOURNAL_DATE_READABLE}"
  echo "   File: ${journal}"
  if [ -n "$TAGS" ]; then
    echo "   Tags: ${TAGS}"
  fi
  if [ -n "$TOPIC" ]; then
    echo "   Topic: ${TOPIC}"
  fi
  if [ -n "$SUMMARY" ]; then
    echo "   Summary: ${SUMMARY}"
  fi
  echo ""
done

echo "💡 Load a journal: /session-journal-load YYYY-MM-DD"
