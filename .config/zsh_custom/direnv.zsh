#!/bin/zsh

function direnv.whitelist() {
    yq \
        -oy \
        '.whitelist.exact |= (. + '"\"$PWD\""' | unique)' \
        "$XDG_CONFIG_HOME/direnv/direnv.toml" \
    | yj -yt > tmp.$$
    mv tmp.$$ "$XDG_CONFIG_HOME/direnv/direnv.toml"
}
