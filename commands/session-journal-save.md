# Save Session Journal

Generate and save current session progress as structured markdown.

## Execute These Steps

### 1. Collect Session Information

Gather from current session:
- Session ID
- Start time
- User's original request
- All actions taken (with timestamps)
- Problems encountered and solutions
- Key decisions made
- Files modified
- Current state
- Pending tasks

### 2. Generate Journal Content

Create markdown with this exact structure:

```markdown
# Session Journal - [session-id]

**Start Time**: YYYY-MM-DD HH:MM:SS
**Task**: [User request]

---

## YYYY-MM-DD HH:MM:SS
### 🎯 Started Task: [Task name]
- **User Request**: [Original request]
- **Initial State**: [State description]
- **Plan**: [Execution plan]

## YYYY-MM-DD HH:MM:SS
### 🔧 Action: [Action description]
- **Tools**: [Tools used]
- **Findings**: [Discovered information]
- **Decision**: [Decision made]

## YYYY-MM-DD HH:MM:SS
### ⚠️ Problem: [Problem description]
- **Error**: [Error message]
- **Analysis**: [Problem analysis]
- **Solution**: [Solution applied]

## YYYY-MM-DD HH:MM:SS
### ✅ Completed: [Completed work]
- **Result**: [Work result]
- **Verification**: [Verification method]
- **Duration**: [Time spent]

---

## 📊 Session Summary

### Completed Work
1. ✅ [Work item 1]
2. ✅ [Work item 2]

### Problems Solved
1. ⚠️ [Problem 1] → [Solution]
2. ⚠️ [Problem 2] → [Solution]

### Key Decisions
- [Decision 1]: [Rationale]
- [Decision 2]: [Rationale]

### Current State
- [State description]

### Pending Tasks
- [ ] [Task 1]
- [ ] [Task 2]

### Important Files
- [File path] - [Purpose]

### Recommendations for Next Session
[Recommendation content]
```

### 3. Calculate Directory Path

Use the path generation script:

```bash
# Determine skill installation directory
if [ -d "$HOME/.opencode/skills/opencode-session-journal" ]; then
    SKILL_DIR="$HOME/.opencode/skills/opencode-session-journal"
elif [ -d "$HOME/.config/opencode/skills/opencode-session-journal" ]; then
    SKILL_DIR="$HOME/.config/opencode/skills/opencode-session-journal"
else
    echo "Error: opencode-session-journal skill not found"
    exit 1
fi

# Generate journal file path using script
FILEPATH=$("$SKILL_DIR/scripts/generate-journal-path.sh")
DIR=$(dirname "$FILEPATH")
```

### 4. Save File

Create directory if needed:
```bash
mkdir -p "$DIR"
```

Write journal content to: `$FILEPATH`

### 5. Confirm Save

Display:
```
✅ Session journal saved

File: [full path]
Size: [file size]

💡 Use /session-journal-load in next session to restore context
```

## Examples

**Save with note:**
```
/session-journal-save "Completed WeBank SDK integration"
```

**Save without note:**
```
/session-journal-save
```

## Notes

- Include ALL session context: actions, decisions, problems, solutions
- Use exact markdown format shown above
- Create directories automatically if they don't exist
- Journals contain sensitive information - protect accordingly
