#!/bin/zsh

# android sdk helpers

# update android sdk
function android.update() {
    asdf shell java "$(asdf latest java temurin)"
    sdkmanager update
}

# get system image fullname for specified version
function android.get-system-image() {
    local version="$1"
    if [ -z "$version" ] ; then
        echo Please provide image version 2>&1
        return 1
    fi

    sdkmanager --list \
    | sed -n -E "s/^.*(system-images;${version};google_apis_playstore;$(arch)\S*).*$/\1/p" | uniq
}

### Listing functions ###

function android.list-system-images() {
    asdf shell java "$(asdf latest java temurin)"
    sdkmanager --list \
    | sed -n -E "s/^.*system-images;(.*);google_apis_playstore;$(arch)\S.*$/\1/p" \
    | sort -Vr
}

function android.list-devices() {
    asdf shell java "$(asdf latest java temurin)"
    avdmanager list device -c | sort
}

function android.list-skins() {
    find "$ANDROID_HOME/skins" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; \
    | sort
}

function android.list-devices-with-skins() {
    android.list-devices | sort | comm -12 --check-order - <(android.list-skins | sort)
}

function android.list-avds() {
    asdf shell java "$(asdf latest java temurin)"
    avdmanager list avd -c | sort
}
