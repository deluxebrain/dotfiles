#!/bin/zsh

# tmux extensions

# reload tmux configuration
# also bound to <prefix> r
function tmux.reload() {
    tmux source-file "${XDG_CONFIG_HOME}/tmux/tmux.conf"
}

# install plugins
# also bound to <prefix> I
function tmux.install-plugins() {
    "${XDG_CONFIG_HOME}/tmux/plugins/tpm/bin/install_plugins"
}

# update plugins
function tmux.update-plugins() {
    "${XDG_CONFIG_HOME}/tmux/plugins/tpm/bin/update_plugins"
}
