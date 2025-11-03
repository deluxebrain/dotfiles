#!/bin/zsh

function gen_secret() {
    local LENGTH=${1:-32}
    local PREFIX=${2:-""}

    # Generate a random alphanumeric string of specified length with an optional prefix
    echo "${PREFIX}$(openssl rand -base64 $((LENGTH * 2)) | tr -dc 'A-Za-z0-9')" | head -c $LENGTH
    echo
}
