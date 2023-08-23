# Custom ZSH aliases

# alias watch to support aliases ( note the trailing _ )
alias watch="watch "

# kubernetes and friends
alias mk="minikube"
alias k="kubectl"
alias i="istioctl"

# thin facade around gh application to deal with authentication
# NOTE this causes a clash with the omz gh plugin
# ( if using gh plugin comment out this alias )
alias gh='gh.wrapper'

# misc
alias lg="lazygit"

# mobile development
alias studio="open -a '/Applications/Android Studio.app'"
