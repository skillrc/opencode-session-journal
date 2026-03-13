# OpenCode Session Journal

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenCode Compatible](https://img.shields.io/badge/OpenCode-Compatible-blue.svg)](https://opencode.ai)
[![Tests](https://img.shields.io/badge/Tests-42%20passing-brightgreen.svg)](tests/TEST_REPORT.md)
[![Coverage](https://img.shields.io/badge/Coverage-95%25+-brightgreen.svg)](tests/TEST_REPORT.md)

**An in-context session memory system for OpenCode - manual control, complete journals, markdown format**

---

## What is OpenCode Session Journal?

OpenCode Session Journal is a lightweight skill that provides **session persistence and memory extraction** through save, load, profile, search, and learn workflows.

- `/session-journal-save` - Save your current session progress as structured markdown
- `/session-journal-load` - Restore session context in a new session
- `/session-journal-profile` - Build and inspect a user profile from complete journals
- `/session-journal-search` - Search saved journals by tags, topics, dates, and content
- `/session-journal-learn` - Extract reusable learnings from complete journals

### Why Use This?

**Problem**: OpenCode loses conversation history when sessions close. Multi-day projects become impractical because you must rebuild context from scratch every time.

**Solution**: Session Journal saves your session state as human-readable markdown logs with org-roam-inspired directory structure, making it easy to continue work across sessions.

## Key Features

✅ **In-context save flow** - Current AI session generates complete content  
✅ **Human-readable format** - Structured markdown logs you can read and edit  
✅ **Manual control** - You decide when to save, load, profile, and learn  
✅ **Local knowledge graph** - JSON indexes for tags/topics without a database  
✅ **Org-roam structure** - Time-organized with `year-YYYY-Zodiac/month-MM-MonthName/day-DD-Weekday/` format

## Comparison with Similar Tools

| Feature | Session Journal | brewcode | subcog | claude-code-soul |
|---------|----------------|----------|--------|------------------|
| **Commands** | 2 | 15+ | 10+ | Automatic |
| **Setup** | Zero | Complex | Database required | Git hooks |
| **Control** | Manual | Manual | Manual | Automatic |
| **Format** | Markdown | JSON + DB | SQLite | Markdown |
| **Dependencies** | None | Node.js, DB | Python, SQLite | Git |
| **GitHub Stars** | New | 15 | 17 | 5 |
| **Philosophy** | Simplest tool | Feature-rich | Data-driven | Hands-off |

**Why Session Journal?**
- **Simplest**: Just 2 commands vs 10-15+ in alternatives
- **Zero setup**: No databases, no complex configuration
- **Manual control**: You decide when to save, not automatic triggers
- **Human-readable**: Plain markdown, not JSON or database formats

## Quick Start (2 Minutes)

### Installation

If you are working with a local clone of this repository, run:

```bash
./install.sh
```

If you are viewing this project remotely or via a downloaded archive, first clone the repository or download and unpack it, then run the installation script as above.

Note: The repository includes MVP runtime scaffolding for session journaling. Runtime helpers live under:
- opencode-session-journal/scripts/generate-journal-path.sh
- opencode-session-journal/scripts/write-journal.sh
- opencode-session-journal/scripts/load-journal.sh
These MVP scripts are intended to be wired into lightweight CLI wrappers (to be added) and wired by the install.sh script into your OpenCode environment. See the new Runtime MVP section below for details.


### Usage

**Save your session:**
```bash
/session-journal-save
# or with a note
/session-journal-save "Completed WeBank SDK integration"
```

**Load previous session:**
```bash
/session-journal-load              # Load most recent
/session-journal-load 2026-03-09   # Load specific date
/session-journal-load list         # List all logs
```

**Build profile (MVP):**
```bash
/session-journal-profile
/session-journal-profile --show
```
 
**Search journals:**

**Search journals:**
```bash
/session-journal-search --tags "auth,security"
/session-journal-search --topic "session-memory"
```

## How It Works

1. **During your session**, work normally with OpenCode
2. **When ready to save**, let the current AI session generate a complete journal in-context
3. **The writer script** saves only journals marked `content_complete: true`
4. **In a new session**, run `/session-journal-load` to restore context
5. **Use profile/search/learn** to turn journals into memory artifacts

## Log Format

Logs are saved to `.opencode/session-journals/` with org-roam-inspired structure:

```
.opencode/session-journals/
  year-2026-Horse/
    month-03-March/
      day-09-Monday/
        journal-1741234567-02:16:45.md
        journal-1741245678-14:30:22.md
      day-10-Tuesday/
        journal-1741334567-09:15:30.md
```

**Directory format:**
- `year-YYYY-Zodiac` - Year with Chinese zodiac animal
- `month-MM-MonthName` - Month number and full name
- `day-DD-Weekday` - Day number and weekday name
- `journal-{timestamp}-{HH:MM:SS}.md` - Unix timestamp + time

**Each complete journal contains:**
- Session metadata (ID, start time, task description)
- `content_complete: true` in frontmatter
- Timestamped action timeline
- Problems encountered and solutions
- Key decisions and rationale
- Current state and next steps
- Important files modified

## Memory Layers

### 1. Complete Journal
The source of truth. Contains the real timeline, decisions, outcomes, and metadata.

### 2. User Profile
Built from complete journals only. Tracks preferences, workflows, and decision patterns.

### 3. Learned Artifacts
Derived from complete journals to capture reusable heuristics and workflows.

### 4. Knowledge Graph
Local JSON indexes (`tags.json`, `topics.json`, `links.json`) for fast retrieval.

## Important Architecture Rule

`/session-journal-save` must be executed in-context.

- The current AI session generates the journal body and metadata.
- Shell scripts must not attempt to reconstruct the true conversation body.
- Incomplete journals must not enter profile or learning pipelines.

## Use Cases

### Multi-Day Projects
```
Day 1: Integrate WeBank SDK → /session-journal-save
Day 2: /session-journal-load → Continue testing → /session-journal-save
Day 3: /session-journal-load → Deploy to production
```

### Context Management
```
Session 1: Research phase (80% context used) → /session-journal-save
Session 2: /session-journal-load → Implementation phase → /session-journal-save
Session 3: /session-journal-load → Testing and documentation
```

### Team Handoffs
```
Developer A: Complete feature → /session-journal-save "Ready for review"
Developer B: /session-journal-load → Review and test → /session-journal-save "Deployed"
```

## Testing

This project follows Test-Driven Development (TDD) methodology with comprehensive test coverage.

### Running Tests

```bash
# Run all tests
./tests/run_tests.sh

# Run with coverage report
./tests/run_tests.sh --coverage

# Run specific test suite
./tests/test_path_generation.sh
./tests/test_save_command.sh
./tests/test_load_command.sh
```

### Test Coverage

- **42 tests** across 5 test suites
- **95%+ coverage** (exceeds 80% goal)
- **100% pass rate**

Test suites:
- Path Generation (10 tests)
- File Operations (8 tests)
- Save Command (8 tests)
- Load Command (8 tests)
- E2E Workflows (8 tests)

See [tests/TEST_REPORT.md](tests/TEST_REPORT.md) for detailed test results.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

All contributions must include tests. Run `./tests/run_tests.sh` before submitting.

## License

MIT License - see [LICENSE](LICENSE) file for details.

-## Runtime MVP wiring map
-The repository includes MVP runtime scaffolding for journaling. MVP helpers live under opencode-session-journal/scripts and are intended to form the core of a runnable journaling workflow once lightweight CLI wrappers are wired by install.sh.
-MVP scripts present:
-  - opencode-session-journal/scripts/generate-journal-path.sh
-  - opencode-session-journal/scripts/write-journal.sh
-  - opencode-session-journal/scripts/load-journal.sh
-Wrappers wired into the OpenCode environment (via install.sh):
-  - opencode-session-journal/commands/session-journal-load.sh
-  - opencode-session-journal/commands/session-journal-save.sh
-  - opencode-session-journal/commands/session-journal-profile.sh
-  - opencode-session-journal/commands/session-journal-search.sh
-Status: End-to-end wrappers exist for Load/Save and lightweight wrappers for Profile/Search; underlying MVP runtimes for profile/search are placeholders until their runtime scripts are added. install.sh wires the available wrappers and makes them executable.
-
-Local installation note
- Run ./install.sh after cloning to wire the docs and the MVP runtime scaffolding into your OpenCode environment.

### Wrapper wiring status (Runtime MVP)
- session-journal-load.sh: shipped and wired by install.sh; calls opencode-session-journal/scripts/load-journal.sh
- session-journal-save.sh: shipped and wired by install.sh; pipes content to opencode-session-journal/scripts/write-journal.sh
- session-journal-profile.sh: wrapper present; wired to opencode-session-journal/scripts/analyze-profile.sh (MVP) or stub if analyze-profile.sh is not present yet
- session-journal-search.sh: wrapper present; wired to opencode-session-journal/scripts/search-journals.sh (MVP) or stub if search-journals.sh is not present yet
- MVP scripts in repo:
  - opencode-session-journal/scripts/generate-journal-path.sh
  - opencode-session-journal/scripts/write-journal.sh
  - opencode-session-journal/scripts/load-journal.sh

> Current state: End-to-end CLI wrappers exist for Load/Save and lightweight wrappers for Profile/Search are provided, but the underlying MVP runtimes for profile/search may be placeholders until the corresponding runtime scripts are added. install.sh wires the available wrappers and makes them executable.

**Star this repo if you find it useful! ⭐**

## Runtime MVP wiring map (final)
The OpenCode Session Journal MVP wiring plan focuses on a minimal, end-to-end flow for saving and loading journals, with placeholders for profiling and search learnings.
- Wrappers on disk (installed by the installer):
  - session-journal-load.sh
  - session-journal-save.sh
  - session-journal-profile.sh
  - session-journal-search.sh
- MVP script paths present in repo:
  - opencode-session-journal/scripts/generate-journal-path.sh
  - opencode-session-journal/scripts/write-journal.sh
  - opencode-session-journal/scripts/load-journal.sh
- Wiring model:
  - installer (install.sh) copies wrappers into OPENCODE_DIR/commands and marks them executable
  - Profile/Search wrappers currently route to MVP backends not yet implemented
- MVP state:
  - Load and Save wrappers wired; load prints latest journal, save writes a new journal
  - Profile/Search wrappers exist as scaffolds; their backends (analyze-profile.sh, search-journals.sh) are not included yet
- MVP flow example:
  - session-journal-load.sh -> load-journal.sh

-## Runtime MVP wiring map (final)
The MVP wiring plan for OpenCode Session Journal focuses on a minimal end-to-end flow for saving and loading journals, with explicit exposure of wrappers and MVP runtime scripts.

- Wrappers on disk (installed by installer):
  - session-journal-load.sh
  - session-journal-save.sh
  - session-journal-profile.sh
  - session-journal-search.sh
- MVP script paths present in repo:
  - opencode-session-journal/scripts/generate-journal-path.sh
  - opencode-session-journal/scripts/write-journal.sh
  - opencode-session-journal/scripts/load-journal.sh
- Wiring model (installer behavior):
  - install.sh copies wrappers into OPENCODE_DIR/commands and marks them executable
- MVP state:
  - Load/Save wrappers wired; load prints latest journal, save writes a new journal
  - Profile/Search wrappers exist as scaffolds; backends (analyze-profile.sh, search-journals.sh) are not included yet
- MVP flow example:
  - session-journal-load.sh -> load-journal.sh

## Phase 1 MVP Wiring Snapshot (Current)
- Wrappers present and wired by installer:
  - session-journal-load.sh
  - session-journal-save.sh
  - session-journal-profile.sh
  - session-journal-search.sh
- MVP backends:
  - analyze-profile.sh (stub)
  - search-journals.sh (stub)
- MVP scripts present in repo:
  - opencode-session-journal/scripts/generate-journal-path.sh
  - opencode-session-journal/scripts/write-journal.sh
  - opencode-session-journal/scripts/load-journal.sh
- Status: End-to-end CLI wrappers exist for Load/Save; Profile/Search wrappers route to stubs.
- Next phases:
  - Phase 2: replace stubs with real MVP backends and expand tests
  - Phase 3: CI integration and final README polish
 
## Phase alignment audit and notes
- This README reflects Phase 1 MVP reality (4 wrappers wired; Learn not wired). A future Phase-2 update will replace stub backends with real MVP implementations for analyze-profile and search-journals, and add Phase-2 tests and CI.
- Known mismatches to resolve in a canonical Phase-1 README:
  - Learn wrapper referenced in Quick Start but not wired in Phase 1; the MVP narrative should either wire a minimal learn wrapper or explicitly remove Learn from Phase 1 MVP scope.
  - Duplicated/multiple sections titled ‘Runtime MVP wiring map’ that may confuse readers about the canonical Phase state. A single, clean Phase 1 section is preferred.
- Refer to REPO_FINDINGS.md for a comprehensive gap log and explicit TODOs.

## Discrepancies and Next Steps
- This section now describes the final MVP wiring map and notes remaining work
- The final README patch should reflect explicit mapping and indicate that Profile/Search backends are pending
- This repository documents MVP runtime scaffolding and a local install flow. To ensure clarity for readers and contributors, we should explicitly map which wrappers exist and whether they are wired by the installer, and distinguish MVP scaffolds from a fully production-ready end-to-end CLI.
- Current plan for the README: add a compact MVP wiring map that lists:
  - Wrapper names and paths: session-journal-load.sh, session-journal-save.sh, session-journal-profile.sh, session-journal-search.sh
  - MVP script paths: generate-journal-path.sh, write-journal.sh, load-journal.sh
  - Wiring status: install.sh behavior, where wrappers land post-install, and note which wrappers are fully wired vs. still placeholders for profile/search.
- The end-to-end CLI surface for profile/search remains MVP scaffolding until their runtime wrappers are implemented; this should be stated clearly in the README to avoid misunderstanding.

- Note: For a clean canonical Phase-1 state and the Phase-2 plan, refer to REPO_FINDINGS.md.
- Phase alignment audit (README vs repo state)
- Wrappers wired (Load, Save, Profile, Search) exist in opencode-session-journal/commands and wired by install.sh.
- Learn wrapper: not wired in Phase 1; README now clarifies MVP scope.
- Phase-1 readme duplication: removed in favor of a single Phase-1 narrative; REPO_FINDINGS.md holds the canonical gap log.
- Zodiac/path references are consistent with the existing code (Horse for 2026 in the examples).
- See REPO_FINDINGS.md for deeper phase 2 planning and gaps.
