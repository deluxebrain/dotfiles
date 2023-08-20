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

function flutter.setup() {
    asdf install java latest:temurin
    asdf install ruby latest:3
    asdf install bundler latest
    asdf install cocoapods latest
    asdf install flutter latest

    asdf shell java "$(asdf latest java temurin)"
    asdf shell ruby "$(asdf latest ruby)"
    asdf shell bundler "$(asdf latest bundler)"
    asdf shell cocoapods "$(asdf latest cocoapods)"
    asdf shell flutter "$(asdf latest flutter)"

    yes | sdkmanager --licenses >/dev/null

    sdkmanager "ndk-bundle"
    sdkmanager "build-tools;34.0.0"
    sdkmanager "platforms;android-32"
    sdkmanager "platform-tools"
    sdkmanager "emulator"
    sdkmanager "tools"

    flutter doctor -v
}
