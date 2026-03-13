#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
JOURNAL_BASE_DIR="${HOME}/.opencode/session-journals"
KG_DIR="${HOME}/.opencode/knowledge-graph"

mkdir -p "$KG_DIR"

TAGS_INDEX="${KG_DIR}/tags.json"
LINKS_INDEX="${KG_DIR}/links.json"
TOPICS_INDEX="${KG_DIR}/topics.json"

JOURNAL_FILE="$1"

if [ -z "$JOURNAL_FILE" ] || [ ! -f "$JOURNAL_FILE" ]; then
  echo "Usage: $0 <journal-file>"
  exit 1
fi

JOURNAL_NAME=$(basename "$JOURNAL_FILE")

python3 <<EOF
import json
import yaml
import sys
from pathlib import Path

journal_file = Path('$JOURNAL_FILE')
tags_index_file = Path('$TAGS_INDEX')
links_index_file = Path('$LINKS_INDEX')
topics_index_file = Path('$TOPICS_INDEX')

try:
    with open(journal_file, 'r') as f:
        content = f.read()
    
    if '---' not in content:
        sys.exit(0)
    
    parts = content.split('---', 2)
    if len(parts) < 3:
        sys.exit(0)
    
    frontmatter = yaml.safe_load(parts[1])
    if not frontmatter or frontmatter.get('content_complete') is not True:
        sys.exit(0)
    
    tags_index = {}
    if tags_index_file.exists():
        with open(tags_index_file, 'r') as f:
            tags_index = json.load(f)
    
    tags_data = frontmatter.get('tags', {})
    auto_tags = tags_data.get('auto', [])
    user_tags = tags_data.get('user', [])
    all_tags = auto_tags + user_tags
    
    for tag in all_tags:
        if tag not in tags_index:
            tags_index[tag] = []
        if '$JOURNAL_NAME' not in tags_index[tag]:
            tags_index[tag].append('$JOURNAL_NAME')
    
    with open(tags_index_file, 'w') as f:
        json.dump(tags_index, f, indent=2)
    
    topics_index = {}
    if topics_index_file.exists():
        with open(topics_index_file, 'r') as f:
            topics_index = json.load(f)
    
    topics_data = frontmatter.get('topics', {})
    primary_topic = topics_data.get('primary')
    secondary_topics = topics_data.get('secondary', [])
    
    if primary_topic:
        if primary_topic not in topics_index:
            topics_index[primary_topic] = []
        if '$JOURNAL_NAME' not in topics_index[primary_topic]:
            topics_index[primary_topic].append('$JOURNAL_NAME')
    
    for topic in secondary_topics:
        if topic not in topics_index:
            topics_index[topic] = []
        if '$JOURNAL_NAME' not in topics_index[topic]:
            topics_index[topic].append('$JOURNAL_NAME')
    
    with open(topics_index_file, 'w') as f:
        json.dump(topics_index, f, indent=2)
    
    links_index = {}
    if links_index_file.exists():
        with open(links_index_file, 'r') as f:
            links_index = json.load(f)
    
    links_data = frontmatter.get('links', {})
    links_index['$JOURNAL_NAME'] = links_data
    
    with open(links_index_file, 'w') as f:
        json.dump(links_index, f, indent=2)
    
    print('✅ Knowledge graph updated')

except Exception as e:
    print(f'Error updating knowledge graph: {e}', file=sys.stderr)
    sys.exit(1)
EOF
