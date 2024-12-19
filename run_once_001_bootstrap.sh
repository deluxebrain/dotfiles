#!/bin/bash

set -eu

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# create xdg file system
[ -d "$XDG_CONFIG_HOME" ] || mkdir -p "$XDG_CONFIG_HOME"
[ -d "$XDG_CACHE_HOME" ] || mkdir -p "$XDG_CACHE_HOME"
[ -d "$XDG_DATA_HOME" ] || mkdir -p "$XDG_DATA_HOME"
[ -d "$XDG_STATE_HOME" ] || mkdir -p "$XDG_STATE_HOME"

# XDG_DATA_HOME paths that must exist
[ -d "$XDG_DATA_HOME/asdf" ] || mkdir -p "$XDG_STATE_HOME/asdf"
[ -d "$XDG_DATA_HOME/gnupg" ] || mkdir -p "$XDG_STATE_HOME/gnupg"
[ -d "$XDG_DATA_HOME/vagrant" ] || mkdir -p "$XDG_STATE_HOME/vagrant"
[ -d "$XDG_DATA_HOME/vim" ] || mkdir -p "$XDG_STATE_HOME/vim"
[ -d "$XDG_DATA_HOME/vscode" ] || mkdir -p "$XDG_STATE_HOME/vscode"

# XDG_STATE_HOME paths that must exist
[ -d "$XDG_STATE_HOME/gh" ] || mkdir -p "$XDG_STATE_HOME/gh"
[ -d "$XDG_STATE_HOME/less" ] || mkdir -p "$XDG_STATE_HOME/less"
[ -d "$XDG_STATE_HOME/vagrant" ] || mkdir -p "$XDG_STATE_HOME/vagrant"
[ -d "$XDG_STATE_HOME/zsh" ] || mkdir -p "$XDG_STATE_HOME/zsh"
