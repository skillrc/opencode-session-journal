SESSION-JOURNAL(1)               User Commands              SESSION-JOURNAL(1)


NAME
       session-journal - Personal AI assistant memory foundation

SYNOPSIS
       /session-journal-save ["description"]
       /session-journal-load [date|list|session-id]
       /session-journal-profile [--show|--all|--dry-run]
       /session-journal-search [--tags TAGS] [--topic TOPIC]
       /session-journal-learn [--all|--dry-run]
       /session-journal-verify

DESCRIPTION
       Session Journal creates persistent, learning memory for your AI
       assistant. Unlike stateless AI that starts fresh every session,
       Session Journal builds a complete understanding of how you work,
       what you prefer, and how you solve problems.

       The system operates on three pillars:

       Memory        Complete episodic storage of every session
       Learning      Pattern extraction from your work history
       Recognition   User profile building for personalization

       Over time, your AI transitions from stranger to assistant:

           Session 1-10      AI saves what you do
           Session 11-50     AI learns how you work
           Session 51-100    AI recognizes your style
           Session 101+      AI anticipates your needs

ARCHITECTURE
       The system separates understanding from persistence:

           +-------------+       +-------------------+       +------------+
           |     YOU     |------>| Current AI Session|------>|  Observes  |
           +-------------+       +-------------------+       +------------+
                                                               |
                                                               v
                                                    +---------------------+
                                                    | /session-journal-   |
                                                    | save                |
                                                    +---------------------+
                                                               |
                                                               v
                                                    +---------------------+
                                                    | AI Generates:       |
                                                    | - Timeline          |
                                                    | - Decisions         |
                                                    | - Preferences       |
                                                    | - content_complete  |
                                                    +---------------------+
                                                               |
                                                               v
                                                    +---------------------+
                                                    | write-journal.sh    |
                                                    | - Validate          |
                                                    | - Atomic write      |
                                                    | - Update indexes    |
                                                    +---------------------+
                                                               |
                                                               v
                                                    +---------------------+
                                                    | STORAGE             |
                                                    | ~/.opencode/        |
                                                    |  - session-journals |
                                                    |  - knowledge-graph  |
                                                    |  - profile          |
                                                    |  - learned          |
                                                    +---------------------+
                                                               |
                                                               v
                                                    +---------------------+
                                                    | [Time passes...]    |
                                                    |                     |
                                                    | /session-journal-   |
                                                    | profile             |
                                                    |                     |
                                                    | AI reads 30+        |
                                                    | journals, extracts  |
                                                    | patterns, updates   |
                                                    | user-profile.yaml   |
                                                    +---------------------+
                                                               |
                                                               v
                                                    +---------------------+
                                                    | "Help with X"       |
                                                    |                     |
                                                    | AI loads profile:   |
                                                    | "This user prefers  |
                                                    |  functional style,  |
                                                    |  security-first..." |
                                                    |                     |
                                                    | Response adapts     |
                                                    | to YOUR style       |
                                                    +---------------------+

       Key Principle: AI understands and generates. Scripts validate and
       write. Storage persists. Over time, the AI learns you.

COMMANDS
       +-------------------------+----------------------------------------+
       | Command                 | Description                            |
       +-------------------------+----------------------------------------+
       | save ["description"]    | Save complete session. AI generates    |
       |                         | content in-context with full timeline, |
       |                         | decisions, and metadata.               |
       +-------------------------+----------------------------------------+
       | load                    | Load most recent session               |
       | load DATE               | Load session by date (YYYY-MM-DD)      |
       | load list               | List all available sessions            |
       | load SESSION-ID         | Load specific session by ID            |
       +-------------------------+----------------------------------------+
       | profile                 | Build user profile from complete       |
       | profile --show          | journals. Extracts patterns,           |
       | profile --all           | preferences, workflows.                |
       | profile --dry-run       |                                        |
       +-------------------------+----------------------------------------+
       | search --tags TAGS      | Search journals by criteria.           |
       | search --topic TOPIC    | Supports tags, topics, dates,          |
       | search --from DATE      | domains, complexity.                   |
       | search --to DATE        |                                        |
       +-------------------------+----------------------------------------+
       | learn                   | Extract reusable learnings from        |
       | learn --all             | complete journals. Creates skill       |
       | learn --dry-run         | artifacts in ~/.opencode/learned/      |
       +-------------------------+----------------------------------------+
       | verify                  | Validate all journals for              |
       |                         | completeness and structure.            |
       +-------------------------+----------------------------------------+

