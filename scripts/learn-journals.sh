#!/bin/bash
set -euo pipefail

JOURNAL_DIR="${HOME}/.opencode/session-journals"
LEARNED_DIR="${HOME}/.opencode/learned"
DRY_RUN=false
FORCE_ALL=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --all)
      FORCE_ALL=true
      shift
      ;;
    *)
      shift
      ;;
  esac
done

mkdir -p "$LEARNED_DIR"

if [ "$FORCE_ALL" = true ]; then
  JOURNALS=$(find "$JOURNAL_DIR" -name 'journal-*.md' -type f -exec grep -l 'content_complete: true' {} \; | sort -r | head -20)
else
  JOURNALS=$(find "$JOURNAL_DIR" -name 'journal-*.md' -type f -exec grep -l 'content_complete: true' {} \; -exec grep -l 'learned: false' {} \; | sort -r | head -20)
fi

if [ -z "${JOURNALS:-}" ]; then
  echo "✅ No journals available for learning."
  exit 0
fi

COUNT=0
for journal in $JOURNALS; do
  COUNT=$((COUNT + 1))
  base="$(basename "$journal" .md)"
  target="$LEARNED_DIR/${base}-learning.md"
  
  python3 - <<EOF
from pathlib import Path
import yaml
import re

journal_path = Path("$journal")
text = journal_path.read_text()
parts = text.split('---', 2)

frontmatter = yaml.safe_load(parts[1]) if len(parts) >= 3 else {}
summary = frontmatter.get('summary', '').strip()
patterns = frontmatter.get('patterns_detected', [])
preferences = frontmatter.get('preferences_observed', [])

body = parts[2] if len(parts) >= 3 else text

completed_work = []
problems_solved = []
key_decisions = []

in_completed = False
in_problems = False
in_decisions = False

for line in body.split('\n'):
    line = line.strip()
    
    if '### Completed Work' in line:
        in_completed = True
        in_problems = False
        in_decisions = False
        continue
    elif '### Problems Solved' in line:
        in_completed = False
        in_problems = True
        in_decisions = False
        continue
    elif '### Key Decisions' in line:
        in_completed = False
        in_problems = False
        in_decisions = True
        continue
    elif line.startswith('### ') and in_completed:
        in_completed = False
    elif line.startswith('### ') and in_problems:
        in_problems = False
    elif line.startswith('### ') and in_decisions:
        in_decisions = False
    
    if in_completed and line.startswith('- ') or line.startswith('1. ') or line.startswith('2. '):
        item = re.sub(r'^[\-\d\.\s]+', '', line)
        if item and len(item) > 10:
            completed_work.append(item)
    elif in_problems and line.startswith('- ') or line.startswith('1. ') or line.startswith('2. '):
        item = re.sub(r'^[\-\d\.\s]+', '', line)
        if item and len(item) > 10:
            problems_solved.append(item)
    elif in_decisions and line.startswith('- '):
        item = re.sub(r'^[\-\d\.\s]+', '', line)
        if item and len(item) > 10:
            key_decisions.append(item)

completed_work = completed_work[:5]
problems_solved = problems_solved[:5]
key_decisions = key_decisions[:5]

task_match = re.search(r'\*\*Task\*\*:\s*(.+?)(?:\n|$)', body)
task = task_match.group(1).strip() if task_match else "Unknown task"

print(f"task: {task}")
print(f"summary: {summary}")
print("completed_work:")
for item in completed_work:
    print(f"  - {item}")
print("problems_solved:")
for item in problems_solved:
    print(f"  - {item}")
print("key_decisions:")
for item in key_decisions:
    print(f"  - {item}")
print("patterns:")
for p in patterns[:3]:
    print(f"  - {p.get('id', 'unknown')}: {p.get('description', '')}")
print("preferences:")
for p in preferences[:3]:
    print(f"  - {p.get('id', 'unknown')}: {p.get('description', '')}")
EOF

done

if [ "$DRY_RUN" = true ]; then
  echo "🔍 Dry run completed for $COUNT journal(s)."
else
  echo "✅ Learned artifacts created for $COUNT journal(s)."
fi
