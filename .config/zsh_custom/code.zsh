#!/bin/zsh

# vscode extensions

# syncs extensions with dotfiles
function code.sync() {
    code --list-extensions | tee "${XDG_CONFIG_HOME}/vscode/extensions"
}
