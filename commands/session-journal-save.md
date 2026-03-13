---
name: session-journal-save
description: Save current session with AI-generated metadata
command: true
---

# Session Journal Save

Save the current session as a complete journal generated from the current conversation context.

## Usage

```bash
/session-journal-save
/session-journal-save "User note"
/session-journal-save --add-tags "important,review"
```

## Options

- `"User note"` - Optional note to add to the journal
- `--add-tags "tag1,tag2"` - Add user-defined tags

## What It Does

1. Uses the current AI session context directly
2. Generates complete journal content and metadata in the same conversation
3. Writes the finished markdown to `.opencode/session-journals/` with org-roam structure
4. Updates search indexes after the file is written

## Execution Model

This command must be executed in-context.

The current AI session is responsible for:
- analyzing the current conversation
- generating tags, topics, categories, patterns, and preferences
- writing the full timeline, decisions, summary, and next steps

Scripts are responsible only for:
- generating the journal path
- writing the provided markdown to disk
- updating indexes

The save command must not rely on a shell script to guess session content.

## In-Context Workflow

When this command is used, the assistant should follow this exact sequence:

1. Review the current conversation and summarize the real work completed.
2. Generate a full journal in markdown with YAML frontmatter.
3. Include `content_complete: true` in the frontmatter.
4. Include real content for:
   - task
   - session timeline
   - completed work
   - problems solved
   - key decisions
   - current state
   - pending tasks
   - important files
   - recommendations for next session
5. Send the complete markdown to `scripts/write-journal.sh` through stdin.
6. Report the saved file path back to the user.

## What Must Never Happen

- Do not leave placeholders like `[To be filled during session]`
- Do not write empty timeline sections
- Do not fabricate session content from shell history alone
- Do not let incomplete journals enter the knowledge graph or profile system

## Required Output Structure

The saved journal must contain:

- YAML frontmatter
- `content_complete: true`
- complete task description
- timeline of work performed
- problems solved
- key decisions
- current state
- pending tasks
- important files
- recommendations for next session

## Output

```
✅ Journal saved: .opencode/session-journals/year-2026-Horse/month-03-March/day-13-Friday/journal-1741234567-14:30:00.md

🤖 AI-generated metadata:
   Tags: java, spring-boot, webank-sdk, integration
   Topic: backend-integration
   Category: backend feature-implementation (complex)
   Confidence: 0.88

💡 Next steps:
   - View: cat "[journal-file]"
   - Load: /session-journal-load
   - Learn: /session-journal-learn
   - Profile: /session-journal-profile
```

## Save Procedure

1. Generate the complete journal markdown in the current session.
2. Ensure the frontmatter contains `content_complete: true`.
3. Get a destination path from `scripts/generate-journal-path.sh`.
4. Pipe the markdown into `scripts/write-journal.sh`.
5. Let the writer update indexes automatically.

## Writer Example

```bash
cat <<'EOF' | ${CLAUDE_PLUGIN_ROOT}/skills/opencode-session-journal/scripts/write-journal.sh
---
session_id: ses_example
datetime: 2026-03-13 22:10:00
content_complete: true
tags:
  auto: [example]
  user: []
  confidence: 0.9
topics:
  primary: session-memory
  secondary: []
  confidence: 0.9
categories:
  domain: tooling
  type: refactor
  complexity: medium
  phase: implementation
summary: |
  Example complete journal.
patterns_detected: []
preferences_observed: []
links:
  related_sessions: []
  related_skills: []
  related_files: []
backlinks: []
learned: false
profiled: false
last_accessed: 2026-03-13 22:10:00
user_note: ""
user_rating: null
user_flags: []
---

# Session Journal - ses_example

**Start Time**: 2026-03-13 22:10:00
**Task**: Example task

---

## Session Timeline

### ✅ Completed
- Example content

---

## 📊 Session Summary

### Completed Work
1. ✅ Example
EOF
```

## Model Usage

Uses the current session model because the current session generates the journal directly.
