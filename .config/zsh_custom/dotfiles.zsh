#!/bin/zsh

# dotfiles helpers

# update all dependencies
function dotfiles.update() {
    cd $HOME || exit

    # Ask for the administrator password upfront
    sudo -v

    echo Upgrading all brew packages >&2
    brew update
    brew upgrade

    echo Updating all yadm submodules >&2
    yadm submodule update --recursive

    echo Updating oh-my-zsh >&2
    omz update

    echo Updating all asdf plugins >&2
    asdf plugin update --all
}
