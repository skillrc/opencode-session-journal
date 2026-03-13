#!/bin/bash
# analyze-profile.sh - Analyze journals and update user profile

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
JOURNAL_BASE_DIR="${HOME}/.opencode/session-journals"
PROFILE_DIR="${HOME}/.opencode/profile"
AGENT_FILE="${SKILL_ROOT}/agents/profile-analyzer.md"

mkdir -p "$PROFILE_DIR"
mkdir -p "$PROFILE_DIR/changelog"

PROFILE_FILE="${PROFILE_DIR}/user-profile.yaml"
CHANGELOG_FILE="${PROFILE_DIR}/changelog/$(date +%Y-%m-%d-%H%M%S)-update.yaml"

DRY_RUN=false
SHOW_PROFILE=false
FORCE_ALL=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --show)
      SHOW_PROFILE=true
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

if [ "$SHOW_PROFILE" = true ]; then
  if [ -f "$PROFILE_FILE" ]; then
    echo "📊 Current User Profile:"
    echo ""
    cat "$PROFILE_FILE"
  else
    echo "⚠️  No user profile found yet."
    echo "💡 Run /session-journal-profile to create one."
  fi
  exit 0
fi

if [ ! -d "$JOURNAL_BASE_DIR" ]; then
  echo "⚠️  No journals found in ${JOURNAL_BASE_DIR}"
  exit 1
fi

echo "🔍 Finding journals to analyze..."

if [ "$FORCE_ALL" = true ]; then
  JOURNALS=$(find "$JOURNAL_BASE_DIR" -name "journal-*.md" -type f -exec grep -l "content_complete: true" {} \; | sort -r | head -20)
else
  JOURNALS=$(find "$JOURNAL_BASE_DIR" -name "journal-*.md" -type f -exec grep -l "content_complete: true" {} \; -exec grep -l "profiled: false" {} \; | sort -r | head -10)
fi

JOURNAL_COUNT=$(echo "$JOURNALS" | wc -l)

if [ -z "$JOURNALS" ] || [ "$JOURNAL_COUNT" -eq 0 ]; then
  echo "✅ All journals already profiled."
  exit 0
fi

echo "📚 Found ${JOURNAL_COUNT} journals to analyze"

CURRENT_PROFILE=""
if [ -f "$PROFILE_FILE" ]; then
  CURRENT_PROFILE=$(cat "$PROFILE_FILE")
fi

JOURNALS_CONTENT=""
for journal in $JOURNALS; do
  if [ -f "$journal" ]; then
    JOURNAL_NAME=$(basename "$journal")
    JOURNALS_CONTENT="${JOURNALS_CONTENT}

=== ${JOURNAL_NAME} ===
$(head -100 "$journal")
"
  fi
done

PROMPT=$(cat <<EOF
Current User Profile:
${CURRENT_PROFILE:-"No existing profile"}

Recent Journals to Analyze:
${JOURNALS_CONTENT}

Analyze these journals and generate profile updates as JSON.
EOF
)

echo "🤖 Analyzing with AI..."

PROFILE_JSON=$(echo "$PROMPT" | claude --agent profile-analyzer --print 2>/dev/null || echo '{}')

if [ "$DRY_RUN" = true ]; then
  echo "🔍 Dry run - would update profile with:"
  echo "$PROFILE_JSON" | jq '.' 2>/dev/null || echo "$PROFILE_JSON"
  exit 0
fi

if command -v jq >/dev/null 2>&1; then
  echo "$PROFILE_JSON" | jq '.' > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "⚠️  Invalid JSON response from AI"
    exit 1
  fi
fi

echo "$PROFILE_JSON" | python3 -c "
import json
import sys
import yaml
from datetime import datetime

try:
    profile_updates = json.load(sys.stdin)
    
    profile_file = '${PROFILE_FILE}'
    changelog_file = '${CHANGELOG_FILE}'
    
    existing_profile = {}
    try:
        with open(profile_file, 'r') as f:
            existing_profile = yaml.safe_load(f) or {}
    except FileNotFoundError:
        pass
    
    updates = profile_updates.get('profile_updates', {})
    
    for category, items in updates.items():
        if category not in existing_profile:
            existing_profile[category] = []
        
        if isinstance(items, dict):
            existing_profile[category] = items
        elif isinstance(items, list):
            existing_ids = {item.get('id'): item for item in existing_profile[category] if isinstance(item, dict)}
            
            for new_item in items:
                item_id = new_item.get('id')
                if item_id in existing_ids:
                    existing_ids[item_id].update(new_item)
                else:
                    existing_profile[category].append(new_item)
            
            existing_profile[category] = list(existing_ids.values())
    
    with open(profile_file, 'w') as f:
        yaml.dump(existing_profile, f, default_flow_style=False, allow_unicode=True)
    
    changelog_entry = {
        'timestamp': datetime.now().isoformat(),
        'changes': profile_updates.get('changelog', []),
        'contradictions': profile_updates.get('contradictions', []),
        'confidence_summary': profile_updates.get('confidence_summary', {})
    }
    
    with open(changelog_file, 'w') as f:
        yaml.dump(changelog_entry, f, default_flow_style=False, allow_unicode=True)
    
    print('✅ Profile updated successfully')
    
    changelog = profile_updates.get('changelog', [])
    if changelog:
        print('')
        print('📝 Changes:')
        for change in changelog[:5]:
            change_type = change.get('type', 'unknown')
            if change_type == 'preference_added':
                print(f\"   + New: {change.get('id')} (confidence: {change.get('confidence')})\")
            elif change_type == 'preference_strengthened':
                print(f\"   ↑ Strengthened: {change.get('id')} ({change.get('old_confidence')} → {change.get('new_confidence')})\")
            elif change_type == 'skill_level_upgraded':
                print(f\"   ⬆ Skill upgrade: {change.get('domain')} ({change.get('old_level')} → {change.get('new_level')})\")
    
    contradictions = profile_updates.get('contradictions', [])
    if contradictions:
        print('')
        print('⚠️  Contradictions detected:')
        for contradiction in contradictions[:3]:
            print(f\"   - {contradiction.get('description')}\")
            if contradiction.get('requires_user_confirmation'):
                print(f\"     Suggested: {contradiction.get('suggested_resolution')}\")

except Exception as e:
    print(f'❌ Error updating profile: {e}', file=sys.stderr)
    sys.exit(1)
"

for journal in $JOURNALS; do
  if [ -f "$journal" ]; then
    sed -i 's/profiled: false/profiled: true/' "$journal" 2>/dev/null || true
  fi
done

echo ""
echo "💡 Profile saved to: ${PROFILE_FILE}"
echo "📜 Changelog saved to: ${CHANGELOG_FILE}"
echo ""
echo "💡 View profile: /session-journal-profile --show"
