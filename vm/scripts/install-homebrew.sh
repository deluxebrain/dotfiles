#!/bin/bash
# Install Homebrew non-interactively.
#
# Environment variables:
#   SKIP_IF_EXISTS - Skip installation if Homebrew already present (default: "true")
set -euo pipefail

SKIP_IF_EXISTS="${SKIP_IF_EXISTS:-true}"
HOMEBREW_PREFIX="/opt/homebrew"

echo "=== Installing Homebrew ==="

# Check if already installed
if [[ -x "${HOMEBREW_PREFIX}/bin/brew" ]]; then
    if [[ "${SKIP_IF_EXISTS}" == "true" ]]; then
        echo "Homebrew already installed, skipping"
        exit 0
    else
        echo "Homebrew already installed, but SKIP_IF_EXISTS=false, reinstalling"
    fi
fi

# Install Homebrew non-interactively
export NONINTERACTIVE=1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "=== Homebrew installed ==="
