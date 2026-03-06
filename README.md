# DOOM for Claude Code

A Claude Code plugin that launches the original DOOM (rendered in ASCII) while Claude is thinking.

https://github.com/user-attachments/assets/effe9689-7b77-473e-a900-d26da3d83b9a

## How it works

- **Send a prompt** → DOOM launches as a tmux popup overlay on top of Claude
- **Claude finishes** → DOOM dismisses automatically
- **Send another prompt** → DOOM launches again
- **Quit Claude** → DOOM closes

The game uses [doom-ascii](https://github.com/wojciech-graj/doom-ascii), a source port of the original DOOM engine that renders to ASCII block characters in your terminal. It plays the shareware WAD (Episode 1: Knee-Deep in the Dead).

## Install

```bash
git clone https://github.com/cleggypdc/doom-claude-code-plugin.git
```

Then use the wrapper script which transparently runs Claude inside tmux (required for the overlay):

```bash
alias claude='~/doom-claude-code-plugin/scripts/claude-wrapper.sh'
claude
```

Or if you're already in tmux, you can use the plugin directly:

```bash
claude --plugin-dir ./doom-claude-code-plugin
```

First run automatically downloads the doom-ascii binary and the freely distributable shareware WAD (~5MB total).

## Requirements

- Claude Code v1.0.33+
- Linux x86_64 (pre-built binary) or macOS (builds from source)
- `tmux` (for overlay popup — falls back to running without overlay if unavailable)
- `curl` and `unzip`

## Controls

| Key | Action |
|-----|--------|
| Arrow keys | Move |
| `,` / `.` | Strafe |
| Space | Fire |
| E | Use / Open doors |
| `]` | Sprint |
| 1-7 | Weapon select |

## Plugin hooks

| Event | Action |
|-------|--------|
| `SessionStart` | Downloads doom-ascii + WAD (first run only) |
| `UserPromptSubmit` | Launches DOOM as tmux popup overlay |
| `Stop` | Dismisses the DOOM popup |
| `SessionEnd` | Kills DOOM |

## Credits

- [doom-ascii](https://github.com/wojciech-graj/doom-ascii) by wojciech-graj
- DOOM by id Software
