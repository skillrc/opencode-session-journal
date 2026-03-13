---
name: session-journal-learn
description: Extract reusable skills and learnings from complete journals
command: true
---

# Session Journal Learn

Extract reusable learnings from complete journals and store them as structured skills.

## Usage

```bash
/session-journal-learn
/session-journal-learn --all
/session-journal-learn --dry-run
```

## What It Does

1. Finds journals with `content_complete: true`
2. Skips journals already marked as `learned: true` unless `--all` is used
3. Extracts reusable patterns, workflows, and decision heuristics
4. Saves them into `.opencode/learned/`
5. Marks processed journals as learned

## Extraction Targets

- Reusable workflow patterns
- Decision heuristics
- Debugging approaches
- User preference signals worth preserving as skills

## Important

Only complete journals may be used for learning.
Template journals or incomplete journals must never produce learned artifacts.
