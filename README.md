# OpenCode Session Journal

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenCode Compatible](https://img.shields.io/badge/OpenCode-Compatible-blue.svg)](https://opencode.ai)

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   ██████  ███████ ███████ ███████ ██   ██ ███    ██ ███████     ║
║   ██   ██ ██      ██      ██      ██   ██ ████   ██ ██          ║
║   ██████  █████   ███████ ███████ ███████ ██ ██  ██ █████       ║
║   ██   ██ ██           ██      ██ ██   ██ ██  ██ ██ ██          ║
║   ██   ██ ███████ ███████ ███████ ██   ██ ██   ████ ███████     ║
║                                                                  ║
║        ██████  ███████ ███████ ██   ██ ███    ██ ███████        ║
║        ██   ██ ██      ██      ██   ██ ████   ██ ██             ║
║        ██████  █████   ███████ ███████ ██ ██  ██ █████          ║
║        ██   ██ ██           ██ ██   ██ ██  ██ ██ ██             ║
║        ██   ██ ███████ ███████ ██   ██ ██   ████ ███████        ║
║                                                                  ║
║              ██ ████████  ██████  ██    ██ ██████  ██            ║
║              ██    ██    ██    ██ ██    ██ ██   ██ ██            ║
║              ██    ██    ██    ██ ██    ██ ██████  ██            ║
║              ██    ██    ██    ██ ██    ██ ██   ██ ██            ║
║              ██    ██     ██████   ██████  ██   ██ ███████       ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**An in-context session memory system for OpenCode**

*Manual control · Complete journals · Markdown format · No databases*

---

## 📋 Command Reference

```
┌─────────────────────────────────────────────────────────────────┐
│  COMMAND                    │  PURPOSE                           │
├─────────────────────────────────────────────────────────────────┤
│  /session-journal-save      │  Save current session (in-context) │
│  /session-journal-load      │  Load previous session context     │
│  /session-journal-profile   │  Build user profile from journals  │
│  /session-journal-search    │  Search journals by tags/topics    │
│  /session-journal-learn     │  Extract reusable learnings        │
│  /session-journal-verify    │  Validate journal integrity        │
└─────────────────────────────────────────────────────────────────┘
```

### Quick Usage Examples

```bash
# Save current session (AI generates complete content in-context)
/session-journal-save "Implemented JWT authentication"

# Load previous session
/session-journal-load              # Load most recent
/session-journal-load 2026-03-14   # Load by date
/session-journal-load list         # List all journals

# Search your memory
/session-journal-search --tags "auth,security"
/session-journal-search --topic "backend"

# Build your profile
/session-journal-profile
/session-journal-profile --show    # View current profile

# Extract learnings
/session-journal-learn --dry-run   # Preview
/session-journal-learn             # Create artifacts

# Validate integrity
/session-journal-verify
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        USER INTERACTION LAYER                        │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌──────────────┐  │
│  │   save      │ │   load      │ │   profile   │ │    learn     │  │
│  └──────┬──────┘ └──────┬──────┘ └──────┬──────┘ └──────┬───────┘  │
└─────────┼───────────────┼───────────────┼───────────────┼──────────┘
          │               │               │               │
          ▼               ▼               ▼               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     IN-CONTEXT GENERATION (AI)                       │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  Current AI session analyzes conversation and generates:     │    │
│  │  • Complete journal markdown with YAML frontmatter           │    │
│  │  • Tags, topics, categories, patterns, preferences           │    │
│  │  • Timeline, decisions, problems, state, recommendations     │    │
│  └─────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      DETERMINISTIC LAYER (Scripts)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │
│  │ write-journal│  │ load-journal │  │update-kg     │               │
│  │   -path gen  │  │   -list      │  │ -index tags  │               │
│  │   -validate  │  │   -by date   │  │ -index topics│               │
│  │   -atomic    │  │   -by id     │  │ -links       │               │
│  └──────────────┘  └──────────────┘  └──────────────┘               │
└─────────────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────────┐
│                           STORAGE LAYER                              │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  ~/.opencode/session-journals/                                 │  │
│  │  year-2026-Horse/month-03-March/day-14-Saturday/              │  │
│  │  └── journal-{timestamp}-{time}.md                            │  │
│  └───────────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  ~/.opencode/knowledge-graph/                                  │  │
│  │  ├── tags.json    { "auth": ["journal-1.md", ...] }          │  │
│  │  ├── topics.json  { "backend": ["journal-1.md", ...] }       │  │
│  │  └── links.json   { "journal-1.md": { ... } }                │  │
│  └───────────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  ~/.opencode/profile/                                          │  │
│  │  └── user-profile.yaml                                         │  │
│  └───────────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  ~/.opencode/learned/                                          │  │
│  │  └── journal-{id}-learning.md                                  │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📁 Directory Structure

```
~/.opencode/
├── session-journals/                    # Your complete session memories
│   └── year-YYYY-Zodiac/
│       └── month-MM-MonthName/
│           └── day-DD-Weekday/
│               └── journal-{ts}-{time}.md
│
├── knowledge-graph/                     # Fast search indexes
│   ├── tags.json
│   ├── topics.json
│   └── links.json
│
├── profile/                             # Your evolving user profile
│   ├── user-profile.yaml
│   └── changelog/
│
└── learned/                             # Extracted reusable skills
    └── journal-{id}-learning.md
```

---

## 🔄 Complete Workflow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         SESSION LIFECYCLE                            │
└─────────────────────────────────────────────────────────────────────┘

    ┌─────────────┐
    │   START     │
    │  Session    │
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │    WORK     │◄──────────────────────────────────────┐
    │  (coding,   │                                       │
    │  decisions) │                                       │
    └──────┬──────┘                                       │
           │                                               │
           ▼                                               │
    ┌─────────────┐     ┌─────────────────────────────┐   │
    │   READY     │────►│  /session-journal-save      │   │
    │   TO SAVE   │     │                             │   │
    └─────────────┘     │  AI generates in-context:   │   │
                        │  • Complete timeline        │   │
                        │  • Tags & topics            │   │
                        │  • Decisions & state        │   │
                        │  • content_complete: true   │   │
                        └──────────────┬──────────────┘   │
                                       │                  │
                                       ▼                  │
                        ┌─────────────────────────────┐   │
                        │   write-journal.sh          │   │
                        │   • Validate completeness   │   │
                        │   • Atomic write            │   │
                        │   • Update KG indexes       │   │
                        └──────────────┬──────────────┘   │
                                       │                  │
                                       ▼                  │
                        ┌─────────────────────────────┐   │
                        │   SAVED JOURNAL             │   │
                        │   (source of truth)         │   │
                        └──────────────┬──────────────┘   │
                                       │                  │
           ┌───────────────────────────┼──────────────────┘
           │                           │
           ▼                           ▼
┌─────────────────────┐    ┌─────────────────────┐
│   NEXT SESSION      │    │   MEMORY LAYERS     │
│                     │    │                     │
│  /session-journal-  │    │  ┌───────────────┐  │
│  load               │◄───┼──┤ Profile       │  │
│                     │    │  │ (patterns)    │  │
│  Context restored   │    │  └───────────────┘  │
│  Continue work      │    │  ┌───────────────┐  │
│        │            │    │  │ Learned       │  │
│        └────────────┼────┼──┤ (skills)      │  │
│                     │    │  └───────────────┘  │
│  /session-journal-  │    │  ┌───────────────┐  │
│  save               │    │  │ KG Index      │  │
│        │            │    │  │ (search)      │  │
│        └────────────┼────┘  └───────────────┘  │
│                     │                           │
└─────────────────────┘                           │
                                                  │
┌─────────────────────────────────────────────────┘
│
│  /session-journal-verify    → Check integrity
│  /session-journal-search    → Find past work
│  /session-journal-profile   → Update user model
│  /session-journal-learn     → Extract patterns
│
└──────────────────────────────────────────────────► (cycle continues)
```

---

## 🎯 Key Principles

### 1. In-Context Generation
```
❌ WRONG: Shell script guesses session content from history
✅ RIGHT: Current AI session generates complete journal directly
```

### 2. Content Completeness Gate
```yaml
# Every valid journal MUST have:
content_complete: true

# Without this flag:
- ❌ Cannot be indexed in knowledge graph
- ❌ Cannot be used for profile building
- ❌ Cannot be used for learning extraction
```

### 3. Deterministic Scripts
```
AI Layer:    Understanding, generation, synthesis
             ↓ (pipes complete content)
Script Layer: Validation, atomic write, indexing
             ↓ (deterministic operations only)
Storage:      Files, indexes, profiles
```

---

## 🛠️ Installation

```bash
# Clone and install
git clone https://github.com/skillrc/opencode-session-journal.git
cd opencode-session-journal
./install.sh
```

**Requirements:**
- Bash 4.0+
- Python 3.6+ (for YAML processing)
- OpenCode CLI

---

## 📊 Comparison

| Feature | Session Journal | brewcode | subcog | claude-code-soul |
|---------|----------------|----------|--------|------------------|
| **Commands** | 6 | 15+ | 10+ | Auto |
| **Setup** | Zero | Complex | DB required | Git hooks |
| **Control** | Manual | Manual | Manual | Automatic |
| **Format** | Markdown | JSON+DB | SQLite | Markdown |
| **Dependencies** | Python, Bash | Node.js, DB | Python, SQLite | Git |
| **Philosophy** | Correct architecture | Feature-rich | Data-driven | Hands-off |

**Why Session Journal?**
- ✅ **Correct execution model**: AI generates, scripts write
- ✅ **Data integrity**: `content_complete` validation gate
- ✅ **Zero setup**: No databases, minimal dependencies
- ✅ **Full control**: You decide when to save/learn/profile
- ✅ **Human readable**: Plain markdown, editable

---

## 📝 Journal Format

```markdown
---
session_id: ses_abc123
timestamp: 1741234567
datetime: 2026-03-14 10:30:00
duration_minutes: 45
content_complete: true

tags:
  auto: [auth, jwt, security]
  user: [important]
  confidence: 0.92

topics:
  primary: authentication
  secondary: [security, api-design]
  confidence: 0.88

categories:
  domain: backend
  type: feature-implementation
  complexity: medium
  phase: implementation

summary: |
  Implemented JWT authentication with refresh tokens.
  Chose jose over jsonwebtoken for better TypeScript support.

patterns_detected:
  - id: research-before-implement
    description: Researched libraries before coding
    confidence: 0.85

preferences_observed:
  - id: security-over-convenience
    description: Prioritizes security even when complex
    confidence: 0.90

links:
  related_sessions: []
  related_skills: []
  related_files:
    - src/middleware/auth.ts

learned: false
profiled: false
---

# Session Journal - ses_abc123

**Start Time**: 2026-03-14 10:30:00
**Task**: Implement JWT authentication

---

## Session Timeline

### 🎯 Started Task: JWT Auth
- **User Request**: Add JWT authentication to API
- **Initial State**: No auth system
- **Plan**: Research → Implement → Test

### 🔧 Action: Research libraries
- Compared jose vs jsonwebtoken
- Chose jose for TypeScript support

### ✅ Completed: JWT Implementation
- Access tokens: 15min expiry
- Refresh tokens: 7 day expiry
- httpOnly cookies for XSS protection

---

## 📊 Session Summary

### Completed Work
1. ✅ Implemented JWT authentication
2. ✅ Added refresh token rotation
3. ✅ Configured httpOnly cookies

### Problems Solved
- JavaScript library vs TypeScript library → Chose jose

### Key Decisions
- Security > convenience: httpOnly despite complexity

### Current State
- Auth system running on port 8080
- All tests passing

### Pending Tasks
- [ ] Test edge cases
- [ ] Document API

### Important Files
- `src/middleware/auth.ts`
- `src/routes/auth.ts`

### Recommendations for Next Session
1. Test token expiration edge cases
2. Add rate limiting

---

**Session End Time**: 2026-03-14 11:15:00
**Total Duration**: 45 minutes
```

---

## 🔍 Use Cases

### Multi-Day Project
```
Day 1: Research → /session-journal-save
Day 2: /session-journal-load → Implement → /session-journal-save
Day 3: /session-journal-load → Test → /session-journal-save
Day 4: /session-journal-load → Deploy
```

### Context Recovery
```
Session 1: 80% context used → /session-journal-save
Session 2: /session-journal-load → Continue → /session-journal-save
Session 3: /session-journal-load → Finish
```

### Knowledge Building
```
After 10 sessions:
→ /session-journal-profile (builds your profile)
→ /session-journal-learn (extracts reusable patterns)
→ /session-journal-search --tags "auth" (finds past work)
```

---

## 🧪 Testing

```bash
# Run verification
/session-journal-verify

# Check specific journal
~/.config/opencode/skills/opencode-session-journal/scripts/verify-journals.sh

# Test all commands
./tests/run_tests.sh
```

---

## 📄 License

MIT License - see [LICENSE](LICENSE)

---

<div align="center">

**⭐ Star this repo if you find it useful! ⭐**

*Built with the principle: AI understands, scripts write, memory persists.*

</div>
