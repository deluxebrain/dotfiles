" XDG configuration for Vim
" See: https://gist.github.com/dkasak/6ae1c6bf0d771155f23b

" Source near top of vimrc
" but *below* set nocompatible ( which resets viminfo )

set directory=$XDG_CONFIG_HOME/vim/swap,~/,/tmp
set backupdir=$XDG_STATE_HOME/vim/backup,~/,/tmp
set undodir=$XDG_STATE_HOME/vim/undo,~/,/tmp
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
set packpath+=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after
set runtimepath+=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after

let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc"
