#!/usr/bin/env bash
# Launch or resume ASCII DOOM while Claude thinks.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="/tmp/claude-doom.pid"
DOOM_DIR="${HOME}/.claude-doom"
BINARY="${DOOM_DIR}/doom_ascii"
WAD="${DOOM_DIR}/doom1.wad"

# If DOOM is already running (paused), just resume it
if [ -f "$PID_FILE" ]; then
    pid=$(cat "$PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
        # Process is alive — send SIGCONT to unpause
        pkill -CONT -f "doom_ascii" 2>/dev/null
        exit 0
    else
        # Stale PID file
        rm -f "$PID_FILE"
    fi
fi

# Run setup if needed (first launch only)
if [ ! -x "$BINARY" ] || [ ! -f "$WAD" ]; then
    bash "${SCRIPT_DIR}/setup-doom.sh"
    if [ ! -x "$BINARY" ] || [ ! -f "$WAD" ]; then
        exit 0
    fi
fi

GAME_CMD="${BINARY} -iwad ${WAD} -scaling 5 -chars block"

# Windows Terminal — split pane so DOOM renders natively beside Claude
if [ -n "$WT_SESSION" ] && command -v wt.exe &>/dev/null; then
    wt.exe -w 0 split-pane -V -s 0.5 --title DOOM wsl.exe bash -c "$GAME_CMD" &>/dev/null &
    # Give it a moment to start, then grab the PID
    sleep 1
    pgrep -f "doom_ascii" > "$PID_FILE" 2>/dev/null
elif command -v tmux &>/dev/null && [ -n "$TMUX" ]; then
    tmux split-window -h -l 50% "TERM=xterm-256color $GAME_CMD"
    tmux select-pane -L
    sleep 1
    pgrep -f "doom_ascii" > "$PID_FILE" 2>/dev/null
elif [[ "$OSTYPE" == "darwin"* ]]; then
    osascript -e "tell application \"Terminal\" to do script \"$GAME_CMD; exit\"" &>/dev/null
    sleep 1
    pgrep -f "doom_ascii" > "$PID_FILE" 2>/dev/null
else
    for term in gnome-terminal konsole xfce4-terminal xterm; do
        if command -v "$term" &>/dev/null; then
            if [ "$term" = "gnome-terminal" ]; then
                $term -- bash -c "$GAME_CMD" &>/dev/null &
            else
                $term -e "$GAME_CMD" &>/dev/null &
            fi
            sleep 1
            pgrep -f "doom_ascii" > "$PID_FILE" 2>/dev/null
            break
        fi
    done
fi

exit 0
