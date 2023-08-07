#!/bin/zsh

# zsh extensions

# reload zsh environment
function zsh.reload() {
    # DONT DO THIS
    # for some reason is evaluates the aliases ...
    # source "${ZDOTDIR}/.zshrc"

    # instead use the function provided by omz
    # https://github.com/ohmyzsh/ohmyzsh/wiki/Cheatsheet
    omz reload
}
