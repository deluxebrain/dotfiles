#!/bin/zsh

# Updates the direnv whitelist by adding the current working directory
# to the list of exact matches in the direnv configuration file.
function direnv.whitelist() {
    yq \
        -oy \
        '.whitelist.exact |= (. + '"\"$PWD\""' | unique)' \
        "$XDG_CONFIG_HOME/direnv/direnv.toml" \
    | yj -yt > tmp.$$
    mv tmp.$$ "$XDG_CONFIG_HOME/direnv/direnv.toml"
}
