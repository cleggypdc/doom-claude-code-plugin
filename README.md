# DOOM for Claude Code

A Claude Code plugin that launches the original DOOM (rendered in ASCII) while Claude is thinking.

## How it works

- **Send a prompt** → DOOM launches in a side-by-side terminal pane
- **Claude finishes** → DOOM pauses (your progress is saved)
- **Send another prompt** → DOOM resumes where you left off
- **Quit Claude** → DOOM closes

The game uses [doom-ascii](https://github.com/wojciech-graj/doom-ascii), a source port of the original DOOM engine that renders to ASCII block characters in your terminal. It plays the shareware WAD (Episode 1: Knee-Deep in the Dead).

## Install

```bash
claude --plugin-dir /path/to/doom-claude-code-plugin
```

Or clone it and point Claude at it:

```bash
git clone https://github.com/cleggypdc/doom-claude-code-plugin.git
claude --plugin-dir ./doom-claude-code-plugin
```

First run automatically downloads the doom-ascii binary and the freely distributable shareware WAD (~5MB total).

## Requirements

- Claude Code v1.0.33+
- Linux x86_64 (pre-built binary) or macOS (builds from source)
- `curl` and `unzip`
- Windows Terminal (for side-by-side split pane on WSL)

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
| `UserPromptSubmit` | Launches or resumes DOOM |
| `Stop` | Pauses DOOM (SIGSTOP) |
| `SessionEnd` | Kills DOOM |

## Credits

- [doom-ascii](https://github.com/wojciech-graj/doom-ascii) by wojciech-graj
- DOOM by id Software
