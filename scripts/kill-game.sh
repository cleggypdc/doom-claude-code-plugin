#!/usr/bin/env bash
# Dismiss the DOOM popup when Claude finishes thinking.

pkill -f "doom_ascii" 2>/dev/null
rm -f /tmp/claude-doom.pid

exit 0
