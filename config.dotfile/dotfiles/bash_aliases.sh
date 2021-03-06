shopt -s expand_aliases

# Navigation
#

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"

# Colour support
#

# Detect which 'ls' flavour is in use
if ls --color > /dev/null 2>&1; then # GNU
    colorflag="--color"
else # MacOS
    colorflag="-G"
fi

# Add colors for filetypes and human-readable sizes by default on 'ls'
alias ls="ls -lhF ${colorflag}"
alias lx="ls -XB"               # Sort by extension
alias lk="ls -Sr"               # Sort by size, asc order
alias lt="ls -tr"               # Sort by date, desc order
alias lc="ls -tcr"              # Sort by change time, desc order
alias lu="ls -tur"              # Sort by access time, desc order

alias grep="grep ${colorflag}"
alias fgrep="fgrep ${colorflag}"
alias egrep="egrep ${colorflag}"

# File system
#

alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias mkdir="mkdir -p"

# Clipboard
#

alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -out"

# Search
#

# Find pattern in files recursively from current directory
alias fif="grep -Rnw . -e"

# Networking
#

# Get external ip address
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

# Run `dig` and display the most useful info
alias digger="dig +nocmd any +multiline +noall +answer"

# List all open ports (.e.g to find what port NodeJS server is listening on)
alias lsp='sudo lsof -i -n -P | grep LISTEN'

# Python
#

# pyi [<distribution>] - install lastest version of distribution
# defaults to CPython
alias pyi="xenv --command=pyenv install"

# List all distributions available
alias pyd="xenv --command=pyenv --all distributions"

# pyv [<distribution>] - list all versions of distribution
# defaults to CPython
alias pyv="xenv --command=pyenv --all versions"

# pyl [<distribution>] - list latest installed version of distribution
# defaults to CPython
alias pyl="xenv --command=pyenv --latest versions"

# pipenv
alias prp="pipenv run python"
alias pei='pipenv install --python `pyenv which python`'

# Ruby
#

# rbi [<distribution>] - install lastest version of distribution
# defaults to CRuby
alias rbi="xenv --command=rbenv install"

# List all distributions available
alias rbd="xenv --command=rbenv --all distributions"

# rbv [<distribution>] - list all versions of distribution
# defaults to CRuby
alias rbv="xenv --command=rbenv --all versions"

# rbl [<distribution>] - list latest installed version of distribution
# defaults to CRuby
alias rbl="xenv --command=rbenv --latest versions"

alias mux="tmuxinator"

# NodeJS
#

# ndi [<distribution>] - install lastest version of distribution
alias ndi="xenv --command=nodenv install"

# List all distributions available
alias ndd="xenv --command=nodenv --all distributions"

# ndv [<distribution>] - list all versions of distribution
alias ndv="xenv --command=nodenv --all versions"

# ndl [<distribution>] - list latest installed version of distribution
alias ndl="xenv --command=nodenv --latest versions"
