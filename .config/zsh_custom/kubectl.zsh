#!/bin/zsh

# kubectl

# enable kubectl completions ...
source <(kubectl completion zsh)

# ... and make them work with the kubectl alias ( k )
complete -F __start_kubectl k
