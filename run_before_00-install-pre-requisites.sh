#!/bin/bash

set -eu

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "[Installing] Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "[Info] Homebrew is already installed"
fi
