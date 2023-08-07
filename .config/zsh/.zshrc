# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# automatic profile selection does not work correctly with tmux plugin
# hence select dotfiles profile using iterm proprietary escape codes
# this must be done before tmux is started
echo -ne "\033]50;SetProfile=dotfiles\a"

# path
export PATH="$HOME/bin:/usr/local/bin:$PATH"
# add homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"

# xdg path configuration
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# zsh
export HISTFILE="$XDG_STATE_HOME/zsh/history"
# compinit dump files ( used by autocompletion )
export ZSH_COMPDUMP="$XDG_CACHE_HOME/.zcompdump-$HOST"

# oh-my-zsh
export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
export ZSH_CUSTOM="$XDG_CONFIG_HOME/zsh_custom"
export ZSH_THEME="powerlevel10k/powerlevel10k"

# XDG configuration for various apps ( in alphabetical order )
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export GEMRC="$XDG_CONFIG_HOME/gem/gemrc"
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_PATH="$XDG_DATA_HOME/gem"
export GH_CONFIG_DIR="$XDG_CONFIG_HOME/gh"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export VSCODE_EXTENSIONS="$XDG_DATA_HOME/vscode/extensions"

# shell configuration
# disable shell state sessions ( we are using zsh for this )
export SHELL_SESSIONS_DISABLE=1
# share history between terminals
setopt share_history
export HISTSIZE='32768'
export HISTFILESIZE="$HISTSIZE"

# vim configuration
# set as default editor
export EDITOR=vim
# bring in support for XDG
export VIMINIT="source ${XDG_CONFIG_HOME}/vim/vimrc"

# fix up gpg as installed by brew
export GPG_TTY=$(tty)

# used by github cli ( gh ) for authenticating against github
# set dynamically by gh alias ( see aliases.zsh )
export GITHUB_TOKEN

# oh-my-zsh plugins
# sorted in ascending order
plugins=(
    asdf
    aws
    brew
    direnv
    docker
    docker-compose
    dotnet
    gh
    git
    gitignore
    gnu-utils
    helm
    iterm2
    redis-cli
    tmux
    virtualenv
    zsh-autosuggestions
)

# zsh-syntax-highlighting last entry of plugins
plugins+=(
    zsh-syntax-highlighting
)

# plugin configuration
# must be between plugins declaration and starting oh-my-zsh

# tmux plugin configuration
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_CONFIG="${XDG_CONFIG_HOME}/tmux/tmux.conf"
ZSH_TMUX_UNICODE=true
# ZSH_TMUX_ITERM2=true
# ZSH_TMUX_FIXTERM_WITH_256COLOR=true

# enable oh-my-zsh
source "${ZSH}/oh-my-zsh.sh"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
# [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
[[ ! -f "${ZDOTDIR}/.p10k.zsh" ]] || source $ZDOTDIR/.p10k.zsh

# add iterm2 shell integration
test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" \
&& source "${ZDOTDIR}/.iterm2_shell_integration.zsh" || true
