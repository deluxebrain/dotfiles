#!/bin/zsh

# flutterfire helpers

# Configure firebase app flavor with support for crashlytics
function flutterfire.configure() {
    if [ $# -ne 3 ] ; then
        echo "Need 3 arguments: firebaseProjectID, flavor, bundleID" >&2
        return 1
    fi

    local project="$1"
    local flavor="$2"
    local bundle_id="$3"

    local account="$(flutterfire.get_logged_in_account)"
    if [[ -z "$account" ]] ; then
        echo "Not logged in" >&2
        return 1
    fi

    for prefix in "Debug" "Release" "Profile"; do
        echo 'yes' | \
        flutterfire configure \
            --account="$account" \
            --project="$project" \
            --out="lib/config/firebase/flavor/firebase_options.dart" \
            --android-out="/android/app/src/$flavor/google-services.json" \
            --ios-bundle-id="$bundle_id" \
            --android-package-name="$bundle_id" \
            --ios-out="/ios/Firebase/$flavor/GoogleService-Info.plist" \
            --ios-build-config="$prefix-$flavor" \
            --yes
    done
}

function flutterfire.get_logged_in_account() {
    account="$(firebase login:list | rev | cut -d ' ' -f 1 | rev)"

    case "$account" in
        *@*)
            echo "$account" ;;
        *)
            return 1
    esac
}
