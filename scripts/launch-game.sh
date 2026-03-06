#!/usr/bin/env bash
# Launch ASCII DOOM as a tmux overlay while Claude thinks.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOOM_DIR="${HOME}/.claude-doom"
BINARY="${DOOM_DIR}/doom_ascii"
WAD="${DOOM_DIR}/doom1.wad"

# Run setup if needed (first launch only)
if [ ! -x "$BINARY" ] || [ ! -f "$WAD" ]; then
    bash "${SCRIPT_DIR}/setup-doom.sh"
    if [ ! -x "$BINARY" ] || [ ! -f "$WAD" ]; then
        exit 0
    fi
fi

# Only works inside tmux (claude-wrapper.sh ensures this)
[ -n "$TMUX" ] || exit 0

# Kill any existing doom (from a previous popup)
pkill -f "doom_ascii" 2>/dev/null

GAME_CMD="TERM=xterm-256color ${BINARY} -iwad ${WAD} -scaling 5 -chars block"

# Floating popup overlay — renders on top of Claude
tmux display-popup -w 80% -h 80% -E "$GAME_CMD" &
echo "popup" > /tmp/claude-doom.pid

exit 0
