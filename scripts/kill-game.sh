#!/usr/bin/env bash
# Pause DOOM when Claude finishes thinking (SIGSTOP freezes the process).

PID_FILE="/tmp/claude-doom.pid"

[ -f "$PID_FILE" ] || exit 0

pkill -STOP -f "doom_ascii" 2>/dev/null

exit 0
