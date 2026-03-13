---
name: session-journal-search
description: Search journals by tags, topics, dates, or content
command: true
---

# Session Journal Search

Search through your session journals using various criteria.

## Usage

```bash
/session-journal-search --tags "auth,security"
/session-journal-search --topic "backend-integration"
/session-journal-search --from 2026-03-01 --to 2026-03-13
/session-journal-search --text "JWT"
/session-journal-search --domain backend --type feature
/session-journal-search --complexity complex
/session-journal-search --tags "auth" --domain backend
```

## Options

- `--tags TAG1,TAG2` - Search by tags (AND logic)
- `--topic TOPIC` - Search by primary or secondary topic
- `--from YYYY-MM-DD` - Search from date
- `--to YYYY-MM-DD` - Search to date
- `--text TEXT` - Search by text content (grep)
- `--domain DOMAIN` - Search by domain (backend/frontend/devops/database/testing)
- `--type TYPE` - Search by type (feature/bug-fix/refactor/research/debugging)
- `--complexity LEVEL` - Search by complexity (simple/medium/complex)

## Implementation

```bash
#!/bin/bash
${CLAUDE_PLUGIN_ROOT}/skills/opencode-session-journal/scripts/search-journals.sh "$@"
```

## What It Does

1. Reads knowledge graph indexes (tags.json, topics.json)
2. Filters journals by specified criteria
3. Displays matching journals with summaries
4. Shows file paths for loading

## Output

```
🔍 Found 3 matching journal(s):

📄 2026-03-09 02:16:45
   File: ~/.opencode/session-journals/year-2026-Horse/month-03-March/day-09-Monday/journal-1741234567-02:16:45.md
   Tags: java, spring-boot, webank-sdk, integration
   Topic: backend-integration
   Summary: Integrated WeBank SDK into Spring Boot backend...

📄 2026-03-05 14:22:10
   File: ~/.opencode/session-journals/year-2026-Horse/month-03-March/day-05-Thursday/journal-1741200000-14:22:10.md
   Tags: auth, jwt, security
   Topic: authentication
   Summary: Implemented JWT authentication with refresh tokens...

💡 Load a journal: /session-journal-load YYYY-MM-DD
```

## Examples

**Search by tags:**
```bash
/session-journal-search --tags "auth,security"
```

**Search by topic:**
```bash
/session-journal-search --topic "authentication"
```

**Search by date range:**
```bash
/session-journal-search --from 2026-03-01 --to 2026-03-13
```

**Search by text:**
```bash
/session-journal-search --text "JWT token"
```

**Combined search:**
```bash
/session-journal-search --tags "auth" --domain backend --complexity complex
```
