#!/bin/zsh

# github cli helpers

# wrapper around gh to ensure auth token is set before executing commands
function gh.wrapper() {
    if [ -z "$GITHUB_TOKEN" ] ; then
        gh.set_auth_token
    fi
    # the leading "\" calls gh and not the alias
    \gh "$@"
}

# pull gh auth token from keychain and set in GITHUB_TOKEN env var
function gh.set_auth_token() {
    GITHUB_TOKEN=$(\
        security find-generic-password \
            -a "$USER" \
            -s "GITHUB_TOKEN" \
            -w 2>/dev/null ; true)
}

# add github token to keychain
# pulls token from first parameter or prompts for it if missing
function gh.add_token_to_keychain() {
    local token="$1"
    if [ -z "$token" ] ; then
        echo "Enter github cli auth token: "
        read token
    fi
    # use -T "" to prevent security application from being allowed
    # passwordless retrieval of the token
    security add-generic-password \
        -a "$USER" \
        -s "GITHUB_TOKEN" \
        -U \
        -T "" \
        -w "$token"
    GITHUB_TOKEN="$token"
}
