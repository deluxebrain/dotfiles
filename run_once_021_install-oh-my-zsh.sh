#!/bin/bash

set -euo pipefail

echo "[Installing] Installing oh-my-zsh and Powerlevel10k theme"

# Check if Oh-My-Zsh is already installed
if [[ ! -d "$ZSH" ]]; then
    echo "[Installing] Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
else
    echo "[Skipping] Oh-My-Zsh is already installed at $ZSH."
fi
