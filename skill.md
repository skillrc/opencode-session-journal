---
name: opencode-session-journal
description: Save session progress for continuation in future sessions, or load previous session context to continue work
---

# OpenCode Session Journal

Session memory system that records complete AI session context in structured markdown format.

## When to Use

**Save a journal when:**
- Completing a major milestone or phase of work
- Context usage approaching 80%+ and you need to continue later
- Ending a work session with incomplete tasks
- Before switching to a different task or project
- After solving complex problems worth documenting

**Load a journal when:**
- Starting a new session to continue previous work
- Need to understand what was done in past sessions
- Reviewing decision history and problem solutions

**Do NOT use for:**
- Every minor action (too granular)
- Simple one-off tasks (no continuation needed)
- When built-in `/handoff` command is sufficient

## Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/session-journal-save` | Save current session | `/session-journal-save "Completed SDK integration"` |
| `/session-journal-load` | Load most recent | `/session-journal-load` |
| `/session-journal-load DATE` | Load specific date | `/session-journal-load 2026-03-09` |
| `/session-journal-load list` | List all journals | `/session-journal-load list` |

## Important

`/session-journal-save` must be executed in the current AI conversation context.
It should not depend on an external shell script to reconstruct the session body.
The current session generates the full journal content, and scripts only handle deterministic file writing and indexing.

Complete journals must include `content_complete: true`. Incomplete journals are not valid memory artifacts.

## Log Structure

Logs saved to `.opencode/session-journals/` with org-roam-inspired hierarchy:

```
.opencode/session-journals/
  year-2026-Horse/
    month-03-March/
      day-09-Monday/
        journal-1741234567-02:16:45.md
```

**Format:**
- `year-YYYY-Zodiac` - Year with Chinese zodiac (2026 = Horse)
- `month-MM-MonthName` - Month number and full name
- `day-DD-Weekday` - Day number and weekday name
- `journal-{timestamp}-{HH:MM:SS}.md` - Unix timestamp + readable time
