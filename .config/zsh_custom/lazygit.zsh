#!/bin/zsh

# lazygit

# use lazygit with yadm
function lg() {
    cd "$HOME"
    yadm enter lazygit
    cd -
}
