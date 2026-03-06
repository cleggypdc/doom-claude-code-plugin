#!/usr/bin/env bash
# Kill DOOM for real when Claude's session ends.

PID_FILE="/tmp/claude-doom.pid"

pkill -KILL -f "doom_ascii" 2>/dev/null
rm -f "$PID_FILE"

exit 0
