#!/bin/zsh

# vscode extensions

# syncs extensions with dotfiles
function code.sync() {
    code --list-extensions | tee "${XDG_CONFIG_HOME}/vscode/extensions"
}

# installs extensions from dotfiles
function code.install-extensions() {
    awk "NF" "$XDG_CONFIG_HOME/vscode/extensions" \
    | xargs -I{} code --force --install-extension {}
}