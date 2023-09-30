#!/bin/zsh

# android sdk helpers

TMPL_AVD_INI=$(
cat <<EOF
hw.keyboard=yes
hw.gpu.enabled=yes
hw.gpu.mode=auto
hw.ramSize=1536
EOF
)

TMPL_AVD_INI_SKIN=$(
cat <<'EOF'
showDeviceFrame=yes
skin.dynamic=yes
skin.name=$__skin
skin.path=$ANDROID_HOME/skins
EOF
)

function android.update() (
    android.__shell
    sdkmanager --update
)

function android.list-system-images() (
    android.__shell
    android.__list-system-images
)

function android.list-devices() (
    android.__shell
    avdmanager list device -c
)

function android.list-skins() (
    android.__shell
    android.__list-skins
)

function android.list-avds() (
    android.__shell
    avdmanager list avd -c | sort
)

function android.describe-avds() (
    android.__shell
    avdmanager list avd
)

function android.create-avd() (
    android.__shell
    local device skin image

    IFS=$'\n' devices=( $(android.__list_devices_ex) )

    PS3="Devices marked '*' have skin"
    PS3="$PS3"$'\n'"Select device: "
    select device in "${devices[@]}" ; do
        [ -n "$device" ] && break ;
    done

    if [ ${device: -1:1} ] ; then
        device="${device%\*}"
        skin="$device"
    fi

    PS3="Select system image version: "
    select image in $(android.__list-system-images) ; do
        [ -n "$image" ] && break ;
    done

    image="$(android.__get-system-image $image)"

    if avdmanager list avd -c | grep -q -w "$device" ; then
        echo "Specified avd already exists" 2>&1
        echo "Overwrite? [Y/n]" 2>&1
        read ans && [ ${ans:-n} = Y ] || { false ; return }
    fi

    echo no \
    | avdmanager create avd \
        --force --name "$device" --package "$image" --device "$device"

    echo $TMPL_AVD_INI >> "$ANDROID_EMULATOR_HOME/avd/${device}.ini"

    if [ -n "$skin" ] ; then
        echo $TMPL_AVD_INI_SKIN \
        | __skin="$skin" envsubst >> "$ANDROID_EMULATOR_HOME/avd/${device}.ini"
    fi
)

function android.delete-avd() (
    android.__shell
    PS3="Select avd to delete: "
    select avd in $(avdmanager list avd -c) ; do
        [ -n "$avd" ] && break ;
    done

    avdmanager delete avd  -n "$avd"
)

### PRIVATE FUNCTIONS ###

function android.__shell() {
    asdf shell java "$(asdf latest java temurin)"
}

# get system image fullname for specified version
function android.__get-system-image() {
    local version="$1"
    if [ -z "$version" ] ; then
        echo Please provide image version 2>&1
        return 1
    fi

    sdkmanager --list \
    | sed -n -E "s/^.*(system-images;${version};google_apis_playstore;$(arch)\S*).*$/\1/p" \
    | uniq
}

function android.__list-system-images() {
    sdkmanager --list \
    | sed -n -E "s/^.*system-images;(.*);google_apis_playstore;$(arch)\S.*Image\s*$/\1/p" \
    | sort -Vr
}

function android.__list-skins() {
    find "$ANDROID_HOME/skins" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; \
    | sort
}

# list all devices and mark with * if have skin
function android.__list_devices_ex() (
    android.__shell
    join -1 1 -2 1 -a 1 -t $'\t' -i -o '1.1,2.2' \
        <(paste \
            <(avdmanager list device -c | tr ' ' '_' | tr '[:upper:]' '[:lower:]') \
            <(avdmanager list device -c) | sort -f) \
        <(find "$ANDROID_HOME/skins" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; \
            | sed 's/$/\t*/' \
            | sort -f) \
    | sed 's/\t//'
)
