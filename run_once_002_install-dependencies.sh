#!/bin/bash

set -euo pipefail

# This script is run once to install system updates and tools.

# Disable automatic software updates until move to Packer images
# ( software updates require the recovery partition to exist )
# echo "[Installing] macOS updates..."
# sudo softwareupdate -i -a

# Install Xcode command line tools
if ! xcode-select -p &> /dev/null; then
    echo "[Installing] Xcode command line tools..."
    xcode-select --install
else
    echo "[Skipping] Xcode command line tools already installed"
fi

# Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "[Installing] Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "[Skipping] Homebrew already installed"
fi
