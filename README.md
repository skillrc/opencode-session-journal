# OpenCode Session Journal

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenCode Compatible](https://img.shields.io/badge/OpenCode-Compatible-blue.svg)](https://opencode.ai)
[![Tests](https://img.shields.io/badge/Tests-42%20passing-brightgreen.svg)](tests/TEST_REPORT.md)
[![Coverage](https://img.shields.io/badge/Coverage-95%25+-brightgreen.svg)](tests/TEST_REPORT.md)

**The simplest session logger for OpenCode - manual control, zero setup, markdown format**

---

## What is OpenCode Session Journal?

OpenCode Session Journal is a lightweight skill that provides **simple session persistence** through two commands:

- `/session-journal-save` - Save your current session progress as structured markdown
- `/session-journal-load` - Restore session context in a new session

### Why Use This?

**Problem**: OpenCode loses conversation history when sessions close. Multi-day projects become impractical because you must rebuild context from scratch every time.

**Solution**: Session Journal saves your session state as human-readable markdown logs with org-roam-inspired directory structure, making it easy to continue work across sessions.

## Key Features

✅ **Two simple commands** - No complex setup, no git hooks  
✅ **Human-readable format** - Structured markdown logs you can read and edit  
✅ **Manual control** - You decide when to save, not automatic triggers  
✅ **Zero dependencies** - Just markdown files, no databases  
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

```bash
git clone https://github.com/woniuxiaodi/opencode-session-journal.git
cd opencode-session-journal
./install.sh
```

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

## How It Works

1. **During your session**, work normally with OpenCode
2. **When ready to save**, run `/session-journal-save` to generate a structured log
3. **In a new session**, run `/session-journal-load` to restore context
4. **Continue working** exactly where you left off

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

**Each log contains:**
- Session metadata (ID, start time, task description)
- Timestamped action timeline
- Problems encountered and solutions
- Key decisions and rationale
- Current state and next steps
- Important files modified

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

---

**Star this repo if you find it useful! ⭐**
