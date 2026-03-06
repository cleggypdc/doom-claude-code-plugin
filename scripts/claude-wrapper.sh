#!/usr/bin/env bash
# Drop-in replacement for 'claude' that transparently wraps it in tmux.
# Install: alias claude='~/doom-plugin/scripts/claude-wrapper.sh'
#
# The user runs 'claude' as normal. This script:
# 1. If already in tmux → runs claude directly with the plugin
# 2. If not → starts tmux, runs claude inside it, exits when claude exits
#
# Hooks inside the plugin can then use tmux panes/popups freely.

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REAL_CLAUDE="$(which -a claude | grep -v "$0" | head -1)"

if [ -z "$REAL_CLAUDE" ]; then
    echo "Error: claude not found in PATH"
    exit 1
fi

# Already inside tmux — just run Claude with the plugin
if [ -n "$TMUX" ]; then
    exec "$REAL_CLAUDE" --plugin-dir "$PLUGIN_DIR" "$@"
fi

# Not in tmux — wrap transparently
if ! command -v tmux &>/dev/null; then
    # No tmux available — fall back to running Claude directly
    exec "$REAL_CLAUDE" --plugin-dir "$PLUGIN_DIR" "$@"
fi

# Start tmux with optimized config, exit tmux when Claude exits
exec tmux -f "$PLUGIN_DIR/tmux.conf" new-session -s "claude-$$" \
    "$REAL_CLAUDE --plugin-dir '$PLUGIN_DIR' $*"
