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

# Get the current GitHub token context
# Usage: gh.current
function gh.current() {
    echo "${GH_CURRENT_CONTEXT:-DEFAULT}"
}

# Use a specific GitHub token context
# Usage: gh.use <context>
function gh.use() {
    local context="$1"
    if [ -z "$context" ]; then
        context="DEFAULT"
    fi
    GH_CURRENT_CONTEXT="${context:u}"
    gh.set_auth_token
}

# pull gh auth token from keychain and set in GITHUB_TOKEN env var
function gh.set_auth_token() {
    local context="$(gh.current)"
    # Construct the token name by uppercasing the context
    # This allows for multiple GitHub tokens to be stored and retrieved
    # based on different contexts (e.g., GITHUB_TOKEN_DEFAULT, GITHUB_TOKEN_WORK)
    local token_name="GITHUB_TOKEN_${context:u}"
    GITHUB_TOKEN=$(\
        security find-generic-password \
            -a "$USER" \
            -s "$token_name" \
            -w 2>/dev/null)

    if [ -z "$GITHUB_TOKEN" ]; then
        echo "Enter github cli auth token for context $context: "
        read -s GITHUB_TOKEN
        gh.add_token_to_keychain "$GITHUB_TOKEN" "$token_name"
    fi
}

# add github token to keychain
# pulls token from first parameter or prompts for it if missing
# secret name can be specified as second parameter, defaults to GITHUB_TOKEN
function gh.add_token_to_keychain() {
    local token="$1"
    local token_name="$2"

    if [ -z "$token" ]; then
        echo "Error: Token is required."
        return 1
    fi

    if [ -z "$token_name" ]; then
        echo "Error: Token name is required."
        return 1
    fi
    # use -T "" to prevent security application from being allowed
    # passwordless retrieval of the token
    security add-generic-password \
        -a "$USER" \
        -s "$token_name" \
        -U \
        -T "" \
        -w "$token"
}
