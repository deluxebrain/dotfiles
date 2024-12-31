#!/bin/bash

set -euo pipefail

# This script is run after changes to .zprofile are applied.
# It is used to reload the Zsh shell to apply the changes.

# .zprofile hash: {{ include "dot_config/zsh/dot_zprofile" | sha256sum }}
# .zshrc hash: {{ include "dot_config/zsh/dot_zshrc" | sha256sum }}
# tmux.conf hash: {{ include "dot_config/tmux/tmux.conf" | sha256sum }}
# com.apple.Terminal.xml hash: {{ include "dot_config/terminal/com.apple.Terminal.xml" | sha256sum }}

# Load Homebrew environment variables only if not already loaded
if ! command -v brew &>/dev/null; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

figlet -f starwars "Reload your shell"
echo "( a full machine reboot may be required for all settings to take affect )"
