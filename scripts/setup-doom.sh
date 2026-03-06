#!/usr/bin/env bash
# One-time setup: download pre-built doom-ascii binary + shareware WAD.
set -e

DOOM_DIR="${HOME}/.claude-doom"
BINARY="${DOOM_DIR}/doom_ascii"
WAD="${DOOM_DIR}/doom1.wad"
VERSION="0.3.1"

# Skip if already set up
if [ -x "$BINARY" ] && [ -f "$WAD" ]; then
    exit 0
fi

echo "[doom-plugin] Setting up DOOM (one-time)..."
mkdir -p "$DOOM_DIR"

# Download pre-built binary
if [ ! -x "$BINARY" ]; then
    ARCH=$(uname -m)
    OS=$(uname -s)

    if [ "$OS" = "Linux" ] && [ "$ARCH" = "x86_64" ]; then
        echo "[doom-plugin] Downloading doom-ascii ${VERSION} (Linux x86_64)..."
        URL="https://github.com/wojciech-graj/doom-ascii/releases/download/${VERSION}/doom-ascii-${VERSION}-x86_64-linux.zip"
        TMP=$(mktemp -d)
        curl -sL "$URL" -o "${TMP}/doom-ascii.zip"
        unzip -qo "${TMP}/doom-ascii.zip" -d "${TMP}"
        cp "${TMP}/doom-ascii" "$BINARY"
        chmod +x "$BINARY"
        rm -rf "$TMP"
    elif [ "$OS" = "Darwin" ]; then
        # macOS: no pre-built binary, build from source
        echo "[doom-plugin] Building doom-ascii from source (macOS)..."
        if ! command -v make &>/dev/null; then
            xcode-select --install 2>/dev/null
            echo "[doom-plugin] ERROR: Xcode command line tools required. Run: xcode-select --install"
            exit 1
        fi
        TMP=$(mktemp -d)
        git clone --depth 1 https://github.com/wojciech-graj/doom-ascii.git "$TMP"
        make -C "$TMP"
        find "$TMP" -name "doom-ascii" -type f | head -1 | xargs -I{} cp {} "$BINARY"
        rm -rf "$TMP"
    else
        echo "[doom-plugin] ERROR: Unsupported platform: ${OS} ${ARCH}"
        echo "[doom-plugin] Supported: Linux x86_64, macOS. See https://github.com/wojciech-graj/doom-ascii"
        exit 1
    fi

    if [ ! -x "$BINARY" ]; then
        echo "[doom-plugin] ERROR: Failed to install doom-ascii binary"
        exit 1
    fi
    echo "[doom-plugin] doom-ascii ready."
fi

# Download the shareware DOOM1.WAD (freely distributable)
if [ ! -f "$WAD" ]; then
    echo "[doom-plugin] Downloading DOOM shareware WAD..."
    curl -sL "https://distro.ibiblio.org/slitaz/sources/packages/d/doom1.wad" -o "$WAD"

    if [ ! -s "$WAD" ]; then
        rm -f "$WAD"
        echo "[doom-plugin] ERROR: Failed to download WAD. Try manually placing doom1.wad in ${DOOM_DIR}/"
        exit 1
    fi
    echo "[doom-plugin] WAD ready."
fi

echo "[doom-plugin] DOOM setup complete! Rip and tear."
