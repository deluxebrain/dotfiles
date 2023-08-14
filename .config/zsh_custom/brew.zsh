#!/bin/zsh

# brew extensions

# syncs dotfiles with currently installed brew packages
function brew.sync() {
    brew bundle dump --force --file="${XDG_CONFIG_HOME}/homebrew/Brewfile"
}
