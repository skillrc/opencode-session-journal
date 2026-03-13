---
name: session-journal-load
description: Load and display a saved complete session journal
command: true
---

# Session Journal Load

Load and display previously saved session journals.

## Usage

```bash
/session-journal-load
/session-journal-load list
/session-journal-load 2026-03-09
/session-journal-load ses_abc123
```

## Implementation

```bash
#!/bin/bash
${CLAUDE_PLUGIN_ROOT}/skills/opencode-session-journal/scripts/load-journal.sh "$@"
```

## What It Does

1. Resolves the target journal by latest, date, session id, or list mode
2. Reads the matching journal file
3. Prints the full journal so the current AI session can absorb context
4. Allows the assistant to continue from the saved state

## Important

Prefer journals with `content_complete: true` when continuing serious work.
If multiple journals match a date, review the most relevant one before continuing.

## Examples

**Load most recent:**
```
/session-journal-load
```

**List all journals:**
```
/session-journal-load list
```

**Load specific date:**
```
/session-journal-load 2026-03-09
```

**Load by session ID:**
```
/session-journal-load ses_abc123
```

## Error Handling

If no journals found:
- Display: "❌ No session journals found. Use /session-journal-save to create one."
- STOP

If journal file is corrupted or unreadable:
- Display: "⚠️ Journal file corrupted: [path]"
- Try next most recent journal
- If all fail, STOP with error message