FILE FORMAT
       A complete journal is a markdown file with YAML frontmatter:

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
           description: Researched libraries before choosing
           confidence: 0.85

       preferences_observed:
         - id: security-over-convenience
           description: Prioritized security even when complex
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

       ### Started Task: JWT Auth
       - **User Request**: Add JWT authentication
       - **Initial State**: No auth system
       - **Plan**: Research -> Implement -> Test

       ### Action: Research libraries
       - Compared jose vs jsonwebtoken
       - Chose jose for TypeScript support

       ### Completed: JWT Implementation
       - Access tokens: 15min expiry
       - Refresh tokens: 7 day expiry
       - httpOnly cookies for XSS protection

       ---

       ## Session Summary

       ### Completed Work
       1. Implemented JWT authentication
       2. Added refresh token rotation
       3. Configured httpOnly cookies

       ### Key Decisions
       - Security > convenience: httpOnly despite complexity

       ### Current State
       - Auth system running on port 8080
       - All tests passing

       ### Pending Tasks
       - [ ] Test token expiration edge cases
       - [ ] Add rate limiting

       ### Important Files
       - `src/middleware/auth.ts`
       - `src/routes/auth.ts`

       ### Recommendations for Next Session
       1. Test token expiration edge cases
       2. Add rate limiting

       ---

       **Session End Time**: 2026-03-14 11:15:00
       **Total Duration**: 45 minutes

       This is not merely a log entry. It is training data for your
       personal AI assistant.

DIRECTORY STRUCTURE
       ~/.opencode/
       |-- session-journals/
       |   `-- year-YYYY-Zodiac/
       |       `-- month-MM-MonthName/
       |           `-- day-DD-Weekday/
       |               `-- journal-{timestamp}-{time}.md
       |
       |-- knowledge-graph/
       |   |-- tags.json
       |   |-- topics.json
       |   `-- links.json
       |
       |-- profile/
       |   |-- user-profile.yaml
       |   `-- changelog/
       |
       `-- learned/
           `-- journal-{id}-learning.md

INSTALLATION
       git clone https://github.com/skillrc/opencode-session-journal.git
       cd opencode-session-journal
       ./install.sh

       Requirements: Bash 4.0+, Python 3.6+

EXAMPLES
       Save current session:
              /session-journal-save "Implemented Redis caching"

       Load previous session:
              /session-journal-load              # Most recent
              /session-journal-load 2026-03-14   # By date
              /session-journal-load list         # All sessions

       Build user profile:
              /session-journal-profile           # Build from journals
              /session-journal-profile --show    # View current profile

       Search past work:
              /session-journal-search --tags "auth,security"
              /session-journal-search --topic "performance"

       Extract learnings:
              /session-journal-learn --dry-run   # Preview
              /session-journal-learn             # Create artifacts

       Validate integrity:
              /session-journal-verify

FILES
       ~/.opencode/session-journals/
              Complete session memories stored as markdown files.

       ~/.opencode/knowledge-graph/tags.json
              Tag index for fast journal retrieval.

       ~/.opencode/knowledge-graph/topics.json
              Topic index for categorical search.

       ~/.opencode/profile/user-profile.yaml
              AI's understanding of your preferences and patterns.

       ~/.opencode/learned/
              Extracted reusable skills and heuristics.

EXIT STATUS
       0      Success
       1      General error (validation failed, file not found)

ENVIRONMENT
       HOME   Used to locate ~/.opencode/ directory

SEE ALSO
       opencode(1), claude(1)

AUTHORS
       Session Journal contributors.
       https://github.com/skillrc/opencode-session-journal

LICENSE
       MIT License - See LICENSE file for details.

                              2026-03-14                    SESSION-JOURNAL(1)
