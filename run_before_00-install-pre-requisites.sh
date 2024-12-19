#!/bin/bash

set -eu

echo "[Notice] Some packages will require administrator privileges. Please enter your password when prompted."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "[Installing] Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "[Info] Homebrew is already installed"
fi
