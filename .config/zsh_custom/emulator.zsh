#!/bin/zsh

# emulator helpers

# run emulator
function emulator.run() {
    local avd="$1"
    local skin_name

    if (( $(emulator -list-avds | wc -l) == 0 )) ; then
        echo "emulator: no avds created" >&2
        return 1
    fi

    if [ -z "$avd" ] ; then
        PS3="Select avd: "
        select avd in $(emulator -list-avds) ; do
            [ -n "$avd" ] && break ;
        done
    fi

    if ! emulator -list-avds | grep -q -w "$avd" ; then
        echo "emulator: no such avd" >&2
        return 1
    fi

    skin_name="$(sed -n -E 's/skin.name=(.*)/\1/p' $ANDROID_EMULATOR_HOME/avd/$avd.ini)"
    if [ -n "$skin_name" ] ; then
        emulator.__run_with_skin "$avd" "$skin_name"
    else
        emulator.__run_without_skin "$avd"
    fi
}

# kill all running emulators
function emulator.kill-all() {
    adb devices | grep emulator | cut -f1 | xargs adb emu kill
}

### PRIVATE FUNCTIONS ###

function emulator.__run_with_skin() {
    local avd="$1"
    local skin="$2"

    nohup emulator \
        -avd "$avd" \
        -skindir "$ANDROID_HOME/skins" \
        -skin "$skin_name" \
        -no-snapshot \
        -wipe-data \
        -no-boot-anim </dev/null >/dev/null 2>&1 &
}

function emulator.__run_without_skin() {
    local avd="$1"

    nohup emulator \
        -avd "$avd" \
        -no-snapshot \
        -wipe-data \
        -no-boot-anim </dev/null >/dev/null 2>&1 &
}
