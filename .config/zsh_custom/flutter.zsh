#!/bin/zsh

# see: https://gist.github.com/ThePredators/064c46403290a6823e03be833a2a3c21

# flutter helpers

# install all flutter dependencies
function flutter.update() {
    asdf install java latest:temurin
    asdf install ruby latest:3
    asdf install bundler latest
    asdf install cocoapods latest
    asdf install flutter latest
}

# create new flutter project in current directory
function flutter.create() {
    if [ -z "$1" ] ; then
        echo Please provide project name 2>&1
        return 1
    fi

    if [ -d "$1" ] ; then
        echo Project already exists 2>&1
        return 1
    fi

    asdf shell flutter latest

    # use --org to add org
    # e.g. --org com.example
    flutter create --project-name "$1"

    cd "$1" || return

    asdf local java latest:temurin
    asdf local ruby latest:3
    asdf local bundler latest
    asdf local cocoapods latest
    asdf local flutter latest
}

function flutter.doctor() {
    asdf shell java "$(asdf latest java temurin)"
    asdf shell ruby "$(asdf latest ruby)"
    asdf shell bundler "$(asdf latest bundler)"
    asdf shell cocoapods "$(asdf latest cocoapods)"
    asdf shell flutter "$(asdf latest flutter)"

    flutter doctor -v
}
