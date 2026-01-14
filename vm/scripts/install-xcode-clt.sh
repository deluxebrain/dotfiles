#!/bin/bash
# Install Xcode Command Line Tools headlessly (without GUI dialog).
#
# Environment variables:
#   SKIP_IF_EXISTS - Skip installation if CLT already present (default: "true")
set -euo pipefail

SKIP_IF_EXISTS="${SKIP_IF_EXISTS:-true}"
CLT_PLACEHOLDER="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"

echo "=== Installing Xcode Command Line Tools ==="

# Check if already installed
if [[ -e "/Library/Developer/CommandLineTools/usr/bin/git" ]]; then
    if [[ "${SKIP_IF_EXISTS}" == "true" ]]; then
        echo "Xcode CLT already installed, skipping"
        exit 0
    else
        echo "Xcode CLT already installed, but SKIP_IF_EXISTS=false, reinstalling"
    fi
fi

# Create placeholder to trigger softwareupdate to list CLT
sudo touch "${CLT_PLACEHOLDER}"

cleanup() {
    sudo rm -f "${CLT_PLACEHOLDER}"
}
trap cleanup EXIT

echo "Searching for Command Line Tools package..."

# Find the CLT label from softwareupdate
CLT_LABEL=$(softwareupdate -l 2>&1 | \
    grep -B 1 -E 'Command Line Tools' | \
    awk -F'*' '/^\*/{print $2}' | \
    sed 's/^ *Label: //g' | \
    sort -V | \
    tail -n 1)

if [[ -z "${CLT_LABEL}" ]]; then
    echo "ERROR: Could not find Command Line Tools in softwareupdate" >&2
    echo "Available updates:" >&2
    softwareupdate -l >&2
    exit 1
fi

echo "Installing: ${CLT_LABEL}"
sudo softwareupdate -i "${CLT_LABEL}"

# Point xcode-select to the installed tools
sudo xcode-select --switch /Library/Developer/CommandLineTools

echo "=== Xcode Command Line Tools installed ==="
