---
name: session-journal-profile
description: Analyze journals and update user profile
command: true
---

# Session Journal Profile

Analyze session journals to build and update your user profile.

## Usage

```bash
/session-journal-profile
/session-journal-profile --show
/session-journal-profile --all
/session-journal-profile --dry-run
```

## Options

- `--show` - Display current user profile
- `--all` - Analyze all journals (not just unprofiled ones)
- `--dry-run` - Preview changes without updating profile

## Implementation

```bash
#!/bin/bash
${CLAUDE_PLUGIN_ROOT}/skills/opencode-session-journal/scripts/analyze-profile.sh "$@"
```

## What It Does

1. Finds journals marked `content_complete: true` and `profiled: false`
2. Calls profile-analyzer agent to extract preferences
3. Updates user profile in `.opencode/profile/user-profile.yaml`
4. Saves changelog to `.opencode/profile/changelog/`
5. Marks journals as `profiled: true`

Incomplete template journals must not be profiled.

## Profile Structure

```yaml
code_style:
  - id: prefer-functional-style
    description: "Prefers functional programming over OOP"
    confidence: 0.85
    evidence_count: 12
    examples: [journal-1741234567.md, ...]
    first_observed: "2026-03-01"
    last_reinforced: "2026-03-13"

communication_style:
  - id: prefer-concise-responses
    description: "Prefers direct answers"
    confidence: 0.78
    evidence_count: 8

workflow_preferences:
  - id: research-then-implement
    description: "Always researches before implementing"
    sequence: [research, compare, implement, test]
    confidence: 0.88
    evidence_count: 15

tech_preferences:
  react:
    - id: prefer-hooks-over-class
      confidence: 0.95
  backend:
    - id: prefer-explicit-error-handling
      confidence: 0.82

decision_patterns:
  - id: security-over-convenience
    description: "Prioritizes security"
    confidence: 0.88
    evidence_count: 14

skill_levels:
  typescript: advanced
  react: advanced
  backend: intermediate
  devops: beginner
```

## Output

```
🔍 Finding journals to analyze...
📚 Found 10 journals to analyze
🤖 Analyzing with AI...
✅ Profile updated successfully

📝 Changes:
   + New: security-over-convenience (confidence: 0.88)
   ↑ Strengthened: prefer-functional-style (0.75 → 0.85)
   ⬆ Skill upgrade: typescript (intermediate → advanced)

⚠️  Contradictions detected:
   - Sometimes uses functional style, sometimes uses classes
     Suggested: May depend on project context

💡 Profile saved to: ~/.opencode/profile/user-profile.yaml
📜 Changelog saved to: ~/.opencode/profile/changelog/2026-03-13-143000-update.yaml

💡 View profile: /session-journal-profile --show
```

## Model Usage

Uses the session's current model via the profile-analyzer agent.
