#!/bin/zsh

# see: https://gist.github.com/ThePredators/064c46403290a6823e03be833a2a3c21

# flutter helpers

# Ref re activesupport:
# https://stackoverflow.com/questions/77236339/after-updating-cocoapods-to-1-13-0-it-throws-error
TMPL_FLUTTER_GEMFILE=$(
cat <<EOF
source "https://rubygems.org"

gem "activesupport", "7.0.8"
gem "cocoapods"
gem "fastlane"
EOF
)

# download latest version of all flutter dependencies
function flutter.update() {
    asdf install java latest:temurin
    asdf install ruby latest:3
    asdf install flutter latest
    asdf install firebase latest
}

# inplace upgrade of a flutter project
function flutter.upgrade() {
    flutter.update
    asdf local flutter latest
    flutter upgrade
    flutter pub upgrade
    flutter doctor -v
}

# run specific flavor
function flutter.run() {
    if [ -z "$1" ] ; then
        echo Please provide flavor name 2>&1
        return 1
    fi

    flutter run --flavor "$1" -t "lib/main_$1.dart"
}

# build specific flavor
function flutter.build() {
    if [ -z "$1" ] ; then
        echo Please provide flavor name 2>&1
        return 1
    fi

    flutter clean
    flutter pub get

    # both ios and android apps will be signed later on in build pipeline
    flutter build ipa --no-codesign --release --flavor "$1" -t "lib/main_$1.dart"
    flutter build appbundle --release --flavor "$1" -t "lib/main_$1.dart"
}

# run on all devices
function flutter.run-all() {
    flutter run -d all
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

    ( \
        asdf shell flutter latest && \
        flutter create \
            --platforms=android,ios \
            --project-name "$1" \
            "$1" \
    )

    cd "$1" || return

    flutter.__install
}

# bring in flutter dependencies for existing project
# use when cloning existing flutter projects
function flutter.init() {
    flutter.__install
    flutter pub get
}

function flutter.pub-upgrade() {
    flutter pub upgrade
}

function flutter.build-runner() {
    flutter pub run build_runner build --delete-conflicting-outputs
}

function flutter.build-runner-watch() {
    flutter pub run build_runner watch --delete-conflicting-outputs
}

function flutter.doctor() {
    flutter doctor -v
}

### PRIVATE FUNCTIONS ###

# Configure project with Flutter runtime and dependencies
function flutter.__install() {
    asdf local ruby latest:3

    # gem install cocoapods
    # https://stackoverflow.com/questions/77236339/after-updating-cocoapods-to-1-13-0-it-throws-error
    # gem uninstall --force activesupport
    # gem install activesupport -v 7.0.8

    asdf local java latest:temurin
    asdf local flutter latest
    asdf local firebase latest

    if ! [[ -f Gemfile ]] ; then
        echo "$TMPL_FLUTTER_GEMFILE" >> Gemfile
    fi

    bundle install

    bundle exec pod setup
}
