#!/bin/zsh

# see: https://gist.github.com/ThePredators/064c46403290a6823e03be833a2a3c21

# flutter helpers

# create new flutter project in current directory
function flutter.init() {
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
