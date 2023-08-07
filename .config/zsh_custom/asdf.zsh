#!/bin/zsh

# asdf extensions

# installs plugins specific in dotfiles
function asdf.init() {
    if ! [ -f "${XDG_CONFIG_HOME}/asdf/plugins" ] ; then
        echo "asdf: no plugins list in dotfiles" >&2
        return 1
    fi

    cat "${XDG_CONFIG_HOME}/asdf/plugins" | __asdf.install-plugins
}

# syncs dotfiles with currently installed asdf plugins
function asdf.sync() {
    asdf plugin list > "$XDG_CONFIG_HOME/asdf/plugins"
}

# asdf plugin installer
# installs all plugins specified on stdin
function __asdf.install-plugins() {
    sort /dev/stdin \
    | comm -23 - <(asdf plugin-list | sort) \
    | join - <(asdf plugin list all) \
    | xargs -L1 -t asdf plugin add
}
