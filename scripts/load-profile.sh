#!/bin/bash
# load-profile.sh - Load user profile and inject into session context

set -e

PROFILE_DIR="${HOME}/.opencode/profile"
PROFILE_FILE="${PROFILE_DIR}/user-profile.yaml"

if [ ! -f "$PROFILE_FILE" ]; then
  exit 0
fi

echo "📖 Loading user profile..."

PROFILE_CONTENT=$(cat "$PROFILE_FILE")

PROFILE_PROMPT=$(python3 -c "
import yaml
import sys

try:
    with open('${PROFILE_FILE}', 'r') as f:
        profile = yaml.safe_load(f) or {}
    
    prompt_parts = []
    prompt_parts.append('You are working with a user who has the following characteristics:')
    prompt_parts.append('')
    
    code_style = profile.get('code_style', [])
    if code_style:
        prompt_parts.append('【Code Style Preferences】')
        for pref in code_style[:5]:
            conf = pref.get('confidence', 0)
            if conf >= 0.7:
                prompt_parts.append(f\"- {pref.get('description')} (confidence: {conf})\")
        prompt_parts.append('')
    
    comm_style = profile.get('communication_style', [])
    if comm_style:
        prompt_parts.append('【Communication Style】')
        for pref in comm_style[:3]:
            conf = pref.get('confidence', 0)
            if conf >= 0.7:
                prompt_parts.append(f\"- {pref.get('description')}\")
        prompt_parts.append('')
    
    workflow = profile.get('workflow_preferences', [])
    if workflow:
        prompt_parts.append('【Workflow Preferences】')
        for pref in workflow[:3]:
            conf = pref.get('confidence', 0)
            if conf >= 0.7:
                desc = pref.get('description')
                seq = pref.get('sequence', [])
                if seq:
                    prompt_parts.append(f\"- {desc} (sequence: {' → '.join(seq)})\")
                else:
                    prompt_parts.append(f\"- {desc}\")
        prompt_parts.append('')
    
    decision_patterns = profile.get('decision_patterns', [])
    if decision_patterns:
        prompt_parts.append('【Decision Patterns】')
        for pattern in decision_patterns[:3]:
            conf = pattern.get('confidence', 0)
            if conf >= 0.7:
                prompt_parts.append(f\"- {pattern.get('description')} (confidence: {conf})\")
        prompt_parts.append('')
    
    skill_levels = profile.get('skill_levels', {})
    if skill_levels:
        prompt_parts.append('【Skill Levels】')
        for domain, level in skill_levels.items():
            prompt_parts.append(f\"- {domain}: {level}\")
        prompt_parts.append('')
    
    prompt_parts.append('Please adapt your responses and code style according to these preferences.')
    
    print('\\n'.join(prompt_parts))

except Exception as e:
    print(f'Error loading profile: {e}', file=sys.stderr)
    sys.exit(1)
")

echo "$PROFILE_PROMPT"
echo ""
echo "✅ User profile loaded into session context"
