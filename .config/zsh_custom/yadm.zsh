#!/bin/zsh

# yadm aliases

# use lazygit with yadm
function y() {
    cd "$DOTFILES_HOME"
    yadm enter lazygit
    cd -
}

# yadm extensions

# clone dotfiles to non-HOME and set .zshenv override to activate it
function yadm.start-testing() {
    local dotfiles_path="$(pwd)"

    cat <<EOF > "${HOME}/.zshenv"
export DOTFILES_HOME="$dotfiles_path"
export ZDOTDIR="${dotfiles_path}/.config/zsh"
EOF

    echo "Issue yadm.stop-testing to restore main dotfiles"
    echo "Terminal restart required ..."
}

# stop testing
function yadm.stop-testing() {
    rm "${HOME}/.zshenv"

    echo "Terminal restart required ..."
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
