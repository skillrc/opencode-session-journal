---
name: session-journal-verify
description: Validate journal files for completeness and structure
command: true
---

# Session Journal Verify

Validate all saved journals for structural completeness and required fields.

## Usage

```bash
/session-journal-verify
```

## What It Validates

For each journal file:
- ✅ Frontmatter delimiter (`---`)
- ✅ `content_complete: true` flag
- ✅ `session_id` field
- ✅ `summary` field
- ✅ Session Journal header
- ✅ Session Timeline section
- ✅ Session Summary section

## Output

```
🔍 Validating session journals...

Checking: journal-2026-03-13-14:30:00.md
  ✅ Basic structure valid

Checking: journal-2026-03-13-12:15:00.md
  ⚠️  Missing summary
  ✅ Basic structure valid

📊 Validation Results:
  Errors: 0
  Warnings: 1
⚠️  Validation passed with warnings
```

## Exit Codes

- `0` - Validation passed (may have warnings)
- `1` - Validation failed with errors

## Important

Use this command to identify incomplete or corrupted journals.
Only journals with `content_complete: true` and all required fields should be used for profile building and learning.
