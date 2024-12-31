#!/bin/bash

set -euo pipefail

# This script is run once to create the XDG file system.

# create xdg file system
echo "[Creating] XDG file system..."
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CACHE_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"

# XDG_DATA_HOME paths that must exist
mkdir -p "$XDG_DATA_HOME/asdf"
mkdir -p "$XDG_DATA_HOME/gnupg"
mkdir -p "$XDG_DATA_HOME/vagrant"
mkdir -p "$XDG_DATA_HOME/vim"

# XDG_STATE_HOME paths that must exist
mkdir -p "$XDG_STATE_HOME/gh"
mkdir -p "$XDG_STATE_HOME/less"
mkdir -p "$XDG_STATE_HOME/vagrant"
mkdir -p "$XDG_STATE_HOME/zsh"
