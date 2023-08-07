" XDG configuration for Vim
" See: https://gist.github.com/dkasak/6ae1c6bf0d771155f23b

" Source near top of vimrc
" but *below* set nocompatible ( which resets viminfo )

if empty("$XDG_CACHE_HOME")
    let $XDG_CACHE_HOME="$HOME/.cache"
endif

if empty("$XDG_CONFIG_HOME")
    let $XDG_CONFIG_HOME="$HOME/.config"
endif

if empty("$XDG_DATA_HOME")
    let $XDG_DATA_HOME="$HOME/.local/share"
endif

if empty("$XDG_STATE_HOME")
    let $XDG_STATE_HOME="$HOME/.local/state"
endif

set directory=$XDG_CONFIG_HOME/vim/swap,~/,/tmp
set backupdir=$XDG_STATE_HOME/vim/backup,~/,/tmp
set undodir=$XDG_STATE_HOME/vim/undo,~/,/tmp
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
set packpath+=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after
set runtimepath+=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after

let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc"
