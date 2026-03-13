# Session Journal [ █ █ █ ▓ ▓ ▒ ░ ] → Your AI's Memory

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenCode Compatible](https://img.shields.io/badge/OpenCode-Compatible-blue.svg)](https://opencode.ai)

> **Every session teaches your AI who you are.**
> 
> *Not a logger. A learning system. The foundation of your personal AI assistant.*

---

## The Problem: Strangers Every Session

You open OpenCode. You get a brilliant AI assistant.
But it's a **stranger**. 

- It doesn't know how you think
- It doesn't remember your preferences  
- It can't see your patterns
- Every session starts from zero

**Current AI is stateless. But you are not.**

Your expertise, your style, your way of solving problems—it all develops over time.
But your AI starts fresh every time. 

This is wrong.

---

## The Solution: Your AI Learns You

Session Journal creates **persistent, learning memory** for your AI:

Session 1-10:    AI saves what you do          [MEMORY]
Session 11-50:   AI learns how you work        [LEARNING]  
Session 51-100:  AI recognizes your style      [RECOGNITION]
Session 101+:    AI anticipates your needs     [ASSISTANT]

**This is the beginning of truly personal AI.**

Not a tool you use. An assistant that knows you.

---

## Three Pillars

    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
    │   MEMORY    │ +  │  LEARNING   │ +  │ RECOGNITION │
    │             │    │             │    │             │
    │  What you   │    │  How you    │    │  Who you    │
    │  did        │    │  did it     │    │  are        │
    │             │    │             │    │             │
    │  Episodic   │    │  Patterns   │    │  Profile    │
    │  Storage    │    │  Extraction │    │  Building   │
    └─────────────┘    └─────────────┘    └─────────────┘

### 1. Memory [Foundation]
Complete session preservation:
- Every decision you made
- Every problem you solved  
- Every file you modified
- Full context, permanently stored

**Your AI never forgets.**

### 2. Learning [Intelligence]
Pattern extraction from sessions:
- Workflow preferences
- Decision heuristics
- Debugging approaches
- Communication style

**Your AI gets smarter.**

### 3. Recognition [Personalization]
User profile building:
- Code style preferences
- Tool choices
- Problem-solving patterns
- Communication patterns

**Your AI becomes yours.**

---

## The Journey: From Stranger to Assistant

### Session 1-10: Foundation Phase
```
You: "Help me implement JWT auth"
AI: "Sure, here's a generic implementation"

You: /session-journal-save "JWT implementation"
[AI saves complete context]
```

**Result**: Your AI now has episodic memory of what you did.

### Session 11-50: Learning Phase  
```
You: /session-journal-profile
[AI analyzes 20 sessions]

Profile Discovered:
- Prefers functional programming (confidence: 0.92)
- Security over convenience (confidence: 0.88)
- Research-then-implement workflow (confidence: 0.85)
```

**Result**: Your AI now understands how you work.

### Session 51-100: Recognition Phase
```
You: "I need to add authentication"
AI: "Based on your previous work and preference for security-first 
     functional style, I'll use the same pattern from your JWT 
     implementation—httpOnly cookies with explicit error handling?"

You: "Exactly"
```

**Result**: Your AI recognizes your style and preferences.

### Session 101+: Assistant Phase
```
You: [starts describing problem]
AI: "I see you're working on auth again. Based on your previous 
     sessions and the patterns I've learned, I suspect you'll want:
     1. httpOnly cookies (security priority)
     2. Functional error handling (your style)
     3. jose library (your preference from 3 sessions ago)
     
     Should I set that up?"
```

**Result**: Your AI anticipates your needs. **This is personal AI.**

---

## Commands: Tools to Teach Your AI

| Command | Purpose |
|---------|---------|
| `/session-journal-save "note"` | Save complete session (AI generates in-context) |
| `/session-journal-load` | Load most recent session |
| `/session-journal-load 2026-03-14` | Load by date |
| `/session-journal-load list` | List all sessions |
| `/session-journal-profile` | Build user profile from journals |
| `/session-journal-profile --show` | View your current profile |
| `/session-journal-search --tags "auth"` | Search by tags |
| `/session-journal-search --topic "backend"` | Search by topic |
| `/session-journal-learn --dry-run` | Preview learnings extraction |
| `/session-journal-learn` | Extract reusable skills |
| `/session-journal-verify` | Validate journal integrity |

---

## Architecture: How It Works

YOU → "Implement auth" → AI [observes everything]
                        ↓
                    /session-journal-save
                        ↓
        AI generates complete journal:
        • Timeline of decisions
        • Problems and solutions
        • Your preferences (observed)
        • Metadata (tags, topics)
        • content_complete: true
                        ↓
            write-journal.sh
            • Validate completeness
            • Atomic write
            • Update indexes
                        ↓
        Storage:
        • ~/.opencode/session-journals/
        • ~/.opencode/knowledge-graph/
        • ~/.opencode/profile/
        • ~/.opencode/learned/
                        ↓
        [Time passes...]
                        ↓
        /session-journal-profile
        AI reads 30 journals
        Extracts patterns:
        - "Prefers functional"
        - "Security-first mindset"
        - "Explicit error handling"
        Updates user-profile.yaml
                        ↓
        [More time passes...]
                        ↓
        "Help with auth"
                        ↓
        AI loads profile:
        "This user prefers..."
        Response adapts to YOUR style

**Key Principle**: AI understands and generates. Scripts validate and write. Storage persists. Over time, the AI learns you.

---

## Vision: Where This Is Going

### Phase 1: Foundation ✅ [Current]
- ✅ Complete session capture
- ✅ Knowledge graph indexing
- ✅ User profile building
- ✅ Learning extraction
- ✅ Data integrity (content_complete gate)

### Phase 2: Intelligence 🔄 [In Progress]
- 🔄 Automatic pattern recognition across sessions
- 🔄 Proactive suggestions based on your history
- 🔄 Style adaptation without explicit instructions
- 🔄 Cross-session insight synthesis

### Phase 3: Personal Assistant 🔮 [Future]
- 🔮 AI anticipates your questions before you ask
- 🔮 Knows your preferences without being told
- 🔮 Suggests solutions in YOUR style
- 🔮 Truly personal AI that grows with you

**The ultimate goal**: An AI assistant that feels like *yours*.

---

## Installation

```bash
# Clone
git clone https://github.com/skillrc/opencode-session-journal.git
cd opencode-session-journal

# Install
./install.sh

# Start teaching your AI
/session-journal-save "My first session"
```

**Requirements**: Bash 4.0+, Python 3.6+

---

## Why This Matters

Current AI assistants are brilliant but **amnesiac and impersonal**.

Every session:
- ❌ Forgets everything
- ❌ Doesn't know your style
- ❌ Can't see your patterns
- ❌ Starts from zero

**Session Journal fixes this.**

By session 100:
- ✅ Remembers everything
- ✅ Knows your preferences
- ✅ Recognizes your patterns
- ✅ Feels like YOUR assistant

**This is the future of AI: personal, learning, adaptive.**

---

## License

MIT License - see [LICENSE](LICENSE)

---

**⭐ Star this repo if you believe in personal AI ⭐**

*"The best AI assistant is the one that knows you."*

[ █ █ █ ▓ ▓ ▒ ░ ] → Building your AI's memory, one session at a time.
