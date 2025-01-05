#!/bin/bash

set -euo pipefail

# Load Homebrew environment variables only if not already loaded
if ! command -v brew &>/dev/null; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "[Configuration] Creating new CA and installing in system trust store..."
mkcert --install
