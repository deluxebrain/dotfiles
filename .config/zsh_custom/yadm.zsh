#!/bin/zsh

# yadm extensions

# use lazygit with yadm
function y() {
    cd "$HOME"
    yadm enter lazygit
    cd -
}

# delete submodule as managed by yadm
function yadm.delete-submodule() {
    local submodule_path="$1"

    if [ -z "$submodule_path" ] ; then
        echo "yadm: please specify path to submodule" >&2
        return 1
    fi

    if ! yadm submodule status "$submodule_path" >/dev/null 2>&1 ; then
        echo "yadm: no submodule at specified path" >&2
        echo "yadm: please ensure you are running from root of home directory" >&2
        return 1
    fi

    # remove submodule from .git/config
    yadm submodule deinit -f "$submodule_path"

    # remove submodule from .git/modules directory
    rm -rf "$(yadm rev-parse --git-dir)/modules/$submodule_path"

    # remove submodule from .gitmodules
    yadm rm -f "$submodule_path"
}
