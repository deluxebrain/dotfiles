#!/bin/bash

set -eu

# Install macOS updates
echo "[Installing] macOS updates..."
sudo softwareupdate -i -a

# Install Xcode command line tools
if ! xcode-select -p &> /dev/null; then
    echo "[Installing] Xcode command line tools..."
    xcode-select --install
fi

# Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "[Installing] Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
