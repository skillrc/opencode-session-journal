#!/bin/bash
# OpenCode Session Journal - Installation Script

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Installing OpenCode Session Journal...${NC}"

# Detect OpenCode config directory
if [ -d "$HOME/.config/opencode" ]; then
    OPENCODE_DIR="$HOME/.config/opencode"
elif [ -d "$HOME/.opencode" ]; then
    OPENCODE_DIR="$HOME/.opencode"
else
    echo "Error: OpenCode config directory not found"
    echo "Expected: ~/.config/opencode or ~/.opencode"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create directories if they don't exist
mkdir -p "$OPENCODE_DIR/skills"
mkdir -p "$OPENCODE_DIR/commands"

# Copy skill (exclude .git, tests, examples)
echo "→ Installing skill..."
rsync -a --exclude='.git' --exclude='tests' --exclude='examples' --exclude='.opencode' \
    "$SCRIPT_DIR/" "$OPENCODE_DIR/skills/opencode-session-journal/"

# Copy commands
echo "→ Installing commands..."
cp "$SCRIPT_DIR/commands/session-journal-save.md" "$OPENCODE_DIR/commands/"
cp "$SCRIPT_DIR/commands/session-journal-load.md" "$OPENCODE_DIR/commands/"
if [ -f "$SCRIPT_DIR/commands/session-journal-load.sh" ]; then
  cp "$SCRIPT_DIR/commands/session-journal-load.sh" "$OPENCODE_DIR/commands/"
  chmod +x "$OPENCODE_DIR/commands/session-journal-load.sh"
fi
if [ -f "$SCRIPT_DIR/commands/session-journal-save.sh" ]; then
  cp "$SCRIPT_DIR/commands/session-journal-save.sh" "$OPENCODE_DIR/commands/"
  chmod +x "$OPENCODE_DIR/commands/session-journal-save.sh"
fi
if [ -f "$SCRIPT_DIR/commands/session-journal-profile.sh" ]; then
  cp "$SCRIPT_DIR/commands/session-journal-profile.sh" "$OPENCODE_DIR/commands/"
  chmod +x "$OPENCODE_DIR/commands/session-journal-profile.sh"
fi
if [ -f "$SCRIPT_DIR/commands/session-journal-search.sh" ]; then
  cp "$SCRIPT_DIR/commands/session-journal-search.sh" "$OPENCODE_DIR/commands/"
  chmod +x "$OPENCODE_DIR/commands/session-journal-search.sh"
fi
if [ -f "$SCRIPT_DIR/commands/session-journal-profile.md" ]; then
    cp "$SCRIPT_DIR/commands/session-journal-profile.md" "$OPENCODE_DIR/commands/"
fi
if [ -f "$SCRIPT_DIR/commands/session-journal-search.md" ]; then
    cp "$SCRIPT_DIR/commands/session-journal-search.md" "$OPENCODE_DIR/commands/"
fi
# Copy learn command if present
if [ -f "$SCRIPT_DIR/commands/session-journal-learn.md" ]; then
  cp "$SCRIPT_DIR/commands/session-journal-learn.md" "$OPENCODE_DIR/commands/"
fi
if [ -f "$SCRIPT_DIR/commands/session-journal-verify.md" ]; then
  cp "$SCRIPT_DIR/commands/session-journal-verify.md" "$OPENCODE_DIR/commands/"
fi
# Additional commands: copy profile and search if present (single block)
if [ -f "$SCRIPT_DIR/commands/session-journal-profile.md" ]; then
  cp "$SCRIPT_DIR/commands/session-journal-profile.md" "$OPENCODE_DIR/commands/"
fi
if [ -f "$SCRIPT_DIR/commands/session-journal-profile.sh" ]; then
  cp "$SCRIPT_DIR/commands/session-journal-profile.sh" "$OPENCODE_DIR/commands/"
  chmod +x "$OPENCODE_DIR/commands/session-journal-profile.sh"
fi
if [ -f "$SCRIPT_DIR/commands/session-journal-search.md" ]; then
  cp "$SCRIPT_DIR/commands/session-journal-search.md" "$OPENCODE_DIR/commands/"
fi
if [ -f "$SCRIPT_DIR/commands/session-journal-search.sh" ]; then
  cp "$SCRIPT_DIR/commands/session-journal-search.sh" "$OPENCODE_DIR/commands/"
  chmod +x "$OPENCODE_DIR/commands/session-journal-search.sh"
fi

echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo "Available commands:"
echo "  /session-journal-save  - Save current session"
echo "  /session-journal-load  - Load previous session"
echo "  /session-journal-profile - Build or view user profile"
echo "  /session-journal-search - Search saved journals"
echo "  /session-journal-learn - Extract reusable learnings"
echo ""
echo "Try: /session-journal-save \"Your first journal entry\""
