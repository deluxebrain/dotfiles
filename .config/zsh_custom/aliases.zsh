# Custom ZSH aliases

# alias watch to support aliases ( note the trailing _ )
alias watch="watch "

# kubernetes and friends
alias mk="minikube"
alias k="kubectl"
alias i="istioctl"

# thin facade around gh application to deal with authentication
# NOTE the use of single quotes to ensure env vars are dynamically evaluated
alias gh='[ -z "$GITHUB_TOKEN" ] && gh.set_auth_token ; gh'

# misc
alias lg="lazygit"
