#!/bin/zsh

# yadm aliases

# use lazygit with yadm
function y() {
    cd "$DOTFILES_HOME"
    yadm enter lazygit
    cd -
}

# yadm extension

# show info re yadm git repo
function yadm.info() {
    yadm remote get-url origin
    yadm rev-parse --show-toplevel
}

# run development environment bootstrap
function yadm.bootstrap-dev() {
    if [ -z "$1" ] ; then
        echo "Please specifiy development environment name" >&2
        return 1
    fi

    yadm config local.class "$1"
    yadm bootstrap
    yadm config --unset local.class
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

# clone dotfiles to non-HOME
# TODO: support branches ( probably the whole point of this ... )
function yadm.clone() {
    local dotfiles_home="$(pwd)"
    local dotfiles_remote="$(yadm remote get-url origin)"

    echo "About to clone main branch to current directory" >&2
    while true; do
        echo -n "Do you wish to proceed? (y/n) "
        read yn
        case $yn in
            [Yy]* ) break ;;
            [Nn]* ) return 1 ;;
            * ) echo "Please answer yes or no" ;;
        esac
    done

    # patch the environment to support the new dotfiles
    # and then clone and bootstrap them
    # note that setting the local.class requires the new repository to exist
    # hence the two step process
    yadm.patch_xdg_env "$dotfiles_home"
    yadm clone -f "$dotfiles_remote" -w "$dotfiles_home" --no-bootstrap
    yadm config local.class Secondary
    yadm bootstrap

    source $ZDOTDIR/.zshrc
    omz reload
}

# revert to main dotfiles
function yadm.restore() {
    yadm.patch_xdg_env "$HOME"
    yadm config local.class Switch
    yadm bootstrap
    yadm config --unset local.class
    source $ZDOTDIR/.zshrc
    omz reload
}

function yadm.patch_xdg_env() {
    local dotfiles_home="$1"
    if [ -z "$dotfiles_home" ] ; then
        echo "ERROR: Please provide path to dotfiles home" >&2
        return 1
    fi

    # patch env for new yadm repo
    # https://github.com/TheLocehiliosan/yadm/blob/master/yadm.md#files
    DOTFILES_HOME="$dotfiles_home"
    XDG_CONFIG_HOME="$DOTFILES_HOME/.config"
    XDG_CACHE_HOME="$DOTFILES_HOME/.cache"
    XDG_DATA_HOME="$DOTFILES_HOME/.local/share"
    XDG_STATE_HOME="$DOTFILES_HOME/.local/state"
    ZDOTDIR="$XDG_CONFIG_HOME/zsh"
}
