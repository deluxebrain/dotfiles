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
            [ -n "${avd}" ] && break ;
        done
    fi

    if ! emulator -list-avds | grep -q -w "$avd" ; then
        echo "emulator: no such avd" >&2
        return 1
    fi

    skin_name="$(sed -n -E 's/skin.name=(.*)/\1/p' $ANDROID_EMULATOR_HOME/avd/$avd.ini)"
    if [ -z "$skin_name" ] ; then
        echo "emulator: avd configuration missing skin.name" >&2
        return 1
    fi

    # emulator ignores skin.name from the .ini file
    # hence pass as option
    nohup emulator \
        -avd "$avd" \
        -skindir "${ANDROID_HOME}/skins" \
        -skin "$skin_name" \
        -no-boot-anim </dev/null >/dev/null 2>&1 &
}

# kill all running emulators
function emulator.kill-all() {
    adb devices | grep emulator | cut -f1 | xargs adb emu kill
}
