#!/bin/zsh

# yadm aliases

# use lazygit with yadm
function y() {
    cd "$DOTFILES_HOME"
    yadm enter lazygit
    cd -
}

# yadm extensions

# clone dotfiles to non-HOME and set ~/.zshenv override to activate it
function yadm.start-testing() {
    local dotfiles_home="$(pwd)"
    local dotfiles_remote="$(yadm remote get-url origin)"

    while true; do
        echo -n "Do you wish to proceed? (y/n) "
        read yn
        case $yn in
            [Yy]* ) break ;;
            [Nn]* ) return 1 ;;
            * ) echo "Please answer yes or no" ;;
        esac
    done

    yadm.__patch_env "$dotfiles_home"
    yadm config local.class Test
    yadm clone -f "$dotfiles_remote" -w "$DOTFILES_HOME" --bootstrap

    cat <<EOF > "${HOME}/.zshenv"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
EOF

    omg reload
}

# stop testing
function yadm.stop-testing() {
    yadm.__patch_env "$HOME"
    rm "${HOME}/.zshenv"
    omg reload
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

function yadm.__patch_env() {
    local dotfiles_home="$1"
    if [ -z "$dotfiles_home" ] ; then
        echo "ERROR: Please provide path to dotfiles home" >&2
        return 1
    fi

    # set just enough of the environment to get yadm and omz working
    DOTFILES_HOME="$dotfiles_home"
    XDG_CONFIG_HOME="${DOTFILES_HOME}/.config"
    XDG_CACHE_HOME="${DOTFILES_HOME}/.cache"
    XDG_DATA_HOME="${DOTFILES_HOME}/.local/share"
    XDG_STATE_HOME="${DOTFILES_HOME}/.local/state"
    ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
    ZSH="${XDG_CONFIG_HOME}/oh-my-zsh"
}