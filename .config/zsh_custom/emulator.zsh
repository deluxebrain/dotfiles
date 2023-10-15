#!/bin/zsh

# emulator helpers

# run emulator
function emulator.run() {
    local -a options
    local family

    options=( "ios" "android" )
    PS3="Select device family: "
    select family in "${options[@]}" ; do
        case "$family" in
            "ios")
                emulator.run-ios ; break ;;
            "android")
                emulator.run-android ; break ;;
        esac
    done
}

function emulator.run-ios() {
    local runtimes runtime_shortname runtime_fullname
    local devices device udid

    IFS=$'\n' runtimes=( $(emulator.__ios_list_runtimes) )

    PS3="Select runtime: "
    select runtime_shortname in $(echo "${runtimes[*]}" | cut -f 1) ; do
        [ -n "$runtime_shortname" ] && break ;
    done

    runtime_fullname="$( \
        sed -n -E "s/^$runtime_shortname\t(.+)$/\1/p" \
        <<< "${runtimes[*]}")"

    IFS=$'\n' devices=( $(emulator.__ios_list_devices "$runtime_fullname") )

    PS3="Select device: "
    select device in $(echo "${devices[*]}" | cut -f 1) ; do
        [ -n "$device" ] && break ;
    done

    # Note cant use -E as device might contact ()
    # Note + ( to match 1+ ) and () ( to capture ) need escaping when not using -E
    udid="$( \
        sed -n "s/^$device\t\(.\+\)$/\1/p" \
        <<< "${devices[*]}")"

    xcrun simctl boot "$udid"

    open -a Simulator
}

function emulator.run-android() {
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
        emulator.__android_run_with_skin "$avd" "$skin_name"
    else
        emulator.__android_run_without_skin "$avd"
    fi
}

# kill all running emulators
function emulator.kill-all() {
    # kill all ios emulators
    xcrun simctl shutdown all
    killall Simulator 2>/dev/null ; true

    # kill all android emulators
    adb devices | grep emulator | cut -f1 | xargs -I {} adb -s {} emu kill
}

function emulator.dark-mode() {
    emulator.__ios_list_running_devices \
    | xargs -I {} xcrun simctl ui {} appearance dark
    adb shell "cmd uimode night yes"
}

function emulator.light-mode() {
    emulator.__ios_list_running_devices \
    | xargs -I {} xcrun simctl ui {} appearance light
    adb shell "cmd uimode night no"
}

### PRIVATE FUNCTIONS ###

function emulator.__android_run_with_skin() {
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

function emulator.__android_run_without_skin() {
    local avd="$1"

    nohup emulator \
        -avd "$avd" \
        -no-snapshot \
        -wipe-data \
        -no-boot-anim </dev/null >/dev/null 2>&1 &
}

function emulator.__ios_list_runtimes() {
    paste \
        <(xcrun simctl list devices --json \
            | jq -r '.devices | keys[]' \
            | rev \
            | cut -d'.' -f1 \
            | rev \
            | sort) \
        <(xcrun simctl list devices --json \
            | jq -r '.devices | keys[]' \
            | sort)
}

function emulator.__ios_list_devices() {
    local runtime="$1"

    if [ -z "$runtime" ] ; then
        echo Please provide runtime name 2>&1
        return 1
    fi

    xcrun simctl list devices --json \
    | jq -r --arg runtime "$runtime" '
        .devices
        | with_entries(select(.key | match($runtime)))
        | to_entries[]
        | .value[]
        | [.name, .udid]
        | @tsv'
}

function emulator.__ios_list_running_devices() {
    xcrun simctl list --json \
    | jq -r '
        .devices
        | to_entries[]
        | .value[]
        | select(.state=="Booted")
        | .udid'
}
